const std = @import("std");

const ProblemInput = struct {
    n: i32,
    a: i32,
    enemy_ships: []i32,

    pub fn deinit(self: *ProblemInput, allocator: std.mem.Allocator) void {
        allocator.free(self.enemy_ships);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try readInput(allocator);
    defer input.deinit(allocator);

    const solution = solve(&input);
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{solution});
}

fn readInput(allocator: std.mem.Allocator) !ProblemInput {
    const stdin = std.io.getStdIn().reader();
    var buf: [1024]u8 = undefined;

    // Read first line with n and a
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var iter = std.mem.split(u8, line, " ");
        const n = try std.fmt.parseInt(i32, iter.next() orelse return error.InvalidInput, 10);
        const a = try std.fmt.parseInt(i32, iter.next() orelse return error.InvalidInput, 10);

        // Read second line with enemy ships
        if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |second_line| {
            var enemy_ships = std.ArrayList(i32).init(allocator);
            defer enemy_ships.deinit();

            var numbers = std.mem.split(u8, second_line, " ");
            while (numbers.next()) |num_str| {
                const num = try std.fmt.parseInt(i32, num_str, 10);
                try enemy_ships.append(num);
            }

            return ProblemInput{
                .n = n,
                .a = a,
                .enemy_ships = try enemy_ships.toOwnedSlice(),
            };
        }
    }
    return error.InvalidInput;
}

fn solve(input: *const ProblemInput) i32 {
    // TODO: Remember to remove this debug print before submission
    std.debug.print("Debug - Input received: n={d}, a={d}, enemy_ships={any}\n", .{
        input.n,
        input.a,
        input.enemy_ships,
    });

    // TODO: Implement actual solution here

    // TODO: This is a dummy return value - replace with actual solution
    return 0;
}

test "sample test case 1" {
    const allocator = std.testing.allocator;

    var enemy_ships = try allocator.alloc(i32, 3);
    defer allocator.free(enemy_ships);
    enemy_ships[0] = 1;
    enemy_ships[1] = 2;
    enemy_ships[2] = 3;

    const input = ProblemInput{
        .n = 3,
        .a = 6,
        .enemy_ships = enemy_ships,
    };

    try std.testing.expectEqual(@as(i32, 2), solve(&input));
}

test "sample test case 2" {
    const allocator = std.testing.allocator;

    var enemy_ships = try allocator.alloc(i32, 5);
    defer allocator.free(enemy_ships);
    enemy_ships[0] = 7;
    enemy_ships[1] = 0;
    enemy_ships[2] = 3;
    enemy_ships[3] = 5;
    enemy_ships[4] = 2;

    const input = ProblemInput{
        .n = 5,
        .a = 8,
        .enemy_ships = enemy_ships,
    };

    try std.testing.expectEqual(@as(i32, 3), solve(&input));
}
