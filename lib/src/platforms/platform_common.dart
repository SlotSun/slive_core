import 'package:slive_core/src/rust/frb_generated.dart';

bool _frbInitialized = false;

Future<void> ensureFrbInit() async {
  if (_frbInitialized) return;
  try {
    await RustLib.init();
  } catch (_) {
    // Already initialized (e.g. by external code calling RustLib.init() directly)
  }
  _frbInitialized = true;
}
