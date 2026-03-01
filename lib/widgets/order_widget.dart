import 'package:flutter/material.dart';
import '../controllers/order_controller.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final controller = OrderController();
  final userIdController = TextEditingController();
  final serviceIdController = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    userIdController.dispose();
    serviceIdController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    final userId = int.tryParse(userIdController.text);
    final serviceId = int.tryParse(serviceIdController.text);
    
    if (userId == null || serviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите числовые значения ID')),
      );
      return;
    }
    
    if (userId <= 0 || serviceId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID должны быть положительными числами')),
      );
      return;
    }

    controller.submitOrder(userId, serviceId);
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
              controller: userIdController,
              decoration: const InputDecoration(
                labelText: 'ID пользователя',
                hintText: 'Введите ID пользователя',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: serviceIdController,
              decoration: const InputDecoration(
                labelText: 'ID услуги',
                hintText: 'Введите ID услуги',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ListenableBuilder(
              listenable: controller,
              builder: (context, child) {
                if (controller.state is OrderLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.state is OrderSuccess) {
                  return Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const SizedBox(height: 16),
                      Text('Заказ №: ${controller.order?.orderId}'),
                      Text('Статус: ${controller.order?.status}'),
                      if (controller.order?.paymentUrl != null)
                        Text('Оплата: ${controller.order?.paymentUrl}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          controller.reset();
                          userIdController.clear();
                          serviceIdController.clear();
                        },
                        child: const Text('Создать новый заказ'),
                      ),
                    ],
                  );
                }

                if (controller.state is OrderError) {
                  return Column(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage ?? 'Неизвестная ошибка',
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