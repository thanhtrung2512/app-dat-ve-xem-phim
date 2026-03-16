import 'package:flutter/material.dart';
import 'success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map? movie;
  final Map? timeData;
  final List<String>? selectedSeats;
  final List<Map<String, dynamic>>? selectedCombos;
  final int totalPrice;
  
  // For Gift purchases
  final Map<String, dynamic>? giftItem;
  final int? quantity;

  const PaymentScreen({
    super.key,
    this.movie,
    this.timeData,
    this.selectedSeats,
    this.selectedCombos,
    required this.totalPrice,
    this.giftItem,
    this.quantity,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Color primaryRed = const Color(0xFFE51937);
  final Color darkBg = const Color(0xFF0A0A0A);
  String? selectedMethod;

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(IconData icon, String label, String methodId) {
    bool isSelected = selectedMethod == methodId;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = methodId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryRed : Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? primaryRed.withValues(alpha: 0.1) : Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: isSelected ? primaryRed : Colors.black54),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: primaryRed, size: 26)
            else
              Icon(Icons.circle_outlined, color: Colors.black.withValues(alpha: 0.1), size: 26),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Nền bên ngoài màu đen
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            color: const Color(0xFFF9F9F9), // Nền bên trong màu trắng/xám nhạt
            child: Column(
              children: [
                // --- HEADER ---
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
                            child: Text("Thanh toán", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- THÔNG TIN PHIM HOẶC QUÀ TẶNG ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                        ),
                        child: widget.movie != null ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                widget.movie!["img"],
                                width: 85,
                                height: 125,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.movie!["name"].toString().toUpperCase(),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildInfoItem(Icons.access_time, "${widget.timeData?["start"] ?? ""} ~ ${widget.timeData?["end"] ?? ""}"),
                                  const SizedBox(height: 4),
                                  _buildInfoItem(Icons.meeting_room_outlined, widget.timeData?["room"] ?? "Rạp 1"),
                                  const SizedBox(height: 4),
                                  _buildInfoItem(Icons.location_on_outlined, "TT CINEMA Hà Đông"),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Ghế: ${widget.selectedSeats?.join(', ') ?? ""}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: primaryRed),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ) : (widget.giftItem != null ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Color(widget.giftItem!["bgColor"]).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(widget.giftItem!["bgColor"]).withValues(alpha: 0.2)),
                              ),
                              child: Center(
                                child: Icon(Icons.card_giftcard, color: Color(widget.giftItem!["bgColor"]), size: 40),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.giftItem!["name"],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.giftItem!["subtitle"] ?? "",
                                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Số lượng: ${widget.quantity}",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ) : const SizedBox()),
                      ),

                      // --- THÔNG TIN COMBO (NẾU CÓ) ---
                      if (widget.selectedCombos != null && widget.selectedCombos!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.fastfood_outlined, size: 20, color: Colors.black54),
                                  const SizedBox(width: 8),
                                  const Text("Bắp & Nước", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black54)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...widget.selectedCombos!.map((combo) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: combo["img"] != null
                                          ? Image.asset(
                                              combo["img"],
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 50,
                                              height: 50,
                                              color: Colors.grey[100],
                                              child: const Icon(Icons.fastfood, size: 24, color: Colors.black26),
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${combo["name"]} (x${combo["quantity"]})",
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${combo["onlinePrice"]} đ",
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],

                      // --- PHƯƠNG THỨC THANH TOÁN ---
                      _buildSectionTitle("Phương thức thanh toán"),
                      
                      _buildPaymentMethod(Icons.credit_card_outlined, "Thẻ tín dụng", "credit"),
                      _buildPaymentMethod(Icons.account_balance_outlined, "Thẻ nội địa (ATM)", "atm"),
                      _buildPaymentMethod(Icons.account_balance_wallet_outlined, "Ví điện tử", "wallet"),

                      const SizedBox(height: 120), 
                    ],
                  ),
                ),
              ),

              // --- BOTTOM BAR ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -5))],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Tổng Tiền", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
                            const SizedBox(height: 4),
                            Text(
                              "${widget.totalPrice} đ",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryRed),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (selectedMethod != null) ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SuccessScreen()),
                          );
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryRed,
                          disabledBackgroundColor: Colors.grey[200],
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
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
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.black38),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.black54, fontSize: 13)),
      ],
    );
  }
}
