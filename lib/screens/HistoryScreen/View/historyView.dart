import 'package:flutter/material.dart';
import 'package:ofline_app/screens/HistoryScreen/View/historyItemsView.dart';
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
        body: historyStream.when(data: (histories) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: mqh * 30 / 2340),
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
                              child: Text(
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
                            history.isDineIn ? const Icon(
                              Icons.shopping_bag,
                              color: Colors.transparent,
                              size: 19,
                            ) : Icon(
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
                            HistotyItemsView(key: ObjectKey(index),history: history),
                       ],
                        onExpansionChanged: (bool expanding) {
                          setState(() {
                            _isExpanded = expanding ? index : null;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }, error: (error, stack) {
          return Center(child: Text('Error: $error'));
        }, loading: () {
          return const Center(child: CircularProgressIndicator(color: kBlue));
        }),
      ),
    );
  }
}
