import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance/Provider/member.dart';

class UserSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "qr-attendance-321308",
  "private_key_id": "63284aa7e4ee491d428fba7d84a717d88669c5dd",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDFBpYvj22Du/IW\nLoCS3LymhKSgUOMnIYS47JL2/uDd/oiKB9LLs8EoxO4XxSrBnfcfeD3yhGWw3Yfh\nUjErqftYUQYMr8KDURN8Tqdg5Y11WooiUoTY8ReRHx3pFXdkMa6HS49tt/4o+YLB\nx22cT8lu8zfjEe3rJMiDN9jMeO8rTkBEVdMf78ARkqOQwLytBe2bn8qnLrotanvT\nxy3gyzqChTC/XboQEaKqL1CWQ9F6c55l0UJqWkeWQtP+1JKFFuBXUoNaX9XLKdJb\n+Urwts1Y5SKrgP1h/N3qr2ZkCiJ4IP3cKlvlZEF3MFXEH1dycpECS61+MQdZSPIo\nu+q8Ek2HAgMBAAECggEACt8z1witZ1vYnka59jX9/EZM0JfbYPkQL3rGb/YH3ILD\ncAfB0axn7ThTVwvHMeCQlrOg33VU0y9LjzBk4YmYrU/oleH2SXQQ2jF7j5+QcGMA\nRP0+srs4V1wF34BoEnxMqs84PpACPf/pVN4MpgJ1FWKQY+maXPkDo3ynwZNZceSK\nT1XUCSsslNKlDCW5vmhXTVcYXNSx6T5Uy9Xd1CW0H83Z6qm3kejpw73zESB1qaD7\nlTz8u/rhf6aRorepiFEXzTvnlJUzL1xEAQjsuEpJUFGQr1FeexU7jiNMUy1gE0bI\nHzA8MGP3Ie79cxF2ghYVXJgHN12HCWozdTC679XxsQKBgQDy6HWpUdcBjeorTmXA\nSdJVgBWUVIfp9CYQZBS8jO2wYzvBFPcK2V+jdUDzf/SxIYALwROLISJSQS//4U7c\nhvfQBBhZj7DPeCgGJPg20YClxJU2JZshRR6eAdpC0IInNum2d7pQ9xRSdjZ9JxDM\nbK6kreJ0xHnma34a99G1Z/ZAeQKBgQDPpRAJyN3vekAofmC0ODPTvDqAC0SHLD+U\nXVzbmxz4wSldUXe6cs8XTLycoKR9hjwkH/IsWe28kX/xWto9cFsJvfnB7pb4+d/K\n8WYvGezqQYsyzVg/O97vm4RJprZ/BPvboOoIw07n0GG9GH8/PQizA0IWk6wOkyQL\ngC+xAXV9/wKBgQDSXZmQwsy2juXvDV03k3cyDtQhereeWJAif9oplM9AhCA6zmJI\npgqasDBI8VbDlGSlSVgYlOB5ZfUg4EqA1+6D2xgPcE7Kzp+y+o9wQi3s4fvrQdRA\nkvC6HJaeaJ9fQMJVAQl9lw2lgLUd3BhDQhhZjDHjuEht0kgLKPYX6eos2QKBgD5N\neJJ3AqBoPffoc3ufoW1WfPcOanFkhW8u1D3QPNEmpBKr7xCyghCrpawZR0GilUkB\njNhh40NBJPJ2ICVvIOG7bsURoZry3oM2C0L2tG9VWz7S/jd671lVgEvZCcjy5d7w\nWUhn0bUcgTcLsqJ23bVYtOuxQ17cJ2SMAcNKfMZhAoGBAJDBIMhlXsjbcO1sQQhf\nxc7mLjK+OL5Dh/GDhf53LAsHNDSnDpNUbvCnzbHQlquGiMjs5cq2ZTnOemanvYEp\nTJ06yrpe7joaOUEUUNL7qt4yuwN5+mOTFRKtCOVo43Nz6xTt7t0JklFr/4D+akQM\n6Dv00LpDbN/PeuEIbAy8xNZI\n-----END PRIVATE KEY-----\n",
  "client_email": "qr-attendance@qr-attendance-321308.iam.gserviceaccount.com",
  "client_id": "103252473221387549683",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/qr-attendance%40qr-attendance-321308.iam.gserviceaccount.com"
}
  ''';
  static final _spreadsheetId = '1VzLyjTqM6a61YrzEiNnFMYYeq6ocSvWB2GoGMWUx9dk';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _sheet;
  static String now = DateFormat("dd-MM-yyyy").format(DateTime.now());
  static List<String> headerRow = [];

  static Future<void> init() async {
    final spreasheet = await _gsheets.spreadsheet(_spreadsheetId);
    _sheet = await _getWorkSheet(spreasheet, title: 'e3dady');
    updateHeaders();
  }

  static Future<void> insertValue(String data, int col, int row) async {
    await _sheet!.values.insertValue(data, column: col, row: row);
  }

  static Future<void> updateHeaders() async {
    await _sheet!.values.row(1).then((value) {
      if (!value.contains(now)) {
        headerRow = value;
      } else {
        return;
      }
    });
    await _sheet!.values.insertValue(now, column: headerRow.length + 1, row: 1);
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
    print(member);
    if (_sheet == null) return false;
    return _sheet!.values.map.insertRowByKey(id, member);
  }
}
