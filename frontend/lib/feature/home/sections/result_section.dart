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
    final controller = ref.read(analysisProvider.notifier); // Get the controller
    final textTheme = Theme.of(context).textTheme;

    // Formatter for currency values
    final currencyFormat = NumberFormat('#,##0', 'ko_KR');

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
        Text('수익 분석 결과', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildResultCard(
          context: context,
          title: '건당 순이익',
          value: '${currencyFormat.format(result.netProfit)}원',
          subtitle: '마진율: ${(result.margin * 100).toStringAsFixed(1)}%',
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        _buildResultCard(
          context: context,
          title: '월 예상 순이익',
          value: '${currencyFormat.format(result.monthlyProfit)}원',
          subtitle: '판매량: ${state.quantity.toInt()}개 기준',
        ),
        const SizedBox(height: 24),
        Text('계산 근거 (Breakdown)', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _buildBreakdownRow('실제 판매가', pReal, currencyFormat),
        _buildBreakdownRow('(-) 플랫폼/결제 수수료', -fee, currencyFormat),
        _buildBreakdownRow('(-) 매입가', -state.costPrice, currencyFormat),
        _buildBreakdownRow('(-) 배송/포장/광고비', -(state.shippingCost + state.packagingCost + state.adCost), currencyFormat),
        const Divider(height: 24),
        _buildBreakdownRow('(=) 세전 영업이익', grossProfit, currencyFormat, isBold: true),
        _buildBreakdownRow('(-) 부가세', -vat, currencyFormat),
        const Divider(height: 24),
        _buildBreakdownRow('(=) 최종 순이익', result.netProfit, currencyFormat, isBold: true),
        const SizedBox(height: 32),
        Text(
          '이 계산 결과를 서버에 저장하여 통계 분석에 활용할 수 있습니다.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => controller.saveCalculationLog(),
            icon: const Icon(Icons.save),
            label: const Text('계산 결과 저장하기'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    bool isPrimary = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: isPrimary ? 4 : 2,
      color: isPrimary ? colorScheme.primaryContainer : colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              value,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isPrimary ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, double value, NumberFormat formatter, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
          Text(
            '${formatter.format(value)}원',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
