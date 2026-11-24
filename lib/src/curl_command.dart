import 'package:http/http.dart' as http;

/// Builds a cURL command for [request], handy for reproducing a call in a terminal.
///
/// Sensitive headers are replaced with `<redacted>` so the output is safe to
/// paste into a bug report. Print it only in debug builds.
String buildCurlCommand(
  http.BaseRequest request, {
  Set<String> redactHeaders = const {'authorization', 'cookie'},
}) {
  final buffer = StringBuffer("curl -X ${request.method} '${request.url}'");

  request.headers.forEach((name, value) {
    final shown =
        redactHeaders.contains(name.toLowerCase()) ? '<redacted>' : value;
    buffer.write(" -H '$name: $shown'");
  });

  if (request is http.Request && request.body.isNotEmpty) {
    final body = request.body.replaceAll("'", r"'\''");
    buffer.write(" -d '$body'");
  }
  return buffer.toString();
}
