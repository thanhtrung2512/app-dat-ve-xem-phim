import 'package:flutter/material.dart';
import '../app_state.dart';
import 'my_reviews_screen.dart';

class BookingScreen extends StatefulWidget {
  final Map movie;
  final Map? timeData; 

  const BookingScreen({super.key, required this.movie, this.timeData});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final Color primaryRed = const Color(0xFFE51937); 

  final List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'];
  final List<String> soldSeats = ['A01', 'A02', 'B11', 'B12', 'K01', 'K02', 'K03', 'K04', 'D09', 'D10', 'E09', 'E10'];
  List<String> selectedSeats = [];
  double currentRating = 5;

  String _getPOVInfo(String seatId) {
    String row = seatId.substring(0, 1);
    int col = int.parse(seatId.substring(1));
    
    if (row == 'G' || row == 'H') return AppState().translate("Vị trí VIP: Tầm nhìn & âm thanh trung tâm.", "VIP Position: Central view & sound.");
    if (row == 'A' || row == 'B') return AppState().translate("Cận cảnh: Trải nghiệm màn hình cực lớn.", "Close-up: Extra large screen experience.");
    if (row == 'K' || row == 'J') return AppState().translate("Hàng cuối: Bao quát toàn rạp.", "Last row: Overview of the entire theater.");
    if (col <= 3 || col >= 14) return AppState().translate("Góc nghiêng: Cảm giác không gian lạ.", "Side view: Unique spatial sensation.");
    return AppState().translate("Tiêu chuẩn: Tầm nhìn cân bằng.", "Standard: Balanced view.");
  }

  void _toggleSeat(String seatId) {
    if (soldSeats.contains(seatId)) return; 
    setState(() {
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId); 
      } else {
        selectedSeats.clear();
        selectedSeats.add(seatId); 
      }
    });
  }

  Widget _buildSeat(String row, int col) {
    String seatId = '$row${col.toString().padLeft(2, '0')}';
    bool isSold = soldSeats.contains(seatId);
    bool isSelected = selectedSeats.contains(seatId);

    return GestureDetector(
      onTap: () => _toggleSeat(seatId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 26,
        height: 26,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSold ? Colors.black12 : (isSelected ? primaryRed : Colors.white),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isSelected ? primaryRed : Colors.black12),
          boxShadow: isSelected ? [BoxShadow(color: primaryRed.withValues(alpha: 0.3), blurRadius: 8)] : null,
        ),
        alignment: Alignment.center,
        child: Text(seatId, style: TextStyle(color: isSold ? Colors.black26 : (isSelected ? Colors.white : Colors.black54), fontSize: 7, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showSuccessTicket(Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 40),
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
                const SizedBox(height: 20),
                Text(AppState().translate("VÉ KỶ NIỆM ĐÃ SẴN SÀNG", "DIGITAL TICKET READY"), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15)],
                  ),
                  child: Column(
                    children: [
                      Text(ticket["movieName"].toString().toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ticketInfo(AppState().translate("GHẾ", "SEAT"), ticket["seats"].join(', ')),
                          _ticketInfo(AppState().translate("ĐIỂM", "SCORE"), "${ticket["average"].toStringAsFixed(1)}/5"),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      Navigator.pop(context); // Đóng bottom sheet
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyReviewsScreen()),
                      );
                    },
                    child: Text(AppState().translate("XEM TẤT CẢ VÉ", "VIEW ALL TICKETS"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ticketInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.black38, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0A), 
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                color: const Color(0xFFF9F9F9), 
                child: Column(
                  children: [
                    // Custom AppBar sắc đỏ (Banner Đỏ)
                    Container(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 20),
                      decoration: BoxDecoration(
                        color: primaryRed,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                        boxShadow: [BoxShadow(color: primaryRed.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), 
                            onPressed: () => Navigator.pop(context)
                          ),
                          Expanded(
                            child: Text(
                              widget.movie["name"].toString().toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 30),
                              Container(height: 4, width: 220, decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(2))),
                              const SizedBox(height: 8),
                              Text(AppState().translate("MÀN HÌNH", "SCREEN"), style: const TextStyle(color: Colors.black26, fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 40),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Column(
                                      children: [
                                        for (var row in rows)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              for (int i = 1; i <= 8; i++) _buildSeat(row, i),
                                              const SizedBox(width: 15), 
                                              for (int i = 9; i <= 16; i++) _buildSeat(row, i),
                                            ],
                                          ),
                                        const SizedBox(height: 120),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Control Panel
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: selectedSeats.isNotEmpty ? 240 : 0,
                              padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5))],
                              ),
                              child: selectedSeats.isEmpty ? const SizedBox() : SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${AppState().translate("Ghế", "Seat")} ${selectedSeats.first}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black)),
                                        Text(_getPOVInfo(selectedSeats.first), style: const TextStyle(color: Colors.black45, fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Text(AppState().translate("Chấm điểm trải nghiệm vị trí này", "Rate your experience at this seat"), style: const TextStyle(color: Colors.black38, fontSize: 13)),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(5, (index) => IconButton(
                                        onPressed: () => setState(() => currentRating = (index + 1).toDouble()),
                                        icon: Icon(index < currentRating ? Icons.star : Icons.star_border, color: primaryRed, size: 30),
                                      )),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryRed, 
                                        minimumSize: const Size(double.infinity, 55), 
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        elevation: 8,
                                        shadowColor: primaryRed.withValues(alpha: 0.4),
                                      ),
                                      onPressed: () {
                                        final ticket = {
                                          "movieName": widget.movie["name"],
                                          "img": widget.movie["img"],
                                          "date": DateTime.now().toString().split(' ')[0],
                                          "seats": selectedSeats,
                                          "average": currentRating,
                                        };
                                        AppState().addDigitalTicket(ticket);
                                        _showSuccessTicket(ticket);
                                      },
                                      child: Text(AppState().translate("XÁC NHẬN & LƯU VÉ", "CONFIRM & SAVE TICKET"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}