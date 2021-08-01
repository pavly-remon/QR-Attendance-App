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
  List<Member> _members = [];

  List<Member> getMembers() {
    return _members;
  }

  Future<void> fetchData() async {
    await UserSheetsApi.getAll().then((values) {
      _members = values;
      notifyListeners();
    });
  }

  String getName(String code) {
    final index = _members.indexWhere((element) => element.id == code);
    if (index == -1)
      return 'Unknown';
    else
      return _members[index].name;
  }

  bool isScanned(String code) {
    final index = _members.indexWhere((element) => element.id == code);
    if (_members[index].scanned)
      return true;
    else {
      _members[index].scanned = true;
      return false;
    }
  }

  bool updateData(String code) {
    final index = _members.indexWhere((element) => element.id == code);
    if (index == -1)
      return false;
    else {
      _members[index].attendance += 1;
      notifyListeners();
      return true;
    }
  }
}
