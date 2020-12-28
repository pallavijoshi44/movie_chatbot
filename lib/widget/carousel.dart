import 'package:flutter/material.dart';
import 'package:carousel_select_widget/carousel_select_widget.dart';

const List<String> kCurrenciesList = ['AUD', 'BRL', 'CAD', 'CNY', 'EUR', 'GBP', 'HKD', 'IDR', 'ILS', 'INR'];
const int kInitialPositionIndex = 0;
const Color kDarkBackgroundColor = Color(0xFF111428);
const Color kTurquoiseColor = Color(0xFF1abc9c);
const Color kMidnightBlue = Color(0xFF2c3e50);
const Color kActiveItemTextColor = Color(0xFF9b59b6);
const double kActiveItemFontSize = 20;
const double kPassiveItemFontSize = 20;
const double kHorizontalWidgetSize = 100.0;
const double kVerticalWidgetSize = 200.0;

class Carousel extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kDarkBackgroundColor,
        appBar: AppBar(
          title: Center(
              child: Text(
            'Carousel Select Widget Example',
          )),
          backgroundColor: kDarkBackgroundColor,
          elevation: 0,
        ),
        body: Center(
          child: Container(
            child: CarouselSelect(
              onChanged: (selectedValue) {
                print(selectedValue);
              },
              valueList: kCurrenciesList,
              backgroundColor: kDarkBackgroundColor,
              activeItemTextColor: kActiveItemTextColor,
              passiveItemsTextColor: kActiveItemTextColor.withOpacity(0.3),
              initialPosition: kInitialPositionIndex,
              scrollDirection: ScrollDirection.horizontal,
              activeItemFontSize: kActiveItemFontSize,
              passiveItemFontSize: kPassiveItemFontSize,
              height: kHorizontalWidgetSize,
            ),
          ),
        ),
      ),
    );
  }
}
