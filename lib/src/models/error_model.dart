class ErrorModel {
  ErrorModel({
    this.errorData,
  });

  Map<String, List<String>>? errorData;

  factory ErrorModel.fromJson(dynamic json) {
    var model = ErrorModel();
    if(json is Map<String, dynamic>) {
      json.forEach((key, value) {
        model.errorData ??= {};
        model.errorData?.putIfAbsent(key,
                () => (value as List<dynamic>).map((e) => e as String).toList());
      });
    }
    return model;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (errorData != null) {
      errorData!.forEach((key, value) {
        json.putIfAbsent(key, () => value);
      });
    }
    return json;
  }
}