import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:entrance_test/src/utils/number_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/color.dart';
import '../../../../constants/icon.dart';
import '../../../../widgets/empty_list_state_widget.dart';
import 'component/product_list_controller.dart';

class ProductListPage extends GetWidget<ProductListController> {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.getMoreProducts();
      }
    });

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: white,
        body: RefreshIndicator(
          onRefresh: () async {
            controller.getProducts();
          },
          child: Obx(
            () => controller.isLoadingRetrieveProduct
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                    ),
                  )
                : controller.products.isEmpty
                    ? const Center(
                        child: EmptyListStateWidget(
                          iconSource: ic_empty_data,
                          text: "No product to show",
                        ),
                      )
                    : buildProductList(context, scrollController),
          ),
        ),
      ),
    );
  }

  Widget buildProductList(
          BuildContext context, ScrollController scrollController) =>
      Column(
        children: [
          Expanded(
            child: DynamicHeightGridView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              itemCount: controller.products.length,
              builder: (context, index) {
                final product = controller.products[index];
                return Container(
                  margin: EdgeInsets.only(
                      left: index % 2 == 0 ? 24 : 0,
                      right: index % 2 == 0 ? 0 : 24,
                      bottom: index == controller.products.length - 1 ? 16 : 0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    shadows: const [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: InkWell(
                    onTap: () => controller.toProductDetail(product),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 1 / 1,
                                child: CachedNetworkImage(
                                  imageUrl: product.images?.isNotEmpty == true
                                      ? product.images![0].urlSmall ?? ''
                                      : '',
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    ic_error_image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () => controller.setFavorite(product),
                                  child: Obx(
                                    () => Image.asset(
                                      product.isFavorite
                                          ? ic_favorite_filled
                                          : ic_favorite_empty,
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: white,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: gray900,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (product.discountPrice != product.price)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.price.inRupiah(),
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: gray600,
                                          fontWeight: FontWeight.w400,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        product.discountPrice.inRupiah(),
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: red600,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Text(
                                    product.price.inRupiah(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: gray900,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Obx(
            () => controller.isLoadingRetrieveMoreProduct
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primary),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
}
