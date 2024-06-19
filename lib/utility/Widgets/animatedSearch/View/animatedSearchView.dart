import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/utility/Widgets/animatedSearch/ViewModel/searchViewModel.dart';

import '../../../Constants/color.dart';


class MySearchBar extends ConsumerStatefulWidget {
  final String hintext;

  const MySearchBar({
    super.key,

    required this.hintext

  });
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _MySearchBarState();
  }
}

class _MySearchBarState extends ConsumerState<MySearchBar> {
  bool showSearchField = false;
  late TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController(text: ref.read(searchTextProvider));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();

  } 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: showSearchField ? Colors.grey.withOpacity(0.07) : kWhite,
          borderRadius: BorderRadius.circular(showSearchField ? 19 : 360)),
      child: showSearchField ? searchField() : searchButton(),
    );
  }

  Widget searchField() {
    return Container(
        child: TextField(
          controller: _controller,
          onChanged: (value){
            ref.read(searchTextProvider.notifier).state = value.toLowerCase();
          },
      cursorHeight: 25,
      style: const TextStyle(fontWeight: FontWeight.w500, color: kGrey),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      cursorColor: kGrey,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        border: InputBorder.none,
        hintText: widget.hintext,
        hintStyle:  TextStyle(
          fontSize: 16,
          color: kGrey.withOpacity(0.37),
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: clearButton(),
      ),
    ));
  }

  Widget searchButton() {
    return IconButton(
      tooltip: '',
      icon: Container(
        child: const Icon(
          Icons.search,
          color: kGrey,
          size: 22,
        ),
      ),
      onPressed: () {
        if (mounted) {
          setState(() {
            showSearchField = true;
          });
        }
      },
    );
  }

  Widget clearButton() {
    return IconButton(
      tooltip: '',
      icon: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(360)),
        child: const Icon(
          Icons.search,
          color: kGrey,
          size: 21,
        ),
      ),
      onPressed: () {
        if (mounted) {
          setState(() {
            showSearchField = false;
          });
        }
      },
    );
  }
}


