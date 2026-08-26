include <../BOSL2/std.scad>
include <../BOSL2/walls.scad>

// A fixture for drying a tea sieve on top of a small plastic ikea bowl.

$fn = 100;

mk = 1;

diff()
hex_panel([140, 140, 70], strut=0.8, spacing=12) {
    tag("remove") color("green")
    tube(h=200, od=200, id=130);

    tag("remove") color("red")
    down(40)
    tube(h=20, od=122, id=90);

    tag("remove") color("green")
    up(70)
    sphere(d=120);

    tag("remove") color("blue")
    down(65) left(80) back(0)
    sphere(d=150);
    //%cuboid([60, 200, 40], rounding=9);
};



