import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/core/utils/handle_time.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final bool onboardingComplete;
  final bool? notificationOn;
  final String? photoUrl;
  final TimeOfDay? notifyAt;
  final int? pages;
  final int? minutes;
  final GoalType? goalType;

  UserModel(
      {required this.uid,
      required this.email,
      required this.name,
      required this.onboardingComplete,
      this.notificationOn,
      this.photoUrl,
      this.notifyAt,
      this.pages,
      this.minutes,
      this.goalType});

  UserModel copyWith(
      {String? uid,
      String? email,
      String? name,
      TimeOfDay? notifyAt,
      bool? notificationOn,
      String? photoUrl,
      int? pages,
      int? minutes,
      GoalType? goalType,
      bool? onboardingComplete}) {
    return UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        name: name ?? this.name,
        notifyAt: notifyAt ?? this.notifyAt,
        photoUrl: photoUrl ?? this.photoUrl,
        pages: pages ?? this.pages,
        minutes: minutes ?? this.minutes,
        goalType: goalType ?? this.goalType,
        onboardingComplete: onboardingComplete ?? this.onboardingComplete,
        notificationOn: notificationOn ?? this.notificationOn);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'onboardingComplete': onboardingComplete,
      'photoUrl': photoUrl,
      'noifyAt': notifyAt,
      'goalType': goalType,
      'pages': pages,
      'minutes': minutes,
      'notificationOn': notificationOn
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      onboardingComplete: map['onboardingComplete'] as bool,
      notificationOn:
          map['notificationOn'] != null ? map['notificationOn'] as bool : null,
      notifyAt: map['notifyAt'] != null
          ? fromTimestamp(map['notifyAt'] as Timestamp)
          : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      pages: map['pages'] != null ? map['pages'] as int : null,
      minutes: map['minutes'] != null ? map['minutes'] as int : null,
      goalType:
          map['goalType'] != null ? GoalType.values[map['goalType']] : null,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, name: $name, onboardingComplete: $onboardingComplete, notifyAt: $notifyAt, photoUrl: $photoUrl, pages: $pages, minutes: $minutes, goalType: $goalType)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.name == name &&
        other.notificationOn == notificationOn &&
        other.notifyAt == notifyAt &&
        other.photoUrl == photoUrl &&
        other.pages == pages &&
        other.minutes == minutes &&
        other.onboardingComplete == onboardingComplete &&
        other.goalType == goalType;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        name.hashCode ^
        notifyAt.hashCode ^
        photoUrl.hashCode ^
        pages.hashCode ^
        minutes.hashCode ^
        goalType.hashCode ^
        onboardingComplete.hashCode ^
        notificationOn.hashCode;
  }
}
