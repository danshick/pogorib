MM_PER_IN = 25.4;
RESOLUTION = 0.01; // 0.01 mm slices (too small to matter)
PRINT_TOLERANCE = 0.15; // mm

RM2_LENGTH = 246; // mm
RM2_THICKNESS = 4.7 + PRINT_TOLERANCE; // mm
RM2_PROFILE_RAD = 4.25; // mm
RM2_CORNER_RAD = 3; // mm
RIB_WIDTH = (MM_PER_IN / 2) + RM2_CORNER_RAD; // 1/2" in mm


module genCurveShape(
    radius = RM2_PROFILE_RAD,
    height = RM2_THICKNESS,
    thickness = RESOLUTION,
  ) {

  width = radius - sqrt(pow(radius, 2) - pow((height / 2), 2));

  rotate([90,0,0])
  // "center" the part 3-dimensionally
  translate([radius - (width), 0, -thickness / 2])
  linear_extrude(thickness)
  intersection() {
    circle(r=radius, $fn = 128, center = true);
    translate([-radius + width / 2, 0, 0])
      square(size = [width, height], center = true);
  }
}

// Not currently used
module genInverseCurveShape(
    radius = RM2_PROFILE_RAD,
    height = RM2_THICKNESS
  ) {

  width = radius - sqrt(pow(radius, 2) - pow((height / 2), 2));

  difference(){
    cube(size = [width, RESOLUTION, RM2_THICKNESS], center = true);
    translate([width/2, 0, 0])
    genCurveShape(radius, height);
  }
}

echo(str("Rib width in mm: ", RIB_WIDTH));

module profileCylinder(radius = 1, steps=32) {
  hull() {
    for (i = [0:360/steps:360])
      translate([  radius * cos(i), radius * sin(i), 0 ]) rotate(i) children(0);
  }
}

module ribShape() {
  hull(){
    // Left side bottom profile
    translate([0, RM2_CORNER_RAD, 0])
    genCurveShape();

    // Bottom rounded corner profile
    translate([3, 3, 0])
    profileCylinder(
      radius = RM2_CORNER_RAD,
      steps = 64
    ){
      rotate(180)
      genCurveShape();
    }

    // Bottom far right profile
    translate([RIB_WIDTH, 0, 0])
    rotate([0, 0, 90])
    genCurveShape();

    // Left side top profile
    translate([0, RM2_LENGTH - RM2_CORNER_RAD, 0])
    genCurveShape();

    // Top rounded corner profile
    translate([3, RM2_LENGTH - 3, 0])
    profileCylinder(
      radius = RM2_CORNER_RAD,
      steps = 64
    ){
      rotate(180)
      genCurveShape();
    }

    // Top far right profile
    translate([RIB_WIDTH, RM2_LENGTH, 0])
    rotate([0, 0, -90])
    genCurveShape();
  }
}

difference() {
  ribShape();
  translate([RIB_WIDTH - RM2_CORNER_RAD, 0, 0])
  ribShape();

translate([6,-0.8,-1.5])
  rotate([90,0,0])
  difference() {
    hull(){
      import("./usb4125-hull.stl", convexity=1);
    }
    translate([0,-1.,-4])
    cube([10, 2, 8], center = true);
  }
}
