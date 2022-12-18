import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turkey_app/src/models/menu_item.dart';
import '../helpers/helper.dart';

MenuItem menuItem;

Future<MenuItem> getMenuItems() async {
  Uri url = Helper.getUri('api/pages');
  http.Response response = await http.get(url);
  menuItem = MenuItem.fromJson(jsonDecode(response.body));
  print(menuItem.data);
  return menuItem;
}
