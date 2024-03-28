class ServerException implements Exception {
  final String message;

  ServerException({
    this.message = 'Some error occoured on the server side',
  });
}
