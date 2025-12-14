import 'package:cached_network_image/cached_network_image.dart';
import 'package:doyel_live/app/modules/auth/controllers/auth_controller.dart';
import 'package:doyel_live/app/modules/live_streaming/controllers/live_streaming_controller.dart';
import 'package:doyel_live/app/widgets/reusable_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GiftsWidget extends StatelessWidget {
  const GiftsWidget({
    super.key,
    required this.streamingController,
    required this.authController,
    required this.data,
    required this.onUpdateAction,
  });
  final LiveStreamingController streamingController;
  final AuthController authController;
  final dynamic data;
  final Function onUpdateAction;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (streamingController.listAnimatedGift.isEmpty ||
          streamingController.listNormalGift.isEmpty) {
        streamingController.fetchGiftList();
      }
    });
    return Obx(() {
      if (streamingController.loadingGfitList.value) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF7374F).withOpacity(0.2),
                  const Color(0xFF88304E).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const SpinKitChasingDots(
              color: Color(0xFFF7374F),
              size: 50.0,
            ),
          ),
        );
      }
      return Container(
        height: streamingController.listActiveCall.length == 1 &&
                streamingController.channelName.value ==
                    authController.profile.value.user!.uid!.toString()
            ? 300
            : 380,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2C2C2C),
              const Color(0xFF1E1E1E),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF7374F).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Decorative top bar
            Container(
              height: 4,
              width: 48,
              margin: const EdgeInsets.only(top: 8, bottom: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF7374F), Color(0xFF88304E)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Active users list
            SizedBox(
              height: 60,
              child: Obx(
                () {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: streamingController.listActiveCall.length,
                    separatorBuilder: (context, index) => SizedBox(
                      width: streamingController.listActiveCall[index]['uid'] ==
                              authController.profile.value.user!.uid!
                          ? 0
                          : 8,
                    ),
                    itemBuilder: ((context, index) {
                      dynamic data = streamingController.listActiveCall[index];
                      if (data['uid'] ==
                          authController.profile.value.user!.uid!) {
                        return Container();
                      }
                      return InkWell(
                        onTap: () {
                          if (data['selected'] != null) {
                            data['selected'] = !data['selected'];
                          } else {
                            data['selected'] = true;
                          }
                          streamingController.listActiveCall.removeAt(index);
                          streamingController.listActiveCall
                              .insert(index, data);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: data['selected'] == true
                                ? const LinearGradient(
                                    colors: [Color(0xFFF7374F), Color(0xFF88304E)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: data['selected'] != true
                                ? const Color(0xFF2C2C2C)
                                : null,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              width: data['selected'] == true ? 2 : 1,
                              color: data['selected'] == true
                                  ? const Color(0xFFFFD700)
                                  : const Color(0xFF522546),
                            ),
                            boxShadow: data['selected'] == true
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFFF7374F).withOpacity(0.4),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFFFD700), Color(0xFFF7374F)],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFFFD700).withOpacity(0.3),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: data['profile_image'] == null
                                              ? Image.asset(
                                                  'assets/others/person.jpg',
                                                  width: 28,
                                                  height: 28,
                                                  fit: BoxFit.cover,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl:
                                                      '${data['profile_image']}',
                                                  width: 28,
                                                  height: 28,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Color(0xFFF7374F),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      if (data['vvip_or_vip_preference'] != null &&
                                          data['vvip_or_vip_preference']
                                                  ['vvip_or_vip_gif'] !=
                                              null)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFFFFD700), Color(0xFFF7374F)],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                            ),
                                            padding: const EdgeInsets.all(1),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              child: CachedNetworkImage(
                                                imageUrl: data[
                                                        'vvip_or_vip_preference']
                                                    ['vvip_or_vip_gif'],
                                                width: 14,
                                                height: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '#${data['uid']}',
                                  style: TextStyle(
                                    fontSize: 6,
                                    fontWeight: FontWeight.bold,
                                    color: data['selected'] == true
                                        ? const Color(0xFFFFD700)
                                        : Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Animated gifts section
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: streamingController.listAnimatedGift.length,
                itemBuilder: ((context, index) {
                  dynamic giftData =
                      streamingController.listAnimatedGift[index];
                  return giftItem(
                    streamingController: streamingController,
                    authController: authController,
                    giftData: giftData,
                  );
                }),
              ),
            ),
            
            const SizedBox(height: 6),
            
            // Normal gifts section
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: streamingController.listNormalGift.length,
                itemBuilder: ((context, index) {
                  dynamic giftData = streamingController.listNormalGift[index];
                  return giftItem(
                    streamingController: streamingController,
                    authController: authController,
                    giftData: giftData,
                  );
                }),
              ),
            ),
            
            const SizedBox(height: 6),
            
            // Bottom action bar
            data['uid'] == authController.profile.value.user!.uid! &&
                    streamingController.listActiveCall.firstWhereOrNull((el) =>
                            el['selected'] != null &&
                            el['selected'] == true &&
                            el['uid'] !=
                                authController.profile.value.user!.uid!) ==
                        null
                ? const SizedBox(height: 46)
                : Container(
                    height: 56,
                    margin: const EdgeInsets.only(left: 14, right: 14, bottom: 14,top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF522546).withOpacity(0.6),
                          const Color(0xFF88304E).withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF88304E).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD700).withOpacity(0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/others/diamond.png',
                            width: 16,
                            height: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Obx(() {
                          return Text(
                            '${authController.profile.value.diamonds}',
                            style: const TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                        const SizedBox(width: 6),
                        Container(
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00C853), Color(0xFF64DD17)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00C853).withOpacity(0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => Get.snackbar(
                              'Oops',
                              "Coming Soon!",
                              backgroundColor: const Color(0xFFF7374F),
                              colorText: Colors.white,
                              snackPosition: SnackPosition.TOP,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              '+ Recharge',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Obx(() {
                          return Container(
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: streamingController
                                          .selectedGift.value['id'] !=
                                      0
                                  ? const LinearGradient(
                                      colors: [Color(0xFFF7374F), Color(0xFF88304E)],
                                    )
                                  : null,
                              color: streamingController
                                          .selectedGift.value['id'] ==
                                      0
                                  ? const Color(0xFF522546)
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: streamingController
                                          .selectedGift.value['id'] !=
                                      0
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFFF7374F).withOpacity(0.4),
                                        blurRadius: 12,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (streamingController
                                        .selectedGift.value['id'] !=
                                    0) {
                                  List<dynamic> listReceiverIds = [];
                                  String receiverFullNames = '';

                                  int giftDiamonds = int.parse(
                                      streamingController
                                          .selectedGift.value['diamonds']
                                          .toString());
                                  List<dynamic> listReceiver =
                                      streamingController.listActiveCall
                                          .where((el) =>
                                              el['selected'] != null &&
                                              el['selected'] == true)
                                          .toList();
                                  if (listReceiver.isNotEmpty) {
                                    giftDiamonds *= listReceiver.length;
                                    for (int i = 0;
                                        i < listReceiver.length;
                                        i++) {
                                      dynamic receiverData =
                                          listReceiver[i];
                                      listReceiverIds
                                          .add(receiverData['uid']);
                                      if (i == listReceiver.length - 1) {
                                        receiverFullNames +=
                                            '${receiverData['full_name']}';
                                      } else {
                                        receiverFullNames +=
                                            '${receiverData['full_name']}, ';
                                      }
                                    }
                                  } else {
                                    listReceiverIds.add(data['uid']);
                                    receiverFullNames = data['full_name'];
                                  }
                                  if (authController
                                          .profile.value.diamonds! <
                                      giftDiamonds) {
                                    Get.snackbar(
                                      'Failed',
                                      "You've no sufficient diamonds. Please +Recharge.",
                                      backgroundColor: const Color(0xFFF7374F),
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                    return;
                                  }
                                  if (streamingController
                                          .loadingGiftSend.value !=
                                      -1) {
                                    return;
                                  }

                                  await streamingController
                                      .tryToSendGiftOnLiveStreaming(
                                    channelName: streamingController
                                        .channelName.value,
                                    giftType: streamingController
                                        .selectedGift.value['gift_type']
                                        .toString(),
                                    giftId: int.parse(streamingController
                                        .selectedGift.value['id']
                                        .toString()),
                                    context: context,
                                    totalDiamonds: giftDiamonds,
                                    diamonds: int.parse(
                                        streamingController.selectedGift
                                            .value['diamonds']
                                            .toString()),
                                    vat: int.parse(streamingController
                                        .selectedGift.value['vat']
                                        .toString()),
                                    receiverFullNames: receiverFullNames,
                                    receiverUids: listReceiverIds,
                                    giftImage: streamingController
                                        .selectedGift.value['gift_image']
                                        .toString(),
                                    gif: streamingController
                                        .selectedGift.value['gif']
                                        .toString(),
                                    audio: streamingController
                                        .selectedGift.value['audio']
                                        .toString(),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                streamingController.loadingGiftSend.value != -1
                                    ? 'Wait...'
                                    : 'Send',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
          ],
        ),
      );
    });
  }
}

class giftItem extends StatelessWidget {
  const giftItem({
    Key? key,
    required this.streamingController,
    required this.authController,
    required this.giftData,
  }) : super(key: key);

  final LiveStreamingController streamingController;
  final AuthController authController;
  final dynamic giftData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: () async {
          if (authController.profile.value.diamonds! < giftData['diamonds']) {
            Get.snackbar(
              'Failed',
              "You've no sufficient diamonds. Please +Recharge.",
              backgroundColor: const Color(0xFFF7374F),
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
            );
            return;
          }
          streamingController.setSelectedGift(
            giftType: giftData['gif'] != null ? 'animation' : 'normal',
            id: giftData['id'],
            diamonds: giftData['diamonds'],
            vat: giftData['vat'],
            giftImage: giftData['gift_image'],
            gif: giftData['gif'],
            audio: giftData['audio'],
          );
        },
        child: Obx(() {
          bool isSelected = (streamingController.selectedGift.value['id'] ==
                      giftData['id'] &&
                  streamingController.selectedGift.value['gift_type'] ==
                      'animation' &&
                  giftData['gif'] != null) ||
              (streamingController.selectedGift.value['id'] ==
                      giftData['id'] &&
                  streamingController.selectedGift.value['gift_type'] ==
                      'normal' &&
                  giftData['gift_image'] != null);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 66,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFFF7374F), Color(0xFF88304E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        const Color(0xFF2C2C2C).withOpacity(0.6),
                        const Color(0xFF1E1E1E).withOpacity(0.6),
                      ],
                    ),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFFFD700)
                    : const Color(0xFF522546).withOpacity(0.5),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFF7374F).withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: giftData['gif'] ?? giftData['gift_image'],
                    width: 38,
                    height: 38,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF7374F),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/others/diamond.png',
                        width: 14,
                        height: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${giftData['diamonds']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}