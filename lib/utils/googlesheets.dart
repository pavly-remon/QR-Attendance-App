import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance/models/member.dart';

import 'credentials.dart';

class UserSheetsApi {
  static const _credentials = CREDENTIALS;

  static final _gsheets = GSheets(_credentials);
  static Worksheet? _sheet;
  static DateTime now = new DateTime.now();
  static List<String> headerRow = [];

  static Future<void> init(String docId) async {
    try {
      final spreasheet = await _gsheets.spreadsheet(docId);
      _sheet = await _getWorkSheet(spreasheet, title: 'Sheet1');
      await _sheet!.values.row(1).then((value) {
        headerRow = value;
        updateHeaders();
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<void> insertValue(String data, int col, int row) async {
    await _sheet!.values.insertValue(data, column: col, row: row);
  }

  static Future<void> updateHeaders() async {
    String currDate = DateFormat("yyyy-MM-dd").format(now);
    var epoch = new DateTime(1899, 12, 30); //gsheet refrence Date
    int diff = now.difference(epoch).inDays;
    if (!headerRow.contains(diff) && !headerRow.contains("${diff}")) {
      await _sheet!.values
          .insertValue(currDate, column: headerRow.length + 1, row: 1);
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreasheet,
      {required String title}) async {
    try {
      return await spreasheet.addWorksheet(title);
    } catch (e) {
      return spreasheet.worksheetByTitle(title)!;
    }
  }

  static Future<List<Member>> getAll() async {
    if (_sheet == null) return <Member>[];
    final members = await _sheet!.values.map.allRows();
    return members == null ? <Member>[] : members.map(Member.fromJson).toList();
  }

  static Future<bool> update({
    required String id,
    required Map<String, dynamic> member,
  }) async {
    if (_sheet == null) return false;
    return _sheet!.values.map.insertRowByKey(id, member);
  }
}
