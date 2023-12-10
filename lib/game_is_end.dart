import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'Functions/Websocket.dart';

class game_is_end extends StatefulWidget {
  final username;
  final ip;
  const game_is_end({super.key,required this.username,required this.ip});

  @override
  State<game_is_end> createState() => _game_is_endState();
}

class _game_is_endState extends State<game_is_end> {
  List<Users> Leaderboard = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Leaderboard.length >= 2 ?  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Row(
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width * 0.115),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.03, child: Icon(PhosphorIcons.trophy(PhosphorIconsStyle.bold), color: const Color(0xFFc7d1da), size: MediaQuery.of(context).size.width *   0.02,)),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: AutoSizeText(
                                  Leaderboard[1].name,
                                  maxLines: 1,
                                  minFontSize: 1,
                                  style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.02),
                                  textAlign: TextAlign.left,
                                )),
                          ],
                        ),
                      Row(
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.115),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: AutoSizeText(
                                "Punkte: ${Leaderboard[1].points}",
                                maxLines: 1,
                                minFontSize: 1,
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.01),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                    ],
                  ) : Container(),
                  Leaderboard.length >= 2 ? Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03, child: Icon(PhosphorIcons.trophy(PhosphorIconsStyle.bold), color: const Color(0xFFccac00), size: MediaQuery.of(context).size.width *   0.02)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: AutoSizeText(
                                Leaderboard[0].name,
                                maxLines: 1,
                                minFontSize: 1,
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.02),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: AutoSizeText(
                                "Punkte: ${Leaderboard[0].points}",
                                maxLines: 1,
                                minFontSize: 1,
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.01),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                    ],
                  ) : Container(),
                  Leaderboard.length >= 3 ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Row(
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03, child: Icon(PhosphorIcons.trophy(PhosphorIconsStyle.bold), color: const Color(0xFF88540b), size: MediaQuery.of(context).size.width *   0.02)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: AutoSizeText(
                                Leaderboard[2].name,
                                maxLines: 1,
                                minFontSize: 1,
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.02),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: AutoSizeText(
                                "Punkte: ${Leaderboard[2].points}",
                                maxLines: 1,
                                minFontSize: 1,
                                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.01),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                    ],
                  ) : Container(),

                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: AutoSizeText(
                "Du bist Platz: ${(Leaderboard.indexWhere((element) => element.name == widget.username) + 1)} mit ${Leaderboard[Leaderboard.indexWhere((element) => element.name == widget.username)].points}",
                maxLines: 1,
                minFontSize: 1,
                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.02),
                textAlign: TextAlign.center,
              )),
          OutlinedButton(onPressed: () async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Phoenix.rebirth(context);
          }, child:
          Text(
            "Neues Spiel",
            style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width *  0.015),
            textAlign: TextAlign.center,
          ))
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<websocket>().get_lobbys(widget.ip);
    setState(() {
      Leaderboard = context.read<websocket>().users;
      Leaderboard.sort((a, b) => b.points >= a.points ? 1 : -1 );
    });
  }
}
