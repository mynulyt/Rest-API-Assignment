class ProductModel {
  late String id;
  late String name;
  late int code;
  late String image;
  late int quantity;
  late int uniPrice;
  late int totalPrice;

  ProductModel.fromJson(Map<String, dynamic> productJson) {
    id = productJson['_id'];
    name = productJson['ProductName'];
    code = productJson['ProductCode'];
    image = productJson['Img'];
    quantity = productJson['Qty'];
    uniPrice = productJson['UnitPrice'];
    totalPrice = productJson['TotalPrice'];
  }
}
