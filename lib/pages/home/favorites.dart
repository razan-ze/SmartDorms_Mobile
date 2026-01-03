import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../home/dorm_details.dart';

class FavoritePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const FavoritePage({super.key, required this.userData});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final url = Uri.parse('https://unistay-server-rm0e.onrender.com/favorites/${widget.userData['id']}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          favorites = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> removeFavorite(int dormId) async {
    setState(() => favorites.removeWhere((d) => d['id'] == dormId));
    try {
      await http.delete(
        Uri.parse('https://unistay-server-rm0e.onrender.com/removeFavorite'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'student_id': widget.userData['id'], 'dorm_id': dormId}),
      );
    } catch (e) {
      fetchFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favorites", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4A5328),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text("Empty 😔"))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 13, mainAxisSpacing: 12, childAspectRatio: 0.99,
              ),
              itemBuilder: (context, index) {
                final dorm = favorites[index];
                // Handle image list from backend
                String img = (dorm['images'] != null && (dorm['images'] as List).isNotEmpty) 
                  ? dorm['images'][0] 
                  : 'https://via.placeholder.com/150';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DormDetailsPage(dormId: dorm['id'].toString(), userData: widget.userData)),
                    ).then((_) => fetchFavorites());
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(img, width: double.infinity, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 5, right: 5,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removeFavorite(dorm['id']),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(dorm['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}