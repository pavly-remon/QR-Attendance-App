import 'package:bloc/bloc.dart';
import 'package:qr_attendance/models/member.dart';
import 'package:qr_attendance/models/members_repo.dart';

part 'member_state.dart';

class MemberCubit extends Cubit<MemberState> {
  MemberCubit() : super(MemberInitial());
  void read(String code) => emit(UpdateMember(code: code));
}
