import 'dart:io';

import 'package:agro_farm/src/blocs/auth_bloc.dart';
import 'package:agro_farm/src/blocs/customer_bloc.dart';
import 'package:agro_farm/src/blocs/product_bloc.dart';
import 'package:agro_farm/src/blocs/vendor_bloc.dart';
import 'package:agro_farm/src/routes.dart';
import 'package:agro_farm/src/screens/landing.dart';
import 'package:agro_farm/src/screens/login.dart';
import 'package:agro_farm/src/services/firestore_service.dart';
import 'package:agro_farm/src/styles/colors.dart';
import 'package:agro_farm/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final authBloc = AuthBloc();
final productBloc = ProductBloc();
final customerBloc = CustomerBloc();
final vendorBloc = VendorBloc();
final firestoreService = FirestoreService();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider(create: (context) => authBloc),
      Provider(create: (context) => productBloc),
      Provider(create: (context) => customerBloc),
      Provider(create: (context) => vendorBloc),
      FutureProvider(create: (context) => authBloc.isLoggedIn()),
      StreamProvider(
        create: (context) => firestoreService.fetchUnitTypes(),
      )
    ], child: PlatFormApp());
  }

  @override
  void dispose() {
    authBloc.dispose();
    productBloc.dispose();
    customerBloc.dispose();
    vendorBloc.dispose();
    super.dispose();
  }
}

class PlatFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isLoggedIn = Provider.of<bool>(context);

    if (Platform.isIOS) {
      return CupertinoApp(
        title: 'Agrofarm',
        home: (isLoggedIn == null)
            ? loadingScreen(true)
            : (isLoggedIn == true)
                ? Landing()
                : Login(),
        onGenerateRoute: Routes.cupertinoRoute,
        theme: CupertinoThemeData(
          primaryColor: AppColors.straw,
          scaffoldBackgroundColor: Colors.white,
          textTheme: CupertinoTextThemeData(
            tabLabelTextStyle: TextStyles.suggestion,
          ),
        ),
      );
    } else {
      return MaterialApp(
        title: 'Agrofarm',
        home: (isLoggedIn == null)
            ? loadingScreen(false)
            : (isLoggedIn == true)
                ? Landing()
                : Login(),
        onGenerateRoute: Routes.materialRoute,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
      );
    }
  }

  Widget loadingScreen(bool isIOS) {
    return (isIOS)
        ? CupertinoPageScaffold(
            child: Center(
            child: CupertinoActivityIndicator(),
          ))
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
