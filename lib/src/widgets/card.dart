import 'package:agro_farm/src/styles/base.dart';
import 'package:agro_farm/src/styles/colors.dart';
import 'package:agro_farm/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppCard extends StatelessWidget {
  final String productName;
  final String unitType;
  final int availableUnits;
  final double price;
  final String note;
  final String imageUrl;

  final formatCurrency = NumberFormat.simpleCurrency(locale: 'hi_IN');

  AppCard({
    @required this.productName,
    @required this.unitType,
    @required this.price,
    @required this.availableUnits,
    this.imageUrl,
    this.note = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: BaseStyles.listPadding,
      padding: BaseStyles.listPadding,
      decoration: BoxDecoration(
        boxShadow: BaseStyles.boxShadow,
        color: Colors.white,
        border: Border.all(
          color: AppColors.darkBlue,
          width: BaseStyles.borderwidth,
        ),
        borderRadius: BorderRadius.circular(BaseStyles.borderradius),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 5.0),
                child: (imageUrl != null && imageUrl != '')
                    ? ClipRRect(
                        child: Image.network(
                          imageUrl,
                          height: 80.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    : Image.asset(
                        'assets/images/vegetables.png',
                        height: 90.0,
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productName, style: TextStyles.subTitle),
                  Text('${formatCurrency.format(price)}/$unitType',
                      style: TextStyles.body),
                  (availableUnits > 0)
                      ? Text('In Stock', style: TextStyles.bodyLightBlue)
                      : Text('Currently Unavailable',
                          style: TextStyles.bodyRed),
                ],
              ),
            ],
          ),
          Text(
            note,
            style: TextStyles.body,
          ),
        ],
      ),
    );
  }
}
