const std = @import("std");
const win = @import("std").os.windows;

pub const MB_OK: u32 = 0x00000000;
pub const MB_OKCANCEL: u32 = 0x00000001;
pub const MB_ABORTRETRYIGNORE: u32 = 0x00000002;
pub const MB_YESNOCANCEL: u32 = 0x00000003;
pub const MB_YESNO: u32 = 0x00000004;
pub const MB_RETRYCANCEL: u32 = 0x00000005;
pub const MB_CANCELTRYCONTINUE: u32 = 0x00000006;

pub const MB_ICONERROR: u32 = 0x00000010;
pub const MB_ICONQUESTION: u32 = 0x00000020;
pub const MB_ICONWARNING: u32 = 0x00000030;
pub const MB_ICONINFORMATION: u32 = 0x00000040;

pub const MB_DEFBUTTON1: u32 = 0x00000000;
pub const MB_DEFBUTTON2: u32 = 0x00000100;
pub const MB_DEFBUTTON3: u32 = 0x00000200;
pub const MB_DEFBUTTON4: u32 = 0x00000300;

pub const IDOK: u32 = 1;
pub const IDCANCEL: u32 = 2;
pub const IDABORT: u32 = 3;
pub const IDRETRY: u32 = 4;
pub const IDIGNORE: u32 = 5;
pub const IDYES: u32 = 6;
pub const IDNO: u32 = 7;

extern "user32" fn MessageBoxA(hwnd: ?win.HWND, text: [*:0]const u8, title: [*:0]const u8, @"type": u32) callconv(.winapi) i32;

pub fn main() !void {
    const title = "Windows Clicker";

    _ = MessageBoxA(null, "This is a clicker game, press retry to get more points.\nIf you press ignore you lose and some times it will auto select to it!", title, MB_ICONINFORMATION);

    var buffer: [128]u8 = @splat(0x00);

    while (true) {
        var count: usize = 0;

        const exit: bool = while (true) {
            @memset(buffer[0..], 0x00);
            const dialog = try std.fmt.bufPrintZ(&buffer, "{d}", .{count});
            const input = MessageBoxA(null, dialog, title, MB_ICONWARNING | MB_ABORTRETRYIGNORE | if (count % 13 == 0) MB_DEFBUTTON2 else MB_DEFBUTTON3);

            switch (input) {
                IDABORT => break true,
                IDRETRY => count += 1,
                IDIGNORE => break false,
                else => unreachable,
            }
        };
        if (exit)
            _ = MessageBoxA(null, try std.fmt.bufPrintZ(&buffer, "Final count was {d}!", .{count}), title, MB_ICONINFORMATION)
        else
            _ = MessageBoxA(null, "You lost since you pressed ignore HAHAHA", title, MB_ICONERROR);

        if (MessageBoxA(null, "Play again?", title, MB_ICONQUESTION | MB_RETRYCANCEL | MB_DEFBUTTON2) == IDCANCEL) break;
    }
}
