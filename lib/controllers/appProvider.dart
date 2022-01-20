

import 'package:drivers_app/models/address.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation,dropOffLocation;

  void updatePickUpLocationAddress( Address pickUpAddress){
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress( Address dropOffAddress){
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}