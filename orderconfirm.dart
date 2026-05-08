import 'package:flutter/material.dart';

class OrderConfirmed extends StatefulWidget {
  final int totalAmount;
  final List<Map<String, dynamic>> cartItems;

  const OrderConfirmed({
    super.key,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<OrderConfirmed> createState() => _OrderConfirmedState();
}

class _OrderConfirmedState extends State<OrderConfirmed>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _checkAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Fake order details
  final String orderId = "#NB-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
  final String estimatedDelivery = "Apr 5 – Apr 7, 2025";
  final String paymentMethod = "Credit Card •••• 4242";

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _checkAnimation = CurvedAnimation(parent: _checkController, curve: Curves.elasticOut);
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Staggered animations
    _checkController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3489),
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Order Confirmed",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // ⭐ Animated Check Circle
            const SizedBox(height: 10),
            ScaleTransition(
              scale: _checkAnimation,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F5EE),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0F6E56), width: 2),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF0F6E56),
                  size: 56,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ⭐ Fade in title
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Text(
                    "Order Placed!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF26215C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Your order $orderId has been confirmed.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF534AB7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ⭐ Slide in content
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [

                    // ⭐ Delivery Progress Bar
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFEEEDFE), width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order Status",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF26215C),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _statusStep(Icons.check_circle, "Confirmed", true, true),
                              _statusLine(true),
                              _statusStep(Icons.inventory_2_outlined, "Packed", false, false),
                              _statusLine(false),
                              _statusStep(Icons.local_shipping_outlined, "Shipped", false, false),
                              _statusLine(false),
                              _statusStep(Icons.home_outlined, "Delivered", false, false),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Confirmed", style: TextStyle(fontSize: 9, color: Color(0xFF0F6E56), fontWeight: FontWeight.w600)),
                              Text("Packed", style: TextStyle(fontSize: 9, color: Color(0xFFAFA9EC))),
                              Text("Shipped", style: TextStyle(fontSize: 9, color: Color(0xFFAFA9EC))),
                              Text("Delivered", style: TextStyle(fontSize: 9, color: Color(0xFFAFA9EC))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ⭐ Order Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFEEEDFE), width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF26215C),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _infoRow("Order ID", orderId),
                          const Divider(color: Color(0xFFEEEDFE), height: 20),
                          _infoRow("Estimated Delivery", estimatedDelivery),
                          const Divider(color: Color(0xFFEEEDFE), height: 20),
                          _infoRow("Payment", paymentMethod),
                          const Divider(color: Color(0xFFEEEDFE), height: 20),
                          _infoRow("Total Paid", "\$${widget.totalAmount}", isPrice: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ⭐ Items Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFEEEDFE), width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.cartItems.length} Item${widget.cartItems.length > 1 ? 's' : ''} Ordered",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF26215C),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...widget.cartItems.asMap().entries.map((entry) {
                            final i = entry.key;
                            final item = entry.value;
                            final List<Color> bgColors = [
                              Color(0xFFEEEDFE),
                              Color(0xFFFAEEDA),
                              Color(0xFFE1F5EE),
                              Color(0xFFFAECE7),
                            ];
                            final colorIndex = i % bgColors.length;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: bgColors[colorIndex],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: Image.asset(
                                      item["image"],
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
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
                                            fontSize: 13,
                                            color: Color(0xFF26215C),
                                          ),
                                        ),
                                        Text(
                                          "Qty: ${item["quantity"]}  •  Size: ${item["size"]}",
                                          style: const TextStyle(fontSize: 11, color: Color(0xFFAFA9EC)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "\$${item["price"] * item["quantity"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF534AB7),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ⭐ Continue Shopping Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3C3489),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Go back to home
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text(
                          "Continue Shopping",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ⭐ Track Order Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF3C3489), width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Track Order",
                          style: TextStyle(
                            color: Color(0xFF3C3489),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⭐ Helper: Status Step
  Widget _statusStep(IconData icon, String label, bool active, bool done) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: done ? const Color(0xFF0F6E56) : (active ? const Color(0xFFE1F5EE) : const Color(0xFFF5F3FF)),
            shape: BoxShape.circle,
            border: Border.all(
              color: done ? const Color(0xFF0F6E56) : const Color(0xFFCECBF6),
              width: 1.5,
            ),
          ),
          child: Icon(icon, size: 18, color: done ? Colors.white : const Color(0xFFAFA9EC)),
        ),
      ],
    );
  }

  // ⭐ Helper: Status Line
  Widget _statusLine(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? const Color(0xFF0F6E56) : const Color(0xFFE0DEFF),
      ),
    );
  }

  // ⭐ Helper: Info Row
  Widget _infoRow(String label, String value, {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF534AB7))),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrice ? 16 : 13,
            fontWeight: isPrice ? FontWeight.bold : FontWeight.w500,
            color: isPrice ? const Color(0xFF26215C) : const Color(0xFF26215C),
          ),
        ),
      ],
    );
  }
}