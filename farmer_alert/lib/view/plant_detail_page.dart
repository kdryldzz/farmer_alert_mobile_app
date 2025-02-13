import 'package:flutter/material.dart';
import 'package:farmer_alert/models/plant.dart';

class PlantDetailPage extends StatelessWidget {
  final Plant plant; // Bitki detayını alıyoruz

  const PlantDetailPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login_page.jpg"), // Arka plan resmini burada ekliyoruz
            fit: BoxFit.cover,
            opacity: 0.3, // Görselin opaklık değerini ayarlayarak daha yumuşak bir arka plan elde ediyoruz
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Bitki fotoğrafı
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  plant.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Bitki adı
              Text(
                plant.name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 10.0,
                      color: Colors.black,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Bitki açıklaması
              Text(
                plant.description,
                style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 0, 0, 0)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Bitki detayı (sulama aralığı, ekilme zamanı vs.)
              _buildDetailRow('Sulama Aralığı', plant.wateringInterval),
              _buildDetailRow('Ekilme Zamanı', plant.plantingSeason),
              _buildDetailRow('Hasat Süresi', plant.harvestTime),
            ],
          ),
        ),
      ),
    );
  }

  // Bitki detayını göstermek için yardımcı fonksiyon
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.green,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 10, 10, 10)),
            ),
          ),
        ],
      ),
    );
  }
}
