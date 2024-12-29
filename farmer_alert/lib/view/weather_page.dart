import 'package:farmer_alert/models/weather_model.dart';
import 'package:farmer_alert/services/weather_service.dart';
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  List<WeatherModel> _weathers = [];

  // Hava durumu verilerini alma ve kontrol etme
  Future<void> _getWeatherData() async {
    try {
      _weathers = await WeatherService().getWeatherData();
      setState(() {});
    } catch (e) {
      print("Bir hata oluştu: $e");
    }
  }

  @override
  void initState() {
    _getWeatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize =
        MediaQuery.of(context).size; // Ekran boyutlarını alıyoruz

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HAFTALIK HAVA DURUMU",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // Geri gitmek için Navigator.pop çağırıyoruz
          },
        ),
        // AppBar'a gradyan arka plan ekliyoruz
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft, // Gradyanın başladığı nokta
              end: Alignment.centerRight, // Gradyanın bittiği nokta
              colors: [
                Colors.white,
                const Color.fromARGB(255, 130, 126, 208)
              ], // Renk geçişleri
            ),
          ),
        ),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login_page.jpg"), // Arka plan resmi
            // Arka plan resmi
            fit: BoxFit.cover, // Resmi ekranın tamamına yay
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.9),
                BlendMode
                    .dstATop), // Hafif opaklık ekleyerek daha belirgin hale getiriyoruz
          ),
        ),
        child: ListView.builder(
          itemCount: _weathers.length,
          itemBuilder: (context, index) {
            final WeatherModel weather = _weathers[index];
            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50.withOpacity(
                    0.7), // Kartların arka planına hafif opaklık ekledik
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Image.network(weather.ikon, width: 100),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 25),
                    child: Text(
                      "${weather.gun}\n ${weather.durum.toUpperCase()} ${weather.derece}°",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Min: ${weather.min} °"),
                          Text("Max: ${weather.max} °"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Gece: ${weather.gece} °"),
                          Text("Nem: ${weather.nem}"),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
