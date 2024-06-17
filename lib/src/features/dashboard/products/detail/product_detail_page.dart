import 'package:cached_network_image/cached_network_image.dart';
import 'package:entrance_test/src/constants/color.dart';
import 'package:entrance_test/src/utils/number_ext.dart';
import 'package:entrance_test/src/widgets/product_review_widget.dart';
import 'package:entrance_test/src/widgets/user_review_widget.dart';
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
                        'Terms & Conditions of Return / Refund',
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
                            UserReviewWidget(
                                imageUrl:
                                    'https://images.unsplash.com/photo-1631947430066-48c30d57b943?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHx8MA%3D%3D',
                                userName: 'Amanda Zahra',
                                rating: 5,
                                daysAgo: 1),
                            SizedBox(height: 12.0),
                            ProductReviewWidget(
                                reviewText:
                                    'Produk skincare ini sangat membantu menjaga kondisi kulit saya tetap sehat dan terhidrasi sepanjang hari. Saya sangat merekomendasikan produk ini kepada ...')
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        const Column(
                          children: [
                            UserReviewWidget(
                                imageUrl:
                                    'https://images.unsplash.com/photo-1628015081036-0747ec8f077a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Z2lybHxlbnwwfHwwfHx8MA%3D%3D',
                                userName: 'R****a',
                                rating: 5,
                                daysAgo: 1),
                            SizedBox(height: 12.0),
                            ProductReviewWidget(
                                reviewText:
                                    'Saya memiliki kulit sensitif dan cenderung breakout. Namun, setelah mencoba produk skincare ini, kulit saya terlihat jauh lebih sehat dan tidak ada reaksi n... ')
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        const Column(
                          children: [
                            UserReviewWidget(
                                imageUrl:
                                    'https://plus.unsplash.com/premium_photo-1673792686302-7555a74de717?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGdpcmx8ZW58MHx8MHx8fDA%3D',
                                userName: 'Pevita Ginting',
                                rating: 4,
                                daysAgo: 2),
                            SizedBox(height: 12.0),
                            ProductReviewWidget(
                                reviewText:
                                    'Saya suka konsistensi dari produk skincare ini. Tidak terlalu berat atau lengket, dan cepat meresap ke dalam kulit.')
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
                          .map(
                            (rating) => Column(
                              children: [
                                UserReviewWidget(
                                  imageUrl: rating.userProfilePicture,
                                  userName: rating.userName,
                                  rating: rating.rating,
                                  daysAgo: int.parse(rating.createdAt),
                                ),
                                const SizedBox(height: 12.0),
                                ProductReviewWidget(reviewText: rating.review),
                                const SizedBox(height: 24.0),
                              ],
                            ),
                          )
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
