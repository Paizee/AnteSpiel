import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class websocket with ChangeNotifier {
  List<Users> users = [];
  List lobby_codes = [];
  var bool_user_name_given;
  var lobby_state;
  var connected;
  DateTime? endtime;
  Future<WebSocketChannel> connect_to_ws(ip) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final wsUrl = Uri.parse(ip);
    var channel =  WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      connected = true;
      notifyListeners();
      users = [];
      lobby_codes = [];
      var index = 0;
      var index_1 = 0;
      var index_2 = 0;

      for (final x in jsonDecode(message)) {
        lobby_codes.add(jsonDecode(message)[index_1]['code']);
        notifyListeners();
        index_1++;
      }
      try {
      if(prefs.getString("lobby_code_check_user_name")!.isNotEmpty){
        final messageMap_1 = jsonDecode(message) as List;
        var index_in_message_1 = messageMap_1.indexWhere((element) =>
        element['code'] == prefs.getString("lobby_code_check_user_name"));
        if (jsonDecode(message)[index_in_message_1]['user'][index_2]['name'] == prefs.getString("check_user_name")) {
          bool_user_name_given = true;
          notifyListeners();
        } else {
          bool_user_name_given = false;
          notifyListeners();
        }
        index_2++;
      }} catch (e) {

      }


      final messageMap = jsonDecode(message) as List;
      var index_in_message = messageMap.indexWhere((element) => element['code'] == prefs.getString("lobby_code"));
      if (index_in_message != -1){
        for (final x in jsonDecode(message)[index_in_message]['user']) {
          users.add(Users(
              name: jsonDecode(message)[index_in_message]['user'][index]
                  ['name'],
              role: jsonDecode(message)[index_in_message]['user'][index]
                  ['role'],
              points: jsonDecode(message)[index_in_message]['user'][index]
                  ['points']));
          notifyListeners();
          index++;
        }
      }

      if (prefs.getString("lobby_code")!.isNotEmpty){
        final messageMap_1 = jsonDecode(message) as List;
        var index_in_message_1 = messageMap_1.indexWhere(
            (element) => element['code'] == prefs.getString("lobby_code"));
        if (jsonDecode(message)[index_in_message_1]['state'] == "started") {
          lobby_state = "started";
          endtime = DateTime.parse(jsonDecode(message)[index_in_message_1]['endtime'].toString());
          notifyListeners();
        }
      }
    });
    return channel;
  }

  Future clear_user_list() async{
    users = [];
    notifyListeners();
  }
  var lobby_code;
  Future create_lobby(username,ip) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    lobby_code = randomNumeric(6);
    prefs.setString("lobby_code",lobby_code);
    notifyListeners();
     var data  =   {
        "lobby": "create",
        "name": username,
        "code": lobby_code,
      };
    await connect_to_ws(ip).then((channel) {
      channel.sink.add(jsonEncode(data));
      channel.sink.close();
    });

  }

  Future join_lobby(username,lobby_code_join,ip) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lobby_code",lobby_code_join);
    lobby_code = lobby_code_join;
    notifyListeners();
    var data  =   {
      "lobby": "join",
      "name": username,
      "code": lobby_code_join,
    };
    await connect_to_ws(ip).then((channel) {
      channel.sink.add(jsonEncode(data));
      channel.sink.close();
    });
  }

  Future get_lobbys(ip) async{
    var data  =   {
      "action": "return_lobbys",
    };
    await connect_to_ws(ip).then((channel) {
      channel.sink.add(jsonEncode(data));
      channel.sink.close();
    });
  }

  Future left_lobby(username,ip) async{
    var data  =   {
      "action": "left_lobby",
      "name": username,
      "code": lobby_code,
      "role": "Admin",
      "points": 0,
    };
    await connect_to_ws(ip).then((channel) {
      channel.sink.add(jsonEncode(data));
      channel.sink.close();
    });
  }

  Future start_lobby(ip) async {
    var data  =   {
      "action": "start_lobby",
      "code": lobby_code,
    };
    await connect_to_ws(ip).then((channel) {
      channel.sink.add(jsonEncode(data));
      channel.sink.close();
    });
  }

  List<Questions> questions_answer = [];
  Future make_questions() async{
    questions_answer = [
      Questions(question: [
        "Ich bin der Teil, der speziell für die Ausführung von Operationen mit Fließkommazahlen in einem Computersystem verantwortlich ist.",
        "Ich bin eine Kombination aus digitalen Schaltkreisen, die arithmetische und bitweise Operationen auf ganzzahligen Binärzahlen durchführen.",
        "Ich bin der Bereich, in dem Daten abgelegt werden, einschließlich Instruktionen, Speicheradressen und anderen relevanten Informationen.",
        "Ich bin dafür zuständig, den Maschinencode in einzelne Anweisungen zu übersetzen und so die Ausführung von Programmen zu ermöglichen.",
        "Ich steuere die Operationen, gebe Befehle an andere Teile des Systems und führe grundlegende Berechnungen durch. Ich bin das Herz und Hirn des Computers."
      ], answer: "CPU"),
      Questions(  question: [
        "Ich bin ein Bereich in der CPU, der speziell für die temporäre Speicherung von Anweisungen während der Programmausführung verantwortlich ist.",
        "Ich diene als Zwischenspeicher für den Maschinencode, um häufig verwendete Anweisungen schnell abrufen zu können.",
        "Meine Aufgabe besteht darin, die Ausführung von Programmen zu beschleunigen, indem ich häufig genutzte Anweisungen schnell und effizient bereitstelle.",
        "Ich bin ein wichtiger Bestandteil, der dazu beiträgt, die Rechenleistung der CPU zu optimieren, indem ich den Zugriff auf Anweisungen beschleunige.",
        "Programmierer verwenden mich, um sicherzustellen, dass ihre Anwendungen effizient und reaktionsschnell ausgeführt werden. Was bin ich?"
      ],
        answer: "CodeCache",),
      Questions(
        question: [
          "Ich bin ein kleiner Bereich in der CPU, der dazu dient, Daten abzulegen, darunter Instruktionen, Speicheradressen und vielfältige andere Informationen.",
          "Ich bin ein wesentlicher Bestandteil, in dem temporäre Informationen für die laufenden Berechnungen gespeichert werden, um den Zugriff zu beschleunigen.",
          "Programme verwenden mich, um temporäre Ergebnisse und Zwischenergebnisse während der Ausführung zu speichern. Wo bin ich in der CPU?",
          "Ich spiele eine entscheidende Rolle bei der Koordination von Rechenvorgängen, indem ich temporäre Daten halte und für schnelle Berechnungen zur Verfügung stelle.",
          "Ich bin ein Ablage- und Zwischenspeicherbereich, der eine Schlüsselrolle bei der effizienten Ausführung von Programmen auf der CPU spielt. Was bin ich?"
        ],
        answer: "Prozessorregister",
      ),
      Questions(
        question: [
          "Ich bin ein entscheidender Bestandteil, der die Kommunikation zwischen dem Motherboard und der CPU in einem Computersystem koordiniert.",
          "Ich bestimme, wie verschiedene Hardwarekomponenten miteinander interagieren und Daten austauschen, um ein reibungsloses Funktionieren des Gesamtsystems zu gewährleisten.",
          "Meine Hauptaufgabe besteht darin, Daten zwischen der CPU, dem Arbeitsspeicher und anderen Peripheriegeräten zu übertragen. Was bin ich?",
          "Ich spiele eine Schlüsselrolle bei der Verbindung von Hardwarekomponenten und ermögliche so die reibungslose Zusammenarbeit des gesamten Computer-Systems.",
          "Entwickler und Hersteller richten ihre Aufmerksamkeit auf mich, um sicherzustellen, dass die verschiedenen Teile eines Computers effektiv zusammenarbeiten. Was repräsentiere ich?"
        ],
        answer: "Chipsatz",
      ),
      Questions(
        question: [
          "Ich bestimme, wie schnell eine CPU Operationen ausführen kann. Je höher meine Frequenz, desto schneller kann die CPU arbeiten.",
          "Messbar in Hertz, repräsentiere ich die Anzahl der Schwingungen pro Sekunde, die die CPU durchführt. Was bin ich?",
          "Meine Geschwindigkeit beeinflusst die Leistungsfähigkeit eines Computers. Je höher ich bin, desto schneller können Befehle verarbeitet werden.",
          "Ich bin ein entscheidender Faktor für die Effizienz und Geschwindigkeit von Prozessen in einem Computer. Was misst man, um mich zu bestimmen?",
          "Programme und Anwendungen profitieren von einer höheren Version von mir, da sie dann schneller auf Befehle der CPU reagieren können. Was repräsentiere ich in der Welt der CPUs?"
        ],
        answer: "Taktrate",
      ),
      Questions(
        question: [
          "Wenn du mich zu stark erhöhst, kann dies zu einem kritischen Problem führen, bei dem die Temperatur der CPU übermäßig steigt.",
          "Beim Übertakten solltest du darauf achten, dass die Kühlung der CPU ausreichend ist, um ... zu vermeiden. Was ist das potenzielle Problem?",
          "Das Anheben meiner Leistungsfähigkeit kann zu einer intensiveren Wärmeentwicklung führen, was wiederum zu ... und instabiler Systemleistung führen kann. Wer bin ich?",
          "Bei zu viel Übertaktung kann die Kühlung des Systems nicht mehr effektiv genug sein, was zu Schäden an der CPU führen kann. Was ist die Gefahr hierbei?",
          "Um ... zu vermeiden, ist es wichtig, die Grenzen der CPU und die Möglichkeiten der Kühlung im Blick zu behalten, besonders bei experimentellem Übertakten. Welches Risiko besteht beim zu starken Übertakten?"
        ],
        answer: "Überhitzung",
      ),
      Questions(
        question: [
          "Diese Vorsichtsmaßnahmen sind entscheidend, um Unfälle und Schäden bei der Arbeit im Inneren eines Computers zu verhindern.",
          "Diese Regeln zielen darauf ab, Benutzer vor elektrischen Gefahren zu schützen und Schäden an Hardwarekomponenten zu minimieren.",
          "Diese Richtlinien betonen den sicheren Umgang mit empfindlichen Komponenten, um Schäden durch elektrostatische Entladungen zu vermeiden.",
          "Sie sind wichtig, um Verletzungen durch elektrischen Strom zu verhindern und sicherzustellen, dass Arbeiten am Computer ohne Risiken durchgeführt werden.",
          "Diese ... betreffen nicht nur den Schutz des Benutzers, sondern auch die Erhaltung der Integrität des Computersystems. Was umfassen diese Schutzmaßnahmen?"
        ],
        answer: "Sicherheitsregeln",
      ),
      Questions(
        question: [
          "Ich bin das Herz des Computers, bestehend aus Millionen oder sogar Milliarden von Transistoren. Was repräsentiere ich in der Welt der Hardware?",
          "Ich bin eine komplexe Einheit, die aus Transistoren besteht, um die Verarbeitungsgeschwindigkeit und Leistungsfähigkeit eines Computers zu gewährleisten. Wer oder was bin ich?",
          "Die Anzahl meiner Transistoren ist ein Maßstab für meine Komplexität und Verarbeitungsleistung. Was ist die entscheidende Struktur, die mich ausmacht?",
          "Mein Gehäuse dient nicht nur dazu, mich zu schützen, sondern auch, um die empfindlichen Transistoren vor äußeren Einflüssen zu bewahren. Was bin ich in einem Computer?",
          "Ich bestehe aus unzähligen Transistoren, die in einem Gehäuse untergebracht sind, um die grundlegende Recheneinheit eines Computers zu bilden. Wie nennt man diese zentrale Komponente?"
        ],
        answer: "Prozessor-Die",
      ),
      Questions(
        question: [
          "Ich bin eine der drei Hauptarten der Wärmeübertragung und beziehe mich auf den Transport von Wärme durch die Bewegung von Fluiden wie Gasen oder Flüssigkeiten. Was bin ich?",
          "Wenn du eine warme Luftblase aufsteigen siehst oder wenn Wasser in einem Topf erhitzt wird und zu zirkulieren beginnt, erlebst du meine Wirkung. Was repräsentiere ich in Bezug auf Wärmeübertragung?",
          "Mein Prinzip spielt eine entscheidende Rolle bei der Übertragung von Wärme in Flüssigkeiten und Gasen, da diese durch Temperaturunterschiede in Bewegung geraten. Was beschreibe ich?",
          "In einem Heizkörper oder einem Kühlsystem wird meine Wirkung genutzt, um Wärme zu transportieren und den Raum zu erwärmen oder abzukühlen. Wie nennt man dieses Prinzip der Wärmeübertragung?",
          "In der Atmosphäre spielt meine Wirkung eine Rolle bei der Verteilung von Wärme, insbesondere durch Auf- und Abwinde. Wie nennt man diese Art der Wärmeübertragung?"
        ],
        answer: "Konvektion",
      ),
      Questions(
        question: [
          "Ich bin eine der drei Hauptarten der Wärmeübertragung und beziehe mich auf die Übertragung von Wärmeenergie durch elektromagnetische Wellen. Was bin ich?",
          "Im Alltag erlebst du meine Wirkung, wenn du dich in der Sonne aufwärmst, da die Sonnenstrahlen meine Form der Wärmeübertragung nutzen. Wie nennt man diesen Prozess?",
          "Im Gegensatz zu Konduktion und Konvektion benötige ich keinen direkten Kontakt oder ein Medium, um Wärme zu übertragen. Was repräsentiere ich in Bezug auf die Übertragung von Wärme?",
          "Wärme, die von einem heißen Ofen oder einem elektrischen Heizelement ausgeht, nutzt meine Form der Wärmeübertragung. Wie nennt man dieses Prinzip?",
          "Wenn du dich vor einem Kamin wärmst und die Wärmeenergie in Form von Strahlen zu dir gelangt, erlebst du meine Wirkung. Wie nennt man dieses Prinzip der Wärmeübertragung?"
        ],
        answer: "Radiation",
      ),
      Questions(
        question: [
          "Ich bezeichne die Form der Wärmeübertragung, bei der Wärme von einem Körper auf einen benachbarten Körper übertragen wird. Was ist diese Art der Wärmeübertragung?",
          "Die ... erfolgt durch direkten Kontakt zwischen den Teilchen eines Körpers, wodurch Wärme von einem Ort zum anderen wandert. Welcher physikalische Prozess beschreibt diese Übertragung?",
          "In festen Materialien ist die .... besonders effizient, da die Teilchen eng beieinander liegen?",
          "Metalle sind gute Leiter für mich aufgrund ihrer freien Elektronen, die Wärme effizient transportieren?",
          "Ein Beispiel für .... ist das Erhitzen eines Metallstabs an einem Ende, wobei die Wärme durch den Stab wandert.",
        ],
        answer: "Konduktion",
      ),
      Questions(
        question: [
          "Ich bin eine Klasse von Materialien, die eine besondere Rolle in der Elektronik spielen und zwischen Leitern und Isolatoren liegen. Was bin ich?",
          "Ein wichtiges Merkmal von mir ist, dass meine elektrische Leitfähigkeit zwischen der von Metallen und Nichtmetallen liegt. Wie nennt man Materialien wie mich?",
          "In der Technologie werde ich oft verwendet, um Transistoren und andere elektronische Bauelemente herzustellen. Was repräsentiere ich in der Welt der Elektronik?",
          "Meine Eigenschaften ermöglichen es, elektronische Schaltungen zu steuern, was entscheidend für die moderne Computertechnologie ist. Welche Art von Material bin ich?",
          "Silizium ist das am häufigsten verwendete Material in meiner Kategorie und bildet die Grundlage vieler elektronischer Bauteile."
        ],
        answer: "Halbleiter",
      ),
      Questions(
        question: [
          "Ich bin ein winziges elektronisches Bauelement, das in der Lage ist, den Fluss von Elektronen zu steuern. Was bin ich, und wie bezeichnet man dieses grundlegende Element der Elektronik?",
          "Meine Hauptfunktion besteht darin, den elektrischen Strom zu verstärken oder zu schalten. Wie nennt man dieses elektronische Bauelement, das in vielen Geräten zu finden ist?",
          "Als Schlüsselelement in digitalen Schaltungen ermögliche ich die Umsetzung von Nullen und Einsen, was für die moderne Computertechnologie entscheidend ist. Wer oder was bin ich?",
          "Ich bestehe aus drei Schichten von Halbleitermaterialien – zwei unterschiedlich dotierten Schichten und einer neutralen Schicht. Wie nennt man dieses grundlegende Aufbauprinzip?",
          "In der Elektronik bin ich unverzichtbar, da ich als Schalter oder Verstärker in milliarden mal ... auf einem einzigen Computerchip agiere. Wie lautet mein Name, der meine Rolle in der Technologie beschreibt?"
        ],
        answer: "Transistor",
      ),
      Questions(
        question: [
          "Ich bin ein spezieller Zwischenspeicher in der CPU, der dazu dient, Anweisungen für den Prozessor bereitzustellen. Was bin ich, und wie bezeichnet man diesen Bereich in der Computerarchitektur?",
          "Meine Hauptaufgabe besteht darin, die Geschwindigkeit der Datenzugriffe zu erhöhen, indem ich häufig verwendete Anweisungen und Daten in unmittelbarer Nähe zur CPU speichere. Welchen Zweck erfülle ich in der Prozessorarchitektur?",
          "Ich bin in verschiedene Stufen aufgeteilt, darunter L1, L2 und L3, um den Zugriff auf Daten mit unterschiedlichen Geschwindigkeiten zu optimieren. Wie nennt man mich, und was repräsentieren diese Stufen?",
          "Prozessoren greifen auf mich zu, um häufig verwendete Daten schneller verfügbar zu haben, was die Gesamtleistung des Systems verbessert. Welchen Namen trage ich, der meine Rolle in der Datenverarbeitung beschreibt?",
          "Ich bin ein entscheidender Bestandteil moderner Prozessorarchitekturen und spiele eine Schlüsselrolle bei der Optimierung der Rechenleistung, indem ich den Datenzugriff beschleunige. Wie lautet meine Bezeichnung in Bezug auf die CPU?"
        ],
        answer: "CPU-Cache",
      ),
      Questions(
        question: [
          "Ich beziehe mich auf den Prozess der Herstellung von Computerchips und bestimme die Größe der kleinsten strukturierten Elemente auf einem Chip. Was bin ich, und welche Bedeutung habe ich für die Chipproduktion?",
          "In der Chip-Herstellung repräsentiere ich die Technologie, die die Strukturgröße der Elemente auf einem Chip in Nanometern angibt. Wie nennt man diesen entscheidenden Aspekt des Fertigungsprozesses?",
          "Kleinere Strukturgrößen, die durch mich ermöglicht werden, führen zu einer höheren Leistung und Energieeffizienz von Computerchips. Wie beschreibt man diesen Effekt im Zusammenhang mit meiner Bezeichnung?",
          "In spezialisierten Einrichtungen, auch als Halbleiterfabriken oder Fabs bekannt, findet der Fertigungsprozess von Computerchips, einschließlich meiner Parameter, statt. Welche Prozesse charakterisieren die Produktion in diesen Einrichtungen?",
          "Ich repräsentiere die Technologie, die es ermöglicht, mehr Transistoren auf einem Chip unterzubringen, was die Grundlage für die Steigerung der Rechenleistung bildet. Welche Zahl, oft in Nanometern angegeben, definiert meine Größe?"
        ],
        answer: "Fertigungsprozess",
      ),
      Questions(
        question: [
          "Ich bin ein kompakt verbautes und mobiles Gerät, das eine tragbare Alternative zu Desktop-Computern darstellt. Was bin ich, und welche Merkmale charakterisieren meine Bauweise?",
          "Meine Mobilität ermöglicht es Benutzern, ihre Arbeit an verschiedenen Orten durchzuführen, und ich bin mit einer eingebauten Tastatur, einem Trackpad oder einem Fingerknubbel sowie einem Akku ausgestattet. Was repräsentiere ich in der Welt der tragbaren Computer?",
          "Als vielseitiges Gerät laufe ich in der Regel auf Windows OEM und bediene verschiedene Anwendungsbereiche, darunter Office-Anwendungen, Multimedia, Gaming und Business-Anwendungen. Welche Art von tragbarem Computer bin ich?",
          "Ich bin in der Lage, eine Vielzahl von Anwendungen zu unterstützen, darunter das Surfen im Internet, das Ansehen von Filmen und das Hören von Musik. Wie nennt man meine Fähigkeit, unterschiedliche Aufgaben zu bewältigen?",
          "In Bezug auf meine Größe, Mobilität und vielseitige Anwendung bin ich ein handliches Gerät, das sich sowohl für den privaten als auch den geschäftlichen Gebrauch eignet. Wie nennt man mich, wenn ich als leicht transportierbarer Computer in Erscheinung trete?"
        ],
        answer: "Notebook",
      ),
      Questions(
        question: [
          "Ich bin ein tragbares Kommunikationsgerät, das Funktionen eines Mobiltelefons mit zahlreichen anderen Anwendungen kombiniert. Was bin ich, und welches Gerät repräsentiere ich in der modernen Technologie?",
          "Meine Hauptfunktionen umfassen das Telefonieren, das Senden von Textnachrichten und das Surfen im Internet. Welche Art von Gerät bin ich, das eine zentrale Rolle im Bereich der mobilen Kommunikation spielt?",
          "Mit einem Touchscreen-Display ausgestattet, ermögliche ich den Zugriff auf eine Vielzahl von Anwendungen, darunter soziale Medien, Spiele, Navigation und mehr. Welches handliche Gerät repräsentiere ich?",
          "Ich basiere auf einem Betriebssystem wie Android oder iOS und bin mit verschiedenen Sensoren ausgestattet, darunter Kameras, Beschleunigungsmesser und GPS. Welche Bezeichnung trifft auf mich zu, wenn ich als intelligentes Kommunikationsgerät agiere?",
          "Als All-in-One-Gerät kombiniere ich Telefonie, Internetzugang, Kamerafunktionen und zahlreiche Apps in einem kompakten Design. Wie nennt man mich, wenn ich als handliches und multifunktionales Gerät bekannt bin?"
        ],
        answer: "Smartphone",
      ),
      Questions(
        question: [
          "Ich bin ein stationäres Computersystem, das aus einem Gehäuse besteht und auf einem Schreibtisch platziert wird. Was bin ich, und welche Funktion repräsentiere ich im Bereich der persönlichen Computertechnologie?",
          "Im Gegensatz zu tragbaren Geräten bin ich nicht mobil, aber ich zeichne mich durch leistungsstarke Hardwarekomponenten aus und ermögliche eine umfassende Erweiterbarkeit. Welches Computersystem beschreibe ich?",
          "Meine Hauptkomponenten umfassen einen zentralen Prozessor, Arbeitsspeicher, Massenspeicher und eine Grafikkarte, die in einem festen Gehäuse integriert sind. Wie nennt man mich, wenn ich als zentrale Recheneinheit in einem festen System agiere?",
          "Ich eigne mich besonders gut für anspruchsvolle Anwendungen und Spiele, da ich aufgrund meines festen Standorts leistungsstarke Hardwarekomponenten aufnehmen kann. Welche Art von Computersystem repräsentiere ich?",
          "Im Vergleich zu mobilen Geräten zeichne ich mich durch eine höhere Rechenleistung und Erweiterbarkeit aus. Wie nennt man mich, wenn ich als leistungsfähiges und vielseitiges Computersystem für den Schreibtisch gelte?"
        ],
        answer: "Desktop-PC",
      ),
      Questions(
        question: [
          "Ich bin ein flaches, tragbares Gerät mit einem Touchscreen-Display, das sich durch Handlichkeit und Mobilität auszeichnet. Was bin ich, und welche Kategorie mobiler Geräte repräsentiere ich?",
          "Meine Bedienung erfolgt hauptsächlich über den Touchscreen, und ich bin ideal für den Konsum von Medien, das Surfen im Internet und das Lesen von digitalen Inhalten geeignet. Welches kompakte Gerät beschreibe ich?",
          "Im Gegensatz zu Laptops fehlt mir eine physische Tastatur, und meine Eingabe erfolgt durch Berühren des Bildschirms oder den Anschluss von externen Eingabegeräten. Welches Gerät repräsentiere ich, das sich durch seine einfache Handhabung auszeichnet?",
          "Ich basiere auf einem mobilen Betriebssystem wie Android oder iOS und eigne mich besonders gut für unterwegs, da ich leicht und handlich bin. Wie nennt man mich, wenn ich als vielseitiges Multimedia-Gerät bekannt bin?",
          "Ich bin ein Teil der Kategorie von Geräten, die zwischen Smartphones und Laptops positioniert sind, und zeichne mich durch Portabilität und Vielseitigkeit aus. Wie lautet meine Bezeichnung, wenn ich als tragbares Touchscreen-Gerät auftrete?"
        ],
        answer: "Tablet",
      ),


    ];
    questions_answer.shuffle();
    notifyListeners();
  }

  Future increment_points(username,points,ip) async{
    var data  =   {
      "action": "increment_points",
      "code": lobby_code,
      "username": username,
      "points": points
    };
    await connect_to_ws(ip).then((channel) {
      channel.sink.add(jsonEncode(data));
      channel.sink.close();
    });
  }

  Future clear_prefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future bool_user_name_given_set_to_false () async {
    bool_user_name_given = false;
    notifyListeners();
  }

  Future check_connection (ip) async {
    connected = false;
    notifyListeners();
    var data  =   {
      "action": "check_connection",
    };
    await connect_to_ws(ip).then((channel) {
      channel.sink.add(jsonEncode(data));
      channel.sink.close();
    });
  }



}



class Users {
  String name;
  String role;
  int points;

  Users({required this.name,required this.role,required this.points});

}


class Questions {
  List question;
  String answer;
  Questions({required this.question,required this.answer});
}





