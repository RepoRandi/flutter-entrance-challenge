import 'package:entrance_test/src/constants/color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ProductReviewWidget extends StatelessWidget {
  final String reviewText;
  final int maxLength;

  const ProductReviewWidget({
    Key? key,
    required this.reviewText,
    this.maxLength = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool shouldShowSeeMore = reviewText.length > maxLength;
    final String displayText = shouldShowSeeMore
        ? '${reviewText.substring(0, maxLength)}...'
        : reviewText;

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: black,
        ),
        children: [
          TextSpan(
            text: displayText,
          ),
          if (shouldShowSeeMore)
            TextSpan(
              text: ' See More',
              style: const TextStyle(
                color: primary,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
        ],
      ),
    );
  }
}
