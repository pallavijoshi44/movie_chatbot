import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twinkle_button/twinkle_button.dart';

import '../domain/constants.dart';

class TextComposer extends StatefulWidget {
  final TextEditingController textController;
  final Function textEditorChanged;
  final Function handleSubmitted;
  final bool isTextFieldEnabled;
  final bool shouldShowTwinkleButton;
  final Function handleTwinkleButton;
  final List<String> helpContent;
  final bool helpContentClickable;

  TextComposer(
      {this.textController,
      this.textEditorChanged,
      this.handleSubmitted,
      this.isTextFieldEnabled,
      this.shouldShowTwinkleButton,
      this.handleTwinkleButton,
      this.helpContent,
      this.helpContentClickable});

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isTextFieldEnabled) focusNode.requestFocus();
    return Platform.isIOS ? _buildForIOS(context) : _buildForAndroid(context);
  }

  IconTheme _buildForAndroid(BuildContext context) {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        height: 50,
        decoration: new BoxDecoration(color: Theme.of(context).cardColor),
        padding: widget.helpContent.length > 0
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            if (widget.helpContent.length > 0)
              new Container(
                  child: new IconButton(
                      icon: new Icon(
                        Icons.help,
                        color: Colors.lightGreen[600],
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: _handleFreeTextAndroid(context))),
            new Flexible(
                child: new TextField(
              focusNode: focusNode,
              enabled: widget.isTextFieldEnabled,
              controller: widget.textController,
              onChanged: widget.textEditorChanged,
              onSubmitted: widget.handleSubmitted,
              style: TextStyle(fontSize: 16, fontFamily: 'QuickSand'),
              maxLines: null,
              decoration: new InputDecoration.collapsed(hintText: HINT_TEXT),
            )),
            new Container(
                child: widget.shouldShowTwinkleButton
                    ? _buildTwinkleButton()
                    : new IconButton(
                        icon: new Icon(
                          Icons.send,
                          color: Colors.lightGreen[600],
                        ),
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
          widget.handleTwinkleButton(widget.textController.text);
        });
  }

  Widget _buildForIOS(BuildContext context) {
    return new SafeArea(
      child: new Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: CupertinoTextField.borderless(
              focusNode: focusNode,
              padding: widget.helpContent.length > 0
                  ? EdgeInsets.zero
                  : EdgeInsets.all(15),
              prefix: widget.helpContent.length > 0
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      child:
                          Icon(CupertinoIcons.question_circle_fill, size: 28),
                      onPressed: _handleFreeTextiOS(context),
                    )
                  : null,
              suffix: widget.shouldShowTwinkleButton
                  ? _buildTwinkleButton()
                  : CupertinoButton(
                      child:
                          Icon(CupertinoIcons.arrow_up_circle_fill, size: 28),
                      onPressed: _handleTextEntered()),
              style: TextStyle(
                  color: Colors.black, fontFamily: 'QuickSand', fontSize: 16),
              enabled: widget.isTextFieldEnabled,
              controller: widget.textController,
              onChanged: widget.textEditorChanged,
              onSubmitted: widget.handleSubmitted,
              placeholder: HINT_TEXT),
        ),
      ),
    );
  }

  Function _handleTextEntered() {
    return widget.isTextFieldEnabled
        ? () => widget.handleSubmitted(widget.textController.text)
        : null;
  }

  Function _handleFreeTextAndroid(BuildContext context) {
    return widget.isTextFieldEnabled
        ? () => showModalBottomSheet(
            elevation: 5,
            context: context,
            builder: (bCtx) {
              return SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.helpContent
                    .map((content) => TextButton(
                          onPressed: widget.helpContentClickable
                              ? () {
                                  _enterFreeText(content, context);
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                content,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'QuickSand'),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ));
            })
        : null;
  }

  Function _handleFreeTextiOS(BuildContext context) {
    return widget.isTextFieldEnabled
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
                  actions: widget.helpContent
                      .map((content) => CupertinoActionSheetAction(
                          onPressed: widget.helpContentClickable
                              ? () {
                                  _enterFreeText(content, context);
                                }
                              : null,
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
    widget.textController.text = content;
    Navigator.of(context).pop();
    focusNode.requestFocus();
  }
}
