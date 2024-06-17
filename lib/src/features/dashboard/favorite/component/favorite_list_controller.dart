import 'package:get/get.dart';

import '../../../../models/product_model.dart';
import '../../../../utils/database_helper.dart';
import '../../products/list/component/product_list_controller.dart';

class FavoriteListController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  final favorites = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final data = await _databaseHelper.fetchFavorites();
    favorites.assignAll(data);

    final productListController = Get.find<ProductListController>();
    productListController.syncFavorites();
  }

  void removeFavorite(String id) async {
    await _databaseHelper.deleteFavorite(id);
    fetchFavorites();
  }
}
