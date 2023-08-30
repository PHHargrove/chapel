/***************************************************************
This code was generated by  Spiral 5.0 beta, www.spiral.net --
Copyright (c) 2005, Carnegie Mellon University
All rights reserved.
The code is distributed under a BSD style license
(see http://www.opensource.org/licenses/bsd-license.php)

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
  notice, reference to Spiral, this list of conditions and the
  following disclaimer.
  * Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the following
  disclaimer in the documentation and/or other materials provided
  with the distribution.
  * Neither the name of Carnegie Mellon University nor the name of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
*AS IS* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
******************************************************************/

use omega;

proc init_fft32() {

}

proc fft32(ref Y: [] complex, X: [] complex) {
  var a5817, a5818, a5819, a5820, a5821, a5822, a5823, a5824, a5825, a5826, a5827, a5828, a5829, s2287, s2288, s2289, s2290, s2291, s2292, s2293, s2294, s2295, s2296, s2297, s2298, s2299, s2300, s2301, s2302, s2303, s2304, s2305, s2306, s2307, s2308, s2309, s2310, s2311, s2312, s2313, s2314, s2315, s2316, s2317, s2318, t5990, t5991, t5992, t5993, t5994, t5995, t5996, t5997, t5998, t5999, t6000, t6001, t6002, t6003, t6004, t6005, t6006, t6007, t6008, t6009, t6010, t6011, t6012, t6013, t6014, t6015, t6016, t6017, t6018, t6019, t6020, t6021, t6022, t6023, t6024, t6025, t6026, t6027, t6028, t6029, t6030, t6031, t6032, t6033, t6034, t6035, t6036, t6037, t6038, t6039, t6040, t6041, t6042, t6043, t6044, t6045, t6046, t6047, t6048, t6049, t6050, t6051, t6052, t6053, t6054, t6055, t6056, t6057, t6058, t6059, t6060, t6061, t6062, t6063, t6064, t6065, t6066, t6067, t6068, t6069, t6070, t6071, t6072:complex;
  t5990 = (X(0) + X(16));
  t5991 = (X(0) - X(16));
  t5992 = (X(8) + X(24));
  t5993 = (t5990 + t5992);
  t5994 = (t5990 - t5992);
  a5817 = (1.0i*(X(8) - X(24)));
  t5995 = (t5991 + a5817);
  t5996 = (t5991 - a5817);
  t5997 = (X(4) + X(20));
  s2287 = ((0.70710678118654757 + 1.0i * 0.70710678118654757)*(X(4) - X(20)));
  t5998 = (X(12) + X(28));
  s2288 = ((-0.70710678118654757 + 1.0i * 0.70710678118654757)*(X(12) - X(28)));
  t5999 = (t5997 + t5998);
  s2289 = (1.0i*(t5997 - t5998));
  t6000 = (s2287 + s2288);
  s2290 = (1.0i*(s2287 - s2288));
  t6001 = (t5993 + t5999);
  t6002 = (t5993 - t5999);
  t6003 = (t5995 + t6000);
  t6004 = (t5995 - t6000);
  t6005 = (t5994 + s2289);
  t6006 = (t5994 - s2289);
  t6007 = (t5996 + s2290);
  t6008 = (t5996 - s2290);
  t6009 = (X(1) + X(17));
  t6010 = (X(1) - X(17));
  t6011 = (X(9) + X(25));
  t6012 = (t6009 + t6011);
  t6013 = (t6009 - t6011);
  a5818 = (1.0i*(X(9) - X(25)));
  t6014 = (t6010 + a5818);
  t6015 = (t6010 - a5818);
  t6016 = (X(5) + X(21));
  s2291 = ((0.70710678118654757 + 1.0i * 0.70710678118654757)*(X(5) - X(21)));
  t6017 = (X(13) + X(29));
  s2292 = ((-0.70710678118654757 + 1.0i * 0.70710678118654757)*(X(13) - X(29)));
  t6018 = (t6016 + t6017);
  s2293 = (1.0i*(t6016 - t6017));
  t6019 = (s2291 + s2292);
  s2294 = (1.0i*(s2291 - s2292));
  t6020 = (t6012 + t6018);
  s2295 = ((0.70710678118654757 + 1.0i * 0.70710678118654757)*(t6012 - t6018));
  s2296 = ((0.98078528040323043 + 1.0i * 0.19509032201612825)*(t6014 + t6019));
  s2297 = ((0.55557023301960218 + 1.0i * 0.83146961230254524)*(t6014 - t6019));
  s2298 = ((0.92387953251128674 + 1.0i * 0.38268343236508978)*(t6013 + s2293));
  s2299 = ((0.38268343236508978 + 1.0i * 0.92387953251128674)*(t6013 - s2293));
  s2300 = ((0.83146961230254524 + 1.0i * 0.55557023301960218)*(t6015 + s2294));
  s2301 = ((0.19509032201612825 + 1.0i * 0.98078528040323043)*(t6015 - s2294));
  t6021 = (X(2) + X(18));
  t6022 = (X(2) - X(18));
  t6023 = (X(10) + X(26));
  t6024 = (t6021 + t6023);
  s2302 = ((0.70710678118654757 + 1.0i * 0.70710678118654757)*(t6021 - t6023));
  a5819 = (1.0i*(X(10) - X(26)));
  s2303 = ((0.92387953251128674 + 1.0i * 0.38268343236508978)*(t6022 + a5819));
  s2304 = ((0.38268343236508978 + 1.0i * 0.92387953251128674)*(t6022 - a5819));
  t6025 = (X(6) + X(22));
  t6026 = (X(6) - X(22));
  t6027 = (X(14) + X(30));
  t6028 = (t6025 + t6027);
  s2305 = ((-0.70710678118654757 + 1.0i * 0.70710678118654757)*(t6025 - t6027));
  a5820 = (1.0i*(X(14) - X(30)));
  s2306 = ((0.38268343236508978 + 1.0i * 0.92387953251128674)*(t6026 + a5820));
  s2307 = ((-0.92387953251128674 - 1.0i * 0.38268343236508978)*(t6026 - a5820));
  t6029 = (t6024 + t6028);
  t6030 = ((1.0i*t6024) + ((- 1.0i)*t6028));
  t6031 = (s2303 + s2306);
  t6032 = ((1.0i*s2303) + ((- 1.0i)*s2306));
  t6033 = (s2302 + s2305);
  t6034 = ((1.0i*s2302) + ((- 1.0i)*s2305));
  t6035 = (s2304 + s2307);
  t6036 = ((1.0i*s2304) + ((- 1.0i)*s2307));
  t6037 = (X(3) + X(19));
  t6038 = (X(3) - X(19));
  t6039 = (X(11) + X(27));
  t6040 = (t6037 + t6039);
  t6041 = (t6037 - t6039);
  a5821 = (1.0i*(X(11) - X(27)));
  t6042 = (t6038 + a5821);
  t6043 = (t6038 - a5821);
  t6044 = (X(7) + X(23));
  s2308 = ((0.70710678118654757 + 1.0i * 0.70710678118654757)*(X(7) - X(23)));
  t6045 = (X(15) + X(31));
  s2309 = ((-0.70710678118654757 + 1.0i * 0.70710678118654757)*(X(15) - X(31)));
  t6046 = (t6044 + t6045);
  s2310 = (1.0i*(t6044 - t6045));
  t6047 = (s2308 + s2309);
  s2311 = (1.0i*(s2308 - s2309));
  t6048 = (t6040 + t6046);
  s2312 = ((-0.70710678118654757 + 1.0i * 0.70710678118654757)*(t6040 - t6046));
  s2313 = ((0.83146961230254524 + 1.0i * 0.55557023301960218)*(t6042 + t6047));
  s2314 = ((-0.98078528040323043 + 1.0i * 0.19509032201612825)*(t6042 - t6047));
  s2315 = ((0.38268343236508978 + 1.0i * 0.92387953251128674)*(t6041 + s2310));
  s2316 = ((-0.92387953251128674 - 1.0i * 0.38268343236508978)*(t6041 - s2310));
  s2317 = ((-0.19509032201612825 + 1.0i * 0.98078528040323043)*(t6043 + s2311));
  s2318 = ((-0.55557023301960218 - 1.0i * 0.83146961230254524)*(t6043 - s2311));
  t6049 = (t6001 + t6029);
  t6050 = (t6001 - t6029);
  t6051 = (t6020 + t6048);
  Y(0) = (t6049 + t6051);
  Y(16) = (t6049 - t6051);
  a5822 = (1.0i*(t6020 - t6048));
  Y(8) = (t6050 + a5822);
  Y(24) = (t6050 - a5822);
  t6052 = (t6003 + t6031);
  t6053 = (t6003 - t6031);
  t6054 = (s2296 + s2313);
  Y(1) = (t6052 + t6054);
  Y(17) = (t6052 - t6054);
  a5823 = (1.0i*(s2296 - s2313));
  Y(9) = (t6053 + a5823);
  Y(25) = (t6053 - a5823);
  t6055 = (t6005 + t6033);
  t6056 = (t6005 - t6033);
  t6057 = (s2298 + s2315);
  Y(2) = (t6055 + t6057);
  Y(18) = (t6055 - t6057);
  a5824 = (1.0i*(s2298 - s2315));
  Y(10) = (t6056 + a5824);
  Y(26) = (t6056 - a5824);
  t6058 = (t6007 + t6035);
  t6059 = (t6007 - t6035);
  t6060 = (s2300 + s2317);
  Y(3) = (t6058 + t6060);
  Y(19) = (t6058 - t6060);
  a5825 = (1.0i*(s2300 - s2317));
  Y(11) = (t6059 + a5825);
  Y(27) = (t6059 - a5825);
  t6061 = (t6002 + t6030);
  t6062 = (t6002 - t6030);
  t6063 = (s2295 + s2312);
  Y(4) = (t6061 + t6063);
  Y(20) = (t6061 - t6063);
  a5826 = (1.0i*(s2295 - s2312));
  Y(12) = (t6062 + a5826);
  Y(28) = (t6062 - a5826);
  t6064 = (t6004 + t6032);
  t6065 = (t6004 - t6032);
  t6066 = (s2297 + s2314);
  Y(5) = (t6064 + t6066);
  Y(21) = (t6064 - t6066);
  a5827 = (1.0i*(s2297 - s2314));
  Y(13) = (t6065 + a5827);
  Y(29) = (t6065 - a5827);
  t6067 = (t6006 + t6034);
  t6068 = (t6006 - t6034);
  t6069 = (s2299 + s2316);
  Y(6) = (t6067 + t6069);
  Y(22) = (t6067 - t6069);
  a5828 = (1.0i*(s2299 - s2316));
  Y(14) = (t6068 + a5828);
  Y(30) = (t6068 - a5828);
  t6070 = (t6008 + t6036);
  t6071 = (t6008 - t6036);
  t6072 = (s2301 + s2318);
  Y(7) = (t6070 + t6072);
  Y(23) = (t6070 - t6072);
  a5829 = (1.0i*(s2301 - s2318));
  Y(15) = (t6071 + a5829);
  Y(31) = (t6071 - a5829);

}
