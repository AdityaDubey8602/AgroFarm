import 'dart:async';
import 'dart:io';

import 'package:agro_farm/src/blocs/auth_bloc.dart';
import 'package:agro_farm/src/blocs/vendor_bloc.dart';
import 'package:agro_farm/src/styles/tabBar.dart';
import 'package:agro_farm/src/widgets/navbar.dart';
import 'package:agro_farm/src/widgets/orders.dart';
import 'package:agro_farm/src/widgets/products.dart';
import 'package:agro_farm/src/widgets/profile.dart';
import 'package:agro_farm/src/widgets/vendor_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Vendor extends StatefulWidget {
  @override
  _VendorState createState() => _VendorState();

  static TabBar get vendorTabBar {
    return TabBar(
      unselectedLabelColor: TabBarStyles.unselectedLabelColor,
      labelColor: TabBarStyles.labelColor,
      indicatorColor: TabBarStyles.indictorColor,
      tabs: [
        Tab(icon: Icon(Icons.list)),
        Tab(icon: Icon(Icons.shopping_cart)),
        Tab(icon: Icon(Icons.person)),
      ],
    );
  }
}

class _VendorState extends State<Vendor> {
  StreamSubscription _userSubscription;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final authBloc = Provider.of<AuthBloc>(context, listen: false);
      final vendorBloc = Provider.of<VendorBloc>(context, listen: false);
      vendorBloc
          .fetchVendor(authBloc.userId)
          .then((vendor) => vendorBloc.changeVendor(vendor));
      _userSubscription = authBloc.user.listen((user) {
        if (user == null)
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              AppNavbar.cupertinoNavBar(title: 'Vendor Name', context: context),
            ];
          },
          body: VendorScaffold.cupertinoTapScaffold,
        ),
      );
    } else {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  AppNavbar.materialNavbar(
                      title: 'Vendor Name', tabBar: Vendor.vendorTabBar)
                ];
              },
              body: TabBarView(children: [
                Products(),
                Orders(),
                Profile(),
              ]),
            ),
          ));
    }
  }
}
