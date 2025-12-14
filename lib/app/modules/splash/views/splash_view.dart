import 'package:doyel_live/app/modules/auth/controllers/auth_controller.dart';
import 'package:doyel_live/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../controllers/splash_controller.dart';

// Color Constants
const primaryColor = Color(0xFFF7374F);
const secondaryColor = Color(0xFF88304E);
const tertiaryColor = Color(0xFF522546);
const surfaceColor = Color(0xFF2C2C2C);
const backgroundColor = Color(0xFF1E1E1E);
const goldAccent = Color(0xFFFFD700);

void _checkServerLockedVersion() {
  final AuthController authController = Get.find();
  if (authController.token.value.isEmpty) {
    Get.offNamed(Routes.AUTH);
  } else {
    Get.offNamed(Routes.NAV);
  }
}

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      _checkServerLockedVersion();
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor,
              tertiaryColor.withOpacity(0.3),
              secondaryColor.withOpacity(0.2),
              backgroundColor,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) => _buildFloatingParticle(index)),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container with glow effect
                  _buildLogoContainer(),
                  
                  const SizedBox(height: 32),
                  
                  // App name with shimmer effect
                  _buildAppName(),
                  
                  const SizedBox(height: 16),
                  
                  // Tagline
                  _buildTagline(),
                  
                  const SizedBox(height: 48),
                  
                  // Custom loading indicator
                  _buildLoadingIndicator(),
                ],
              ),
            ),
            
            // Bottom decoration
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomWave(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = (index * 37) % 100;
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 2000 + (random * 10)),
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Positioned(
          left: (random * 3.5) % 100 + (value * 50),
          top: (random * 5) % 100 + (value * 100),
          child: Opacity(
            opacity: (0.1 + (random % 30) / 100) * (1 - value * 0.5),
            child: Container(
              width: 4 + (random % 8).toDouble(),
              height: 4 + (random % 8).toDouble(),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    index % 2 == 0 ? primaryColor : goldAccent,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        );
      },
      onEnd: () {},
    );
  }

  Widget _buildLogoContainer() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.elasticOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primaryColor.withOpacity(0.3),
                  secondaryColor.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.5),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: goldAccent.withOpacity(0.3),
                  blurRadius: 60,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: goldAccent.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'assets/logos/doyel_live.jpeg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppName() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                primaryColor,
                goldAccent,
                secondaryColor,
                primaryColor,
              ],
              stops: const [0.0, 0.3, 0.6, 1.0],
            ).createShader(bounds),
            child: const Text(
              'Sky Live',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  secondaryColor.withOpacity(0.3),
                  tertiaryColor.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: goldAccent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Text(
              'Your Stage, Your Spotlight',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer pulsing ring
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.8, end: 1.2),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
            );
          },
          onEnd: () {},
        ),
        
        // Spinning loader
        SpinKitRing(
          color: goldAccent,
          size: 60.0,
          lineWidth: 3.0,
        ),
        
        // Inner dot
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                primaryColor,
                secondaryColor,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomWave() {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              secondaryColor.withOpacity(0.3),
              tertiaryColor.withOpacity(0.5),
            ],
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.6);
    
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height * 0.7);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    
    var secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.4);
    var secondEndPoint = Offset(size.width, size.height * 0.6);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}