import 'package:flutter/cupertino.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/models/widget_meta.dart';

class QuestionOption extends StatefulWidget implements TeXViewWidget {
  final bool? isSelected;
  const QuestionOption({super.key, required this.isSelected});

  @override
  State<QuestionOption> createState() => _QuestionOptionState();

  @override
  TeXViewWidgetMeta meta() {
    // TODO: implement meta
    throw UnimplementedError();
  }

  @override
  void onTapCallback(String id) {
    // TODO: implement onTapCallback
  }

  @override
  Map toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

class _QuestionOptionState extends State<QuestionOption> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
