import 'package:better_way/feature/home/controller/analysis_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellingSection extends ConsumerWidget {
  const SellingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final controller = ref.read(analysisProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('판매 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: state.sellingPrice.toString(),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '판매가 (원)'),
          onChanged: (v) => controller.updateSellingPrice(double.tryParse(v) ?? 0),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: (state.discountRate * 100).toString(),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '할인율 (%)'),
          onChanged: (v) => controller.updateDiscountRate((double.tryParse(v) ?? 0) / 100),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: state.quantity.toString(),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '월 판매 수량 (개)'),
          onChanged: (v) => controller.updateQuantity(double.tryParse(v) ?? 0),
        ),
      ],
    );
  }
}
