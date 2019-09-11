fn main() {
    use std::fs::File;
    use std::io::{Read, Write};
    let mut pads = String::new();
    File::open("geometry/pads.geom").unwrap().read_to_string(&mut pads).unwrap();
    let mut generated = String::new();
    File::open("src/geometry/generated.rs").unwrap().read_to_string(&mut generated).unwrap();
    let new_generated = generated.rsplitn(2, "//INSERT AFTER\n").skip(1).next().unwrap();
    write!(File::create("src/geometry/generated.rs").unwrap(), "{}//INSERT AFTER\nparse_pads!(PadType, PadConsts, PadState, window, particles, x, y, r, jump_time, dt, px, py, pw, params, state,\n{}\n);", new_generated, pads).unwrap();
}