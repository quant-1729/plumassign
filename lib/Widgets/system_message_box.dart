import 'package:flutter/material.dart';
class SystemMessageBox extends StatelessWidget {
  String Message;
   SystemMessageBox({super.key, required this.Message});

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(

                decoration: BoxDecoration(
                  color: Color(0xFF969AA8),
                  borderRadius: BorderRadius.circular(58)
              ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                  child: Text(
                    Message, style: TextStyle(
                      fontSize: 12,
                      color: Colors.white
                  ),
                  ),
                ),
              )
            ],
          ),
        ),
      );


  }
}
