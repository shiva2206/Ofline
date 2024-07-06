import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';

class Cartmodel {
  List<CartItem> items;
  final String cart_payment_image;
  final String customer_id;
  final String shop_id;
    final String id; 
  final double gst;
  final double sgst;
  final double total_amount;
  int total_cart_item;

  Cartmodel({
    required this.items,
    required this.cart_payment_image,
    required this.customer_id,
    required this.shop_id,
    required this.id, 
    required this.gst,
    required this.sgst,
    required this.total_cart_item,
    required this.total_amount,
  });

  factory Cartmodel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Cartmodel(
      id: doc.id, // And this
      items: (data['cart_items'] as List).map((item) => CartItem.fromMap(item)).toList(),
      cart_payment_image: data['cart_payment_image'],
      customer_id: data['customer_id'],
      shop_id: data['shop_id'],
      gst: data['tax']['gst'],
      sgst: data['tax']['state_tax'],
      total_amount: data['total_amount'].toDouble(),
      total_cart_item: data['total_cart_item']
    );
  }
}
class CartItem {
  final String cart_product_name;
  final double cart_product_price;
  int cart_product_qty;
  final String cart_product_sizeVariant;
  final double cart_total_product_price;

  CartItem({
    required this.cart_product_name,
    required this.cart_product_price,
    required this.cart_product_qty,
    required this.cart_product_sizeVariant,
    required this.cart_total_product_price,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      cart_product_name: map['cart_product_name'],
      cart_product_price: map['cart_product_price'],
      cart_product_qty: map['cart_product_qty'],
      cart_product_sizeVariant: map['cart_product_sizeVariant'],
      cart_total_product_price: map['total_cart_product_price'],
    );
  }
}

class Tuple2 {
  final String shopId;
  final String customerId;

  Tuple2({
    required this.shopId,
    required this.customerId,
  });
}
