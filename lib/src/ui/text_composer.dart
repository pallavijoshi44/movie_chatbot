import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twinkle_button/twinkle_button.dart';

import '../domain/constants.dart';

class TextComposer extends StatelessWidget {
  final TextEditingController textController;
  final Function textEditorChanged;
  final Function handleSubmitted;
  final bool isTextFieldEnabled;
  final bool shouldShowTwinkleButton;
  final Function handleTwinkleButton;

  TextComposer(
      {this.textController,
      this.textEditorChanged,
      this.handleSubmitted,
      this.isTextFieldEnabled,
      this.shouldShowTwinkleButton,
      this.handleTwinkleButton});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildForIOS(context)
        : new IconTheme(
            data: new IconThemeData(color: Theme.of(context).accentColor),
            child: new Container(
              height: 50,
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: new Row(
                children: <Widget>[
                  new Flexible(
                      child: new TextField(
                    enabled: isTextFieldEnabled,
                    controller: textController,
                    onChanged: textEditorChanged,
                    onSubmitted: handleSubmitted,
                    style: TextStyle(fontSize: 14, fontFamily: 'QuickSand'),
                    maxLines: null,
                    decoration:
                        new InputDecoration.collapsed(hintText: HINT_TEXT),
                  )),
                  new Container(
                      child: shouldShowTwinkleButton
                          ? _buildTwinkleButton()
                          : new IconButton(
                              icon: new Icon(Icons.send),
                              onPressed: _handleTextEntered())),
                ],
              ),
            ),
          );
  }

  TwinkleButton _buildTwinkleButton() {
    return TwinkleButton(
        buttonHeight: 30,
        buttonWidth: 60,
        buttonTitle: Text(
          'Send',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w300,
            fontSize: 14.0,
          ),
        ),
        buttonColor: Colors.green[100],
        onclickButtonFunction: () {
          handleTwinkleButton(textController.text);
        });
  }

  Widget _buildForIOS(BuildContext context) {
    return new SafeArea(
      child: new Container(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 10.0, left: 10.0, right: 0.0),
        child: new Row(
          children: <Widget>[
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 5.0, bottom: 5.0, left: 20.0, right: 0.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: CupertinoTextField.borderless(
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'QuickSand',
                        fontSize: 15),
                    enabled: isTextFieldEnabled,
                    controller: textController,
                    onChanged: textEditorChanged,
                    onSubmitted: handleSubmitted,
                    placeholder: HINT_TEXT),
              ),
            ),
            CupertinoButton(
                child: shouldShowTwinkleButton
                    ? _buildTwinkleButton()
                    : Icon(Icons.send),
                onPressed: _handleTextEntered())
          ],
        ),
      ),
    );
  }

  Function _handleTextEntered() {
    return isTextFieldEnabled
        ? () => handleSubmitted(textController.text)
        : null;
  }
}
