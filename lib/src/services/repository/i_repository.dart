import 'package:contacts/src/helpers/database.dart';

import '../../models/i_entity.dart';

typedef Predicate<T> = bool Function(T);

abstract class IRepository<T extends IEntityBase> {
  late final DBProvider dbProvider;
  late final String tableName;

  Future<T?> getItemAsync({required Predicate<T> predicate});

  Future<Iterable<T>?> getItemsAsync({Predicate<T>? predicate});

  Future<int> insertItemAsync(T item);

  Future<int> updateItemAsync(T item);

  Future<int> deleteItemAsync(T item);
}
