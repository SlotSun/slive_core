import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slive_core/slive_core.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await RustLib.init();
    CoreLog.startRustLog();
  });

  test('rust log test', () async {
    await testLogValue(i: 42);
  });
}
