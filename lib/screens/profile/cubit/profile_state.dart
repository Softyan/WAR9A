part of 'profile_cubit.dart';

@MappableClass()
class ProfileState extends BaseState with ProfileStateMappable {
  final User user;
  const ProfileState(
      {super.message, super.statusState, this.user = const User()});
}
