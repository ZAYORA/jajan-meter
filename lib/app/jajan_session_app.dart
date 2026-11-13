import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/jajan_source.dart';
import '../features/jajan/jajan_workspace.dart';
import '../providers/jajan_provider.dart';
import '../vaka_ui/jajan_theme.dart';

/// Seluruh Navigator berada di dalam sesi. Mengganti key UID membuang provider,
/// stream, filter, form, dan route detail akun sebelumnya secara bersamaan.
class JajanSessionApp extends StatefulWidget {
  const JajanSessionApp({
    super.key,
    required this.source,
    this.onSignOut,
    this.demo = false,
    this.now,
    this.autoRefreshClock = true,
  });
  final JajanSource source;
  final Future<void> Function()? onSignOut;
  final bool demo;
  final DateTime Function()? now;
  final bool autoRefreshClock;
  @override
  State<JajanSessionApp> createState() => _JajanSessionAppState();
}

class _JajanSessionAppState extends State<JajanSessionApp>
    with WidgetsBindingObserver {
  late final JajanProvider _provider;
  @override
  void initState() {
    super.initState();
    _provider = JajanProvider(
      source: widget.source,
      now: widget.now,
      autoRefreshClock: widget.autoRefreshClock,
    );
    WidgetsBinding.instance.addObserver(this);
    unawaited(_provider.mulai());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _provider.refreshClock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
    value: _provider,
    child: Consumer<JajanProvider>(
      builder: (context, p, _) => MaterialApp(
        title: widget.demo ? 'Jajan Meter — Demo transaksi' : 'Jajan Meter',
        debugShowCheckedModeBanner: false,
        theme: buildJajanTheme(),
        darkTheme: buildJajanTheme(brightness: Brightness.dark),
        themeMode: p.themeMode,
        home: JajanWorkspace(onSignOut: widget.onSignOut, demo: widget.demo),
      ),
    ),
  );
}
