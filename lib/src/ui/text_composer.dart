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
  final List<String> helpContent;

  TextComposer(
      {this.textController,
      this.textEditorChanged,
      this.handleSubmitted,
      this.isTextFieldEnabled,
      this.shouldShowTwinkleButton,
      this.handleTwinkleButton,
      this.helpContent});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildForIOS(context)
        : new IconTheme(
            data: new IconThemeData(color: Theme.of(context).accentColor),
            child: new Container(
              height: 50,
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: new Row(
                children: <Widget>[
                  new Container(
                      child: new IconButton(
                          icon: new Icon(Icons.help),
                          onPressed: _handleFreeTextAndroid(context))),
                  new Flexible(
                      child: new TextField(
                    enabled: isTextFieldEnabled,
                    controller: textController,
                    onChanged: textEditorChanged,
                    onSubmitted: handleSubmitted,
                    style: TextStyle(fontSize: 16, fontFamily: 'QuickSand'),
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
        margin: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: CupertinoTextField.borderless(
              prefix: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  CupertinoIcons.question_circle_fill,
                  size: 28,
                ),
                onPressed: _handleFreeTextiOS(context),
              ),
              suffix: shouldShowTwinkleButton
                  ? _buildTwinkleButton()
                  : CupertinoButton(
                      child:
                          Icon(CupertinoIcons.arrow_up_circle_fill, size: 28),
                      onPressed: _handleTextEntered()),
              style: TextStyle(
                  color: Colors.black, fontFamily: 'QuickSand', fontSize: 16),
              enabled: isTextFieldEnabled,
              controller: textController,
              onChanged: textEditorChanged,
              onSubmitted: handleSubmitted,
              placeholder: HINT_TEXT),
        ),
      ),
    );
  }

  Function _handleTextEntered() {
    return isTextFieldEnabled
        ? () => handleSubmitted(textController.text)
        : null;
  }

  Function _handleFreeTextAndroid(BuildContext context) {
    return isTextFieldEnabled
        ? () => showModalBottomSheet(
            elevation: 5,
            context: context,
            builder: (bCtx) {
              return SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: helpContent
                    .map((content) => TextButton(
                        onPressed: () {
                          _enterFreeText(content, context);
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            content,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16),
                          ),
                        )))
                    .toList(),
              ));
            })
        : null;
  }

  Function _handleFreeTextiOS(BuildContext context) {
    return isTextFieldEnabled
        ? () => showCupertinoModalPopup(
            useRootNavigator: false,
            context: context,
            builder: (ctx) {
              return CupertinoActionSheet(
                  cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                          const Text(CANCEL, style: TextStyle(fontSize: 16))),
                  actions: helpContent
                      .map((content) => CupertinoActionSheetAction(
                          onPressed: () {
                            _enterFreeText(content, context);
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              content,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16),
                            ),
                          )))
                      .toList());
            })
        : null;
  }

  void _enterFreeText(String content, BuildContext context) {
     textController.text = content;
    Navigator.of(context).pop();
  }
}
