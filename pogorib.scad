MM_PER_IN = 25.4;
RESOLUTION = 0.01; // 0.01 mm slices (too small to matter)
PRINT_TOLERANCE = 0.15; // mm

RIB_WIDTH = MM_PER_IN / 2; // 1/2" in mm
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
    #circle(r=radius, $fn = 128, center = true);
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


pogoPinL = 13.25;
pogoPinH = 2.78;
pogoPinW = RIB_WIDTH;
pinsH = 1.6;
pinsStickout = 1.5;
bridgeCompensation = .2;
module Pogo8212200510001101Slot(){
    translate([pinsStickout,0,((pogoPinH+bridgeCompensation)/2)-pinsH/2])
    cube([pogoPinW,pogoPinL,pinsH]);
    cube([pogoPinW,pogoPinL,pogoPinH+bridgeCompensation]);
}

magnetL = 13.5;
magnetD = 3.22;
magnetTol = .2;
$fs = RESOLUTION;
module magnetHole(){
    rotate([0,90,0])
    translate([.25,0,-magnetL+RIB_WIDTH-.725]) // -.7** makes them not go all the way through
    #cylinder(d=magnetD+magnetTol, h=magnetL);
}

INTERMAGNET_DIST = 16.3 / 3;
module magnetHoles(bottomLoc){
    // translation of bottom one (closest to USB-C cable)
    translate([0,bottomLoc + (INTERMAGNET_DIST * 0),0])
    magnetHole();
    translate([0,bottomLoc + (INTERMAGNET_DIST * 1),0])
    magnetHole();
    translate([0,bottomLoc + (INTERMAGNET_DIST * 2),0])
    magnetHole();
    translate([0,bottomLoc + (INTERMAGNET_DIST * 3),0])
    magnetHole();
}

echo(str("Rib width in mm: ", RIB_WIDTH));

difference(){
  hull(){
    #genCurveShape();

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
  
  PINNY_STICKOUTY = .4;
  distanceFromUSBside = 12.3;
  translate([-pogoPinW-pinsStickout+PINNY_STICKOUTY+RIB_WIDTH,distanceFromUSBside,-pogoPinH/2])
  Pogo8212200510001101Slot();

  magnetHoles(34.43);
  magnetHoles(RM2_LENGTH-16.47-INTERMAGNET_DIST);

  // TESTING PIECES
  // Cut in half
  translate([-10,60,-10])
  cube([30,530,30]);
}

// add stops
translate([30/2,-RIB_WIDTH/2,0])
cube([30,RIB_WIDTH,RM2_THICKNESS], center = true);

//translate([30/2,(-RIB_WIDTH/2)+RM2_LENGTH+RIB_WIDTH,0])
//cube([30,RIB_WIDTH,RM2_THICKNESS], center = true);

