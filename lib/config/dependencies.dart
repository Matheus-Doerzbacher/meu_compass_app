import 'package:meu_compass_app/data/services/api/auth_api_client.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => AuthApiClient()),
  ];
}
