import 'package:entrance_test/app/routes/route_name.dart';
import 'package:get/get.dart';

import '../../../../../models/product_model.dart';
import '../../../../../models/request/product_list_request_model.dart';
import '../../../../../repositories/product_repository.dart';
import '../../../../../utils/database_helper.dart';
import '../../../../../utils/networking_util.dart';
import '../../../../../widgets/snackbar_widget.dart';
import '../../../favorite/component/favorite_list_controller.dart';

class ProductListController extends GetxController {
  final ProductRepository _productRepository;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  ProductListController({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  final RxList<ProductModel> _products = <ProductModel>[].obs;

  List<ProductModel> get products => _products.toList();

  final _isLoadingRetrieveProduct = false.obs;

  bool get isLoadingRetrieveProduct => _isLoadingRetrieveProduct.value;

  final _isLoadingRetrieveMoreProduct = false.obs;

  bool get isLoadingRetrieveMoreProduct => _isLoadingRetrieveMoreProduct.value;

  final _isLoadingRetrieveCategory = false.obs;

  bool get isLoadingRetrieveCategory => _isLoadingRetrieveCategory.value;

  final _canFilterCategory = true.obs;

  bool get canFilterCategory => _canFilterCategory.value;

  final _isLastPageProduct = false.obs;

  //The number of product retrieved each time a call is made to server
  final _limit = 10;

  //The number which shows how many product already loaded to the device,
  //thus giving the command to ignore the first x number of data when retrieving
  int _skip = 0;

  final favorites = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
    fetchFavorites();
  }

  //first load or after refresh.
  void getProducts() async {
    _isLoadingRetrieveProduct.value = true;
    _skip = 0;
    try {
      final productList =
          await _productRepository.getProductList(ProductListRequestModel(
        limit: _limit,
        skip: _skip,
      ));
      _products.value = productList.data;
      _products.refresh();
      _isLastPageProduct.value = productList.data.length < _limit;
      _skip = products.length;

      syncFavorites();
    } catch (error) {
      SnackbarWidget.showFailedSnackbar(NetworkingUtil.errorMessage(error));
    }
    _isLoadingRetrieveProduct.value = false;
  }

  void getMoreProducts() async {
    if (_isLastPageProduct.value || _isLoadingRetrieveMoreProduct.value) return;

    _isLoadingRetrieveMoreProduct.value = true;

    try {
      final productList =
          await _productRepository.getProductList(ProductListRequestModel(
        limit: _limit,
        skip: _skip,
      ));
      _products.addAll(productList.data);
      _isLastPageProduct.value = productList.data.length < _limit;
      _skip = products.length;

      syncFavorites();
    } catch (error) {
      SnackbarWidget.showFailedSnackbar(NetworkingUtil.errorMessage(error));
    }

    _isLoadingRetrieveMoreProduct.value = false;
  }

  void toProductDetail(ProductModel product) async {
    Get.toNamed(RouteName.productDetail, parameters: {'id': product.id});
  }

  Future<void> fetchFavorites() async {
    final data = await _databaseHelper.fetchFavorites();
    favorites.assignAll(data);

    syncFavorites();
  }

  Future<void> addFavorite(ProductModel product) async {
    await _databaseHelper.insertFavorite(product);
    fetchFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await _databaseHelper.deleteFavorite(id);
    fetchFavorites();
  }

  void setFavorite(ProductModel product) async {
    product.isFavorite = !product.isFavorite;
    try {
      if (product.isFavorite) {
        await addFavorite(product);
        print('Added to favorites: ${product.id}');
      } else {
        await removeFavorite(product.id);
        print('Removed from favorites: ${product.id}');
      }
      final favoriteListController = Get.find<FavoriteListController>();
      favoriteListController.fetchFavorites();

      syncFavorites();
    } catch (e) {
      print('Error setting favorite: $e');
    }
  }

  void syncFavorites() {
    final favoriteListController = Get.find<FavoriteListController>();
    for (var product in _products) {
      product.isFavorite =
          favoriteListController.favorites.any((fav) => fav.id == product.id);
    }
    _products.refresh();
  }
}
