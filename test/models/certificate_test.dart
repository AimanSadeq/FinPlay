import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart' show httpStatusKey;
import 'package:finplay/data/models/certificate.dart';

/// Pins how GET /certificate/me responses map onto screen states.
///
/// The branch that matters is 401: sessions last 7 days, so an expired session is routine, and
/// if it falls through to the generic error branch the learner is shown the server's raw
/// "Not authenticated" with no way forward. That regression is silent — the screen still
/// renders — so it is pinned here rather than left to manual testing.
void main() {
  group('CertificateStatus.fromResponse', () {
    test('401 is a session-expired state, not a generic error', () {
      final s = CertificateStatus.fromResponse({
        'success': false,
        'error': 'Not authenticated',
        httpStatusKey: 401,
      });
      expect(s.sessionExpired, isTrue);
      expect(s.error, isNull, reason: 'must not surface the raw server string');
      expect(s.subscriptionRequired, isFalse);
    });

    test('402 is a subscription-required state', () {
      final s = CertificateStatus.fromResponse({
        'success': false,
        'code': 'SUBSCRIPTION_REQUIRED',
        httpStatusKey: 402,
      });
      expect(s.subscriptionRequired, isTrue);
      expect(s.sessionExpired, isFalse);
      expect(s.error, isNull);
    });

    test('other failures keep the server message', () {
      final s = CertificateStatus.fromResponse({
        'success': false,
        'error': 'Could not load certificate',
        httpStatusKey: 500,
      });
      expect(s.error, 'Could not load certificate');
      expect(s.sessionExpired, isFalse);
      expect(s.subscriptionRequired, isFalse);
    });

    test('not yet eligible reports progress', () {
      final s = CertificateStatus.fromResponse(
          {'success': true, 'eligible': false, 'completed': 3, 'total': 8});
      expect(s.eligible, isFalse);
      expect(s.completed, 3);
      expect(s.total, 8);
      expect(s.progress, closeTo(0.375, 0.001));
      expect(s.certificate, isNull);
    });

    test('progress never divides by zero', () {
      final s = CertificateStatus.fromResponse(
          {'success': true, 'eligible': false, 'completed': 0, 'total': 0});
      expect(s.progress, 0);
    });

    test('revoked is eligible but carries no certificate', () {
      final s = CertificateStatus.fromResponse({
        'success': true,
        'eligible': true,
        'revoked': true,
        'completed': 8,
        'total': 8,
      });
      expect(s.revoked, isTrue);
      expect(s.certificate, isNull, reason: 'a revoked cert must never be presented as valid');
    });

    test('awarded parses the certificate', () {
      final s = CertificateStatus.fromResponse({
        'success': true,
        'eligible': true,
        'completed': 8,
        'total': 8,
        'certificate': {
          'verificationCode': 'ABC123',
          'learnerName': 'Demo Player',
          'programName': 'Finance for Non-Finance',
          'issuedAt': '2026-07-29T10:00:00.000Z',
          'viewUrl': '/api/certificate/view/ABC123',
        },
      });
      expect(s.eligible, isTrue);
      expect(s.revoked, isFalse);
      expect(s.certificate, isNotNull);
      expect(s.certificate!.verificationCode, 'ABC123');
      expect(s.certificate!.issuedAt, isNotNull);
      // Relative paths must be resolved against the API host, else the button opens nothing.
      expect(s.certificate!.viewUrl, startsWith('https://'));
      expect(s.certificate!.viewUrl, endsWith('/api/certificate/view/ABC123'));
      expect(s.certificate!.verifyUrl, endsWith('/verify/ABC123'));
    });

    test('an absolute viewUrl is left alone', () {
      final s = CertificateStatus.fromResponse({
        'success': true,
        'eligible': true,
        'certificate': {
          'verificationCode': 'X1',
          'learnerName': 'A',
          'programName': 'B',
          'viewUrl': 'https://example.com/c/X1',
        },
      });
      expect(s.certificate!.viewUrl, 'https://example.com/c/X1');
    });
  });
}
