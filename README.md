Projeto baseado no Design Pattern: Builder

Maiores detalhes em: https://refactoring.guru/pt-br/design-patterns/builder

# A abstração
```Dart
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

```
# A implementação para Mysql
```Dart
class QueryBuilderImplMysql extends QueryBuilder {
  var _selectPart = '';
  var _selectType = '';
  var _wherePart = <String>[];
  var _limitPart = '';
  reset() {
    _selectPart = '';
    _selectType = '';
    _wherePart = <String>[];
    _limitPart = '';
  }

  @override
  QueryBuilder select({required String table, required List<String> fields}) {
    reset();
    _selectPart = 'SELECT ${fields.join(",")} FROM $table';
    _selectType = 'select';
    return this;
  }

  @override
  QueryBuilder where(
      {required String field, String operator = '=', required String value}) {
    if (['select', 'update', 'delete'].contains(_selectType)) {
      _wherePart.add("$field $operator '$value'");
    } else {
      throw Exception(' WHERE can only be added to SELECT, UPDATE OR DELETE');
    }
    return this;
  }

  @override
  QueryBuilder limit({required String start, required String offset}) {
    if (_selectType == 'select') {
      _limitPart = ' LIMIT $start, $offset';
    } else {
      throw Exception('LIMIT can only be added to SELECT');
    }
    return this;
  }

  @override
  String getSQL() {
    var sql = _selectPart;
    if (_wherePart.isNotEmpty) {
      sql += ' WHERE ${_wherePart.join(" AND ")}';
    }
    if (_limitPart.isNotEmpty) {
      sql += _limitPart;
    }
    sql += ';';
    return sql;
  }
}
```

# A implementação para Postgres
```Dart
class QueryBuilderImplPostgres extends QueryBuilder {
...
  @override
  QueryBuilder limit({required String start, required String offset}) {
    if (_selectType == 'select') {
      _limitPart = ' LIMIT $start OFFSET $offset';
    } else {
      throw Exception('LIMIT can only be added to SELECT');
    }
    return this;
  }
...
```


# O uso
```Dart

void main(List<String> arguments) {
  print('Design Pattern: Builder');
  var sql = clienteCode(QueryBuilderImplMysql());
  print(sql);
  var sql2 = clienteCode(QueryBuilderImplPostgres());
  print(sql2);
}

String clienteCode(QueryBuilder queryBuilder) {
  var sql = queryBuilder
      .select(table: 'users', fields: ['name', 'email'])
      .where(field: 'age', operator: '>', value: '18')
      .where(field: 'age', operator: '<', value: '30')
      .limit(start: '10', offset: '20')
      .getSQL();
  return sql;
}
```
