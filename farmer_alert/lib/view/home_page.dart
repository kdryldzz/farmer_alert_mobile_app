import 'package:farmer_alert/models/bottom_navigation_layout.dart';
import 'package:farmer_alert/view/login_page.dart';
import 'package:farmer_alert/view/market_prices_page.dart';
import 'package:farmer_alert/view/near_places_page.dart';
import 'package:farmer_alert/view/news_page.dart';
import 'package:farmer_alert/view/plants_page.dart';
import 'package:farmer_alert/view/records_page.dart';
import 'package:farmer_alert/view/weather_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationLayout(
      currentIndex: _currentIndex,
      body: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/login_page.jpg"), // Arka plan resmi
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                    ),
                    Text(
                      "FARMER ALERT",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0,
                                2.0), // Gölgenin x ve y eksenindeki kayması
                            blurRadius: 10.0, // Gölgenin bulanıklık derecesi
                            color: Colors.black
                                .withOpacity(0.9), // Gölge rengi ve opaklığı
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 60),
                      child: IconButton(
                          style: ButtonStyle(),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          icon: Icon(Icons.logout)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  "Market Prices",
                  Icons.list_alt,
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MarketPrices()),
                  ),
                ),
                SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  "Near Places",
                  Icons.list_alt,
                  const Color.fromARGB(255, 54, 116, 215),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NearPlacesPage()),
                  ),
                ),
                SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  "Weather",
                  Icons.cloud,
                  const Color.fromARGB(255, 183, 134, 180),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeatherPage()),
                  ),
                ),
                SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  "Records",
                  Icons.list_alt,
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecordsPage()),
                  ),
                ),
                SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  "News",
                  Icons.article,
                  Colors.orangeAccent,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsPage()),
                  ),
                ),
                SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  "plants",
                  Icons.list_alt,
                  const Color.fromARGB(255, 54, 116, 215),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlantsPage()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
      ),
    );
  }
}
