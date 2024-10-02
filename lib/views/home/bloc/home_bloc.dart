import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_plus/models/user_model.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoadingState()) {
    on<GetUserEvent>(_getUserEvent);
    on<SearchUserEvent>(_searchUserEvent);
    on<AddUserEvent>(_addUserEvent);
  }
  Future<void> _addUserEvent(
    AddUserEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    try {
      await InternetAddress.lookup('google.com');

      CollectionReference contacts =
          FirebaseFirestore.instance.collection('contacts');

      // Add the user to Firestore
      await contacts.add(event.user.toMap());

      // Optionally, you can fetch the updated list of users after adding a new user
      add(GetUserEvent(context: event.context));
    } on SocketException catch (_) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(
          content: Text('Please check your Internet.'),
        ),
      );
    }
  }

  Future<void> _getUserEvent(
    GetUserEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    try {
      await InternetAddress.lookup('google.com');

      CollectionReference contacts =
          FirebaseFirestore.instance.collection('contacts');

      QuerySnapshot querySnapshot = await contacts.get();
      List<UserModel> userList = [];

      for (var doc in querySnapshot.docs) {
        // Convert the document data to a UserModel instance
        UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        userList.add(user);
      }
      if (userList.isEmpty) {
        emit(
          HomeErrorState(
            errorMessage: "Failed to load user.",
          ),
        );
      } else {
        if (state is HomeLoadedState) {
          emit(
            (state as HomeLoadedState).copyWith(users: userList),
          );
        }
        emit(HomeLoadedState(users: userList));
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(
          content: Text('Please check your Internet.'),
        ),
      );
    }
  }

  Future<void> _searchUserEvent(
    SearchUserEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state;

      // Check if the current state is HomeLoadedState
      if (currentState is HomeLoadedState) {
        // Retrieve the list of all users
        final allUsers = currentState.users;

        // If the search key is empty, emit the original list of users
        if (event.key.isEmpty) {
          emit(currentState.copyWith(filteredNotes: allUsers));
        } else {
          // Filter the users based on the search key (case insensitive)
          final filteredUsers = allUsers.where((user) {
            return user.firstName.toLowerCase().contains(event.key) ||
                user.lastName.toLowerCase().contains(event.key) ||
                user.city.toLowerCase().contains(event.key) ||
                user.contactNumber
                    .contains(event.key); // Add more fields if needed
          }).toList();

          // Emit the updated state with filtered users
          emit(currentState.copyWith(filteredNotes: filteredUsers));
        }
      }
    } catch (e) {
      print(e);
      // Emit an error state if something goes wrong
      emit(HomeErrorState(errorMessage: 'An error occurred while searching.'));
    }
  }
}
