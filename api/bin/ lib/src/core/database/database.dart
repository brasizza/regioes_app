abstract interface class Database {
  Future<T?> openDatabase<T>(Map<String, dynamic> path);
  Future<void> closeDatabase();
  Future<List<T>?> getData<T>(String query);
  Future<T?> getUnique<T>(String query);
  Future<int> insert<T>({required String tableName, required T value});
  Future<int> insertAll<T>({required String tableName, required List<T> value, bool clear = false});
  Future<bool> update<T>({required String tableName, required T value});
  Future<bool> delete<T>({required String tableName, required T value});
}
