/// A self-paced subscription plan, as returned by GET /api/billing/plans.
/// Amounts are in MAJOR units of [currency] (e.g. 36 = 36.00 AED).
class BillingPlan {
  final String id; // e.g. 'self_paced_monthly'
  final num amount; // 36, 180
  final String currency; // 'AED'
  final int periodDays;
  final String labelEn;
  final String labelAr;

  const BillingPlan({
    required this.id,
    required this.amount,
    required this.currency,
    required this.periodDays,
    required this.labelEn,
    required this.labelAr,
  });

  factory BillingPlan.fromJson(Map<String, dynamic> json) {
    return BillingPlan(
      id: json['id']?.toString() ?? '',
      amount: (json['amount'] as num?) ?? 0,
      currency: json['currency']?.toString() ?? 'AED',
      periodDays: (json['periodDays'] as num?)?.toInt() ?? 30,
      labelEn: json['labelEn']?.toString() ?? '',
      labelAr: json['labelAr']?.toString() ?? '',
    );
  }

  bool get isYearly => id.contains('year') || periodDays > 90;

  /// Amount formatted without trailing zeros (36, 180, 9.99).
  String get amountText {
    final d = amount.toDouble();
    return d == d.roundToDouble() ? d.toInt().toString() : d.toStringAsFixed(2);
  }
}
