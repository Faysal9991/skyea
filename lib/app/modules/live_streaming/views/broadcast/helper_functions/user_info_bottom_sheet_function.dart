import 'package:cached_network_image/cached_network_image.dart';
import 'package:doyel_live/app/modules/live_streaming/controllers/live_streaming_controller.dart';
import 'package:doyel_live/app/modules/messenger/utils/utils.dart';
import 'package:doyel_live/app/modules/messenger/views/messages/message_view.dart';
import 'package:doyel_live/app/modules/splash/views/splash_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:doyel_live/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doyel_live/app/modules/profile/controllers/profile_controller.dart';


void showUserInfoBottomSheet({
  required BuildContext context,
  required dynamic data,
  required Function onUpdateAction,
}) {
  final ProfileController profileController = Get.find();
  final AuthController authController = Get.find();
  final LiveStreamingController streamingController = Get.find();

  Future.delayed(Duration.zero, () {
    profileController.fetchProfileForUserInfo(userId: data['uid']);
  });

  Widget _messageWidget({required dynamic data}) {
    dynamic profile = {
      'profile_image': data['profile_image'],
      'full_name': data['full_name'],
      'user': {'uid': data['uid']},
    };
    String chatId = getChatId(
      uid: authController.profile.value.user!.uid!,
      peeredUserId: data['uid'],
    );

    return data['uid'] == authController.profile.value.user!.uid
        ? const SizedBox()
        : Expanded(
            child: MessagesView(
              profile: profile,
              chatId: chatId,
              isShowInLive: true,
            ),
          );
  }

  showModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withOpacity(0.7),
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SafeArea(
        child: Obx(() {
          if (profileController.loadingProfileForUserInfo.value) {
            return Container(
              height: data['uid'] != authController.profile.value.user!.uid ? 280 : 180,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [backgroundColor, surfaceColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 20, spreadRadius: 2),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SpinKitHourGlass(color: primaryColor, size: 50.0),
                  const SizedBox(height: 16),
                  Text(
                    data['full_name'] ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID: ${data['uid']}',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          if (profileController.profileForUserInfo == null) {
            return Container(
              height: 200,
              alignment: Alignment.center,
              child: Text('Error loading profile', style: TextStyle(color: Colors.white70)),
            );
          }

          final profileData = profileController.profileForUserInfo!;
          profileData['uid'] = data['uid'];

          bool isOwnProfile = profileData['uid'] == authController.profile.value.user!.uid;

          return Container(
            height: isOwnProfile ? 180 : MediaQuery.of(context).size.height * 0.70,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [backgroundColor, surfaceColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: primaryColor.withOpacity(0.4), width: 1.5),
              boxShadow: [
                BoxShadow(color: primaryColor.withOpacity(0.25), blurRadius: 30, spreadRadius: 5),
              ],
            ),
            child: Stack(
              children: [
                // Main Content Card
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                  
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        // Name & Level
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            if (profileData['vvip_or_vip_preference']?['vvip_or_vip_gif'] != null)
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [goldAccent, Colors.orange]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'L.V.${data['level']?['level'] ?? 0}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            Flexible(
                              child: Text(
                                profileData['full_name'] ?? '',
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ID, Diamonds, Stars
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('ID: ${profileData['uid']}', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                Image.asset('assets/others/diamond.png', width: 18, height: 18, color: goldAccent),
                                const SizedBox(width: 6),
                                Text('${profileData['diamonds'] ?? 0}', style: TextStyle(color: goldAccent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '⭐ ${(profileData['diamonds'] ?? 0) < 100000 ? 0 : (profileData['diamonds'] / 100000).floor()}',
                              style: const TextStyle(color: Colors.yellow, fontSize: 13),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Action Buttons (Follow / Block)
                        if (!isOwnProfile)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (profileController.loadingPerformFollow.value == profileData['uid']) return;
                                  List<dynamic> followers = await profileController.performFollow(uid: profileData['uid']);
                                  profileController.setAccountFollowers(followers);
                                  onUpdateAction({
                                    'action': 'followers',
                                    'uid': profileData['uid'],
                                    'followers': followers,
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                icon: Obx(() => profileController.loadingPerformFollow.value != profileData['uid']
                                    ? Icon(
                                        profileController.accountFollowers.contains(authController.profile.value.user!.uid!)
                                            ? Icons.check
                                            : Icons.person_add,
                                        size: 18,
                                      )
                                    : const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))),
                                label: Obx(() => Text(
                                      profileController.accountFollowers.contains(authController.profile.value.user!.uid!) ? 'Following' : 'Follow',
                                      style: const TextStyle(fontSize: 13),
                                    )),
                              ),
                              const SizedBox(width: 12),
                              if (streamingController.channelName.value == authController.profile.value.user!.uid.toString())
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    if (profileController.loadingPerformBlock.value == profileData['uid']) return;
                                    List<dynamic> blocks = await profileController.performBlock(uid: profileData['uid']);
                                    onUpdateAction({
                                      'action': 'blocks',
                                      'uid': profileData['uid'],
                                      'blocks': blocks,
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  icon: Obx(() => profileController.loadingPerformBlock.value != profileData['uid']
                                      ? Icon(
                                          authController.profile.value.blocks!.contains(profileData['uid']) ? Icons.check_circle : Icons.block,
                                          size: 18,
                                        )
                                      : const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))),
                                  label: Obx(() => Text(
                                        authController.profile.value.blocks!.contains(profileData['uid']) ? 'Blocked' : 'Block',
                                        style: const TextStyle(fontSize: 13),
                                      )),
                                ),
                            ],
                          ),

                        const SizedBox(height: 16),

                        // Message View
                        _messageWidget(data: data),
                      ],
                    ),
                  ),
                ),

                // Profile Avatar (Floating on top)
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
                        boxShadow: [
                          BoxShadow(color: primaryColor.withOpacity(0.6), blurRadius: 20, spreadRadius: 5),
                        ],
                      ),
                      child: ClipOval(
                        child: data['profile_image'] == null && data['photo_url'] == null
                            ? Image.asset('assets/others/person.jpg', width: 86, height: 86, fit: BoxFit.cover)
                            : CachedNetworkImage(
                                imageUrl: data['profile_image'] ?? data['photo_url'],
                                width: 86,
                                height: 86,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(color: surfaceColor, child: const CircularProgressIndicator(color: primaryColor)),
                              ),
                      ),
                    ),
                  ),
                ),

                // VIP / Level Badge - FIXED POSITIONING
                if (profileData['vvip_or_vip_preference']?['vvip_or_vip_gif'] != null)
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(left: 50),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: goldAccent, width: 2),
                          boxShadow: [BoxShadow(color: goldAccent.withOpacity(0.6), blurRadius: 12)],
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profileData['vvip_or_vip_preference']['vvip_or_vip_gif'],
                            width: 36,
                            height: 36,
                          ),
                        ),
                      ),
                    ),
                  )
                else if (!isOwnProfile)
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(left: 50),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: primaryColor,
                          child: Text(
                            '${data['level']?['level'] ?? 0}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      );
    },
  );
}