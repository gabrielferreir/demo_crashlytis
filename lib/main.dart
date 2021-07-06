import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(MyApp());
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text('Error'));
              if (snapshot.connectionState == ConnectionState.done) {
                return Scaffold(
                    appBar: AppBar(),
                    body: Column(
                      children: [
                        ElevatedButton(
                          child: Text('CRASH'),
                          onPressed: () {
                            throw Exception('Teste');
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Future.delayed(Duration.zero,
                                    () => throw Exception('async error'));
                          },
                          child: Text('CRASH ASSINCRONO'),
                        ),
                      ],
                    ));
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
