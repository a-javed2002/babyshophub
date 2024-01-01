// import 'package:flutter/material.dart';

// enum OrderStatus {
//   pending,
//   submitted,
//   processing,
//   shipped,
//   delivered,
// }

// class OrderStatusBar extends StatefulWidget {
//   final OrderStatus initialStatus;

//   const OrderStatusBar({Key? key, this.initialStatus = OrderStatus.pending})
//       : super(key: key);

//   static OrderStatus getStatusEnum(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return OrderStatus.pending;
//       case 'submitted':
//         return OrderStatus.submitted;
//       case 'processing':
//         return OrderStatus.processing;
//       case 'shipped':
//         return OrderStatus.shipped;
//       case 'delivered':
//         return OrderStatus.delivered;
//       default:
//         return OrderStatus
//             .pending; // Default to pending if status is unrecognized
//     }
//   }

//   @override
//   _OrderStatusBarState createState() => _OrderStatusBarState();
// }

// class _OrderStatusBarState extends State<OrderStatusBar> {
//   double _statusBarHeight = 0.0;
//   OrderStatus _currentStatus = OrderStatus.pending;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print(widget.initialStatus);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 500),
//       height: _statusBarHeight,
//       color: _getStatusColor(),
//       child: Center(
//         child: Text(
//           _getStatusText(),
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }

//   void toggleStatusBar(OrderStatus newStatus) {
//     setState(() {
//       _statusBarHeight = _statusBarHeight == 0.0 ? 100.0 : 0.0;
//       _currentStatus = newStatus;
//     });
//   }

//   Color _getStatusColor() {
//     switch (_currentStatus) {
//       case OrderStatus.pending:
//         return Colors.yellow;
//       case OrderStatus.submitted:
//         return Colors.green;
//       case OrderStatus.processing:
//         return Colors.blue;
//       case OrderStatus.shipped:
//         return Colors.orange;
//       case OrderStatus.delivered:
//         return Colors.teal;
//     }
//   }

//   String _getStatusText() {
//     switch (_currentStatus) {
//       case OrderStatus.pending:
//         return 'pending';
//       case OrderStatus.submitted:
//         return 'Submitted Successfully!';
//       case OrderStatus.processing:
//         return 'Processing';
//       case OrderStatus.shipped:
//         return 'Shipped';
//       case OrderStatus.delivered:
//         return 'Delivered';
//     }
//   }
// }

// class OrderScreen extends StatefulWidget {
//   @override
//   _OrderScreenState createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   final GlobalKey<_OrderStatusBarState> _orderStatusBarKey =
//       GlobalKey<_OrderStatusBarState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Screen'),
//       ),
//       body: Column(
//         children: [
//           // Your order content goes here
//           // ...

//           // Add the animated status bar
//           OrderStatusBar(
//             key: _orderStatusBarKey,
//             initialStatus: OrderStatus.pending,
//           ),

//           // Add buttons to toggle the status bar to different statuses
//           ElevatedButton(
//             onPressed: () {
//               _orderStatusBarKey.currentState
//                   ?.toggleStatusBar(OrderStatus.pending);
//             },
//             child: const Text('Pending'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _orderStatusBarKey.currentState
//                   ?.toggleStatusBar(OrderStatus.submitted);
//             },
//             child: const Text('Submitted'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _orderStatusBarKey.currentState
//                   ?.toggleStatusBar(OrderStatus.processing);
//             },
//             child: const Text('Processing'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _orderStatusBarKey.currentState
//                   ?.toggleStatusBar(OrderStatus.shipped);
//             },
//             child: const Text('Shipped'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _orderStatusBarKey.currentState
//                   ?.toggleStatusBar(OrderStatus.delivered);
//             },
//             child: const Text('Delivered'),
//           ),
//         ],
//       ),
//     );
//   }
// }
