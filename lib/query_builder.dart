abstract class QueryBuilder {
  QueryBuilder select({
    required String table,
    required List<String> fields,
  });
  QueryBuilder where({
    required String field,
    String operator = '=',
    required String value,
  });
  QueryBuilder limit({
    required String start,
    required String offset,
  });
  String getSQL();
}
