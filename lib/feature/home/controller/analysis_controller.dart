import 'package:better_way/core/network/api_service.dart';
import 'package:better_way/core/provider/session_provider.dart';
import 'package:better_way/feature/home/state/analysis_state.dart';
import 'package:better_way/feature/home/util/profit_calculator.dart';
import 'package:flutter/foundation.dart';
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
  late ApiService _apiService;
  String? _clientId;

  AnalysisController();

  @override
  AnalysisState build() {
    _apiService = ref.read(apiServiceProvider);

    // Listen to clientIdProvider and store the value
    ref.listen<AsyncValue<String>>(clientIdProvider, (previous, next) {
      next.whenData((clientId) {
        _clientId = clientId;
      });
    });

    // Initial state with default values
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

  Future<void> saveCalculationLog() async {
    if (_clientId == null) {
      if (kDebugMode) {
        print('Client ID not yet available, skipping log send.');
      }
      return;
    }

    final currentInputs = state;
    final currentResult = ref.read(profitResultProvider);

    final payload = {
      'clientId': _clientId,
      'sellingPrice': currentInputs.sellingPrice,
      'discountRate': currentInputs.discountRate,
      'costPrice': currentInputs.costPrice,
      'shippingCost': currentInputs.shippingCost,
      'packagingCost': currentInputs.packagingCost,
      'adCost': currentInputs.adCost,
      'platformFeeRate': currentInputs.platformFeeRate,
      'paymentFeeRate': currentInputs.paymentFeeRate,
      'quantity': currentInputs.quantity,
      'netProfit': currentResult.netProfit,
      'margin': currentResult.margin,
      'monthlyProfit': currentResult.monthlyProfit,
    };

    try {
      final response = await _apiService.post('/api/log_calculation', payload);
      if (kDebugMode) {
        if (response.statusCode == 200) {
          print('Calculation log sent successfully.');
        } else {
          print('Failed to send calculation log: ${response.statusCode} ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending calculation log: $e');
      }
    }
  }

  void _updateState(AnalysisState newState) {
    state = newState;
  }

  void updateSellingPrice(double value) => _updateState(state.copyWith(sellingPrice: value));
  void updateDiscountRate(double value) => _updateState(state.copyWith(discountRate: value));
  void updateCostPrice(double value) => _updateState(state.copyWith(costPrice: value));
  void updateShippingCost(double value) => _updateState(state.copyWith(shippingCost: value));
  void updatePackagingCost(double value) => _updateState(state.copyWith(packagingCost: value));
  void updateAdCost(double value) => _updateState(state.copyWith(adCost: value));
  void updatePlatformFeeRate(double value) => _updateState(state.copyWith(platformFeeRate: value));
  void updatePaymentFeeRate(double value) => _updateState(state.copyWith(paymentFeeRate: value));
  void updateQuantity(double value) => _updateState(state.copyWith(quantity: value));
}
