class CategoriesModel {
  String? name;
  String? image;

  CategoriesModel({this.name, this.image});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }
}
