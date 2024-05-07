/*
 * Copyright 2024-2024 Hewlett Packard Enterprise Development LP
 * Other additional copyright holders may be indicated within.
 *
 * The entirety of this work is licensed under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 *
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
The Image module provides a way to write arrays of pixels to an output image format.

For example, the following code creates a 3x3 array of pixels and writes it to
a BMP file. The array is then scaled by a factor of 2 (creating a 9x9 image)
and written to a second BMP file.

.. code-block:: chapel

   use Image;

   var arr: [1..3, 1..3] int;

   arr[1, ..] = [0xFF0000, 0x00FF00, 0x0000FF];
   arr[2, ..] = [0x00FF00, 0x0000FF, 0xFF0000];
   arr[3, ..] = [0x0000FF, 0xFF0000, 0x00FF00];

   writeImage("pixels.bmp", imageType.bmp, arr);
   writeImage("pixels2.bmp", imageType.bmp, scale(arr, 2));


*/
@unstable("Image is unstable")
module Image {

  private use IO, Math;


  //
  // Configuration params/types
  // (Override defaults on compiler line using -s<cfg>=<val>)
  //
  @chpldoc.nodoc
  config type pixelType = int;
  @chpldoc.nodoc
  config param bitsPerColor = 8;

  //
  // Define config-dependent types and params.
  //
  @chpldoc.nodoc
  param colorMask = (0x1 << bitsPerColor) - 1;
  @chpldoc.nodoc
  type colorType = uint(bitsPerColor);


  //
  // set helper params for colors
  //
  @chpldoc.nodoc
  param red = 0,        // names for referring to colors
        green = 1,
        blue = 2,
        numColors = 3;

  //
  // Verify that config-specified pixelType is appropriate for storing colors
  //
  if isIntegral(pixelType) {
    if numColors*bitsPerColor > numBits(pixelType) then
      compilerError("pixelType '" + pixelType:string +
                    "' isn't big enough to store " +
                    bitsPerColor:string + " bits per color");
  } else {
    compilerError("pixelType must be an integral type");
  }

  //
  // how far to shift a color component when packing into a pixelType
  //
  private inline proc colorOffset(param color) param {
    return color * bitsPerColor;
  }

  /* Defines what kind of image to output */
  enum imageType {
    /* A BMP image is written from a 2D array of pixels */
    bmp
  }

  /*
    Write an array of pixels as an image

    :arg image: the output filename or an open fileWriter
    :arg format: the image format
    :arg pixels: an array of pixel values
  */
  proc writeImage(image, format: imageType, pixels: [] pixelType) throws {
    // the output file channel
    const outfile = if isSubtype(image.type, fileWriter)
                      then image
                      else open(image, ioMode.cw).writer(locking=true);
    select format {
      when imageType.bmp do writeImageBMP(outfile, pixels);
      otherwise
        halt("Don't know how to write images of type: ", format);
    }
  }

  private proc writeImageBMP(outfile, pixels) do
    compilerError("pixels must be a 2D array of colors");

  private proc writeImageBMP(outfile, pixels: [?d]) throws
    where d.isRectangular() && d.rank == 2 {
    const rows = d.dim(0).size,
          cols = d.dim(1).size,
          headerSize = 14,
          dibHeaderSize = 40,  // always use old BITMAPINFOHEADER
          bitsPerPixel = numColors*bitsPerColor,
          // row size in bytes. Pad each row out to 4 bytes.
          rowQuads = divCeil(bitsPerPixel * cols, 32),
          rowSize = 4 * rowQuads,
          rowSizeBits = 8 * rowSize,
          pixelsSize = rowSize * rows,
          size = headerSize + dibHeaderSize + pixelsSize,
          offsetToPixelData = headerSize + dibHeaderSize;

    // Write the BMP image header
    outfile.writef("BM");
    outfile.writeBinary(size:uint(32), endianness.little);
    outfile.writeBinary(0:uint(16), endianness.little); /* reserved1 */
    outfile.writeBinary(0:uint(16), endianness.little); /* reserved2 */
    outfile.writeBinary(offsetToPixelData:uint(32), endianness.little);

    // Write the DIB header BITMAPINFOHEADER
    outfile.writeBinary(dibHeaderSize:uint(32), endianness.little);
    outfile.writeBinary(cols:int(32), endianness.little);
    outfile.writeBinary(-rows:int(32), endianness.little); /*neg for swap*/
    outfile.writeBinary(1:uint(16), endianness.little); /* 1 color plane */
    outfile.writeBinary(bitsPerPixel:uint(16), endianness.little);
    outfile.writeBinary(0:uint(32), endianness.little); /* no compression */
    outfile.writeBinary(pixelsSize:uint(32), endianness.little);
    outfile.writeBinary(2835:uint(32), endianness.little); /*pixels/meter print resolution=72dpi*/
    outfile.writeBinary(2835:uint(32), endianness.little); /*pixels/meter print resolution=72dpi*/
    outfile.writeBinary(0:uint(32), endianness.little); /* colors in palette */
    outfile.writeBinary(0:uint(32), endianness.little); /* "important" colors */

    for i in d.dim(0) {
      var nbits = 0;
      for j in d.dim(1) {
        var p = pixels[i,j];
        var redv = (p >> colorOffset(red)) & colorMask;
        var greenv = (p >> colorOffset(green)) & colorMask;
        var bluev = (p >> colorOffset(blue)) & colorMask;

        // write 24-bit color value
        outfile.writeBits(bluev, bitsPerColor);
        outfile.writeBits(greenv, bitsPerColor);
        outfile.writeBits(redv, bitsPerColor);
        nbits += numColors * bitsPerColor;
      }
      // write the padding.
      // The padding is only rounding up to 4 bytes so
      // can be written in a single writeBits call.
      outfile.writeBits(0:uint, (rowSizeBits-nbits):int(8));
    }
  }

  /*
    Takes a 2D array of some element type and computes an integer color
    gradient between the newMin/Max. This is a simple interpolation of the
    values in the array to the new range.

    :arg arr: the 2D array of values to sample
    :arg newMin: the new minimum value
    :arg newMax: the new maximum value
    :returns: a new array of pixels with the same domain as ``arr``
  */
  proc downSample(arr: [?d], newMin:int = 0, newMax:int = 0xFFFFFF): [d] int
    where d.isRectangular() && d.rank == 2 {
    var oldMin = min reduce arr,
        oldMax = max reduce arr;

    var outArr: [d] int =
      ((newMax - newMin) * ((arr - oldMin) / (oldMax - oldMin)) + newMin):int;

    return outArr;
  }

  /*
  Linearly interpolates between two colors to create an array of pixels.
  */
  proc interpolateColor(arr: [?d], colorA: pixelType, colorB: pixelType): [d] pixelType {
    const low = min reduce arr;
    const spread = ((max reduce arr) - low):real;

    proc colorComponent(color: pixelType, param offset: int) do
      return (color >> colorOffset(offset)) & colorMask;
    proc linInterp(t:real, l, h) do return (l * (1 - t) + h * t):int;

    var outPixels: [d] pixelType;
    forall (a, outPixel) in zip(arr, outPixels) {

      const t = (a - low):real / spread;
      const redv = linInterp(t,
                             colorComponent(colorA, red),
                             colorComponent(colorB, red)) & colorMask;
      const greenv = linInterp(t,
                               colorComponent(colorA, green),
                               colorComponent(colorB, green)) & colorMask;
      const bluev = linInterp(t,
                              colorComponent(colorA, blue),
                              colorComponent(colorB, blue)) & colorMask;

      outPixel = (redv << colorOffset(red)) |
                 (greenv << colorOffset(green)) |
                 (bluev << colorOffset(blue));
    }

    return outPixels;
  }


  /*
    Scale a 2D array of pixels by a given factor

    :arg arr: the 2D array of pixels
    :arg factor: the factor to scale by
    :returns: a new array of pixels scaled by the factor
  */
  proc scale(arr: [?d], factor: int): []
    where d.isRectangular() && d.rank == 2 {
    var rows = d.dim(0).size,
        cols = d.dim(1).size;

    var outArr: [d.dim(0).lowBound..#rows*factor, d.dim(1).lowBound..#cols*factor] arr.eltType;

    const outArrSpace = {d.dim(0).lowBound..by factor #rows,
                         d.dim(1).lowBound..by factor #cols};
    forall (arrIdx, outArrIdx) in zip(d, outArrSpace) {
      outArr[outArrIdx[0]..#factor, outArrIdx[1]..#factor] = arr[(...arrIdx)];
    }

    return outArr;
  }


  private import Subprocess as sp;
  /*
  Represents a ffmpeg stream that frame data can be written to to produce a mp4.
  */
  record mediaPipe {
    @chpldoc.nodoc
    var imageName: string;
    @chpldoc.nodoc
    var imgType: imageType;
    @chpldoc.nodoc
    var finished = false;
    @chpldoc.nodoc
    var process: sp.subprocess(true);

    proc init(image: string, imgType: imageType, framerate = 30) throws {
      this.imageName = image;
      this.imgType = imgType;
      init this;

      const ffmpegStart = ["ffmpeg", "-y",
                           "-f", "image2pipe",
                           "-r", framerate:string];
      const pixelFmtArgs;
      select imgType {
        when imageType.bmp do
          pixelFmtArgs = ["-pix_fmt", "bgr24", "-c:v", "bmp"];
        otherwise {
          halt("Don't know how to write images of type: ", imgType);
          pixelFmtArgs = [""]; // dummy value for split init
        }
      }
      const ffmpegEnd = ["-i", "-",
                         "-c:v", "libx264",
                         "-crf", "25",
                         "-pix_fmt", "yuv420p",
                         this.imageName];
      const nArgs = ffmpegStart.domain.size + pixelFmtArgs.domain.size + ffmpegEnd.domain.size;
      var args: [0..#nArgs] string;
      args[0..#ffmpegStart.domain.size] = ffmpegStart;
      args[ffmpegStart.domain.size..#pixelFmtArgs.domain.size] = pixelFmtArgs;
      args[(ffmpegStart.domain.size + pixelFmtArgs.domain.size)..#ffmpegEnd.size] = ffmpegEnd;

      this.process = sp.spawn(args, stdin=sp.pipeStyle.pipe);
    }
    proc ref deinit() {
      try! finish();
    }

    /*
    Write a frame into the media pipe.
    */
    proc writeFrame(pixelData: [] pixelType) throws {
      writeImage(process.stdin, imageType.bmp, pixelData);
      process.stdin.flush();
    }
    proc ref finish() throws {
      if !finished {
        process.wait();
        finished = true;
      }
    }
  }

}
