import 'package:flutter/material.dart';
import 'cargo_booking_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class ItemSyarat {
  String headerText;
  String expandedText;
  bool isExpanded;
  
  ItemSyarat({
    required this.headerText,
    required this.expandedText,
    this.isExpanded = false,
  });
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final TextEditingController _trackingController = TextEditingController();
  final List<String> armadaList = ['Colt Diesel', 'Fuso', 'Tronton'];

  final List<ItemSyarat> _syaratData = [
    ItemSyarat(
        headerText: 'Bahan Mudah Terbakar',
        expandedText: 'Pastikan suhu stabil dan jauh dari percikan api.'),
    ItemSyarat(
        headerText: 'Bahan Kimia Beracun',
        expandedText: 'Wajib menggunakan kontainer tersegel rapat.'),
  ];

  // PERBAIKAN: Tambahkan dispose untuk membersihkan memori controller
  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
  }

  // Navigasi ke halaman form pesanan
  void _pilihArmada(String armada) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CargoBookingScreen(armadaTerpilih: armada)),
    );

    // Menerima returning data
    if (result != null && result == true) {
      if (!mounted) return; // Mencegah error context jika widget sudah tertutup
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status Resi: Berhasil Diterbitkan!')),
      );
    }
  }

  Widget _buildManifesMuatan() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Armada Tersedia'),
              Tab(text: 'Syarat Muatan'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // TAB 1: Armada Tersedia
                ListView.builder(
                  itemCount: armadaList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: SizedBox(
                        width: 60,
                        height: 60,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.local_shipping),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                color: Colors.red,
                                child: const Text(
                                  'FULL',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      title: Text(armadaList[index]),
                      trailing: ElevatedButton(
                        onPressed: () => _pilihArmada(armadaList[index]),
                        child: const Text('Pilih Armada'),
                      ),
                    );
                  },
                ),
                // TAB 2: Syarat Muatan Berbahaya
                SingleChildScrollView(
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _syaratData[index].isExpanded = isExpanded;
                      });
                    },
                    children: _syaratData.map<ExpansionPanel>((ItemSyarat item) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(title: Text(item.headerText));
                        },
                        body: ListTile(title: Text(item.expandedText)),
                        isExpanded: item.isExpanded,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRekapResi() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('No. Resi')),
          DataColumn(label: Text('Armada')),
          DataColumn(label: Text('Status')),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('R-001')),
            DataCell(Text('Fuso')),
            DataCell(Text('Terkirim'))
          ]),
          DataRow(cells: [
            DataCell(Text('R-002')),
            DataCell(Text('Tronton')),
            DataCell(Text('Proses'))
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoDepo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Depo Utama: Gudang Jakarta Utara',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const SelectableText(
              'API Tracking Code: TRK-992-APIX',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            const Text('(Silakan block dan salin kode di atas)'),
            const SizedBox(height: 40),
            const Divider(), // Garis pemisah
            const SizedBox(height: 20),
            const Text(
              'Lacak Pengiriman Kargo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Tempat paste kode
            TextField(
              controller: _trackingController,
              decoration: InputDecoration(
                hintText: 'Tempel (Paste) Kode Tracking di sini',
                labelText: 'Masukkan Kode API',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tombol aksi tracking
            ElevatedButton(
              onPressed: () {
                if (_trackingController.text.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Status Tracking'),
                      content: Text(
                          'Mencari data untuk kode: ${_trackingController.text}\n\n'
                          'Status:\nKargo sedang dalam perjalanan menuju depo tujuan.\n'
                          'Estimasi Tiba: Besok Pagi.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Silakan paste/masukkan kode tracking terlebih dahulu!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Lacak Kargo'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildManifesMuatan(),
      _buildRekapResi(),
      _buildInfoDepo(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dasbor Logistik')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Identitas Armada: \nPetugas A - Shift Pagi',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Manifes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), label: 'Rekap Resi'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info Depo'),
        ],
      ),
    );
  }
}