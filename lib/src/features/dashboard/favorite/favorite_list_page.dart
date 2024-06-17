import 'package:cached_network_image/cached_network_image.dart';
import 'package:entrance_test/src/features/dashboard/favorite/component/favorite_list_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/icon.dart';

class FavoriteListPage extends GetView<FavoriteListController> {
  const FavoriteListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Products'),
      ),
      body: Obx(() {
        if (controller.favorites.isEmpty) {
          return const Center(child: Text('No favorites yet'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final product = controller.favorites[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: CachedNetworkImage(
                  imageUrl: product.images?.isNotEmpty == true
                      ? product.images![0].urlSmall ?? ''
                      : '',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    ic_error_image,
                    fit: BoxFit.contain,
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    if (product.discountPrice != product.price)
                      Row(
                        children: [
                          Text(
                            'Rp${product.price}',
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rp${product.discountPrice}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'Rp${product.price}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          product.ratingAverage.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('(${product.ratingCount})'),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.removeFavorite(product.id),
                ),
                onTap: () {
                  // Implement navigation to product detail if needed
                },
              ),
            );
          },
        );
      }),
    );
  }
}
