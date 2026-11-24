import 'dart:convert';
import 'dart:typed_data';

/// Turns an HTTP response into the map shape most controllers want:
/// `{'success': bool, 'message': String?, ...body}`.
///
/// - Backends that send their own `success` flag keep it.
/// - Backends that do not get one derived from the status code.
/// - Non-JSON or non-object bodies never throw.
/// - Bodies are decoded as UTF-8, so Arabic and other non-ASCII text survives.
Map<String, dynamic> parseApiResponse(int statusCode, Uint8List bodyBytes) {
  final ok = statusCode >= 200 && statusCode < 300;

  Map<String, dynamic>? data;
  try {
    final decoded = json.decode(utf8.decode(bodyBytes));
    if (decoded is Map<String, dynamic>) data = decoded;
  } on FormatException {
    data = null;
  }

  if (data == null) {
    return ok
        ? {'success': true}
        : {
            'success': false,
            'message': 'Request failed with status: $statusCode',
          };
  }

  data.putIfAbsent('success', () => ok);
  if (!ok && data['success'] != false) data['success'] = false;
  if (data['success'] == false) {
    data['message'] ??= 'Request failed with status: $statusCode';
  }
  return data;
}
