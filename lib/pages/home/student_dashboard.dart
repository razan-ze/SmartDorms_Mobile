import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/dorm_card.dart';
import '../profile/view_profile.dart';
import '../home/searchbar_page.dart';
import 'favorites.dart';
class StudentDashboard extends StatefulWidget {
  final Map<String, dynamic> userData;

  const StudentDashboard({super.key, required this.userData});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  List dorms = [];
  bool isLoading = true;
  int favoritesCount = 0;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await getDorms();
    await fetchFavoritesCount();
  }

  Future<void> getDorms() async {
    try {
      final url = Uri.parse('https://unistay-server-rm0e.onrender.com/dorms');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          dorms = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching dorms: $e");
    }
  }

  Future<void> fetchFavoritesCount() async {
    final url = Uri.parse(
      'https://unistay-server-rm0e.onrender.com/favorites/${widget.userData['id']}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          favoritesCount = json.decode(response.body).length;
        });
      }
    } catch (e) {
      debugPrint("Error fetching favorites count: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A5328),
        iconTheme: const IconThemeData(color: Color(0xFFF5F5DC)),
        centerTitle: true,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset(
            'assets/logoo.png',
            fit: BoxFit.contain,
            height: 40, // kbira shway
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () {}, // stays on dashboard
          ),
          // Favorite icon with counter only
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // Navigate to FavoritePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FavoritePage(userData: widget.userData),
                    ),
                  ).then(
                    (_) => fetchFavoritesCount(),
                  ); // refresh count on return
                },
              ),
              if (favoritesCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$favoritesCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewProfile(userData: widget.userData),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4A5328)),
            )
          : Column(
              children: [
                // SEARCH BAR
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (query) {
                      if (query.trim().isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SearchResultsPage(
                              searchQuery: query.trim(),
                              userData: widget.userData,
                            ),
                          ),
                        );
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Search dorms...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFF4A5328)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFF4A5328)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF4A5328),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                // DORMS GRID
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: dorms.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.90,
                        ),
                    itemBuilder: (context, index) {
                      return DormCard(
                        dorm: dorms[index],
                        userData: widget.userData,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
