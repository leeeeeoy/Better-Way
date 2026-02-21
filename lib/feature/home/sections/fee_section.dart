import 'package:better_way/feature/home/controller/analysis_controller.dart';
import 'package:better_way/feature/home/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeeSection extends ConsumerWidget {
  const FeeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final controller = ref.read(analysisProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('수수료 정보', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: '플랫폼 수수료',
          initialValue: (state.platformFeeRate * 100).toString(),
          suffix: const Text('%'),
          onChanged: (v) => controller.updatePlatformFeeRate((double.tryParse(v) ?? 0) / 100),
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: '결제 수수료',
          initialValue: (state.paymentFeeRate * 100).toString(),
          suffix: const Text('%'),
          onChanged: (v) => controller.updatePaymentFeeRate((double.tryParse(v) ?? 0) / 100),
        ),
      ],
    );
  }
}
