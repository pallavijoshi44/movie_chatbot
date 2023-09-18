import 'package:flutter/material.dart';

class CountryTheme {
  final String? searchText;
  final String? searchHintText;
  final String? lastPickText;
  final Color? alphabetSelectedBackgroundColor;
  final Color? alphabetTextColor;
  final Color? alphabetSelectedTextColor;
  final bool isShowTitle;
  final bool isShowFlag;
  final bool isShowCode;
  final bool isDownIcon;
  final String? initialSelection;
  final bool showEnglishName;
  //final void Function() systemUiOverlayStyle;

  CountryTheme({
    //this.systemUiOverlayStyle,
    this.searchText,
    this.searchHintText,
    this.lastPickText,
    this.alphabetSelectedBackgroundColor,
    this.alphabetTextColor,
    this.alphabetSelectedTextColor,
    required this.isShowTitle,
    required this.isShowFlag,
    required this.isShowCode,
    required this.isDownIcon,
    this.initialSelection,
    required this.showEnglishName,
  });
}