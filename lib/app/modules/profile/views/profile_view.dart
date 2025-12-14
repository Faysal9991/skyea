import 'package:cached_network_image/cached_network_image.dart';
import 'package:doyel_live/app/modules/auth/controllers/auth_controller.dart';
import 'package:doyel_live/app/modules/auth/views/change_password_view.dart';
import 'package:doyel_live/app/modules/business/views/agent/agent_for_host_view.dart';
import 'package:doyel_live/app/modules/business/views/agent/hosts/hosts_view.dart';
import 'package:doyel_live/app/modules/business/views/host_requst_view.dart';
import 'package:doyel_live/app/modules/business/views/moderator/moderator_view.dart';
import 'package:doyel_live/app/modules/business/views/reseller/reseller_view.dart';
import 'package:doyel_live/app/modules/products/views/vip_package_view.dart';
import 'package:doyel_live/app/modules/products/views/vvip_package_view.dart';
import 'package:doyel_live/app/modules/profile/views/block_list_view.dart';
import 'package:doyel_live/app/modules/profile/views/broadcasting_histories.dart';
import 'package:doyel_live/app/modules/profile/views/edit_profile_view.dart';
import 'package:doyel_live/app/modules/profile/views/info/privacy_policy_view.dart';
import 'package:doyel_live/app/modules/profile/views/info/terms_and_conditions_view.dart';
import 'package:doyel_live/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Fancy Header ===
            Text(
              'My Profile',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: primaryColor.withOpacity(0.6),
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // === Hero Profile Card with Glassmorphism + Glow ===
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.3),
                    secondaryColor.withOpacity(0.4),
                    tertiaryColor.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
              ),
              child: Row(
                children: [
                  // Profile Picture with VIP/VVIP Badge + Glow
                  Obx(() {
                    final hasVipBadge = _authController.profile.value.vvip_or_vip_preference['vvip_or_vip_gif'] != null;
                    return Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [primaryColor, secondaryColor],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.7),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: hasVipBadge ? 36 : 42,
                            backgroundColor: surfaceColor,
                            child: CircleAvatar(
                              radius: hasVipBadge ? 32 : 38,
                              backgroundImage: _authController.profile.value.profile_image == null &&
                                  _authController.profile.value.photo_url == null
                                  ? const AssetImage('assets/others/person.jpg') as ImageProvider
                                  :CachedNetworkImageProvider(
  (_authController.profile.value.profile_image ??
          _authController.profile.value.photo_url!)
      .startsWith('http')
      ? (_authController.profile.value.profile_image ??
          _authController.profile.value.photo_url!)
      : 'https://${_authController.profile.value.profile_image ?? _authController.profile.value.photo_url!}',
)

                            ),
                          ),
                        ),
                        // VVIP/VIP Animated Badge
                        if (hasVipBadge)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black87,
                                border: Border.all(color: goldAccent, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: goldAccent.withOpacity(0.8),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: _authController.profile.value.vvip_or_vip_preference['vvip_or_vip_gif'],
                                  width: 38,
                                  height: 38,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),

                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                          _authController.profile.value.full_name ?? 'User',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          _authController.profile.value.user?.phone ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        )),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStatItem('assets/others/diamond.png', '${_authController.profile.value.diamonds ?? 0}', 'Diamonds', goldAccent),
                            const SizedBox(width: 20),
                            _buildStatItem(Icons.people, '${_authController.profile.value.followers?.length ?? 0}', 'Followers', Colors.cyanAccent),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // === Account Settings Grid ===
            _buildFancySectionTitle("Account Settings", Icons.person_outline),
            const SizedBox(height: 16),
            _buildGridSection([
              _GridItem("Edit Profile", Icons.edit, () => Get.to(() => const EditProfileView()), [Colors.blue.shade400, Colors.blue.shade600]),
              if (_authController.profile.value.login_type == 'password_login')
                _GridItem("Change Password", Icons.lock_outline, () => Get.to(() => ChangePasswordView()), [Colors.orange.shade400, Colors.orange.shade600]),
              _GridItem("Block List", Icons.block, () => Get.to(() => const BlockListView()), [Colors.red.shade400, Colors.red.shade600]),
              _GridItem("Broadcast History", MdiIcons.history, () => Get.to(() => BroadcastingHistoriesView(userId: _authController.profile.value.user!.uid!, isAgentSearch: false)), [Colors.purple.shade400, Colors.purple.shade600]),
              if (_authController.profile.value.is_moderator == true)
                _GridItem("Moderator Panel", Icons.shield, () => Get.to(() => ModeratorView()), [Colors.deepPurple.shade400, Colors.deepPurple.shade600]),
              if (_authController.profile.value.is_reseller == true)
                _GridItem("Reseller Dashboard", MdiIcons.diamondStone, () => Get.to(() => ResellerView()), [goldAccent, Colors.amber.shade700]),
            ]),

            const SizedBox(height: 30),

            // === Premium Features Grid ===
            _buildFancySectionTitle("Premium Features", Icons.star_border_purple500_sharp),
            const SizedBox(height: 16),
            _buildGridSection([
              _GridItem("VVIP Package", Icons.vignette, () => Get.to(() => const VVIPPackageView()), [goldAccent, Colors.amber.shade700]),
              _GridItem("VIP Package", Icons.auto_awesome, () => Get.to(() => const VIPPackageView()), [Colors.purpleAccent, Colors.purple.shade600]),
              if (_authController.profile.value.is_agent == true)
                _GridItem("My Hosts", Icons.groups, () => Get.to(() => HostsView(agentUserId: _authController.profile.value.user!.uid!)), [Colors.teal.shade400, Colors.teal.shade700]),
              if (!(_authController.profile.value.is_agent == true || _authController.profile.value.is_host == true || _authController.profile.value.is_moderator == true || _authController.profile.value.is_reseller == true))
                _GridItem("Become a Host", Icons.live_tv, () => Get.to(() => const HostRequstView()), [primaryColor, secondaryColor]),
              if (_authController.profile.value.is_host == true)
                _GridItem("My Agent", Icons.support_agent, () => Get.to(() => AgentForHostView()), [Colors.cyan.shade400, Colors.cyan.shade700]),
            ]),

            const SizedBox(height: 30),

            // === More Options Grid ===
            _buildFancySectionTitle("More", Icons.more_horiz),
            const SizedBox(height: 16),
            _buildGridSection([
              _GridItem("Share App", Icons.share, () async {
                await SharePlus.instance.share(
                  ShareParams(
                    text: "Join Sky Live for unlimited fun!\nhttps://play.google.com/store/apps/details?id=com.taksoft.Sky_live",
                    subject: "Sky Live - Live Streaming App",
                  ),
                );
              }, [Colors.green.shade400, Colors.green.shade600]),
              _GridItem("Help & Feedback", MdiIcons.helpCircleOutline, () {
                launchUrl(Uri(scheme: 'mailto', path: 'toplive46@gmail.com'));
              }, [Colors.indigo.shade400, Colors.indigo.shade600]),
              _GridItem("Privacy Policy", Icons.privacy_tip_outlined, () => Get.to(() => const PrivacyPolicyView()), [Colors.blueGrey.shade400, Colors.blueGrey.shade700]),
              _GridItem("Terms & Conditions", Icons.description_outlined, () => Get.to(() => const TermsAndConditionsView()), [Colors.grey.shade600, Colors.grey.shade800]),
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Reusable Stat Item
  Widget _buildStatItem(dynamic icon, String value, String label, Color color) {
    return Row(
      children: [
        icon is String
            ? Image.asset(icon, width: 20, height: 20, color: color)
            : Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
            shadows: [Shadow(color: color.withOpacity(0.5), blurRadius: 8)],
          ),
        ),
      ],
    );
  }

  // Fancy Section Title
  Widget _buildFancySectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor.withOpacity(0.8), secondaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // Grid Section Builder
  Widget _buildGridSection(List<_GridItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildGridCard(
          title: item.title,
          icon: item.icon,
          onTap: item.onTap,
          gradientColors: item.gradientColors,
        );
      },
    );
  }

  // Fancy Grid Card
  Widget _buildGridCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Grid Item Model
class _GridItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  _GridItem(this.title, this.icon, this.onTap, this.gradientColors);
}