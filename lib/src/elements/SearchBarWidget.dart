import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../elements/SearchWidget.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged onClickFilter;

  const SearchBarWidget({Key key, this.onClickFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(SearchModal());
      },
      child: Container(

        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(

            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            Expanded(
              child: Text(
                S.of(context).search_for_restaurants_or_foods,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 12,color: Colors.grey)),
              ),
            ),
            SizedBox(width: 8),
            InkWell(
              onTap: () {
                onClickFilter('e');
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(222)),
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [

                    Icon(
                      Icons.filter_alt,
                      color: Theme.of(context).hintColor,
                      size: 21,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
