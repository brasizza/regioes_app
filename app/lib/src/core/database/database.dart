abstract interface class Database {
  Future<T?> openDatabase<T>(Map<String, dynamic> path);
  Future<void> closeDatabase();
  Future<List<T>?> getData<T>(String? query);
  Future<void> clear();

  Future<int> insert<T>({required T value});
  Future<int> insertAll<T>({required List<T> value});
}
