class D { var x = 1; }
class C: D { var y = 2; }
operator **(d:borrowed D,i:int) do return d.x..i;

write("C(): ");
writeln(borrowed C():string);
write("new C(): ");
writeln((new owned C()).borrow());
write("new C():D: ");
writeln((new owned C()).borrow():borrowed D);
write("new C():D**2: ");
writeln((new owned C()).borrow():borrowed D**2);
write("+ reduce new C():D**2: ");
writeln(+ reduce (new owned C()).borrow():borrowed D**2);
write("~ + reduce new C():D**2: ");
writeln(~ + reduce (new owned C()).borrow():borrowed D**2);
write("~ + reduce new C():D**2 * 4: ");
writeln(~ + reduce (new owned C()).borrow():borrowed D**2 * 4);
write("- ~ + reduce new C():D**2 * 4: ");
writeln(- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4);
write("- ~ + reduce new C():D**2 * 4 + 5: ");
writeln(- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4 + 5);
write("- ~ + reduce new C():D**2 * 4 + 5 << 2: ");
writeln(- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4 + 5 << 2);
write("- ~ + reduce new C():D**2 * 4 + 5 << 2 <= 85: ");
writeln(- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4 + 5 << 2 <= 85);
write("- ~ + reduce new C():D**2 * 4 + 5 << 2 <= 85 == false: ");
writeln(- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4 + 5 << 2 <= 85 == false);
write("- ~ + reduce new C():D**2 * 4 + 5 << 2 <= 85 == false | true: ");
writeln(- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4 + 5 << 2 <= 85 == false | true);
write("- ~ + reduce new C():D**2 * 4 + 5 << 2 <= 85 == false | true && false: ");
writeln(- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4 + 5 << 2 <= 85 == false | true && false);
write("- ~ + reduce new C():D**2 * 4 + 5 << 2 <= 85 == false | true && false || true: ");
writeln(- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4 + 5 << 2 <= 85 == false | true && false || true);
write("(- ~ + reduce new C():D**2 * 4 + 5 << 2 <= 85 == false | true && false || true) .. 5: ");
writeln((- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4 + 5 << 2 <= 85 == false | true && false || true) .. 5);
write("(- ~ + reduce new C():D**2 * 4 + 5 << 2 <= 85 == false | true && false || true) .. 5 by 2: ");
writeln((- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4 + 5 << 2 <= 85 == false | true && false || true) .. 5 by 2);
write("for i in (- ~ + reduce new C():D**2 * 4 + 5 << 2 <= 85 == false | true && false || true) .. 5 by 2 do i: ");
writeln(for i in (- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4 + 5 << 2 <= 85 == false | true && false || true) .. 5 by 2 do i);
write("for i in (- ~ + reduce new C():D**2 * 4 + 5 << 2 <= 85 == false | true && false || true) .. 5 by 2 do i, 0: ");
writeln(for i in (- ~ + reduce (new owned C()).borrow():borrowed D**2 * 4 + 5 << 2 <= 85 == false | true && false || true) .. 5 by 2 do i, 0);
