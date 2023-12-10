import 'dart:async';

import 'package:antespiel/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import 'Functions/Websocket.dart';

class waitinglist extends StatefulWidget {
  final creator;
  final username;
  final ip;
  const waitinglist({super.key,required this.creator,required this.username,required this.ip});

  @override
  State<waitinglist> createState() => _waitinglistState();
}

class _waitinglistState extends State<waitinglist> {
  ScrollController scrollController = ScrollController();
  int first_list = 1;
  int second_list = 0;
  int third_list = 0;
  Timer? timer;
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
                  Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(onPressed: () {
                        context.read<websocket>().clear_user_list();
                        context.read<websocket>().left_lobby(widget.username,widget.ip);
                        Navigator.pop(context);

                        }, icon: Icon(PhosphorIcons.arrowCircleLeft(PhosphorIconsStyle.bold),size:  MediaQuery.of(context).size.height * 0.05,),)),
                  Align(alignment: Alignment.topCenter,child: Image.asset("assets/Ante-Edition.png")),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Warteraum",style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.03)),
            ),
          ),
          Center(
            child: Text(" Code: ${context.watch<websocket>().lobby_code}",style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015)),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ListView.builder(
                        shrinkWrap: true,
                         itemCount: context.watch<websocket>().users.length <= 7 ? context.watch<websocket>().users.length : 7 ,
                         itemBuilder: (context, index) {
                           if (context.watch<websocket>().users.isNotEmpty){
                           return Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Container(
                               decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2),borderRadius: BorderRadius.circular(8)),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.only(top: 4,left: 16,bottom: 4),
                                     child: Text(context.watch<websocket>().users[index].name,style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015)),
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.only(top: 4,right: 16,bottom: 4 ),
                                     child: Text(context.watch<websocket>().users[index].role,style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015)),
                                   )
                                 ],
                               ),
                             ),
                           );}

                           else {return Align(alignment: Alignment.center,child: LoadingAnimationWidget.waveDots(color: Colors.white70, size: 50));}
                         }),
                  ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: context.watch<websocket>().users.length >= 8 ?  context.watch<websocket>().users.length >= 14 ? 7 : context.watch<websocket>().users.length -7  : 0 ,
                      itemBuilder: (context, index) {
                        index = index + 7;
                        if (context.watch<websocket>().users.isNotEmpty){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2),borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4,left: 16,bottom: 4),
                                    child: Text(context.watch<websocket>().users[index].name,style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4,right: 16,bottom: 4 ),
                                    child: Text(context.watch<websocket>().users[index].role,style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015)),
                                  )
                                ],
                              ),
                            ),
                          );}

                        else {return Align(alignment: Alignment.center,child: LoadingAnimationWidget.waveDots(color: Colors.white70, size: 50));}
                      }),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ListView.builder(
                      shrinkWrap: true,

                      itemCount: context.watch<websocket>().users.length >= 15 ? context.watch<websocket>().users.length - 15: 0 ,
                      itemBuilder: (context, index) {
                        index = index + 14;
                        if (context.watch<websocket>().users.isNotEmpty){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2),borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4,left: 16,bottom: 4),
                                    child: Text(context.watch<websocket>().users[index].name,style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4,right: 16,bottom: 4 ),
                                    child: Text(context.watch<websocket>().users[index].role,style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015)),
                                  )
                                ],
                              ),
                            ),
                          );}

                        else {return Align(alignment: Alignment.center,child: LoadingAnimationWidget.waveDots(color: Colors.white70, size: 50));}
                      }),
                ),
              ],
            ),
          ),
          widget.creator == true && context.watch<websocket>().users.length >= 2 ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(onPressed: (){
              context.read<websocket>().start_lobby(widget.ip);
            }, child: Text("Starten",style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.015)),),
          ) : Container()
        ],
      )

    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      context.read<websocket>().get_lobbys(widget.ip);
      if (context.read<websocket>().lobby_state == "started") {
        timer.cancel();
        Navigator.push(context, MaterialPageRoute(builder: (builder) =>  game( username: widget.username,ip: widget.ip,)));
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
