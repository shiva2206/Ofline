import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/products/Model/CartModel.dart';
import 'package:ofline_app/screens/ShopScreen/products/ViewModel/CartViewModel.dart';
import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';
import 'package:ofline_app/utility/Constants/string_extensions.dart';
import '../../../../utility/Constants/color.dart';

class Cartview extends ConsumerStatefulWidget {
  final ShopModel shop;
  final String customerId;
  const Cartview({super.key, required this.shop, required this.customerId});

  @override
  ConsumerState<Cartview> createState() => _CartviewState();
}

class _CartviewState extends ConsumerState<Cartview> {
  String groupValue = 'Dine In';
  @override
  Widget build(BuildContext context) {
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    final cartItems = ref.watch(cartStreamProvider(Tuple2(item1: widget.shop, item2: widget.customerId)));

    return Container(
      width: double.infinity,
      height: mqh * 140 / 2340,
      decoration: const BoxDecoration(
        color: kWhite,
        boxShadow: [
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
      ),
      child: Padding(
          padding: EdgeInsets.only(
              left: mqw * 230 / 1080,
              top: mqh * 30 / 2340,
              right: mqw * 250 / 1080),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      width: double.infinity,
                      height: mqh * 1800 / 2340,
                      decoration: const BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                widget.shop.shop_name.toTitleCase(),
                                style: const TextStyle(
                                    color: kBlue,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5)),
                          ),
                          cartItems.when(data: (cartitem) {

                            return Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: 3,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: mqh * 20 / 2340,
                                          bottom: mqh * 35 / 2340,
                                          right: mqw * 40 / 1080,
                                          left: mqw * 40 / 1080),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          const BorderRadius.all(
                                              Radius.circular(10)),
                                          color: kChipColor
                                              .withOpacity(0.35),
                                        ),
                                        height: mqh * 200 / 2340,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                              mqw * 5 / 1080),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                EdgeInsets.only(
                                                    left: mqw *
                                                        40 /
                                                        1080,
                                                    top: mqh *
                                                        40 /
                                                        2340),
                                                child: const Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      'Burger',
                                                      maxLines: 2,
                                                      textDirection:
                                                      TextDirection
                                                          .ltr,
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          fontSize:
                                                          14.7,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                          color: kGrey),
                                                      textAlign:
                                                      TextAlign
                                                          .left,
                                                    ),
                                                    Text('₹300',
                                                        textDirection:
                                                        TextDirection
                                                            .ltr,
                                                        textAlign:
                                                        TextAlign
                                                            .left,
                                                        style: TextStyle(
                                                            color:
                                                            kGrey,
                                                            fontSize:
                                                            13.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500))
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(
                                                    left: mqw *
                                                        10 /
                                                        1080),
                                                child: DropdownButton<
                                                    String>(
                                                  value: "Small",
                                                  underline: Container(
                                                    color: kWhite,
                                                  ),
                                                  style: const TextStyle(
                                                      fontSize: 12.5,
                                                      color: kGrey,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
                                                  icon: const Icon(
                                                    Icons
                                                        .arrow_drop_down_sharp,
                                                    color: kGrey,
                                                  ),
                                                  onChanged: (String?
                                                  newValue) {
                                                    // setState(() {
                                                    //   dropdownValue =
                                                    //       newValue!;
                                                    // });
                                                  },
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(10),
                                                  dropdownColor: kWhite,
                                                  items: const [
                                                    DropdownMenuItem<
                                                        String>(
                                                        value: 'Small',
                                                        child: Text(
                                                            'Small')),
                                                    DropdownMenuItem<
                                                        String>(
                                                        value: 'Medium',
                                                        child: Text(
                                                            'Medium')),
                                                    DropdownMenuItem<
                                                        String>(
                                                        value: 'Large',
                                                        child: Text(
                                                            'Large'))
                                                  ],
                                                ),
                                              ),
                                              const Text('₹3000',
                                                  textDirection:
                                                  TextDirection.ltr,
                                                  textAlign:
                                                  TextAlign.left,
                                                  style: TextStyle(
                                                      color: kGrey,
                                                      fontSize: 13.5,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500)),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(
                                                    right: mqw *
                                                        35 /
                                                        1080),
                                                child: Container(
                                                  height:
                                                  mqh * 80 / 2340,
                                                  width:
                                                  mqw * 205 / 1080,
                                                  decoration: const BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .all(Radius
                                                          .circular(
                                                          7)),
                                                      color: kBlue),
                                                  child: Padding(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        mqw *
                                                            20 /
                                                            1080),
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Icon(
                                                          Icons.remove,
                                                          color: kWhite,
                                                          size: 19.5,
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            '10',
                                                            style:
                                                            TextStyle(
                                                              color:
                                                              kWhite,
                                                              fontSize:
                                                              13.5,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.add,
                                                          color: kWhite,
                                                          size: 19.5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          }, error: (error, StackTrace) {
                            return Text("Error : $error");
                          }, loading: () {
                            return CircularProgressIndicator(color: kBlue,);
                          }),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mqw * 70 / 1080),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: mqw * 300 / 1080,
                                  child: Row(
                                    children: [
                                      Radio(
                                          activeColor: kBlue,
                                          value: 'Dine In',
                                          groupValue: groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              groupValue = value!;
                                            });
                                          }),
                                      const Text(
                                        'Dine In',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w600,
                                            fontSize: 15,
                                            color: kBlue),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: mqw * 400 / 1080,
                                  child: Row(
                                    children: [
                                      Radio(
                                          activeColor: kGrey,
                                          value: 'Takeaway',
                                          groupValue: groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              groupValue = value!;
                                            });
                                          }),
                                      const Text(
                                        'Takeaway',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w500,
                                            fontSize: 15,
                                            color: kGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: mqh * 30 / 2340,
                                left: mqw * 50 / 2340,
                                right: mqw * 35 / 1080),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'UPI',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: kGrey.withOpacity(0.25)),
                                ),
                                Text(
                                  'Shine Jaiswal',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: kGrey.withOpacity(0.25)),
                                ),
                                Icon(
                                  Icons.content_copy,
                                  size: 16,
                                  color: kGrey.withOpacity(0.40),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: mqh * 65 / 2340,
                                left: mqw * 100 / 1080,
                                bottom: mqh * 15 / 2340),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: mqw * 400 / 1080,
                                  child: Row(
                                    children: [
                                      const Text(
                                        '₹9000',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w500,
                                            fontSize: 14,
                                            color: kGrey),
                                      ),
                                      SizedBox(
                                          width: mqw * 10 / 1080),
                                      const Icon(
                                        Icons.info_outline_rounded,
                                        color: kGrey,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: mqw * 210 / 1080,
                                ),
                                Container(
                                  height: mqh * 100 / 2340,
                                  width: mqw * 275 / 1080,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)),
                                      color: kBlue),
                                  child: const Center(
                                    child: Text(
                                      'Pre-order',
                                      style: TextStyle(
                                        color: kWhite,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Container(
              height: mqh * 0.049,
              width: mqw * 400 / 1080,
              decoration: const BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.5)),
                  color: kBlue),
              child: Padding(
                padding: EdgeInsets.all(mqw * 10 / 1080),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: mqw * 55 / 1080, right: 20 / 1080),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          '100 Items',
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                            width: mqw * 100 / 1080,
                            child: const Center(
                              child: Icon(
                                Icons.shopping_cart,
                                color: kWhite,
                                size: 20,
                              ),
                            )),
                        const Text(
                          '₹10000',
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
