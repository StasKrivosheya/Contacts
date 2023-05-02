import 'package:contacts/src/helpers/database.dart';
import 'package:contacts/src/models/user_model.dart';
import 'package:contacts/src/services/repository/i_repository.dart';

class UserRepository implements IRepository<User> {
  UserRepository() {
    dbProvider = DBProvider.instance;
    tableName = UserFields.databaseTableName;
  }

  @override
  late final DBProvider dbProvider;

  @override
  late final String tableName;

  @override
  Future<int> deleteItemAsync(User user) async {
    final db = await dbProvider.database;
    return db.delete(tableName, where: '${UserFields.id} = ?', whereArgs: [user.id]);
  }

  @override
  Future<User?> getItemAsync({required Predicate<User> predicate}) async {
    final db = await dbProvider.database;
    final queryResult = await db.query(tableName);
    final users = queryResult.isNotEmpty
        ? queryResult.map((item) => User.fromJson(item)).toList()
        : [];

    User? result;
    try {
      result = users.firstWhere((user) => predicate(user));
    } on StateError {
      result = null;
    }
    return result;
  }

  @override
  Future<Iterable<User>?> getItemsAsync({Predicate<User>? predicate}) async {
    final db = await dbProvider.database;
    final queryResult = await db.query(tableName);
    final users = queryResult.isNotEmpty
        ? queryResult.map((item) => User.fromJson(item)).toList()
        : [];

    Iterable<User>? result;
    if (predicate != null && users.isNotEmpty) {
      result = users.where((u) => predicate(u)).cast<User>();
    }

    return result;
  }

  @override
  Future<int> insertItemAsync(User user) async {
    final db = await dbProvider.database;
    return db.insert(tableName, user.toJson());
  }

  @override
  Future<int> updateItemAsync(User user) async {
    final db = await dbProvider.database;

    return db.update(tableName, user.toJson(),
        where: '${UserFields.id} = ?', whereArgs: [user.id]);
  }
}
