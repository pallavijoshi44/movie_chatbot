import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class CarouselDialogSlider extends StatelessWidget {
  CarouselDialogSlider(this.carouselSelect);

  final CarouselSelect carouselSelect;

  @override
  Widget build(BuildContext context) {
    // List<Map<ItemCarousel, String>>
    final List<String> imageList =
        carouselSelect.items.map((item) => item.image.imageUri).toList();
    return Container(
        child: Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
          ),
          items: imageList
              .map((item) => Container(
                      child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(item,
                                fit: BoxFit.cover, width: 1000.0),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  '${carouselSelect.items[imageList.indexOf(item)].title}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ))).toList(),
        ),
      ],
    ));
  }
}
