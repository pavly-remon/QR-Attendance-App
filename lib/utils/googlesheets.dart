import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance/models/member.dart';

class UserSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "qr-attendance-321308",
  "private_key_id": "3fcf997aab44d7c76421d6163829b0aeca998cff",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDhxizaye5dnk1S\n4gRxBvqCHElUEr0fsJxlcuSPs9nOK0g9jVrDUrh9a6g+BQfQrq5ATk9JGUueO0yu\nrDOhcrnErS67vLZZyAXGrjaEYvmkK2BfakeOrCVEnBhwSu0nrbXFD7nN5I1/J37U\n25GeCRIMSBzMIWBP6XSJ2w/tz7qugwGr/c6sXzg2TWUPQm6GTxXRPuaryCjrJzSc\naKycP0Sjqwj17MOijE7m/VB7vBYk5T6lekop3pTeZ/FPDYOdXoWSUguQpwACg3W/\nDKC2aJt/wPbMTt3r2Utvzuazd8mzw5TWG7RDoT248JRJ2dJL8asIEeJ+du1ch6j1\n7Cix4CMLAgMBAAECggEAVy+MSsEIB6cF/SfCx1MGkhASUSEbX414F8USdlvhlDgq\noXpgvmTHUcetJKYUqoWKTNLw0y2tgeEsb5eYKJSBIG4wSddKI8mWUW8dJmqCNN97\nS91i3LmleqU82sBUbKosM3krK1NDQQMje1d/GCQwkAWY+Us6QiHJGyM5N4Cseo7q\n4h9r3yB0f34/ylRskzeHqDGyDA4i7MdU3BI7HxPMSeVY0d5g+g3YNvBtR08mEo75\nFjc2Q3agZmTFRDcMv2GWRxFQSYFqbuPpP5wJYaQUBIwwNxAak7tZLnKzOIZjPd4V\nec11TIjPjUCxEdUQJFDQbO/nNvnnlBFdAfRi5fXDIQKBgQD4hkRz3LRYoWsar8z9\nGkUsovx5nAB9CB5e0FlLc8sd7gxeMZj4+pLYOivqpjccpMw+aA74YEDkIul1Wfp8\n7S0kZyDTvOlrnxIsCuAyQ7MNhoOv4oX7yN64SCOQg9iCeXOgILpfq+Rutmd+bPmO\nvTSBCagXkaiWNOhXh+OdRwe5JQKBgQDokLiv6pyNxNfwit8uGQK4WLCe2iBK3wGJ\nFo8VkAvOsEMn9necm0gOrllYpXJjiGG2v/HuGpIJ8JFXu/rcYaIrY4TRblOm6q6B\nOMsciXlpeJHVd3pKXf4gTpgude2S2QeJUyaCLDW/SjsXstCgM1OiBoCSKzoQSWXu\nyqK8G/qsbwKBgQDtXUAP8SIG7NUg/fupWefrxBekBs2onZJ0OEaw+/1prqz9Yh2a\n36hVAOplCS/mGbhBep2huD0CKB4WSUQnAVh2RlFiKjI+6gUvL4wGNgbTykAIQzB4\n1Ndz5uKg6mxl4Z3/uIKJUeGxpGGgrHCGVkvJWvHC4QnFvO6Ue2N4GhlUSQKBgQCW\nGHkqCDgcA1P+yhH6VWf9BDiRfWPkDoOWL3oPR5VnQzlEfHx8FXfvCbVeUgE+ndG6\nuazxqDJiueGEBy2DuHuKl0MsS5EvpD0V50qnU06JtKgiZmcFwh32SeNL8Q5wfSOx\nDHpI/zF9EPKMe/rLufSbGKk4LS/fPQ/Nivh2gXRKfwKBgEVXWMHoa+Fa6rW+92bN\nVfV59MX7A/3f0hAA2m9SI0EUPr6J0pmX4Yr0E/Hf23sq7M+1JqFat4saFNeJzFRE\nKeBs295m76E1yD7TVSSE5hc/dGmTJvV0W9+FLDT4O6qw0Tkg/fGrus3GzBQKEGd7\nsFNfBNR78dEj2q7rTvU0v6Zv\n-----END PRIVATE KEY-----\n",
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
    try {
      final spreasheet = await _gsheets.spreadsheet(_spreadsheetId);
      _sheet = await _getWorkSheet(spreasheet, title: 'e3dady');
      await _sheet!.values.row(1).then((value) => headerRow = value);
    } catch (e) {
      throw e;
    }
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
