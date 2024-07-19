import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:new_chat_app/items/button_cus.dart';
import 'package:new_chat_app/items/textflied_cus.dart';
import 'package:new_chat_app/pages/chat_page.dart';


class RegisterPage extends StatefulWidget {

   RegisterPage({super.key});

   static String id='RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController email=TextEditingController();

  final TextEditingController password=TextEditingController();

  GlobalKey<FormState> formKey=GlobalKey();

  bool isLoding=false;

  // define value
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoding,
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key:formKey ,
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(130),
                    child: Image.asset("assets/logochat.jpeg",width: 130,height: 130,),
                  ),
                  SizedBox(height: 10,),
                  Text("Chat App",style: TextStyle(fontSize: 40,color: Colors.blue.shade800,fontWeight: FontWeight.bold),),
                  SizedBox(height: 80,),
                  Row(
                    children: [
                      Text("SING UP",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  TextFieldCustom(myController: email, hinttext: "Email"),
                  SizedBox(height: 20,),
                  TextFormField(
                    obscureText: _isObscure,
                    validator: (data) {
                      if (data!.isEmpty) {
                        return 'field is required';
                        }
                      },
                    controller: password ,
                    decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.black,),
        
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
        
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue,width: 3),
                  borderRadius: BorderRadius.circular(15),
                ),


                suffixIcon: IconButton(
                  onPressed:() {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: _isObscure ? const Icon(
                    Icons.visibility_off,
                    color: Colors.grey,)
                    : const Icon(
                      Icons.visibility,
                      color: Colors.black,
                    ),
                    color: Colors.blue.shade900,
                  )),
              


        
              
            ),
                  SizedBox(height: 40,),
                  ButtonCus(titleBytton: 'Sig up', onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoding=true;
                      });
                      
                      try {
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      Navigator.of(context).pushReplacementNamed(ChatPage.id);
                      print("===========================craete new user");
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
      
                        showDialog(
                                context: context, 
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey.shade900,
                                    icon: Icon(Icons.info,color :Colors.grey,size: 40,),
                                    title: Text("The password provided is too weak.",style: TextStyle(color: Colors.white),),
                                  );
                                  
                                },
                              );
                        
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
      
                          showDialog(
                                context: context, 
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey.shade900,
                                    icon: Icon(Icons.info,color :Colors.grey,size: 40,),
                                    title: Text("The account already exists for that email.",style: TextStyle(color: Colors.white),),
                                  );
                                  
                                },
                              );
                          }
                      } catch (e) {
                        print(e);
                        }

                        setState(() {
                        isLoding=false;
                      });
                   
                      
                    }
                    },),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("already have an account?",style: TextStyle(color: Colors.white,fontSize: 18),),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);  
                        },
                        child: Text("Login",style: TextStyle(color: Colors.blue.shade800,fontSize: 18,fontWeight: FontWeight.bold),)),
              
                    ],
                  )
                  
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}