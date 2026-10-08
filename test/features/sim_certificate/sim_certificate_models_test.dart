import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart' show httpStatusKey;
import 'package:finplay/features/sim_certificate/data/sim_certificate_models.dart';

void main() {
  const certJson = {
    'verificationCode': 'FP-ABCD-1234',
    'learnerName': 'Sara Ali',
    'programName': 'FinPlay Business Simulation',
    'issuedAt': '2026-03-15T12:00:00.000Z',
    'verifyUrl': 'https://finplay.viftraining.com/verify/FP-ABCD-1234',
  };

  group('SimCertificateStatus (/certificate/simulation/mine)', () {
    test('issued', () {
      final s = SimCertificateStatus.fromResponse({
        'success': true, 'mode': 'self-paced', 'eligible': true, 'revoked': false,
        'progress': {'currentRound': 3, 'totalRounds': 3},
        'certificates': [certJson],
      });
      expect(s.state, SimCertState.issued);
      expect(s.certificate!.verificationCode, 'FP-ABCD-1234');
    });

    test('eligible but unclaimed', () {
      final s = SimCertificateStatus.fromResponse({
        'success': true, 'mode': 'corporate', 'eligible': true, 'revoked': false,
        'progress': {'currentRound': 3, 'totalRounds': 3}, 'certificates': [],
      });
      expect(s.state, SimCertState.eligible);
    });

    test('locked with progress', () {
      final s = SimCertificateStatus.fromResponse({
        'success': true, 'eligible': false, 'progress': {'currentRound': 2, 'totalRounds': 3}, 'certificates': [],
      });
      expect(s.state, SimCertState.locked);
      expect(s.currentRound, 2);
      expect(s.totalRounds, 3);
    });

    test('401 → signed out (panel hides)', () {
      final s = SimCertificateStatus.fromResponse({'success': false, 'error': 'Not authenticated', httpStatusKey: 401});
      expect(s.state, SimCertState.signedOut);
    });

    test('revoked certificate is not returned, so it reads as eligible/locked, never issued', () {
      final s = SimCertificateStatus.fromResponse({
        'success': true, 'eligible': true, 'revoked': true, 'progress': {'currentRound': 3, 'totalRounds': 3}, 'certificates': [],
      });
      expect(s.revoked, isTrue);
      expect(s.state, isNot(SimCertState.issued));
    });
  });

  group('SimClaimResult', () {
    test('success', () {
      final r = SimClaimResult.fromResponse({'success': true, 'alreadyIssued': false, 'certificate': certJson});
      expect(r.ok, isTrue);
    });
    test('402 subscription required (self-paced)', () {
      final r = SimClaimResult.fromResponse({'success': false, 'code': 'SUBSCRIPTION_REQUIRED', 'error': 'x', httpStatusKey: 402});
      expect(r.ok, isFalse);
      expect(r.subscriptionRequired, isTrue);
    });
    test('403 not finished keeps the server message', () {
      final r = SimClaimResult.fromResponse({'success': false, 'error': 'Your team has not completed the simulation yet.', httpStatusKey: 403});
      expect(r.error, contains('not completed'));
      expect(r.subscriptionRequired, isFalse);
    });
    test('410 revoked', () {
      expect(SimClaimResult.fromResponse({'success': false, 'error': 'revoked', httpStatusKey: 410}).revoked, isTrue);
    });
  });

  test('LinkedIn add-to-profile URL matches the website format', () {
    final c = SimCertificate.fromJson(certJson)!;
    final local = DateTime.parse('2026-03-15T12:00:00.000Z').toLocal();
    expect(
      c.linkedInAddToProfileUrl.toString(),
      'https://www.linkedin.com/profile/add?startTask=CERTIFICATION_NAME'
      '&name=FinPlay%20Business%20Simulation'
      '&organizationName=VIFM'
      '&issueYear=${local.year}'
      '&issueMonth=${local.month}'
      '&certUrl=https%3A%2F%2Ffinplay.viftraining.com%2Fverify%2FFP-ABCD-1234'
      '&certId=FP-ABCD-1234',
    );
  });

  test('certificate date formats as day month year', () {
    final d = DateTime(2026, 10, 5, 12);
    expect(formatCertificateDate(d, false), '5 October 2026');
    expect(formatCertificateDate(d, true), '5 أكتوبر 2026');
  });
}
