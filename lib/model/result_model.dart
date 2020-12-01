import 'package:flutter/material.dart';
class AnswerModel {
  String userName;
  bool isAnswerCorrect;

  AnswerModel({this.userName, this.isAnswerCorrect});

  AnswerModel.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    isAnswerCorrect = json['IsAnswerCorrect'];
  }

  Map<String, dynamic>  toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserName'] = this.userName;
    data['IsAnswerCorrect'] = this.isAnswerCorrect;
    return data;
  }
}