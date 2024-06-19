import 'package:flutter/material.dart';
import '../../../../utility/Constants/color.dart';
import '../../../../utility/Widgets/animatedSearch/View/animatedSearchView.dart';
import '../Model/productModel.dart';

class Product_Screen extends StatefulWidget {
  const Product_Screen({super.key});

  @override
  State<Product_Screen> createState() => _Order_ScreenState();
}

class _Order_ScreenState extends State<Product_Screen> {
  OrderCategoryList orderCategory = OrderCategoryList();

  late List<OrderCategoryList> visibile;
  String groupValue = 'Dine In';

  @override
  void initState() {
    // TODO: implement initState
    // visibile = orderCategory.orderProductCategory.value;
    super.initState();
  }

  String dropdownValue = 'Small';
  @override
  Widget build(BuildContext context) {
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                                  child: ListView.builder(
                                      itemCount: orderCategory
                                          .orderProductCategory.keys.length,
                                      itemBuilder: (BuildContext, index) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {});
                                              },
                                              child: Text(
                                                orderCategory
                                                    .orderProductCategory.keys
                                                    .elementAt(index)
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: kBlue,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        );
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
            title: const MySearchBar(hintext: 'Since 1993'),
            centerTitle: true),
        body: Column(
          children: [
            Expanded(
              flex: 14,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: mqh * 1280 / 2340, top: mqh * 40 / 2340),
                        child: Container(
                          height: mqh * 625 / 2340,
                          width: mqw * 480 / 1080,
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
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: mqh * 350 / 2340,
                                width: mqw * 480 / 1080,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0)),
                                  child: Image.asset(
                                    'images/burger.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: mqh * 30 / 2340,
                                    left: mqw * 25 / 1080),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: mqw * 250 / 1080,
                                      child: const Text(
                                        'Burger',
                                        maxLines: 2,
                                        textDirection: TextDirection.ltr,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14.7,
                                            fontWeight: FontWeight.w500,
                                            color: kGrey),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: mqw * 55 / 1080,
                                          right: mqw * 55 / 1080),
                                      child: const Text('₹300',
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: kGrey,
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: mqh * 10 / 1080,
                                    bottom: mqh * 15 / 2340),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: mqw * 10 / 1080),
                                      child: DropdownButton<String>(
                                        value: dropdownValue,
                                        underline: Container(
                                          color: kWhite,
                                        ),
                                        style: const TextStyle(
                                            fontSize: 12.5,
                                            color: kGrey,
                                            fontWeight: FontWeight.w500),
                                        icon: const Icon(
                                          Icons.arrow_drop_down_sharp,
                                          color: kGrey,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        dropdownColor: kWhite,
                                        items: const [
                                          DropdownMenuItem<String>(
                                              value: 'Small',
                                              child: Text('Small')),
                                          DropdownMenuItem<String>(
                                              value: 'Medium',
                                              child: Text('Medium')),
                                          DropdownMenuItem<String>(
                                              value: 'Large',
                                              child: Text('Large'))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: mqw * 50 / 1080,
                                    ),
                                    Container(
                                      height: mqh * 70 / 2340,
                                      width: mqw * 140 / 1080,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7)),
                                          color: kBlue),
                                      child: const Center(
                                        child: Text(
                                          'add',
                                          style: TextStyle(
                                            color: kWhite,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: mqh * 1280 / 2340, top: mqh * 40 / 2340),
                        child: Container(
                          height: mqh * 625 / 2340,
                          width: mqw * 480 / 1080,
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
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: mqh * 350 / 2340,
                                width: mqw * 480 / 1080,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0)),
                                  child: Image.asset(
                                    'images/burger.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: mqh * 30 / 2340,
                                    left: mqw * 25 / 1080),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: mqw * 250 / 1080,
                                      child: const Text(
                                        'Burger',
                                        maxLines: 2,
                                        textDirection: TextDirection.ltr,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14.7,
                                            fontWeight: FontWeight.w500,
                                            color: kGrey),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: mqw * 55 / 1080,
                                          right: mqw * 55 / 1080),
                                      child: const Text('₹300',
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: kGrey,
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: mqh * 10 / 1080,
                                    bottom: mqh * 15 / 2340),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: mqw * 10 / 1080),
                                      child: DropdownButton<String>(
                                        value: dropdownValue,
                                        underline: Container(
                                          color: kWhite,
                                        ),
                                        style: const TextStyle(
                                            fontSize: 12.5,
                                            color: kGrey,
                                            fontWeight: FontWeight.w500),
                                        icon: const Icon(
                                          Icons.arrow_drop_down_sharp,
                                          color: kGrey,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        dropdownColor: kWhite,
                                        items: const [
                                          DropdownMenuItem<String>(
                                              value: 'Small',
                                              child: Text('Small')),
                                          DropdownMenuItem<String>(
                                              value: 'Medium',
                                              child: Text('Medium')),
                                          DropdownMenuItem<String>(
                                              value: 'Large',
                                              child: Text('Large'))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: mqw * 50 / 1080,
                                    ),
                                    Container(
                                      height: mqh * 70 / 2340,
                                      width: mqw * 140 / 1080,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7)),
                                          color: kBlue),
                                      child: const Center(
                                        child: Text(
                                          'add',
                                          style: TextStyle(
                                            color: kWhite,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
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
                                    const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text('Burger King',
                                          style: TextStyle(
                                              color: kBlue,
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.5)),
                                    ),
                                    Expanded(
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
                                                          value: dropdownValue,
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
                                                            setState(() {
                                                              dropdownValue =
                                                                  newValue!;
                                                            });
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
                                    ),
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
                                      padding:  EdgeInsets.only(top: mqh*30/2340, left: mqw*50/2340, right: mqw*35/1080),
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
                                      padding: EdgeInsets.only(top: mqh*65/2340,left: mqw*100/1080,bottom: mqh*15/2340),
                                      child: Row(

                                        children: [
                                          SizedBox(
                                            width: mqw * 400 / 1080,
                                            child:  Row(
                                              children: [
                                                const Text(
                                                  '₹9000',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 14,
                                                      color: kGrey),
                                                ),
                                                SizedBox(width: mqw*10/1080),
                                                const Icon(Icons.info_outline_rounded, color: kGrey,size: 16,)
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
