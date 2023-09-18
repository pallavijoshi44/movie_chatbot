import 'package:flutter/material.dart';
import 'package:flutter_app/src/ui/rating_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieInformationWidget extends StatelessWidget {
  MovieInformationWidget(
      {this.title,
      this.image,
      this.year,
      this.rating,
      this.duration,
      this.tagline,
      this.homePage});

  String? title = "";
  String? image = "";
  String? year = "";
  String? rating = "";
  String? duration = "";
  String? tagline = "";
  String? homePage = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: GestureDetector(
              onTap: isValid(this.homePage)
                  ? () {
                      _openWebView(context, this.homePage);
                    }
                  : null,
              child: image == null && image != ""
                  ? Image.asset(
                      'assets/images/placeholder.jpg',
                      fit: BoxFit.cover,
                      height: 180,
                    )
                  : Image.network(
                      image!,
                      fit: BoxFit.cover,
                      height: 180,
                    ),
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(this.title ?? "",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'QuickSand',
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 5.0,
                  ),
                  Visibility(
                    visible: isValid(this.tagline),
                    child: Text(this.tagline ?? "",
                        style: TextStyle(
                            color: Colors.green[900],
                            fontFamily: 'QuickSand',
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal)),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  if (isValid(this.year))
                    Visibility(
                      visible: isValid(this.year),
                      child: Text(this.year!,
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'QuickSand',
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  SizedBox(
                    height: 5.0,
                  ),
                  if (isValid(this.rating))
                    Visibility(
                        visible: isValid(this.rating),
                        child: RatingWidget(
                          rating: this.rating,
                          centerAlignment: false,
                        )),
                  SizedBox(
                    height: 5.0,
                  ),
                  if (isValid(this.duration))
                    Visibility(
                      visible: isValid(this.duration),
                      child: Text(this.duration!,
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontFamily: 'QuickSand',
                              fontSize: 14)),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool isValid(String? item) => item != null && item.isNotEmpty;

  Future<void> _openWebView(BuildContext context, String? url) async {
    if (url != null && await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
