import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subhan/Adidas.dart';
import 'package:subhan/Jordan.dart';
import 'package:subhan/Leather.dart';
import 'package:subhan/Puma.dart';
import 'package:subhan/final.dart';
import 'package:subhan/Profile.dart';

class Shoes extends StatefulWidget {
  const Shoes({super.key});

  @override
  State<Shoes> createState() => _ShoesState();
}

class _ShoesState extends State<Shoes> {
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> favoriteItems = [];

  Uint8List? _profileImage;
  bool _isDarkMode = false;
  String _searchQuery = "";
  String _selectedCategory = "All"; // ✅ Category filter

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      final bytes = await picked.readAsBytes();
      setState(() => _profileImage = bytes);
    }
  }

  // ✅ 2 naye shoes add ki hain + category field
  final List<Map<String, dynamic>> shoes = [
    {"name": "Leather Shoes",  "image": "lib/images/7.png",  "price": 120, "category": "Formal"},
    {"name": "Jordan",         "image": "lib/images/2.png",  "price": 150, "category": "Sports"},
    {"name": "Adidas Run",     "image": "lib/images/6.png",  "price": 100, "category": "Running"},
    {"name": "Puma Classic",   "image": "lib/images/8.png",  "price": 90,  "category": "Casual"},
    {"name": "Nike Air Max",   "image": "lib/images/10.png",  "price": 180, "category": "Sports"},
    {"name": "Oxford Classic", "image": "lib/images/11.png", "price": 200, "category": "Formal"},
  ];

  final List<Color> cardBgColors = [
    Color(0xFFEEEDFE),
    Color(0xFFFAEEDA),
    Color(0xFFE1F5EE),
    Color(0xFFFAECE7),
    Color(0xFFE6F1FB),
    Color(0xFFF1EFE8),
  ];

  final List<Color> btnColors = [
    Color(0xFF3C3489),
    Color(0xFFBA7517),
    Color(0xFF0F6E56),
    Color(0xFFD85A30),
    Color(0xFF185FA5),
    Color(0xFF5F5E5A),
  ];

  final List<Color> priceColors = [
    Color(0xFF534AB7),
    Color(0xFF854F0B),
    Color(0xFF0F6E56),
    Color(0xFF993C1D),
    Color(0xFF185FA5),
    Color(0xFF444441),
  ];

  // ✅ Categories list
  final List<String> categories = ["All", "Sports", "Casual", "Formal", "Running"];

  @override
  Widget build(BuildContext context) {
    // ✅ Search + Category filter dono saath
    final filteredShoes = shoes.where((s) {
      final matchesSearch =
          s["name"].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == "All" || s["category"] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF1A1A2E) : const Color(0xFFF5F3FF),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF3C3489),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: _profileImage != null
                              ? MemoryImage(_profileImage!)
                              : const NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfaxitJiL1cTSkHkw_43kxGknd-sSF7OceaA&s",
                                ) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt,
                                size: 16, color: Color(0xFF3C3489)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Subhan Sohail",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF534AB7)),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                      profileImage: _profileImage,
                      onImageChanged: (bytes) =>
                          setState(() => _profileImage = bytes),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF534AB7)),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading:
                  const Icon(Icons.shopping_cart, color: Color(0xFF534AB7)),
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => Cart(cartItems: cartItems)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Favorites'),
              trailing: favoriteItems.isNotEmpty
                  ? CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text("${favoriteItems.length}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10)),
                    )
                  : null,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            FavoritesScreen(favoriteItems: favoriteItems)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF534AB7)),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3489),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "NEW BALANCE",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5),
        ),
        actions: [
          IconButton(
            icon: Icon(
                _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white),
            onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined,
                    color: Colors.white),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Cart(cartItems: cartItems))),
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                        color: Color(0xFFEF9F27), shape: BoxShape.circle),
                    child: Center(
                      child: Text("${cartItems.length}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("WELCOME BACK 👋",
                style: TextStyle(
                    color: Color(0xFF534AB7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(
              "Find your perfect pair",
              style: TextStyle(
                  color: _isDarkMode
                      ? Colors.white
                      : const Color(0xFF26215C),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            // Search bar
            TextFormField(
              style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black),
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: "Search shoes...",
                hintStyle: const TextStyle(color: Color(0xFFAFA9EC)),
                filled: true,
                fillColor: _isDarkMode
                    ? const Color(0xFF2A2A3E)
                    : Colors.white,
                prefixIcon:
                    const Icon(Icons.search, color: Color(0xFF534AB7)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: Color(0xFFCECBF6), width: 0.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: Color(0xFFCECBF6), width: 0.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: Color(0xFF534AB7), width: 1.5)),
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Category Filter Row
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF3C3489)
                            : (_isDarkMode
                                ? const Color(0xFF2A2A3E)
                                : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF3C3489)
                              : const Color(0xFFCECBF6),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (_isDarkMode
                                  ? Colors.white70
                                  : const Color(0xFF534AB7)),
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            const Divider(color: Color(0xFFCECBF6), thickness: 0.5),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Featured",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode
                            ? Colors.white
                            : const Color(0xFF26215C))),
                const Text("See all",
                    style: TextStyle(
                        fontSize: 13, color: Color(0xFF534AB7))),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: filteredShoes.isEmpty
                  ? Center(
                      child: Text(
                        "No shoes found 👟",
                        style: TextStyle(
                            fontSize: 16,
                            color: _isDarkMode
                                ? Colors.white54
                                : const Color(0xFF534AB7)),
                      ),
                    )
                  : GridView.builder(
                      itemCount: filteredShoes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.70,
                      ),
                      itemBuilder: (context, index) {
                        final shoe = filteredShoes[index];
                        final originalIndex = shoes
                            .indexWhere((s) => s["name"] == shoe["name"]);
                        bool isFav = favoriteItems
                            .any((e) => e["name"] == shoe["name"]);

                        return Container(
                          decoration: BoxDecoration(
                            color: _isDarkMode
                                ? const Color(0xFF2A2A3E)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: cardBgColors[originalIndex],
                                width: 0.8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  InkWell(
                                    borderRadius:
                                        const BorderRadius.vertical(
                                            top: Radius.circular(18)),
                                    onTap: () {
                                      if (originalIndex == 0) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const Leather()));
                                      } else if (originalIndex == 1) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const Jordan()));
                                      } else if (originalIndex == 2) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const Adidas()));
                                      } else if (originalIndex == 3) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const Puma()));
                                      }
                                      // Index 4 & 5 ke liye apni detail pages banao
                                    },
                                    child: Container(
                                      height: 120,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color:
                                            cardBgColors[originalIndex],
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(18)),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        shoe["image"],
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            const Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isFav) {
                                            favoriteItems.removeWhere(
                                                (e) =>
                                                    e["name"] ==
                                                    shoe["name"]);
                                          } else {
                                            favoriteItems.add(shoe);
                                          }
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(isFav
                                              ? "Removed from favorites"
                                              : "Added to favorites ❤️"),
                                          duration:
                                              const Duration(seconds: 1),
                                        ));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          isFav
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFav
                                              ? Colors.red
                                              : Colors.grey,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12, 8, 12, 10),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shoe["name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: _isDarkMode
                                              ? Colors.white
                                              : const Color(0xFF26215C)),
                                    ),
                                    const SizedBox(height: 1),
                                    // ✅ Category badge
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color:
                                            cardBgColors[originalIndex],
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        shoe["category"],
                                        style: TextStyle(
                                            fontSize: 10,
                                            color:
                                                btnColors[originalIndex],
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "\$${shoe["price"]}",
                                      style: TextStyle(
                                          color:
                                              priceColors[originalIndex],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              btnColors[originalIndex],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10)),
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 7),
                                          elevation: 0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            cartItems.add({
                                              "name": shoe["name"],
                                              "image": shoe["image"],
                                              "price": shoe["price"],
                                              "quantity": 1,
                                              "size": "42",
                                              "color": "Black",
                                            });
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Added to cart ✅")));
                                        },
                                        child: const Text(
                                          "Add to Cart",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
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
          ],
        ),
      ),
    );
  }
}

// Favorites Screen (unchanged)
class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteItems;
  const FavoritesScreen({super.key, required this.favoriteItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3489),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Favorites",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text("No favorites yet ❤️",
                  style: TextStyle(
                      fontSize: 16, color: Color(0xFF534AB7))))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final shoe = favoriteItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFCECBF6), width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: const Color(0xFFEEEDFE),
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.asset(shoe["image"],
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey)),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(shoe["name"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF26215C))),
                          const SizedBox(height: 4),
                          Text("\$${shoe["price"]}",
                              style: const TextStyle(
                                  color: Color(0xFF534AB7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.favorite, color: Colors.red, size: 20),
                    ],
                  ),
                );
              },
            ),
    );
  }
}