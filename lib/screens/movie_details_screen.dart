import 'package:flutter/material.dart';
import 'booking_screen.dart';
import '../app_state.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Map movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final Color primaryRed = const Color(0xFFE51937);
  final Color darkBg = const Color(0xFF0A0A0A);
  final Color bgColor = Colors.white;

  void _showRatingDialog() {
    int selectedRating = 5;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(AppState().translate("Đánh giá phim", "Movie Review"), style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => IconButton(
                  icon: Icon(
                    index < selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => setDialogState(() => selectedRating = index + 1),
                )),
              ),
              TextField(
                controller: commentController,
                style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  hintText: AppState().translate("Nhập nhận xét của bạn...", "Enter your comment..."),
                  hintStyle: const TextStyle(color: Colors.black38),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE51937))),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(AppState().translate("Hủy", "Cancel"))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
              onPressed: () {
                setState(() {
                  AppState().addReview(widget.movie["name"], {
                    "user": "Tôi",
                    "rating": selectedRating,
                    "comment": commentController.text,
                    "movieImg": widget.movie["img"],
                    "isMe": true,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppState().translate("Cảm ơn bạn đã đánh giá!", "Thank you for your rating!"))),
                );
              },
              child: Text(AppState().translate("Gửi", "Submit"), style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        bool isFavorite = AppState().isFavorite(widget.movie);
        List<Map<String, dynamic>> reviews = AppState().getReviews(widget.movie["name"]);

        return Scaffold(
          backgroundColor: darkBg,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                color: bgColor,
                child: Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 400,
                          pinned: true,
                          backgroundColor: darkBg,
                          iconTheme: const IconThemeData(color: Colors.white),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Image.asset(widget.movie["img"], fit: BoxFit.cover),
                          ),
                          actions: [
                            IconButton(
                              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                              onPressed: () {
                                setState(() => AppState().toggleFavorite(widget.movie));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(!isFavorite 
                                    ? AppState().translate("Đã thêm vào yêu thích", "Added to favorites") 
                                    : AppState().translate("Đã xóa khỏi yêu thích", "Removed from favorites"))),
                                );
                              },
                            ),
                          ],
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.movie["name"].toString().toUpperCase(), 
                                  style: const TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 18),
                                    const SizedBox(width: 4),
                                    Text(widget.movie["rate"], style: const TextStyle(color: Colors.black54, fontSize: 16)),
                                    const SizedBox(width: 15),
                                    Text(widget.movie["type"], style: const TextStyle(color: Colors.black54)),
                                    const SizedBox(width: 15),
                                    Text(widget.movie["duration"].toString().replaceAll("Phút", AppState().translate("Phút", "Mins")), style: const TextStyle(color: Colors.black54)),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Text(AppState().translate("TÓM TẮT NỘI DUNG", "SYNOPSIS"), style: TextStyle(color: primaryRed, fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                Text(
                                  AppState().translate(
                                    "Đây là bộ phim bom tấn hấp dẫn nhất mùa hè này, mang lại những trải nghiệm cảm xúc khó quên với dàn diễn viên tài năng và kỹ xảo điện ảnh đỉnh cao.",
                                    "This is the most exciting blockbuster of this summer, bringing unforgettable emotional experiences with a talented cast and top-notch cinematography."
                                  ),
                                  style: const TextStyle(color: Colors.black87, height: 1.5),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppState().translate("ĐÁNH GIÁ TỪ CỘNG ĐỒNG", "COMMUNITY REVIEWS"), style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                                    TextButton(onPressed: _showRatingDialog, child: Text(AppState().translate("Viết đánh giá", "Write a review"), style: TextStyle(color: primaryRed))),
                                  ],
                                ),
                                const Divider(color: Colors.black12),
                                ...reviews.map((r) => Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAFAFA),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: r["isMe"] == true ? primaryRed : Colors.grey[300],
                                            child: Text(
                                              r["user"][0].toUpperCase(),
                                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        r["comment"],
                                        style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                                      ),
                                    ],
                                  ),
                                )),
                                const SizedBox(height: 120),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))
                          ]
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryRed,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(movie: widget.movie))),
                          child: Text(
                            AppState().translate("ĐÁNH GIÁ TRẢI NGHIỆM VỊ TRÍ", "RATE SEAT EXPERIENCE"), 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)
                          ),
                        ),
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
