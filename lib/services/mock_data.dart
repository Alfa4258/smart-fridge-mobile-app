import '../models/ingredient.dart';

List<Ingredient> buildMockIngredients() {
  return const [
    Ingredient(
      id: 1,
      count: 3,
      frequency: 2,
      isFresh: 1,
      imageUrl: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?q=80&w=800&auto=format&fit=crop',
      entryTime: '2026-05-13T08:30:00.000000',
      lastUpdated: '2026-05-14T09:00:00.000000',
      namaItem: 'Tomat',
      status: 'is_fresh',
    ),
    Ingredient(
      id: 2,
      count: 1,
      frequency: 1,
      isFresh: 0,
      imageUrl: 'https://images.unsplash.com/photo-1506806732259-39c2d0268443?q=80&w=800&auto=format&fit=crop',
      entryTime: '2026-05-10T10:00:00.000000',
      lastUpdated: '2026-05-14T08:15:00.000000',
      namaItem: 'Bayam',
      status: 'is_rotten',
    ),
    Ingredient(
      id: 3,
      count: 5,
      frequency: 3,
      isFresh: 1,
      imageUrl: 'https://images.unsplash.com/photo-1518977956815-de1f9944fbbd?q=80&w=800&auto=format&fit=crop',
      entryTime: '2026-05-12T07:00:00.000000',
      lastUpdated: '2026-05-14T07:45:00.000000',
      namaItem: 'Wortel',
      status: 'is_fresh',
    ),
  ];
}
