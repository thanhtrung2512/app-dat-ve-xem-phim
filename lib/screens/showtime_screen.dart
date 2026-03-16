import 'package:flutter/material.dart';
import 'booking_screen.dart';

class ShowtimeScreen extends StatefulWidget {
  final Map movie;

  const ShowtimeScreen({super.key, required this.movie});

  @override
  State<ShowtimeScreen> createState() => _ShowtimeScreenState();
}

class _ShowtimeScreenState extends State<ShowtimeScreen> with SingleTickerProviderStateMixin {
  final Color darkBg = const Color(0xFF0A0A0A);
  final Color primaryRed = const Color(0xFFE51937);
  final Color ageBadgeColor = const Color(0xFFD61884);
  final Color seatAvailableColor = const Color(0xFF28A745);

  int selectedDateIndex = 0;
  
  // Dữ liệu mẫu Ngày
  final List<Map<String, String>> dates = [
    {"day": "Sun", "date": "15"},
    {"day": "Mon", "date": "16"},
    {"day": "Tue", "date": "17"},
    {"day": "Wed", "date": "18"},
    {"day": "Thu", "date": "19"},
    {"day": "Fri", "date": "20"},
    {"day": "Sat", "date": "21"},
  ];

  late TabController _regionTabController;

  // Dữ liệu mẫu phân loại trực tiếp: Miền -> Danh sách Rạp
  final Map<String, List<Map<String, dynamic>>> cinemasByRegion = {
    "Miền Bắc": [
      {
        "cinemaName": "TT Cinema Hà Đông",
        "formats": [
          {
            "name": "2D | Phụ đề tiếng Anh",
            "times": [
              {"start": "19:00", "end": "21:00", "booked": 45, "total": 120, "room": "Rạp 04", "status": "available"},
              {"start": "21:00", "end": "23:00", "booked": 79, "total": 120, "room": "Rạp 04", "status": "available"},
              {"start": "23:40", "end": "25:40", "booked": 120, "total": 120, "room": "Rạp 06", "status": "sold_out"},
            ]
          }
        ]
      },
      {
        "cinemaName": "TT Cinema Cầu Giấy",
        "formats": [
          {
            "name": "2D | Lồng tiếng",
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
            "name": "2D | Phụ đề tiếng Việt",
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
            "name": "IMAX | Phụ đề tiếng Anh",
            "times": [
              {"start": "19:30", "end": "21:30", "booked": 200, "total": 250, "room": "IMAX 1", "status": "available"},
            ]
          }
        ]
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _regionTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _regionTabController.dispose();
    super.dispose();
  }

  // --- WIDGET: Lưới Suất Chiếu ---
  Widget _buildTimeGrid(List times) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: times.map<Widget>((timeData) {
        bool isSoldOut = timeData["status"] == "sold_out";

        return GestureDetector( // Đổi InkWell thành GestureDetector để nhận chạm nhạy hơn trên Web
          onTap: isSoldOut ? null : () {
            // Chuyển trang khi có dữ liệu
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => BookingScreen(
                  movie: widget.movie, 
                  timeData: timeData, // Truyền thông tin suất chiếu sang
                ),
              )
            );
          },
          child: Container(
            width: 105,
            decoration: BoxDecoration(
              color: isSoldOut ? const Color(0xFFF3F3F3) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12, width: 1.0),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4, left: 4, right: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        isSoldOut ? "Đã bán hết" : timeData["start"],
                        style: TextStyle(
                          color: isSoldOut ? Colors.black38 : Colors.black,
                          fontSize: isSoldOut ? 12 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!isSoldOut)
                        Text(" ~${timeData["end"]}", style: const TextStyle(color: Colors.black38, fontSize: 10)),
                    ],
                  ),
                ),
                Container(height: 1, color: Colors.black12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isSoldOut ? "" : "${timeData["booked"]}/${timeData["total"]}",
                        style: TextStyle(color: seatAvailableColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeData["room"],
                        style: TextStyle(color: isSoldOut ? Colors.black26 : Colors.black, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- WIDGET: Danh Sách Rạp Theo Miền ---
  Widget _buildCinemaList(List<Map<String, dynamic>> cinemas) {
    if (cinemas.isEmpty) {
      return const Center(child: Text("Không có suất chiếu tại miền này", style: TextStyle(color: Colors.black54)));
    }
    
    return ListView.separated(
      itemCount: cinemas.length,
      separatorBuilder: (_, _) => Container(height: 8, color: const Color(0xFFF7F7F7)),
      itemBuilder: (context, index) {
        final cinema = cinemas[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Text(
                cinema["cinemaName"],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            ...cinema["formats"].map<Widget>((format) {
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(format["name"], style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    _buildTimeGrid(format["times"]),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String movieName = widget.movie["name"] ?? "UNKNOWN MOVIE";
    String ageRating = widget.movie["age"] ?? "T16";

    return Scaffold(
      backgroundColor: darkBg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500), // Khớp tỉ lệ với Home/Movie Screen
          child: Column(
            children: [
              // --- HEADER CUSTOM ---
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
                        Expanded(
                          child: Center(
                            child: Text(movieName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
              ),

              // --- PHẦN THÂN TRẮNG BO GÓC ---
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      // Thanh Chọn Ngày
                      Container(
                        height: 80,
                        margin: const EdgeInsets.only(top: 8),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dates.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            bool isSelected = selectedDateIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => selectedDateIndex = index),
                              child: Container(
                                width: 60,
                                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.black : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(dates[index]["day"]!, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 14)),
                                    const SizedBox(height: 2),
                                    Text(dates[index]["date"]!, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1, color: Colors.black12),
                      
                      // Dải Thông Tin Phim
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        color: const Color(0xFFF7F7F7),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: ageRating == "T18" ? primaryRed : ageBadgeColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(ageRating, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(movieName, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                      
                      // Tabs Miền
                      TabBar(
                        controller: _regionTabController,
                        labelColor: primaryRed,
                        unselectedLabelColor: Colors.black54,
                        indicatorColor: primaryRed,
                        tabs: const [
                          Tab(text: "Miền Bắc"),
                          Tab(text: "Miền Trung"),
                          Tab(text: "Miền Nam"),
                        ],
                      ),
                      const Divider(height: 1, color: Colors.black12),
                      
                      // Nội Dung Tabs (Vuốt để chuyển)
                      Expanded(
                        child: TabBarView(
                          controller: _regionTabController,
                          children: [
                            _buildCinemaList(cinemasByRegion["Miền Bắc"]!),
                            _buildCinemaList(cinemasByRegion["Miền Trung"]!),
                            _buildCinemaList(cinemasByRegion["Miền Nam"]!),
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
    );
  }
}