import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lingo/Authentication/Logout_Screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingo/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = false;
  final _apiService = ApiService();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _gender;
  DateTime? _selectedDate;

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat.yMMMMd().format(picked);
      });
    }
  }

  //String _email = '';
  String? _profileImageUrl; // Add this at the top with your state variables

  Future<void> _fetchUserProfile() async {
    print("Fetching!!!");
    try {
      final response = await _apiService.getUserProfile();
      final data = response.data;

      final user = data['userDetails']; // 👈 Fix: access nested object

      setState(() {
        _nameController.text = user['fullName'] ?? '';
        _phoneController.text = user['phoneNumber'] ?? '';
        _gender = user['gender'];
        _emailController.text = user['email'] ?? '';
        _dobController.text =
            user['dateOfBirth'] != null
                ? DateFormat.yMMMMd().format(
                  DateTime.parse(user['dateOfBirth']),
                )
                : '';
        _selectedDate =
            user['dateOfBirth'] != null
                ? DateTime.parse(user['dateOfBirth'])
                : null;
        _profileImageUrl = user['profilePhoto'];

        print('Fetched profile data: $user');
      });
    } catch (e) {
      print('Failed to fetch user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching profile data')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _updateUserProfile() async {
    setState(() => _isLoading = true);

    try {
      final response = await _apiService.updateProfile(
        data: {
          'fullName': _nameController.text,
          'phoneNumber': _phoneController.text,
          'email': _emailController.text,
          'gender': _gender,
          'dateOfBirth': _selectedDate?.toIso8601String(),
        },
      );

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        setState(() => _isEditing = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'] ?? 'Update failed')),
        );
      }
    } catch (e) {
      print('Update error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update profile')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon:
                _isEditing
                    ? (_isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.cyanAccent,
                            strokeWidth: 2,
                          ),
                        )
                        : const Icon(Icons.check, color: Colors.greenAccent))
                    : const Icon(Icons.edit, color: Colors.cyanAccent),
            tooltip: _isEditing ? 'Save Profile' : 'Edit Profile',
            onPressed:
                _isLoading
                    ? null
                    : () {
                      if (_isEditing) {
                        _updateUserProfile();
                      } else {
                        setState(() => _isEditing = true);
                      }
                    },
          ),
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              tooltip: 'Logout',
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Logged out')));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Logout()),
                );
              },
            ),
        ],
      ),

      backgroundColor: Colors.black,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/images/lingoo2.png')
                                as ImageProvider,
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.cyanAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(label: 'Name', controller: _nameController),
            const SizedBox(height: 16),
            _buildDateField(),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Phone Number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(label: 'Email', controller: _emailController),
            const SizedBox(height: 16),
            _buildGenderDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: _isEditing,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.cyanAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _isEditing ? _pickDate : null,
      child: AbsorbPointer(
        child: TextField(
          controller: _dobController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Age (Date of Birth)',
            labelStyle: const TextStyle(color: Colors.white70),
            hintText:
                _selectedDate != null
                    ? DateFormat.yMMMMd().format(_selectedDate!)
                    : 'Select your birthdate',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.cyanAccent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      dropdownColor: Colors.grey[900],
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.cyanAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
      ),
      items:
          ['male', 'female', 'other']
              .map(
                (gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(toBeginningOfSentenceCase(gender)!),
                ),
              )
              .toList(),

      onChanged: (value) {
        _isEditing ? (value) => setState(() => _gender = value) : null;
        //setState(() => _gender = value);
      },
    );
  }
}
