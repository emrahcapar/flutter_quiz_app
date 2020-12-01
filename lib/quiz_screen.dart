import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quizmobileapp/model/quiz_model.dart';
import 'package:quizmobileapp/model/result_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class QuizScreen extends StatefulWidget {
  final String userName;
  final WebSocketChannel channel;

  QuizScreen({
    Key key,
    @required this.userName,
    @required this.channel,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  _QuizScreenState();

  Timer _newQuestionTimer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quiz App",
          style: TextStyle(fontSize: 26),
        ),
      ),
      body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 24),
              child: Column(
                children: <Widget>[
                  Hero(child:  Image.asset(
                    "assets/images/cup.png",
                    width: 150,
                    height: 150,
                  ),tag: "Emrah",),
                  SizedBox(height: 20),
                  StreamBuilder(
                      stream: widget.channel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          QuizModel quizModel = QuizModel.fromJson(
                              json.decode(snapshot.data.toString()));
                          if(DateTime.parse(quizModel.newQuestionDate).isAfter(DateTime.now())){

                              _newQuestionTimer = new Timer.periodic(
                                Duration(seconds: 1),
                                    (Timer timer) =>
                                    setState(() {
                                      if (!DateTime.parse(quizModel.newQuestionDate).isAfter(DateTime.now())) {
                                          _newQuestionTimer.cancel();
                                          return questionWidget(quizModel);
                                      }
                                      else{

                                      }
                                    }));
                            return  showResultWidget(quizModel);
                          }else{
                            return questionWidget(quizModel);

                          }
                        }
                        return watingUserWidget();
                      }),
                ],
              ))),
    );
  }

  Widget watingUserWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Rakip bekleniyor",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(width: 75, height: 75, child: CircularProgressIndicator())
      ],
    );
  }

  Widget questionWidget(QuizModel quizModel) {
    return Column(children: <Widget>[
      Text(
        "Aşağıdaki soruyu hemen cevapla !",
        style: TextStyle(
            fontSize: 20, color: Colors.grey[500]),
      ),
      SizedBox(height: 20),
      Card(
        color: Colors.blue[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding:
            const EdgeInsets.only(left: 6, right: 6, top: 25, bottom: 12.0),
            child: Text(
              quizModel.newQuestion.questionText,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          for (NewQuestionAnswersModel answer
          in quizModel.newQuestion.newQuestionAnswers)
            answerWidget(quizModel, answer),
          SizedBox(height: 20)
        ]),
      )
    ],);
  }

  Widget answerWidget(QuizModel quizModel, NewQuestionAnswersModel answer) {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.grey)),
          onPressed: () {
            AnswerModel answerModel = AnswerModel();
            answerModel.isAnswerCorrect =
                answer.isCorrect;
            answerModel.userName = widget.userName;
            widget.channel.sink.add(json.encode(answerModel));
          },
          color: Colors.white,
          textColor: Colors.black,
          child: Text(answer.answerText,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget showResultWidget(QuizModel quizModel) {
    return Column(
      children: <Widget>[
        if(quizModel.lastQuestionIsAnswerCorrect)
          Text(
             "Tebrikler Soruyu Doğru Bildin !",
            style: TextStyle(
                fontSize: 20, color: Colors.green),
          )
        else
          Text(
            "Üzgünüm soruyu doğru bilemedin !",
            style: TextStyle(
                fontSize: 20, color: Colors.red),
          )
        ,
        SizedBox(height: 20),
        Text(
          quizModel.username.toUpperCase(),
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
         "Lütfen bir sonraki soruyu bekleyiniz..",
          style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 50),
        Container(child: CircularProgressIndicator(),width: 75,height: 75,)
      ],
    );
  }
}
