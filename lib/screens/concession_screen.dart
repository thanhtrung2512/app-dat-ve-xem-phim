import 'package:flutter/material.dart';
import 'payment_screen.dart';

class ConcessionScreen extends StatefulWidget {
  final Map movie;
  final Map timeData;
  final List<String> selectedSeats;
  final int seatTotalPrice;

  const ConcessionScreen({
    super.key,
    required this.movie,
    required this.timeData,
    required this.selectedSeats,
    required this.seatTotalPrice,
  });

  @override
  State<ConcessionScreen> createState() => _ConcessionScreenState();
}

class _ConcessionScreenState extends State<ConcessionScreen> {
  final Color primaryRed = const Color(0xFFE51937);
  final Color darkBg = const Color(0xFF0A0A0A);
  
  // Dữ liệu mẫu Combo với ảnh
  final List<Map<String, dynamic>> combos = [
    {
      "name": "Hot Sale Only Online",
      "price": 99000,
      "onlinePrice": "99.000",
      "img": "assets/images/bn.png", 
      "contents": ["[A]Original (L)", "[A]Pepsi (L)"],
      "quantity": 1,
    },
    {
      "name": "[A]CB1 Ma Tieu Da Keyring",
      "price": 189000,
      "onlinePrice": "189.000",
      "img": "assets/images/bn.png",
      "contents": ["1 Bắp L + 1 Nước L + 1 Keyring"],
      "quantity": 0,
    },
    {
      "name": "XXXL Popcorn Super Size_Onl",
      "price": 99000,
      "onlinePrice": "99.000",
      "img": "assets/images/bn.png",
      "contents": ["1 Bắp XXXL"],
      "quantity": 0,
    },
    {
      "name": "[A] Pizza Combo 1",
      "price": 145000,
      "onlinePrice": "145.000",
      "img": "assets/images/bn.png",
      "contents": ["1 Pizza + 1 Nước L"],
      "quantity": 0,
    },
  ];

  int getTotalFoodPrice() {
    int total = 0;
    for (var combo in combos) {
      int price = combo["price"] is int ? combo["price"] : 0;
      int quantity = combo["quantity"] is int ? combo["quantity"] : 0;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    int totalFoodPrice = getTotalFoodPrice();
    int finalTotal = widget.seatTotalPrice + totalFoodPrice;

    return Scaffold(
      backgroundColor: darkBg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              // --- HEADER CUSTOM ĐỒNG BỘ ---
              Container(
                color: primaryRed,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text("Combo bắp & nước", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
              ),

              // --- DANH SÁCH COMBO ---
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: combos.length,
                    itemBuilder: (context, index) {
                      final combo = combos[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 2))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: combo["img"] != null 
                                    ? Image.asset(
                                        combo["img"],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 80, height: 80, color: Colors.grey[200],
                                          child: const Icon(Icons.fastfood, color: Colors.grey),
                                        ),
                                      )
                                    : Container(
                                        width: 80, height: 80, color: Colors.grey[200],
                                        child: const Icon(Icons.fastfood, color: Colors.grey),
                                      ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(combo["name"] ?? "Combo", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text("Giá online: ${combo["onlinePrice"] ?? "0"} đ", style: const TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      combo["quantity"]++;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    side: const BorderSide(color: Colors.black12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  child: const Text("Đặt", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (combo["contents"] != null)
                              ...List.generate((combo["contents"] as List).length, (i) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text("• ${combo["contents"][i]}", style: const TextStyle(color: Colors.black87, fontSize: 13)),
                              )),
                            if ((combo["quantity"] ?? 0) > 0) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Tổng Tiền:${combo["onlinePrice"] ?? "0"} đ", style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold, fontSize: 14)),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        combo["quantity"] = 0;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // --- THANH THANH TOÁN DƯỚI ĐÁY ĐÃ CĂN CHỈNH ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${widget.selectedSeats.length} Ghế, ${combos.fold(0, (sum, item) => sum + (item["quantity"] as int))} Combo",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${finalTotal.toString()} đ",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryRed),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          List<Map<String, dynamic>> selectedCombos = combos.where((c) => (c["quantity"] ?? 0) > 0).toList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                movie: widget.movie,
                                timeData: widget.timeData,
                                selectedSeats: widget.selectedSeats,
                                selectedCombos: selectedCombos,
                                totalPrice: finalTotal,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryRed,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text("Thanh toán", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
