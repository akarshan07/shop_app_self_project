import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {

  static const routeName = '/userProduct-Screen';
  
  Future<void> _refreshIndicator(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          }, icon: Icon(Icons.add)),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshIndicator(context),
        builder:(ctx,snapshot)=>  snapshot.connectionState == ConnectionState.waiting?Center(child: CircularProgressIndicator()):RefreshIndicator(
          onRefresh: ()=>_refreshIndicator(context),
          child: Consumer<Products>(
            builder:(ctx,productData,_)=> Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (ctx,index) => Column(
                  children: [
                    UserProductItem(
                      id: productData.items[index].id,
                      title: productData.items[index].title,
                      imageUrl: productData.items[index].imageUrl,
                    ),
                    const Divider(),
                  ],
                ),
                itemCount: productData.items.length,),
            ),
          ),
        ),
      ),
    );
  }
}
