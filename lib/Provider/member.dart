import 'package:flutter/widgets.dart';
import 'package:qr_attendance/Provider/googlesheets.dart';

class Member {
  String id = '';
  String name;
  Map<String, String> attendance;

  Member({
    this.id = '',
    required this.name,
    required this.attendance,
  });
  static Member fromJson(Map<String, dynamic> json) {
    String id = json['ID'];
    String name = json['Name'];
    json.remove('ID');
    json.remove('Name');
    return Member(
<<<<<<< HEAD
      id: id,
      name: name,
      attendance: json as Map<String, String>,
=======
      id: json['ID'],
      name: json['Name'],
      attendance: int.parse(json['Attendance']),
>>>>>>> origin/main
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, String> json = this.attendance;
    json['ID'] = this.id;
    json['Name'] = this.name;
    return json;
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
