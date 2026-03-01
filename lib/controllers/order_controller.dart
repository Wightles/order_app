import 'package:flutter/material.dart';
import '/models/order.dart';
import '/services/order_service.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {}

class OrderError extends OrderState {}

class OrderController extends ChangeNotifier {
  final OrderService _service = OrderService();
  
  OrderState _state = OrderInitial();
  String? _errorMessage;
  Order? _order;

  OrderState get state => _state;
  String? get errorMessage => _errorMessage;
  Order? get order => _order;

  Future<void> submitOrder(int userId, int serviceId) async {
    _state = OrderLoading();
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.createOrder(userId, serviceId);
      _order = result;
      _state = OrderSuccess();
    } catch (e) {
      _errorMessage = e.toString();
      _state = OrderError();
    }
    notifyListeners();
  }

  void reset() {
    _state = OrderInitial();
    _errorMessage = null;
    _order = null;
    notifyListeners();
  }
}