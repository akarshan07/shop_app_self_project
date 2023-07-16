import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {

  final ord.OrderItem order;


  OrderItem({
   required this.order,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy   hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(icon: _isExpanded? const Icon(Icons.expand_less) : const Icon(Icons.expand_more),onPressed: (){
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },),
          ),
          if(_isExpanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: min(widget.order.cartItem.length * 20 + 30, 100),
              child: ListView(
                children: widget.order.cartItem.map((prod) =>Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(prod.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    Text('\$${prod.price} x ${prod.quantity}'),
                  ],
                )).toList(),
              ),
            )
        ],
      ),
    );
  }
}
