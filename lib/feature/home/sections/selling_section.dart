import 'package:better_way/feature/home/controller/analysis_controller.dart';
import 'package:better_way/feature/home/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellingSection extends ConsumerWidget {
  const SellingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final controller = ref.read(analysisProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('판매 정보', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: '판매가',
          initialValue: state.sellingPrice.toString(),
          suffix: const Text('원'),
          onChanged: (v) => controller.updateSellingPrice(double.tryParse(v) ?? 0),
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: '할인율',
          initialValue: (state.discountRate * 100).toString(),
          suffix: const Text('%'),
          onChanged: (v) => controller.updateDiscountRate((double.tryParse(v) ?? 0) / 100),
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: '월 판매 수량',
          initialValue: state.quantity.toString(),
          suffix: const Text('개'),
          onChanged: (v) => controller.updateQuantity(double.tryParse(v) ?? 0),
        ),
      ],
    );
  }
}
