import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  final String historyId;
  final String date;
  final String time;
  final String shopId;
  final String customerId;
  final bool isAccepted;
  final bool isDineIn;
  final bool isReady;
  final bool isPaymentIncomplete;
  final bool isCancelled;
  final bool isSuccessful;
  final String historyPaymentImage;
  final String historyShopName;
  final int totalHistoryAmount;
  final List<Map<String, dynamic>> history_items;

  History({
    required this.historyId,
    required this.date,
    required this.time,
    required this.shopId,
    required this.customerId,
    required this.isAccepted,
    required this.isDineIn,
    required this.isReady,
    required this.isPaymentIncomplete,
    required this.isCancelled,
    required this.isSuccessful,
    required this.historyPaymentImage,
    required this.historyShopName,
    required this.totalHistoryAmount,
    required this.history_items,
  });

  factory History.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return History(
      historyId: doc.id,
      date: data['date'],
      time: data['time'],
      shopId: data['shop_id'],
      customerId: data['customer_id'],
      isAccepted: data['isAccepted'],
      isDineIn: data['isDineIn'],
      isReady: data['isReady'],
      isPaymentIncomplete: data['is_payment_incomplete'],
      isCancelled: data['isCancelled'],
      isSuccessful: data['isSuccessful'],
      historyPaymentImage: data['history_payment_image'],
      historyShopName: data['history_shop_name'],
      totalHistoryAmount: data['total_history_amount'],
      history_items: List<Map<String, dynamic>>.from(data['history_item']),
    );
  }
}