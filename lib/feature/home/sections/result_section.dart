import 'package:better_way/feature/home/controller/analysis_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ResultSection extends ConsumerWidget {
  const ResultSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(profitResultProvider);
    final state = ref.watch(analysisProvider);
    final currencyFormat = NumberFormat.currency(locale: 'ko_KR', symbol: '원');

    // Values for breakdown
    final pReal = state.sellingPrice * (1 - state.discountRate);
    final fTotal = state.platformFeeRate + state.paymentFeeRate;
    final fee = pReal * fTotal;
    final outputVat = pReal * (10 / 110);
    final inputVat = state.costPrice * (10 / 110);
    final double vat = (outputVat - inputVat).clamp(0, double.infinity);
    final grossProfit = pReal - fee - state.costPrice - state.shippingCost - state.packagingCost - state.adCost;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('수익 분석 결과', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildResultCard(
          '건당 순이익',
          currencyFormat.format(result.netProfit),
          '마진율: ${(result.margin * 100).toStringAsFixed(1)}%',
        ),
        const SizedBox(height: 12),
        _buildResultCard('월 예상 순이익', currencyFormat.format(result.monthlyProfit), '판매량: ${state.quantity.toInt()}개 기준'),
        const SizedBox(height: 24),
        const Text('계산 근거 (Breakdown)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _buildBreakdownRow('실제 판매가', pReal),
        _buildBreakdownRow('(-) 플랫폼/결제 수수료', -fee),
        _buildBreakdownRow('(-) 매입가', -state.costPrice),
        _buildBreakdownRow('(-) 배송/포장/광고비', -(state.shippingCost + state.packagingCost + state.adCost)),
        const Divider(),
        _buildBreakdownRow('(=) 세전 영업이익', grossProfit, isBold: true),
        _buildBreakdownRow('(-) 부가세', -vat),
        const Divider(),
        _buildBreakdownRow('(=) 최종 순이익', result.netProfit, isBold: true),
      ],
    );
  }

  Widget _buildResultCard(String title, String value, String subtitle) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, double value, {bool isBold = false}) {
    final currencyFormat = NumberFormat.currency(locale: 'ko_KR', symbol: '');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            currencyFormat.format(value),
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
