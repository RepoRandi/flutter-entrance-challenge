import 'package:carousel_slider/carousel_slider.dart';
import 'package:entrance_test/src/constants/image.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:entrance_test/src/models/onboarding_content_model.dart';

import '../../../../app/routes/route_name.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  final CarouselController carouselController = CarouselController();
  final GetStorage storage = GetStorage();

  final List<OnboardingContentModel> contents = [
    OnboardingContentModel(
      imageUrl: discoverProducts,
      title: 'Discover Products',
      description: 'Find a variety of products that suit your needs.',
    ),
    OnboardingContentModel(
      imageUrl: favoritesProduct,
      title: 'Add to Favorites',
      description: 'Save your favorite products for easy access.',
    ),
    OnboardingContentModel(
      imageUrl: exclusiveFeatures,
      title: 'Exclusive Features',
      description: 'Enjoy exclusive features and premium content.',
    ),
  ];

  void next() {
    if (currentIndex.value < contents.length - 1) {
      carouselController.nextPage();
    } else {
      _finishOnboarding();
    }
  }

  void skip() {
    _finishOnboarding();
  }

  void _finishOnboarding() async {
    await storage.write('hasSeenOnboarding', true);
    Get.offAllNamed(RouteName.login);
  }
}
