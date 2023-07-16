import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {

  // final String title;
  // ProductDetailScreen({required this.title});

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context)!.settings.arguments.toString();
    final loadedProduct = Provider.of<Products>(context,listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(loadedProduct.imageUrl,height: 300,width: double.infinity,fit: BoxFit.cover,),
            const SizedBox(height: 20,),
            Text('\$${loadedProduct.price.toString()}',style: TextStyle(fontSize: 30,color: Colors.grey),),
            const SizedBox(height: 20,),
             Container(
               padding: const EdgeInsets.all(8.0),
               alignment: Alignment.center,
               child: Text(loadedProduct.description,style: TextStyle(fontSize: 18),),
             ),
          ],
        ),
      ),
    );
  }
}
