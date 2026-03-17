import 'package:flutter/material.dart';
import 'booking_screen.dart';

class ShowtimeScreen extends StatefulWidget {
  final Map movie;

  const ShowtimeScreen({super.key, required this.movie});

  @override
  State<ShowtimeScreen> createState() => _ShowtimeScreenState();
}

class _ShowtimeScreenState extends State<ShowtimeScreen> {
  // --- CONSTANTS ---
  final Color primaryRed = const Color(0xFFE51937);
  final Color textSecondary = Colors.black38;
  final Color textPrimary = Colors.black;

  // --- STATE ---
  int selectedDateIndex = 0;
  String selectedRegion = "Miền Bắc";

  // --- MOCK DATA ---
  final List<Map<String, String>> dates = [
    {"day": "CN", "date": "15/03"},
    {"day": "T2", "date": "16/03"},
    {"day": "T3", "date": "17/03"},
    {"day": "T4", "date": "18/03"},
    {"day": "T5", "date": "19/03"},
    {"day": "T6", "date": "20/03"},
    {"day": "T7", "date": "21/03"},
  ];

  final List<String> regions = ["Miền Bắc", "Miền Trung", "Miền Nam"];

  final Map<String, List<Map<String, dynamic>>> cinemasByRegion = {
    "Miền Bắc": [
      {
        "cinemaName": "TT Cinema Hà Đông",
        "formats": [
          {
            "name": "2D PHỤ ĐỀ TIẾNG ANH",
            "times": [
              {"start": "19:00", "end": "21:00", "booked": 45, "total": 120, "room": "Rạp 04", "status": "available"},
              {"start": "21:00", "end": "23:00", "booked": 79, "total": 120, "room": "Rạp 04", "status": "available"},
              {"start": "23:40", "end": "01:40", "booked": 120, "total": 120, "room": "Rạp 06", "status": "sold_out"},
            ]
          }
        ]
      },
      {
        "cinemaName": "TT Cinema Cầu Giấy",
        "formats": [
          {
            "name": "2D LỒNG TIẾNG",
            "times": [
              {"start": "10:00", "end": "12:00", "booked": 15, "total": 100, "room": "Rạp 01", "status": "available"},
            ]
          }
        ]
      }
    ],
    "Miền Trung": [
      {
        "cinemaName": "TT Cinema Sơn Trà",
        "formats": [
          {
            "name": "2D PHỤ ĐỀ TIẾNG VIỆT",
            "times": [
              {"start": "14:00", "end": "16:00", "booked": 50, "total": 120, "room": "Rạp 03", "status": "available"},
            ]
          }
        ]
      }
    ],
    "Miền Nam": [
      {
        "cinemaName": "TT Cinema Gò Vấp",
        "formats": [
          {
            "name": "IMAX PHỤ ĐỀ TIẾNG ANH",
            "times": [
              {"start": "19:30", "end": "21:30", "booked": 200, "total": 250, "room": "IMAX 1", "status": "available"},
            ]
          }
        ]
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              _buildRegionFilter(),
              Expanded(
                child: _buildCinemaList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.movie["name"]?.toString().toUpperCase() ?? "SHOWTIME",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {
          bool isSelected = selectedDateIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedDateIndex = index),
            child: Padding(
              padding: const EdgeInsets.only(right: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dates[index]["date"]!,
                    style: TextStyle(
                      color: isSelected ? textPrimary : textSecondary,
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isSelected ? 12 : 0,
                    height: 2,
                    color: primaryRed,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRegionFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: regions.map((region) {
          bool isSelected = selectedRegion == region;
          return GestureDetector(
            onTap: () => setState(() => selectedRegion = region),
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Text(
                region.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? primaryRed : textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCinemaList() {
    final cinemas = cinemasByRegion[selectedRegion] ?? [];
    if (cinemas.isEmpty) {
      return const Center(
        child: Text(
          "NO SHOWTIMES AVAILABLE",
          style: TextStyle(color: Colors.black12, fontSize: 10, letterSpacing: 1.0),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      itemCount: cinemas.length,
      itemBuilder: (context, index) {
        final cinema = cinemas[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cinema["cinemaName"].toString().toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ...cinema["formats"].map<Widget>((format) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    format["name"],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: textSecondary.withValues(alpha: 0.5),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTimeGrid(format["times"]),
                  const SizedBox(height: 40),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildTimeGrid(List times) {
    return Wrap(
      spacing: 30,
      runSpacing: 20,
      children: times.map<Widget>((timeData) {
        bool isSoldOut = timeData["status"] == "sold_out";
        return GestureDetector(
          onTap: isSoldOut ? null : () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookingScreen(movie: widget.movie, timeData: timeData)),
            );
          },
          child: Opacity(
            opacity: isSoldOut ? 0.2 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeData["start"],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  isSoldOut ? "SOLD OUT" : "${timeData["booked"]}/${timeData["total"]} SEATS",
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}