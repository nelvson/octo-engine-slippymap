const std = @import("std");
const a = @import("./get_coordinates.zig");

const print = std.debug.print;
const math = std.math;
const PI = math.pi;

pub fn get_tiles(lat: f64, long: f64, zoom: u5) struct { x_tile: i32, y_tile: i32 } {
    const n: f64 = @floatFromInt(@as(i32, 1) << zoom);
    const x_tile: i32 = @intFromFloat(math.floor(n * (long + 180.0) / 360.0));

    const lat_rad: f64 = math.degreesToRadians((lat));
    const log = @log((math.tan(lat_rad) + (1.0 / math.cos(lat_rad))));

    const y_tile: i32 = @intFromFloat(math.floor(n *
        (1.0 - log / PI) / 2.0));
    return .{ .x_tile = x_tile, .y_tile = y_tile };
}

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const lat_lon_alloc = gpa.allocator();

    var lat_lon = std.ArrayList(a.LatLon).init(lat_lon_alloc);
    defer lat_lon.deinit();

    a.get_coordinates(&lat_lon);
    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    //    <trkpt lat="-6.2432460" lon="106.6315630">

    const lat: f64 = -6.2498060;
    const lon: f64 = 106.6258030;
    // get_tiles is not fully working (yet). returned values are wrong
    const tiles = get_tiles(
        lat,
        lon,
        18,
    );
    print("{d}--{d}", .{ tiles.x_tile, tiles.y_tile });
}
