import 'package:better_way/feature/home/state/analysis_state.dart';
import 'package:better_way/feature/home/util/profit_calculator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analysisProvider = NotifierProvider<AnalysisController, AnalysisState>(() => AnalysisController());

class AnalysisController extends Notifier<AnalysisState> {
  AnalysisController();

  void updateSellingPrice(double value) => state = state.copyWith(sellingPrice: value);

  void updateCostPrice(double value) => state = state.copyWith(costPrice: value);

  void calculate() {
    final result = ProfitCalculator.calculate(
      sellingPrice: state.sellingPrice,
      discountRate: state.discountRate,
      costPrice: state.costPrice,
      shippingCost: state.shippingCost,
      packagingCost: state.packagingCost,
      adCost: state.adCost,
      platformFeeRate: state.platformFeeRate,
      paymentFeeRate: state.paymentFeeRate,
      quantity: state.quantity,
    );

    state = state.copyWith(netProfit: result.netProfit, margin: result.margin, monthlyProfit: result.monthlyProfit);
  }

  @override
  AnalysisState build() {
    return AnalysisState(
      sellingPrice: 0,
      discountRate: 0,
      costPrice: 0,
      shippingCost: 0,
      packagingCost: 0,
      adCost: 0,
      platformFeeRate: 0,
      paymentFeeRate: 0,
      quantity: 0,
    );
  }
}
