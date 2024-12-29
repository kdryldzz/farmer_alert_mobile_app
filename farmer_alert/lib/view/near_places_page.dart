import 'dart:convert'; // JSON decode işlemi için
import 'package:flutter/services.dart'; // Asset dosyasını yüklemek için
import 'package:flutter/material.dart';

class NearPlacesPage extends StatefulWidget {
  const NearPlacesPage({super.key});

  @override
  State<NearPlacesPage> createState() => _NearPlacesPageState();
}

class _NearPlacesPageState extends State<NearPlacesPage> {
  List<dynamic> locations = []; // Tüm konumlar
  List<dynamic> filteredLocations = []; // Filtrelenmiş konumlar
  String searchQuery = ""; // Arama çubuğundaki metin
  bool isSearching = false; // Arama çubuğu açık mı kontrolü

  // JSON verilerini yüklemek için
  Future<void> loadLocations() async {
    try {
      final String response =
          await rootBundle.loadString('datas/locations.json');
      final data = json.decode(response); // JSON'u çözümle
      setState(() {
        locations = data; // Tüm konumları atayın
        filteredLocations = data; // Başlangıçta tüm konumlar görünsün
      });
    } catch (e) {
      print("Hata: $e");
    }
  }

  // Arama çubuğu için filtreleme işlemi
  void filterLocations(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredLocations = locations; // Tüm listeyi göster
      } else {
        filteredLocations = locations
            .where((location) => location['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadLocations(); // Sayfa yüklendiğinde verileri al
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                onChanged: filterLocations,
                decoration: InputDecoration(
                  hintText: "Yer ara...",
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )
            : const Text(
                "Yakındaki Yerler",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
              ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 54, 116, 215),
        actions: [
          isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchQuery = "";
                      filteredLocations = locations;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login_page.jpg"), // Arka plan resmi
            fit: BoxFit.cover,
          ),
        ),
        child: filteredLocations.isEmpty
            ? const Center(
                child: Text(
                  "Sorry, we don't find anything :( ",
                  style: TextStyle(fontSize: 28, color: Colors.black45),
                ), // Yükleniyor göstergesi
              )
            : ListView.builder(
                itemCount: filteredLocations.length,
                itemBuilder: (context, index) {
                  final location = filteredLocations[index]; // Her bir konum
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    color: Colors.white.withOpacity(0.8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      title: Text(
                        location['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 54, 116, 215),
                        ),
                      ),
                      subtitle: Text(
                        '${location['city']}, ${location['district']}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Burada "Konuma git" butonu için işlem yapılabilir
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 54, 116, 215),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Konuma Git",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
