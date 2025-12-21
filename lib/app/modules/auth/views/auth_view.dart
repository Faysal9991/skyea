import 'dart:ui';
import 'package:doyel_live/app/modules/auth/views/registration_view.dart';
import 'package:doyel_live/app/widgets/reusable_widgets.dart';
import 'package:doyel_live/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:animate_do/animate_do.dart';
import '../controllers/auth_controller.dart';


class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [tertiaryColor, backgroundColor, Color(0xFF0F0F0F)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background Particles
            ...List.generate(12, (i) => _floatingGlow(i, size)),

            // Main Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.08, vertical: 20),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 900),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 420),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                          decoration: BoxDecoration(
                            color: surfaceColor.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: primaryColor.withOpacity(0.4), width: 1.8),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo
                              BounceInDown(
                                duration: const Duration(milliseconds: 1200),
                                child: Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [primaryColor.withOpacity(0.8), secondaryColor],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.6),
                                        blurRadius: 40,
                                        spreadRadius: 8,
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

                              // App Name
                              ElasticIn(
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [goldAccent, primaryColor],
                                  ).createShader(bounds),
                                  child: Text(
                                    'Sky Live',
                                    style: GoogleFonts.poppins(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      shadows: [
                                        Shadow(color: goldAccent.withOpacity(0.8), blurRadius: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text(
                                'Go Live. Be Seen. Be Legendary.',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.8,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 50),

                              // Loading
                              Obx(() => controller.authLoading.value
                                  ? Column(
                                      children: [
                                        SpinKitPouringHourGlassRefined(color: goldAccent, size: 70),
                                        const SizedBox(height: 20),
                                        Text(
                                          "Entering the spotlight...",
                                          style: GoogleFonts.poppins(
                                            color: goldAccent,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink()),

                              const SizedBox(height: 30),

                              // Google Button
                              _fancyButton(
                                
                                text: "Continue with Google",
                                icon: MdiIcons.google,
                                gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
                                textColor: Colors.black87,
                                shadowColor: Colors.grey.shade400,
                                borderColor: Colors.grey.shade300,
                                onTap: controller.authLoading.value ? null : controller.tryToSignInWithGoogle,
                              ),

                              const SizedBox(height: 18),

                              // Phone Button
                              _fancyButton(
                                text: "Continue with Phone",
                                icon: MdiIcons.phone,
                                gradient: LinearGradient(
                                  colors: [primaryColor, secondaryColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                textColor: Colors.white,
                                shadowColor: primaryColor,
                                glowColor: primaryColor.withOpacity(0.6),
                                onTap: controller.authLoading.value
                                    ? null
                                    : () => Get.to(() => const RegistrationView()),
                              ),

                              const SizedBox(height: 32),

                              // Terms
                              Text(
                                "By continuing, you agree to our\nTerms of Service & Privacy Policy",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.white60, height: 1.5),
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

  // FIXED BUTTON — NO MORE OVERFLOW!
  Widget _fancyButton({
    required String text,
    required IconData icon,
    required Gradient gradient,
    required Color textColor,
    required Color shadowColor,
    Color? borderColor,
    Color? glowColor,
    required VoidCallback? onTap,
  }) {
    return ElasticInUp(
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4), // extra safety
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(20),
                border: borderColor != null ? Border.all(color: borderColor, width: 1.5) : null,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.5),
                    blurRadius: 16,     // reduced from 20
                    offset: const Offset(0, 8),
                  ),
                  if (glowColor != null)
                    BoxShadow(
                      color: glowColor,
                      blurRadius: 24,   // reduced from 30
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: textColor, size: 28),
                  const SizedBox(width: 14),
                  Flexible(    // prevents text overflow on tiny screens
                    child: Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Floating Particles (unchanged — they were perfect)
  Widget _floatingGlow(int index, Size size) {
    final random = DateTime.now().millisecondsSinceEpoch + index * 1000;
    final left = (random % 100) / 100 * size.width;
    final duration = 20 + (index % 8);

    return AnimatedPositioned(
      duration: Duration(seconds: duration),
      curve: Curves.easeInOut,
      top: -50,
      left: left,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(seconds: duration),
        builder: (_, value, __) {
          return Transform.translate(
            offset: Offset(0, value * size.height + 100),
            child: Opacity(
              opacity: 0.6 - (value * 0.4),
              child: Container(
                width: 6 + (index % 6) * 6,
                height: 6 + (index % 6) * 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index % 2 == 0 ? primaryColor : goldAccent,
                  boxShadow: [
                    BoxShadow(
                      color: (index % 2 == 0 ? primaryColor : goldAccent).withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}