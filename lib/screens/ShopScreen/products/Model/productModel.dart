import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? name;
  int? price;
  String? image;
  OrderModel({required this.name, required this.price, required this.image});
}

class OrderProductList {
  List<OrderModel> orderProduct = [
    OrderModel(name: 'Cheese', price: 89, image: "images/coffee.jpg"),
    OrderModel(name: 'Aaloo Pratha', price: 39, image: "images/coffee.jpg"),
    OrderModel(name: 'Matar Paneer', price: 67, image: "images/coffee.jpg"),
    OrderModel(name: 'Sandwich Masala', price: 44, image: "images/coffee.jpg"),
    OrderModel(name: 'Paneer Dosa', price: 89, image: "images/coffee.jpg"),
    OrderModel(name: 'Sweet Corn', price: 100, image: "images/coffee.jpg"),
    OrderModel(name: 'Fish Curry', price: 99, image: "images/coffee.jpg"),
    OrderModel(
        name: 'Chinese Choummin', price: 109, image: "images/coffee.jpg"),
    OrderModel(name: 'Samosa Chat', price: 55, image: "images/coffee.jpg"),
  ];
}

class OrderCategoryList {
  // List <OrderCategoryList> myList = [];

  Map<String, List<OrderModel>> orderProductCategory = {
    "Cheese": [
      OrderModel(name: 'Spring Roll', price: 65, image: "images/coffee.jpg"),
      OrderModel(name: 'Chicken Egg Roll', price: 70, image: "images/bag.jpg"),
      OrderModel(
          name: 'Chicken Kathi Roll', price: 90, image: "images/bag.jpg"),
      OrderModel(
          name: ' Single Chicken Kathi Roll',
          price: 80,
          image: "images/bag.jpg"),
    ],
    "Paneer": [
      OrderModel(name: 'Egg Roll', price: 60, image: "images/coffee.jpg"),
      OrderModel(name: 'Paneer Egg Roll', price: 70, image: "images/bag.jpg"),
      OrderModel(name: 'Bhurji Egg Roll', price: 90, image: "images/bag.jpg"),
      OrderModel(name: 'Egg Biryani', price: 100, image: "images/bag.jpg"),
    ],
    "Chicken": [
      OrderModel(name: 'Spring Roll', price: 65, image: "images/coffee.jpg"),
      OrderModel(name: 'Spring Roll', price: 65, image: "images/coffee.jpg"),
      OrderModel(name: 'Spring Roll', price: 65, image: "images/coffee.jpg"),
      OrderModel(name: 'Spring Roll', price: 65, image: "images/coffee.jpg"),
      OrderModel(name: 'Chicken Egg Roll', price: 70, image: "images/bag.jpg"),
      OrderModel(
          name: 'Chicken Kathi Roll', price: 90, image: "images/bag.jpg"),
      OrderModel(
          name: ' Single Chicken Kathi Roll',
          price: 80,
          image: "images/bag.jpg"),
    ],
    "Mushroom": [
      OrderModel(name: 'Egg Roll', price: 60, image: "images/coffee.jpg"),
      OrderModel(name: 'Paneer Egg Roll', price: 70, image: "images/bag.jpg"),
      OrderModel(name: 'Bhurji Egg Roll', price: 90, image: "images/bag.jpg"),
      OrderModel(name: 'Egg Biryani', price: 100, image: "images/bag.jpg"),
    ],
    "Slider": [
      OrderModel(name: 'Spring Roll', price: 65, image: "images/coffee.jpg"),
      OrderModel(name: 'Chicken Egg Roll', price: 70, image: "images/bag.jpg"),
      OrderModel(
          name: 'Chicken Kathi Roll', price: 90, image: "images/bag.jpg"),
      OrderModel(
          name: ' Single Chicken Kathi Roll',
          price: 80,
          image: "images/bag.jpg"),
    ],
    "Non-Veg": [
      OrderModel(name: 'Egg Roll', price: 60, image: "images/coffee.jpg"),
      OrderModel(name: 'Paneer Egg Roll', price: 70, image: "images/bag.jpg"),
      OrderModel(name: 'Bhurji Egg Roll', price: 90, image: "images/bag.jpg"),
      OrderModel(name: 'Egg Biryani', price: 100, image: "images/bag.jpg"),
    ],
    "Veg": [
      OrderModel(name: 'Spring Roll', price: 65, image: "images/coffee.jpg"),
      OrderModel(name: 'Chicken Egg Roll', price: 70, image: "images/bag.jpg"),
      OrderModel(
          name: 'Chicken Kathi Roll', price: 90, image: "images/bag.jpg"),
      OrderModel(
          name: ' Single Chicken Kathi Roll',
          price: 80,
          image: "images/bag.jpg"),
    ],
    "Non-Veg": [
      OrderModel(name: 'Egg Roll', price: 60, image: "images/coffee.jpg"),
      OrderModel(name: 'Paneer Egg Roll', price: 70, image: "images/bag.jpg"),
      OrderModel(name: 'Bhurji Egg Roll', price: 90, image: "images/bag.jpg"),
      OrderModel(name: 'Egg Biryani', price: 100, image: "images/bag.jpg"),
    ],
    "Veg": [
      OrderModel(name: 'Spring Roll', price: 65, image: "images/coffee.jpg"),
      OrderModel(name: 'Chicken Egg Roll', price: 70, image: "images/bag.jpg"),
      OrderModel(
          name: 'Chicken Kathi Roll', price: 90, image: "images/bag.jpg"),
      OrderModel(
          name: ' Single Chicken Kathi Roll',
          price: 80,
          image: "images/bag.jpg"),
    ],
    "Non-Veg": [
      OrderModel(name: 'Egg Roll', price: 60, image: "images/coffee.jpg"),
      OrderModel(name: 'Paneer Egg Roll', price: 70, image: "images/bag.jpg"),
      OrderModel(name: 'Bhurji Egg Roll', price: 90, image: "images/bag.jpg"),
      OrderModel(name: 'Egg Biryani', price: 100, image: "images/bag.jpg"),
    ],
  };
}

class ProductModel {
  final String id;
  final String product_name;
  final String product_image;
  final Map<String, double> sizeVariants;

  ProductModel(
      {required this.id,
      required this.product_name,
      required this.product_image,
      required this.sizeVariants});


  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map <String, dynamic>;
    return ProductModel(
        id: doc.id,
        product_name: data['product_name'],
        product_image: data['productImageLink'],
        sizeVariants: data['sizeVariants']);
  }
}
