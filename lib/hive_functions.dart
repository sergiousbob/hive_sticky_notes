
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_sticky_notes/hive_box.dart';


class HiveFunctions {

  static final userBox = Hive.box(userHiveBox);


  static createUser(Map data) {
    userBox.add(data);
  }


  static addAllUser(List data) {
    userBox.addAll(data);
  }


  static List getAllUsers() {
    final data =
        userBox.keys.map((key) {
          final value = userBox.get(key);
          return {"key": key, "title": value["title"], "body": value['body']};
        }).toList();

    return data.reversed.toList();
  }


  static Map getUser(int key) {
    return userBox.get(key);
  }


  static updateUser(int key, Map data) {
    userBox.put(key, data);
  }


  static deleteUser(int key) {
    return userBox.delete(key);
  }


  static deleteAllUser(int key) {
    return userBox.deleteAll(userBox.keys);
  }
}