import 'package:flutter/material.dart';
import '../controllers/order_controller.dart';

class OrderScreen extends StatefulWidget {
  final OrderController controller;

  const OrderScreen({
    super.key,
    required this.controller,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _userIdController = TextEditingController();
  final _serviceIdController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _serviceIdController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    final userId = int.tryParse(_userIdController.text);
    final serviceId = int.tryParse(_serviceIdController.text);
    
    if (userId == null || serviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите числовые значения ID'),
        ),
      );
      return;
    }
    
    if (userId <= 0 || serviceId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID должны быть положительными числами'),
        ),
      );
      return;
    }

    widget.controller.submitOrder(userId, serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание заказа'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'ID пользователя',
                hintText: 'Введите ID пользователя',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _serviceIdController,
              decoration: const InputDecoration(
                labelText: 'ID услуги',
                hintText: 'Введите ID услуги',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                final state = widget.controller.state;
                
                if (state is OrderLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (state is OrderSuccess) {
                  return Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text('Заказ создан: ${widget.controller.order?.orderId}'),
                      Text('Статус: ${widget.controller.order?.status}'),
                      if (widget.controller.order?.paymentUrl != null)
                        Text('Ссылка на оплату: ${widget.controller.order?.paymentUrl}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          widget.controller.reset();
                          _userIdController.clear();
                          _serviceIdController.clear();
                        },
                        child: const Text('Создать новый заказ'),
                      ),
                    ],
                  );
                }
                
                if (state is OrderError) {
                  return Column(
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.controller.errorMessage ?? 'Неизвестная ошибка',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitOrder,
                        child: const Text('Повторить'),
                      ),
                    ],
                  );
                }
                
                return ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Создать заказ'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}