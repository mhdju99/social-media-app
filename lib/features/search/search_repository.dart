import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/core/errors/expentions.dart';
import 'package:social_media_app/core/errors/failure.dart';
import 'package:social_media_app/features/authentication/data/models/user_model/user_model.dart';
import 'package:social_media_app/features/search/SimpleUserModel.dart';

class SearchRepository {
  final ApiConsumer api;
  SearchRepository({
    required this.api,
  });
  Future<Either<Failure, List<SimpleUserModel>>> searchPersons(String query) async {
    print("❣search starde");
    try {
      final response = await api.get(await EndPoints.searchusersEndPoint,
          queryParameters: {"userName": query});
      print("❣$response");

      final List<SimpleUserModel> data = (response.data["data"] as List).map((e) => SimpleUserModel.fromJson(e)).toList();
      data
          .where((user) =>
              user.userName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return right(data);
    } on ServerException catch (e) {
          print("❣$e");

      return left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (a) {
                print("❣$a");

      return left(Failure(errMessage: a.toString()));
    }
  }
}
