
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers_app/config-maps.dart';
import 'package:drivers_app/main.dart';
import 'package:drivers_app/models/rideDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'notification_dialog.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging  = FirebaseMessaging.instance;

  Future initialize(context)async{
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage =message.data['route'];
      Navigator.pushNamed(context, routeFromMessage);
      print('  ====== route $routeFromMessage');
    });


  }

  Future<String> getToken()async{
    String token = await firebaseMessaging.getToken();

    driverRef.child(currentFirebaseUser.uid).child("token").set(token);
    print("this is token : ${token}");
    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");

  }

  String getRideRequestId(Map<String , dynamic> message){
    String rideRequestId = "" ;
    if(Platform.isAndroid){
       rideRequestId = message['ride_request_id'];
       print(rideRequestId);

    }else{
       rideRequestId = message['ride_request_id'];

    }
    return rideRequestId;
  }

  void retrieveRideRequestInfo(String rideRequestId, BuildContext context){
    newRequestsRef.child(rideRequestId).once().then((DataSnapshot dataSnapshot){
     if(dataSnapshot.value !=null){
       assetsAudioPlayer.open(Audio("assets/sounds/41497953_bird-singing-01.mp3"));
       assetsAudioPlayer.play();


       double pickUpLocLat = double.parse(dataSnapshot.value["pickup"]["latitude"].toString());
       double pickUpLocLng = double.parse(dataSnapshot.value["pickup"]["longitude"].toString());
       String pickUpAddress= dataSnapshot.value["pickUp_address"].toString();

       double dropOffLocLat = double.parse(dataSnapshot.value["dropoff"]["latitude"].toString());
       double dropOffLocLng = double.parse(dataSnapshot.value["dropoff"]["longitude"].toString());
       String dropOffAddress= dataSnapshot.value["dropoff_address"].toString();

       String paymentMethod= dataSnapshot.value["payment_method"].toString();

       RideDetails rideDetails = RideDetails();
       rideDetails.ride_request_id =rideRequestId;
       rideDetails.pickUp_address = pickUpAddress;
       rideDetails.dropoff_address = dropOffAddress;
       rideDetails.pickup = LatLng(pickUpLocLat, pickUpLocLng);
       rideDetails.dropoff = LatLng(dropOffLocLat, dropOffLocLng);
       rideDetails.payment_method = paymentMethod;

       print("info  :: ${pickUpAddress}");

       print("info  :: ${dropOffAddress}");

       Get.defaultDialog(content:NotificationDialog(rideDetails: rideDetails,) );
     }
    });
  }

}