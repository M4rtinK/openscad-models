include <../BOSL2/std.scad>
include <../BOSL2/screws.scad>

$fn = 100;

mk = 4;

text = str("S22U charger mk", mk);

// charging coil
charging_coil_depth = 2.5;
charging_coil_diameter = 50;
coil_wire_cutout_width = 3;
coil_wire_cutout_notch_width = 13.17;

// s22 ultra sizes
s22u_thickness = 16;
s22u_width = 89.6;
s22u_height = 177;
s22u_case_side_thickness = 5.86;
s22u_case_bottom_thickness = 7.1;

// holder
holder_width = 110;
holder_thickness = 30;
holder_bottom_screw_hole_offset = 7;

module simple_coil_holder() {
    // A module holding the charging coild.
    //
    // The coil backing material can be quite fragile,
    // so it seems best to provide it with a backing material
    // and install it as a mdoule into the charger.
    
    diff()
    cuboid([55, 55, 8]) {
        // charging coil cutout
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        cylinder(d=charging_coil_diameter, charging_coil_depth);
        // central charging coil aretation pin
        tag("keep")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        cylinder(h=charging_coil_depth, d=5.4);
        // wire cutouts
        // cutout 1
        tag("remove")
        align(RIGHT)
        back(coil_wire_cutout_notch_width/2 + coil_wire_cutout_width/2)
        attach(TOP, TOP,inside=true,shiftout=0.01)
        cuboid([10, 3, charging_coil_depth]);
        // cutout 2
        tag("remove")
        align(RIGHT)
        fwd(coil_wire_cutout_notch_width/2 + coil_wire_cutout_width/2)
        attach(TOP, TOP,inside=true,shiftout=0.01)
        cuboid([10, 3, charging_coil_depth]);
        // model description
        tag("remove")
        down(4)
        yflip()
        text3d(text, h=3, size=4, anchor=CENTER);
    }
}

module vertical_s22u_holder() {
    // S22 Ultra vertical holder
    //
    // It is espected for the phone to be inserted from the top with cameras up,
    // but it seems to work also with cameras down.
    
    holder_mk = 4;
    holder_text = str("S22U holder mk", holder_mk);
    
    holder_inside_width = s22u_width + 0.9;
    holder_height = 124.3;    
    coil_module_width = 54.5 + 1;
    coil_module_height = 54.5 + 0.5;
    bottom_depth = 10;
    side_thickness = (holder_width - (holder_inside_width)) / 2;

    // coil module allignment
    base_width = 60;
    base_height = 60;
    base_left_offset = 10.31;
    base_bottom_offset = 49.4;
    left_offset = base_left_offset + ((base_width - coil_module_width) / 2) + s22u_case_side_thickness;
    echo("width");
    echo(left_offset);
    bottom_offset = base_bottom_offset + ((base_height - coil_module_height) / 2) + s22u_case_bottom_thickness;
    echo("bottom");
    echo(bottom_offset);

    diff()
    cuboid([holder_thickness, holder_width, holder_height]) {
        // make space for the phone
        tag("remove")
        attach(BOTTOM, BOTTOM, inside=true, shiftout=0.01)
        up(bottom_depth) color("lightblue")
        cuboid([s22u_thickness+1, holder_inside_width, holder_height], rounding=2);
        // create a cutout for the charging coil module
        tag("remove")
        align(FWD) back(coil_module_width/2)
        attach(BOTTOM, BOTTOM, inside=true, shiftout=0.01)
        up(bottom_depth + 52.125) right((s22u_thickness+1)/2 + 20/2 + 1 - 5)
        back(side_thickness + left_offset)
        color("green") cuboid([20, coil_module_width, coil_module_height], rounding=0);
        // cooling cutout - front
        tag("remove")
        position(LEFT) down(20-30)
        cuboid([30, holder_inside_width-15, 50+60], rounding=1);
        // cooling cutout - back bottom
        tag("remove")
        position(RIGHT) down(30)
        cuboid([30, holder_inside_width-30, 30], rounding=1);
        // add nut traps for integration with other parts
        tag("remove")
        position(FRONT+BOTTOM) back(holder_bottom_screw_hole_offset)
        color("red") m4_nut_trap(0);
        tag("remove")
        position(BACK+BOTTOM) fwd(holder_bottom_screw_hole_offset)
        color("red") m4_nut_trap(0);
        // temporary PCB holders
        tag("remove")
        position(BACK) back(8) up(25) right(5)
        color("white") yrot(90) rect_tube(size=30, wall=1.8, rounding=5, h=5.2);
        tag("remove")
        position(BACK) back(8) up(25) left(10)
        color("white") yrot(90) rect_tube(size=30, wall=1.8, rounding=5, h=5.2);
        tag("remove")
        position(RIGHT) down(55)
        zrot(90) xrot(90)
        text3d(holder_text, h=3, size=6.5, anchor=CENTER);
    }
}

module m4_nut_trap(rotate=0) {
    zrot(rotate) screw_hole("M3", length=20, anchor=BOTTOM)
        up(3.5) position(BOT) nut_trap_side(20, "M3", poke_len=20);
}

module base_plate() {

    base_plate_mk = 2;
    base_plate_text = str("base plate mk", base_plate_mk);

    diff()
    cuboid([130, 70, 10], anchor=BOTTOM, rounding=5, edges = "Z") {
        // holder cutout
        tag("remove")
        up(4)
        cuboid([holder_width+1, holder_thickness+1, 7]);
        // screw holes
        tag("remove")
        up(1.75) left((holder_width/2)-holder_bottom_screw_hole_offset)
        screw_hole("M3", length=10, orient=DOWN, head="socket", counterbore=3.5);
        // screw holes
        tag("remove")
        //attach(BOTTOM, BOTTOM, inside=true, shiftout=0.01)
        up(1.75) right((holder_width/2)-holder_bottom_screw_hole_offset)
        screw_hole("M3", length=10, orient=DOWN, head="socket", counterbore=3.5);
        tag("remove")
        //position(LEFT) up(30)
        zflip() xflip()
        up(4) fwd(3)
        text3d(base_plate_text, h=3, size=6.5, anchor=CENTER);
    }
}

vertical_s22u_holder();
//base_plate();