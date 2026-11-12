import 'package:flutter/material.dart';

/// Provider belum tersedia di AuthService. Callback null = tombol nonaktif.
/// Jangan menyamakan klik UI dengan autentikasi yang berhasil.
class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({
    super.key,
    this.onGoogle,
    this.onApple,
    this.onFacebook,
  });
  final VoidCallback? onGoogle;
  final VoidCallback? onApple;
  final VoidCallback? onFacebook;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final item in [
        (label: 'Google', callback: onGoogle),
        (label: 'Apple', callback: onApple),
        (label: 'Facebook', callback: onFacebook),
      ])
        Tooltip(
          message: item.callback == null
              ? '${item.label}: belum tersedia'
              : 'Masuk dengan ${item.label}',
          child: OutlinedButton(
            onPressed: item.callback,
            child: Text(item.label),
          ),
        ),
    ],
  );
}
