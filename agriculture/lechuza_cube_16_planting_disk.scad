include <../BOSL2/std.scad>
include <../BOSL2/walls.scad>

// planting disk for Lechuza Cube 16 self watering pot

$fn = 100;

mk = 3;

diff()
hex_panel(circle(d=130), 1.8, 4, h = 3, frame = 25, shift) {
    cyl(d=20, h=3);
    tag("remove") color("red")
    cuboid([7.5,2.7,60], chamfer=0.1);
    tag("remove") color("blue")
    cuboid([3.5,9,60], chamfer=0.8);
    /*tag("remove") color("red")
    tube(h=20, od=160, id=25);*/
}



