import 'package:flutter/material.dart';

/// Kontrak rute usulan untuk Agnie. Shell tidak membuat GoRouter/redirect sendiri.
class JajanDestination {
  const JajanDestination(this.label, this.path, this.icon);
  final String label;
  final String path;
  final IconData icon;
}

const jajanDestinations = [
  JajanDestination('Beranda', '/', Icons.home_outlined),
  JajanDestination('Riwayat', '/riwayat', Icons.receipt_long_outlined),
  JajanDestination('Statistik', '/statistik', Icons.bar_chart_outlined),
  JajanDestination('Lencana', '/streak', Icons.local_fire_department_outlined),
  JajanDestination('Target hemat', '/target', Icons.track_changes_outlined),
  JajanDestination('Pengaturan', '/pengaturan', Icons.tune_outlined),
];
const jajanTabletBreakpoint = 840.0;
