import 'package:contacts/src/helpers/database.dart';
import 'package:contacts/src/models/contact_model.dart';
import 'package:contacts/src/services/repository/i_repository.dart';
import 'package:rxdart/rxdart.dart';

class ContactRepository implements IRepository<ContactModel> {
  ContactRepository() {
    dbProvider = DBProvider.instance;
    tableName = ContactFields.databaseTableName;

    _init();
  }

  @override
  late final DBProvider dbProvider;

  @override
  late final String tableName;

  final _contactStreamController = BehaviorSubject<List<ContactModel>>();

  @override
  Future<int> deleteItemAsync(ContactModel contact) async {
    final contacts = [..._contactStreamController.value];
    int contactIndex = contacts.indexWhere((c) => c.id == contact.id);
    contacts.removeAt(contactIndex);
    _contactStreamController.add(contacts);

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

  Stream<List<ContactModel>> getContacts(int userId) {
    return _contactStreamController.stream
        .map((contacts) => contacts.where((c) => c.userId == userId).toList())
        .asBroadcastStream();
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
    } else if (predicate == null) {
      result = contacts.toList().cast<ContactModel>();
    }

    return result;
  }

  @override
  Future<int> insertItemAsync(ContactModel contact) async {
    final db = await dbProvider.database;
    int contactId = await db.insert(tableName, contact.toJson());

    final contacts = [..._contactStreamController.value];
    contacts.add(contact.copyWith(id: contactId));
    _contactStreamController.add(contacts);

    return contactId;
  }

  @override
  Future<int> updateItemAsync(ContactModel contact) async {
    final contacts = [..._contactStreamController.value];
    final editingContactIndex = contacts.indexWhere((c) => c.id == contact.id);
    contacts[editingContactIndex] = contact;
    _contactStreamController.add(contacts);

    final db = await dbProvider.database;
    return db.update(tableName, contact.toJson(),
        where: '${ContactFields.id} = ?', whereArgs: [contact.id]);
  }

  void _init() async {
    final contactsList = await getItemsAsync();

    if (contactsList != null && contactsList.isNotEmpty) {
      _contactStreamController.add(contactsList.toList());
    }
  }
}
