const std = @import("std");
const ArrayList = std.ArrayList;
const test_allocator = std.testing.allocator;

// Input data structure
pub const City = struct {
    endpoints: usize,
    roads: ArrayList([2]usize),
};

// Equivalent to C++ or Rust using
const Input = ArrayList(City);

// Read input from stdin and convert to our data structure
pub fn readInput(allocator: std.mem.Allocator) !Input {
    const stdin = std.io.getStdIn().reader();
    var buf = std.io.bufferedReader(stdin);
    var reader = buf.reader();

    // Read number of cities
    var line_buf: [1024 * 1024]u8 = undefined;
    const first_line = try reader.readUntilDelimiter(&line_buf, '\n');
    const n = try std.fmt.parseInt(usize, first_line, 10);

    var cities = ArrayList(City).init(allocator);
    errdefer cities.deinit();

    // Read each city
    var i: usize = 0;
    while (i < n) : (i += 1) {
        // Read number of endpoints
        const m_line = try reader.readUntilDelimiter(&line_buf, '\n');
        const m = try std.fmt.parseInt(usize, m_line, 10);

        // Read number of roads
        const r_line = try reader.readUntilDelimiter(&line_buf, '\n');
        const r = try std.fmt.parseInt(usize, r_line, 10);

        var roads = ArrayList([2]usize).init(allocator);
        errdefer roads.deinit();

        // Read each road
        var j: usize = 0;
        while (j < r) : (j += 1) {
            const road_line = try reader.readUntilDelimiter(&line_buf, '\n');
            var road_it = std.mem.splitAny(u8, road_line, " ");
            const start = try std.fmt.parseInt(usize, road_it.next() orelse return error.InvalidInput, 10);
            const end = try std.fmt.parseInt(usize, road_it.next() orelse return error.InvalidInput, 10);
            try roads.append(.{ start, end });
        }

        try cities.append(.{
            .endpoints = m,
            .roads = roads,
        });
    }

    return cities;
}

// Solve function that takes a single city and returns the minimum number of roads needed
pub fn solve(city: City) usize {
    // TODO: Remove this debug print before submission
    std.debug.print("Processing city with {d} endpoints and {d} roads\n", .{ city.endpoints, city.roads.items.len });
    for (city.roads.items) |road| {
        std.debug.print("Road: {d} -> {d}\n", .{ road[0], road[1] });
    }

    // TODO: Implement actual solution
    return 0; // Dummy return value
}

pub fn main() !void {
    // Create an arena allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Read input
    var input = try readInput(allocator);
    defer {
        for (input.items) |city| {
            city.roads.deinit();
        }
        input.deinit();
    }

    // Process each city and print results
    const stdout = std.io.getStdOut().writer();
    for (input.items) |city| {
        const result = solve(city);
        try stdout.print("{d}\n", .{result});
    }
}

// Tests
test "sample input 1" {
    // Create test data
    var roads1 = ArrayList([2]usize).init(test_allocator);
    try roads1.append(.{ 0, 1 });
    try roads1.append(.{ 1, 2 });
    try roads1.append(.{ 3, 4 });
    defer roads1.deinit();

    const city1 = City{
        .endpoints = 5,
        .roads = roads1,
    };

    var roads2 = ArrayList([2]usize).init(test_allocator);
    try roads2.append(.{ 0, 1 });
    defer roads2.deinit();

    const city2 = City{
        .endpoints = 2,
        .roads = roads2,
    };

    // Test each city
    try std.testing.expectEqual(@as(usize, 1), solve(city1));
    try std.testing.expectEqual(@as(usize, 0), solve(city2));
}
