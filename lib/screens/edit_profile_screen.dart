import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../models/app_user.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

class EditProfileScreen extends StatefulWidget {
  final AppUser user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  bool _isLoading = false;
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _displayNameController =
        TextEditingController(text: widget.user.displayName);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _selectedImagePath = image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImagePath == null) return null;

    try {
      final fileName =
          'profile_${widget.user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');

      if (kIsWeb) {
        // For web, use putData
        final bytes = await XFile(_selectedImagePath!).readAsBytes();
        await ref.putData(bytes);
      } else {
        // For mobile/desktop, use putFile
        await ref.putFile(File(_selectedImagePath!));
      }

      return await ref.getDownloadURL();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String? imageUrl;
    if (_selectedImagePath != null) {
      imageUrl = await _uploadImage();
      if (imageUrl == null) {
        setState(() => _isLoading = false);
        return;
      }
    }

    if (!mounted) return;

    context.read<ProfileBloc>().add(
          UpdateProfile(
            userId: widget.user.uid,
            displayName: _displayNameController.text.trim(),
            profileImageUrl: imageUrl,
          ),
        );

    // Show success message and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'EDIT PROFILE',
          style: AppTypography.h5.copyWith(
            letterSpacing: 2.0,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
            setState(() => _isLoading = false);
          }
        },
        child: SingleChildScrollView(
          padding: AppSpacing.paddingAllLarge,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Picture Section
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.gray800,
                          border: Border.all(
                            color: AppColors.borderLight,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _selectedImagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: kIsWeb
                                    ? Image.network(
                                        _selectedImagePath!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_selectedImagePath!),
                                        fit: BoxFit.cover,
                                      ),
                              )
                            : widget.user.profileImageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: Image.network(
                                      widget.user.profileImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColors.gray500,
                                  ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextButton(
                        onPressed: _isLoading ? null : _pickImage,
                        child: Text(
                          'CHANGE PHOTO',
                          style: AppTypography.labelMedium.copyWith(
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Display Name Field
                Text(
                  'DISPLAY NAME',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _displayNameController,
                  enabled: !_isLoading,
                  style: AppTypography.bodyMedium,
                  decoration: const InputDecoration(
                    hintText: 'Enter your display name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a display name';
                    }
                    if (value.trim().length < 2) {
                      return 'Display name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // Email (Read-only)
                Text(
                  'EMAIL',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  initialValue: widget.user.email,
                  enabled: false,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Save Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textInverse,
                          ),
                        )
                      : Text(
                          'SAVE CHANGES',
                          style: AppTypography.button.copyWith(
                            letterSpacing: 2.0,
                          ),
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
