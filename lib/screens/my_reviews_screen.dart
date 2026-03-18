import 'package:flutter/material.dart';
import '../app_state.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  final Color darkBg = const Color(0xFF0A0A0A);
  final Color primaryRed = const Color(0xFFE51937);
  final Color bgColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        List<Map<String, dynamic>> myReviews = [];
        AppState().movieReviews.forEach((movieName, reviews) {
          for (var r in reviews) {
            if (r["isMe"] == true) {
              myReviews.add({...r, "movieName": movieName});
            }
          }
        });

        List<Map<String, dynamic>> myTickets = AppState().getMyTickets();

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: darkBg,
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  color: bgColor,
                  child: Column(
                    children: [
                      _buildAppBarLocal(),
                      TabBar(
                        labelColor: const Color(0xFFE51937),
                        unselectedLabelColor: Colors.black38,
                        indicatorColor: const Color(0xFFE51937),
                        indicatorWeight: 3,
                        tabs: [
                          Tab(text: AppState().translate("ĐÁNH GIÁ NỘI DUNG", "MOVIE REVIEWS")),
                          Tab(text: AppState().translate("BỘ SƯU TẬP VÉ", "TICKET COLLECTION")),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Tab 1: Đánh giá nội dung
                            myReviews.isEmpty
                                ? _buildEmptyState(Icons.rate_review_outlined, AppState().translate("Bạn chưa có đánh giá nào", "You have no reviews yet"))
                                : ListView.separated(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: myReviews.length,
                                    separatorBuilder: (context, index) => const SizedBox(height: 24),
                                    itemBuilder: (context, index) => _buildReviewItem(myReviews[index]),
                                  ),
                            // Tab 2: Bộ sưu tập vé
                            myTickets.isEmpty
                                ? _buildEmptyState(Icons.confirmation_num_outlined, AppState().translate("Bạn chưa sưu tập được vé nào", "You have no tickets collected"))
                                : ListView.builder(
                                    padding: const EdgeInsets.all(20),
                                    itemCount: myTickets.length,
                                    itemBuilder: (context, index) => _buildTicketItem(myTickets[index]),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black12, size: 80),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.black38, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildAppBarLocal() {
    return Container(
      color: primaryRed,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    AppState().translate("TRẢI NGHIỆM CỦA TÔI", "MY EXPERIENCE"),
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> r) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ảnh phim bên trái
            if (r["movieImg"] != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                child: Image.asset(
                  r["movieImg"],
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            (r["movieName"] ?? AppState().translate("Phim", "Movie")).toString().toUpperCase(),
                            style: TextStyle(color: primaryRed, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.8),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                "${r["rating"]}.0",
                                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 12, color: Colors.black38),
                        const SizedBox(width: 4),
                        Text(r["time"] ?? AppState().translate("Vừa xong", "Just now"), style: const TextStyle(color: Colors.black38, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Colors.black12),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        r["comment"],
                        style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.5, fontStyle: FontStyle.italic),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketItem(Map<String, dynamic> ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 15, offset: const Offset(0, 5))],
        border: Border.all(color: Colors.black.withValues(alpha: 0.02)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(ticket["img"], height: 140, width: double.infinity, fit: BoxFit.cover),
                Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)])))),
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Text(
                    ticket["movieName"].toString().toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _ticketSmallInfo(AppState().translate("GHẾ", "SEAT"), ticket["seats"].join(', ')),
                  const Spacer(),
                  _ticketSmallInfo(AppState().translate("NGÀY", "DATE"), ticket["date"]),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(AppState().translate("TRẢI NGHIỆM", "EXPERIENCE"), style: const TextStyle(color: Colors.black26, fontSize: 9, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.stars, color: Color(0xFFE51937), size: 14),
                          const SizedBox(width: 4),
                          Text("${ticket["average"].toStringAsFixed(1)}/5", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketSmallInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black26, fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}
