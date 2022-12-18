import '../helpers/custom_trace.dart';

class ExtraGroup {
  String id;
  String name;
  int required;

  ExtraGroup();

  ExtraGroup.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      required=jsonMap['required'];
    } catch (e) {
      id = '';
      name = '';
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map['required']=required;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
