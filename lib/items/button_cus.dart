import 'package:flutter/material.dart';

class ButtonCus extends StatelessWidget {
  final String titleBytton;
  final void Function() onTap;
   ButtonCus({super.key, required this.titleBytton, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue.shade800,
                  ),
                  child: Text(titleBytton,style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                ),
    );
  }
}