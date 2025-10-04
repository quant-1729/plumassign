import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';

class PrimaryAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget> iconButtons;
  final String? title;
  final bool showBackButton;

  const PrimaryAppBar({
    Key? key,
    required this.iconButtons,
    this.title,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  State<PrimaryAppBar> createState() => _PrimaryAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}

class _PrimaryAppBarState extends State<PrimaryAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: AppBar(
          title: widget.title != null ? Text(widget.title!,style: TextStyle(fontSize: AppTextsizes.large_text)) : null,
          actions: [
            for (var button in widget.iconButtons)
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: button,
              )
          ],
        ),
      ),
    );
  }
}
