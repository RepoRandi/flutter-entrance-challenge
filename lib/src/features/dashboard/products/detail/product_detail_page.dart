import 'package:cached_network_image/cached_network_image.dart';
import 'package:entrance_test/src/constants/color.dart';
import 'package:entrance_test/src/utils/number_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/icon.dart';
import 'component/product_detail_controller.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Product',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: black),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.product == null) {
          return const Center(child: Text('Product not found'));
        } else {
          final product = controller.product!;
          final ratings = controller.ratings.take(3).toList();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  imageUrl: product.images?.isNotEmpty == true
                      ? product.images![0].url ?? ''
                      : '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    ic_error_image,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.price.inRupiah(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: black),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: yellow,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            '${product.ratingAverage}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            '(${product.reviewCount ?? 0} Reviews)',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: gray600),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 6,
                  decoration: const BoxDecoration(color: gray100),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Description',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: black),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        product.description ?? 'No description available.',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: black),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 6,
                  decoration: const BoxDecoration(color: gray100),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Description',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: black),
                      ),
                      const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          children: product.returnTerms!
                              .split('\n')
                              .asMap()
                              .map((index, text) => MapEntry(
                                    index,
                                    TextSpan(
                                      text: '${index + 1}. $text\n',
                                    ),
                                  ))
                              .values
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 6,
                  decoration: const BoxDecoration(color: gray100),
                ),
                if (ratings.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Product Review',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: black),
                            ),
                            Text(
                              'See More',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: yellow,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              '${product.ratingAverage}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              'from ${product.ratingCount ?? 0} rating)',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: gray600),
                            ),
                            const SizedBox(width: 4.0),
                            Container(
                              height: 4,
                              width: 4,
                              decoration: BoxDecoration(
                                  color: gray600,
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              '${product.reviewCount ?? 0} reviews',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: gray600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        const Column(
                          children: [
                            Row(),
                            SizedBox(height: 12.0),
                          ],
                        )
                      ],
                    ),
                  ),
                if (ratings.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ratings:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ...ratings
                          .map((rating) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(rating.userProfilePicture),
                                ),
                                title: Text(rating.userName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(rating.review),
                                    Text(
                                      'Rating: ${rating.rating}⭐',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Reviewed on: ${rating.createdAt}',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ))
                          .toList()
                    ],
                  )
              ],
            ),
          );
        }
      }),
    );
  }
}
