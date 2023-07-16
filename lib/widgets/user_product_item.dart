import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {

  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({
    required this.id,
    required this.title,
    required this.imageUrl,
});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
          }, icon: Icon(Icons.edit,color: Colors.purple,),),
          IconButton(onPressed: ()async{
            try {
              await Provider.of<Products>(context, listen: false).removeProduct(id);
            }catch(error){
              scaffold.showSnackBar(SnackBar(content: Text(error.toString(),textAlign: TextAlign.center,)));
            }

          }, icon: Icon(Icons.delete,color: Theme.of(context).errorColor,),),
        ],),
      ),
    );
  }
}
