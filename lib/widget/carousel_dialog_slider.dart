import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/movie_webview.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class CarouselDialogSlider extends StatelessWidget {
  CarouselDialogSlider(this.carouselSelect);

  final CarouselSelect carouselSelect;

  _inform(BuildContext context, String movieName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MovieWebView(
                  url: 'https://flutter.dev',
                  movieName: movieName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imageList =
        carouselSelect.items.map((item) => item.image.imageUri).toList();
    return Container(
        child: Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 1.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
          ),
          items: imageList
              .map((item) => InkWell(
                    onTap: () => _inform(context,
                        '${carouselSelect.items[imageList.indexOf(item)].title}'),
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Flexible(
                            child: Container(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(item,
                                          fit: BoxFit.cover, width: 1000.0),
                                    ],
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                '${carouselSelect.items[imageList.indexOf(item)].title}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                '${carouselSelect.items[imageList.indexOf(item)].description}',
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    ));
  }
}
