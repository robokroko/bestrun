import 'package:flutter/material.dart';
import 'package:bestrun/models/profile_model.dart';

class MessageEventType {
  static const none = 0;
  static const user = 1;
  static const system = 2;
}

const Color primaryColor = Colors.black;
const Color readMessageTextColor = Color(0xFF919191);
const Color unreadMessageGreyTextColor = Color(0xFFAEAEAE);
const Color unreadMessageWhiteTextColor = Colors.white;
const Color messageImageBackgroundColor = Color(0xFF121212);
const Color messageTextBackgroundColor = Color(0xFF1C1C1C);
const Color messageBottomBorderColor = Color(0xFF3C3C3C);
const Color bestRunGreen = Color(0xFF69FF03);
const Color appbarColor = Color(0xFF0C0C0C);
const Color messageAnswerSeparatorColor = Color(0xFF20404B);
const Color answerBackgroundColor = Color(0xFF0C0C0C);
const Color textFieldBackgroundColor = Color(0xFF222222);

const TextStyle titleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const TextStyle loginTitleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20.0,
  fontWeight: FontWeight.w300,
);

const TextStyle formTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15.0,
  fontWeight: FontWeight.w300,
);

const TextStyle menuTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15.0,
  fontWeight: FontWeight.w200,
);

const TextStyle menuHeaderTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontWeight: FontWeight.w800,
);

const TextStyle menuHeaderTextStyleNickName = TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontWeight: FontWeight.w200,
);

const TextStyle menuHeaderUnderTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 12.0,
  fontWeight: FontWeight.w100,
);

class ProfileData {
  static List<Profile> profiles = [
    Profile(
      name: 'Teszt Jakab',
      email: 'tesztmail@gmail.com',
      weight: '78 kg',
      height: '175 cm',
      dateOfBirth: '1990.09.09',
    ),
  ];
}
