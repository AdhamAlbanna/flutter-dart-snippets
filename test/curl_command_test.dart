import 'package:flutter_dart_snippets/flutter_dart_snippets.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('buildCurlCommand', () {
    test('includes method, url, headers and body', () {
      final request =
          http.Request('POST', Uri.parse('https://api.example.com/login'))
            ..headers['Content-Type'] = 'application/json'
            ..body = '{"a":1}';

      expect(
        buildCurlCommand(request),
        "curl -X POST 'https://api.example.com/login' "
        "-H 'Content-Type: application/json' -d '{\"a\":1}'",
      );
    });

    test('redacts the Authorization header', () {
      final request =
          http.Request('GET', Uri.parse('https://api.example.com/me'))
            ..headers['Authorization'] = 'secret-token';

      final command = buildCurlCommand(request);
      expect(command, isNot(contains('secret-token')));
      expect(command, contains('<redacted>'));
    });

    test('escapes single quotes in the body', () {
      final request = http.Request('POST', Uri.parse('https://api.example.com'))
        ..body = "it's";
      expect(buildCurlCommand(request), contains(r"it'\''s"));
    });
  });
}
