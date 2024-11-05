const std = @import("std");
const expect = std.testing.expect;
const print = std.debug.print;
const ArrayList = std.ArrayList;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak!");
    }

    const input = try readInput(allocator);
    defer input.deinit();

    var writer = std.io.getStdOut().writer();

    // Process each group and print results
    for (input.groups.items) |group| {
        const result = solve(group);
        try writer.print("{d}\n", .{result});
    }
}

// Structure to hold a single group of gnomes
const GnomeGroup = struct {
    size: usize,
    gnomes: []u32,

    pub fn deinit(self: *const GnomeGroup, allocator: std.mem.Allocator) void {
        allocator.free(self.gnomes);
    }
};

// Structure to hold all input data
const Input = struct {
    n: usize,
    groups: ArrayList(GnomeGroup),
    allocator: std.mem.Allocator,

    pub fn deinit(self: *const Input) void {
        for (self.groups.items) |group| {
            group.deinit(self.allocator);
        }
        self.groups.deinit();
    }
};

fn readInput(allocator: std.mem.Allocator) !Input {
    var buffer: [1024]u8 = undefined;
    const reader = std.io.getStdIn().reader();

    // Read number of groups
    var line = try reader.readUntilDelimiter(&buffer, '\n');
    const n = try std.fmt.parseInt(usize, line, 10);

    // Initialize groups array
    var groups = ArrayList(GnomeGroup).init(allocator);

    // Read each group
    var i: usize = 0;
    while (i < n) : (i += 1) {
        line = try reader.readUntilDelimiter(&buffer, '\n');
        var it = std.mem.tokenize(u8, line, " ");

        // Read group size
        const size = try std.fmt.parseInt(usize, it.next().?, 10);

        // Read gnome IDs
        var gnomes = try allocator.alloc(u32, size);
        var j: usize = 0;
        while (j < size) : (j += 1) {
            gnomes[j] = try std.fmt.parseInt(u32, it.next().?, 10);
        }

        try groups.append(GnomeGroup{
            .size = size,
            .gnomes = gnomes,
        });
    }

    return Input{
        .n = n,
        .groups = groups,
        .allocator = allocator,
    };
}

fn solve(group: GnomeGroup) usize {
    // TODO: Remember to remove this debug print before submission
    print("Processing group with {d} gnomes: ", .{group.size});
    for (group.gnomes) |gnome| {
        print("{d} ", .{gnome});
    }
    print("\n", .{});

    // TODO: Implement actual solution
    // For now, return dummy value
    return 1;
}

test "sample test case 1" {
    const allocator = std.testing.allocator;

    // First group: 7 1 2 3 4 8 5 6
    var gnomes1 = [_]u32{ 1, 2, 3, 4, 8, 5, 6 };
    const group1 = GnomeGroup{
        .size = 7,
        .gnomes = try allocator.dupe(u32, &gnomes1),
    };
    defer group1.deinit(allocator);
    try expect(solve(group1) == 5);

    // Second group: 5 3 4 5 2 6
    var gnomes2 = [_]u32{ 3, 4, 5, 2, 6 };
    const group2 = GnomeGroup{
        .size = 5,
        .gnomes = try allocator.dupe(u32, &gnomes2),
    };
    defer group2.deinit(allocator);
    try expect(solve(group2) == 4);

    // Third group: 4 10 20 11 12
    var gnomes3 = [_]u32{ 10, 20, 11, 12 };
    const group3 = GnomeGroup{
        .size = 4,
        .gnomes = try allocator.dupe(u32, &gnomes3),
    };
    defer group3.deinit(allocator);
    try expect(solve(group3) == 2);
}
