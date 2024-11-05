const std = @import("std");
const testing = std.testing;
const ArrayList = std.ArrayList;

pub const Animal = struct {
    name: []const u8,
    sound: []const u8,
};

pub const TestCase = struct {
    recording: []const u8,
    known_animals: []Animal,

    pub fn deinit(self: *TestCase, allocator: std.mem.Allocator) void {
        allocator.free(self.recording);
        for (self.known_animals) |animal| {
            allocator.free(animal.name);
            allocator.free(animal.sound);
        }
        allocator.free(self.known_animals);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var line_buf = ArrayList(u8).init(allocator);
    defer line_buf.deinit();

    const stdin = std.io.getStdIn().reader();

    // Read number of test cases
    try stdin.readUntilDelimiterArrayList(&line_buf, '\n', 1024);
    const num_cases = try std.fmt.parseInt(usize, line_buf.items, 10);

    var i: usize = 0;
    while (i < num_cases) : (i += 1) {
        line_buf.clearRetainingCapacity();

        // Read recording
        try stdin.readUntilDelimiterArrayList(&line_buf, '\n', 1024);
        var test_case = TestCase{
            .recording = try allocator.dupe(u8, line_buf.items),
            .known_animals = &[_]Animal{},
        };
        defer test_case.deinit(allocator);

        // Read animal sounds until "what does the fox say?"
        var animals = ArrayList(Animal).init(allocator);
        defer animals.deinit();

        while (true) {
            line_buf.clearRetainingCapacity();
            try stdin.readUntilDelimiterArrayList(&line_buf, '\n', 1024);

            if (std.mem.eql(u8, line_buf.items, "what does the fox say?")) break;

            var iter = std.mem.splitSequence(u8, line_buf.items, " goes ");
            const name = iter.next() orelse continue;
            const sound = iter.next() orelse continue;

            try animals.append(Animal{
                .name = try allocator.dupe(u8, name),
                .sound = try allocator.dupe(u8, sound),
            });
        }

        test_case.known_animals = try animals.toOwnedSlice();

        // Process the test case
        const result = try solve(test_case);
        try std.io.getStdOut().writer().print("{s}\n", .{result});
    }
}

pub fn solve(test_case: TestCase) ![]const u8 {
    // TODO: Remember to remove this debug print before submission
    std.debug.print("Recording: {s}\n", .{test_case.recording});
    for (test_case.known_animals) |animal| {
        std.debug.print("Animal {s} goes {s}\n", .{ animal.name, animal.sound });
    }

    // TODO: Hmm, we need an allocator to generate a string. Add it to the input.
    // Example:
    // try std.mem.concat(allocator, u8, &[_][]const u8{ "first", " ", "second" });

    // TODO: Implement actual solution
    // For now, return dummy output
    return "wa pa pa pa pa pa pow";
}

test "sample test case 1" {
    const allocator = testing.allocator;

    var test_case = TestCase{
        .recording = try allocator.dupe(u8, "toot woof wa ow ow ow pa blub blub"),
        .known_animals = try allocator.dupe(Animal, &[_]Animal{
            .{
                .name = try allocator.dupe(u8, "dog"),
                .sound = try allocator.dupe(u8, "woof"),
            },
            .{
                .name = try allocator.dupe(u8, "fish"),
                .sound = try allocator.dupe(u8, "blub"),
            },
            .{
                .name = try allocator.dupe(u8, "elephant"),
                .sound = try allocator.dupe(u8, "toot"),
            },
            .{
                .name = try allocator.dupe(u8, "seal"),
                .sound = try allocator.dupe(u8, "ow"),
            },
        }),
    };
    defer test_case.deinit(allocator);

    const expected_output = "wa pa pa pa pa pa pow";
    const result = try solve(test_case);
    try testing.expectEqualStrings(expected_output, result);
}
