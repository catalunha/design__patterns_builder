import 'package:design__patterns_builder/query_builder.dart';

class QueryBuilderImplPostgres extends QueryBuilder {
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
      _limitPart = ' LIMIT $start OFFSET $offset';
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
