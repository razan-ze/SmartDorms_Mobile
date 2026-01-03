import 'package:flutter/material.dart';

class DormLightbox extends StatelessWidget {
  final List<String> images;
  final int photoIndex;
  final VoidCallback onClose;
  final Function(int) onChangeIndex;

  const DormLightbox({
    super.key,
    required this.images,
    required this.photoIndex,
    required this.onClose,
    required this.onChangeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: Colors.black.withOpacity(0.85),
          child: Center(
            child: Stack(
              children: [
                Center(
                  child: Image.network(
                    images[photoIndex],
                    width: MediaQuery.of(context).size.width * 0.9,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  left: 16,
                  top: MediaQuery.of(context).size.height / 2 - 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
                    onPressed: () => onChangeIndex((photoIndex - 1 + images.length) % images.length),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: MediaQuery.of(context).size.height / 2 - 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 28),
                    onPressed: () => onChangeIndex((photoIndex + 1) % images.length),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: onClose,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
