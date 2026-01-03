import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../widgets/dormInfoCard.dart';
import '../../widgets/dorm_lightBox.dart';
import '../profile/view_profile.dart';
import '../home/student_dashboard.dart';
import 'favorites.dart';

class DormDetailsPage extends StatefulWidget {
  final String dormId;
  final Map<String, dynamic> userData;

  const DormDetailsPage({
    super.key,
    required this.dormId,
    required this.userData,
  });

  @override
  State<DormDetailsPage> createState() => _DormDetailsPageState();
}

class _DormDetailsPageState extends State<DormDetailsPage> {
  Map<String, dynamic>? dorm;
  bool isLoading = true;
  bool isFavorite = false;
  int favoritesCount = 0;
  bool showAllImages = false;
  bool lightboxOpen = false;
  int photoIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // Load dorm details, favorites count, and check if favorite
  Future<void> _loadAllData() async {
    await fetchDorm();
    await fetchFavoritesCount();
    await checkIfFavorite();
  }

  Future<void> fetchDorm() async {
    final url = Uri.parse('https://unistay-server-rm0e.onrender.com/dorm/${widget.dormId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List images = [];
        if (data['images'] != null) {
          if (data['images'] is String) {
            images = data['images'].split(',').where((img) => img.isNotEmpty).toList();
          } else {
            images = List<String>.from(data['images']);
          }
        }
        setState(() {
          dorm = {...data, 'images': images};
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching dorm: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> checkIfFavorite() async {
    final url = Uri.parse('https://unistay-server-rm0e.onrender.com/favorites/${widget.userData['id']}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          isFavorite = data.any((f) => f['id'].toString() == widget.dormId.toString());
        });
      }
    } catch (e) {
      debugPrint("Error checking favorite: $e");
    }
  }

  Future<void> fetchFavoritesCount() async {
    final url = Uri.parse('https://unistay-server-rm0e.onrender.com/favorites/${widget.userData['id']}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          favoritesCount = json.decode(response.body).length;
        });
      }
    } catch (e) {
      debugPrint("Error count: $e");
    }
  }

  Future<void> toggleFavorite() async {
    final studentId = widget.userData['id'];
    final dId = dorm!['id'];
    bool previousState = isFavorite;

    // Optimistic UI
    setState(() => isFavorite = !isFavorite);

    try {
      if (previousState) {
        final response = await http.delete(
          Uri.parse('https://unistay-server-rm0e.onrender.com/removeFavorite'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'student_id': studentId, 'dorm_id': dId}),
        );
        if (response.statusCode != 200) throw Exception();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Removed from favorites 💔")),
        );
      } else {
        final response = await http.post(
          Uri.parse('https://unistay-server-rm0e.onrender.com/addFavorite'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'student_id': studentId, 'dorm_id': dId}),
        );
        if (response.statusCode != 200 && response.statusCode != 201) throw Exception();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added to favorites ❤️")),
        );
      }
      fetchFavoritesCount();
    } catch (e) {
      setState(() => isFavorite = previousState);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Action failed. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF4A5328)),
        ),
      );
    }

    final images = dorm!['images'].isNotEmpty ? dorm!['images'] : ['https://via.placeholder.com/300'];
    final displayedImages = showAllImages ? images : images.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A5328),
        iconTheme: const IconThemeData(color: Color(0xFFF5F5DC)),
        centerTitle: false, 
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Image.asset('assets/logoo.png', height: 50),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => StudentDashboard(userData: widget.userData)),
              (route) => false,
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FavoritePage(userData: widget.userData)),
                  ).then((_) => _loadAllData());
                },
              ),
              if (favoritesCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$favoritesCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ViewProfile(userData: widget.userData)),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Images Grid
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(displayedImages.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            photoIndex = index;
                            lightboxOpen = true;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            displayedImages[index],
                            width: (MediaQuery.of(context).size.width - 48) / 3,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                if (images.length > 3)
                  TextButton(
                    onPressed: () => setState(() => showAllImages = !showAllImages),
                    child: Text(
                      showAllImages ? "Show Less" : "Show More",
                      style: const TextStyle(
                        color: Color(0xFFB6974D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                // Dorm Info Card
                DormInfoCard(
                  dorm: dorm!,
                  isFavorite: isFavorite,
                  onToggleFavorite: toggleFavorite,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          // Lightbox Overlay
          if (lightboxOpen)
            DormLightbox(
              images: List<String>.from(images),
              photoIndex: photoIndex,
              onClose: () => setState(() => lightboxOpen = false),
              onChangeIndex: (newIndex) => setState(() => photoIndex = newIndex),
            ),
        ],
      ),
    );
  }
}
