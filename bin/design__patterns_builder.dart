import 'package:design__patterns_builder/design__patterns_builder.dart'
    as design__patterns_builder;
import 'package:design__patterns_builder/query_builder.dart';
import 'package:design__patterns_builder/query_builder_impl_mysql.dart';
import 'package:design__patterns_builder/query_builder_impl_postgres.dart';

// void main(List<String> arguments) {
//   design__patterns_builder.execute();
// }

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
