import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/Services/storage_service.dart';
import 'package:todo_app/custom_widgets/app_button.dart';
import 'package:todo_app/custom_widgets/app_text_form_field.dart';
import 'package:todo_app/main.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String? imagePath;

  const ProfileScreen({super.key, required this.name, this.imagePath});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String currentName;
  String? currentImagePath;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    currentName = widget.name;
    currentImagePath = widget.imagePath;
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                title: "Take Photo From Camera",
                onPressed: () async {
                  final XFile? photo = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (photo != null) {
                    setState(() => currentImagePath = photo.path);
                    await StorageService.saveUser(
                      currentName,
                      currentImagePath,
                    );
                  }
                  if (mounted) Navigator.pop(context);
                },
              ),
              const SizedBox(height: 15),
              AppButton(
                title: "Upload From Gallery",
                onPressed: () async {
                  final XFile? photo = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (photo != null) {
                    setState(() => currentImagePath = photo.path);
                    await StorageService.saveUser(
                      currentName,
                      currentImagePath,
                    );
                  }
                  if (mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNameEditor() {
    final TextEditingController nameController = TextEditingController(
      text: currentName,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextFormField(
                controller: nameController,
                hintText: "Enter your name",
              ),
              const SizedBox(height: 15),
              AppButton(
                title: "Update Your Name",
                onPressed: () async {
                  if (nameController.text.isNotEmpty) {
                    setState(() => currentName = nameController.text);
                    await StorageService.saveUser(
                      currentName,
                      currentImagePath,
                    );
                  }
                  if (mounted) Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.indigo),
          onPressed: () => Navigator.pop(context, {
            'name': currentName,
            'imagePath': currentImagePath,
          }),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.nightlight_round : Icons.wb_sunny_outlined,
              color: Colors.indigo,
            ),
            onPressed: () {
              MyApp.of(context).changeTheme(
                isDark ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: currentImagePath != null
                      ? FileImage(File(currentImagePath!))
                      : null,
                  child: currentImagePath == null
                      ? const Icon(Icons.person, size: 70, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            const Divider(indent: 40, endIndent: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showNameEditor,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Colors.indigo,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
