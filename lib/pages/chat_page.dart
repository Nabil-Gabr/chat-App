import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:new_chat_app/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static String id='ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isLoding=false;
  final ScrollController _controller = ScrollController(); //animate to the end list
TextEditingController controlMessage=TextEditingController(); 

 //imageCamara:styp 1: value 
  File? fileCamara ;

  //getImageFormFirebaseStoage:styp 1
  String? urlImage;


  CollectionReference Message=FirebaseFirestore.instance.collection('messages');
  Future<void> addMessage(){
    return Message.add({
      'message':controlMessage.text ,
      'date': DateTime.now(),
      'senderId':FirebaseAuth.instance.currentUser!.uid,
      'id':urlImage
    }).then((value) => print("============================================message Added"))
      .catchError((error) => print("=====================================Failed to add message: $error"));
  }

  Future<void> addImage(){
    return Message.add({
      'message':controlMessage.text ,
      'date': DateTime.now(),
      'senderId':FirebaseAuth.instance.currentUser!.uid,
      'id':urlImage
    }).then((value) => print("============================================message Added"))
      .catchError((error) => print("=====================================Failed to add message: $error"));
  }
  

  

  final Stream<QuerySnapshot> readMessage=FirebaseFirestore.instance.collection('messages').orderBy('date',).snapshots();

  //Image.........................................................................................
  
 

  //imageCamara:styp 2 : getImageCamara
  getImageCamara() async{

    //imageCamara:styp 2: 1 (object of ImagePicer)
    final ImagePicker picker = ImagePicker();
    //imageCamara:styp 2: 2 (openCamara)
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    //imageCamara:styp 2: 3 (Store path in vale)
    if (photo !=null) {
      fileCamara=File(photo.path);

      //=========Upload images un firebase_storage============
      //styp 1
      var photoPath=basename(photo.path);
      //styp 2
      var erfPhoto=FirebaseStorage.instance.ref('imgaes/$photoPath');
      //styp 3
      await erfPhoto.putFile(fileCamara!);

      //getImageFormFirebaseStoage:styp 2
      urlImage=await erfPhoto.getDownloadURL();
    }
    //imageCamara:styp 2: 4 (setState)
    addImage();
   
    
    

  }

  //image.........................................................................
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade800,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chat App',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),)
          ],
        ),
        actions: [
          IconButton
          (onPressed: ()async{
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed(LoginPage.id);
          }, 
          icon: Icon(Icons.exit_to_app,color: Colors.white,))
        ],
      ),

      body: Column(
        children: [
          StreamBuilder(
            stream: readMessage, 
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {

              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }


              return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                
                controller: _controller,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                 
                    return   Align(
                    alignment: FirebaseAuth.instance.currentUser!.uid==snapshot.data!.docs[index]['senderId'] ? Alignment.centerRight : Alignment.centerLeft,
                    child:  Container(
                      height:snapshot.data!.docs[index]['id'] !=null ? 250 : null ,
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.only(top: 15,left: 10,bottom: 6,right: 15),
                      decoration:BoxDecoration(
                        color: (FirebaseAuth.instance.currentUser!.uid ==snapshot.data!.docs[index]['senderId'])?  Colors.blue.shade900 : Colors.grey.shade800,
                        borderRadius: 
                        snapshot.data!.docs[index]['id']!= null?
                        (FirebaseAuth.instance.currentUser!.uid==snapshot.data!.docs[index]['senderId'] ? BorderRadius.only(topLeft:Radius.circular(5),bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5),topRight: Radius.circular(5)) : BorderRadius.only(topRight:Radius.circular(5),bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5),topLeft: Radius.circular(5)))
                        : 
                        (FirebaseAuth.instance.currentUser!.uid==snapshot.data!.docs[index]['senderId'] ? BorderRadius.only(topLeft:Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(30)) : BorderRadius.only(topRight:Radius.circular(20),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(20)))
                      ),
                      child: snapshot.data!.docs[index]['id']!= null ?
                      Column(
                        crossAxisAlignment: FirebaseAuth.instance.currentUser!.uid == snapshot.data!.docs[index]['senderId'] ?  CrossAxisAlignment.start : CrossAxisAlignment.end ,
                        children: [
                          ModalProgressHUD(
                            inAsyncCall: isLoding,
                            child: Container(
                              width: 250,
                              height: 210,
                              child: CachedNetworkImage(imageUrl: snapshot.data!.docs[index]['id'],
                              placeholder:(context,url) { return const Center(child: CircularProgressIndicator(),);},imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider,fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn,))),),),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(DateFormat.jm().format(snapshot.data!.docs[index]['date'].toDate()),style: TextStyle(fontSize: 10,fontStyle: FontStyle.italic,color: Colors.white),)
                        ],
                      )
                      :
                      Column(
                        crossAxisAlignment: FirebaseAuth.instance.currentUser!.uid == snapshot.data!.docs[index]['senderId'] ?  CrossAxisAlignment.start : CrossAxisAlignment.end ,
                        children: [
                          Text('${snapshot.data!.docs[index]['message']}',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                          Text(DateFormat.jm().format(snapshot.data!.docs[index]['date'].toDate()),style: TextStyle(fontSize: 10,fontStyle: FontStyle.italic,color: Colors.white),)
                          
                        ],
                      ),
                    ),
                  );

                
              },),
            ),
          );
            },
          
          ),

          TextField(
            maxLines: null,
            controller:controlMessage ,
            decoration: InputDecoration(
              
                fillColor: Colors.white,
                filled: true,
                hintText: "Message",
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
                  onPressed: (){
                    if(controlMessage.text !=""){
                      addMessage();
                    }
                    controlMessage.clear();
                    _controller.animateTo(
                      _controller.position.maxScrollExtent,
                      duration: Duration(seconds: 1,),
                      curve: Curves.fastOutSlowIn,
  );
                  }, 
                  icon: Icon(Icons.send,color: Colors.blue.shade900,)),

                prefixIcon: IconButton(
                  onPressed: ()async {
                    
                    // setState(() {
                    //   isLoding=true;
                    // });
                  await  getImageCamara();
                  // setState(() {
                  //     isLoding=false;
                  //   });
                  _controller.animateTo(
                      _controller.position.maxScrollExtent,
                      duration: Duration(seconds: 2),
                      curve: Curves.fastOutSlowIn,
  );
                  
                  }, 
                  icon: Icon(Icons.camera_alt,color: Colors.blue.shade900,)),
            ),
          )
        ],
      ),
    );
  }
  
  basename(String path) {}
}
