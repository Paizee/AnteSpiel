import 'dart:io';
import 'package:antespiel/Functions/Websocket.dart';
import 'package:antespiel/game.dart';
import 'package:antespiel/game_is_end.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'connection_infos.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {

    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();


  runApp(Phoenix(child: const Main()));
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<websocket>(
            create: (context) => websocket(),
          ),
        ],
        builder: (context, child) {
          return MaterialApp(
            home: const connection_infos(),
            theme: FlexThemeData.dark(
              scheme: FlexScheme.material,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 13,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 20,
                useTextTheme: true,
                alignedDropdown: true,
                useInputDecoratorThemeInDialogs: true,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: false,
              // To use the Playground font, add GoogleFonts package and uncomment
              // fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
          );

        });
  }
}


class Pageswitching extends StatefulWidget {
  const Pageswitching({super.key});

  @override
  State<Pageswitching> createState() => _PageswitchingState();
}

class _PageswitchingState extends State<Pageswitching> {
  PageController controller = PageController(initialPage: 1);
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      children: [
        const connection_infos(),
      ],
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
}




