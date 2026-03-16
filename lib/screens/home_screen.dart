import 'dart:async';
import 'package:flutter/material.dart';
import 'movie_screen.dart';
import 'showtime_screen.dart'; // Đã import ShowtimeScreen
import 'gift_screen.dart'; // Import màn hình Quà tặng

// ==========================================
// 1. CÁC TRANG DUMMY (CÁC TRANG ĐÍCH KHI BẤM NÚT)
// ==========================================
class MovieDetailScreen extends StatelessWidget {
  final Map movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie["name"]), backgroundColor: const Color(0xFF0A0A0A)),
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(movie["img"], height: 400, fit: BoxFit.fill), 
            ),
            const SizedBox(height: 20),
            Text(movie["name"], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
            const SizedBox(height: 10),
            Text("Thể loại: ${movie["type"]}", style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class TicketPage extends StatelessWidget { const TicketPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Vé của tôi"), backgroundColor: const Color(0xFF0A0A0A)), backgroundColor: const Color(0xFF0A0A0A), body: const Center(child: Text("Danh sách vé của bạn", style: TextStyle(color: Colors.white, fontSize: 18)))); }
class ProfilePage extends StatelessWidget { const ProfilePage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Hồ sơ"), backgroundColor: const Color(0xFF0A0A0A)), backgroundColor: const Color(0xFF0A0A0A), body: const Center(child: Text("Thông tin cá nhân", style: TextStyle(color: Colors.white, fontSize: 18)))); }
// GiftScreen đã được chuyển sang gift_screen.dart
class CinemaPage extends StatelessWidget { const CinemaPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Hệ thống Rạp"), backgroundColor: const Color(0xFF0A0A0A)), backgroundColor: const Color(0xFF0A0A0A), body: const Center(child: Text("Danh sách Rạp TT CINEMA", style: TextStyle(color: Colors.white, fontSize: 18)))); }
class PromotionScreen extends StatelessWidget { const PromotionScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Khuyến mãi"), backgroundColor: const Color(0xFF0A0A0A)), backgroundColor: const Color(0xFF0A0A0A), body: const Center(child: Text("Các chương trình khuyến mãi", style: TextStyle(color: Colors.white, fontSize: 18)))); }


// ==========================================
// 2. MÀN HÌNH CHÍNH (HOME SCREEN)
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController promoController;
  late PageController movieController;

  int promoIndex = 3000;
  int movieIndex = 3000; 
  late Timer promoTimer;

  // BẢNG MÀU SANG TRỌNG (ĐEN - ĐỎ ĐÔ)
  final Color darkBg = const Color(0xFF0A0A0A);
  final Color rubyRed = const Color(0xFF8B0000); 
  final Color darkCard = const Color(0xFF151515);

  List promoImages = [
    "assets/images/km.jpg", 
    "assets/images/km.jpg",
    "assets/images/km.jpg",
  ];

  List movies = [
    {
      "name": "PIRATES OF THE CARIBBEAN",
      "img": "assets/images/km.jpg", 
      "rate": "8.8",
      "type": "Hành động",
      "duration": "140 Phút",
      "date": "10/02/2026"
    },
    {
      "name": "QUỶ NHẬP TRÀNG",
      "img": "assets/images/QNT.jpeg", 
      "rate": "8.5",
      "type": "Kinh dị",
      "duration": "120 Phút",
      "date": "10/02/2026"
    },
    {
      "name": "LẬT MẶT",
      "img": "assets/images/QNT.jpeg", 
      "rate": "8.2",
      "type": "Hành động",
      "duration": "115 Phút",
      "date": "20/02/2026"
    },
  ];

  @override
  void initState() {
    super.initState();
    promoController = PageController(viewportFraction: 0.60, initialPage: promoIndex);
    movieController = PageController(viewportFraction: 0.65, initialPage: movieIndex);

    promoTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (promoController.hasClients) {
        setState(() {
          promoIndex++;
        });
        promoController.animateToPage(
          promoIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    promoTimer.cancel();
    promoController.dispose();
    movieController.dispose();
    super.dispose();
  }

  // --- WIDGET: BANNER QUẢNG CÁO ---
  Widget promoBanner() {
    return SizedBox(
      height: 110,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: promoController,
              onPageChanged: (i) => setState(() => promoIndex = i),
              itemBuilder: (context, index) {
                int realPromoIndex = index % promoImages.length;
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PromotionScreen())),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6), 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: rubyRed.withValues(alpha: 0.5), width: 1), 
                      color: darkCard, 
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11), 
                      child: SizedBox(
                        width: double.infinity,
                        child: Image.asset(
                          promoImages[realPromoIndex],
                          fit: BoxFit.fill, // Kéo dãn ảnh để lấp đầy khung promo banner
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(promoImages.length, (i) {
              int realPromoIndex = promoIndex % promoImages.length;
              bool active = i == realPromoIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 16 : 6,
                height: 4,
                decoration: BoxDecoration(
                  color: active ? rubyRed : Colors.white24, 
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  // --- WIDGET: THẺ PHIM ---
  Widget movieCard(Map movie) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: darkCard, 
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.7), blurRadius: 25, offset: const Offset(0, 12)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    movie["img"],
                    fit: BoxFit.fill, // Kéo dãn ảnh poster để lấp đầy toàn bộ khung thẻ phim
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: BoxDecoration(
                color: rubyRed, 
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie["name"].toString().toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFD4AF37), size: 13), 
                      const SizedBox(width: 4),
                      Text(movie["rate"], style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.bold)),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text("•", style: TextStyle(color: Colors.white54, fontSize: 10))),
                      Text(movie["type"], style: const TextStyle(color: Colors.white, fontSize: 11)),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text("•", style: TextStyle(color: Colors.white54, fontSize: 10))),
                      Text(movie["duration"], style: const TextStyle(color: Colors.white, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      // ĐÃ SỬA LỖI Ở DÒNG NÀY: Dùng `movie: movie` thay vì `selectedMovie: movie`
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShowtimeScreen(movie: movie))),
                      borderRadius: BorderRadius.circular(30), 
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111111),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 8, offset: const Offset(0, 4))]
                        ),
                        child: const Text(
                          "ĐẶT VÉ", 
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 2.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- WIDGET: ITEM ĐIỀU HƯỚNG BÊN DƯỚI ---
  Widget _buildNavItem(IconData icon, String label, Widget targetScreen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => targetScreen)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int realMovieIndex = movieIndex % movies.length;

    return Scaffold(
      backgroundColor: darkBg, 
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Stack(
            children: [
              // LỚP 1: ẢNH NỀN
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    key: ValueKey(movies[realMovieIndex]["img"]),
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(movies[realMovieIndex]["img"]), fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Positioned.fill(child: Container(color: darkBg.withValues(alpha: 0.85))),

              // LỚP 2: NỘI DUNG CHÍNH
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // HEADER 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.sort, color: Colors.white, size: 28),
                          const Spacer(),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketPage())),
                                child: const Icon(Icons.confirmation_num_outlined, color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
                                child: Container(
                                  width: 30, height: 30,
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                                  child: const Icon(Icons.person, color: Colors.white, size: 18),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                    promoBanner(),
                    const SizedBox(height: 15),

                    // MOVIE CAROUSEL
                    Expanded(
                      child: PageView.builder(
                        controller: movieController,
                        // Bỏ itemCount để cuộn vô tận
                        onPageChanged: (i) => setState(() => movieIndex = i),
                        itemBuilder: (context, index) {
                          // Tính toán vị trí thực tế trong danh sách phim
                          int currentRealIndex = index % movies.length;
                          
                          return AnimatedBuilder(
                            animation: movieController,
                            builder: (context, child) {
                              double value = 1.0;
                              if (movieController.position.haveDimensions) {
                                value = movieController.page! - index;
                                value = (1 - (value.abs() * 0.08)).clamp(0.9, 1.0); 
                              }
                              return Transform.scale(
                                scale: value,
                                child: Opacity(
                                  opacity: value < 1.0 ? 0.35 : 1.0, 
                                  child: child,
                                ),
                              );
                            },
                            child: movieCard(movies[currentRealIndex]),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16), 

                    // THANH ĐÁNH DẤU (INDICATORS) CHO PHẦN PHIM
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(movies.length, (i) {
                        bool active = i == realMovieIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: active ? 24 : 8,
                          height: 6,
                          decoration: BoxDecoration(
                            color: active ? rubyRed : Colors.white24,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                    
                    // Khoảng trống đủ lớn để dấu chấm không bị đè bởi Bottom Navigation
                    const SizedBox(height: 100), 
                  ],
                ),
              ),

              // LỚP 3: THANH BOTTOM NAVIGATION
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Container(
                  height: 70, 
                  decoration: BoxDecoration(
                    color: darkCard, 
                    borderRadius: BorderRadius.circular(20), 
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 20, offset: const Offset(0, 10))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(Icons.local_movies_outlined, "Phim", const MovieScreen()), 
                      _buildNavItem(Icons.card_giftcard, "Quà tặng", const GiftScreen()),
                      
                      // NÚT TT CINEMA
                      GestureDetector(
                        onTap: () {
                          // Quay lại phim đầu tiên của vòng lặp hiện tại
                          int targetPage = movieIndex - (movieIndex % movies.length);
                          movieController.animateToPage(targetPage, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: rubyRed, 
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.movie_filter, color: Colors.white, size: 20), 
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "TT CINEMA", 
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                            )
                          ],
                        ),
                      ),
                      _buildNavItem(Icons.storefront_outlined, "Rạp", const CinemaPage()),
                      _buildNavItem(Icons.local_offer_outlined, "Khuyến mãi", const PromotionScreen()),
                    ],
                  ),
                ),
              ) 
            ],
          ),
        ),
      ),
    );
  }
}