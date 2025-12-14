import 'package:cached_network_image/cached_network_image.dart';
import 'package:doyel_live/app/modules/live_streaming/controllers/live_streaming_controller.dart';
import 'package:doyel_live/app/modules/live_streaming/views/broadcast/helper_functions/user_interact/widgets/contributors_widget.dart';
import 'package:doyel_live/app/modules/live_streaming/views/broadcast/helper_functions/user_interact/widgets/gifts_widget.dart';
import 'package:doyel_live/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showUserInteractBottomSheet({
  required BuildContext context,
  required dynamic data,
  required Function onUpdateAction,
}) {
  final AuthController authController = Get.find();
  final LiveStreamingController streamingController = Get.find();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    enableDrag: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF121212),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag Handle + Tab Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    color: Color(0xFF1E1E1E),
                  ),
                  child: Column(
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tab Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTabItem(
                            icon: 'assets/others/gift.png',
                            label: 'SEND GIFTS',
                            isActive: streamingController.userInteractTab.value == 'gifts',
                            onTap: () => streamingController.setUserInteractTab(tab: 'gifts'),
                          ),
                          _buildTabItem(
                            profileImage: data['profile_image'] ?? data['photo_url'],
                            vvipGif: data['vvip_or_vip_preference']?['vvip_or_vip_gif'],
                            label: data['full_name'] ?? 'User',
                            isActive: streamingController.userInteractTab.value == 'contributors',
                            onTap: () => streamingController.setUserInteractTab(tab: 'contributors'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Animated Underline Indicator
                      Obx(() {
                        bool isGifts = streamingController.userInteractTab.value == 'gifts';
                        return AnimatedAlign(
                          alignment: isGifts ? Alignment.centerLeft : Alignment.centerRight,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Obx(() {
                      if (streamingController.userInteractTab.value == 'gifts') {
                        return GiftsWidget(
                          data: data,
                          streamingController: streamingController,
                          authController: authController,
                          onUpdateAction: onUpdateAction,
                        );
                      } else if (streamingController.userInteractTab.value == 'contributors') {
                        return ContributorsWidget(
                          streamingController: streamingController,
                          data: data,
                          onUpdateAction: onUpdateAction,
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// Reusable Tab Item Widget
Widget _buildTabItem({
  String? icon,
  String? profileImage,
  String? vvipGif,
  required String label,
  required bool isActive,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isActive ? 1.0 : 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Image.asset(icon, width: 28, height: 28, color: isActive ? Colors.pinkAccent : Colors.grey)
          else
            Stack(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: profileImage == null
                      ? const AssetImage('assets/others/person.jpg')
                      : CachedNetworkImageProvider(profileImage) as ImageProvider,
                ),
                if (vvipGif != null && vvipGif.isNotEmpty)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.orange.shade700, width: 2),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: vvipGif,
                        width: 14,
                        height: 14,
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade400,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
  );
}