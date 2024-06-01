part of 'data_warga_cubit.dart';

@MappableClass()
class DataWargaState extends BaseState with DataWargaStateMappable {
  final List<User> users;
  const DataWargaState(
      {super.message, super.statusState, this.users = const []});
}
