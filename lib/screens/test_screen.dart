import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';


class TestScreen extends StatefulWidget {
  final numberOfQuestion;
  TestScreen({this.numberOfQuestion});
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int numberOfRemaining;
  int numberOfCorrect;
  int rateOfCorrect;

  int questionRight;
  int questionLeft;
  String operator = '+';
  String answerString = '';

  Soundpool soundpool;

  int soundIdCorrect;
  int soundIdInCorrect;

  bool isCalcChecButtonEnable = false;
  bool isAnswerCheckButtonEnable = false;
  bool isBackButtonEnable = false;
  bool isCorrectEnable = false;
  bool isEndMessage = false;
  bool isCorret = false;


  @override
  void initState() {
    super.initState();
     numberOfCorrect = 0;
     rateOfCorrect = 0;
     numberOfRemaining = widget.numberOfQuestion;

    initSounds();

    setQuestion();
  }

  @override
  void dispose() {
    super.dispose();
    soundpool.release();
  }
  void initSounds() async {
    try{
      soundpool = Soundpool();
      soundIdCorrect =await loadSound('assets/sounds/sound_correct.mp3');
      soundIdInCorrect =await loadSound('assets/sounds/sound_incorrect.mp3');
      setState(() {
      });
    }on IOException catch(error){
      print('エラー内容は$error');
    }

  }
  Future<int> loadSound(String soundPath) {
    return rootBundle.load(soundPath).then((value) => soundpool.load(value));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _scorePart(),
              _questionPart(),
              _calcButton(),
              _answerCheckButoon(),
              _backButton()
            ],
          ),
          corectMessge(),
          endMessage()
        ],
      ),
    ));
  }
  corectMessge() {
    if(isCorrectEnable){
      if(isCorret){
        return Center(child: Image.asset('assets/images/pic_correct.png'));
      }else {
        return Center(child: Image.asset('assets/images/pic_incorrect.png'));
      }
    }else{
      return Container();
    }
  }

  endMessage() {
    if(isEndMessage){
      return Center(child: Text('テスト終了',style: TextStyle(fontSize: 80.0)));
    }else{
      return Container();
    }

  }


  _scorePart() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right:8.0,top:8.0),
      child: Table(
        children: [
          TableRow(
            children: [
            Center(child: Text('残り問題数',style: TextStyle(fontSize: 10.0),)),
              Center(child: Text('正解数',style: TextStyle(fontSize: 10.0),)),
              Center(child: Text('正答率',style: TextStyle(fontSize: 10.0),))
      ]
          ),
          TableRow(
            children: [
              Center(child: Text(numberOfRemaining.toString(),style: TextStyle(fontSize: 20.0),)),
              Center(child: Text(numberOfCorrect.toString(),style: TextStyle(fontSize: 20.0),)),
              Center(child: Text(rateOfCorrect.toString(),style: TextStyle(fontSize: 20.0),)),
            ],
          )
        ],
      ),
    );
  }

  _questionPart() {
    return Padding(
      padding: const EdgeInsets.only(top:20),
      child: Row(
        children: [
           Expanded(flex: 2,child: Center(child: Text(questionRight.toString(),style: TextStyle(fontSize: 36.0)))),
           Expanded(flex:1,child: Center(child: Text(operator,style: TextStyle(fontSize: 20.0)))),
           Expanded(flex: 2,child: Center(child: Text(questionLeft.toString(),style: TextStyle(fontSize: 36.0)))),
           Expanded(flex: 1,child: Center(child: Text("=",style: TextStyle(fontSize: 20.0)))),
           Expanded(flex: 3,child: Center(child: Text(answerString,style: TextStyle(fontSize: 50.0))))

        ],
      ),
    );
  }

  _calcButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top:80.0),
        child: Table(
          children: [
            TableRow(
              children: [
                mathButton('7'),
                mathButton('8'),
                mathButton('9'),
              ]
            ),
            TableRow(
                children: [
                  mathButton('4'),
                  mathButton('5'),
                  mathButton('6'),
                ]
            ),
            TableRow(
                children: [
                  mathButton('1'),
                  mathButton('2'),
                  mathButton('3'),
                ]
            ),
            TableRow(
                children: [
                  mathButton('0'),
                  mathButton('-'),
                  mathButton('C'),
                ]
            ),
          ],
        ),
      ),
    );
  }
  Widget mathButton(String numString) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: RaisedButton(
          onPressed: isCalcChecButtonEnable ? () =>inputAnswer(numString) : null,
          child: Text(numString,style: TextStyle(fontSize: 30.0 )),
      ),
    );
  }
  inputAnswer(String numString) {
    setState(() {
       if(numString == 'C'){
         answerString = ' ';
       return;
       }
       if(numString == '-'){
         if(answerString == ''){
           answerString = '-';
         }
         return;
       }
       if(numString == '0'){
         if(answerString != '0' && answerString != '-'){
           answerString = answerString + numString;

         }
         return;
       }
       if(answerString == '0'){
         answerString = numString;
         return;
       }
      answerString = answerString + numString;
    });
  }

  _answerCheckButoon() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right:8.0),
      child: SizedBox(
      width: double.infinity,
        child: RaisedButton(
            onPressed: isCalcChecButtonEnable ? () =>answerCheck():null,
            child: Text('答え合わせ',style:TextStyle(fontSize: 20.0)),
      ),
    )
    );
  }
  answerCheck() {
    if(answerString == '' || answerString == '-'){
      return;
    }
    isCalcChecButtonEnable = false;
    isAnswerCheckButtonEnable =false;
    isBackButtonEnable = false;
    isCorrectEnable = true;
    isEndMessage = false;
    var myAnswer = int.parse(answerString).toInt();
    var realAnswer = 0;
    if(operator == '+'){
      realAnswer = questionLeft + questionRight;
    }else{
      realAnswer = questionRight - questionLeft;
    }

    if(myAnswer == realAnswer){
     isCorret = true;
     soundpool.play(soundIdCorrect);
     numberOfCorrect += 1;
     numberOfRemaining -=1;
    }else{
      isCorret = false;
      numberOfRemaining -=1;
      soundpool.play(soundIdInCorrect);
    }

    rateOfCorrect = ((numberOfCorrect/(widget.numberOfQuestion - numberOfRemaining))*100).toInt();

    if(numberOfRemaining == 0) {
      // 残り問題数がないとき
      isCalcChecButtonEnable = false;
      isAnswerCheckButtonEnable = false;
      isBackButtonEnable = true;
      isCorrectEnable = true;
      isEndMessage = true;

    }else{
      //残り問題数がなあるとき
      Timer(Duration(seconds: 1), () => setQuestion());

    }
    setState(() {

    });
  }

  _backButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: null,
           child: Text('戻るボタン',style: TextStyle(fontSize: 20.0,),
        )
        ),
      ),
    );
  }


  //TODO 問題を出す
  void setQuestion() {
    isCalcChecButtonEnable = true;
    isAnswerCheckButtonEnable = true;
    isBackButtonEnable = false;
    isCorrectEnable = false;
    isEndMessage = false;

    answerString = '';

    Random random = Random();
    questionLeft = random.nextInt(100)+1;
    questionRight = random.nextInt(100)+1;

    if(random.nextInt(2)+1 == 1){
      operator = '+';
    }else{
      operator = '-';
    }
    setState(() {

    });
  }











}
