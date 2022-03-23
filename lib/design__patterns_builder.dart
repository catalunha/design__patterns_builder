import 'package:design__patterns_builder/query_builder_impl_mysql.dart';

void execute() {
  print('Design Pattern: Builder');
  var sql = clienteCode(QueryBuilderImplMysql());
  print(sql);
}

String clienteCode(QueryBuilderImplMysql queryBuilder) {
  var sql = queryBuilder
      .select(table: 'users', fields: ['name', 'email'])
      .where(field: 'age', operator: '>', value: '18')
      .where(field: 'age', operator: '<', value: '30')
      .limit(start: '10', offset: '20')
      .getSQL();
  return sql;
}
