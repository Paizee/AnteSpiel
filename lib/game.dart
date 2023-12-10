import 'dart:async';

import 'package:antespiel/Functions/Websocket.dart';
import 'package:antespiel/game_is_end.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class game extends StatefulWidget {
  final username;
  final ip;
  const game({super.key,required this.username,required this.ip});

  @override
  State<game> createState() => _gameState();
}

class _gameState extends State<game> {
  TextEditingController inputcontroller = TextEditingController();
  bool input_wrong = false;
  int possible_points = 5;
  int points = 0;
  int index_question = 0;
  int index_question_same = 0;
  Timer? timer;
  List<Users> Leaderboard = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Align(alignment: Alignment.topCenter,child: Image.asset("assets/Ante-Edition.png")),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Text(
                    "Frage: ${context.watch<websocket>().questions_answer[index_question].question[index_question_same]}",
                    style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *  0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.425,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Stack(
                    children: [
                      TextField(
                        maxLines: 1,
                        autocorrect: false,
                        controller: inputcontroller,
                        onChanged: (nameController) {
                          setState(() {
                            input_wrong = false;
                          });
                        },
                        keyboardType: TextInputType.name,
                        style: TextStyle(fontFamily: "Roboto",color: Colors.white70,fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),
                        decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 15), hintText: "Eingabe",fillColor: input_wrong ? Colors.red : null,hoverColor: input_wrong ? Colors.red : null,),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: (){
                          if (context.read<websocket>().questions_answer[index_question].answer == inputcontroller.text) {
                           setState(() {
                             index_question += 1;
                             inputcontroller.text = "";
                             points += (5 - index_question_same);
                           });
                           context.read<websocket>().increment_points(widget.username,(5 - index_question_same),widget.ip);
                          } else {
                            setState(() {
                              input_wrong = true;
                            });
                          }
                        },
                        child: Text("Bestätigen",
                            style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width * 0.02)) ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.015,
                    ),
                    index_question_same != 4 ? OutlinedButton(
                        onPressed: (){
                          setState(() {
                            possible_points -= 1;
                            index_question_same++;
                          });
                        },
                        child: Text("Andere Frage",
                            style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width * 0.02)) ) : OutlinedButton(
                        onPressed: (){
                          setState(() {
                            index_question++;
                            index_question_same = 0;
                            possible_points = 5;
                            inputcontroller.text = "";
                          });
                        },
                        child: Text("Aufgeben",
                            style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width * 0.02)) ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  child: Text(
                    "Mögliche Punkte: $possible_points",
                    style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  child: Text(
                    "Punkte: $points",
                    style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  child: Text(
                    "Noch: ${context.watch<websocket>().endtime!.toUtc().add(Duration(minutes: 60)).difference(DateTime.now()).toString().substring(2,7)}",
                    style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015,color: context.watch<websocket>().endtime!.toUtc().add(Duration(minutes: 60)).difference(DateTime.now()).inMinutes <= 1 ? Colors.red:null),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Align(alignment: Alignment.bottomRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.305,
                child: ListView(children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(PhosphorIcons.trophy(PhosphorIconsStyle.bold), size: MediaQuery.of(context).size.width *  0.015),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Text(
                            "Name " ,
                            style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width *   0.015),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *  0.065,
                          ),
                          Text(
                            "Punkte" ,
                            style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width *   0.015),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.305,
                        height: 2,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *  0.0105,
                      ),
                      Leaderboard.length >= 1 ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03, child: Icon(PhosphorIcons.trophy(PhosphorIconsStyle.bold), color: const Color(0xFFccac00), size: MediaQuery.of(context).size.width *   0.015)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: AutoSizeText(
                                Leaderboard[0].name,
                                maxLines: 1,
                                minFontSize: 1,
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.015),
                                textAlign: TextAlign.left,
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.055,
                              child: Text(
                                Leaderboard[0].points.toString(),
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.015),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ): Container(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *  0.02,
                      ),
                      Leaderboard.length >= 2 ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03, child: Icon(PhosphorIcons.trophy(PhosphorIconsStyle.bold), color: const Color(0xFFc7d1da), size: MediaQuery.of(context).size.width *   0.015)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: AutoSizeText(
                                Leaderboard[1].name,
                                maxLines: 1,
                                minFontSize: 1,
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.015),
                                textAlign: TextAlign.left,
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.055,
                              child: Text(
                                Leaderboard[1].points.toString(),
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.015),
                                textAlign: TextAlign.left,
                              )),

                        ],
                      ): Container(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *  0.02,
                      ),
                      Leaderboard.length >= 3 ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03, child: Icon(PhosphorIcons.trophy(PhosphorIconsStyle.bold), color: const Color(0xFF88540b), size: MediaQuery.of(context).size.width *   0.015)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: AutoSizeText(
                                Leaderboard[2].name,
                                maxLines: 1,
                                minFontSize: 1,
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.015),
                                textAlign: TextAlign.left,
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.055,
                              child: Text(
                                Leaderboard[2].points.toString(),
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.015),
                                textAlign: TextAlign.left,
                              )),

                        ],
                      ): Container(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *  0.02,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03, child: Icon(PhosphorIcons.dotsThree(PhosphorIconsStyle.bold), size: MediaQuery.of(context).size.width *   0.02)),
                        ],
                      ),
                      Leaderboard.length >= 1 ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                              child: Text(
                                (Leaderboard.indexWhere((element) => element.name == widget.username) + 1).toString(),
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width *   0.015),
                                textAlign: TextAlign.center,
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: AutoSizeText(
                                Leaderboard[Leaderboard.indexWhere((element) => element.name == widget.username)].name,
                                maxLines: 1,
                                minFontSize: 1,
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.015),
                                textAlign: TextAlign.left,
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.055,
                              child: Text(
                                Leaderboard[Leaderboard.indexWhere((element) => element.name == widget.username)].points.toString(),
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.015),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ) : Container(),
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<websocket>().make_questions();
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      context.read<websocket>().get_lobbys(widget.ip);
      setState(() {
        Leaderboard = context.read<websocket>().users;
        Leaderboard.sort((a, b) => b.points >= a.points ? 1 : -1 );
      });
      if (context.read<websocket>().endtime!.toUtc().add(Duration(minutes: 60)).difference(DateTime.now()).inSeconds <= 0) {
        timer.cancel();
        Navigator.push(context, MaterialPageRoute(builder: (builder) => game_is_end(username: widget.username,ip: widget.ip)));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }
}
