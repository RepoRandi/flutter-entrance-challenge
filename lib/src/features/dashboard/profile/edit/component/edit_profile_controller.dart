import 'package:entrance_test/src/features/dashboard/profile/component/profile_controller.dart';
import 'package:entrance_test/src/utils/string_ext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../repositories/user_repository.dart';
import '../../../../../utils/date_util.dart';
import '../../../../../utils/networking_util.dart';
import '../../../../../widgets/snackbar_widget.dart';

class EditProfileController extends GetxController {
  final UserRepository _userRepository;

  EditProfileController({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  final etFullName = TextEditingController();
  final etPhoneNumber = TextEditingController();
  final etEmail = TextEditingController();
  final etHeight = TextEditingController();
  final etWeight = TextEditingController();
  final etBirthDate = TextEditingController();

  final _countryCode = "".obs;

  String get countryCode => _countryCode.value;

  final _gender = ''.obs;

  String get gender => _gender.value;

  final _profilePictureUrlOrPath = ''.obs;

  String get profilePictureUrlOrPath => _profilePictureUrlOrPath.value;

  final _isLoadPictureFromPath = false.obs;

  bool get isLoadPictureFromPath => _isLoadPictureFromPath.value;

  final _isGenderFemale = false.obs;

  bool get isGenderFemale => _isGenderFemale.value;

  DateTime birthDate = DateTime.now();

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

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
        etFullName.text = localUser.name;
        etPhoneNumber.text = localUser.phone;
        etEmail.text = localUser.email ?? '';
        etHeight.text = localUser.height?.toString() ?? '';
        etWeight.text = localUser.weight?.toString() ?? '';

        _countryCode.value = localUser.countryCode;

        _profilePictureUrlOrPath.value = localUser.profilePicture ?? '';
        _isLoadPictureFromPath.value = false;

        _gender.value = localUser.gender ?? '';
        if (gender.isNullOrEmpty || gender == 'laki_laki') {
          onChangeGender(false);
        } else {
          onChangeGender(true);
        }

        etBirthDate.text = '';
        if (localUser.dateOfBirth.isNullOrEmpty == false) {
          birthDate =
              DateUtil.getDateFromShortServerFormat(localUser.dateOfBirth!);
          etBirthDate.text = DateUtil.getBirthDate(birthDate);
        }
      } else {
        SnackbarWidget.showFailedSnackbar(response.message);
      }
    } catch (error) {
      error.printError();
      SnackbarWidget.showFailedSnackbar(NetworkingUtil.errorMessage(error));
    }
  }

  Future<void> changeImage() async {
    if (await _requestStoragePermission()) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _profilePictureUrlOrPath.value = pickedFile.path;
        _isLoadPictureFromPath.value = true;
      } else {
        Get.snackbar('Cancelled', 'Image selection was cancelled.');
      }
    } else {
      Get.snackbar('Permission Denied',
          'You need to grant storage access to change the profile picture.');
    }
  }

  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  void onChangeGender(bool isFemale) {
    if (isFemale) {
      _gender.value = 'perempuan';
    } else {
      _gender.value = 'laki_laki';
    }
    _isGenderFemale.value = isFemale;
  }

  void onChangeBirthDate(DateTime dateTime) {
    birthDate = dateTime;
    etBirthDate.text = DateUtil.getBirthDate(birthDate);
  }

  void saveData() async {
    if (etFullName.text.isEmpty) {
      SnackbarWidget.showFailedSnackbar('Name cannot be empty.');
      return;
    }
    if (etEmail.text.isEmpty ||
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(etEmail.text)) {
      SnackbarWidget.showFailedSnackbar('Invalid email.');
      return;
    }
    if (int.tryParse(etHeight.text) == null || int.parse(etHeight.text) < 0) {
      SnackbarWidget.showFailedSnackbar('Height must be a positive integer.');
      return;
    }
    if (int.tryParse(etWeight.text) == null || int.parse(etWeight.text) < 0) {
      SnackbarWidget.showFailedSnackbar('Weight must be a positive integer.');
      return;
    }

    _isLoading.value = true;

    try {
      await _userRepository.updateUser(
        name: etFullName.text,
        email: etEmail.text,
        height: int.parse(etHeight.text),
        weight: int.parse(etWeight.text),
        gender: _gender.value,
        dateOfBirth: DateUtil.getShortServerFormatDateString(birthDate),
        profilePicturePath:
            isLoadPictureFromPath ? profilePictureUrlOrPath : null,
      );

      final profileController = Get.find<ProfileController>();
      profileController.loadUserFromServer();

      SnackbarWidget.showSuccessSnackbar('Profile updated successfully.');
    } catch (e) {
      SnackbarWidget.showFailedSnackbar(e.toString());
    } finally {
      _isLoading.value = false;
    }
  }
}
