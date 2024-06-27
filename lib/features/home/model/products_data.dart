class ProductsData {
  late final List<ProductsModel> products;

  ProductsData.fromJson(List<dynamic> json) {
    products = json.map((e) => ProductsModel.fromJson(e)).toList();
  }
}

class ProductsModel {
  late final int id;
  late final String title;
  late final num price;
  late final String description;
  late final String image;
  late final String category;
  late final Rating rating;

  ProductsModel.fromJson(Map<dynamic, dynamic> json) {
    id = json["id"] ?? 0;
    title = json["title"] ?? "";
    price = json["price"] ?? 0;
    description = json["description"] ?? "";
    image = json["image"] ?? "";
    category = json["category"] ?? "";
    rating = Rating.fromJson(json["rating"] ?? {});
  }
}

class Rating {
  late final num rate;
  late final num count;

  Rating.fromJson(Map<dynamic, dynamic> json) {
    rate = json["rate"] ?? 0;
    count = json["count"] ?? 0;
  }
}
