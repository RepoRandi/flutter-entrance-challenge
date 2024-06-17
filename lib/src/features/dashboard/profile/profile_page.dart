import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../constants/color.dart';
import '../../../constants/icon.dart';
import '../../../constants/image.dart';
import '../../../widgets/button_icon.dart';
import 'component/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 0), () {
            controller.loadUserFromServer();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.onEditProfileClick();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() => ClipOval(
                                child: CachedNetworkImage(
                                  width: 48,
                                  height: 48,
                                  imageUrl: controller.profilePictureUrl,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    width: 48,
                                    height: 48,
                                    defaultProfileImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                          const SizedBox(width: 16),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                    controller.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                              const SizedBox(height: 4),
                              Obx(() => Text(
                                    controller.phone,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: gray500,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                            ],
                          )),
                          Image.asset(
                            ic_arrow_right,
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 4, color: gray100, height: 4),
              Column(
                children: [
                  iconTileProfile(ic_test_unauthenticated, "Test 401", () {
                    controller.onTestUnauthenticatedClick();
                  }),
                  Obx(() => controller.isLoadingProgress.value
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: controller.downloadProgress.value / 100,
                            ),
                            const SizedBox(height: 20),
                            Text(
                                'Downloading... ${controller.downloadProgress.value}%'),
                          ],
                        )
                      : iconTileProfile(ic_download, "Download File", () {
                          controller.onDownloadFileClick();
                        })),
                  iconTileProfile(ic_webpage, "Open Webpage", () {
                    controller.onOpenWebPageClick();
                  }),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Obx(() =>
                        signOutButton(context, controller.isLoading.value)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconTileProfile(String iconSource, String text, Function onClick) =>
      InkWell(
        onTap: () {
          onClick();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                iconSource,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Image.asset(
                ic_arrow_right,
                height: 20,
                width: 20,
              ),
            ],
          ),
        ),
      );

  Widget signOutButton(BuildContext context, bool isLoading) => SizedBox(
        height: 52,
        width: double.infinity,
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: ButtonIcon(
            buttonColor: isLoading ? gray500 : red50,
            textColor: red600,
            textLabel: isLoading ? "Signing Out..." : "Sign Out",
            onClick: () {
              controller.confirmLogout();
            },
          ),
        ),
      );
}
