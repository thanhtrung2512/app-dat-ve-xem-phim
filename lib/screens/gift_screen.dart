import 'package:flutter/material.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quà tặng"),
        backgroundColor: const Color(0xFFE51937),
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red[50],
                    child: const Icon(Icons.card_giftcard, size: 40, color: Color(0xFFE51937)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Voucher ${100*(index+1)}k", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text("80.000 đ", style: TextStyle(color: Color(0xFFE51937), fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
