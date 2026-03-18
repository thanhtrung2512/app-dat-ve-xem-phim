import 'package:flutter/material.dart';
import '../app_state.dart';
import 'movie_details_screen.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  const FavoriteMoviesScreen({super.key});

  @override
  State<FavoriteMoviesScreen> createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  final Color primaryRed = const Color(0xFFE51937);
  final Color darkBg = const Color(0xFF0A0A0A);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final favorites = AppState().favoriteMovies;

        return Scaffold(
          backgroundColor: darkBg, // Nền tối bên ngoài khung
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                color: Colors.white, // Nền trắng bên trong khung
                child: Column(
                  children: [
                    _buildAppBarLocal(),
                    Expanded(
                      child: favorites.isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                              itemCount: favorites.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 20),
                              itemBuilder: (context, index) => _buildMovieItem(favorites[index]),
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
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 20),
      decoration: BoxDecoration(
        color: primaryRed,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
        boxShadow: [BoxShadow(color: primaryRed.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              AppState().translate("PHIM YÊU THÍCH", "FAVORITE MOVIES"),
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, color: Colors.black.withValues(alpha: 0.05), size: 100),
          const SizedBox(height: 16),
          Text(AppState().translate("Kho phim yêu thích của bạn đang trống", "Your favorite movies collection is empty"), 
            style: const TextStyle(color: Colors.black38, fontSize: 14, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }

  Widget _buildMovieItem(Map movie) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)));
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              // Poster Phim
              Image.asset(
                movie["img"],
                width: 90,
                height: 125,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              // Thông tin
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie["name"].toString().toUpperCase(),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        movie["type"] ?? "Hành động",
                        style: TextStyle(fontSize: 12, color: primaryRed, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${AppState().translate("Thời lượng", "Duration")}: ${movie["duration"] ?? "120p"}",
                        style: const TextStyle(fontSize: 11, color: Colors.black38),
                      ),
                    ],
                  ),
                ),
              ),
              // Nút xóa
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red, size: 24),
                  onPressed: () {
                    setState(() {
                      AppState().toggleFavorite(movie);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
