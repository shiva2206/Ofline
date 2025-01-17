import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/cart/Model/CartModel.dart';
import 'package:ofline_app/screens/ShopScreen/cart/View/CartView.dart';
import 'package:ofline_app/screens/ShopScreen/cart/View/CustomBottomSheet.dart';

import 'package:ofline_app/screens/ShopScreen/products/ViewModel/productViewModel.dart';
import 'package:ofline_app/utility/Widgets/animatedSearch/ViewModel/searchViewModel.dart';
import '../../../../utility/Constants/color.dart';
import '../../../../utility/Widgets/animatedSearch/View/animatedSearchView.dart';
import '../../shops/Model/shopModel.dart';
import '../Model/productModel.dart';
import 'package:ofline_app/utility/Constants/string_extensions.dart';

class Product_Screen extends ConsumerStatefulWidget {
  final ShopModel shop;
  final String startingYear;
  bool toCart;

  Product_Screen(
      {Key? key, required this.shop, required this.startingYear,required this.toCart})
      : super(key: key);

  @override
  ConsumerState<Product_Screen> createState() => _Product_ScreenState();
}

class _Product_ScreenState extends ConsumerState<Product_Screen> with WidgetsBindingObserver{
    String groupValue = 'Dine In';
  int count = -1;
  late Map<String, dynamic> sortedMap;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   OverlayEntry? _overlayEntry;

   void _showOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Custombottomsheet(
            
            shop: widget.shop,
            customerId: FirebaseAuth.instance.currentUser!.uid,
            overlayEntry: _overlayEntry,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void initState(){
    // TODO: implement initState
    // visibile = orderCategory.orderProductCategory.value;
    super.initState();
     WidgetsBinding.instance.addObserver(this);
    updateCount();
    

     if (widget.toCart) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => Custombottomsheet(
    //         shop: widget.shop,
    //         customerId: "z2hoSD4BzcNev0tSCmT3mQYnxPz2",
    //       ),
    //     ),
    //   ).then((_) {
    //     setState(() {
    //       widget.toCart = false; // Reset the flag when returning from the Custombottomsheet screen
    //     });
    //   });
    // });
      WidgetsBinding.instance.addPostFrameCallback((_) => _showOverlay(context));

    
  }
    



  }

  Timer? _debounceTimer;
   @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    print("---------------");
    print(state);
    print("---------------");

    DocumentReference shopRef = FirebaseFirestore.instance.collection('Shop').doc(widget.shop.id);

    if (state == AppLifecycleState.inactive) {
      await shopRef.update({
        'live_view': FieldValue.increment(count),
      });
      count = -1;
      print("minus 1");
    } else if (state == AppLifecycleState.resumed) {
      await shopRef.update({
        'live_view': FieldValue.increment(1),
      });
      print("plus 1");
    } else if (state == AppLifecycleState.hidden) {
      count = 0;
    }
    print("----------finished");
  }

  void updateCount() async {
    try {
      final DocumentReference shopRef = _firestore.collection('Shop').doc(widget.shop.id);

      await shopRef.update({'live_view': FieldValue.increment(1)});
      await shopRef.update({'views': FieldValue.increment(1)});

      print("Views count updated successfully");
    } catch (e) {
      print("Error updating Views count: $e");
      throw e; // or handle error appropriately
    }
  }

  Map<String, String?> dropdownValues = {};
  String filter = 'All';
  List<CartItem> cartValues = [];
  Map<String, bool> isAddedMap = {};

  void decreaseLiveCount() async {
    ref.read(searchTextProvider.notifier).state = "";
    final DocumentReference shopRef = _firestore.collection('Shop').doc(widget.shop.id);

    await shopRef.update({'live_view': FieldValue.increment(-1)});
  }

  Future<void> addToCart(ProductModel product) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final cartRef = _firestore.collection('Cart')
        .where('shop_id', isEqualTo: widget.shop.id)
        .where('customer_id', isEqualTo: userId);
    final cartSnapshot = await cartRef.get();

    int productPrice = product.sizeVariants[dropdownValues[product.product_name]];

    if (cartSnapshot.docs.isNotEmpty) {
      final existingCartDoc = cartSnapshot.docs.first.reference;
      final cartData = cartSnapshot.docs.first.data();

      List<dynamic> cartItems = cartData['cart_items'];
      bool productFound = false;
      for (var item in cartItems) {
        if (item['cart_product_name'] == product.product_name && item['cart_product_sizeVariant']==dropdownValues[product.product_name]) {
          item['cart_product_qty'] += 1;
          item['total_cart_product_price'] = item['cart_product_qty'] * productPrice;
          productFound = true;
          break;
        }
      }

      if (productFound) {
        await existingCartDoc.update({
          'cart_items': cartItems,
          'total_cart_item': FieldValue.increment(1),
          'total_amount': FieldValue.increment(productPrice),
        });
      } else {
        await existingCartDoc.update({
          'cart_items': FieldValue.arrayUnion([{
            'cart_product_name': product.product_name,
            'cart_product_price': productPrice,
            'cart_product_qty': 1,
            'cart_product_sizeVariant': dropdownValues[product.product_name],
            'total_cart_product_price': productPrice,
          }]),
          'total_cart_item': FieldValue.increment(1),
          'total_amount': FieldValue.increment(productPrice),
        });
      }
    } else {
      final newCartDoc = _firestore.collection('Cart').doc();
      await newCartDoc.set({
        'customer_id': userId,
        'shop_id': widget.shop.id,
        'cart_items': [{
          'cart_product_name': product.product_name,
          'cart_product_price': productPrice,
          'cart_product_qty': 1,
          'cart_product_sizeVariant': dropdownValues[product.product_name],
          'total_cart_product_price': productPrice,
        }],
        'total_amount': productPrice,
        'total_cart_item': 1,
        'cart_payment_image': ""
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final productListAsyncValue = ref.watch(productListProvider(widget.shop.id));
    Set<String> categorySet = {'All'};
    final user = FirebaseAuth.instance.currentUser?.uid;

    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    print(dropdownValues);
    
    return PopScope(
      onPopInvoked: (didPop) async {
        decreaseLiveCount();
        ref.read(searchTextProvider.notifier).state = "";
          if (_overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
          // return Future.value(false); // Prevents the default back button action
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kWhite,
        appBar: AppBar(
            backgroundColor: kWhite,
            bottomOpacity: 0,
            leading: Padding(
              padding: EdgeInsets.only(left: mqw * 85 / 1080),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: kGrey,
                  size: 21,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: mqw * 85 / 1080),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mqw * 140 / 1080),
                            child: AlertDialog(
                              shadowColor: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                              backgroundColor: kWhite,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17)),
                              title: const Center(
                                child: Text(
                                  'Menu',
                                  style: TextStyle(
                                      color: kGrey,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              content: Container(
                                  decoration: BoxDecoration(
                                      color: kWhite,
                                      borderRadius: BorderRadius.circular(18)),
                                  height: mqh * 800 / 2340,
                                  width: mqw * 10 / 1080,
                                  child: productListAsyncValue.when(data: (products) {
                                    for (var product in products) {
                                      if (!categorySet.contains(product.sub_category)) {
                                        categorySet.add(product.sub_category);
                                      }
                                    }
                                    return ListView.builder(
                                        itemCount: categorySet.length,
                                        itemBuilder: (BuildContext, index) {
                                          String category =
                                          categorySet.elementAt(index);
                                          return Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    filter = category;
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: Text(
                                                  category.toTitleCase(),
                                                  style: const TextStyle(
                                                      color: kBlue,
                                                      fontSize: 17,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }, error: (error, StackTrace) {
                                    return Center(child: Text('Error: $error'));
                                  }, loading: () {
                                    return const CircularProgressIndicator(
                                        color: Colors.transparent);
                                  })),
                            ),
                          );
                        });
                  },
                  child: const Icon(
                    Icons.category_outlined,
                    color: kGrey,
                    size: 20,
                  ),
                ),
              )
            ],
            elevation: 0,
            title: MySearchBar(hintext: 'Since ${widget.startingYear}'),
            centerTitle: true),
        body: Column(
          children: [
            Expanded(
                flex: 14,
                child: productListAsyncValue.when(data: (products) {
                  List<ProductModel> inStockProducts =
                  products.where((product) => filter == 'All' ? product.inStock : product.inStock && product.sub_category == filter).toList();
                  return Padding(
                    padding: EdgeInsets.only(top: mqh * 15 / 2340),
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14.0,
                        childAspectRatio: 0.815,
                      ),
                      itemCount: inStockProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final product = inStockProducts[index];

                        Map<String, dynamic> unsortedMap = product.sizeVariants;
                        List<MapEntry<String, dynamic>> sortedEntries = unsortedMap.entries.toList();
                        sortedEntries.sort((a, b) => a.value.compareTo(b.value));
                        sortedMap = Map.fromEntries(sortedEntries);
                        dropdownValues.putIfAbsent(
                            product.product_name, () => sortedMap.keys.first);

                        return Padding(
                          padding: const EdgeInsets.only(left: 7.0, right: 7.0),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0.5, 1.00),
                                  color: Color.fromRGBO(230, 230, 231, 0.3),
                                  blurRadius: 2.0,
                                ),
                                BoxShadow(
                                  offset: Offset(-1, 0.3),
                                  color: Color.fromRGBO(125, 125, 125, 0.15),
                                  blurRadius: 2.0,
                                ),
                              ],
                              color: kWhite,
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Column(
                              children: [
                                Stack(children: [
                                  SizedBox(
                                    height: mqh * 350 / 2340,
                                    width: mqw * 530 / 1080,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(18.0),
                                        topRight: Radius.circular(18.0),
                                      ),
                                      child: Image.network(
                                        product.product_image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  product.isVeg ?
                                  Positioned(
                                    right: mqw * 35 / 1080,
                                    top: mqh * 40 / 2340,
                                    child: Container(
                                      height: mqh * 53 / 2340,
                                      width: mqw * 50 / 1080,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.green, width: 1.5),
                                          color: kWhite, borderRadius: BorderRadius.circular(4)),
                                      child: const Center(
                                        child: CircleAvatar(backgroundColor: Colors.green, radius: 5),
                                      ),
                                    ),
                                  ) : const SizedBox(height: 2, width: 2),
                                ],),


                                Padding(
                                  padding: EdgeInsets.only(
                                    top: mqh * 30 / 2340,
                                    left: mqw * 25 / 1080,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: mqw * 250 / 1080,
                                        height: mqh * 115 / 2340,
                                        child: Text(
                                          product.product_name.toTitleCase(),
                                          maxLines: 2,
                                          textDirection: TextDirection.ltr,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14.7,
                                            fontWeight: FontWeight.w500,
                                            color: kGrey,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Container(
                                        width: mqw * 160 / 1080,
                                        height: mqh * 110 / 2340,
                                        child: Text(
                                          "₹${sortedMap[dropdownValues[product.product_name]]}",
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: kGrey,
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: mqh * 10 / 2340
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: mqw * 10 / 1080,
                                        ),
                                        child: sortedMap.keys.first !=
                                            "size"
                                            ? DropdownButton<String>(
                                          value: dropdownValues[product.product_name],
                                          underline: Container(
                                            color: kWhite,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            color: kGrey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          icon: const Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color: kGrey,
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownValues[product.product_name] = newValue;
                                            });
                                          },
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          dropdownColor: kWhite,
                                          items: [
                                            ...sortedMap.keys
                                                .map((String category) {
                                              return DropdownMenuItem<
                                                  String>(
                                                value: category,
                                                child: Text(category.toTitleCase()),
                                              );
                                            }).toList()
                                          ],
                                        )
                                            : const SizedBox(
                                            height: 48, width: 54),
                                      ),
                                      SizedBox(
                                        width: mqw * 50 / 1080,
                                      ),
                                      isAddedMap[product.product_name]==true ? Container(child: Icon(Icons.check, color: kBlue, size: 20), color: kWhite,) : Container(
                                        height: mqh * 70 / 2340,
                                        width: mqw * 140 / 1080,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(7),
                                          ),
                                          color: kBlue,
                                        ),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                isAddedMap[product.product_name] = true;
                                              });
                                              addToCart(product).then((_) {
                                                Future.delayed(const Duration(seconds: 5), () {
                                                  setState(() {
                                                    isAddedMap[product.product_name] = false;
                                                  });
                                                });
                                              });
                                            },
                                            child: const Text(
                                              'Add',
                                              style: TextStyle(
                                                color: kWhite,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }, error: (error, stackTrace) {
                  return Center(child: Text('Error: $error'));
                }, loading: () {
                  return const CircularProgressIndicator(
                      color: Colors.transparent);
                })),
            Expanded(
              flex: 1,
              child: Cartview(shop: widget.shop, customerId: user!, cart: cartValues,showOverlay: _showOverlay,),
            ),
          ],
        ),
      ),
    );
  }
}