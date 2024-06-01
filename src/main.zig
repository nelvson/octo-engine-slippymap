const std = @import("std");

pub fn get_tiles(lat: f64, long: f64, zoom: u5) struct { x_tile: i32, y_tile: i32 } {
    const n: f64 = @floatFromInt(@as(i32, 1) << zoom);
    const x_tile: i32 = @intFromFloat(std.math.floor(n * (long + 180.0) / 360.0));

    const lat_rad = std.math.degreesToRadians((lat));
    const y_tile: i32 = @intFromFloat(std.math.floor(n *
        (1.0 - std.math.log(f64, std.math.tan(lat_rad) + (1.0 / std.math.cos(lat_rad)), 10) / std.math.pi) / 2.0));
    return .{ .x_tile = x_tile, .y_tile = y_tile };
}

pub fn main() !void {
    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    //    <trkpt lat="-6.2432460" lon="106.6315630">

    const lat: f64 = -6.2432460;
    const lon: f64 = 106.6315630;
    // get_tiles is not fully working (yet). returned values are wrong
    const tiles = get_tiles(
        lat,
        lon,
        18,
    );
    std.debug.print("{d}--{d}", .{ tiles.x_tile, tiles.y_tile });
}