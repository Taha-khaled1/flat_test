import 'package:flutter/material.dart';
import 'package:turkey_app/src/models/home_foods.dart';
import 'package:turkey_app/src/models/route_argument.dart';

class GridAllFoodInCategory extends StatefulWidget {
  final List<Foodies> foodies;

  GridAllFoodInCategory({this.foodies});

  @override
  _GridAllFoodInCategoryState createState() => _GridAllFoodInCategoryState();
}

class _GridAllFoodInCategoryState extends State<GridAllFoodInCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 230,
      child: ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.foodies.length < 6 ? widget.foodies.length : 3,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
              onTap: () {
                Navigator.of(context).pushNamed('/Food',
                    arguments: new RouteArgument(
                        id: widget.foodies[index].id.toString()));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width / 2.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: widget.foodies[index].media.isEmpty
                              ? AssetImage('assets/img/loading.gif')
                              : NetworkImage(
                                  widget.foodies[index].media[0].thumb),
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.foodies[index].name,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    widget.foodies[index].restaurant.name,
                    style: Theme.of(context).textTheme.caption,
                    overflow: TextOverflow.ellipsis,
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
