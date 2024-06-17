import '../product_model.dart';

class ProductListRequestModel {
  ProductListRequestModel({
    ProductSort? sort,
    int? limit,
    int? skip,
  })  : _sortBy = SortType.getSortByValue(sort ?? ProductSort.newest),
        _sortOrder = SortType.getSortColumnValue(sort ?? ProductSort.newest),
        _limit = limit ?? 10,
        _skip = skip ?? 0;

  final String _sortBy;
  final String _sortOrder;
  final int _limit;
  final int _skip;

  Map<String, dynamic> toJson() => {
    'sort_column': _sortBy,
    'sort_order': _sortOrder,
    'limit': _limit,
    'skip': _skip,
  };

  @override
  String toString(){
    return toJson().toString();
  }
}
