import 'package:better_way/feature/home/controller/analysis_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(context, ref) {
    final state = ref.watch(analysisProvider);
    final controller = ref.read(analysisProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('상품 수익 분석기')),
      body: SingleChildScrollView(
        padding: const .all(24),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const Text('판매 정보', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              keyboardType: .number,
              decoration: const InputDecoration(labelText: '판매가'),
              onChanged: (v) => controller.updateSellingPrice(double.tryParse(v) ?? 0),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: '매입가'),
              keyboardType: .number,
              onChanged: (v) => controller.updateCostPrice(double.tryParse(v) ?? 0),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: controller.calculate, child: const Text('순이익 계산하기')),
            const SizedBox(height: 32),
            if (state.netProfit != null) ...[
              Text(
                '건당 순이익: ${state.netProfit!.toStringAsFixed(0)}원',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('마진율: ${(state.margin! * 100).toStringAsFixed(1)}%'),
              Text('월 예상 이익: ${state.monthlyProfit!.toStringAsFixed(0)}원'),
            ],
          ],
        ),
      ),
    );
  }
}
