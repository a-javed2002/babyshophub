import 'dart:io';

import 'package:babyshophub/consts/firestore_consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class profileController{
  var profileImgPath='';

  var nameController=TextEditingController();
  var newPassController=TextEditingController();
  var oldPassController=TextEditingController();

  var profileImgLink='';
  var isLoading=false;

  changeImg(context)async{
    try{
      final img=await ImagePicker().pickImage(source:ImageSource.gallery,imageQuality:70);
      if(img==null) return;
      profileImgPath=img.path;
    } on PlatformException catch(e){
      // VxToast.show(context,msg:e.toString());
    }
  }

  uploadProfileImage()async{
    var filename=basename(profileImgPath);
    var destination='images/${currentUser!.uid}/$filename';
    Reference ref=FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath));
    profileImgLink=await ref.getDownloadURL();
  }

  updateProfile({name,password,imgUrl})async{
    var store=firestore.collection(userCollection).doc(currentUser!.uid);
    await store.set({'name':name,'password':password,'imageUrl':imgUrl},SetOptions(merge:true));
    isLoading;
  }

  changeAuthPassword({email,password,newPassword})async{
    final cred=EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value){
      currentUser!.updatePassword(newPassword);
    }).catchError((error){
      print(error.toString());
    });
  }
}