import 'package:flutter/material.dart';

class MovieProvider extends StatelessWidget {
  MovieProvider({this.title, this.logos});

  final String title;
  final List<dynamic> logos;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: Image.asset('assets/icon/app_icon.png', width: 30, height: 30, fit: BoxFit.cover,),
      ),
      Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 60),
          decoration: BoxDecoration(
            color: Colors.lightGreen[200],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
          ),
          margin: const EdgeInsets.only(top: 15.0),
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.title),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                    runSpacing: 10.0,
                    spacing: 10.0,
                    alignment: WrapAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: this.logos.map((logo) {
                      return Image.network(
                        logo,
                        fit: BoxFit.cover,
                        width: 50.0,
                        height: 50.0,
                      );
                    }).toList()),
              ]))
    ]));
  }
}
