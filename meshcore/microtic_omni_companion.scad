include <../BOSL2/std.scad>
include <../BOSL2/screws.scad>

$fn = 100;

// Lets attach a tiny Wio companion to
// the big Microtik 868 MHz omni antenna!


/// size of the Microtin omni antenna mounting plate
omni_plate_width = 68;
omni_plate_height = 50;
// there is a central aretation goorve (?) in the plate
omni_plate_groove_width = 19.2 - 0.2;
omni_plate_groove_depth = 1.6 - 0.1;
// there are M5 mounting holes in the plate
mounting_hole_side_offset = 2.7;

// box holding the Wio electronics
wio_box_outer_width = 25+1;
wio_box_outer_height = 25+1;
wio_box_outer_depth = 20;
// inner space
wio_box_inner_width = 17.4+0.6;
wio_box_inner_height = 21.4+0.1;
wio_box_inner_depth = 10;
// bottom pins
wio_bottom_pin_length = 5;
wio_bottom_pin_clerance_with = 3;
// antenna pigtail cutout
pigtail_cutout_depth = wio_box_inner_depth - 2;
pigtail_cutout_width = 5;
pigtail_cutout_offset_left = 3;
// USB-C custout
usb_c_cutout_width = 9;
usb_c_cutout_depth = 2;
usb_c_cutout_length = 6;

module m5_hole() {
    screw_hole("M5", length=20, head="socket",counterbore=5, anchor=TOP);
}

module main_holder() {
    // main holder for everything
    mk = 6;
    text = str("wio holder mk", mk);
    diff()
    cuboid([omni_plate_width, omni_plate_height, 5], rounding=7, edges=["Z"]) {
        // central aretation ridge

        attach(TOP, TOP)
        cuboid([omni_plate_groove_width, omni_plate_height, omni_plate_groove_depth]);

        // pigtail protector plate
        attach(TOP, TOP)  color("green") fwd(45) down(5)
        cuboid(
            [omni_plate_groove_width*2, 40, 15],
            rounding=0,
            except_edges = [TOP+BACK, BACK+LEFT, BACK+RIGHT]
        );
        // pigtail cutout
        tag("remove")
        attach(TOP, TOP, inside=true,shiftout=0.01) fwd(65) down(15)
        cuboid([4, 45, 30], rounding=2);

        // holes for screws/zipties
        tag("remove")
        position(BOTTOM+LEFT) right(2.76+mounting_hole_side_offset) back(0) up(12)
        color("red") m5_hole();
        tag("remove")
        position(BOTTOM+RIGHT) left(2.76+mounting_hole_side_offset) back(0) up(12)
        color("red") m5_hole();
        // wio box cutout
        tag("remove")
        attach(BOTTOM, BOTTOM, inside=true,shiftout=0.01)
        cuboid([wio_box_outer_width+0.3, wio_box_outer_height+0.3, 3]);
        // add versioning text
        tag("remove")
        up(5) left(2)
        zrot(270) xrot() color("white")
        text3d(text, h=3, size=4.5, anchor=CENTER);
    }

}

module wio_holder() {
    // the tiny box holding the Wio board stacked with the MCU board
    mk = 3;
    text = str("mk", mk);
    diff()
    cuboid([wio_box_outer_width, wio_box_outer_height, wio_box_outer_depth]) {
        // make space for the Wio boards
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        cuboid([wio_box_inner_width, wio_box_inner_height, wio_box_inner_depth]);
        // wio has some some pins on the bottom we need to accomodate
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        left(wio_box_inner_width/2 - wio_bottom_pin_clerance_with/2) up(wio_box_inner_depth)
        cuboid([wio_bottom_pin_clerance_with, wio_box_inner_height, wio_bottom_pin_length]);
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        right(wio_box_inner_width/2 - wio_bottom_pin_clerance_with/2) up(wio_box_inner_depth)
        cuboid([wio_bottom_pin_clerance_with, wio_box_inner_height, wio_bottom_pin_length]);
        // antena pigtail custout
        tag("remove")
        attach(TOP, TOP,inside=true,shiftout=0.01)
        right(wio_box_inner_width/2 - pigtail_cutout_width/2 - pigtail_cutout_offset_left) up() back(10)
        cuboid([pigtail_cutout_width, 20, pigtail_cutout_depth]);
        // add a hole in the middle so we can poke the boards out if needed
        tag("remove")
        position(BOTTOM+TOP) up(12)
        color("red") m5_hole();
        // add versioning text
        tag("remove")
        down(4) left(12)
        zrot(270) xrot(90) color("white")
        text3d(text, h=3, size=8, anchor=CENTER);
    }
}

module top_clamp() {
    // top clamp attached to the other side of the main holder to keep thr Wio and its box in place
    mk = 3;
    text = str("tc mk", mk);
    cutout_depth = 4;
    diff()
    cuboid([omni_plate_width, omni_plate_height/2.8, 7.5], rounding=7, edges=["Z"]) {
        // holes for screws/zipties
        tag("remove")
        position(BOTTOM+LEFT) right(2.76+mounting_hole_side_offset) back(0) up(14)
        color("red") m5_hole();
        tag("remove")
        position(BOTTOM+RIGHT) left(2.76+mounting_hole_side_offset) back(0) up(14)
        color("red") m5_hole();
        // wio top cutout
        tag("remove")
        attach(TOP, TOP, inside=true,shiftout=0.01)
        cuboid([wio_box_inner_width, wio_box_inner_height, cutout_depth]);
        // USB-C cutout
        tag("remove")
        attach(TOP, TOP, inside=true,shiftout=0.01) fwd(usb_c_cutout_length/2-wio_box_inner_height/2)
        back(3/2)
        cuboid([usb_c_cutout_width, usb_c_cutout_length+3, cutout_depth+usb_c_cutout_depth]);
        // add versioning text
        tag("remove")
        up(3) left(16)
        zrot(90) color("white")
        text3d(text, h=3, size=5.5, anchor=CENTER);

    }
}


//m5_hole();
//main_holder();
//wio_holder();
//top_clamp();
