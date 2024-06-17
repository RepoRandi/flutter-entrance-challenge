import 'package:get/get.dart';

import '../../../../../models/product_model.dart';
import '../../../../../models/rating_model.dart';
import '../../../../../repositories/product_repository.dart';
import '../../../../../utils/networking_util.dart';
import '../../../../../widgets/snackbar_widget.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _productRepository;
  ProductDetailController({required ProductRepository productRepository})
      : _productRepository = productRepository;

  final Rx<ProductModel?> _product = Rx<ProductModel?>(null);
  ProductModel? get product => _product.value;

  final _ratings = <RatingModel>[].obs;
  List<RatingModel> get ratings => _ratings;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    final productId = Get.parameters['id'];
    if (productId != null) {
      getProductDetail(productId);
      getProductRatings(productId);
    } else {
      Get.back();
    }
  }

  Future<void> getProductDetail(String id) async {
    _isLoading.value = true;
    try {
      final response = await _productRepository.getProductDetail(id);
      _product.value = response.data;
    } catch (error) {
      SnackbarWidget.showFailedSnackbar(NetworkingUtil.errorMessage(error));
    }
    _isLoading.value = false;
  }

  Future<void> getProductRatings(String productId) async {
    try {
      final ratingResponse =
          await _productRepository.getProductRatings(productId);
      _ratings.assignAll(ratingResponse.data);
    } catch (error) {
      SnackbarWidget.showFailedSnackbar(NetworkingUtil.errorMessage(error));
    }
  }
}
