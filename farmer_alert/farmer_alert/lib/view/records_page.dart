import 'package:farmer_alert/services/recordsdao.dart';
import 'package:farmer_alert/view/add_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:farmer_alert/models/record.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  List<Record> records = []; // Kayıt listesi

  @override
  void initState() {
    super.initState();
    _loadRecords(); // Sayfa açıldığında veritabanından kayıtları çek
  }

  // Veritabanından kayıtları çekme
  void _loadRecords() async {
    List<Record> data =
        await RecordDAO().tumRecords(); // RecordDAO kullanıyoruz
    setState(() {
      records = data; // Verileri Record objelerine direkt olarak atıyoruz
    });
  }

  void addRecord(Record record) async {
    // Veritabanına ekle
    await RecordDAO()
        .recordEkle(record.action, record.crop, record.cost, record.date);
    _loadRecords(); // Veritabanına ekledikten sonra kayıtları yeniden yükle
  }

  void deleteRecord(int index) async {
    await RecordDAO().recordSil(records[index].id!); // Veritabanından sil
    _loadRecords(); // Silme işleminden sonra kayıtları yeniden yükle
  }

  void editRecord(int index, Record updatedRecord) async {
    await RecordDAO().recordGuncelle(
        records[index].id!,
        updatedRecord.action,
        updatedRecord.crop,
        updatedRecord.cost,
        updatedRecord.date); // Veritabanında güncelle
    _loadRecords(); // Güncellemeden sonra kayıtları yeniden yükle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KAYITLAR',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: 1.0, // Harf aralığına dikkat ettim
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 143, 218, 143),
                Color.fromARGB(255, 6, 89, 32)
              ], // Yeşil tonları
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/login_page.jpg'), // Doğa arka planı
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.9), BlendMode.dstATop),
          ),
        ),
        child: ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7), // Yumuşak opaklık
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  records[index].crop,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Tarih: ${records[index].date} - Maliyet: ${records[index].cost}₺',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        Record? updatedRecord = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddRecordScreen(record: records[index]),
                          ),
                        );
                        if (updatedRecord != null) {
                          editRecord(index, updatedRecord);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteRecord(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Record? newRecord = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecordScreen(),
            ),
          );
          if (newRecord != null) {
            addRecord(newRecord);
          }
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
