import 'package:flutter/material.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/global/widget/app_bar.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chineseBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: const CustomAppBar(goBack: '/menu'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.raisinBlack,
                borderRadius: BorderRadius.circular(AppRadii.xl),
                border: Border.all(color: AppColors.borderMedium, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.manage_accounts_outlined,
                          size: 24,
                          color: AppColors.accentYellow,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Pengaturan Akun',
                          style: TextStyle(
                            
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ubah dan perbarui kata sandi akun Anda.',
                      style: TextStyle(
                        
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Current Password
                    const Text(
                      'Current Password',
                      style: TextStyle(
                        
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    TextFormField(
                      controller: currentPasswordController,
                      obscureText: true,
                      style: const TextStyle(
                        
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Masukkan kata sandi saat ini',
                        prefixIcon: Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.textSecondary),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan Password sekarang';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18.0),

                    // New Password
                    const Text(
                      'New Password',
                      style: TextStyle(
                        
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: true,
                      style: const TextStyle(
                        
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Masukkan kata sandi baru',
                        prefixIcon: Icon(Icons.key_outlined, size: 18, color: AppColors.textSecondary),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan Password baru';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18.0),

                    // Confirm Password
                    const Text(
                      'Konfirmasi Password',
                      style: TextStyle(
                        
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      style: const TextStyle(
                        
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Ulangi kata sandi baru',
                        prefixIcon: Icon(Icons.check_circle_outline_rounded, size: 18, color: AppColors.textSecondary),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan Konfirmasi Password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 28.0),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentYellow,
                          foregroundColor: AppColors.onAccentYellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            debugPrint('success');
                          }
                        },
                        child: const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.onAccentYellow,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
