import 'package:flutter/material.dart';
import 'success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map? movie;
  final Map? timeData;
  final List<String>? selectedSeats;
  final List<Map<String, dynamic>>? selectedCombos;
  final int totalPrice;
  
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

  // --- WIDGET CHỌN PHƯƠNG THỨC GỌN GÀNG ---
  Widget _buildPaymentOption(IconData icon, String label, String methodId) {
    bool isSelected = selectedMethod == methodId;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = methodId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryRed : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isSelected ? primaryRed : Colors.black45),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? primaryRed : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: primaryRed, size: 20)
            else
              const Icon(Icons.circle_outlined, color: Colors.black12, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              // --- HEADER ĐỒNG BỘ VỚI CONCESSION SCREEN ---
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
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- CHI TIẾT ĐƠN HÀNG GỘP ---
                        const Text("CHI TIẾT ĐƠN HÀNG", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black38, letterSpacing: 1)),
                        const SizedBox(height: 16),
                        
                        if (widget.movie != null) ...[
                          Text(widget.movie!["name"].toString().toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, height: 1.2)),
                          const SizedBox(height: 8),
                          Text(
                            "${widget.timeData?["start"]} • ${widget.timeData?["room"]} • Ghế ${widget.selectedSeats?.join(', ')}",
                            style: const TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        ] else if (widget.giftItem != null) ...[
                          Text(widget.giftItem!["name"].toString().toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, height: 1.2)),
                          const SizedBox(height: 8),
                          Text("Số lượng: ${widget.quantity}", style: const TextStyle(color: Colors.black54, fontSize: 14)),
                        ],

                        // --- LIST COMBO HIỂN THỊ DẠNG TEXT GỌN ---
                        if (widget.selectedCombos != null && widget.selectedCombos!.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: Colors.black12),
                          ),
                          ...widget.selectedCombos!.map((combo) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${combo["name"]} x${combo["quantity"]}", style: const TextStyle(color: Colors.black54, fontSize: 14)),
                                Text("${combo["onlinePrice"]}đ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black38)),
                              ],
                            ),
                          )),
                        ],

                        const SizedBox(height: 40),

                        // --- PHƯƠNG THỨC THANH TOÁN ---
                        const Text("PHƯƠNG THỨC THANH TOÁN", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black38, letterSpacing: 1)),
                        const SizedBox(height: 16),
                        _buildPaymentOption(Icons.credit_card, "Thẻ tín dụng / Ghi nợ", "credit"),
                        _buildPaymentOption(Icons.account_balance, "Thẻ nội địa (ATM)", "atm"),
                        _buildPaymentOption(Icons.account_balance_wallet, "Ví điện tử (Momo, ZaloPay)", "wallet"),

                        const SizedBox(height: 40),
                        
                        // --- MÃ GIẢM GIÁ ---
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "Nhập mã giảm giá (nếu có)",
                              hintStyle: TextStyle(fontSize: 14, color: Colors.black26),
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.confirmation_number_outlined, size: 20, color: Colors.black26),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- THANH THANH TOÁN DƯỚI ĐÁY ĐỒNG BỘ ---
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
                          const Text("TỔNG CỘNG", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black38)),
                          const SizedBox(height: 4),
                          Text(
                            "${widget.totalPrice} đ",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: primaryRed),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: selectedMethod != null ? () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SuccessScreen()));
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryRed,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.black12,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text("XÁC NHẬN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
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

