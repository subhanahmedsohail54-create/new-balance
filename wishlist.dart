import 'package:flutter/material.dart';

class Wishlist extends StatelessWidget {
  final List<Map<String, dynamic>> wishlistItems;

  const Wishlist({super.key, required this.wishlistItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3489),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "MY WISHLIST",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: wishlistItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Color(0xFFCECBF6),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Your wishlist is empty",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF26215C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap ❤️ on any shoe to add it here",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF534AB7),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: wishlistItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final item = wishlistItems[index];
                  final List<Color> cardBgColors = [
                    Color(0xFFEEEDFE),
                    Color(0xFFFAEEDA),
                    Color(0xFFE1F5EE),
                    Color(0xFFFAECE7),
                  ];
                  final List<Color> priceColors = [
                    Color(0xFF534AB7),
                    Color(0xFF854F0B),
                    Color(0xFF0F6E56),
                    Color(0xFF993C1D),
                  ];
                  final bgColor = cardBgColors[index % cardBgColors.length];
                  final priceColor = priceColors[index % priceColors.length];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: bgColor, width: 0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(18)),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            item["image"],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 50, color: Colors.grey);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF26215C),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\$${item["price"]}",
                                style: TextStyle(
                                  color: priceColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}