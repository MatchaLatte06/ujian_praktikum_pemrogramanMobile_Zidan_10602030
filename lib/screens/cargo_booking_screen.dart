import 'package:flutter/material.dart';

class CargoBookingScreen extends StatefulWidget {
  final String armadaTerpilih;
  
  // Menerima passing data
  const CargoBookingScreen({Key? key, required this.armadaTerpilih}) : super(key: key);

  @override
  State<CargoBookingScreen> createState() => _CargoBookingScreenState();
}

class _CargoBookingScreenState extends State<CargoBookingScreen> {
  String _kategoriMuatan = 'General Cargo';
  
  bool _asuransi = false;
  bool _jasaForklift = false;
  bool _pengawalan = false;
  
  DateTime? _tglJemput;
  TimeOfDay? _jamBerangkat;
  
  double _tonase = 1.0;
  bool _reeferActive = false;

  Future<void> _pilihTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _tglJemput = picked);
    }
  }

  Future<void> _pilihJam() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _jamBerangkat = picked);
    }
  }

  void _tampilkanBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rincian Biaya Logistik', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Armada: ${widget.armadaTerpilih}'),
              Text('Estimasi Tonase: ${_tonase.toStringAsFixed(1)} Ton'),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // Tutup bottom sheet
                  _tampilkanDialogKonfirmasi();
                },
                child: const Text('Konfirmasi Penerbitan Surat Jalan'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _tampilkanDialogKonfirmasi() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Persetujuan'),
        content: const Text('Terbitkan surat jalan untuk muatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text('Batal')
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Tutup dialog
              Navigator.pop(context, true); // Tutup halaman form dan kembalikan data (returning data)
            },
            child: const Text('Setuju'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Kargo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Armada Terpilih: ${widget.armadaTerpilih}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            
            const Text('Kategori Muatan (Radio):'),
            RadioListTile(title: const Text('General Cargo'), value: 'General Cargo', groupValue: _kategoriMuatan, onChanged: (v) => setState(() => _kategoriMuatan = v.toString())),
            RadioListTile(title: const Text('Makanan Beku/Perishable'), value: 'Makanan Beku/Perishable', groupValue: _kategoriMuatan, onChanged: (v) => setState(() => _kategoriMuatan = v.toString())),
            RadioListTile(title: const Text('Alat Berat'), value: 'Alat Berat', groupValue: _kategoriMuatan, onChanged: (v) => setState(() => _kategoriMuatan = v.toString())),
            
            const Divider(),
            const Text('Proteksi Pengiriman (Checkbox):'),
            CheckboxListTile(title: const Text('Asuransi Barang Rusak'), value: _asuransi, onChanged: (v) => setState(() => _asuransi = v!)),
            CheckboxListTile(title: const Text('Jasa Forklift Muat'), value: _jasaForklift, onChanged: (v) => setState(() => _jasaForklift = v!)),
            CheckboxListTile(title: const Text('Pengawalan Prioritas'), value: _pengawalan, onChanged: (v) => setState(() => _pengawalan = v!)),
            
            const Divider(),
            ListTile(
              title: Text(_tglJemput == null ? 'Pilih Tanggal Penjemputan' : 'Tgl: ${_tglJemput.toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pilihTanggal,
            ),
            ListTile(
              title: Text(_jamBerangkat == null ? 'Pilih Jam Keberangkatan' : 'Jam: ${_jamBerangkat!.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: _pilihJam,
            ),
            
            const Divider(),
            Text('Estimasi Tonase (Slider): ${_tonase.toStringAsFixed(1)} Ton'),
            Slider(
              value: _tonase,
              min: 1.0,
              max: 20.0,
              divisions: 19,
              onChanged: (v) => setState(() => _tonase = v),
            ),
            
            SwitchListTile(
              title: const Text('Mesin Pendingin Kontainer (Reefer)'),
              value: _reeferActive,
              onChanged: (v) => setState(() => _reeferActive = v),
            ),
            
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _tampilkanBottomSheet,
                child: const Text('Hitung Biaya Logistik'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}