import 'package:flutter/material.dart';
import 'package:neuroapp_task6/model/UserModel.dart';
import 'package:neuroapp_task6/service/userServices.dart';

class UserProvider extends ChangeNotifier {
  final ApiServices apiService = ApiServices();

  List<User> _users = [];
  List<User> _filteredUsers = [];

  bool isLoading = false;
  String? error;

  int _page = 1;
  final int _limit = 5;
  bool hasMore = true;

  List<User> get users => _filteredUsers;

  // 🔥 FETCH USERS
  Future<void> fetchUsers({bool refresh = false}) async {
    try {
      if (refresh) {
        _page = 1;
        _users.clear();
        hasMore = true;
      }

      if (!hasMore) return;

      isLoading = true;
      notifyListeners();

      final newUsers = await apiService.fetchUsers();

      // fake pagination for JSONPlaceholder
      final start = (_page - 1) * _limit;
      final end = start + _limit;

      if (start >= newUsers.length) {
        hasMore = false;
      } else {
        _users.addAll(
          newUsers.sublist(
            start,
            end > newUsers.length ? newUsers.length : end,
          ),
        );
        _page++;
      }

      _filteredUsers = List.from(_users);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔍 SEARCH
  void search(String query) {
    if (query.isEmpty) {
      _filteredUsers = List.from(_users);
    } else {
      _filteredUsers = _users
          .where((u) => u.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
