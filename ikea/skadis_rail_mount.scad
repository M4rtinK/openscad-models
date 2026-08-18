include <../BOSL2/std.scad>
include <../BOSL2/screws.scad>

$fn = 100;

holder_width = 100;
holder_height = 80;
holder_thickness = 12;
rail_width_fit_factor = 0.5;
rail_width = 55.3 + rail_width_fit_factor;
rail_thickness = 8;
rail_hole_diameter = 14.4;
rail_hole_offset_right = 5.7;
rail_hole_spacing = 35.13;
hole_offset = 11;
wall_screw_diameter = 4;

module m4_nut_trap(rotate=90) {
    zrot(rotate) screw_hole("M4", length=20, anchor=BOTTOM)
        up(3.5) position(BOT) nut_trap_side(100, "M4", poke_len=0);
}

module m4_hole() {
    zflip() screw_hole("M4", length=20, head="socket",counterbore=5, anchor=TOP);
}

module rail_holder_back() {
    // A module holding the rail from the back.
    //
    // It has a hole in the back for the screw that mounts the holder to the wall.
    mk = 5;
    text = str("rail holder back mk", mk);

    diff()
    cuboid([holder_width, holder_height, holder_thickness]) {
        // charging coil cutout
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        cuboid([rail_width, holder_height+2, rail_thickness/2]);
        // mounting hole & lower area around it
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        cuboid([wall_screw_diameter,12,20], rounding=1);
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        cuboid([20,35,rail_thickness/2 + 2], rounding=2, edges="Z");
        // add nut traps for integration with the other half
        // left
        tag("remove")
        position(FRONT+BOTTOM+LEFT) right(hole_offset) back(10)
        color("red") m4_nut_trap(180);
        tag("remove")
        position(BACK+BOTTOM+LEFT) right(hole_offset) fwd(holder_height/2)
        color("red") m4_nut_trap(180);
        tag("remove")
        position(BACK+BOTTOM+LEFT) right(hole_offset) fwd(10)
        color("red") m4_nut_trap(180);
        // right
        tag("remove")
        position(FRONT+BOTTOM+RIGHT) left(hole_offset) back(10)
        color("red") m4_nut_trap(0);
        tag("remove")
        position(BACK+BOTTOM+RIGHT) left(hole_offset) fwd(holder_height/2)
        color("red") m4_nut_trap(0);
        tag("remove")
        position(BACK+BOTTOM+RIGHT) left(hole_offset) fwd(10)
        color("red") m4_nut_trap(0);
        // add versioning text
        tag("remove")
        up(3) left(15)
        zrot(90) color("white")
        text3d(text, h=3, size=5.5, anchor=CENTER);
    }
    // aretation cylinder, using existing holes in the metal rail
    right(rail_hole_diameter/2 + rail_width/2 - rail_hole_diameter - rail_hole_offset_right - rail_width_fit_factor/2)
    back(rail_hole_spacing/2 + rail_hole_diameter/2)
    cylinder(d=rail_hole_diameter, 8);
    right(rail_hole_diameter/2 + rail_width/2 - rail_hole_diameter - rail_hole_offset_right - rail_width_fit_factor/2)
    fwd(rail_hole_spacing/2 + rail_hole_diameter/2)
    cylinder(d=rail_hole_diameter, 8);
}

module rail_holder_front() {
    // A module holding the rail from the front.
    //
    // Mounts to the back holder from the front.

    mk = 4;
    text = str("rail holder front mk", mk);

    diff()
    cuboid([holder_width, holder_height, holder_thickness]) {
        // charging coil cutout
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        cuboid([rail_width, holder_height+2, rail_thickness/2.2]);
        // add screw holes for integration with the other half
        // left
        tag("remove")
        position(FRONT+BOTTOM+LEFT) right(hole_offset) back(10)
        color("red") m4_hole();
        tag("remove")
        position(BACK+BOTTOM+LEFT) right(hole_offset) fwd(holder_height/2)
        color("red") m4_hole();
        tag("remove")
        position(BACK+BOTTOM+LEFT) right(hole_offset) fwd(10)
        color("red") m4_hole();
        // right
        tag("remove")
        position(FRONT+BOTTOM+RIGHT) left(hole_offset) back(10)
        color("red") m4_hole();
        tag("remove")
        position(BACK+BOTTOM+RIGHT) left(hole_offset) fwd(holder_height/2)
        color("red") m4_hole();
        tag("remove")
        position(BACK+BOTTOM+RIGHT) left(hole_offset) fwd(10)
        color("red") m4_hole();
        // add nut traps for integrating with skadis
        tag("remove")
        position(FRONT+BOTTOM) down(1) right(0) back(20)
        color("red") m4_nut_trap(270);
        tag("remove")
        position(BACK+BOTTOM) down(1) right(0) fwd(20)
        color("red") m4_nut_trap(90);
        // add versioning text
        tag("remove")
        up(3) left(15)
        zrot(90) color("white")
        text3d(text, h=3, size=5.5, anchor=CENTER);
    }
}

module rail_holder_front_short(step_height=1) {
    // A module holding the rail from the front - short version.
    //
    // Used for fit checks with the rail.

    mk = 1;
    text = str(step_height, " mm");

    diff()
    cuboid([holder_width, 10, holder_thickness]) {
        // charging coil cutout
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        cuboid([rail_width, holder_height+2, rail_thickness/2.2]);       
        // add versioning text
        tag("remove")
        up(3) left(6) fwd(2.5)
        zrot(0) color("white")
        text3d(text, h=3, size=6.5, anchor=CENTER);
        tag("keep")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        color("magenta")
        up(rail_thickness/2.2 - step_height) left(rail_width/2-5)
        cuboid([10, 10, step_height]);
    }    
}

module skadis_stabilizer() {
    // Stabilize the skadis board on the edges
    //
    // The board is connected to the wall only in the middle
    // via the rail, so wee need to brace it against the wall
    // near the edges via these stabilizers.
    // As things might be sometimes slightly eneven, we need
    // a multi part stabilizer to age a good fit.
    
    mk = 1;
    text = str("mk", mk);

    stabilizer_diameter = 25;
    stabilizer_hole_diameter = 20;
    stabilizer_hole_depth = 5;
    stabilizer_height = 20;
    diff()
    cylinder(d=stabilizer_diameter, stabilizer_height) {
        // hole for variable legth piece
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        cylinder(d=stabilizer_hole_diameter, stabilizer_hole_depth);
        // mounting hole
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        color("red") zrot(rotate) screw_hole("M4", length=25, anchor=BOTTOM)
        up(14.5) position(BOT) nut_trap_side(100, "M4", poke_len=15);
        // revision
        tag("remove")
        up(6) fwd(3)
        zrot(180) color("white")
        text3d(text, h=3, size=5.5, anchor=CENTER);
    }
}

module skadis_stabilizer_cylinder(stabilizer_cylinder_height=9) {
    // Skadis stabilizer module
    //
    // These modules can be combined to get a good fit.
    
    mk = 1;
    text = str("mk", mk);
    depth_text = str(stabilizer_cylinder_height, " mm");
    stabilizer_hole_diameter = 20;
    diff()
    cylinder(d=stabilizer_hole_diameter-0.3, stabilizer_cylinder_height) {
        // central M4 scre hole
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01) up(20)
        color("red") m4_hole();
        // revision
        tag("remove")
        up(stabilizer_cylinder_height/2 + 0.5) fwd(3)
        zrot(180) color("white")
        text3d(text, h=3, size=5, anchor=CENTER);
        // depth
        tag("remove")
        up(stabilizer_cylinder_height/2 + 0.5) back(6)
        zrot(180) color("white")
        text3d(depth_text, h=3, size=4, anchor=CENTER);
    }
}

//fwd(100) rail_holder_back();
//rail_holder_back();
fwd() rail_holder_front_short(0.6);
fwd(15) rail_holder_front_short(0.8);
fwd(30) rail_holder_front_short(1);
fwd(45) rail_holder_front_short(1.2);
fwd(60) rail_holder_front_short(1.4);
fwd(75) rail_holder_front_short(1.6);
fwd(90) rail_holder_front_short(1.8);
//fwd(50) skadis_stabilizer();
//fwd(25) skadis_stabilizer_cylinder();
//fwd(0) skadis_stabilizer_cylinder(5);




