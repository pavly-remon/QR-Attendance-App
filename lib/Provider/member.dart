import 'package:flutter/widgets.dart';
import 'package:qr_attendance/Provider/googlesheets.dart';

class Member {
  String id = '';
  String name;
  int attendance;
  bool scanned;

  Member({
    this.id = '',
    required this.name,
    required this.attendance,
    this.scanned = false,
  });
  static Member fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['ID'],
      name: json['Name'],
      attendance: int.parse(json['Attendance']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': this.id,
      'Name': this.name,
      'Attendance': this.attendance,
    };
  }
}

class Domain with ChangeNotifier {
  List<Member> members = [];

  Future<void> fetchData() async {
    await UserSheetsApi.getAll().then((values) {
      members = values;
      notifyListeners();
    });
  }

  String getName(String code) {
    final index = members.indexWhere((element) => element.id == code);
    if (index == -1)
      return 'Unknown';
    else
      return members[index].name;
  }
}
