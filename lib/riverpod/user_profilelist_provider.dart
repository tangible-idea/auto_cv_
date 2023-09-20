import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user_profile_item.dart';

/// StateNotifierProvider is a combination of StateProvider and ChangeNotifierProvider.
final userProfileListProvider = StateNotifierProvider<UserProfileNotifier, List<UserProfileItem>>
  ((ref) => UserProfileNotifier());

class UserProfileNotifier extends StateNotifier<List<UserProfileItem>> {
  UserProfileNotifier() :
        super([
          UserProfileItem(),
        ]);
}

