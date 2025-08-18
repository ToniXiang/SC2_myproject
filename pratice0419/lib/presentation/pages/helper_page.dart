import 'package:flutter/material.dart';

class HelperPage extends StatelessWidget {
  const HelperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final faqs = [
      {"question": "購買需要付費嗎？", "answer": "模擬不會實際扣款。"},
      {"question": "功能不齊全？", "answer": "自己想需求和設計前後端程式需要很多時間。"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("幫助中心")),
      body: ListView.separated(
        itemCount: faqs.length,
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return ExpansionTile(
            leading: const Icon(Icons.help_outline),
            title: Text(
              faq["question"]!,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(faq["answer"]!),
              ),
            ],
          );
        },
      ),
    );
  }
}
