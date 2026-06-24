import 'dart:async';

import 'package:logger/logger.dart';
import 'package:slive_core/src/rust/api/log.dart' as rust_log;

enum RequestLogType { all, short, none }

class CoreLog {
  static bool enableLog = true;
  static RequestLogType requestLogType = RequestLogType.all;
  static Function(Level, String)? onPrintLog;
  static Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static StreamSubscription<rust_log.LogEntry>? _rustSub;

  /// 启动 Rust→Dart 日志桥接（需在 RustLib.init() 之后调用）
  static void startRustLog() {
    _rustSub?.cancel();
    _rustSub = rust_log.setupLogStream().listen(_onRustLog);
  }

  static void _onRustLog(rust_log.LogEntry entry) {
    final tag = '[Rust:${entry.lbl}]';
    switch (entry.logLevel) {
      case rust_log.Level.error:
        CoreLog.e('$tag ${entry.msg}', StackTrace.current);
      case rust_log.Level.warn:
        CoreLog.w('$tag ${entry.msg}');
      case rust_log.Level.info:
        CoreLog.i('$tag ${entry.msg}');
      default:
        CoreLog.d('$tag ${entry.msg}');
    }
  }

  /// 停止 Rust 日志桥接
  static void stopRustLog() {
    _rustSub?.cancel();
    _rustSub = null;
  }

  static void d(String message) {
    if (!enableLog) return;
    onPrintLog?.call(Level.debug, message);
    onPrintLog ?? logger.d("${DateTime.now()}\n$message");
  }

  static void i(String message) {
    if (!enableLog) return;
    onPrintLog?.call(Level.info, message);
    onPrintLog ?? logger.i("${DateTime.now()}\n$message");
  }

  static void e(String message, StackTrace stackTrace) {
    if (!enableLog) return;
    onPrintLog?.call(Level.error, message);
    onPrintLog ??
        logger.e("${DateTime.now()}\n$message", stackTrace: stackTrace);
  }

  static void error(Object e) {
    if (!enableLog) return;
    onPrintLog?.call(Level.error, e.toString());
    onPrintLog ??
        logger.e("${DateTime.now()}\n$e",
            error: e,
            stackTrace: (e is Error) ? e.stackTrace : StackTrace.current);
  }

  static void w(String message) {
    if (!enableLog) return;
    onPrintLog?.call(Level.warning, message);
    onPrintLog ?? logger.w("${DateTime.now()}\n$message");
  }
}
