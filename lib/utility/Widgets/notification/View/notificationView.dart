import 'package:flutter/material.dart';

import '../../../Constants/color.dart';
import '../Model/notificationModel.dart';

class Notification_Page extends StatefulWidget {
  const Notification_Page({super.key});

  @override
  State<Notification_Page> createState() => _Notification_PageState();
}

class _Notification_PageState extends State<Notification_Page> {

  NotificationList status = NotificationList();

  @override
  Widget build(BuildContext context) {
    var mqh = MediaQuery.of(context).size.height;
    var mqw = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            elevation: 0,
            title: const Text('Notification',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 18, color: kBlue)),
            centerTitle: true),
        body: Column(

          children: [
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: mqw * 35 / 1080,
                    right: mqw * 35 / 1080,
                    top: mqh * 30 / 2340,
                  ),
                  itemCount: status.statusList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: mqw * 1000 / 1080,
                          height: mqh * 160 / 2340,
                          decoration: BoxDecoration(
                              color: kChipColor.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(9)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  [
                                SizedBox(
                                  width: mqw*280/1080,
                                  child: Text( status.statusList[index].shopName.toString(),
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: kGrey,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ),
                                Text(status.statusList[index].orderStatus.toString().toLowerCase(),
                                    style: const TextStyle(
                                        color: kGrey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  status.statusList[index].time.toString().toLowerCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: kGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),

                                // const Icon(Icons.delete, color: kGrey, size: 17)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: mqh * 60 / 2340)
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
