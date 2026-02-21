import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/analysis_state.freezed.dart';

@freezed
abstract class AnalysisState with _$AnalysisState {
  const factory AnalysisState({
    required double sellingPrice,
    required double discountRate,
    required double costPrice,
    required double shippingCost,
    required double packagingCost,
    required double adCost,
    required double platformFeeRate,
    required double paymentFeeRate,
    required double quantity,
    double? netProfit,
    double? margin,
    double? monthlyProfit,
  }) = _AnalysisState;
}
