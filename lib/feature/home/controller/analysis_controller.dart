import 'package:better_way/feature/home/state/analysis_state.dart';
import 'package:better_way/feature/home/util/profit_calculator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profitResultProvider = Provider<ProfitResult>((ref) {
  final state = ref.watch(analysisProvider);
  return ProfitCalculator.calculate(
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
});

final analysisProvider = NotifierProvider<AnalysisController, AnalysisState>(() => AnalysisController());

class AnalysisController extends Notifier<AnalysisState> {
  AnalysisController();

  void updateSellingPrice(double value) => state = state.copyWith(sellingPrice: value);
  void updateDiscountRate(double value) => state = state.copyWith(discountRate: value);
  void updateCostPrice(double value) => state = state.copyWith(costPrice: value);
  void updateShippingCost(double value) => state = state.copyWith(shippingCost: value);
  void updatePackagingCost(double value) => state = state.copyWith(packagingCost: value);
  void updateAdCost(double value) => state = state.copyWith(adCost: value);
  void updatePlatformFeeRate(double value) => state = state.copyWith(platformFeeRate: value);
  void updatePaymentFeeRate(double value) => state = state.copyWith(paymentFeeRate: value);
  void updateQuantity(double value) => state = state.copyWith(quantity: value);

  @override
  AnalysisState build() {
    return const AnalysisState(
      sellingPrice: 30000,
      discountRate: 0.1,
      costPrice: 10000,
      shippingCost: 3000,
      packagingCost: 500,
      adCost: 200,
      platformFeeRate: 0.12,
      paymentFeeRate: 0.03,
      quantity: 100,
    );
  }
}
