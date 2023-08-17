class PopularModel {
  String? name;
  String? image;
  String? title;
  String? price;

  PopularModel({this.name, this.image, this.title, this.price});

  PopularModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    title = json['title'];
    price = json['price'];
  }
}
