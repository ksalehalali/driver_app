import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'models/user.dart';

String mapKey = "AIzaSyBSn3hFO_1ndRGrxuCZcnQ-LzhWet2Nq-s";

User firebaseUser ;

Users userCurrentInfo;

User currentFirebaseUser = FirebaseAuth.instance.currentUser;

StreamSubscription<Position> homeTabPageStreamSubscription;

void displayToastMSG(String msg , BuildContext context) {
  Fluttertoast.showToast(msg: msg);
}

final assetsAudioPlayer = AssetsAudioPlayer();
