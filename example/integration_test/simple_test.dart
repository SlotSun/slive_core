import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slive_core/slive_core.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());
  test('detectPlatform returns bilibili for bilibili URL', () async {
    final result = await detectPlatform(url: 'https://live.bilibili.com/12345');
    expect(result, 'bilibili');
  });
}
