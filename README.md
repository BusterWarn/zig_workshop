# Zig Workshop - Kattis Problems

This repository contains boilerplate code for solving Kattis problems using Zig 0.13.0. Each problem is structured in its own directory with a standard setup to help you focus on solving the algorithmic challenges.

## Getting Started

### Prerequisites
- Zig 0.13.0
- Git
- A Kattis account
- Join the contest - https://open.kattis.com/contests/k44vjq

### Running Solutions
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/zig_workshop.git
   cd zig_workshop
   ```

2. Navigate to a problem directory:
   ```bash
   cd thisaintyourgrandpascheckerboard
   ```

3. Run the solution:
   ```bash
   zig run src/main.zig
   ```

4. Run the tests:
   ```bash
   zig test src/main.zig
   ```

5. Add your implementation in the `solve` function. Remember to remove the input print.

## Zig Quick Reference

Random cheat sheet: https://github.com/grokkhub/zig-cheatsheet

### Basic Control Flow

#### Loops
```zig
// Loop n times
var i: usize = 0;
while (i < 10) : (i += 1) {
    // do something
}

// For loop over slice
const items = [_]i32{ 1, 2, 3, 4 };
for (items, 0..) |item, index| {
    // use item and index
}

// Loop with continue/break
while (true) {
    if (condition) continue;
    if (other_condition) break;
}
```

#### Error Handling
```zig
// Using try
const result = try someFunction();  // Returns on error
if (someFunction()) |value| {       // Handle optional
    // use value
} else |err| {
    // handle error
}

// Defer (cleanup)
const file = try std.fs.openFile("path", .{});
defer file.close();  // Will be called when scope ends
```

### Memory Management

#### Allocation
```zig
// Basic allocation
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
defer _ = gpa.deinit();
const allocator = gpa.allocator();

// Allocate array
const bytes = try allocator.alloc(u8, 100);
defer allocator.free(bytes);
```

#### Dynamic Arrays (ArrayList)
```zig
var list = std.ArrayList(i32).init(allocator);
defer list.deinit();

try list.append(42);
try list.appendSlice(&[_]i32{ 1, 2, 3 });
```

#### HashMaps
```zig
var map = std.AutoHashMap(i32, []const u8).init(allocator);
defer map.deinit();

try map.put(1, "one");
if (map.get(1)) |value| {
    // use value
}
```

### String Operations

#### Strings Basics
```zig
// Strings are just slices of u8
const string: []const u8 = "Hello";
const char = string[0];  // Get single byte

// Create owned string
const owned_string = try allocator.dupe(u8, "Hello");
defer allocator.free(owned_string);
```

#### String Operations
```zig
// Concatenation
const a = "Hello";
const b = "World";
const c = try std.fmt.allocPrint(allocator, "{s} {s}", .{ a, b });
defer allocator.free(c);

// Substring check
const contains = std.mem.indexOf(u8, haystack, needle) != null;

// Split
var iterator = std.mem.splitAny(u8, "a,b,c", ",");
while (iterator.next()) |token| {
    // use token
}

// Trim
const trimmed = std.mem.trim(u8, " hello ", " ");
```

### Additional Useful Operations

#### Reading Input
```zig
const stdin = std.io.getStdIn().reader();
var buf: [1024]u8 = undefined;
const line = try stdin.readUntilDelimiter(&buf, '\n');
```

#### Parsing Numbers
```zig
const number = try std.fmt.parseInt(i32, "123", 10);
```

#### Sorting
```zig
std.sort.sort(i32, slice, {}, std.sort.asc(i32));
```

#### Math Operations
```zig
const abs = std.math.absInt(-42);
const min = @min(a, b);
const max = @max(a, b);
const power = std.math.pow(f64, 2, 3);
```

#### Buffered Writing
```zig
var bw = std.io.bufferedWriter(std.io.getStdOut().writer());
try bw.writer().print("{d}\n", .{42});
try bw.flush();
```

#### Array/Slice Operations
```zig
// Create 2D array
var grid = try allocator.alloc([]i32, height);
for (grid) |*row| {
    row.* = try allocator.alloc(i32, width);
}

// Deep copy
const copy = try allocator.dupe(i32, original);
```

#### Set Operations
```zig
var set = std.AutoHashMap(i32, void).init(allocator);
try set.put(42, {});
const exists = set.contains(42);
```

#### Queue Operations
```zig
var queue = std.TailQueue(i32){};
var node = try allocator.create(std.TailQueue(i32).Node);
node.data = 42;
queue.append(node);
```

#### Binary Search
```zig
const index = std.sort.binarySearch(i32, target, sorted_slice, {}, std.sort.asc(i32));
```

#### Bit Operations
```zig
const set_bit = value | (1 << position);
const clear_bit = value & ~(1 << position);
const toggle_bit = value ^ (1 << position);
const is_set = (value & (1 << position)) != 0;
```

