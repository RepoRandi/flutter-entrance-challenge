import 'package:carousel_slider/carousel_slider.dart';
import 'package:entrance_test/src/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:entrance_test/src/features/onboarding/component/onboarding_controller.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider.builder(
              carouselController: controller.carouselController,
              itemCount: controller.contents.length,
              itemBuilder: (context, index, realIndex) {
                final content = controller.contents[index];
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.6,
                        child: Image.asset(content.imageUrl, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        content.title,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          content.description,
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                );
              },
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.7,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  controller.currentIndex.value = index;
                },
              ),
            ),
          ),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(controller.contents.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.currentIndex.value == index
                        ? primary
                        : gray200,
                  ),
                );
              }),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.skip,
                    style: ElevatedButton.styleFrom(backgroundColor: white),
                    child: const Text('Skip'),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(() {
                  return Expanded(
                    child: ElevatedButton(
                      onPressed: controller.next,
                      style: ElevatedButton.styleFrom(backgroundColor: primary),
                      child: Text(
                        controller.currentIndex.value ==
                                controller.contents.length - 1
                            ? 'Finish'
                            : 'Next',
                        style: const TextStyle(color: white),
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
  }
}
