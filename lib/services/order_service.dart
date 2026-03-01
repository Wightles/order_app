import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../exceptions/api_exception.dart';
import '../config/api_config.dart';

class OrderService {
  Future<Order> createOrder(int userId, int serviceId) async {
    final client = http.Client();
    
    try {
      final response = await client
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/orders'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'userId': userId,
              'serviceId': serviceId,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Order.fromJson(jsonDecode(response.body));
      } else {
        String message;
        try {
          final error = jsonDecode(response.body);
          message = error['message'] ?? 'Ошибка сервера';
        } catch (_) {
          message = 'Ошибка сервера: ${response.statusCode}';
        }
        throw ApiException(message, statusCode: response.statusCode);
      }
    } on SocketException {
      throw ApiException('Отсутствует подключение к интернету');
    } on TimeoutException {
      throw ApiException('Превышено время ожидания (10 секунд)');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Неизвестная ошибка');
    } finally {
      client.close();
    }
  }
}