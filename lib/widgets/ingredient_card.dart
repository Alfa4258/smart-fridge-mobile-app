import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../app/app_colors.dart';
import '../models/ingredient.dart';
import '../utils/date_utils.dart';

/// Converts a Firebase snake_case name to display-friendly Title Case.
/// e.g. "sawi_hijau" → "Sawi Hijau", "nanas" → "Nanas"
String _formatIngredientName(String raw) {
  return raw
      .split('_')
      .map((word) => word.isEmpty
          ? word
          : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}

class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  final String? fallbackImageUrl;

  const IngredientCard({super.key, required this.ingredient, this.fallbackImageUrl});

  @override
  Widget build(BuildContext context) {
    final days = daysSince(ingredient.entryTime);
    final dayText = days < 1 ? 'Baru' : '$days Hari';
    final displayName = _formatIngredientName(ingredient.namaItem);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Pilih URL yang valid: imageUrl dari objek, fallback dari images_references, atau kosong
    final imageUrl = ingredient.imageUrl.isNotEmpty
        ? ingredient.imageUrl
        : (fallbackImageUrl ?? '');

    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      shadowColor: Colors.black26,
      // ikut cardTheme (white di light, cardDark di dark)
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: _IngredientImage(
                    imageUrl: imageUrl,
                    fallbackUrl: fallbackImageUrl,
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: _StatusChip(status: ingredient.status),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              displayName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textDarkMode : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '$dayText | ${ingredient.count} item',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.grey500Dark : AppColors.grey500,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.update, size: 15, color: AppColors.primaryGreen),
                const SizedBox(width: 2),
                Text(
                  relativeTime(ingredient.lastUpdated),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.grey500Dark : AppColors.grey500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget gambar yang mencoba imageUrl utama, lalu fallback dari images_references.
/// Menggunakan CachedNetworkImage seperti Glide di app lama (cache + placeholder).
/// Headers meniru Android WebView agar tidak diblokir hotlink protection
/// (Glide secara otomatis menyertakan User-Agent Android, Flutter tidak).
class _IngredientImage extends StatefulWidget {
  final String imageUrl;
  final String? fallbackUrl;

  const _IngredientImage({required this.imageUrl, this.fallbackUrl});

  @override
  State<_IngredientImage> createState() => _IngredientImageState();
}

class _IngredientImageState extends State<_IngredientImage> {
  // User-Agent identik dengan yang dikirim Glide/Android WebView secara default.
  // Ini kunci agar server seperti pngtree.com tidak memblokir request.
  static const Map<String, String> _headers = {
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36',
    'Referer': 'https://www.google.com/',
  };

  late String _activeUrl;
  bool _usedFallback = false;

  @override
  void initState() {
    super.initState();
    _activeUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(covariant _IngredientImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _activeUrl = widget.imageUrl;
      _usedFallback = false;
    }
  }

  void _tryFallback() {
    final fallback = widget.fallbackUrl;
    if (!_usedFallback &&
        fallback != null &&
        fallback.isNotEmpty &&
        _activeUrl != fallback) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _activeUrl = fallback;
            _usedFallback = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_activeUrl.isEmpty) {
      _tryFallback();
      return Icon(
        Icons.image_not_supported,
        color: AppColors.grey500,
        size: 32,
      );
    }

    return CachedNetworkImage(
      imageUrl: _activeUrl,
      httpHeaders: _headers,
      cacheKey: 'v2_$_activeUrl',
      fit: BoxFit.contain,
      placeholder: (context, url) => const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        _tryFallback();
        return const Icon(
          Icons.image_not_supported,
          color: AppColors.grey500,
          size: 32,
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    // cFresh: cardBackgroundColor primary_green, cornerRadius 15dp
    if (status == 'is_fresh') {
      return _buildChip('SEGAR', AppColors.primaryGreen, AppColors.white);
    }
    // cNotFresh: cardBackgroundColor accent_red, cornerRadius 15dp
    if (status == 'is_rotten') {
      return _buildChip('TIDAK SEGAR', AppColors.accentRed, AppColors.white);
    }
    return const SizedBox.shrink();
  }

  Widget _buildChip(String text, Color background, Color foreground) {
    return Container(
      // layout_marginHorizontal="5dp" layout_marginVertical="2dp"
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        // textSize="8sp"
        style: TextStyle(fontSize: 8, color: foreground),
      ),
    );
  }
}
