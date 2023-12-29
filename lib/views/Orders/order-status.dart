import 'package:flutter/material.dart';

enum OrderStatus {
  Pending,
  Submitted,
  Processing,
  Shipped,
  Delivered,
}

class OrderStatusBar extends StatefulWidget {
  final OrderStatus initialStatus;

  const OrderStatusBar({Key? key, this.initialStatus = OrderStatus.Pending}) : super(key: key);

  @override
  _OrderStatusBarState createState() => _OrderStatusBarState();
}

class _OrderStatusBarState extends State<OrderStatusBar> {
  double _statusBarHeight = 0.0;
  OrderStatus _currentStatus = OrderStatus.Pending;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: _statusBarHeight,
      color: _getStatusColor(),
      child: Center(
        child: Text(
          _getStatusText(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void toggleStatusBar(OrderStatus newStatus) {
    setState(() {
      _statusBarHeight = _statusBarHeight == 0.0 ? 100.0 : 0.0;
      _currentStatus = newStatus;
    });
  }

  Color _getStatusColor() {
    switch (_currentStatus) {
      case OrderStatus.Pending:
        return Colors.yellow;
      case OrderStatus.Submitted:
        return Colors.green;
      case OrderStatus.Processing:
        return Colors.blue;
      case OrderStatus.Shipped:
        return Colors.orange;
      case OrderStatus.Delivered:
        return Colors.teal;
    }
  }

  String _getStatusText() {
    switch (_currentStatus) {
      case OrderStatus.Pending:
        return 'Pending';
      case OrderStatus.Submitted:
        return 'Submitted Successfully!';
      case OrderStatus.Processing:
        return 'Processing';
      case OrderStatus.Shipped:
        return 'Shipped';
      case OrderStatus.Delivered:
        return 'Delivered';
    }
  }
}

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final GlobalKey<_OrderStatusBarState> _orderStatusBarKey =
      GlobalKey<_OrderStatusBarState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Screen'),
      ),
      body: Column(
        children: [
          // Your order content goes here
          // ...

          // Add the animated status bar
          OrderStatusBar(
            key: _orderStatusBarKey,
            initialStatus: OrderStatus.Pending,
          ),

          // Add buttons to toggle the status bar to different statuses
          ElevatedButton(
            onPressed: () {
              _orderStatusBarKey.currentState?.toggleStatusBar(OrderStatus.Pending);
            },
            child: const Text('Pending'),
          ),
          ElevatedButton(
            onPressed: () {
              _orderStatusBarKey.currentState?.toggleStatusBar(OrderStatus.Submitted);
            },
            child: const Text('Submitted'),
          ),
          ElevatedButton(
            onPressed: () {
              _orderStatusBarKey.currentState?.toggleStatusBar(OrderStatus.Processing);
            },
            child: const Text('Processing'),
          ),
          ElevatedButton(
            onPressed: () {
              _orderStatusBarKey.currentState?.toggleStatusBar(OrderStatus.Shipped);
            },
            child: const Text('Shipped'),
          ),
          ElevatedButton(
            onPressed: () {
              _orderStatusBarKey.currentState?.toggleStatusBar(OrderStatus.Delivered);
            },
            child: const Text('Delivered'),
          ),
        ],
      ),
    );
  }
}
