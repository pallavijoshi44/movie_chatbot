import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/ui/country/selection_list.dart';
import 'package:flutter_app/src/ui/country/support/code_countries_en.dart';
import 'package:flutter_app/src/ui/country/support/code_countrys.dart';

import 'country_selection_theme.dart';
import 'support/code_country.dart';

export 'country_selection_theme.dart';
export 'support/code_country.dart';

class CountryListPick extends StatefulWidget {
  CountryListPick(
      {required this.onChanged,
      required this.initialSelection,
      required this.appBar,
        this.pickerBuilder,
       this.countryBuilder,
      required this.theme,
      this.useUiOverlay = true,
      this.useSafeArea = false});

  final String initialSelection;
  final ValueChanged<CountryCode> onChanged;
  final PreferredSizeWidget appBar;
  final Widget? Function(BuildContext context, CountryCode countryCode)? pickerBuilder;
  final CountryTheme theme;
  final Widget? Function(BuildContext context, CountryCode countryCode)? countryBuilder;
  final bool useUiOverlay;
  final bool useSafeArea;

  @override
  _CountryListPickState createState() {
    List<Map> jsonList =
        this.theme.showEnglishName ?? true ? countriesEnglish : codes;

    List elements = jsonList
        .map((s) => CountryCode(
              name: s['name'],
              code: s['code'],
              dialCode: s['dial_code'],
              flagUri: 'assets/flags/${s['code'].toLowerCase()}.png',
            ))
        .toList();
    return _CountryListPickState(elements.first, elements);
  }
}

class _CountryListPickState extends State<CountryListPick> {
  CountryCode selectedItem;
  List elements = [];

  _CountryListPickState(this.selectedItem, this.elements);

  @override
  void initState() {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection),
          orElse: () => CountryCode(
              name: "India",
              dialCode: "+91",
              code: "IN",
              flagUri: 'assets/flags/in.png'));
    } else {
      selectedItem = CountryCode(
          name: "India",
          dialCode: "+91",
          code: "IN",
          flagUri: 'assets/flags/in.png');
    }

    super.initState();
  }

  void _awaitFromSelectScreen(BuildContext context, PreferredSizeWidget appBar,
      CountryTheme theme) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectionList(
            elements,
            selectedItem,
            appBar: widget.appBar,
            theme: theme,
            countryBuilder: widget.countryBuilder,
            useUiOverlay: widget.useUiOverlay,
            useSafeArea: widget.useSafeArea,
          ),
        ));

    setState(() {
      selectedItem = result ?? selectedItem;
      widget.onChanged(result ?? selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _awaitFromSelectScreen(context, widget.appBar, widget.theme);
      },
      child: widget.pickerBuilder != null
          ? widget.pickerBuilder!(context, selectedItem)!
          : Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.theme?.isShowFlag ?? true == true)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.asset(
                        selectedItem.flagUri,
                        width: 32.0,
                      ),
                    ),
                  ),
                if (widget.theme?.isShowCode ?? true == true)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(selectedItem.toString()),
                    ),
                  ),
                if (widget.theme?.isShowTitle ?? true == true)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(selectedItem.toCountryStringOnly(),
                          style: Platform.isIOS
                              ? CupertinoTheme.of(context)
                                  .textTheme
                                  .tabLabelTextStyle
                              : Theme.of(context).textTheme.displayLarge),
                    ),
                  ),
                if (widget.theme?.isDownIcon ?? true == true)
                  Flexible(
                    child: Icon(Icons.keyboard_arrow_down),
                  )
              ],
            ),
    );
  }
}
