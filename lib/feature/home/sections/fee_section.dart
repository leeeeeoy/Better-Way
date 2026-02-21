import 'package:better_way/feature/home/controller/analysis_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeeSection extends ConsumerWidget {
  const FeeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final controller = ref.read(analysisProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('수수료 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: (state.platformFeeRate * 100).toString(),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '플랫폼 수수료 (%)'),
          onChanged: (v) => controller.updatePlatformFeeRate((double.tryParse(v) ?? 0) / 100),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: (state.paymentFeeRate * 100).toString(),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '결제 수수료 (%)'),
          onChanged: (v) => controller.updatePaymentFeeRate((double.tryParse(v) ?? 0) / 100),
        ),
      ],
    );
  }
}
