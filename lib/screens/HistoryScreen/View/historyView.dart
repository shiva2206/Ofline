import 'package:flutter/material.dart';
import 'package:ofline_app/utility/Constants/string_extensions.dart';
import 'package:ofline_app/utility/Widgets/drawer/View/drawerView.dart';
import '../../../utility/Constants/color.dart';
import '../../../utility/Widgets/appBar/View/appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ViewModel/historyViewModel.dart';


class History_Screen extends ConsumerStatefulWidget {
  History_Screen({super.key, required this.customerId});
  final String customerId;


  @override
  ConsumerState<History_Screen> createState() => _History_ScreenState();
}

class _History_ScreenState extends ConsumerState<History_Screen> {
  int? _isExpanded;



  @override
  Widget build(BuildContext context) {
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    final historyStream = ref.watch(customerHistoryStreamProvider(widget.customerId));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const MyAppBar(
          title: Text('Pre-order',
              style: TextStyle(
                  color: kBlue, fontWeight: FontWeight.w700, fontSize: 18)),
        ),
        backgroundColor: kWhite,
        drawer: CustomDrawer(mqh: mqh, mqw: mqw,),
        body: historyStream.when(data: (histories){
          return  Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: mqh*30/2340),
                  child: ListView.builder(
                    itemCount: histories.length,
                    itemBuilder: (context, index) {
                      final history = histories[index];
                      print(history);
                      return ExpansionTile(
                        textColor: history.isReady ? kBlue : kGrey,
                        initiallyExpanded: _isExpanded == index,
                        iconColor:
                        history.isAccepted == true && history.isCancelled == false
                            ? kBlue
                            : history.isReady ==true && history.isAccepted == true && history.isCancelled == false
                            ? kBlue
                            : history.isCancelled? kRed: kGrey,
                        collapsedIconColor: history.isAccepted ==true && history.isCancelled == false
                            ? kBlue
                            : history.isReady ==true && history.isAccepted == true && history.isCancelled == false
                            ? kBlue
                            : history.isCancelled == true? kRed: kGrey,
                        tilePadding: EdgeInsets.only(
                            left: mqw * 60 / 1080, right: mqw * 60 / 1080),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: mqw * 320 / 1080,
                              child:  Text(
                                history.historyShopName.toTitleCase(),
                                style: TextStyle(
                                    color: history.isAccepted
                                        ? kBlue : history.isReady? kBlue
                                        : history.isCancelled
                                        ? kRed
                                        : history.isSuccessful? kBlue
                                        : kGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                            ),
                           history.isDineIn? const Icon( Icons.shopping_bag,

                             color: Colors.transparent,

                             size: 19, ) :  Icon(
                              Icons.shopping_bag,
                             color: history.isAccepted
                                 ? kBlue : history.isReady? kBlue
                                 : history.isCancelled
                                 ? kRed
                                 : history.isSuccessful? kBlue
                                 : kGrey,
                              size: 19,
                            ),
                            Text(
                              history.time,
                              style: TextStyle(
                                  color: history.isAccepted
                                      ? kBlue : history.isReady? kBlue
                                      : history.isCancelled
                                      ? kRed
                                      : history.isSuccessful? kBlue
                                      : kGrey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: mqh * 140 / 2340,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: kChipColor.withOpacity(0.35),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: mqw * 50 / 1080),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        width: mqw * 150 / 1080,
                                        child:  Center(
                                          child: Text(
                                            'Name',
                                            style: TextStyle(
                                                color: history.isAccepted
                                                    ? kBlue : history.isReady? kBlue
                                                    : history.isCancelled
                                                    ? kRed
                                                    : history.isSuccessful? kBlue
                                                    : kGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: mqw * 140 / 1080),
                                        child: Container(
                                          color: Colors.transparent,
                                          width: mqw * 130 / 1080,
                                          child:  Center(
                                            child: Text(
                                              'Qty',
                                              style: TextStyle(
                                                  color: history.isAccepted
                                                      ? kBlue : history.isReady? kBlue
                                                      : history.isCancelled
                                                      ? kRed
                                                      : history.isSuccessful? kBlue
                                                      : kGrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.transparent,
                                        width: mqw * 190 / 1080,
                                        child:  Center(
                                          child: Text(
                                            'Size',
                                            style: TextStyle(
                                                color: history.isAccepted
                                                    ? kBlue : history.isReady? kBlue
                                                    : history.isCancelled
                                                    ? kRed
                                                    : history.isSuccessful? kBlue
                                                    : kGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.transparent,
                                        width: mqw * 160 / 1080,
                                        child:  Center(
                                          child: Text(
                                            'Price',
                                            style: TextStyle(
                                                color: history.isAccepted
                                                    ? kBlue : history.isReady? kBlue
                                                    : history.isCancelled
                                                    ? kRed
                                                    : history.isSuccessful? kBlue
                                                    : kGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              ListView.builder(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: history.history_items.length,
                                  itemBuilder: (BuildContext context, index) {
                                    final his_item = history.history_items[index];
                                    return SizedBox(
                                      height: mqh * 150 / 2340,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: mqw * 50 / 1080,

                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              width: mqw * 290 / 1080,
                                              // height: mqh*200/2340,
                                              child: Center(
                                                child: Text(
                                                  his_item['history_product_name'],
                                                  style:  TextStyle(
                                                      color: history.isAccepted
                                                          ? kBlue : history.isReady? kBlue
                                                          : history.isCancelled
                                                          ? kRed
                                                          : history.isSuccessful? kBlue
                                                          : kGrey,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 14),
                                                  maxLines: 3,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              width: mqw * 130 / 1080,
                                              child: Center(
                                                child: Text(
                                                  his_item['history_product_qty'].toString(),
                                                  style: TextStyle(
                                                      color: history.isAccepted
                                                          ? kBlue : history.isReady? kBlue
                                                          : history.isCancelled
                                                          ? kRed
                                                          : history.isSuccessful? kBlue
                                                          : kGrey,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 14.5),
                                                  maxLines: 1,
                                                  textDirection:
                                                  TextDirection.ltr,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              width: mqw * 190 / 1080,
                                              child:  Center(
                                                child: Text(
                                                  his_item['history_product_size_variant'],
                                                  style:  TextStyle(
                                                      color: history.isAccepted
                                                          ? kBlue : history.isReady? kBlue
                                                          : history.isCancelled
                                                          ? kRed
                                                          : history.isSuccessful? kBlue
                                                          : kGrey,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 14.5),
                                                  maxLines: 2,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              width: mqw * 160 / 1080,
                                              child: Center(
                                                child: Text('₹${his_item['history_total_product_price']}',
                                                  style: TextStyle(
                                                      color: history.isAccepted
                                                          ? kBlue : history.isReady? kBlue
                                                          : history.isCancelled
                                                          ? kRed
                                                          : history.isSuccessful? kBlue
                                                          : kGrey,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 14.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              SizedBox(height: mqh * 40 / 2340),
                              Padding(
                                padding: EdgeInsets.only(left: mqw*468/1080),
                                child: Row(
                                  children: [
                                    Text( '₹${history.totalHistoryAmount}' ,
                                      textDirection: TextDirection.ltr,
                                      style:  TextStyle(
                                          color: history.isAccepted
                                              ? kBlue : history.isReady? kBlue
                                              : history.isCancelled
                                              ? kRed
                                              : history.isSuccessful? kBlue
                                              : kGrey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                     Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.info_outline_rounded,
                                          color: history.isAccepted
                                              ? kBlue : history.isReady? kBlue
                                              : history.isCancelled
                                              ? kRed
                                              : history.isSuccessful? kBlue
                                              : kGrey,
                                          size: 16),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: mqh * 40 / 2340),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: mqh * 50 / 2340,
                                    bottom: mqh * 25 / 2340,
                                    left: mqw * 130 / 1080,
                                    right: mqw * 130 / 1080),
                                child: Center(
                                  child: Stack(
                                    clipBehavior: Clip.hardEdge,
                                    children: [
                                      Positioned(
                                        bottom: mqh * 5 / 2340,
                                        top: mqh * 5 / 2340,
                                        child: Center(
                                          child: Container(
                                            width: mqw * 835 / 1080,
                                            height: mqh * 25 / 2340,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(100),
                                                color: kChipColor
                                                    .withOpacity(0.35)),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.radio_button_on,
                                              color: history.isAccepted
                                                  ? kBlue
                                                  : kGrey,
                                              size: 30),
                                          Icon(Icons.radio_button_on,
                                              color: history.isAccepted &
                                              history.isReady
                                                  ? kBlue
                                                  : kGrey,
                                              size: 30),
                                          Icon(Icons.radio_button_on,
                                              color: history.isAccepted &
                                              history.isReady &
                                              history.isSuccessful
                                                  ? kBlue
                                                  : kGrey,
                                              size: 30)
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: mqw * 70 / 1080),
                                    child: Text(
                                      'Accepted',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: history.isAccepted
                                              ? kBlue : history.isReady? kBlue
                                              : history.isSuccessful? kBlue
                                              : kGrey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: mqw * 30 / 1080,
                                        right: mqw * 55 / 1080),
                                    child: Text(
                                      'Ready',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: history.isAccepted == true
                                              && history.isReady == true? kBlue
                                              : kGrey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: mqw * 95 / 1080),
                                    child: Text(
                                      'Served',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: history.isAccepted == true
                                              && history.isReady == true
                                              && history.isSuccessful == true? kBlue: kGrey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),

                              SizedBox(height: mqh * 100 / 2340),

                              history.isCancelled ==true
                                  ? const Center(
                                  child: Text(
                                    'Cancelled',
                                    style: TextStyle(
                                        color: kRed,
                                        fontSize: 17,
                                        fontWeight:
                                        FontWeight.w600),
                                  ))
                                  : history.isSuccessful == true
                                  ? const Center(
                                  child: Text(
                                    'Served',
                                    style: TextStyle(
                                        color: kBlue,
                                        fontSize: 17,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ))
                                  : const Center(
                                  child: SizedBox(
                                    height: 1,
                                    width: 1,
                                  )),
                              SizedBox(height: mqh * 50 / 2340),
                              Padding(
                                padding:  EdgeInsets.only(left: mqw*700/1080),
                                child: Text('#${history.historyId.substring(0,12).toTitleCase()}', style: const TextStyle(color: kGrey, fontWeight: FontWeight.w400, fontSize: 14.5),),
                              )
                            ],
                          ),
                        ],
                        onExpansionChanged: (bool expanding) {
                          setState(() {
                            _isExpanded = index;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }, error: (error, stack){ return Center(child: Text('Error: $error')); }, loading: (){return const Center(child: CircularProgressIndicator(color: kBlue));})


      ),
    );
  }
}
