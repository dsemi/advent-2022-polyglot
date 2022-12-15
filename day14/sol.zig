const std = @import("std");

const Coord = struct {
    x: usize,
    y: usize,
};

fn go(grid: *std.ArrayList([1000]u8), p2: bool, x: usize, y: usize) bool {
    if (y >= grid.items.len) return p2;
    if (grid.items[y][x] == '~') return false;
    if (grid.items[y][x] == '#' or grid.items[y][x] == 'o') return true;
    const b = go(grid, p2, x, y + 1) and go(grid, p2, x - 1, y + 1) and go(grid, p2, x + 1, y + 1);
    grid.items[y][x] = if (b) 'o' else '~';
    return b;
}

fn flowSand(grid: *std.ArrayList([1000]u8), p2: bool) usize {
    _ = go(grid, p2, 500, 0);
    var settled: usize = 0;
    for (grid.items) |row| {
        for (row) |v| settled += @boolToInt(v == 'o');
    }
    return settled;
}

pub fn main() !void {
    var alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer alloc.deinit();
    const a = alloc.allocator();
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    try stdout.print("Day 14: Zig\n", .{});

    var grid = std.ArrayList([1000]u8).init(a);
    while (try stdin.readUntilDelimiterOrEofAlloc(a, '\n', 1000)) |line| {
        var pts = std.ArrayList(Coord).init(a);
        var it = std.mem.split(u8, line, " -> ");
        while (it.next()) |pt| {
            const idx = std.mem.indexOfScalar(u8, pt, ',').?;
            const x = try std.fmt.parseInt(usize, pt[0..idx], 10);
            const y = try std.fmt.parseInt(usize, pt[idx + 1 ..], 10);
            while (grid.items.len < y + 2) {
                var row: [1000]u8 = undefined;
                for (row) |*v| v.* = '.';
                try grid.append(row);
            }
            try pts.append(Coord{ .x = x, .y = y });
        }
        var i: usize = 1;
        while (i < pts.items.len) : (i += 1) {
            const p1 = pts.items[i - 1];
            const p2 = pts.items[i];
            const x0 = std.math.min(p1.x, p2.x);
            const y0 = std.math.min(p1.y, p2.y);
            const x1 = std.math.max(p1.x, p2.x);
            const y1 = std.math.max(p1.y, p2.y);
            var x = x0;
            while (x <= x1) : (x += 1) {
                var y = y0;
                while (y <= y1) : (y += 1) {
                    grid.items[y][x] = '#';
                }
            }
        }
    }
    var grid2 = try grid.clone();
    try stdout.print("Part 1: {:20}\n", .{flowSand(&grid, false)});
    try stdout.print("Part 2: {:20}\n", .{flowSand(&grid2, true)});
}
