import 'dart:async';

import 'package:antespiel/waitinglist.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Functions/Websocket.dart';

class connection_infos extends StatefulWidget {
  const connection_infos({super.key});

  @override
  State<connection_infos> createState() => _connection_infosState();
}

class _connection_infosState extends State<connection_infos> {
  TextEditingController ipcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset("assets/Ante-Edition.png"),)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  lobby_entry(ip: ipcontroller.text,)),);

                      },
                      child: Text("Lobby beitreten",
                        style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),

                      ),)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  lobby_create(ip: ipcontroller.text,)),);
                      },
                      child: Text("Lobby erstellen",
                        style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),

                      ),))
              ],
            ),),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child:
                        TextField(
                          maxLines: 1,
                          autocorrect: false,
                          controller: ipcontroller,
                          onSubmitted: (ipcontroller) {
                            if (ipcontroller.length != 0) {
                              context.read<websocket>().check_connection(ipcontroller);

                            }

                          },
                          keyboardType: TextInputType.name,
                          style: TextStyle(fontFamily: "Roboto",color: Colors.white70,fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width * 0.02),
                          decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 15), border: InputBorder.none, hintText: "IP"),
                        ),
                  ),
                  Icon(PhosphorIcons.dot(PhosphorIconsStyle.bold),color: context.watch<websocket>().connected != null ? context.watch<websocket>().connected?  Colors.green : Colors.red : Colors.transparent ,size: MediaQuery.of(context).size.width * 0.05,)
                ],
              ),
            ),


          ]
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      //212.227.173.86
      ipcontroller.text = "ws://212.227.173.86:8765/websocket";
    context.read<websocket>().clear_prefs();
    context.read<websocket>().check_connection(ipcontroller.text);



  }
}

class lobby_create extends StatefulWidget {
  final ip;
  const lobby_create({super.key,required this.ip});

  @override
  State<lobby_create> createState() => _lobby_createState();
}

class _lobby_createState extends State<lobby_create> {
  TextEditingController nameController = TextEditingController();
  bool namegivenbool = false;
  bool nameemptybool = false;

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
                      child: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(PhosphorIcons.arrowCircleLeft(PhosphorIconsStyle.bold),size:  MediaQuery.of(context).size.height * 0.05,),)),
                  Align(alignment: Alignment.topCenter,child: Image.asset("assets/Ante-Edition.png")),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              child: Text(
                "Name",
                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),
              ),
            ),
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
                    controller: nameController,
                    onChanged: (nameController) {
                      setState(() {
                        namegivenbool = false;
                        nameemptybool = false;
                      });
                    },
                    keyboardType: TextInputType.name,
                    style: TextStyle(fontFamily: "Roboto",color: Colors.white70,fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),
                    decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 15), border: InputBorder.none, hintText: "Name"),
                  ),
                  nameemptybool || namegivenbool ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(PhosphorIcons.warning(PhosphorIconsStyle.bold), color: Colors.red,)),
                  ) : Container(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Visibility(
                visible: namegivenbool || nameemptybool,
                child: Text(
                  namegivenbool == true ? "Der Name ist schon vergeben!" : "Der Name darf nicht leer sein!",
                  style: TextStyle(fontFamily: "Roboto",color: Colors.red,fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  context.read<websocket>().create_lobby(nameController.text,widget.ip).whenComplete(() {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) =>  waitinglist(creator: true,username: nameController.text,ip: widget.ip,)));
                  });

                },
                child: Text("Erstellen",
                  style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),

                ),))
        ],
      ),
    );
  }
}


class lobby_entry extends StatefulWidget {
  final ip;
  const lobby_entry({super.key,required this.ip});

  @override
  State<lobby_entry> createState() => _lobby_entryState();
}

class _lobby_entryState extends State<lobby_entry> {
  TextEditingController nameController = TextEditingController();
  bool namegivenbool = false;
  bool nameemptybool = false;
  TextEditingController lobbycodeController = TextEditingController();
  bool lobbycodewrongbool = false;
  bool lobbycodeemptybool = false;
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
                      child: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(PhosphorIcons.arrowCircleLeft(PhosphorIconsStyle.bold),size:  MediaQuery.of(context).size.height * 0.05,),)),
                  Align(alignment: Alignment.topCenter,child: Image.asset("assets/Ante-Edition.png")),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              child: Text(
                "Lobby Code",
                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),
              ),
            ),
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
                    controller: lobbycodeController,
                    onChanged: (nameController) {
                      timer?.cancel();
                      setState(() {
                        lobbycodeemptybool = false;
                        lobbycodewrongbool = false;
                      });
                    },
                    keyboardType: TextInputType.name,
                    style: TextStyle(fontFamily: "Roboto",color: Colors.white70,fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),
                    decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 15), border: InputBorder.none, hintText: "Lobby Code"),
                  ),
                  lobbycodeemptybool || lobbycodewrongbool ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(PhosphorIcons.warning(PhosphorIconsStyle.bold), color: Colors.red,)),
                  ) : Container(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Visibility(
                visible: lobbycodewrongbool || lobbycodeemptybool,
                child: Text(
                  lobbycodewrongbool == true ? "Falscher Lobby Code!" : "Der Lobby Code darf nicht leer sein!",
                  style: TextStyle(fontFamily: "Roboto",color: Colors.red,fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              child: Text(
                "Name",
                style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),
              ),
            ),
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
                    controller: nameController,
                    onChanged: (nameController) {
                      timer?.cancel();
                      setState(() {
                        namegivenbool = false;
                        nameemptybool = false;
                      });
                    },
                    keyboardType: TextInputType.name,
                    style: TextStyle(fontFamily: "Roboto",color: Colors.white70,fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),
                    decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 15), border: InputBorder.none, hintText: "Name"),
                  ),
                  nameemptybool || namegivenbool ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(PhosphorIcons.warning(PhosphorIconsStyle.bold), color: Colors.red,)),
                  ) : Container(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Visibility(
                visible: namegivenbool || nameemptybool,
                child: Text(
                  namegivenbool == true ? "Der Name ist schon vergeben!" : "Der Name darf nicht leer sein!",
                  style: TextStyle(fontFamily: "Roboto",color: Colors.red,fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  int i = 0;
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                if (nameController.text.isNotEmpty) {
                  if (lobbycodeController.text.isNotEmpty) {
                    prefs.setString("check_user_name",nameController.text);
                    prefs.setString("lobby_code_check_user_name",lobbycodeController.text);
                    prefs.reload();
                    context.read<websocket>().get_lobbys(widget.ip);
                    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
                      if (context.read<websocket>().bool_user_name_given != null) {
                        if(context.read<websocket>().lobby_codes.contains(lobbycodeController.text)) {
                          if (context.read<websocket>().bool_user_name_given == false && i == 0) {
                            context.read<websocket>().join_lobby(nameController.text,lobbycodeController.text,widget.ip).whenComplete(() {
                              Navigator.push(context, MaterialPageRoute(builder: (builder) =>  waitinglist(creator: false,username: nameController.text,ip: widget.ip)));
                            });
                            timer.cancel();
                            i++;
                          }else {
                            setState(() {
                              namegivenbool = true;
                            });
                            timer.cancel();
                          }
                        }else {
                          setState(() {
                            lobbycodewrongbool = true;
                          });
                          timer.cancel();
                        }
                      }
                    });
                  } else {
                    setState(() {
                      lobbycodeemptybool = true;
                    });
                  }
                } else {
                  setState(() {
                    nameemptybool = true;
                  });
                }
                },
                child: Text("Beitreten",
                  style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width * 0.02),

                ),))
        ],
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }
}

