import '../repositories/profile_repository.dart';
import '../services/user_service.dart';
import '../models/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/utils/utils.dart' as utils;

// Repository Provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) => ProfileRepository());
// Service Provider
final userServiceProvider = Provider<UserService>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UserServiceImpl(repository);
});

class UserListState {
  final List<Profile> items;
  final bool isLoading;
  final String? error;

  const UserListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  UserListState copyWith({
    List<Profile>? items,
    bool? isLoading,
    String? error,
  }) {
    return UserListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final userListProvider = StateNotifierProvider<UserListNotifier, UserListState>(
  (ref) => UserListNotifier(ref),
);

class UserListNotifier extends StateNotifier<UserListState> {
  final Ref ref;

  UserListNotifier(this.ref) : super(const UserListState());

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = ref.read(userServiceProvider);
      final items = await service.fetchUsers();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    }
  }

  Future<void> addUser(Profile profile) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = ref.read(userServiceProvider);
      await service.insertUser(profile);
      state = state.copyWith(items: [...state.items, profile], isLoading: false);
    } catch (e) {
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    }
  }

  Future<void> updateUser(Profile updated) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = ref.read(userServiceProvider);
      await service.updateUser(updated.id, updated);
      final newItems = state.items.map((u) => u.id == updated.id ? updated : u).toList();
      state = state.copyWith(items: newItems, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    }
  }

  Future<void> removeUser(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = ref.read(userServiceProvider);
      await service.deleteUser(id);
      final newItems = state.items.where((u) => u.id != id).toList();
      state = state.copyWith(items: newItems, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    }
  }
}
