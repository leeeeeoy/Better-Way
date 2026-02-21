import 'package:better_way/feature/home/controller/analysis_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CostSection extends ConsumerWidget {
  const CostSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final controller = ref.read(analysisProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('비용 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: state.costPrice.toString(),
          decoration: const InputDecoration(labelText: '매입가 (원)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => controller.updateCostPrice(double.tryParse(v) ?? 0),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: state.shippingCost.toString(),
          decoration: const InputDecoration(labelText: '배송비 (원)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => controller.updateShippingCost(double.tryParse(v) ?? 0),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: state.packagingCost.toString(),
          decoration: const InputDecoration(labelText: '포장비 (원)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => controller.updatePackagingCost(double.tryParse(v) ?? 0),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: state.adCost.toString(),
          decoration: const InputDecoration(labelText: '건당 광고비 (원)'),
          keyboardType: TextInputType.number,
          onChanged: (v) => controller.updateAdCost(double.tryParse(v) ?? 0),
        ),
      ],
    );
  }
}
