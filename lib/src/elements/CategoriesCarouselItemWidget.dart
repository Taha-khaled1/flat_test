import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CategoriesCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  Category category;

  CategoriesCarouselItemWidget({Key key, this.marginLeft, this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).pushNamed('/Category',
                      arguments: RouteArgument(id: category.id));
                },
                child: Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          category.image.icon,
                        ),
                      )),
                )),
            SizedBox(height: 5),
            Text(
              category.name,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, fontFamily: "ElMessiri-Bold"),
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow[700],
                  size: 15,
                ),
                Text(
                  '4.5',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

// Widget s() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: <Widget>[
//       // Hero(
//       // tag: category.id,
//       // child:
//       Container(
//         margin: EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
//         width: 110,
//         height: 110,
//         decoration: BoxDecoration(
//             color: Theme.of(context).primaryColor,
//             borderRadius: BorderRadius.all(Radius.circular(30)),
//             boxShadow: [
//               BoxShadow(
//                   color: Theme.of(context).focusColor.withOpacity(0.2),
//                   offset: Offset(0, 2),
//                   blurRadius: 7.0)
//             ]),
//         // child: Padding(
//         //  padding: const EdgeInsets.all(15),
//         child: category.image.url.toLowerCase().endsWith('.svg')
//             ? SvgPicture.network(
//                 //Image.asset(
//                 category.image.url,
//                 fit: BoxFit.cover,
//                 //   color: Theme.of(context).accentColor,
//               )
//             : CachedNetworkImage(
//                 width: 110,
//                 height: 110,
//                 fit: BoxFit.fill,
//                 imageUrl: category.image.icon,
//                 placeholder: (context, url) => Image.asset(
//                   'assets/img/loading.gif',
//                   fit: BoxFit.cover,
//                 ),
//                 errorWidget: (context, url, error) => Icon(Icons.error),
//               ),
//         //),
//       ),
//       //),
//       SizedBox(height: 5),
//       Row(
//         children: [
//           Expanded(
//             child: Container(
//               alignment: Alignment.topRight,
//               margin:
//                   EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
//               child: Text(
//                 category.name,
//                 textDirection: TextDirection.rtl,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                     color: Colors.grey[800],
//                     fontSize: 13,
//                     fontFamily: "ElMessiri-Bold"),
//               ),
//             ),
//           ),
//         ],
//       )
//     ],
//   );
// }
}
