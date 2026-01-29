import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:todo_app/Services/storage_service.dart';
import 'package:todo_app/custom_widgets/app_button.dart';
import 'package:todo_app/custom_widgets/app_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ImagePicker picker = ImagePicker();
  XFile? photo;
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  void takeImageFromCamera() async {
    photo = await picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  void chooseImageFromGallery() async {
    photo = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> navigateToHome() async {
    await StorageService.saveUser(nameController.text, photo?.path);
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(name: nameController.text, imagePath: photo?.path),
        ),
        (e) => false,
      );
    }
  }

  void showPhotoAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("No Photo Selected"),
        content: const Text(
          "Are you sure you want to continue without a profile photo?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await navigateToHome();
            },
            child: const Text("Yes, Continue"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: photo == null,
                    replacement: CircleAvatar(
                      radius: 120,
                      backgroundColor: Colors.black,
                      backgroundImage: photo != null
                          ? FileImage(File(photo!.path))
                          : null,
                    ),
                    child: const CircleAvatar(
                      radius: 120,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person, size: 170, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 25),
                  AppButton(
                    title: "Take a Picture From Camera",
                    onPressed: takeImageFromCamera,
                  ),
                  const SizedBox(height: 25),
                  AppButton(
                    title: "Upload Photo From Gallery",
                    onPressed: chooseImageFromGallery,
                  ),
                  const SizedBox(height: 15),
                  const Divider(thickness: 2, color: Colors.lightBlue),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    controller: nameController,
                    hintText: "Enter Your Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    title: "Confirm",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (photo == null) {
                          showPhotoAlert();
                        } else {
                          await navigateToHome();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
