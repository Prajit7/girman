part of 'home_bloc.dart';

sealed class HomeEvent {}

class GetUserEvent extends HomeEvent {
  BuildContext context;
  GetUserEvent({required this.context});
}

class SearchUserEvent extends HomeEvent {
  final String key;
  BuildContext context;

  SearchUserEvent({
    required this.key,
    required this.context,
  });
}

class AddUserEvent extends HomeEvent {
  final UserModel user;
  BuildContext context;

  AddUserEvent({
    required this.user,
    required this.context,
  });
}
