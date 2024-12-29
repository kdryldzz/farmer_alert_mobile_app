import 'dart:convert';
import 'package:farmer_alert/models/plant.dart';
import 'package:farmer_alert/view/plant_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // JSON dosyasını yüklemek için

class PlantsPage extends StatefulWidget {
  @override
  _PlantsPageState createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  late List<Plant> plants = [];

  @override
  void initState() {
    super.initState();
    _loadPlants(); // Sayfa açıldığında JSON verisini yükle
  }

  // JSON dosyasını yükleyip listeyi oluşturma
  Future<void> _loadPlants() async {
    // Burada datas/plants.json dosyasını okuyoruz
    final String response = await rootBundle.loadString('datas/plants.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      plants = data.map((json) => Plant.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          Positioned.fill(
            child: Image.asset(
              'images/login_page.jpg', // Görsel dosyasının yolu
              fit: BoxFit.cover, // Görseli ekranı dolduracak şekilde yerleştir
            ),
          ),
          // Üstteki bitkiler listesi
          Scaffold(
            appBar: AppBar(
              title: Text('Bitkiler'),
              centerTitle: true,
              backgroundColor: Colors.green,
              elevation: 0, // AppBar'ın gölge efektini kaldırdım
            ),
            backgroundColor:
                Colors.transparent, // Scaffold'un arka planını saydam yaptım
            body: plants.isEmpty
                ? Center(
                    child:
                        CircularProgressIndicator(), // Veriler yüklenene kadar yükleniyor spinnerı
                  )
                : ListView.builder(
                    itemCount: plants.length,
                    itemBuilder: (context, index) {
                      final plant = plants[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                plant.imageUrl,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plant.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    plant.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlantDetailPage()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text('View Details'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
