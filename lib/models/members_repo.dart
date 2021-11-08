import 'package:qr_attendance/utils/googlesheets.dart';

import 'member.dart';

class MemberRepository {
  static List<Member> members = [];

  MemberRepository() {
    Future.delayed(Duration.zero, () async {
      UserSheetsApi.init().then((value) async {
        await UserSheetsApi.getAll().then((values) {
          members = values;
        });
      });
    }).catchError((e) {
      print('Data not loaded');
    });
  }

  static Future<void> updateMembers(String code) async {
    var headers = UserSheetsApi.headerRow;
    String now = UserSheetsApi.now;
    int index = members.indexWhere((element) => element.id == code);
    if (index != -1 && !members[index].scanned) {
      members[index].scanned = !members[index].scanned;
      members[index].attendance[now] = "O";
      try {
        UserSheetsApi.insertValue('O', headers.length + 1, index + 2);
      } catch (e) {
        members[index].scanned = !members[index].scanned;
        members[index].attendance.remove(now);
      }
    }
  }
}
