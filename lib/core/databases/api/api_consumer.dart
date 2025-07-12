abstract class ApiConsumer {
  Future<dynamic> get(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? header});
  Future<dynamic> post(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false,
      Map<String, dynamic>? header});
  Future<dynamic> patch(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false,
      Map<String, dynamic>? header});
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });
}
