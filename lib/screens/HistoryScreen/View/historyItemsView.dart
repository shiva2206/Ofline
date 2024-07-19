import 'package:flutter/material.dart';
import 'package:ofline_app/screens/HistoryScreen/Model/historyModel.dart';
import 'package:ofline_app/utility/Constants/string_extensions.dart';
import 'package:ofline_app/utility/Widgets/drawer/View/drawerView.dart';
import '../../../utility/Constants/color.dart';
import '../../../utility/Widgets/appBar/View/appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ViewModel/historyViewModel.dart';
class HistotyItemsView extends StatefulWidget {

  final History history;
  const HistotyItemsView({super.key,required this.history});

  @override
  State<HistotyItemsView> createState() => _HistotyItemsViewState();
}

class _HistotyItemsViewState extends State<HistotyItemsView> {
  bool _isLongPressed = false;
  @override
  Widget build(BuildContext context) {
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return    GestureDetector(
                            onLongPressStart: (_) {
                              print("long press -------------");
                              setState(() {
                                _isLongPressed = true;
                              });
                            },
                            onLongPressEnd: (_) {
                              setState(() {
                                _isLongPressed = false;
                              });
                            },
                            child: _isLongPressed
                                ? Image.network(
                                    "https://firebasestorage.googleapis.com/v0/b/ofline-80f07.appspot.com/o/paymentImage%2Fd6efabd7-8062-4fd1-a422-215ee20bb990?alt=media&token=0709de0f-2176-495c-9b19-b0b51f8e23d0",
                                    fit: BoxFit.cover,
                                  )
                                : Column(
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
                                                child: Center(
                                                  child: Text(
                                                    'Name',
                                                    style: TextStyle(
                                                        color: widget.history.isAccepted
                                                            ? kBlue
                                                            : widget.history.isReady
                                                                ? kBlue
                                                                : widget.history.isCancelled
                                                                    ? kRed
                                                                    : widget.history.isSuccessful
                                                                        ? kBlue
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
                                                  child: Center(
                                                    child: Text(
                                                      'Qty',
                                                      style: TextStyle(
                                                          color: widget.history.isAccepted
                                                              ? kBlue
                                                              : widget.history.isReady
                                                                  ? kBlue
                                                                  : widget.history.isCancelled
                                                                      ? kRed
                                                                      : widget.history.isSuccessful
                                                                          ? kBlue
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
                                                child: Center(
                                                  child: Text(
                                                    'Size',
                                                    style: TextStyle(
                                                        color: widget.history.isAccepted
                                                            ? kBlue
                                                            : widget.history.isReady
                                                                ? kBlue
                                                                : widget.history.isCancelled
                                                                    ? kRed
                                                                    : widget.history.isSuccessful
                                                                        ? kBlue
                                                                        : kGrey,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                color: Colors.transparent,
                                                width: mqw * 160 / 1080,
                                                child: Center(
                                                  child: Text(
                                                    'Price',
                                                    style: TextStyle(
                                                        color: widget.history.isAccepted
                                                            ? kBlue
                                                            : widget.history.isReady
                                                                ? kBlue
                                                                : widget.history.isCancelled
                                                                    ? kRed
                                                                    : widget.history.isSuccessful
                                                                        ? kBlue
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
                                          itemCount: widget.history.history_items.length,
                                          itemBuilder: (BuildContext context, index) {
                                            final his_item = widget.history.history_items[index];
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
                                                      child: Center(
                                                        child: Text(
                                                          his_item['history_product_name'],
                                                          style: TextStyle(
                                                              color: widget.history.isAccepted
                                                                  ? kBlue
                                                                  : widget.history.isReady
                                                                      ? kBlue
                                                                      : widget.history.isCancelled
                                                                          ? kRed
                                                                          : widget.history.isSuccessful
                                                                              ? kBlue
                                                                              : kGrey,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14),
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width: mqw * 130 / 1080,
                                                      child: Center(
                                                        child: Text(
                                                          his_item['history_product_qty']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: widget.history.isAccepted
                                                                  ? kBlue
                                                                  : widget.history.isReady
                                                                      ? kBlue
                                                                      : widget.history.isCancelled
                                                                          ? kRed
                                                                          : widget.history.isSuccessful
                                                                              ? kBlue
                                                                              : kGrey,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14.5),
                                                          maxLines: 1,
                                                          textDirection: TextDirection.ltr,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width: mqw * 190 / 1080,
                                                      child: Center(
                                                        child: Text(
                                                          his_item['history_product_size_variant'],
                                                          style: TextStyle(
                                                              color: widget.history.isAccepted
                                                                  ? kBlue
                                                                  : widget.history.isReady
                                                                      ? kBlue
                                                                      : widget.history.isCancelled
                                                                          ? kRed
                                                                          : widget.history.isSuccessful
                                                                              ? kBlue
                                                                              : kGrey,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14.5),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width: mqw * 160 / 1080,
                                                      child: Center(
                                                        child: Text(
                                                          '₹${his_item['history_total_product_price']}',
                                                          style: TextStyle(
                                                              color: widget.history.isAccepted
                                                                  ? kBlue
                                                                  : widget.history.isReady
                                                                      ? kBlue
                                                                      : widget.history.isCancelled
                                                                          ? kRed
                                                                          : widget.history.isSuccessful
                                                                              ? kBlue
                                                                              : kGrey,
                                                              fontWeight: FontWeight.w400,
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
                                        padding: EdgeInsets.only(left: mqw * 468 / 1080),
                                        child: Row(
                                          children: [
                                            Text(
                                              '₹${widget.history.totalHistoryAmount}',
                                              textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                  color: widget.history.isAccepted
                                                      ? kBlue
                                                      : widget.history.isReady
                                                          ? kBlue
                                                          : widget.history.isCancelled
                                                              ? kRed
                                                              : widget.history.isSuccessful
                                                                  ? kBlue
                                                                  : kGrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Icon(Icons.info_outline_rounded,
                                                  color: widget.history.isAccepted
                                                      ? kBlue
                                                      : widget.history.isReady
                                                          ? kBlue
                                                          : widget.history.isCancelled
                                                              ? kRed
                                                              : widget.history.isSuccessful
                                                                  ? kBlue
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
                                                      color: widget.history.isAccepted
                                                          ? kBlue
                                                          : kGrey,
                                                      size: 30),
                                                  Icon(Icons.radio_button_on,
                                                      color: widget.history.isAccepted &
                                                              widget.history.isReady
                                                          ? kBlue
                                                          : kGrey,
                                                      size: 30),
                                                  Icon(Icons.radio_button_on,
                                                      color: widget.history.isAccepted &
                                                              widget.history.isReady &
                                                              widget.history.isSuccessful
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
                                            padding: EdgeInsets.only(left: mqw * 70 / 1080),
                                            child: Text(
                                              'Accepted',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: widget.history.isAccepted
                                                      ? kBlue
                                                      : widget.history.isReady
                                                          ? kBlue
                                                          : widget.history.isSuccessful
                                                              ? kBlue
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
                                                  color: widget.history.isAccepted == true &&
                                                          widget.history.isReady == true
                                                      ? kBlue
                                                      : kGrey,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: mqw * 95 / 1080),
                                            child: Text(
                                              'Served',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: widget.history.isAccepted == true &&
                                                          widget.history.isReady == true &&
                                                          widget.history.isSuccessful == true
                                                      ? kBlue
                                                      : kGrey,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: mqh * 100 / 2340),
                                      widget.history.isCancelled == true
                                          ? const Center(
                                              child: Text(
                                                'Cancelled',
                                                style: TextStyle(
                                                    color: kRed,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            )
                                          : widget.history.isSuccessful == true
                                              ? const Center(
                                                  child: Text(
                                                    'Served',
                                                    style: TextStyle(
                                                        color: kBlue,
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                )
                                              : const Center(
                                                  child: SizedBox(
                                                    height: 1,
                                                    width: 1,
                                                  )),
                                      SizedBox(height: mqh * 50 / 2340),
                                      Padding(
                                        padding: EdgeInsets.only(left: mqw * 700 / 1080),
                                        child: Text(
                                          '#${widget.history.historyId.substring(0, 12).toTitleCase()}',
                                          style: const TextStyle(
                                              color: kGrey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.5),
                                        ),
                                      ),
                                    ],
                                  ),
                          );
                      
  }
}