import 'package:flutter/material.dart';
import 'concession_screen.dart';

class BookingScreen extends StatefulWidget {
  final Map movie;
  final Map? timeData; // Nhận thêm thông tin suất chiếu từ trang trước

  const BookingScreen({super.key, required this.movie, this.timeData});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final Color darkBg = const Color(0xFF151515); // Nền tối
  final Color primaryRed = const Color(0xFFE51937); // Đỏ chủ đạo
  final Color screenGlow = Colors.orange; // Màu phát sáng của màn hình

  final int ticketPrice = 65000; // Giá 1 vé
  
  // Danh sách hàng và cột
  final List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'];
  
  // Giả lập một số ghế đã bán
  final List<String> soldSeats = ['A01', 'A02', 'B11', 'B12', 'K01', 'K02', 'K03', 'K04', 'D09', 'D10', 'E09', 'E10'];
  
  // Danh sách ghế người dùng đang chọn
  List<String> selectedSeats = [];

  //  khi bấm vào 1 ghế
  void _toggleSeat(String seatId) {
    if (soldSeats.contains(seatId)) return; // Ghế đã bán thì không làm gì cả
    
    setState(() {
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId); // Bỏ chọn
      } else {
        selectedSeats.add(seatId); // Chọn thêm
      }
    });
  }

  // --- WIDGET: TỪNG Ô GHẾ ---
  Widget _buildSeat(String row, int col) {
    String seatId = '$row${col.toString().padLeft(2, '0')}';
    bool isSold = soldSeats.contains(seatId);
    bool isSelected = selectedSeats.contains(seatId);

    // Mặc định: Ghế trống
    Color bgColor = const Color(0xFF2B2B2B); 
    Color textColor = Colors.white70;

    if (isSold) {
      bgColor = const Color(0xFF1E1E1E); // Đã bán -> Tối mờ
      textColor = Colors.white24;
    } else if (isSelected) {
      bgColor = primaryRed; // Đang chọn -> Đỏ rực
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => _toggleSeat(seatId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          seatId,
          style: TextStyle(
            color: textColor,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String movieName = widget.movie["name"] ?? "UNKNOWN";
    String timeInfo = widget.timeData != null 
        ? "2D Phụ đề tiếng Anh | ${widget.timeData!["start"]} ~ ${widget.timeData!["end"]}"
        : "2D Phụ đề tiếng Anh | 21:35~24:01"; 

    return Scaffold(
      backgroundColor: darkBg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SafeArea(
        child: Stack(
          children: [
            // ===================================
            // LỚP 1: CÁC NỘI DUNG CUỘN (APPBAR + SƠ ĐỒ GHẾ)
            // ===================================
            Positioned.fill(
              child: Column(
                children: [
                  // --- 1. HEADER  ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                movieName.toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                timeInfo,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.confirmation_num_outlined, color: Colors.white),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- 2. ĐƯỜNG KẺ "MÀN HÌNH" ĐƠN GIẢN ---
                  Container(
                    height: 2,
                    width: 280,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 8),
                  const Text("MÀN HÌNH", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                  
                  const SizedBox(height: 30),

                  // --- 3. SƠ ĐỒ GHẾ (CUỘN ĐƯỢC 2 CHIỀU) ---
                  Expanded(
                    child: InteractiveViewer( // Cho phép zoom và pan như ảnh thật
                      minScale: 0.5,
                      maxScale: 2.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: rows.map((row) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Cụm ghế bên trái (Cột 1-8)
                                for (int i = 1; i <= 8; i++) _buildSeat(row, i),
                                
                                // Lối đi ở giữa
                                const SizedBox(width: 25), 
                                
                                // Cụm ghế bên phải (Cột 9-16)
                                for (int i = 9; i <= 16; i++) _buildSeat(row, i),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  
                  // Chừa một khoảng trống bên dưới để không bị thanh Bottom Bar đè lên
                  const SizedBox(height: 120),
                ],
              ),
            ),

            // ===================================
            // LỚP 2: THANH THANH TOÁN (BOTTOM SHEET PÓP LÊN)
            // ===================================
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              bottom: selectedSeats.isNotEmpty ? 0 : -150, // Trượt xuống ẩn đi khi mảng rỗng
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Thông tin ghế và giá
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ghế ${selectedSeats.join(', ')}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Tạm tính: ${selectedSeats.length * ticketPrice} đ", 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryRed),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Nút Tiếp Tục
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConcessionScreen(
                              movie: widget.movie,
                              timeData: widget.timeData!,
                              selectedSeats: selectedSeats,
                              seatTotalPrice: selectedSeats.length * ticketPrice,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Tiếp tục", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  ),
);
  }
}