import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';

/// StateNotifierProvider is a combination of StateProvider and ChangeNotifierProvider.
final userProfileListProvider = StateNotifierProvider<UserProfileNotifier, List<UserModel>>
  ((ref) => UserProfileNotifier());

class UserProfileNotifier extends StateNotifier<List<UserModel>> {
  UserProfileNotifier() :
        super([]);

  void addUserModel(UserModel userModel) {
    state = [...state, userModel];
  }

  void addUserModels(List<UserModel> userModels) {
    state = [...state, ...userModels];
  }
}

