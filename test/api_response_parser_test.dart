import 'dart:convert';

import 'package:flutter_dart_snippets/flutter_dart_snippets.dart';
import 'package:test/test.dart';

Map<String, dynamic> parse(int status, String body) =>
    parseApiResponse(status, utf8.encode(body));

void main() {
  group('parseApiResponse', () {
    test('derives success from a 2xx status when the body has no flag', () {
      final result = parse(200, '{"id": 1}');
      expect(result['success'], isTrue);
      expect(result['id'], 1);
    });

    test('keeps a backend-provided success flag', () {
      expect(parse(200, '{"success": false, "message": "no"}')['success'],
          isFalse);
    });

    test('marks non-2xx responses as failures and keeps the server message',
        () {
      final result = parse(400, '{"message": "Invalid credentials"}');
      expect(result['success'], isFalse);
      expect(result['message'], 'Invalid credentials');
    });

    test('adds a message when a failure has none', () {
      expect(parse(500, '{}')['message'], 'Request failed with status: 500');
    });

    test('does not throw on empty or non-JSON bodies', () {
      expect(parse(204, '')['success'], isTrue);
      expect(parse(502, '<html>Bad gateway</html>')['success'], isFalse);
    });

    test('does not throw on JSON that is not an object', () {
      expect(parse(200, '[1, 2, 3]')['success'], isTrue);
    });

    test('decodes UTF-8 (Arabic) text', () {
      expect(parse(200, '{"name": "أحمد"}')['name'], 'أحمد');
    });
  });
}
