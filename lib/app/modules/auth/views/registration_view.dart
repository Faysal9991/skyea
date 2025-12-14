

// import 'package:doyel_live/app/routes/app_pages.dart';
// import 'package:doyel_live/app/widgets/country_phone_code_widget.dart';
// import 'package:doyel_live/app/widgets/reusable_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'package:get/get.dart';

// import '../controllers/auth_controller.dart';

// class RegistrationView extends StatefulWidget {
//   const RegistrationView({Key? key}) : super(key: key);

//   @override
//   State<RegistrationView> createState() => _RegistrationViewState();
// }

// class _RegistrationViewState extends State<RegistrationView> {
//   final AuthController _authController = Get.find();

//   final TextEditingController _editingControllerName = TextEditingController();

//   final TextEditingController _editingControllerPhoneNumber =
//       TextEditingController();

//   final TextEditingController _editingControllerPassword =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // Future.delayed(Duration.zero, () {
//     //   _authController.setVisibilitySignUpPassword(false);
//     // });
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 64,
//                   ),
//                   Center(
//                     child: Image.asset(
//                       'assets/logos/doyel_live.jpeg',
//                       width: 130,
//                       height: 130,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   const Center(
//                     child: Text(
//                       'Your Phone!',
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   showSignUpFormWidget(context),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget showSignUpFormWidget(context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(
//           height: 16,
//         ),
//         rPrimaryTextField(
//           controller: _editingControllerName,
//           keyboardType: TextInputType.name,
//           borderColor: Colors.grey,
//           hintText: 'Enter your name !!',
//         ),
//         const SizedBox(
//           height: 16,
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Container(
//             decoration: BoxDecoration(
//               // color: Colors.grey,
//               borderRadius: BorderRadius.circular(
//                 8.0,
//               ),
//               border: Border.all(
//                 color: Colors.grey,
//               ),
//             ),
//             child: ListTile(
//               dense: true,
//               onTap: () => openCountryPickerDialog(
//                 context: context,
//                 authController: _authController,
//               ),
//               title: Obx(
//                 () {
//                   return buildCountryPickerDialogItem(
//                     country: _authController.country.value,
//                     showAsSelected: true,
//                     textEditingControllerPhoneNumber:
//                         _editingControllerPhoneNumber,
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 8,
//         ),
//         rPrimaryTextField(
//           controller: _editingControllerPassword,
//           keyboardType: TextInputType.visiblePassword,
//           obscureText: true,
//           borderColor: Colors.grey,
//           hintText: 'Enter password',
//         ),
//         Obx(() {
//           if (!_authController.authLoading.value) {
//             return Container();
//           }
//           return const SpinKitFadingCircle(
//             color: Colors.orange,
//             size: 48.0,
//           );
//         }),
//         const SizedBox(
//           height: 16,
//         ),
//         rPrimaryElevatedButton(
//           onPressed: () async {
//             if (_authController.authLoading.value) {
//               return;
//             }

//             FocusScope.of(context).unfocus();
//             String fullName = _editingControllerName.text.trim();
//             String phoneNumber = _editingControllerPhoneNumber.text.trim();
//             String password = _editingControllerPassword.text.trim();

//             if (fullName.isNotEmpty &&
//                 phoneNumber.isNotEmpty &&
//                 // emailAddress.isNotEmpty &&
//                 password.isNotEmpty) {
//               if (password.length < 8) {
//                 Get.snackbar(
//                   'Failed',
//                   "Password length must be at least 8 characters long.",
//                   backgroundColor: Colors.red,
//                   colorText: Colors.white,
//                   snackPosition: SnackPosition.BOTTOM,
//                 );
//                 return;
//               }

//               // ${country.phoneCode} ${country.name} ${country.isoCode} ${country.iso3Code}
//               if (_authController.country.value.isoCode == 'BD') {
//                 // Bangladeshi mobile number
//                 phoneNumber = int.parse(phoneNumber).toString();
//                 if (phoneNumber.length < 10 || !phoneNumber.startsWith('1')) {
//                   Get.snackbar(
//                     'Failed',
//                     "${_authController.country.value.name} mobile number is incorrect.",
//                     backgroundColor: Colors.red,
//                     colorText: Colors.white,
//                     snackPosition: SnackPosition.BOTTOM,
//                   );
//                   return;
//                 }
//               }
//               _authController.tryToSingInWithPassword(
//                 fullName: fullName,
//                 mobileNumber:
//                     '+${_authController.country.value.phoneCode}$phoneNumber',
//                 phoneCode: _authController.country.value.phoneCode,
//                 password: password,
//               );
//             } else {
//               Get.snackbar(
//                 'Failed',
//                 "All fields are required.",
//                 backgroundColor: Colors.red,
//                 colorText: Colors.white,
//                 snackPosition: SnackPosition.BOTTOM,
//               );
//             }
//           },
//           primaryColor: Theme.of(context).primaryColor,
//           buttonText: 'LOGIN',
//           fontSize: 16.0,
//           fixedSize: Size(
//             MediaQuery.of(context).size.width - 21,
//             46,
//           ),
//           borderRadius: 8.0,
//         ),
//       ],
//     );
//   }
// }

import 'dart:ui';

import 'package:doyel_live/app/routes/app_pages.dart';
import 'package:doyel_live/app/widgets/country_phone_code_widget.dart';
import 'package:doyel_live/app/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../controllers/auth_controller.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView>
    with TickerProviderStateMixin {
  final AuthController controller = Get.find();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [Colors.deepPurple.shade900, Colors.black87]
                      : [
                          Colors.deepPurple.shade50,
                          Colors.orange.shade50,
                          Colors.pink.shade50,
                        ],
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 900),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.white.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2), width: 1.5),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Perfect Circular Logo
                              BounceInDown(
                                duration: const Duration(milliseconds: 1000),
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.deepPurple.withOpacity(0.3),
                                        blurRadius: 30,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/logos/doyel_live.jpeg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              ElasticIn(
                                child: Text(
                                  'Create Account',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple.shade700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),
                              Text(
                                'Join Sky Live with your phone',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.deepPurple.shade400,
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Name Field
                              _fancyTextField(
                                controller: _nameCtrl,
                                hint: "Full Name",
                                icon: Icons.person_outline,
                                delay: 200,
                              ),

                              const SizedBox(height: 20),

                              // Country + Phone Number
                              _countryPhoneField(isDark),

                              const SizedBox(height: 20),

                              // Password Field
                              _fancyTextField(
                                controller: _passCtrl,
                                hint: "Password (min 8 chars)",
                                icon: Icons.lock_outline,
                                isPassword: true,
                                delay: 400,
                              ),

                              const SizedBox(height: 30),

                              // Loading Indicator
                              Obx(() => controller.authLoading.value
                                  ? Column(
                                      children: [
                                        SpinKitPulse(color: Colors.orange, size: 60),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Creating your account...",
                                          style: GoogleFonts.poppins(color: Colors.white70),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink()),

                              const SizedBox(height: 20),

                              // Register Button
                              _fancyButton(
                                text: "Login ACCOUNT",
                                onTap: controller.authLoading.value ? null : _handleRegister,
                              ),

                              const SizedBox(height: 16),
                              Text(
                                "By signing up, you agree to our Terms & Privacy",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fancyTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    int delay = 0,
  }) {
    return FadeInLeft(
      delay: Duration(milliseconds: delay),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple.shade400),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.deepPurple.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2.5),
          ),
        ),
      ),
    );
  }

  Widget _countryPhoneField(bool isDark) {
    return FadeInRight(
      delay: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.deepPurple.shade200, width: 1.5),
        ),
        child: Row(
          children: [
            // Country Picker
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => openCountryPickerDialog(
                context: context,
                authController: controller,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => Row(
                      children: [
                      
                        Text(
                          "+${controller.country.value.phoneCode}",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.deepPurple),
                      ],
                    )),
              ),
            ),
            const SizedBox(width: 12),
            // Phone Input
            Expanded(
              child: TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  hintText: "Phone number",
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fancyButton({required String text, required VoidCallback? onTap}) {
    return ZoomIn(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade600, Colors.deepPurple.shade800],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() async {
    FocusScope.of(context).unfocus();
    String name = _nameCtrl.text.trim();
    String phone = _phoneCtrl.text.trim();
    String pass = _passCtrl.text.trim();

    if (name.isEmpty || phone.isEmpty || pass.isEmpty) {
      Get.snackbar("Error", "All fields are required", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (pass.length < 8) {
      Get.snackbar("Weak Password", "Password must be 8+ characters", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

   
    controller.tryToSingInWithPassword(
      fullName: name,
        mobileNumber:
                    '+${controller.country.value.phoneCode}$phone',
      phoneCode: controller.country.value.phoneCode,
      password: pass,
    );
  }
}
