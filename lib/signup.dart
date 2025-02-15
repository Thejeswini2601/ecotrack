import 'package:ewaste/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();

  bool isloading=false;

  signup() async{
    setState(() {
      isloading=true;
    });
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
     Get.offAll((const Wrapper())); 
  }on FirebaseAuthException catch(e){
    Get.snackbar('Error', e.code);

  }catch(e){
    Get.snackbar('Error', e.toString());
  }  
  setState(() {
      isloading=false;
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return isloading?const Center(child: CircularProgressIndicator(),):Scaffold(
      appBar: AppBar(title: const Text("Sign Up"),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText:'Enter email'),
            ),
            TextField(
              controller: password,
              decoration: const InputDecoration(hintText:'Enter password'),
            ),
            ElevatedButton(onPressed: (()=>signup()), child: const Text("Sign Up"))
          ],
        ),
      ),

    );
  }
}