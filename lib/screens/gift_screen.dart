import 'package:flutter/material.dart';
import 'payment_screen.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({super.key});

  // Dữ liệu mẫu quà tặng
  static const List<Map<String, dynamic>> _bestSellers = [
    {
      "name": "VÉ SUPER PLEX",
      "subtitle": "Hạn sử dụng | 12 tháng",
      "price": "150.000 đ",
      "bgColor": 0xFF8EC5E6,
      "textColor": 0xFF1A4A7C,
      "label": "VÉ QUÀ TẶNG SUPER PLEX 2D",
      "tag": "SUPER\nPLEX",
    },
    {
      "name": "VÉ CHARTLOTTE",
      "subtitle": "Hạn sử dụng | 12 tháng",
      "price": "370.000 đ",
      "bgColor": 0xFF111111,
      "textColor": 0xFFD4AF37,
      "label": "CHARLOTTE",
      "tag": "",
    },
  ];

  static const List<Map<String, dynamic>> _allGifts = [
    {
      "name": "VÉ CHARTLOTTE",
      "subtitle": "Hạn sử dụng | 12 tháng",
      "price": "370.000 đ",
      "bgColor": 0xFF111111,
      "textColor": 0xFFD4AF37,
      "label": "CHARLOTTE",
      "tag": "",
    },
    {
      "name": "VÉ CINE COMFORT",
      "subtitle": "Hạn sử dụng | 12 tháng",
      "price": "190.000 đ",
      "bgColor": 0xFFFFF3C4,
      "textColor": 0xFFE07B39,
      "label": "VÉ QUÀ TẶNG PHIM 2D",
      "tag": "cineComfort",
    },
    {
      "name": "VÉ SUPER PLEX",
      "subtitle": "Hạn sử dụng | 12 tháng",
      "price": "150.000 đ",
      "bgColor": 0xFF8EC5E6,
      "textColor": 0xFF1A4A7C,
      "label": "VÉ QUÀ TẶNG SUPER PLEX 2D",
      "tag": "SUPER\nPLEX",
    },
    {
      "name": "VÉ STANDARD 2D",
      "subtitle": "Hạn sử dụng | 12 tháng",
      "price": "90.000 đ",
      "bgColor": 0xFFCC1F37,
      "textColor": 0xFFFFD700,
      "label": "VÉ QUÀ TẶNG PHIM 2D",
      "tag": "",
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE51937);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              // --- HEADER ĐỎ ---
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
                            child: Text(
                              "Quà tặng",
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
              ),

              // --- DANH SÁCH ---
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  children: [
                    // MỤC BÁN CHẠY NHẤT
                    const Text(
                      "Bán chạy nhất",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    ..._bestSellers.map((item) => _buildGiftCard(context, item)),

                    const SizedBox(height: 8),
                    const Divider(height: 24, color: Colors.black12),

                    // TẤT CẢ QUÀ TẶNG
                    const Text(
                      "Tất cả quà tặng",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    ..._allGifts.map((item) => _buildGiftCard(context, item)),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGiftCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ẢNH VÉ NHỎ CÓ PADDING LỚN HƠN
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 20, 32, 10),
            child: Center(
              child: SizedBox(
                width: 220, // Giới hạn chiều rộng vé
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildTicketImage(item),
                ),
              ),
            ),
          ),

          // THÔNG TIN VÉ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["name"],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["subtitle"],
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          giftItem: item,
                          quantity: 1,
                          totalPrice: int.parse(item["price"].replaceAll(RegExp(r'[^0-9]'), '')),
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE51937),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item["price"],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketImage(Map<String, dynamic> item) {
    final Color bgColor = Color(item["bgColor"]);
    final Color textColor = Color(item["textColor"]);
    final bool isCharlotte = item["label"] == "CHARLOTTE";

    return Container(
      height: 90,
      width: double.infinity,
      color: bgColor,
      child: isCharlotte
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "CHARLOTTE",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fiber_manual_record, color: textColor.withValues(alpha: 0.5), size: 10),
                      const SizedBox(width: 4),
                      Text(
                        "TT CINEMA",
                        style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 11, letterSpacing: 2),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Chữ MOVIE GIFT TICKET
                Positioned(
                  left: 16,
                  top: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MOVIE",
                        style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w900, height: 0.9, letterSpacing: -1),
                      ),
                      Text(
                        "GIFT",
                        style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w900, height: 0.9, letterSpacing: -1),
                      ),
                      Text(
                        "TICKET",
                        style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w900, height: 0.9, letterSpacing: -1),
                      ),
                    ],
                  ),
                ),
                // Tag góc trên phải
                if (item["tag"] != "" && item["tag"] != "cineComfort")
                  Positioned(
                    top: 10,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      color: Colors.white.withValues(alpha: 0.9),
                      child: Text(
                        item["tag"],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                if (item["tag"] == "cineComfort")
                  Positioned(
                    top: 10,
                    right: 14,
                    child: Text(
                      "cineComfort",
                      style: TextStyle(color: textColor.withValues(alpha: 0.8), fontSize: 11, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
                    ),
                  ),
                // Nhãn phụ dưới
                Positioned(
                  bottom: 14,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["label"],
                        style: TextStyle(color: textColor.withValues(alpha: 0.9), fontSize: 8, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.fiber_manual_record, color: const Color(0xFFE51937), size: 6),
                          const SizedBox(width: 4),
                          Text(
                            "TT CINEMA",
                            style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 7, letterSpacing: 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
