import 'package:flutter_dart_snippets/flutter_dart_snippets.dart';
import 'package:test/test.dart';

void main() {
  const noDelay = Duration.zero;

  group('retry', () {
    test('returns immediately when the action succeeds', () async {
      var calls = 0;
      final result = await retry(() async {
        calls++;
        return 'ok';
      }, baseDelay: noDelay);
      expect(result, 'ok');
      expect(calls, 1);
    });

    test('retries failures and eventually succeeds', () async {
      var calls = 0;
      final result = await retry(() async {
        if (++calls < 3) throw StateError('flaky');
        return 'ok';
      }, baseDelay: noDelay);
      expect(result, 'ok');
      expect(calls, 3);
    });

    test('rethrows the last error after maxAttempts', () async {
      var calls = 0;
      await expectLater(
        retry(() async {
          calls++;
          throw StateError('always');
        }, maxAttempts: 4, baseDelay: noDelay),
        throwsStateError,
      );
      expect(calls, 4);
    });

    test('does not retry errors rejected by retryIf', () async {
      var calls = 0;
      await expectLater(
        retry(() async {
          calls++;
          throw ArgumentError('bad input');
        }, baseDelay: noDelay, retryIf: (error) => error is! ArgumentError),
        throwsArgumentError,
      );
      expect(calls, 1);
    });
  });
}
