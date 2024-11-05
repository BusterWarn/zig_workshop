const std = @import("std");

pub const InputData = struct {
    n: u32,
    coordinates: []Coordinate,

    pub fn deinit(self: *InputData, allocator: std.mem.Allocator) void {
        allocator.free(self.coordinates);
    }
};

pub const Coordinate = struct {
    x: i32,
    y: i32,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try readInput(allocator);
    defer input.deinit(allocator);

    const result = try solve(input);

    // Print with 6 decimal places
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d:.6}\n", .{result});
}

pub fn readInput(allocator: std.mem.Allocator) !InputData {
    var buffer: [1024]u8 = undefined;
    const stdin = std.io.getStdIn().reader();

    // Read N
    const n_line = try stdin.readUntilDelimiter(&buffer, '\n');
    const n = try std.fmt.parseInt(u32, n_line, 10);

    // Read coordinates
    var coordinates = try allocator.alloc(Coordinate, n);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        const line = try stdin.readUntilDelimiter(&buffer, '\n');
        var iter = std.mem.splitAny(u8, line, " ");
        const x = try std.fmt.parseInt(i32, iter.next().?, 10);
        const y = try std.fmt.parseInt(i32, iter.next().?, 10);
        coordinates[i] = Coordinate{ .x = x, .y = y };
    }

    return InputData{
        .n = n,
        .coordinates = coordinates,
    };
}

pub fn solve(input: InputData) !f64 {
    // TODO: Remove this debug print before submission
    std.debug.print("Input data: n={}, coordinates=", .{input.n});
    for (input.coordinates) |coord| {
        std.debug.print("({},{}), ", .{ coord.x, coord.y });
    }
    std.debug.print("\n", .{});

    // TODO: Implement actual solution
    return 0.0;
}

// Tests
test "sample test case 1" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const test_coordinates = [_]Coordinate{
        .{ .x = 1, .y = 1 },
        .{ .x = 2, .y = 2 },
        .{ .x = 3, .y = 3 },
    };
    const coordinates = try allocator.alloc(Coordinate, test_coordinates.len);
    @memcpy(coordinates, &test_coordinates);

    const input = InputData{
        .n = 3,
        .coordinates = coordinates,
    };
    const result = try solve(input);
    try std.testing.expectApproxEqAbs(@as(f64, 0.000000), result, 0.000001);
}

test "sample test case 2" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const test_coordinates = [_]Coordinate{
        .{ .x = 0, .y = 1 },
        .{ .x = 1, .y = 0 },
        .{ .x = 1, .y = 1 },
    };
    const coordinates = try allocator.alloc(Coordinate, test_coordinates.len);
    @memcpy(coordinates, &test_coordinates);

    const input = InputData{
        .n = 3,
        .coordinates = coordinates,
    };
    const result = try solve(input);
    try std.testing.expectApproxEqAbs(@as(f64, 0.000000), result, 0.000001);
}

test "sample test case 3" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const test_coordinates = [_]Coordinate{
        .{ .x = 0, .y = 2 },
        .{ .x = 1, .y = 1 },
        .{ .x = 1, .y = 0 },
    };
    const coordinates = try allocator.alloc(Coordinate, test_coordinates.len);
    @memcpy(coordinates, &test_coordinates);

    const input = InputData{
        .n = 3,
        .coordinates = coordinates,
    };
    const result = try solve(input);
    try std.testing.expectApproxEqAbs(@as(f64, 0.333333), result, 0.000001);
}
