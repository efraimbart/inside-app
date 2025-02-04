import 'dart:convert';

import 'package:inside_data/src/loaders/wordpress/wordpress_repository.dart';

Future<void> main(List<String> args) async {
  final id = args.isNotEmpty ? int.tryParse(args.first) ?? 16 : 16;

  const domain = 'insidechassidus.org';
  final repository = WordpressRepository(wordpressDomain: domain);
  await repository.category(id);

  final encoder = JsonEncoder.withIndent('\t');
  print(encoder
      .convert([...repository.categories.values, ...repository.groups.values]));
}
