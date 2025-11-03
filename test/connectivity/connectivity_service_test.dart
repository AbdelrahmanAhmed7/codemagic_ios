import 'package:flutter_test/flutter_test.dart';
import 'package:mediconsult/core/network/connectivity_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('connectivity stream can be listened', () async {
    final service = ConnectivityService.instance;
    final stream = service.connectivityStream;
    expect(stream, isA<Stream<bool>>());
  });
}


