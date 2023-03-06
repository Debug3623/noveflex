import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_version_update/app_version_update.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:novelflex/TabScreens/home_screen.dart';
import 'package:novelflex/UserAuthScreen/SignUpScreens/SignUpScreen_Second.dart';
import 'package:novelflex/localization/Language/languages.dart';
import 'package:novelflex/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transitioner/transitioner.dart';
import 'package:workmanager/workmanager.dart';
import 'MixScreens/BooksScreens/BookDetailsAuthor.dart';
import 'Models/language_model.dart';
import 'Provider/UserProvider.dart';
import 'Provider/VariableProvider.dart';
import 'UserAuthScreen/login_screen.dart';
import 'UserAuthScreen/SignUpScreens/signUpScreen_First.dart';
import 'Utils/ApiUtils.dart';
import 'Utils/Constants.dart';
import 'Utils/constant.dart';
import 'Utils/notification.dart';
import 'Utils/store_config.dart';
import 'Utils/toast.dart';
import 'firebase_options.dart';
import 'localization/locale_constants.dart';
import 'localization/localizations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

const fetchBackground = "fetchBackground";
BuildContext? context1;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}





Future<void> main() async {

  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {}
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appleStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {

    StoreConfig(
      store:  Store.googlePlay,
      apiKey:googleApiKey,
    );
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // if (Platform.isIOS || Platform.isMacOS) {
  //   StoreConfig(
  //     store: Store.appleStore,
  //     apiKey: Constants.appleApiKey,
  //   );
  // } else if (Platform.isAndroid) {
  //   StoreConfig(
  //     store:  Store.googlePlay,
  //     apiKey: Constants.googleApiKey,
  //   );
  // }

  runApp(Phoenix(child: MyApp(sharedPreferences: prefs)));


}


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title// description
  importance: Importance.high,
);


// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//
//     FlutterLocalNotificationsPlugin localNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//     var android = new AndroidInitializationSettings('@drawable/icon_notify');
//     var IOS = new IOSInitializationSettings();
//
//     var settings = new InitializationSettings(android: android, iOS: IOS);
//     localNotificationsPlugin.initialize(settings,
//         onSelectNotification: (payload) {
//           if (payload != null) {
//             onSelectNotification(payload);
//             debugPrint('notification payload: ' + payload);
//           }
//         });
//     localNotificationsPlugin.initialize(settings);
//     _showNotificationWithDefaultSound(localNotificationsPlugin);
//     return Future.value(true);
//   });
// }
//
//
// Future _showNotificationWithDefaultSound(notification) async {
//   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       importance: Importance.max,
//       priority: Priority.high
//   );
//   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//   var platformChannelSpecifics = new NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics
//   );
//   await notification.show(0, 'New Novel Published',
//       'See whats in new Manga',
//       platformChannelSpecifics, payload: 'Default_Sound'
//   );
// }
//
// Future onSelectNotification(String payload) async {
//   await Navigator.push(
//     context1!,
//     MaterialPageRoute(builder: (context) => HomeScreen()),
//   );
// }


class MyApp extends StatefulWidget {
  late SharedPreferences sharedPreferences;

  MyApp({super.key, required this.sharedPreferences});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }
}



class _MyAppState extends State<MyApp> {

  String? token;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_launcher');
    const iosInitializationSetting = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // defaultPresentAlert: true,
      // defaultPresentBadge: true,
      // defaultPresentSound: true
    );
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid,iOS:iosInitializationSetting);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                color: Colors.blue,
                icon: "@drawable/icon_notify",
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          // context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            }, context: context);
      }
    });

    setFCMToken();
  }



  setFCMToken() async {
    SharedPreferences prefts = await SharedPreferences.getInstance();
    token = Platform.isIOS ? await FirebaseMessaging.instance.getAPNSToken() : await FirebaseMessaging.instance.getToken();
    prefts.setString('fcm_token', token!);
    // String? tokenIOS = await FirebaseMessaging.instance.getAPNSToken();
    print(" token__ $token");
  }


  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<InternetConnectionStatus>(
      initialData: InternetConnectionStatus.connected,
      create: (_) {
        return InternetConnectionCheckerPlus().onStatusChange;
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
              create: (context) => UserProvider(widget.sharedPreferences)),
          ChangeNotifierProvider<VariableProvider>(
              create: (context) => VariableProvider()),
        ],
        child: FirebasePhoneAuthProvider(
          child: MaterialApp(
            locale: _locale,
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            debugShowCheckedModeBanner: false,
            home: SplashFirst(),
            routes: {
              // 'slider_screen': (context) => SliderScreen(),
              'tab_screen': (context) => TabScreen(),
              'login_screen': (context) => LoginScreen(),
            },
          ),
        ),
      ),
    );
  }


}


class SplashFirst extends StatefulWidget {
  const SplashFirst({Key? key}) : super(key: key);

  @override
  State<SplashFirst> createState() => _SplashFirstState();
}

class _SplashFirstState extends State<SplashFirst> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    super.initState();
    retrieveDynamicLink(context);
    expireToken();
    Timer(const Duration(seconds: 0), () {
      if (context.read<UserProvider>().UserToken == '' ||
          context.read<UserProvider>().UserToken == null
          || expireToken() >=13) {
        Transitioner(
          context: context,
          child: SplashPage(),
          animation: AnimationType.fadeIn, // Optional value
          duration: Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      } else {
        Transitioner(
          context: context,
          child: TabScreen(),
          animation: AnimationType.fadeIn, // Optional value
          duration: Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      }
    });
  }

  int expireToken(){
    final currentTime = DateTime.now();
    final savedTime =context.read<UserProvider>().GetSavedTime==null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(context.read<UserProvider>().GetSavedTime!);
    final diff_day = currentTime.difference(savedTime).inDays;
    print("days differences for expiry token $diff_day");

    return diff_day;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: const Color(0xffebf5f9),
        body: const Center(
          child: CupertinoActivityIndicator(
          ),
        )
    );
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    UserProvider userProvider =
    Provider.of<UserProvider>(this.context, listen: false);
    try {
      final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('referral_code')) {
          String? referral_code = deepLink.queryParameters['referral_code'];
          // Constants.showToastBlack(context, deepLink.queryParameters['referral_code']!);
          // context.watch<UserProvider>().setReferral(referral_code.toString());
          userProvider.setReferral(referral_code.toString());
          print("Referal_user_code${userProvider.GetReferral.toString()}");
          Transitioner(
            context: context,
            child: SignUpScreen_Second(ReferralUserID:deepLink.queryParameters['referral_code'],),
            animation: AnimationType.slideLeft, // Optional value
            duration: Duration(milliseconds: 1000), // Optional value
            replacement: true, // Optional value
            curveType: CurveType.decelerate, // Optional value
          );
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpScreen_Second(ReferralUserID:deepLink.queryParameters['referral_code'],)));
          print("referral_code = $referral_code");
          }

      }

      FirebaseDynamicLinks.instance.onLink;

    } catch (e) {
      print(e.toString());
    }
  }
}


class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().setLanguage('English');
      changeLanguage(context, 'en');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset('assets/quotes_data/bg_login.png',fit: BoxFit.fill,),
          ),
          Positioned(
            top: _height * 0.2,
            // left: _width*0.5,
            child: Image.asset('assets/quotes_data/NoPath.png'),
          ),
          Positioned(
            top: _height * 0.4,
            left: _width * 0.2,
            child: Container(
                width: 256,
                height: 2,
                decoration: BoxDecoration(color: const Color(0xff333333))),
          ),
          Positioned(
            top: _height * 0.45,
            left:context.read<UserProvider>().SelectedLanguage=='English' ? _width*0.1 : 0.0,
            right:context.read<UserProvider>().SelectedLanguage=='Arabic' ? _width*0.05 : 0.0,


            child: Text(Languages.of(context)!.labelWelcome,
                style: const TextStyle(
                    color: const Color(0xff101010),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Lato",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
                textAlign: TextAlign.center),
          ),
          Positioned(
              top: _height * 0.7,
              left: _width * 0.1,
              child: GestureDetector(
                onTap: (){
                  Transitioner(
                    context: context,
                    child: LoginScreen(),
                    animation: AnimationType.slideLeft, // Optional value
                    duration: Duration(milliseconds: 1000), // Optional value
                    replacement: true, // Optional value
                    curveType: CurveType.decelerate, // Optional value
                  );
                  },
                child: Container(
                  width: _width*0.83,
                  height: _height*0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x24000000),
                            offset: Offset(0, 7),
                            blurRadius: 14,
                            spreadRadius: 0)
                      ],
                      color: const Color(0xff3a6c83)),
                  child: Center(
                    child: Text(
                      Languages.of(context)!.login,
                      style: const TextStyle(
                          color:  const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Lato",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                    ),
                  ),
                ),
              )),
          Positioned(
            top: _height * 0.79,
            left: _width * 0.1,
            child: GestureDetector(
              onTap: (){
                 Transitioner(
                  context: context,
                  child: SignUpScreen_Second(ReferralUserID: "",),
                  animation: AnimationType.slideLeft, // Optional value
                  duration: Duration(milliseconds: 1000), // Optional value
                  replacement: true, // Optional value
                  curveType: CurveType.decelerate, // Optional value
                );
              },
              child: Container(
                width: _width*0.83,
                height: _height*0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xff3a6c83),
                      width: 2,
                    )),
                child: Center(
                  child: Text(
                    Languages.of(context)!.signup,
                    style: const TextStyle(
                        color: const Color(0xff3a6c83),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Lato",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: _height*0.05,
            left:context.read<UserProvider>().SelectedLanguage=='English' ? _width*0.8 : _width*0.02,
            child: GestureDetector(
              child: Column(
                children: [
                  Text(context.read<UserProvider>().SelectedLanguage=='English' ? "🇦🇪" : "🇺🇸", style: TextStyle(
                      fontSize: _width*_height*0.0001
                  ),),
                  Text(context.read<UserProvider>().SelectedLanguage=='English' ? "العربية": "English ", style: const TextStyle(
                      color:   Colors.black,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Lato",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  ),),

                ],
              ),
              onTap: () {
                UserProvider userProviderlng =
                Provider.of<UserProvider>(this.context, listen: false);
                if(userProviderlng.SelectedLanguage == 'English'){
                  userProviderlng.setLanguage('Arabic');
                  changeLanguage(context, 'ar');
                }else{
                  userProviderlng.setLanguage('English');
                  changeLanguage(context, 'en');
                }

              },
            ),
          ),
          Positioned(
            top: _height * 0.88,
            left: _width * 0.1,
            child: GestureDetector(
              onTap: (){
                Transitioner(
                  context: context,
                  child:HomeScreen(
                    route: "guest",
                  ),
                  animation: AnimationType.slideLeft, // Optional value
                  duration: Duration(milliseconds: 1000), // Optional value
                  replacement: false, // Optional value
                  curveType: CurveType.decelerate, // Optional value
                );
              },
              child: Container(
                width: _width*0.83,
                height: _height*0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xff3a6c83),
                      width: 2,
                    )),
                child: Center(
                  child: Text(
                    Languages.of(context)!.guest,
                    style: const TextStyle(
                        color: const Color(0xff3a6c83),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Lato",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
