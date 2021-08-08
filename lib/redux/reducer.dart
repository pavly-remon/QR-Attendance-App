import 'package:qr_attendance/redux/actions.dart';
import 'package:qr_attendance/redux/state.dart';

MemberState updateMemberReducer(MemberState state, dynamic action) {
  if (action is UpdateMemberAttendance) {
    return MemberState(
        members: state.members
            .map((member) => member.id == action.updatedMember.id
                ? action.updatedMember
                : member)
            .toList());
  }
  return state;
}
