

import 'package:drivers_app/Assistants/assistantMethods.dart';
import 'package:drivers_app/View/AllScreens/mainscreen.dart';
import 'package:drivers_app/config-maps.dart';
import 'package:drivers_app/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CarInfoScreen extends StatelessWidget {
  static const String idScreen = "car-info";
   CarInfoScreen({Key key}) : super(key: key);

  TextEditingController carModelController = TextEditingController();
  TextEditingController carColorController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AssistantMethods.getCurrentOnLineUserInfo();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 22.0,),
              Image.asset("assets/images/taxi.png",width: 390.0,height: 250.0,),
              Padding(padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0,32.0),child: Column(
                children: [
                  SizedBox(
                    height: 12.0,
                  ),
                  Text("Enter Car Details",style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),

                  SizedBox(height: 26.0,),
                  TextField(
                    controller: carModelController,
                    decoration: InputDecoration(
                      labelText: "Car Model",
                      hintStyle: TextStyle(color: Colors.grey[400],fontSize: 10.0)
                    ),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0,),
                  TextField(
                    controller: carNumberController,
                    decoration: InputDecoration(
                        labelText: "Car Number",
                        hintStyle: TextStyle(color: Colors.grey[400],fontSize: 10.0)
                    ),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0,),
                  TextField(
                    controller: carColorController,
                    decoration: InputDecoration(
                        labelText: "Car Color",
                        hintStyle: TextStyle(color: Colors.grey[400],fontSize: 10.0)
                    ),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 44.0,),

                  InkWell(
                    onTap: (){
                      if(carModelController.text.isEmpty){
                        displayToastMSG("please write car model",context);
                      }else if(carNumberController.text.isEmpty){
                        displayToastMSG("please write car number",context);
                      }else if(carColorController.text.isEmpty){
                        displayToastMSG("please write car color",context);
                      }else{
                        saveDriverCarInfo(context);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "NEXT",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 26.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }

  void saveDriverCarInfo(context)async{
    String userId = currentFirebaseUser.uid;

    Map carInfoMap = {
      "car_color":carColorController.text,
      "car_number":carNumberController.text,
      "car_model":carModelController.text,

    };

    driverRef.child(userId).child("car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

  }
  void displayToastMSG(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg);
  }
}
