const std = @import("std");
const expect = std.testing.expect;

// Represents the game board
const Board = struct {
    grid: [7][7]u8,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const board = try readInput(allocator);
    const result = solve(board);

    // Print the result
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

// Reads the input and returns a Board struct
fn readInput(allocator: std.mem.Allocator) !Board {
    const stdin = std.io.getStdIn().reader();
    var buf_reader = std.io.bufferedReader(stdin);
    var reader = buf_reader.reader();

    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();

    var board: Board = undefined;

    // Read 7 lines
    var row: usize = 0;
    while (row < 7) : (row += 1) {
        try reader.readUntilDelimiterArrayList(&buf, '\n', 1024);

        // Copy the line into the board grid
        var col: usize = 0;
        while (col < 7) : (col += 1) {
            if (col < buf.items.len) {
                board.grid[row][col] = buf.items[col];
            } else {
                board.grid[row][col] = ' ';
            }
        }

        buf.clearRetainingCapacity();
    }

    return board;
}

// Solves the peg game puzzle
fn solve(board: Board) u32 {
    // DEBUG: Print the input board
    std.debug.print("Input board:\n", .{});
    for (board.grid) |row| {
        for (row) |cell| {
            std.debug.print("{c}", .{cell});
        }
        std.debug.print("\n", .{});
    }

    // TODO: Implement the actual solution
    return 0;
}

// Tests
test "sample test case 1" {
    const input = Board{
        .grid = .{
            .{ ' ', ' ', ' ', 'o', 'o', 'o', ' ' },
            .{ ' ', ' ', ' ', 'o', 'o', 'o', ' ' },
            .{ 'o', 'o', 'o', 'o', 'o', 'o', 'o' },
            .{ 'o', 'o', 'o', '.', 'o', 'o', 'o' },
            .{ 'o', 'o', 'o', 'o', 'o', 'o', 'o' },
            .{ ' ', ' ', ' ', 'o', 'o', 'o', ' ' },
            .{ ' ', ' ', ' ', 'o', 'o', 'o', ' ' },
        },
    };
    try expect(solve(input) == 4);
}

test "sample test case 2" {
    const input = Board{
        .grid = .{
            .{ ' ', ' ', ' ', 'o', 'o', 'o', ' ' },
            .{ ' ', ' ', ' ', 'o', 'o', 'o', ' ' },
            .{ '.', '.', 'o', 'o', 'o', '.', '.' },
            .{ 'o', 'o', '.', '.', '.', 'o', 'o' },
            .{ '.', '.', 'o', 'o', 'o', '.', '.' },
            .{ ' ', ' ', ' ', 'o', 'o', 'o', ' ' },
            .{ ' ', ' ', ' ', 'o', 'o', 'o', ' ' },
        },
    };
    try expect(solve(input) == 12);
}
