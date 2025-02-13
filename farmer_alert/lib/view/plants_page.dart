import 'dart:convert';
import 'package:farmer_alert/models/plant.dart';
import 'package:farmer_alert/view/plant_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // JSON dosyasını yüklemek için

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

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
      appBar: AppBar(
        title: const Text('Bitkiler',style: TextStyle(fontSize: 32,fontWeight: FontWeight.w700),),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0, // AppBar'ın gölge efektini kaldırdım
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login_page.jpg"), // Arka plan resmi
            fit: BoxFit.cover,
          ),
        ),
        child: plants.isEmpty
            ? const Center(
                child: CircularProgressIndicator(), // Veriler yüklenene kadar yükleniyor spinnerı
              )
            : ListView.builder(
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  return GestureDetector(
                    onTap: () {
                      // Bitkilerin detaylarına gitmek için
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantDetailPage(plant: plant),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
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
                            child: Text(
                              plant.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
