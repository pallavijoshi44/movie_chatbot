import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../domain/constants.dart';

class TextComposer extends StatelessWidget {
  final TextEditingController textController;
  final Function textEditorChanged;
  final Function handleSubmitted;
  final bool isTextFieldEnabled;

  TextComposer(this.textController, this.textEditorChanged,
      this.handleSubmitted, this.isTextFieldEnabled);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildForIOS(context)
        : new IconTheme(
            data: new IconThemeData(color: Theme.of(context).accentColor),
            child: new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: new Row(
                children: <Widget>[
                  new Flexible(
                    child: new PlatformTextField(
                      enabled: isTextFieldEnabled,
                      controller: textController,
                      onChanged: textEditorChanged,
                      onSubmitted: handleSubmitted,material: (_, context) => MaterialTextFieldData(
                      decoration:
                          new InputDecoration.collapsed(hintText: HINT_TEXT)),
                    cupertino: (_, context) => CupertinoTextFieldData(placeholder: HINT_TEXT),),
                  ),
                  new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 4.0),
                      child: new PlatformIconButton(
                          icon: new Icon(Icons.send),
                          onPressed: isTextFieldEnabled
                              ? () => handleSubmitted(textController.text)
                              : null)),
                ],
              ),
            ),
          );
  }

  Widget _buildForIOS(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(50.0))),
      margin: const EdgeInsets.only(
          top: 8.0, bottom: 50.0, left: 20.0, right: 20.0),
      child: new Row(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(left: 8.0),
              child: CupertinoTextField.borderless(
                style: TextStyle(color: Colors.black,fontFamily: 'OpenSans', fontSize: 14),
                  enabled: isTextFieldEnabled,
                  controller: textController,
                  onChanged: textEditorChanged,
                  onSubmitted: handleSubmitted,
                  placeholder: HINT_TEXT),
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: isTextFieldEnabled
                  ? () => handleSubmitted(textController.text)
                  : null)
        ],
      ),
    );
  }
}
