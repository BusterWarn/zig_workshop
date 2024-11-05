const std = @import("std");

// Input type to hold the parsed data
const Input = struct {
    n: u32,
    grid: [][]u8,

    pub fn deinit(self: Input, allocator: std.mem.Allocator) void {
        for (self.grid) |row| {
            allocator.free(row);
        }
        allocator.free(self.grid);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input = try readInput(allocator);
    defer input.deinit(allocator);

    const result = try solve(input);

    // Print final result
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

pub fn readInput(allocator: std.mem.Allocator) !Input {
    const stdin = std.io.getStdIn().reader();
    var buf_reader = std.io.bufferedReader(stdin);
    var reader = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    // Read n
    const line = try reader.readUntilDelimiter(&buf, '\n');
    const n = try std.fmt.parseInt(u32, line, 10);

    // Read grid
    var grid = try allocator.alloc([]u8, n);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        const row = try reader.readUntilDelimiter(&buf, '\n');
        grid[i] = try allocator.dupe(u8, row);
    }

    return Input{
        .n = n,
        .grid = grid,
    };
}

pub fn solve(input: Input) !u32 {
    // Debug print of input
    std.debug.print("Input n: {d}\n", .{input.n});
    std.debug.print("Grid:\n", .{});
    for (input.grid) |row| {
        std.debug.print("{s}\n", .{row});
    }

    // TODO: Implement actual solution
    return 0;
}

test "sample test 1" {
    const allocator = std.testing.allocator;

    // Prepare test input
    var grid = try allocator.alloc([]u8, 4);
    grid[0] = try allocator.dupe(u8, "WBBW");
    grid[1] = try allocator.dupe(u8, "WBWB");
    grid[2] = try allocator.dupe(u8, "BWWB");
    grid[3] = try allocator.dupe(u8, "BWBW");

    const input = Input{
        .n = 4,
        .grid = grid,
    };
    defer input.deinit(allocator);

    // Expected output is 1
    try std.testing.expectEqual(@as(u32, 1), try solve(input));
}

test "sample test 2" {
    const allocator = std.testing.allocator;

    var grid = try allocator.alloc([]u8, 4);
    grid[0] = try allocator.dupe(u8, "BWWB");
    grid[1] = try allocator.dupe(u8, "BWBB");
    grid[2] = try allocator.dupe(u8, "WBBW");
    grid[3] = try allocator.dupe(u8, "WBWW");

    const input = Input{
        .n = 4,
        .grid = grid,
    };
    defer input.deinit(allocator);

    // Expected output is 0
    try std.testing.expectEqual(@as(u32, 0), try solve(input));
}

test "sample test 3" {
    const allocator = std.testing.allocator;

    var grid = try allocator.alloc([]u8, 6);
    grid[0] = try allocator.dupe(u8, "BWBWWB");
    grid[1] = try allocator.dupe(u8, "WBWBWB");
    grid[2] = try allocator.dupe(u8, "WBBWBW");
    grid[3] = try allocator.dupe(u8, "BBWBWW");
    grid[4] = try allocator.dupe(u8, "BWWBBW");
    grid[5] = try allocator.dupe(u8, "WWBWBB");

    const input = Input{
        .n = 6,
        .grid = grid,
    };
    defer input.deinit(allocator);

    // Expected output is 0
    try std.testing.expectEqual(@as(u32, 0), try solve(input));
}

test "sample test 4" {
    const allocator = std.testing.allocator;

    var grid = try allocator.alloc([]u8, 6);
    grid[0] = try allocator.dupe(u8, "WWBBWB");
    grid[1] = try allocator.dupe(u8, "BBWWBW");
    grid[2] = try allocator.dupe(u8, "WBWBWB");
    grid[3] = try allocator.dupe(u8, "BWBWBW");
    grid[4] = try allocator.dupe(u8, "BBWBWW");
    grid[5] = try allocator.dupe(u8, "WBWWBB");

    const input = Input{
        .n = 6,
        .grid = grid,
    };
    defer input.deinit(allocator);

    // Expected output is 1
    try std.testing.expectEqual(@as(u32, 1), try solve(input));
}
