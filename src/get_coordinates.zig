const std = @import("std");
const parse_float = std.fmt.parseFloat;
const print = std.debug.print;
const cwd = std.fs.cwd();

pub const LatLon = struct {
    lat: f64,
    lon: f64,
};

pub export fn get_coordinates(list: *std.ArrayList(LatLon)) void {
    const allocator = std.heap.page_allocator;
    // Open the file
    const file_result = cwd.openFile("./lat-lon.txt", .{});

    if (file_result) |file| {
        // Get the file size
        const file_size = file.getEndPos() catch {
            std.debug.print("Error getting file size\n", .{});
            return;
        };

        // Allocate a buffer to read the file into
        const buffer: []u8 = allocator.alloc(u8, file_size) catch {
            std.debug.print("Error allocating buffer\n", .{});
            return;
        };
        defer allocator.free(buffer);

        //Read the file into the buffer
        const read_result = file.readAll(buffer);
        if (read_result) |bytes_read| {
            var split = std.mem.splitAny(u8, buffer[0..bytes_read], "\n");

            while (split.next()) |line| {
                var split_comma = std.mem.splitAny(u8, line, ",");

                const lat = parse_float(f32, split_comma.first()) catch 0.0;

                const lon = parse_float(f32, split_comma.next() orelse "0.0") catch 0.0;

                const struct_lat_lon = LatLon{
                    .lat = lat,
                    .lon = lon,
                };

                if (list.append(struct_lat_lon)) |err| {
                    std.debug.print("Error appending item1: {}\n", .{err});
                    return;
                } else {}

                //               std.debug.print("{any}, {any}\n", .{ lat, lon });
            }

            //const lat = split.first();
            //const lon = split.next();

            //std.debug.print("{any}, {any}", .{ lat, lon });

            //           try lat_lon.append(.{ .lat = lat, .lon = lon });

            //           std.debug.print("File contents:\n{any}\n", .{split.buffer});
            //std.debug.print("File contents:\n{any}\n", .{bytes_read});
        } else |err| {
            std.debug.print("Error reading file: {}\n", .{err});
            return;
        }

        // Close the file
        //if (file.close()) |err| {
        //    std.debug.print("Error closing file: {}\n", .{err});
        //}
    } else |err| {
        std.debug.print("Error opening file: {}\n", .{err});
    }
}
