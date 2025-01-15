import 'package:idb_shim/idb_browser.dart';

class IndexedDBService<T> {
  final String dbName;
  final String storeName;
  final int dbVersion;

  late Future<Database> _database;

  IndexedDBService({
    required this.dbName,
    required this.storeName,
    this.dbVersion = 1,
  }) {
    _database = _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return await idbFactoryBrowser.open(dbName, version: dbVersion,
        onUpgradeNeeded: (VersionChangeEvent e) {
      final db = e.database;
      if (!db.objectStoreNames.contains(storeName)) {
        db.createObjectStore(storeName, autoIncrement: true);
      }
    });
  }

  Future<bool> contains(String key) async {
    final db = await _database;
    final transaction = db.transaction(storeName, 'readonly');
    final store = transaction.objectStore(storeName);
    final existing = await store.getObject(key);
    return existing != null;
  }

  Future<void> save(String key, Map<String, dynamic> value) async {
    final exists = await contains(key);
    if (exists) {
      return; // 이미 존재하면 저장하지 않음
    }
    final db = await _database;
    final transaction = db.transaction(storeName, 'readwrite');
    final store = transaction.objectStore(storeName);
    await store.put(value, key); // JSON 저장
    await transaction.completed;
  }

  Future<void> add(Map<String, dynamic> value) async {
    final db = await _database;
    final transaction = db.transaction(storeName, 'readwrite');
    final store = transaction.objectStore(storeName);
    await store.add(value); // JSON 저장
    await transaction.completed;
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await _database;
    final transaction = db.transaction(storeName, 'readonly');
    final store = transaction.objectStore(storeName);
    final results = await store.getAll();
    return results.whereType<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>?> get(String key) async {
    final db = await _database;
    final transaction = db.transaction(storeName, 'readonly');
    final store = transaction.objectStore(storeName);
    final result = await store.getObject(key);
    if (result is Map<String, dynamic>) {
      return result;
    }
    return null;
  }

  Future<void> delete(String key) async {
    final db = await _database;
    final transaction = db.transaction(storeName, 'readwrite');
    final store = transaction.objectStore(storeName);
    await store.delete(key);
    await transaction.completed;
  }

  Future<void> clear() async {
    final db = await _database;
    final transaction = db.transaction(storeName, 'readwrite');
    final store = transaction.objectStore(storeName);
    await store.clear();
    await transaction.completed;
  }

  Future<void> deleteDatabase() async {
    await idbFactoryBrowser.deleteDatabase(dbName);
  }
}
