import 'package:better_way/feature/home/controller/analysis_controller.dart';
import 'package:better_way/feature/home/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CostSection extends ConsumerWidget {
  const CostSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final controller = ref.read(analysisProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('비용 정보', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: '매입가',
          initialValue: state.costPrice.toString(),
          suffix: const Text('원'),
          onChanged: (v) => controller.updateCostPrice(double.tryParse(v) ?? 0),
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: '배송비',
          initialValue: state.shippingCost.toString(),
          suffix: const Text('원'),
          onChanged: (v) => controller.updateShippingCost(double.tryParse(v) ?? 0),
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: '포장비',
          initialValue: state.packagingCost.toString(),
          suffix: const Text('원'),
          onChanged: (v) => controller.updatePackagingCost(double.tryParse(v) ?? 0),
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: '건당 광고비',
          initialValue: state.adCost.toString(),
          suffix: const Text('원'),
          onChanged: (v) => controller.updateAdCost(double.tryParse(v) ?? 0),
        ),
      ],
    );
  }
}
