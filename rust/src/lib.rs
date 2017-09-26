#![feature(lang_items)]
#![no_std]

#[no_mangle]
pub extern fn rust_main() {
    // Attention: we have a small stack and no guard page
    let hello = b"Hello World"; // b for byte string
    let color_byte = 0x1f; // white foreground blue background

    let mut hello_colored = [color_byte; 24];
    for (i, char_byte) in hello.into_iter().enumerate() {
        hello_colored[i*2] = *char_byte;
    }

    // Write hello world to the center of VGA text buffer
    let buffer_ptr = (0xb8000, + 1988) as *mut _;
    unsafe { *buffer_ptr = hello_colored };

    loop{}
}

#[lang = "eh_personality"] extern fn eh_personality() {}
#[lang = "panic_fmt"] #[no_mangle] pub extern fn panic_fmt() -> !{loop{}}
