import 'package:qr_attendance/models/googlesheets.dart';
import 'package:qr_attendance/models/member.dart';

class MemberState {
  List<Member> members;
  MemberState({this.members = const []});
  MemberState.initialState() : members = List.unmodifiable(<Member>[]) {
    Future.delayed(Duration.zero, () async {
      await UserSheetsApi.getAll().then((values) {
        members = values;
      });
    });
  }
}
