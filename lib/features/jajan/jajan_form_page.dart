import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/jajan.dart';
import '../../providers/jajan_category.dart';
import '../../providers/jajan_provider.dart';
import '../../vaka_ui/formatters.dart';
import '../../vaka_ui/foundation/widgets/jm_button.dart';
import '../../vaka_ui/jajan_theme.dart';
import '../../vaka_ui/widgets/jajan_choice_chips.dart';
import '../../vaka_ui/widgets/jajan_surface.dart';
import 'jajan_shared.dart';

class JajanFormPage extends StatefulWidget {
  const JajanFormPage({super.key, this.original});
  final Jajan? original;
  @override
  State<JajanFormPage> createState() => _JajanFormPageState();
}

class _JajanFormPageState extends State<JajanFormPage> {
  late final TextEditingController _amount;
  late final TextEditingController _reason;
  late final TextEditingController _note;
  late DateTime _date;
  String? _category;
  String? _error;
  bool _saving = false;
  int get _nominal => int.tryParse(_amount.text) ?? 0;
  @override
  void initState() {
    super.initState();
    final value = widget.original;
    _amount = TextEditingController(text: value?.nominal.toString() ?? '');
    _reason = TextEditingController(text: value?.alasan ?? '');
    _note = TextEditingController(text: value?.catatan ?? '');
    _category = value == null ? null : kelompokKategori(value.kategori);
    _date = value?.tanggal.toLocal() ?? context.read<JajanProvider>().sekarang;
  }

  @override
  void dispose() {
    _amount.dispose();
    _reason.dispose();
    _note.dispose();
    super.dispose();
  }

  void _keypad(String value) {
    final old = _amount.text;
    final next = value == '⌫'
        ? (old.isEmpty ? '' : old.substring(0, old.length - 1))
        : old == '0'
        ? value
        : old + value;
    if (next.length <= 12) {
      setState(
        () => _amount.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (!mounted || date == null) return;
    setState(
      () => _date = DateTime(
        date.year,
        date.month,
        date.day,
        _date.hour,
        _date.minute,
        _date.second,
        _date.millisecond,
      ),
    );
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_date),
    );
    if (!mounted || time == null) return;
    setState(
      () => _date = DateTime(
        _date.year,
        _date.month,
        _date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final p = context.read<JajanProvider>();
    final id = await p.simpanJajan(
      original: widget.original,
      nominal: _nominal,
      kelompok: _category ?? '',
      alasan: _reason.text,
      tanggal: _date,
      catatan: _note.text,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (id != null && id.isNotEmpty) {
      Navigator.of(context).pop(id);
    } else {
      setState(
        () => _error = p.actionError ?? 'Belum berhasil menyimpan. Coba lagi.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<JajanProvider>();
    final canSave =
        !_saving &&
        !p.isSaving &&
        p.isReady &&
        _nominal > 0 &&
        _category != null &&
        _reason.text.trim().isNotEmpty;
    return PopScope(
      canPop: !_saving,
      child: JajanPage(
        title: widget.original == null ? 'Tambah Jajan' : 'Edit Jajan',
        subtitle: 'Catat sekarang, tenang kemudian.',
        onBack: _saving ? null : () => Navigator.of(context).pop(),
        child: LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 720;
            final amount = JajanSurface(
              child: Column(
                children: [
                  const Text('Berapa jajanmu?'),
                  const SizedBox(height: 12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      formatRupiah(_nominal),
                      key: const ValueKey('formatted_amount'),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: context.inkColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    key: const ValueKey('nominal_input'),
                    controller: _amount,
                    enabled: !_saving,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: 'Nominal',
                      prefixText: 'Rp ',
                      hintText: '0',
                      errorText: _amount.text.isNotEmpty && _nominal <= 0
                          ? 'Nominal harus lebih dari Rp0.'
                          : null,
                    ),
                  ),
                  if (wide) ...[
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, c) => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final value in [
                            '1',
                            '2',
                            '3',
                            '4',
                            '5',
                            '6',
                            '7',
                            '8',
                            '9',
                            '00',
                            '0',
                            '⌫',
                          ])
                            SizedBox(
                              width: (c.maxWidth - 16) / 3,
                              child: OutlinedButton(
                                onPressed: _saving
                                    ? null
                                    : () => _keypad(value),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: value == '⌫'
                                    ? const Icon(
                                        Icons.backspace_outlined,
                                        semanticLabel: 'Hapus satu digit',
                                      )
                                    : Text(
                                        value,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
            final inputs = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Pilih kategori',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                IgnorePointer(
                  ignoring: _saving,
                  child: JajanCategoryGrid(
                    selectedValue: _category,
                    onChanged: (value) => setState(() => _category = value),
                  ),
                ),
                if (widget.original != null &&
                    _category ==
                        kelompokKategori(widget.original!.kategori)) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Kategori tersimpan: ${widget.original!.kategori}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 28),
                Text(
                  'Alasan jajan',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                IgnorePointer(
                  ignoring: _saving,
                  child: JajanChoiceChips(
                    choices: jajanReasons,
                    useYellow: true,
                    selectedValue: jajanReasons
                        .where(
                          (r) =>
                              r.label.toLowerCase() ==
                              _reason.text.trim().toLowerCase(),
                        )
                        .firstOrNull
                        ?.value,
                    onChanged: (value) => setState(
                      () => _reason.text = jajanReasons
                          .firstWhere((r) => r.value == value)
                          .label,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const ValueKey('reason_input'),
                  controller: _reason,
                  enabled: !_saving,
                  onChanged: (_) => setState(() {}),
                  maxLength: 120,
                  decoration: const InputDecoration(
                    labelText: 'Alasan (wajib)',
                    hintText: 'Pilih di atas atau tulis alasanmu',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const ValueKey('note_input'),
                  controller: _note,
                  enabled: !_saving,
                  maxLines: 2,
                  maxLength: 300,
                  decoration: const InputDecoration(
                    labelText: 'Catatan (opsional)',
                    hintText: 'Misalnya: Nasi Ayam',
                    prefixIcon: Icon(Icons.edit_note_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      key: const ValueKey('form_date'),
                      onPressed: _saving ? null : _pickDate,
                      icon: const Icon(Icons.calendar_today_outlined, size: 18),
                      label: Text(formatTanggal(_date)),
                    ),
                    OutlinedButton.icon(
                      key: const ValueKey('form_time'),
                      onPressed: _saving ? null : _pickTime,
                      icon: const Icon(Icons.schedule_outlined, size: 18),
                      label: Text(formatJam(_date)),
                    ),
                  ],
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _error!,
                      key: const ValueKey('form_error'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                JmButton(
                  key: const ValueKey('save_jajan'),
                  label: widget.original == null
                      ? 'Simpan Jajan!'
                      : 'Simpan perubahan',
                  icon: Icons.check,
                  isLoading: _saving,
                  onPressed: canSave ? _save : null,
                  expand: true,
                ),
                const SizedBox(height: 12),
                Text(
                  _saving
                      ? 'Menunggu konfirmasi penyimpanan. Pastikan internet tersambung.'
                      : 'Isi nominal, kategori, dan alasan untuk menyimpan.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
            if (!wide) {
              return Column(
                children: [amount, const SizedBox(height: 24), inputs],
              );
            }
            return Row(
              key: const ValueKey('crud_form_two_columns'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: amount),
                const SizedBox(width: 24),
                Expanded(child: inputs),
              ],
            );
          },
        ),
      ),
    );
  }
}
