import 'package:better_way/feature/home/sections/cost_section.dart';
import 'package:better_way/feature/home/sections/fee_section.dart';
import 'package:better_way/feature/home/sections/result_section.dart';
import 'package:better_way/feature/home/sections/selling_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(context, ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('상품 수익 분석기')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SellingSection(),
            SizedBox(height: 24),
            CostSection(),
            SizedBox(height: 24),
            FeeSection(),
            SizedBox(height: 32),
            Divider(),
            SizedBox(height: 32),
            ResultSection(),
          ],
        ),
      ),
    );
  }
}
