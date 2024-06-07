import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'models.dart';

part 'api.g.dart';

@RestApi(baseUrl: "https://api.exemplo.com")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/comidas")
  Future<List<Comida>> getComidas();
}

Future<List<Comida>> fetchData() async {
  final dio = Dio();
  final client = ApiService(dio);

  try {
    return await client.getComidas();
  } catch (e) {
    print(e);
    return [];
  }
}
