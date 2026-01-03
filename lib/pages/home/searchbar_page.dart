import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/dorm_card.dart';
import '../../widgets/searchbar.dart';

class SearchResultsPage extends StatefulWidget {
  final String searchQuery;
  final Map<String, dynamic> userData;
  const SearchResultsPage({super.key, required this.searchQuery,required this.userData});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List dorms = [];
  bool isLoading = true;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.searchQuery);
    fetchSearchResults(widget.searchQuery);
  }

  Future<void> fetchSearchResults(String query) async {
    setState(() => isLoading = true);

    try {
      final url = Uri.parse(
        "https://unistay-server-rm0e.onrender.com/dorms/search?q=$query",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          dorms = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A5328),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFF5F2E7), // beige
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Search Dorms",
          style: TextStyle(
            color: Color(0xFFF5F2E7), // beige
            fontSize: 20,
           
          ),
        ),
      ),

      body: Column(
        children: [
          //  SEARCH BAR (same as dashboard)
         DormSearchBar(controller: searchController,userData: widget.userData),

          // RESULTS
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4A5328)),
                  )
                : dorms.isEmpty
                ? const Center(
                    child: Text(
                      "No results found",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : GridView.builder(
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
                      return DormCard(dorm: dorms[index],userData: widget.userData);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}