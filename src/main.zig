const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const uname = std.posix.uname();

    var hostname_buffer: [std.posix.HOST_NAME_MAX]u8 = undefined;
    const hostname = try std.posix.gethostname(&hostname_buffer);

    var cwd_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const cwd = try std.posix.getcwd(&cwd_buffer);

    try stdout.print(
        "Welcome to Zig Hello Scratch.\nHostname: {s}\nWorkin directory: {s}\nSystem: {s}, {s}, {s}\nArchitecture: {s}\n\n",
        .{hostname, cwd, uname.sysname, uname.release, uname.version, uname.machine},
    );

    var index: u32 = 0;
    while (true) : (index += 1) {
        try stdout.print("Output {d}.\n", .{index});
        try bw.flush(); // don't forget to flush!
        std.posix.nanosleep(2, 0);
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
