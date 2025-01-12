import 'package:flutter/material.dart';
import 'package:farmer_alert/models/record.dart';

class AddRecordScreen extends StatefulWidget {
  final Record? record;

  const AddRecordScreen({super.key, this.record});

  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController cropController;
  late TextEditingController costController;
  late TextEditingController dateController;
  String? selectedAction;

  @override
  void initState() {
    super.initState();
    cropController = TextEditingController(text: widget.record?.crop ?? '');
    costController =
        TextEditingController(text: widget.record?.cost.toString() ?? '');
    dateController = TextEditingController(text: widget.record?.date ?? '');
    selectedAction = widget.record?.action;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null ? 'Kayıt Ekle' : 'Kayıt Düzenle'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedAction,
                decoration: const InputDecoration(
                  labelText: 'Eylem',
                  border: OutlineInputBorder(),
                ),
                items: ['Ekti', 'biçti'].map((action) {
                  return DropdownMenuItem(
                    value: action,
                    child: Text(action),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAction = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cropController,
                decoration: const InputDecoration(
                  labelText: 'Ürün',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Bu alan boş bırakılamaz' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Maliyet (₺)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Bu alan boş bırakılamaz' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Tarih (GG-AA-YYYY)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Bu alan boş bırakılamaz' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(
                      context,
                      Record(
                        action: selectedAction!,
                        crop: cropController.text,
                        cost: double.parse(costController.text),
                        date: dateController.text,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(widget.record == null ? 'Kaydet' : 'Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
