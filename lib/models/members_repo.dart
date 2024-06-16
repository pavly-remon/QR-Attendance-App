import 'package:intl/intl.dart';
import 'package:qr_attendance/utils/googlesheets.dart';

import 'member.dart';

class MemberRepository {
  static List<Member> members = [];

  static Future<void> initialize(String docId) async {
    try {
      var value = await UserSheetsApi.init(docId);
      members = await UserSheetsApi.getAll();
    } catch (e) {
      throw e;
    }
  }

  static Future<void> updateMembers(String code) async {
    var headers = UserSheetsApi.headerRow;
    int index = members.indexWhere((element) => element.id == code);

    var epoch = new DateTime(1899, 12, 30); //gsheet refrence Date
    int diff = UserSheetsApi.now.difference(epoch).inDays;

    if (index != -1 &&
        !members[index].scanned &&
        members[index].attendance["${diff}"] != "O") {
      members[index].scanned = true;
      members[index].attendance["${diff}"] = "O";
      try {
        UserSheetsApi.insertValue('O', headers.length + 1, index + 2);
      } catch (e) {
        members[index].scanned = !members[index].scanned;
        members[index].attendance.remove("${diff}");
      }
    }
  }
}
