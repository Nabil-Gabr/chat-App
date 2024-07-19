import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_chat_app/pages/chat_page.dart';
import 'package:new_chat_app/pages/image_mass.dart';
import 'package:new_chat_app/pages/login_page.dart';
import 'package:new_chat_app/pages/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('==============================User is currently signed out!');
    } else {
      print('==============================User is signed in!');
    }
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoginPage.id:(context) => LoginPage(),
        RegisterPage.id:(context) => RegisterPage(),
        ChatPage.id:(context) => ChatPage(),
        ImageMessage.id:(context) => ImageMessage(),
      },
      initialRoute: FirebaseAuth.instance.currentUser !=null ?ChatPage.id :LoginPage.id,
      // FirebaseAuth.instance.currentUser !=null ?ChatPage.id :LoginPage.id,
      // home: LoginPage(),
    );
  }
}














// showDialog(
//                               context: context, 
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   backgroundColor: Colors.grey.shade900,
//                                   icon: Icon(Icons.info,color :Colors.grey,size: 40,),
//                                   title: Text("ِAre you suer you want to delete",style: TextStyle(color: Colors.white),),
//                                   content: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       ElevatedButton(
//                                         style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                                         onPressed: ()async{
//                                           //
//                                           // await FirebaseFirestore.instance.collection("notess").doc(snapshot.data!.docs[index].id).delete();
//                                           // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(),));
//                                         }, 
//                                         child: SizedBox(
//                                           width: 80,
//                                           child: Text("Yes",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
//                                         ) ,
//                                       ),
                  
//                                       ElevatedButton(
//                                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                                         onPressed: (){
//                                           // Navigator.pop(context,false);
//                                         }, 
//                                         child: SizedBox(
//                                           width: 80,
//                                           child: Text("No",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
//                                         ) ,
//                                       ),
//                                     ],
//                                   ),
                                  
//                                 );
                                
//                               },
//                             )