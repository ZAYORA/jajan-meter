import 'package:flutter/material.dart';

import '../jajan_theme.dart';
import '../widgets/jajan_bottom_bar.dart';
import 'home_preview_page.dart';

class VakaPreviewApp extends StatelessWidget {
  const VakaPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jajan Meter — Pratinjau Vaka',
      debugShowCheckedModeBanner: false,
      theme: buildJajanTheme(),
      home: const VakaPreviewShell(),
    );
  }
}

/// Hanya shell untuk meninjau komponen. Router/login produksi tetap milik tim.
class VakaPreviewShell extends StatefulWidget {
  const VakaPreviewShell({super.key});

  @override
  State<VakaPreviewShell> createState() => _VakaPreviewShellState();
}

class _VakaPreviewShellState extends State<VakaPreviewShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  color: JajanColors.paleYellow,
                  child: const Text(
                    'PRATINJAU UI · DATA CONTOH',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: JajanColors.ink,
                    ),
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: const [
                      HomePreviewPage(),
                      _PlaceholderTab(
                        title: 'Statistik',
                        subtitle: 'Kenali pola jajanmu.',
                        icon: Icons.bar_chart_outlined,
                        description: 'Grafik dan rekap mingguan akan tersedia di halaman ini.',
                      ),
                      _PlaceholderTab(
                        title: 'Target',
                        subtitle: 'Kasih batas, bukan berhenti jajan.',
                        icon: Icons.track_changes_outlined,
                        description: 'Pengaturan jatah dan progres akan tersedia di halaman ini.',
                      ),
                      _PlaceholderTab(
                        title: 'Pengaturan',
                        subtitle: 'Bikin Jajan Meter terasa seperti kamu.',
                        icon: Icons.tune_outlined,
                        description: 'Tema, informasi aplikasi, dan pengaturan akun akan tersedia di sini.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: JajanBottomBar(
            selectedIndex: _selectedIndex,
            onSelected: (index) => setState(() => _selectedIndex = index),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.description,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: JajanColors.paleBlue,
                child: Icon(icon, color: JajanColors.blue, size: 30),
              ),
              const SizedBox(height: 20),
              Text(
                'Halaman sedang disiapkan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(description),
            ],
          ),
        ),
      ],
    );
  }
}
