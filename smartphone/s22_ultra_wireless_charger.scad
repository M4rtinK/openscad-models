include <../BOSL2/std.scad>

$fn = 100;

mk = 2;

text = str("s22uc mk", mk);

// charging coil
charging_coil_depth = 2.5;
charging_coil_diameter = 50;
coil_wire_cutout_width = 3;
coil_wire_cutout_notch_width = 13.17;

// s22 ultra sizes
s22u_thickness = 16;
s22u_width = 89.6;
s22u_height = 177;

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
    holder_width = 100;
    holder_height = 124.3;
    holder_thickness = 30;
    diff()
    cuboid([holder_thickness, holder_width, holder_height]) {
        // make space for the phone
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        up(10) color("lightblue") cuboid([s22u_thickness+1, s22u_width + 0.9, holder_height], rounding=2);
        // create a cutout for the charging coil module
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        up(59.4) right((s22u_thickness+1)/2 + 20/2 + 1) back(4.69)
        color("green") cuboid([20, 60.5, 60.5], rounding=0);
    }
}


vertical_s22u_holder();