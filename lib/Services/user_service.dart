
import 'package:hive/hive.dart';
import 'package:todo_app/Models/user_model.dart';

class UserService {
  late Box<UserModel> _userBox;

  Future<void> init() async {
    _userBox = await Hive.openBox<UserModel>('user');
  }

  UserModel? getUser() {
    return _userBox.get('user');
  }

  Future<void> saveUser(UserModel user) async {
    await _userBox.put('user', user);
  }
}
