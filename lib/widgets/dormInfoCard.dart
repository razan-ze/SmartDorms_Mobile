import 'package:flutter/material.dart';

class DormInfoCard extends StatelessWidget {
  final Map<String, dynamic> dorm;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const DormInfoCard({
    super.key,
    required this.dorm,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF4A5328), width: 1.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              dorm['name'] ?? "Dorm Name",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A5328),
              ),
            ),
            const SizedBox(height: 10),

            InfoRow(title: "City", value: dorm['city']),
            InfoRow(title: "Price", value: dorm['price'] != null ? "\$${dorm['price']}/mo" : "N/A"),
            InfoRow(title: "University", value: dorm['university']),
            InfoRow(title: "Phone", value: dorm['telephone']),
            InfoRow(title: "Distance", value: dorm['distance_to_university']?.toString()),

            const SizedBox(height: 10),

            const Text(
              "Features",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A5328),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                if (dorm['feature1'] != null) FeatureChip(label: dorm['feature1']),
                if (dorm['feature2'] != null) FeatureChip(label: dorm['feature2']),
                if (dorm['feature3'] != null) FeatureChip(label: dorm['feature3']),
              ],
            ),

            const SizedBox(height: 12),

            // --- TOGGLE BUTTON LOGIC START ---
            SizedBox(
              width: 180, // Increased width slightly to fit longer text
              height: 36,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // 1. Change Background Color based on status
                  backgroundColor: isFavorite 
                      ? Colors.red.shade700 // Red if it's already a favorite
                      : const Color(0xFFB6974D), // Mustard if not
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                onPressed: onToggleFavorite,
                // 2. Change Icon based on status
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: Colors.white,
                ),
                // 3. Change Label Text based on status
                label: Text(
                  isFavorite ? "Remove from Favorites" : "Add to Favorites",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // --- TOGGLE BUTTON LOGIC END ---
          ],
        ),
      ),
    );
  }
}

// -------- Helper Widgets --------
class InfoRow extends StatelessWidget {
  final String title;
  final dynamic value;

  const InfoRow({super.key, required this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A5328), // Olive
              fontSize: 12,
            ),
          ),
          Flexible(
            child: Text(
              value?.toString() ?? "-",
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureChip extends StatelessWidget {
  final String label;

  const FeatureChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFB6974D).withOpacity(0.2), // Mustard soft
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF4A5328), // Olive
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
