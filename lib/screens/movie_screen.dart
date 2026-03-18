import 'package:flutter/material.dart';
import 'movie_details_screen.dart';
import '../app_state.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color darkBg = const Color(0xFF0A0A0A); // Nền đen (Giống trang home)
  final Color primaryRed = const Color(0xFFE51937); // Màu đỏ chủ đạo (Nhãn và Nút)
  final Color bgColor = Colors.white; // Nền danh sách phim (trắng)

  // Dữ liệu mẫu
  List nowShowingMovies = [
    {
      "name": "TÀI",
      "img": "assets/images/p1.jpg",
      "rate": "8.8",
      "type": "Drama",
      "duration": "100 Phút",
      "date": "06/03/2026",
      "age": "T16"
    },
    {
      "name": "QUỶ NHẬP TRÀNG 2",
      "img": "assets/images/QNT.jpeg",
      "rate": "8.5",
      "type": "Thriller/Criminal/Horror",
      "duration": "126 Phút",
      "date": "13/03/2026",
      "age": "T18"
    },
    {
      "name": "CÚ NHẢY KỲ DIỆU",
      "img": "assets/images/p3.jpg",
      "rate": "8.2",
      "type": "Animation",
      "duration": "105 Phút",
      "date": "13/03/2026",
      "age": "P"
    },
  ];

  List comingSoonMovies = [
    {
      "name": "AVENGERS: DOOMSDAY",
      "img": "assets/images/p3.jpg",
      "rate": "9.0",
      "type": "Hành động",
      "duration": "150 Phút",
      "date": "01/05/2026",
      "age": "T16"
    },
    {
      "name": "SPIDER-MAN 4",
      "img": "assets/images/p2.jpg",
      "rate": "8.9",
      "type": "Hành động, Viễn tưởng",
      "duration": "130 Phút",
      "date": "15/07/2026",
      "age": "T13"
    },
  ];

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

  Widget _buildAgeBadge(String age) {
    Color badgeColor;
    if (age == "T18") {
      badgeColor = primaryRed;
    } else if (age == "T16") {
      badgeColor = Colors.pink;
    } else if (age == "P") {
      badgeColor = Colors.green;
    } else {
      badgeColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Text(
        age,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMovieList(List movies) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
      itemCount: movies.length,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Divider(height: 1, color: Colors.black12),
      ),
      itemBuilder: (context, index) => _buildMovieItem(context, movies[index]),
    );
  }

  Widget _buildMovieItem(BuildContext context, Map movie) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                movie["img"],
                width: 130,
                height: 195,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: _buildAgeBadge(movie["age"] ?? "T13"),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                movie["name"].toString().toUpperCase(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text("${AppState().translate("Thời lượng", "Duration")} : ${movie["duration"].toString().replaceAll("Phút", AppState().translate("Phút", "Mins"))}",
                  style: const TextStyle(color: Colors.black54, fontSize: 12)),
              const SizedBox(height: 4),
              Text("${AppState().translate("Khởi chiếu", "Release")} : ${movie["date"]}",
                  style: const TextStyle(color: Colors.black54, fontSize: 12)),
              const SizedBox(height: 4),
              Row(
                children: [
                   Text("${AppState().translate("Thể loại", "Genre")} : ${movie["type"]}",
                      style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                 Navigator.push(
                   context,
                       MaterialPageRoute(
                   builder: (_) => MovieDetailsScreen(movie: movie)));
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: primaryRed,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    AppState().translate("Xem chi tiết", "Details"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    double maxWidth = 500.0;

    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: darkBg,
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                color: bgColor,
                child: Column(
                  children: [
                    _buildAppBarLocal(),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TabBar(
                                controller: _tabController,
                                indicatorColor: Colors.transparent,
                                labelColor: Colors.black87,
                                unselectedLabelColor: Colors.grey,
                                labelStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                unselectedLabelStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.normal),
                                tabs: [
                                  Tab(text: AppState().translate("Phim đang chiếu", "Now Showing")),
                                  Tab(text: AppState().translate("Phim sắp chiếu", "Coming Soon")),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Colors.black12),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildMovieList(nowShowingMovies),
                                  _buildMovieList(comingSoonMovies),
                                ],
                              ),
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
      },
    );
  }

  Widget _buildAppBarLocal() {
    return Container(
      color: primaryRed,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    AppState().translate("Phim", "Movies"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
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
}