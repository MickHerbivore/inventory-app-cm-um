import 'dart:convert';

class ProductList {
  ProductList({
    required this.listado,
  });

  List<Product> listado;

  factory ProductList.fromJson(String str) => ProductList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductList.fromMap(Map<String, dynamic> json) => ProductList(
        listado:
            List<Product>.from(json["documents"]?.map((x) => Product.fromMap(x["fields"], x["name"])) ?? []),
      );

  Map<String, dynamic> toMap() => {
        "Product": List<dynamic>.from(listado.map((x) => x.toMap())),
      };
}

class Product {
  Product({
    this.id = '',
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productState,
    required this.categoryId,
  });

  String id;
  String productName;
  int productPrice;
  String productImage;
  String productState;
  String categoryId;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str), '');

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json, String name) => Product(
        id: name.split('/').last,
        productName: json["productName"]["stringValue"],
        productPrice: int.parse(json["productPrice"]["integerValue"]),
        productImage: json["productImage"]["stringValue"],
        productState: json["productState"]["stringValue"],
        categoryId: json["categoryId"]["stringValue"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "productName": productName,
        "productPrice": productPrice,
        "productImage": productImage,
        "productState": productState,
        "categoryId": categoryId,
      };

  Product copy() => Product(
      id: id,
      productName: productName,
      productPrice: productPrice,
      productImage: productImage,
      productState: productState,
      categoryId: categoryId,
    );
}
