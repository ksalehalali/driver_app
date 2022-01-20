import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:drivers_app/Assistants/assistantMethods.dart';
import 'package:drivers_app/config-maps.dart';
import 'package:drivers_app/main.dart';
import 'package:drivers_app/notifications/push_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget {
   HomeTabPage({Key key}) : super(key: key);


  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerMaps = Completer();

  GoogleMapController newGoogleMapController;

   Position currentPosition;
  Position currentPosition2;

   Geolocator geoLocator = Geolocator();

   String driverStatusText = "Offline now , go Online";

   Color driverStatusColor = Colors.black;
  Color driverStatusColorText = Colors.red;

   bool isDriverAvailable = false;

   final CameraPosition _kGooglePlex = CameraPosition(
     target: LatLng(37.42796133580664, -122.085749655962),
     zoom: 14.4746,
   );

   void locatePosition() async {
     Position position = await Geolocator.getCurrentPosition(
         desiredAccuracy: LocationAccuracy.high);
     currentPosition = position;
     currentPosition2 = currentPosition;
     print(currentPosition2.longitude);

     LatLng latLngPosition = LatLng(position.latitude, position.longitude);

     CameraPosition cameraPosition =
     new CameraPosition(target: latLngPosition, zoom: 15);

     newGoogleMapController
         .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
     var assistantMethods = AssistantMethods();

     // String address =
     // await assistantMethods.searchCoordinateAddress(position, context);
     // print(address);

   }



   void currentDriverInfo()async{
     currentFirebaseUser = await FirebaseAuth.instance.currentUser;
     PushNotificationService pushNotificationService = PushNotificationService();

     pushNotificationService.initialize(context);
     pushNotificationService.getToken();

   }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentDriverInfo();

  }
  @override

  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          //polylines: polyLineSet,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          //markers: markersSet,
          //circles: circlesSet,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerMaps.complete(controller);
            newGoogleMapController = controller;
            // setState(() {
            //   bottomPaddingOfMap = 320.0;
            // });
             locatePosition();
          },
        ),

        //online off line driver container
        Container(
          height: 140,
          width: double.infinity,
          color: driverStatusColor,
        ),

        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  onPressed: (){
                  if(isDriverAvailable != true){
                    makeDriverOnlineNow() ;
                    getLocationLiveUpdates();

                    setState(() {
                      driverStatusColor = Colors.green;
                      driverStatusText = "Online Now";
                      isDriverAvailable = true;
                      driverStatusColorText =Colors.green;
                    });
                    displayToastMSG("You are Online Now", context);
                  }else{
                    setState(() {
                      driverStatusColor = Colors.black54;
                      driverStatusText = "Offline Now - Go Online";
                      isDriverAvailable = false;
                      driverStatusColorText =Colors.red;

                    });
                    makeDriverOffLineNow();
                  }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(driverStatusColorText)
                  ),
                  icon:
                  Icon(
                    Icons.phone_android,
                    color: Colors.white,
                    size: 26.0,
                  ),label: Text(driverStatusText),),
              ),
            ],
          ),
        )
      ],
    );
  }

  void makeDriverOnlineNow()async{

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

      locatePosition();
      //print(currentPosition2.longitude);
     Geofire.initialize("availableDrivers");

     Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

     rideRequestRef.onValue.listen((event) {

     });
  }

  void getLocationLiveUpdates(){

     homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
       currentPosition = position;

       if(isDriverAvailable ==true){
         Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);

       }
       LatLng latLng = LatLng(position.latitude,position.longitude);
       newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
     });

  }

  void makeDriverOffLineNow(){
    Geofire.removeLocation(currentFirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef = null;
    displayToastMSG("You are Offline Now", context);
  }
}