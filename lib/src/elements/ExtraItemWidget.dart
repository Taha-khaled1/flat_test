import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/extra.dart';

class ExtraItemWidget extends StatefulWidget {
  final Extra extra;
  final List<Extra> extras;
  final VoidCallback onChanged;
  final int i;
  final int isReq;

  ExtraItemWidget(
      {Key key, this.extra, this.onChanged, this.i, this.isReq, this.extras,})
      : super(key: key);

  @override
  _ExtraItemWidgetState createState() => _ExtraItemWidgetState();
}

class _ExtraItemWidgetState extends State<ExtraItemWidget>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  Animation<double> sizeCheckAnimation;
  Animation<double> rotateCheckAnimation;
  Animation<double> opacityAnimation;
  Animation opacityCheckAnimation;
  int index=-1;

  @override
  void initState() {
    print('${widget.extra.name} ${widget.extra.name}');
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween(begin: 0.0, end: 60.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    opacityAnimation = Tween(begin: 0.0, end: 0.5).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    opacityCheckAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    rotateCheckAnimation = Tween(begin: 2.0, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    sizeCheckAnimation = Tween<double>(begin: 0, end: 36).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    print('ghjkl;');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // if (widget.extra.checked) {
        //   animationController.reverse();
        // } else {
        //   animationController.forward();
        // }
        //
        // widget.extra.checked = !widget.extra.checked;
        // if (widget.isReq == 1) {
        //   if(widget.extra.checked){
        //     for(int i=0;i<widget.extras.length;i++){
        //       if(i!=widget.i){
        //         widget.extras[i].checked=false;
        //       }
        //     }
        //   }
        //   requierdMap[widget.extra.extraGroupId.toString()][0] =
        //       widget.extra.checked;
        // }
        // widget.onChanged();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Stack(
          //   alignment: AlignmentDirectional.center,
          //   children: <Widget>[
          //     Container(
          //       height: 30,
          //       width: 30,
          //       decoration: BoxDecoration(
          //         color: Theme.of(context).primaryColor,
          //         border: Border.all(
          //           width: 1,
          //         ),
          //         borderRadius: BorderRadius.all(Radius.circular(60)),
          //       ),
          //     ),
          //     // Container(
          //     //   height: 30,
          //     //   width: 30,
          //     //   decoration: BoxDecoration(
          //     //     border: Border.all(
          //     //       width: 1,
          //     //       color: Theme.of(context).accentColor,
          //     //     ),
          //     //     borderRadius: BorderRadius.all(Radius.circular(60)),
          //     //     color: Theme.of(context).primaryColor,
          //     //   ),
          //     //   // child: Transform.rotate(
          //     //   //   angle: rotateCheckAnimation.value,
          //     //   //   child: Icon(
          //     //   //     Icons.check,
          //     //   //     size: 20,
          //     //   //     color: Theme.of(context)
          //     //   //         .accentColor
          //     //   //         .withOpacity(opacityCheckAnimation.value),
          //     //   //   ),
          //     //   // ),
          //     // ),
          //   ],
          // ),
          SizedBox(width: 15),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.extra?.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        Helper.skipHtml(widget.extra.description),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Helper.getPrice(widget.extra.price, context,
                    style: Theme.of(context).textTheme.headline4),
              ],
            ),
          )
        ],
      ),
    );
  }
}
