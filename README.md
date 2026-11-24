# Flutter & Dart Snippets

Small, tested, framework-agnostic Dart techniques that I reuse across Flutter apps. Each one is a single file with no state-management dependency, so you can copy it into any project or import the package.

All snippets are covered by unit tests (`dart test`).

## What's inside

| Snippet | File | What it solves |
|---|---|---|
| **API response parser** | [`api_response_parser.dart`](lib/src/api_response_parser.dart) | Turns any HTTP response into `{success, message, ...body}`. Works with backends that do and do not send a `success` flag, and never throws on empty or non-JSON bodies. |
| **cURL command builder** | [`curl_command.dart`](lib/src/curl_command.dart) | Reproduce a failing request in the terminal. Redacts `Authorization` and `Cookie` so logs are safe to share. |
| **Retry with backoff** | [`retry.dart`](lib/src/retry.dart) | Retry flaky calls with exponential backoff, and only for errors you choose (timeouts, 5xx), never for validation failures. |
| **Validators** | [`validators.dart`](lib/src/validators.dart) | Returns a `ValidationError` enum instead of a string, so validation stays separate from localization. Map the enum to translated text in the UI layer. |

## Usage

Copy the file you need, or add the package from Git:

```yaml
dependencies:
  flutter_dart_snippets:
    git: https://github.com/AdhamAlbanna/flutter-dart-snippets.git
```

### API response parser

```dart
final response = await http.get(uri);
final result = parseApiResponse(response.statusCode, response.bodyBytes);

if (result['success'] == true) {
  // use result['data'], result['id'], ...
} else {
  showError(result['message']);
}
```

### cURL command builder

```dart
if (kDebugMode) debugPrint(buildCurlCommand(request));
// curl -X POST 'https://api.example.com/login' -H 'Authorization: <redacted>' -d '{"a":1}'
```

### Retry with backoff

```dart
final data = await retry(
  () => fetchProfile(),
  maxAttempts: 4,
  retryIf: (error) => error is TimeoutException || error is SocketException,
);
```

### Validators

```dart
String? validator(String? value) {
  switch (validate(value, min: 6, max: 40)) {
    case ValidationError.required:
      return 'field_required'.tr;
    case ValidationError.tooShort:
      return 'field_too_short'.tr;
    default:
      return null;
  }
}
```

## Development

```bash
dart pub get
dart format lib test
dart analyze
dart test
```

## Related

See [flutter-getx-starter](https://github.com/AdhamAlbanna/flutter-getx-starter) for a full Flutter project that uses these ideas end to end.

## License

[MIT](LICENSE) © Adham Albanna
