import 'package:flutter/material.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class CategoriesCarouselWidget extends StatelessWidget {
  List<Category> categories;

  CategoriesCarouselWidget({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 110)
        : Container(
      height: 170,
       // padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: this.categories.length<3?this.categories.length:3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return new CategoriesCarouselItemWidget(
                  marginLeft: 0,
                  category: this.categories.elementAt(index),
                );
              },
            ));
  }
}
