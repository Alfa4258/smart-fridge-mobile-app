import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../app/app_colors.dart';
import '../app/app_constants.dart';
import '../models/ingredient.dart';
import '../services/mock_data.dart';
import '../widgets/ingredient_card.dart';

class IngredientScreen extends StatelessWidget {
  const IngredientScreen({super.key});

  Stream<Map<String, String>> _imageReferencesStream() {
    if (AppConstants.useMockData) {
      return const Stream<Map<String, String>>.empty();
    }
    return FirebaseDatabase.instance.ref('images_references').onValue.map((event) {
      final value = event.snapshot.value;
      final references = <String, String>{};

      if (value is Map) {
        for (final entry in value.entries) {
          final key = entry.key?.toString() ?? '';
          final entryValue = entry.value;
          if (entryValue is Map) {
            final url = entryValue['image_url']?.toString();
            if (url != null && url.isNotEmpty) {
              references[_normalizeKey(key)] = url;
            }
          }
        }
      }

      return references;
    });
  }

  String _normalizeKey(String value) {
    return value.toLowerCase().replaceAll('_', '');
  }

  Stream<List<Ingredient>> _ingredientsStream() {
    if (AppConstants.useMockData) {
      return Stream.value(buildMockIngredients());
    }
    return FirebaseDatabase.instance.ref('objects').onValue.map((event) {
      final value = event.snapshot.value;
      return _parseIngredientList(value);
    });
  }

  List<Ingredient> _parseIngredientList(dynamic value) {
    final items = <Ingredient>[];
    if (value is Map) {
      for (final entry in value.values) {
        if (entry is Map) {
          items.add(Ingredient.fromMap(entry));
        }
      }
    } else if (value is List) {
      for (final entry in value) {
        if (entry is Map) {
          items.add(Ingredient.fromMap(entry));
        }
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Ingredient>>(
        stream: _ingredientsStream(),
        builder: (context, snapshot) {
          final ingredients = snapshot.data ?? const <Ingredient>[];
          final isLoading = snapshot.connectionState == ConnectionState.waiting && ingredients.isEmpty;

          return StreamBuilder<Map<String, String>>(
            stream: _imageReferencesStream(),
            builder: (context, referenceSnapshot) {
              final references = referenceSnapshot.data ?? const <String, String>{};

              return Stack(
                children: [
                  SafeArea(
                    bottom: false,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final itemWidth = (constraints.maxWidth) / 3;
                          return Wrap(
                            children: List.generate(ingredients.length, (index) {
                              final ingredient = ingredients[index];
                              final fallbackUrl = references[_normalizeKey(ingredient.namaItem)];
                              return SizedBox(
                                width: itemWidth,
                                child: IngredientCard(
                                  ingredient: ingredient,
                                  fallbackImageUrl: fallbackUrl,
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
              // Recipe recommendation button removed per request.
                  if (isLoading)
                    const Center(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(color: AppColors.primaryGreen),
                      ),
                    ),
                  if (!isLoading && ingredients.isEmpty)
                    const Center(
                      child: Text('Tidak ada data bahan masakan'),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
