import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CastDetails extends StatelessWidget {
  CastDetails({this.cast});

  final List<dynamic> cast;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cast',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontFamily: 'QuickSand',
                  fontWeight: FontWeight.bold),
            ),
            Container(
                height: 200.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: this
                      .cast
                      .map((item) => Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.only(right: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                item.profile == null
                                    ? Image.asset(
                                        'assets/images/person_placeholder.png',
                                        height: 130,
                                        width: 100,
                                        fit: BoxFit.fitHeight,
                                      )
                                    : Image.network(item.profile,
                                        height: 130,
                                        width: 100,
                                        fit: BoxFit.fitHeight),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 75,
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: Text(
                                    '${item.name}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontFamily: 'QuickSand'),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                )),
          ]),
    );
  }
}
