import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../facilitator/api_once.dart';

// Facilitator-only earnings-call routes the shared EarningsCallRepository does not cover
// (website EarningsCallPanel.tsx). Paths checked against server/routes/earnings-call.ts.
const String _personas = '/earnings-call/personas'; // GET (public), POST, DELETE /:id
const String _questions = '/earnings-call/questions'; // POST /:teamId/videos
const String _videosStatus = '/earnings-call/videos/status'; // GET: sets + advances D-ID jobs

/// D-ID built-in Microsoft neural voices offered for a photo-animated ('did') persona.
const List<(String, String)> earningsCallVoices = [
  ('en-US-GuyNeural', 'Male (US) - Guy'),
  ('en-US-DavisNeural', 'Male (US) - Davis'),
  ('en-GB-RyanNeural', 'Male (UK) - Ryan'),
  ('en-US-JennyNeural', 'Female (US) - Jenny'),
  ('en-GB-SoniaNeural', 'Female (UK) - Sonia'),
  ('ar-SA-HamedNeural', 'Male (Arabic) - Hamed'),
];

/// Largest photo the server accepts as a data URL (it rejects > ~2.8 MB of text).
const int earningsCallMaxPhotoBytes = 2000000;

/// Builds the `data:image/...;base64,` URL the server requires for a persona photo, or null
/// when the bytes are not an image the server will take.
String? photoDataUrl(List<int> bytes, {String? contentType}) {
  if (bytes.isEmpty || bytes.length > earningsCallMaxPhotoBytes) return null;
  var type = (contentType ?? '').split(';').first.trim().toLowerCase();
  if (!type.startsWith('image/')) {
    // Sniff the common formats when the server sent no usable content type.
    if (bytes.length > 3 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
      type = 'image/jpeg';
    } else if (bytes.length > 8 && bytes[0] == 0x89 && bytes[1] == 0x50) {
      type = 'image/png';
    } else if (bytes.length > 12 && bytes[8] == 0x57 && bytes[9] == 0x45) {
      type = 'image/webp';
    } else {
      return null;
    }
  }
  return 'data:$type;base64,${base64Encode(bytes)}';
}

/// Per-team video progress from a question set's items.
({int done, int processing, int failed}) videoProgress(Map<String, dynamic> set) {
  var done = 0, processing = 0, failed = 0;
  for (final q in (set['questions'] as List<dynamic>? ?? const [])) {
    if (q is! Map) continue;
    switch (q['videoStatus']) {
      case 'done':
        done++;
      case 'processing':
        processing++;
      case 'error':
        failed++;
    }
  }
  return (done: done, processing: processing, failed: failed);
}

class EarningsCallAdminApi {
  final ApiClient _api;
  EarningsCallAdminApi(this._api);

  String _err(Map<String, dynamic> res, String fallback) =>
      (res['error'] ?? res['message'] ?? fallback).toString();

  /// GET /earnings-call/personas -> `{data: [{id, name, title, photoDataUrl, voiceId}]}`.
  Future<List<Map<String, dynamic>>> personas() async {
    final res = await _api.get(_personas);
    final data = res['data'];
    if (data is! List) return [];
    return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// POST /earnings-call/personas. 'heygen' needs the HeyGen avatar id and voice id;
  /// 'did' animates the photo with one of [earningsCallVoices].
  Future<void> addPersona({
    required String name,
    required String title,
    required String provider,
    required String voiceId,
    String? heygenAvatarId,
    required String photoDataUrl,
  }) async {
    final res = await _api.postOnce(_personas, data: {
      'name': name,
      'title': title,
      'provider': provider,
      'heygenAvatarId': ?heygenAvatarId,
      'voiceId': voiceId,
      'photoDataUrl': photoDataUrl,
    });
    if (res['success'] != true) throw Exception(_err(res, 'Could not add analyst'));
  }

  /// DELETE /earnings-call/personas/:id.
  Future<void> deletePersona(String id) async {
    final res = await _api.sendOnce('DELETE', '$_personas/${Uri.encodeComponent(id)}');
    if (res['success'] != true) throw Exception(_err(res, 'Delete failed'));
  }

  /// POST /earnings-call/questions/:teamId/generate: drafts the AI analyst questions (a paid
  /// model call, so never auto-retried). Same contract as EarningsCallRepository's.
  Future<Map<String, dynamic>> generateQuestions(String teamId) =>
      _api.postOnce('$_questions/${Uri.encodeComponent(teamId)}/generate');

  /// POST /earnings-call/questions/:teamId/videos: render lip-synced analyst clips for the
  /// team's question set (personas rotate). 503 when the avatar service is not configured.
  Future<void> renderVideos(String teamId) async {
    // Never retried: each question orders a paid avatar video, and a retry after a 5xx or a
    // slow response would order the whole set again.
    final res = await _api.postOnce('$_questions/${Uri.encodeComponent(teamId)}/videos');
    if (res['success'] != true) throw Exception(_err(res, 'Video generation failed'));
  }

  /// GET /earnings-call/videos/status: every question set for the round, with each
  /// question's `videoStatus`; reading it also advances pending render jobs.
  Future<List<Map<String, dynamic>>> videoStatus() async {
    final res = await _api.get(_videosStatus);
    final data = res['data'];
    if (data is! List) throw Exception(_err(res, 'Could not read video status'));
    return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Downloads an image and returns it as a persona photo data URL. The app has no image
  /// picker, so a persona photo is taken from a link (e.g. a company headshot URL).
  Future<String> photoFromUrl(String url) async {
    final r = await Dio().get<List<int>>(url, options: Options(responseType: ResponseType.bytes));
    final bytes = r.data ?? const <int>[];
    if (bytes.length > earningsCallMaxPhotoBytes) throw Exception('Photo too large (max 2 MB)');
    final dataUrl = photoDataUrl(bytes, contentType: r.headers.value('content-type'));
    if (dataUrl == null) throw Exception('That link is not an image');
    return dataUrl;
  }
}
