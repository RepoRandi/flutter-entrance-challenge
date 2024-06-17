import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../app/routes/route_name.dart';
import '../../../repositories/user_repository.dart';
import '../../../widgets/snackbar_widget.dart';

class LoginController extends GetxController {
  final UserRepository _userRepository;

  LoginController({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  final etPhone = TextEditingController();
  final etPassword = TextEditingController();
  var countryCode = '62'.obs;
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void doLogin() async {
    if (etPhone.text.length < 8 || etPhone.text.length > 16) {
      SnackbarWidget.showFailedSnackbar(
          'Nomor telepon harus antara 8 dan 16 digit.');
      return;
    }

    if (!RegExp(r'^[1-9][0-9]*$').hasMatch(etPhone.text)) {
      SnackbarWidget.showFailedSnackbar(
          'Nomor telepon harus valid dan tidak boleh diawali dengan 0.');
      return;
    }

    if (etPassword.text.length < 8) {
      SnackbarWidget.showFailedSnackbar(
          'Kata sandi harus terdiri dari minimal 8 karakter');
      return;
    }

    isLoading.value = true;

    try {
      await _userRepository.login(
          countryCode.value, etPhone.text, etPassword.text);
      Get.offAllNamed(RouteName.dashboard);
    } catch (error) {
      SnackbarWidget.showFailedSnackbar(error.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
