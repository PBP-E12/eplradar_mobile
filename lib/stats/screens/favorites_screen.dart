import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../services/favorite_service.dart';
import '../models/favorite_model.dart';
import '../widgets/favorite_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FavoriteList? favList;
  bool loading = true;

  List<dynamic> searchResults = [];
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final req = context.read<CookieRequest>();

    try {
      favList = await FavoriteService.fetchFavorites(req);
    } catch (_) {
      favList = FavoriteList(favorites: []);
    }

    setState(() => loading = false);
  }

  Future<void> deleteFavorite(String playerId) async {
    final req = context.read<CookieRequest>();
    await FavoriteService.deleteFavorite(req, playerId);
    loadFavorites();
  }

  Future<void> updateReason(String playerId, String reason) async {
    final req = context.read<CookieRequest>();
    await FavoriteService.updateReason(req, playerId, reason);
    loadFavorites();
  }

  Future<void> searchPlayers(String q) async {
    final req = context.read<CookieRequest>();
    final result = await FavoriteService.searchPlayer(req, q);
    setState(() => searchResults = result);
  }

  Future<void> addFavorite(String playerId) async {
    final req = context.read<CookieRequest>();
    await FavoriteService.addFavorite(req, playerId);
    searchCtrl.clear();
    setState(() => searchResults = []);
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF1D1F22);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Pemain Favorit Saya"),
        backgroundColor: bg,
        elevation: 0,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                TextField(
                  controller: searchCtrl,
                  onChanged: (v) {
                    if (v.length >= 2) {
                      searchPlayers(v);
                    } else {
                      setState(() => searchResults = []);
                    }
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Cari pemain...",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF3A3B3E),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 12),

                if (searchResults.isNotEmpty)
                  ...searchResults.map((p) {
                    final alreadyFav = favList!.favorites.any(
                      (f) => f.playerId == p['id'].toString(),
                    );

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2C2F),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${p['name']} - ${p['club']}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          IconButton(
                            icon: Icon(
                              alreadyFav ? Icons.check : Icons.add,
                              color: alreadyFav
                                  ? Colors.greenAccent
                                  : Color(0xFF2563eb),
                            ),
                            onPressed: alreadyFav
                                ? null // disable
                                : () => addFavorite(p["id"].toString()),
                          ),
                        ],
                      ),
                    );
                  }),

                const SizedBox(height: 20),

                if (favList != null)
                  ...favList!.favorites.map(
                    (f) => FavoriteCard(
                      image: f.photo,
                      name: f.name,
                      club: f.club,
                      initialReason: f.reason,
                      onSave: (r) => updateReason(f.playerId, r),
                      onDelete: () => deleteFavorite(f.playerId),
                    ),
                  ),
              ],
            ),
    );
  }
}
