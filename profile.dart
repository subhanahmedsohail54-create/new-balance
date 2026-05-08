import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final Uint8List? profileImage;
  final Function(Uint8List) onImageChanged;

  const ProfileScreen({
    super.key,
    required this.profileImage,
    required this.onImageChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _image;

  // ⭐ Editable fields
  String _name = "Subhan Sohail";
  String _phone = "03002757703";
  String _address = "Karachi, Pakistan";
  String _email = "subhan@gmail.com";

  @override
  void initState() {
    super.initState();
    _image = widget.profileImage;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      final bytes = await picked.readAsBytes();
      setState(() => _image = bytes);
      widget.onImageChanged(bytes);
    }
  }

  // ⭐ Edit dialog
  void _editField(String title, String currentValue, IconData icon, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(icon, color: const Color(0xFF534AB7), size: 20),
            const SizedBox(width: 8),
            Text(
              "Edit $title",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF26215C),
              ),
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter $title",
            filled: true,
            fillColor: const Color(0xFFF5F3FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCECBF6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF534AB7), width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C3489),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3489),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              _editField("Name", _name, Icons.person, (val) => setState(() => _name = val));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ⭐ Header background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 30, bottom: 40),
              decoration: const BoxDecoration(
                color: Color(0xFF3C3489),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // ⭐ Badi photo
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: _image != null
                                ? MemoryImage(_image!)
                                : const NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfaxitJiL1cTSkHkw_43kxGknd-sSF7OceaA&s",
                                  ) as ImageProvider,
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF9F27),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Premium Member ⭐",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ⭐ Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFCECBF6), width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3C3489).withOpacity(0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.person,
                    label: "Name",
                    value: _name,
                    onEdit: () => _editField(
                      "Name", _name, Icons.person,
                      (val) => setState(() => _name = val),
                    ),
                  ),
                  _divider(),
                  _buildInfoTile(
                    icon: Icons.phone,
                    label: "Phone",
                    value: _phone,
                    onEdit: () => _editField(
                      "Phone", _phone, Icons.phone,
                      (val) => setState(() => _phone = val),
                    ),
                  ),
                  _divider(),
                  _buildInfoTile(
                    icon: Icons.email,
                    label: "Email",
                    value: _email,
                    onEdit: () => _editField(
                      "Email", _email, Icons.email,
                      (val) => setState(() => _email = val),
                    ),
                  ),
                  _divider(),
                  _buildInfoTile(
                    icon: Icons.location_on,
                    label: "Address",
                    value: _address,
                    onEdit: () => _editField(
                      "Address", _address, Icons.location_on,
                      (val) => setState(() => _address = val),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ⭐ Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatCard("Orders", "12", Icons.shopping_bag, const Color(0xFFEEEDFE), const Color(0xFF534AB7)),
                  const SizedBox(width: 12),
                  _buildStatCard("Favorites", "5", Icons.favorite, const Color(0xFFFFEEEE), Colors.red),
                  const SizedBox(width: 12),
                  _buildStatCard("Reviews", "8", Icons.star, const Color(0xFFFFF8E7), const Color(0xFFEF9F27)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ⭐ Extra options
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFCECBF6), width: 0.8),
              ),
              child: Column(
                children: [
                  _buildOptionTile(Icons.notifications_outlined, "Notifications", const Color(0xFF534AB7)),
                  _divider(),
                  _buildOptionTile(Icons.lock_outline, "Privacy & Security", const Color(0xFF534AB7)),
                  _divider(),
                  _buildOptionTile(Icons.help_outline, "Help & Support", const Color(0xFF534AB7)),
                  _divider(),
                  _buildOptionTile(Icons.logout, "Logout", Colors.red),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEDFE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF534AB7), size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF26215C),
        ),
      ),
      trailing: GestureDetector(
        onTap: onEdit,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEDFE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.edit, size: 16, color: Color(0xFF534AB7)),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color bgColor, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, Color color) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: title == "Logout" ? Colors.red : const Color(0xFF26215C),
        ),
      ),
      trailing: title == "Logout"
          ? null
          : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFEEEDFE), indent: 16, endIndent: 16);
}