import 'package:farmer_alert/models/bottom_navigation_layout.dart';
import 'package:farmer_alert/services/auth_service.dart';
import 'package:farmer_alert/view/add_new_product_page.dart';
import 'package:farmer_alert/view/login_page.dart';
import 'package:farmer_alert/view/market_prices_page.dart';
import 'package:farmer_alert/view/my_plans.dart';
import 'package:farmer_alert/view/near_places_page.dart';
import 'package:farmer_alert/view/news_page.dart';
import 'package:farmer_alert/view/plants_page.dart';
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/login_page.jpg"), // Arka plan resmi
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken), // Daha modern bir efekt
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text(
                        "FARMER ALERT",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto', // Daha modern bir font
                          shadows: [
                            Shadow(
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ],
                        ),
                      ),
                    ),Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 0),
                      child: IconButton(
                        onPressed: () {
                          logOut(context);
                        },
                        icon: const Icon(Icons.logout),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _buildMenuButton(
                        context,
                        "Market Fiyatları",
                        Icons.list_alt,
                        Colors.green,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MarketPrices()),
                        ),
                      ),
                      _buildMenuButton(
                        context,
                        "Yakındaki Al-Sat Konumları",
                        Icons.location_on,
                        const Color.fromARGB(255, 54, 116, 215),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NearPlacesPage()),
                        ),
                      ),
                      _buildMenuButton(
                        context,
                        "Hava Durumu",
                        Icons.cloud,
                        const Color.fromARGB(255, 183, 134, 180),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WeatherPage()),
                        ),
                      ),
                      _buildMenuButton(
                        context,
                        "Tarım Haberleri",
                        Icons.article,
                        Colors.orangeAccent,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewsPage()),
                        ),
                      ),
                      _buildMenuButton(
                        context,
                        "Bitkiler Hakkında..",
                        Icons.grass,
                        const Color.fromARGB(255, 54, 116, 215),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlantsPage()),
                        ),
                      ),
                      _buildMenuButton(
                        context,
                        "Planlarım",
                        Icons.assignment,
                        const Color.fromARGB(255, 23, 152, 141),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyPlansPage()),
                        ),
                      ),
                      _buildMenuButton(
                        context,
                        "Yeni İlaçlama Planı",
                        Icons.add_circle_outline,
                        const Color.fromARGB(255, 173, 225, 18),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddNewProductPage()),
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
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }
}
