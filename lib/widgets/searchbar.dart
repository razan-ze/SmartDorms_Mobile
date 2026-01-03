import 'package:flutter/material.dart';
import '../pages/home/searchbar_page.dart'; // adjust path

class DormSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Map<String, dynamic> userData;
  const DormSearchBar({super.key, required this.controller,required this.userData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: (query) {
          if (query.trim().isNotEmpty) {
            controller.clear(); // clear input after search
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchResultsPage(searchQuery: query.trim(),userData: userData),
              ),
            );
          }
        },
        decoration: InputDecoration(
          hintText: "Search dorms...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
    );
  }
}