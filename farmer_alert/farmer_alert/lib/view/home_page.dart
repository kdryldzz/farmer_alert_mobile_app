import 'package:farmer_alert/models/bottom_navigation_layout.dart';
import 'package:farmer_alert/services/auth_service.dart';
import 'package:farmer_alert/view/add_new_product_page.dart';
import 'package:farmer_alert/view/login_page.dart';
import 'package:farmer_alert/view/market_prices_page.dart';
import 'package:farmer_alert/view/my_plans.dart';
import 'package:farmer_alert/view/near_places_page.dart';
import 'package:farmer_alert/view/news_page.dart';
import 'package:farmer_alert/view/plants_page.dart';
import 'package:farmer_alert/view/records_page.dart';
import 'package:farmer_alert/view/weather_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final int _currentIndex = 1;
   final authService = AuthService();

  void logOut(BuildContext context) async {
    authService.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationLayout(
      currentIndex: _currentIndex,
      body: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/login_page.jpg"), // Arka plan resmi
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const SizedBox(
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
                            offset: const Offset(2.0,
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
                          style: const ButtonStyle(),
                          onPressed: () {
                           logOut(context);
                          },
                          icon: const Icon(Icons.logout)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  "Near Places",
                  Icons.list_alt,
                  const Color.fromARGB(255, 54, 116, 215),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NearPlacesPage()),
                  ),
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  "Weather",
                  Icons.cloud,
                  const Color.fromARGB(255, 183, 134, 180),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WeatherPage()),
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  "plants",
                  Icons.list_alt,
                  const Color.fromARGB(255, 54, 116, 215),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlantsPage()),
                  ),
                ),const SizedBox(height: 20), _buildMenuButton(
                  context,
                  "my plans",
                  Icons.list_alt,
                  const Color.fromARGB(255, 23, 152, 141),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPlansPage()),
                  ),
                ),const SizedBox(height: 20),
                  _buildMenuButton(
                  context,
                  "new product plan",
                  Icons.list_alt,
                  const Color.fromARGB(255, 173, 225, 18),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNewProductPage()),
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
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
      ),
    );
  }
}
