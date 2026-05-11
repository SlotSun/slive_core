import 'package:logger/logger.dart';

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
