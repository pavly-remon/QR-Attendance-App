part of 'member_cubit.dart';

abstract class MemberState {
  List<Member> members = MemberRepository.members;
}

class MemberInitial extends MemberState {
  MemberInitial();
}

class UpdateMember extends MemberState {
  String code;
  UpdateMember({required this.code}) {
    MemberRepository.updateMembers(code);
  }
}
