import 'package:design__patterns_builder/query_builder.dart';

class QueryBuilderImplMysql extends QueryBuilder {
  var selectPart = '';
  var selectType = '';
  var wherePart = <String>[];
  var limitPart = '';
  reset() {
    selectPart = '';
    wherePart = <String>[];
    limitPart = '';
  }

  @override
  QueryBuilder select({required String table, required List<String> fields}) {
    reset();
    selectPart = 'SELECT ${fields.join(",")} FROM $table';
    selectType = 'select';
    return this;
  }

  @override
  QueryBuilder where(
      {required String field, String operator = '=', required String value}) {
    if (['select', 'update', 'delete'].contains(selectType)) {
      wherePart.add("$field $operator '$value'");
    } else {
      throw Exception(' WHERE can only be added to SELECT, UPDATE OR DELETE');
    }
    return this;
  }

  @override
  QueryBuilder limit({required String start, required String offset}) {
    if (selectType == 'select') {
      limitPart = ' LIMIT $start, $offset';
    } else {
      throw Exception('LIMIT can only be added to SELECT');
    }
    return this;
  }

  @override
  String getSQL() {
    var sql = selectPart;
    if (wherePart.isNotEmpty) {
      sql += ' WHERE ${wherePart.join(" AND ")}';
    }
    if (limitPart.isNotEmpty) {
      sql += limitPart;
    }
    sql += ';';
    return sql;
  }
}
