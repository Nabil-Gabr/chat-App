import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController myController;
  final String hinttext;
   TextFieldCustom({ required this.myController, required this.hinttext, });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
              validator: (data) {
                if (data!.isEmpty) {
                  return 'field is required';
                }
                
              },
              controller: myController ,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: hinttext,
                hintStyle: TextStyle(color: Colors.black,),
        
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
        
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue,width: 3),
                  borderRadius: BorderRadius.circular(15),
                )
              ),
        
              
            );
  }
}