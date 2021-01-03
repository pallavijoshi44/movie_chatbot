import 'package:flutter/material.dart';

class MovieProvider extends StatelessWidget {
  MovieProvider({this.title, this.logos});

  final String title;
  final List<dynamic> logos;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Text(''),
              backgroundColor: Colors.transparent,
            ),
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                  margin: const EdgeInsets.only(top: 5.0),
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
                      ])))
        ]));
  }
}
// Container(
// margin: const EdgeInsets.symmetric(vertical: 10.0),
// child: new Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Expanded(
// child:
// new Text(this.title, style: Theme.of(context).textTheme.title),
// ),
// Container(
// margin: const EdgeInsets.only(left: 16.0),
// child: Wrap(
// alignment: WrapAlignment.spaceAround,
// direction: Axis.horizontal,
// children: this.logos.map((logo) {
// return DecoratedBox(
// decoration: BoxDecoration(
// image: DecorationImage(
// image: AssetImage(logo))));
// }).toList(),
// ),
// ),
// ],
// ),
// );

/*
 Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: Wrap(
                      alignment: WrapAlignment.spaceAround,
                      direction: Axis.horizontal,
                      children: this.logos.map((logo) {
                        return DecoratedBox(
                            decoration: BoxDecoration(
                                image:
                                    DecorationImage(image: AssetImage(logo))));
                      }).toList(),
                    ),
                  ),
 */
