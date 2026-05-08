import 'package:flutter/material.dart';
import 'package:subhan/orderconfirm.dart'; // ⭐ Import add karo

class Cart extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const Cart({super.key, required this.cartItems});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
  }

  int getTotalPrice() {
    int total = 0;
    for (var item in cartItems) {
      total += (item["price"] as int) * (item["quantity"] as int);
    }
    return total;
  }

  void updateQuantity(int index, bool increase) {
    setState(() {
      if (increase) {
        cartItems[index]["quantity"]++;
      } else {
        if (cartItems[index]["quantity"] > 1) {
          cartItems[index]["quantity"]--;
        }
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

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

  final List<Color> btnColors = [
    Color(0xFF3C3489),
    Color(0xFFBA7517),
    Color(0xFF0F6E56),
    Color(0xFFD85A30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),

      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3489),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Cart",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),

      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Color(0xFFCECBF6)),
                  SizedBox(height: 16),
                  Text(
                    "Cart is Empty",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF534AB7),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Add some shoes to get started!",
                    style: TextStyle(fontSize: 13, color: Color(0xFFAFA9EC)),
                  ),
                ],
              ),
            )
          : Column(
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Row(
                    children: [
                      Text(
                        "${cartItems.length} item${cartItems.length > 1 ? 's' : ''} in cart",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF534AB7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final colorIndex = index % cardBgColors.length;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: cardBgColors[colorIndex], width: 0.8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [

                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: cardBgColors[colorIndex],
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  item["image"],
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image_not_supported, color: Colors.grey);
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["name"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF26215C),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "\$${item["price"] * item["quantity"]}",
                                      style: TextStyle(
                                        color: priceColors[colorIndex],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => updateQuantity(index, false),
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: cardBgColors[colorIndex],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(Icons.remove, size: 16, color: btnColors[colorIndex]),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          item["quantity"].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF26215C),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () => updateQuantity(index, true),
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: btnColors[colorIndex],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(Icons.add, size: 16, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              GestureDetector(
                                onTap: () => removeItem(index),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFCEBEB),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.delete_outline, color: Color(0xFFE24B4A), size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ⭐ Total + Checkout
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    border: Border(top: BorderSide(color: Color(0xFFEEEDFE), width: 1)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Amount",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF534AB7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "\$${getTotalPrice()}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF26215C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3C3489),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          // ⭐ Navigate to OrderConfirmed
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderConfirmed(
                                  totalAmount: getTotalPrice(),
                                  cartItems: List.from(cartItems),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Proceed to Checkout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}