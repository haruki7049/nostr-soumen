const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });
    mod.addCSourceFiles(.{ .root = b.path("src"), .files = &.{"main.cpp"} });
    mod.linkSystemLibrary("CLI11", .{});
    mod.linkSystemLibrary("ftxui", .{});
    mod.linkSystemLibrary("boost", .{});

    // Executable
    const exe = b.addExecutable(.{
        .name = "nostr_soumen",
        .root_module = mod,
    });
    b.installArtifact(exe);

    // Run step
    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
