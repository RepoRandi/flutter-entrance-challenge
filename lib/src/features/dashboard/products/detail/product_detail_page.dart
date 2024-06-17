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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Discounted Price: ${product.discountPrice}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.green),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Description: ${product.description ?? 'No description available.'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Return Terms: ${product.returnTerms ?? 'No return terms available.'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Prescription Required: ${product.isPrescriptionDrugs ?? false ? 'Yes' : 'No'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 8),
                      Text(
                        'Rating Count: ${product.ratingCount ?? 0}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 8),
                      Text(
                        'Created At: ${product.createdAt != null ? product.createdAt!.toLocal().toString() : 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Updated At: ${product.updatedAt != null ? product.updatedAt!.toLocal().toString() : 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (product.categories != null &&
                          product.categories!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Categories:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ...product.categories!.map((category) => Text(
                                  category.name,
                                  style: const TextStyle(fontSize: 16),
                                ))
                          ],
                        ),
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
