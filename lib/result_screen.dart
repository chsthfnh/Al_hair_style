import 'package:flutter/material.dart';
import 'recommendation_data.dart';

class ResultScreen extends StatelessWidget {
  final String faceShape;
  final String skinTone;
  const ResultScreen({
    Key? key,
    required this.faceShape,
    required this.skinTone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final advice = RecommendationData.hairAdvice[faceShape];
    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả tư vấn')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              faceShape,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
              ),
            ),
            Text(skinTone, style: const TextStyle(color: Colors.orangeAccent)),
            const Divider(height: 40),
            if (advice != null) ...[
              Text(advice['description'], style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              _buildList(
                'Kiểu tóc hợp:',
                advice['good_hairstyles'],
                Colors.greenAccent,
              ),
              _buildList(
                'Kiểu tóc nên tránh:',
                advice['bad_hairstyles'],
                Colors.redAccent,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildList(String title, List items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...items.map(
          (i) => ListTile(
            leading: Icon(Icons.check_circle, color: color, size: 18),
            title: Text(i),
          ),
        ),
      ],
    );
  }
}
