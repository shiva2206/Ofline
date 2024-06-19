

class NotificationModel{
  String? shopName;

  String? get Shop_Name => shopName;

  set Shop_Name(String? value) {
    shopName = value;
  }
  String? orderStatus;
  String? time;

  NotificationModel({required this.shopName, required this.orderStatus, required this.time });

}

class NotificationList {
  List<NotificationModel> statusList = [
    NotificationModel(
        shopName: 'Burger King', orderStatus: 'cancelled', time: '12:01 pm'),
    NotificationModel(
        shopName: 'Burger King', orderStatus: 'accepted ', time: '06:00 pm'),
    NotificationModel(shopName: 'Burger King', orderStatus: 'ready     ', time: '11:45 am')
  ];
}