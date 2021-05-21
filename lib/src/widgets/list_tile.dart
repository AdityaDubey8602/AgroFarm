import 'package:agro_farm/src/styles/base.dart';
import 'package:agro_farm/src/styles/colors.dart';
import 'package:agro_farm/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppListTile extends StatelessWidget {
  final String month;
  final String date;
  final String title;
  final String location;
  final bool acceptingOrders;
  final String marketId;

  AppListTile({
    @required this.month,
    @required this.date,
    @required this.title,
    @required this.location,
    @required this.marketId,
    this.acceptingOrders = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: AppColors.lightBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  date,
                  style: TextStyles.buttonTextLight,
                ),
              ],
            ),
          ),
          title: Text(
            title,
            style: TextStyles.subTitle,
          ),
          subtitle: Text(location),
          trailing: (acceptingOrders)
              ? Icon(
                  FontAwesomeIcons.shoppingBasket,
                  color: AppColors.darkBlue,
                )
              : Text(''),
          onTap: (acceptingOrders)
              ? () => Navigator.of(context).pushNamed('/customer/$marketId')
              : null,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: BaseStyles.listFieldHorizontal),
          child: Divider(
            color: AppColors.lightGrey,
          ),
        ),
      ],
    );
  }
}
