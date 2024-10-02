part of 'home_bloc.dart';

sealed class HomeState extends Equatable {}

final class HomeLoadingState extends HomeState {
  @override
  List<Object?> get props => [];
}

final class HomeLoadedState extends HomeState {
  final List<UserModel> users;
  final List<UserModel> filteredUsers;

  HomeLoadedState({
    this.users = const [],
    this.filteredUsers = const [],
  });

  HomeLoadedState copyWith({
    List<UserModel>? users,
    List<UserModel>? filteredNotes,
  }) {
    return HomeLoadedState(
      users: users ?? this.users,
      filteredUsers: filteredNotes ?? this.filteredUsers,
    );
  }

  @override
  List<Object> get props => [
        users,
        filteredUsers,
      ];
}

final class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}
