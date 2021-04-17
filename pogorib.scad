MM_PER_IN = 25.4;
RESOLUTION = 0.01; // 0.01 mm slices (too small to matter)
PRINT_TOLERANCE = 0.15; // mm

RIB_WIDTH = MM_PER_IN / 4; // 1/4" in mm
RM2_LENGTH = 246; // mm
RM2_THICKNESS = 4.7 + PRINT_TOLERANCE; // mm
RM2_CURVE_RAD = 4.25; // mm

module genCurveShape(
    radius = RM2_CURVE_RAD,
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
    radius = RM2_CURVE_RAD,
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

difference(){
  hull(){
    genCurveShape();

    translate([0, RM2_LENGTH, 0])
    genCurveShape();

    translate([RIB_WIDTH - RESOLUTION / 2, 0, 0])
    cube(size=[RESOLUTION, RESOLUTION, RM2_THICKNESS], center = true);

    translate([RIB_WIDTH - RESOLUTION / 2, RM2_LENGTH, 0])
    cube(size=[RESOLUTION, RESOLUTION, RM2_THICKNESS], center = true);
  }

  translate([RIB_WIDTH, 0, 0])
  hull(){
    genCurveShape();

    translate([0, RM2_LENGTH, 0])
    genCurveShape();
  }
}


