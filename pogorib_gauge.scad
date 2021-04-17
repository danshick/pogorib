/************************************************
*
* This file is a hacky test of various radiuses
* to see what matches the rM2's curved profile
*
************************************************/


use <pogorib.scad>;

difference() {
  translate([-3, 0,0])
  cube([7, 6 * 10, 2], center=true);

  translate([0, -5 * 5, 0])
  for(i = [0:9]){
    rad = 4 + (0.1 * i);
    translate([-6, (i * 5.5) - .85,])
    linear_extrude(height = 1)
    text(str(floor(rad), ".", (rad - floor(rad)) * 10), 2);

    translate([0, i * 5.5, 0])
    rotate([90,0,0])
    union(){
      genCurveShape(radius = rad, thickness = 2);
      translate([2.5, 0, 0])
      cube(size = [5, 2, 4.85], center = true);
    }
  }
}
