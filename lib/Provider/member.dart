import 'package:flutter/widgets.dart';
import 'package:qr_attendance/Provider/googlesheets.dart';

class Member {
  String id = '';
  String name;

  Member({
    this.id = '',
    required this.name,
  });
  static Member fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['ID'],
      name: json['Name'],
    );
  }
}

class Domain with ChangeNotifier {
  List<Member> _members = [];

  List<Member> getMembers() {
    return _members;
  }

  Future<void> fetchData() async {
    await UserSheetsApi.getAll().then((values) {
      _members = values;
    });
  }

  String getName(String code) {
    final index = _members.indexWhere((element) => element.id == code);
    if (index == -1)
      return 'Unknown';
    else
      return _members[index].name;
  }
}
