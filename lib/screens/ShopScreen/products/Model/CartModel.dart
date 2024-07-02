import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';

class Cartmodel
{
  final List<CartItem> items;
  final String cart_payment_image;
  final String customer_id;
  final String shop_id;
  final int gst;
  final int sgst;
  Cartmodel({
    required this.items,
    required this.cart_payment_image,
    required this.customer_id,
    required this.shop_id,
    required this.gst,
    required this.sgst
  });

  factory Cartmodel.fromFirestore(QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Cartmodel(
      items: (data['items'] as List).map((item) => CartItem.fromMap(item)).toList(),
      cart_payment_image: data['cart_payment_image'],
      customer_id: data['customer_id'],
      shop_id: data['shop_id'],
      gst: data['tax']['gst'], // Ensure this nested access is correct
      sgst: data['tax']['sgst'], // Ensure this nested access is correct
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'cart_payment_image': cart_payment_image,
      'customer_id': customer_id,
      'shop_id': shop_id,
      'gst': gst,
      'sgst': sgst,
    };
  }
}

class CartItem
{
  final String product_name;
  final int product_price;
  final int product_qty;
  final String product_sizeVariant;
  final int total_product_price;
  CartItem({
    required this.product_name,
    required this.product_price,
    required this.product_qty,
    required this.product_sizeVariant,
    required this.total_product_price,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product_name: map['product_name'],
      product_price: map['product_price'],
      product_qty: map['product_qty'],
      product_sizeVariant: map['product_size_variant'],
      total_product_price: map['total_product_price'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'product_name': product_name,
      'product_price': product_price,
      'product_qty': product_qty,
      'product_size_variant': product_sizeVariant,
      'total_product_price': total_product_price,
    };
  }
}

class Tuple2
{
  final ShopModel item1;
  final String item2;
  Tuple2({
    required this.item1,
    required this.item2
});
}