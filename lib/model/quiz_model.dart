import 'package:flutter/material.dart';
class QuizModel {
  int onlineUserCount;
  String newQuestionDate;
  NewQuestionModel newQuestion;
  bool lastQuestionIsAnswerCorrect;
  String username;

  QuizModel(
      {this.onlineUserCount,
        this.newQuestionDate,
        this.newQuestion,
        this.lastQuestionIsAnswerCorrect,
        this.username});

  QuizModel.fromJson(Map<String, dynamic> json) {
    onlineUserCount = json['OnlineUserCount'];
    newQuestionDate = json['NewQuestionDate'];
    newQuestion = json['NewQuestion'] != null
        ? new NewQuestionModel.fromJson(json['NewQuestion'])
        : null;
    lastQuestionIsAnswerCorrect = json['LastQuestionIsAnswerCorrect'];
    username = json['Username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OnlineUserCount'] = this.onlineUserCount;
    data['NewQuestionDate'] = this.newQuestionDate;
    if (this.newQuestion != null) {
      data['NewQuestion'] = this.newQuestion.toJson();
    }
    data['LastQuestionIsAnswerCorrect'] = this.lastQuestionIsAnswerCorrect;
    data['Username'] = this.username;
    return data;
  }
}

class NewQuestionModel {
  String questionText;
  List<NewQuestionAnswersModel> newQuestionAnswers;

  NewQuestionModel({this.questionText, this.newQuestionAnswers});

  NewQuestionModel.fromJson(Map<String, dynamic> json) {
    questionText = json['QuestionText'];
    if (json['NewQuestionAnswers'] != null) {
      newQuestionAnswers = new List<NewQuestionAnswersModel>();
      json['NewQuestionAnswers'].forEach((v) {
        newQuestionAnswers.add(new NewQuestionAnswersModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuestionText'] = this.questionText;
    if (this.newQuestionAnswers != null) {
      data['NewQuestionAnswers'] =
          this.newQuestionAnswers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewQuestionAnswersModel {
  String answerText;
  bool isCorrect;

  NewQuestionAnswersModel({this.answerText, this.isCorrect});

  NewQuestionAnswersModel.fromJson(Map<String, dynamic> json) {
    answerText = json['AnswerText'];
    isCorrect = json['IsCorrect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AnswerText'] = this.answerText;
    data['IsCorrect'] = this.isCorrect;
    return data;
  }
}