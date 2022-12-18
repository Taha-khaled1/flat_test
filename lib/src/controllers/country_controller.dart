import 'dart:convert';

import 'package:http/http.dart'as http;
class Helper{
  Future<Map> getData()async{
    String url="http://turkey.freelance-jo.cloud/system/api/countries";
    http.Response response=await http.get(   Uri.parse(url),);
    print(">>>>>>>>>>${jsonDecode(response.body)}");

    return jsonDecode(response.body);
  }
}
