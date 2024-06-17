import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/routes/route_name.dart';
import '../../../../repositories/user_repository.dart';
import '../../../../utils/database_helper.dart';
import '../../../../utils/networking_util.dart';
import '../../../../widgets/snackbar_widget.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  final _name = "".obs;

  String get name => _name.value;

  final _phone = "".obs;

  String get phone => _phone.value;

  final _profilePictureUrl = "".obs;

  String get profilePictureUrl => _profilePictureUrl.value;

  var isLoading = false.obs;

  var isLoadingProgress = false.obs;

  var downloadProgress = 0.obs;

  ProfileController({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  void onInit() {
    super.onInit();
    loadUserFromServer();
  }

  void loadUserFromServer() async {
    try {
      final response = await _userRepository.getUser();
      if (response.status == 0) {
        final localUser = response.data;

        _name.value = localUser.name;
        _phone.value = localUser.countryCode.isNotEmpty
            ? "+${localUser.countryCode}${localUser.phone}"
            : "";
        _profilePictureUrl.value = localUser.profilePicture ?? '';
      } else {
        SnackbarWidget.showFailedSnackbar(response.message);
      }
    } catch (error) {
      SnackbarWidget.showFailedSnackbar(NetworkingUtil.errorMessage(error));
    }
  }

  onEditProfileClick() async {
    Get.toNamed(RouteName.editProfile);
  }

  /*
    This Function is used as challenge tester
    DO NOT modify this function
   */
  onTestUnauthenticatedClick() async {
    await _userRepository.testUnauthenticated();
  }

  Future<void> onDownloadFileClick() async {
    try {
      isLoadingProgress.value = true;
      final dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/flutter_tutorial.pdf";

      await dio.download(
        "https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf",
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            downloadProgress.value = int.parse(progress);
          }
        },
      );

      isLoadingProgress.value = false;
      downloadProgress.value = 0;
      SnackbarWidget.showSuccessSnackbar("Download complete: $filePath");
    } catch (e) {
      isLoadingProgress.value = false;
      downloadProgress.value = 0;
      SnackbarWidget.showFailedSnackbar("Download failed: $e");
    }
  }

  Future<void> onOpenWebPageClick() async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=lpnKWK-KEYs');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void confirmLogout() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              doLogout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void doLogout() async {
    isLoading.value = true;

    try {
      await _userRepository.logout();
      await removeAllFavorites();
      Get.offAllNamed(RouteName.login);
    } catch (error) {
      SnackbarWidget.showFailedSnackbar(error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeAllFavorites() async {
    await _databaseHelper.deleteAllFavorites();
  }
}
