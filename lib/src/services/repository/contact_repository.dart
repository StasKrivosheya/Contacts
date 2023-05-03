import 'package:contacts/src/helpers/database.dart';
import 'package:contacts/src/models/contact_model.dart';
import 'package:contacts/src/services/repository/i_repository.dart';

class ContactRepository implements IRepository<ContactModel> {
  ContactRepository() {
    dbProvider = DBProvider.instance;
    tableName = ContactFields.databaseTableName;
  }

  @override
  late final DBProvider dbProvider;

  @override
  late final String tableName;

  @override
  Future<int> deleteItemAsync(ContactModel contact) async {
    final db = await dbProvider.database;
    return db.delete(tableName, where: '${ContactFields.id} = ?', whereArgs: [contact.id]);
  }

  @override
  Future<ContactModel?> getItemAsync({required Predicate<ContactModel> predicate}) async {
    final db = await dbProvider.database;
    final queryResult = await db.query(tableName);
    final contacts = queryResult.isNotEmpty
        ? queryResult.map((item) => ContactModel.fromJson(item)).toList()
        : [];

    ContactModel? result;
    try {
      result = contacts.firstWhere((contact) => predicate(contact));
    } on StateError {
      result = null;
    }
    return result;
  }

  @override
  Future<Iterable<ContactModel>?> getItemsAsync({Predicate<ContactModel>? predicate}) async {
    final db = await dbProvider.database;
    final queryResult = await db.query(tableName);
    final contacts = queryResult.isNotEmpty
        ? queryResult.map((item) => ContactModel.fromJson(item)).toList()
        : [];

    Iterable<ContactModel>? result;
    if (predicate != null && contacts.isNotEmpty) {
      result = contacts.where((u) => predicate(u)).cast<ContactModel>();
    }

    return result;
  }

  @override
  Future<int> insertItemAsync(ContactModel contact) async {
    final db = await dbProvider.database;
    return db.insert(tableName, contact.toJson());
  }

  @override
  Future<int> updateItemAsync(ContactModel contact) async {
    final db = await dbProvider.database;

    return db.update(tableName, contact.toJson(),
        where: '${ContactFields.id} = ?', whereArgs: [contact.id]);
  }
}
