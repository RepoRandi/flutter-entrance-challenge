import 'package:entrance_test/src/features/dashboard/products/detail/component/product_detail_binding.dart';
import 'package:entrance_test/src/features/dashboard/products/detail/product_detail_page.dart';
import 'package:entrance_test/src/features/onboarding/component/onboarding_binding.dart';
import 'package:get/get.dart';

import '../../src/features/dashboard/component/dashboard_binding.dart';
import '../../src/features/dashboard/dashboard_page.dart';
import '../../src/features/dashboard/profile/edit/component/edit_profile_binding.dart';
import '../../src/features/dashboard/profile/edit/edit_profile_page.dart';
import '../../src/features/login/component/login_binding.dart';
import '../../src/features/login/login_page.dart';
import '../../src/features/onboarding/onboarding_page.dart';
import '../../src/features/splash/splash_screen.dart';
import 'route_name.dart';

class AppRoute {
  static final pages = [
    GetPage(
      name: RouteName.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: RouteName.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: RouteName.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RouteName.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: RouteName.editProfile,
      page: () => const EditProfilePage(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: RouteName.productDetail,
      page: () => const ProductDetailPage(),
      binding: ProductDetailBinding(),
    ),
  ];
}
