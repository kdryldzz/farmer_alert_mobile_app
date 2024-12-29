import 'package:farmer_alert/services/veritabani_yardimcisi.dart';
import 'package:farmer_alert/models/record.dart';

class RecordDAO {
  // Tüm kayıtları al
  Future<List<Record>> tumRecords() async {
    var db =
        await VeritabaniYardimcisi.veritabaniErisim(); // Veritabanı erişimi

    // Veritabanından tüm verileri al
    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM records");

    // Her bir satır için Record nesnesi oluştur
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Record(
          id: satir["id"],
          action: satir["action"],
          crop: satir["crop"],
          cost: satir["cost"],
          date: satir["date"]);
    });
  }

  // Kayıt arama (action veya crop alanına göre)
  Future<List<Record>> recordArama(String aramaKelimesi) async {
    var db =
        await VeritabaniYardimcisi.veritabaniErisim(); // Veritabanı erişimi

    // Arama kriterine göre veritabanından veri al
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM records WHERE action LIKE '%$aramaKelimesi%' OR crop LIKE '%$aramaKelimesi%'");

    // Her bir satır için Record nesnesi oluştur
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Record(
          id: satir["id"],
          action: satir["action"],
          crop: satir["crop"],
          cost: satir["cost"],
          date: satir["date"]);
    });
  }

  // Yeni bir kayıt ekle
  Future<void> recordEkle(
      String action, String crop, double cost, String date) async {
    var db =
        await VeritabaniYardimcisi.veritabaniErisim(); // Veritabanı erişimi
    var bilgiler = Map<String, dynamic>(); // Yeni kayıt verisi

    // Kayıt bilgilerini ekle
    bilgiler["action"] = action;
    bilgiler["crop"] = crop;
    bilgiler["cost"] = cost;
    bilgiler["date"] = date;

    // Veritabanına yeni kaydı ekle
    await db.insert("records", bilgiler);
  }

  // Belirli bir kaydı güncelle
  Future<void> recordGuncelle(
      int id, String action, String crop, double cost, String date) async {
    var db =
        await VeritabaniYardimcisi.veritabaniErisim(); // Veritabanı erişimi
    var bilgiler = Map<String, dynamic>(); // Güncellenen kayıt verisi

    // Kayıt bilgilerini güncelle
    bilgiler["action"] = action;
    bilgiler["crop"] = crop;
    bilgiler["cost"] = cost;
    bilgiler["date"] = date;

    // Belirtilen id'ye sahip kaydı güncelle
    await db.update("records", bilgiler, where: "id=?", whereArgs: [id]);
  }

  // Belirli bir kaydı sil
  Future<void> recordSil(int id) async {
    var db =
        await VeritabaniYardimcisi.veritabaniErisim(); // Veritabanı erişimi
    // Belirtilen id'ye sahip kaydı sil
    await db.delete("records", where: "id=?", whereArgs: [id]);
  }
}
