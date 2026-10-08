import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/models/entitlement.dart';
import 'package:finplay/data/models/user.dart';
import 'package:finplay/features/assessment/screens/assessment_screen.dart';
import 'package:finplay/features/self_paced/widgets/entitlement_banner.dart';

void main() {
  group('SelfPacedUser.plan', () {
    test('read from /me and kept in storage', () {
      final u = SelfPacedUser.fromJson({'email': 'a@b.c', 'displayName': 'A', 'plan': 'demo'});
      expect(u.plan, 'demo');
      expect(u.isDemoPlan, isTrue);
      expect(SelfPacedUser.fromJson(u.toStorageJson()).plan, 'demo');
    });

    test('absent on a login response', () {
      final u = SelfPacedUser.fromJson({'email': 'a@b.c', 'displayName': 'A'});
      expect(u.plan, isNull);
      expect(u.isDemoPlan, isFalse);
    });
  });

  group('lapsed / ending access wording', () {
    test('voucher and paid plans had an access period, not a free trial', () {
      expect(hadPaidAccess('voucher'), isTrue);
      expect(hadPaidAccess('self_paced'), isTrue);
      expect(hadPaidAccess('trial'), isFalse);
      expect(hadPaidAccess(null), isFalse);
    });

    Entitlement sub(int days) => Entitlement(
          active: true,
          reason: 'subscription',
          enforced: true,
          accessUntil: DateTime.now().add(Duration(days: days, minutes: 5)),
        );

    test('voucher learners are reminded only in the last 14 days', () {
      expect(isVoucherEnding(sub(10), 'voucher'), isTrue);
      expect(isVoucherEnding(sub(14), 'voucher'), isTrue);
      expect(isVoucherEnding(sub(16), 'voucher'), isFalse);
      expect(isVoucherEnding(sub(200), 'voucher'), isFalse);
      // A paid subscriber is not a voucher learner.
      expect(isVoucherEnding(sub(5), 'self_paced'), isFalse);
      expect(
          isVoucherEnding(
              const Entitlement(active: true, reason: 'trial', enforced: true), 'voucher'),
          isFalse);
    });
  });

  group('assessment gate (GET /assessments/status)', () {
    test('open when nothing blocks', () {
      expect(AssessmentGate.fromStatus({'completed': false}).open, isTrue);
    });

    test('suppressed wins and carries the reason', () {
      final g = AssessmentGate.fromStatus({
        'suppressed': true,
        'suppressedReason': 'DBA study',
        'anonymous': true,
        'completed': true,
      });
      expect(g.block, AssessmentBlock.suppressed);
      expect(g.reason, 'DBA study');
    });

    test('anonymous means sign in before answering', () {
      expect(AssessmentGate.fromStatus({'anonymous': true, 'completed': null}).block,
          AssessmentBlock.needsSignIn);
    });

    test('a recorded attempt is shown instead of a retake', () {
      final g = AssessmentGate.fromStatus({
        'completed': true,
        'lastScore': {'score': 18, 'total': 25, 'submittedAt': '2026-01-01'},
      });
      expect(g.block, AssessmentBlock.alreadyDone);
      expect(g.score, 18);
      expect(g.total, 25);
    });
  });
}
