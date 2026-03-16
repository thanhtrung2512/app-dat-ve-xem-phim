import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  final int quantity;

  const PaymentScreen({
    super.key,
    required this.item,
    required this.quantity,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE51937);
    final int priceVal = int.parse(widget.item["price"].replaceAll(RegExp(r'[^0-9]'), ''));
    final int totalAmount = priceVal * widget.quantity;
    final String formattedTotal = "${totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
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
                            child: Text(
                              "Thanh toán",
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

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // --- TÓM TẮT SẢN PHẨM ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail Vé
                          Container(
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: _buildMiniTicket(widget.item),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Thông tin
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.item["name"],
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                                ),
                                const SizedBox(height: 4),
                                Text("Số lượng: ${widget.quantity}", style: const TextStyle(color: Colors.black54)),
                                const SizedBox(height: 2),
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(color: Colors.black54, fontSize: 13),
                                    children: [
                                      TextSpan(text: "Hạn sử dụng:"),
                                      TextSpan(text: " Quà tặng online", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                    ],
                                  ),
                                ),
                                const Text("2026-03-16 ~ 2027-03-16", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 12),
                                Text(
                                  formattedTotal,
                                  style: const TextStyle(fontSize: 16, color: primaryRed, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // --- PHƯƠNG THỨC THANH TOÁN ---
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          _buildPaymentOption(Icons.credit_card, "Thẻ tín dụng"),
                          _buildPaymentOption(Icons.account_balance, "Thẻ nội địa (ATM)"),
                          _buildPaymentOption(Icons.account_balance_wallet, "Ví điện tử", subtitle: "Momo, VNPay, Zalopay, ShopeePay"),
                          _buildPaymentOption(Icons.history_edu, "Ví trả sau", subtitle: "Lotte C&F, Muadee, Fundiin, Home Paylat..."),
                          _buildPaymentOption(Icons.qr_code_scanner, "VietQR", isLast: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- BOTTOM BAR ---
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
                ),
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Agreement Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _isAgreed,
                            onChanged: (v) => setState(() => _isAgreed = v ?? false),
                            activeColor: primaryRed,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                                children: [
                                  TextSpan(text: "Tôi đã đọc và đồng ý với "),
                                  TextSpan(text: "Điều kiện & Điều khoản", style: TextStyle(color: primaryRed, decoration: TextDecoration.underline)),
                                  TextSpan(text: ", cam kết mua vé xem phim cho người đúng độ tuổi quy định"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Price & Pay Button
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Tổng Tiền", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Row(
                                  children: [
                                    Text(
                                      formattedTotal,
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryRed),
                                    ),
                                    const Icon(Icons.keyboard_arrow_up, color: Colors.black54),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isAgreed ? () {} : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryRed,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey.shade300,
                                minimumSize: const Size(double.infinity, 54),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Text("Thanh toán", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
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

  Widget _buildPaymentOption(IconData icon, String title, {String? subtitle, bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Icon(icon, color: Colors.black87, size: 28),
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black45)) : null,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black26),
          onTap: () {},
        ),
        if (!isLast) const Divider(height: 1, indent: 20, endIndent: 20, color: Colors.black12),
      ],
    );
  }

  Widget _buildMiniTicket(Map<String, dynamic> item) {
    final Color bgColor = Color(item["bgColor"]);
    final Color textColor = Color(item["textColor"]);
    final bool isCharlotte = item["label"] == "CHARLOTTE";
    
    return Container(
      color: bgColor,
      child: Center(
        child: isCharlotte 
          ? Text("CHARLOTTE", style: TextStyle(color: textColor, fontSize: 8, letterSpacing: 1, fontWeight: FontWeight.bold))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("GIFT", style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
                Text("TICKET", style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
      ),
    );
  }
}
