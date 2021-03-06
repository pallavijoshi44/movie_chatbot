import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class TextComposer extends StatelessWidget {
  final TextEditingController textController;
  final Function textEditorChanged;
  final Function handleSubmitted;
  final bool isTextFieldEnabled;

  TextComposer(this.textController, this.textEditorChanged,
      this.handleSubmitted, this.isTextFieldEnabled);

  @override
  Widget build(BuildContext context) {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                enabled: isTextFieldEnabled,
                controller: textController,
                onChanged: textEditorChanged,
                onSubmitted: handleSubmitted,
                decoration: new InputDecoration.collapsed(hintText: HINT_TEXT),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () => handleSubmitted(textController.text))),
          ],
        ),
      ),
    );
  }
}
