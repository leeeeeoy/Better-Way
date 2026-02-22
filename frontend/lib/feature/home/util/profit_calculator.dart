class ProfitCalculator {
  static ProfitResult calculate({
    required double sellingPrice,
    required double discountRate,
    required double costPrice,
    required double shippingCost,
    required double packagingCost,
    required double adCost,
    required double platformFeeRate,
    required double paymentFeeRate,
    required double quantity,
  }) {
    final pReal = sellingPrice * (1 - discountRate);
    final fTotal = platformFeeRate + paymentFeeRate;
    final fee = pReal * fTotal;

    final outputVat = pReal * (10 / 110);
    final inputVat = costPrice * (10 / 110);
    final vat = (outputVat - inputVat).clamp(0, double.infinity);

    final grossProfit = pReal - fee - costPrice - shippingCost - packagingCost - adCost;

    final netProfit = grossProfit - vat;
    final double margin = pReal == 0 ? 0 : netProfit / pReal;
    final monthlyProfit = netProfit * quantity;

    return ProfitResult(netProfit: netProfit, margin: margin, monthlyProfit: monthlyProfit);
  }
}

class ProfitResult {
  final double netProfit;
  final double margin;
  final double monthlyProfit;

  ProfitResult({required this.netProfit, required this.margin, required this.monthlyProfit});
}
