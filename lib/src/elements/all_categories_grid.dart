import 'package:flutter/material.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class AllCategoriesGrid extends StatelessWidget {
  List<Category> categories;

  AllCategoriesGrid({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 110)
        : Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.1, color: Colors.black12)),
            child: GridView.builder(
              itemCount: this.categories.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return new CategoriesCarouselItemWidget(
                  marginLeft: 0,
                  category: this.categories.elementAt(index),
                );
              },
            ),
          );
  }
}
