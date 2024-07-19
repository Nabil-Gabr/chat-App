import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart';



class ImageMessage extends StatefulWidget {
   ImageMessage({super.key});

  static String id='ImageMessage';

  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  bool isLodingImage=false;


  //imageCamara:styp 1: value 
  File? fileCamara ;

  //getImageFormFirebaseStoage:styp 1
  String? urlImage;

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
      setState(() {
        isLodingImage=true;
      });
      await erfPhoto.putFile(fileCamara!);
      setState(() {
        isLodingImage=false;
      });

      //getImageFormFirebaseStoage:styp 2
      urlImage=await erfPhoto.getDownloadURL();
    }
    //imageCamara:styp 2: 4 (setState)
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getImageCamara();
        },
        child: Icon(Icons.camera_alt),),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          
          children: [
            if(fileCamara !=null)
            Container(
              width: 250,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                border: Border.all(width: 5,color: Colors.blue.shade900)
                
              ),
            
              child: ModalProgressHUD(
                inAsyncCall: isLodingImage,
                child: Image.file(fileCamara!,fit: BoxFit.cover,)),
            ),
      
            
      
            
          ],
        ),
      ),
    );
  }
}








// isLoding==true ?Center(child: CircularProgressIndicator(),) : Image.file(fileCamara!,fit: BoxFit.fill,),







// snapshot.data!.docs[index]['id']