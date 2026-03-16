import 'package:flutter/material.dart';
import 'payment_screen.dart';

class GiftDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const GiftDetailScreen({super.key, required this.item});

  @override
  State<GiftDetailScreen> createState() => _GiftDetailScreenState();
}

class _GiftDetailScreenState extends State<GiftDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE51937);

    return Scaffold(
      backgroundColor: Colors.white,
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

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // --- ẢNH VÉ NỔI ---
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                      color: Colors.white,
                      child: Center(
                        child: SizedBox(
                          width: 280,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildTicketDetailImage(widget.item),
                          ),
                        ),
                      ),
                    ),

                    // --- TIÊU ĐỀ VÀ GIÁ ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item["name"],
                            style: const TextStyle(fontSize: 22, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.item["price"],
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- BỘ CHỌN SỐ LƯỢNG VÀ NÚT MUA ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          // Selector
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                _buildQtyBtn(Icons.remove, () {
                                  if (_quantity > 1) setState(() => _quantity--);
                                }),
                                Container(
                                  width: 40,
                                  alignment: Alignment.center,
                                  child: Text("$_quantity", style: const TextStyle(fontSize: 16)),
                                ),
                                _buildQtyBtn(Icons.add, () {
                                  setState(() => _quantity++);
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Nút Mua
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      item: widget.item,
                                      quantity: _quantity,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryRed,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 48),
                                shape: RoundedRectangleMethod(),
                                elevation: 0,
                              ),
                              child: const Text("Mua ngay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- TABS ---
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black54,
                      indicatorColor: primaryRed,
                      indicatorWeight: 3,
                      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(text: "Nội dung chi tiết"),
                        Tab(text: "Hướng dẫn sử dụng"),
                      ],
                    ),
                    const Divider(height: 1, color: Colors.black12),

                    // --- TAB CONTENT (Sử dụng SizedBox để tránh lỗi ListView lồng nhau) ---
                    SizedBox(
                      height: 500, // Đủ để hiển thị text
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildDetailContent(),
                          _buildUsageContent(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RoundedRectangleBorder RoundedRectangleMethod() => RoundedRectangleBorder(borderRadius: BorderRadius.circular(24));

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.black38, size: 20),
      ),
    );
  }

  Widget _buildDetailContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Nội dung sản phẩm", "Quà tặng online 1EA"),
          const SizedBox(height: 16),
          _buildInfoRow("Số lượng mua tối\nthiểu", "Không giới hạn"),
          const SizedBox(height: 16),
          _buildInfoRow("Hạn sử dụng", "Quà tặng online 12\ntháng"),
          const SizedBox(height: 24),
          const Text("Giải thích", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 150, child: Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black54))),
      ],
    );
  }

  Widget _buildUsageContent() {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        Text("Use Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Text("- Phiếu quà tặng có thể đổi thành 1 vé xem phim cho các bộ phim định dạng 2D phòng chiếu Super Plex tại LC Gò Vấp", style: TextStyle(height: 1.5)),
        SizedBox(height: 8),
        Text("- Phiếu quà tặng không áp dụng phòng chiếu khác: Charlotte, Cine Comfort...", style: TextStyle(height: 1.5)),
        SizedBox(height: 24),
        Text("Cancel/Refund", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Text("- Phiếu quà tặng dành cho 1 người, không được nhượng bán, quy đổi thành tiền hoặc hàng hóa", style: TextStyle(height: 1.5)),
        SizedBox(height: 8),
        Text("- Phiếu quà tặng không hỗ trợ đổi trả và hoàn tiền", style: TextStyle(height: 1.5)),
        SizedBox(height: 24),
        Text("ETC", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Text("- Mọi thông tin chi tiết vui lòng liên hệ qua trung tâm chăm sóc khách hàng.", style: TextStyle(height: 1.5)),
        SizedBox(height: 12),
        Text("- Hoặc gọi vào số (028) 3775 2524", style: TextStyle(height: 1.5)),
      ],
    );
  }

  Widget _buildTicketDetailImage(Map<String, dynamic> item) {
    final Color bgColor = Color(item["bgColor"]);
    final Color textColor = Color(item["textColor"]);
    final bool isCharlotte = item["label"] == "CHARLOTTE";

    return Container(
      height: 120,
      width: double.infinity,
      color: bgColor,
      child: isCharlotte
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "CHARLOTTE",
                    style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w300, letterSpacing: 6),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fiber_manual_record, color: textColor.withValues(alpha: 0.5), size: 10),
                      const SizedBox(width: 4),
                      Text("TT CINEMA", style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 11, letterSpacing: 2)),
                    ],
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Positioned(
                  left: 20,
                  top: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("MOVIE", style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w900, height: 0.9, letterSpacing: -1)),
                      Text("GIFT", style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w900, height: 0.9, letterSpacing: -1)),
                      Text("TICKET", style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w900, height: 0.9, letterSpacing: -1)),
                    ],
                  ),
                ),
                if (item["tag"] != "" && item["tag"] != "cineComfort")
                  Positioned(
                    top: 10,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      color: Colors.white.withValues(alpha: 0.9),
                      child: Text(item["tag"], textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ),
                  ),
                if (item["tag"] == "cineComfort")
                  Positioned(
                    top: 10,
                    right: 14,
                    child: Text("cineComfort", style: TextStyle(color: textColor.withValues(alpha: 0.8), fontSize: 11, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600)),
                  ),
                Positioned(
                  bottom: 14,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item["label"], style: TextStyle(color: textColor.withValues(alpha: 0.9), fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.fiber_manual_record, color: const Color(0xFFE51937), size: 7),
                          const SizedBox(width: 4),
                          Text("TT CINEMA", style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 8, letterSpacing: 1)),
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
