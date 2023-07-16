import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {

  final String title;
  final String productId;
  final String id;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(productId),
      background: Container(
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        child: Icon(Icons.delete,color: Colors.white,size: 30,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
          Provider.of<Cart>(context,listen: false).removeItem(productId);
      },
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (ctx)=>AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you really want to remove this product?'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(ctx).pop(false);
            }, child: Text('No')),
            TextButton(onPressed: (){
              Navigator.of(ctx).pop(true);
            }, child: Text('yes'),),
          ],
        ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            leading: CircleAvatar(child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: FittedBox(child: Text('\$$price'),),
            ),),
            title: Text(title),
            subtitle: Text('Total: ${(price*quantity)}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }
}
