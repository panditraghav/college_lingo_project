import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lingo/services/api_service.dart';
import 'package:logger/logger.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  final logger = Logger();
  final _storage = FlutterSecureStorage();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _gender = 'Male';
  File? _profileImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future _submit() async {
    if (_profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a profile image!"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      // Pass this data to your backend
      try {
        final response = await _apiService.signup(
          email: _emailController.text,
          password: _passwordController.text,
          fullName: _nameController.text,
          age: _ageController.text,
          dateOfBirth: _dobController.text,
          gender: _gender,
          phoneNumber: _phoneController.text,
          file: _profileImage!,
        );
        logger.i(response.data);

        final token = response.data['token'];
        logger.i("Token: $token");

        if (token != null) {
          await _storage.write(key: 'token', value: token);
        }

        _formKey.currentState!.save();
        logger.i("Name: ${_nameController.text}");
        logger.i("Email: ${_emailController.text}");
        logger.i("Phone: ${_phoneController.text}");
        logger.i("Age: ${_ageController.text}");
        logger.i("Gender: $_gender");
        logger.i("DOB: ${_dobController.text}");
        logger.i("Password: ${_passwordController.text}");

        Navigator.pushNamed(context, '/home');
      } catch (e) {
        logger.e(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Some error occured!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final neonColor = Colors.cyanAccent;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'NEW USER',
          style: TextStyle(color: Colors.cyanAccent),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: neonColor,
                    backgroundImage:
                        _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                    child:
                        _profileImage == null
                            ? const Icon(Icons.add_a_photo, color: Colors.black)
                            : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_nameController, 'Name', neonColor),
              _buildTextField(
                _emailController,
                'Email',
                neonColor,
                type: TextInputType.emailAddress,
              ),
              _buildTextField(
                _phoneController,
                'Phone No',
                neonColor,
                type: TextInputType.phone,
              ),
              _buildTextField(
                _ageController,
                'Age',
                neonColor,
                type: TextInputType.number,
              ),
              _buildGenderDropdown(neonColor),
              _buildDatePicker(neonColor),
              _buildTextField(
                _passwordController,
                'Password',
                neonColor,
                obscure: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: neonColor,
                  foregroundColor: Colors.black,
                ),
                onPressed: _submit,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    Color neonColor, {
    bool obscure = false,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: obscure,
        style: TextStyle(color: neonColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: neonColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: neonColor),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: neonColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildGenderDropdown(Color neonColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: _gender,
        dropdownColor: Colors.black,
        style: TextStyle(color: neonColor),
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: TextStyle(color: neonColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: neonColor),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: neonColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items:
            ['Male', 'Female', 'Other'].map((gender) {
              return DropdownMenuItem(value: gender, child: Text(gender));
            }).toList(),
        onChanged: (value) {
          setState(() {
            _gender = value!;
          });
        },
      ),
    );
  }

  Widget _buildDatePicker(Color neonColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: _dobController,
        style: TextStyle(color: neonColor),
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          labelStyle: TextStyle(color: neonColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: neonColor),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: neonColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: Icon(Icons.calendar_today, color: neonColor),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(data: ThemeData.dark(), child: child!);
            },
          );
          if (pickedDate != null) {
            _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
        validator: (value) => value!.isEmpty ? 'Please enter DOB' : null,
      ),
    );
  }
}
