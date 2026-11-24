/// Runs [action], retrying failures with exponential backoff.
///
/// Waits `baseDelay`, `2 * baseDelay`, `4 * baseDelay`, ... between attempts
/// and rethrows the last error after [maxAttempts]. Use [retryIf] to retry only
/// errors that are worth retrying (timeouts, 5xx), never validation failures.
Future<T> retry<T>(
  Future<T> Function() action, {
  int maxAttempts = 3,
  Duration baseDelay = const Duration(milliseconds: 300),
  bool Function(Object error)? retryIf,
}) async {
  assert(maxAttempts >= 1, 'maxAttempts must be at least 1');

  var attempt = 0;
  while (true) {
    attempt++;
    try {
      return await action();
    } catch (error) {
      final canRetry = attempt < maxAttempts && (retryIf?.call(error) ?? true);
      if (!canRetry) rethrow;
      await Future<void>.delayed(baseDelay * (1 << (attempt - 1)));
    }
  }
}
