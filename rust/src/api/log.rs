use log::info;

flutter_logger::flutter_logger_init!();

#[flutter_rust_bridge::frb()]
pub fn test_log_value(i: i32) {
    info!("test called with: {i}")
}
