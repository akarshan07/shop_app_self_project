import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';

enum filterOption{
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {

  bool _showOnlyFavorite = false;
  var _isLoading = false;

  @override
  void initState() {
    setState((){
      _isLoading = true;
    });
    Provider.of<Products>(context,listen: false).fetchAndSetProducts().then((_){
      setState((){
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop App'),
        actions: [
          Consumer<Cart>(
              builder: (ctx,cart,_)=>Badge(
                  child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
                Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                  ), value: cart.quantity.toString())),
          PopupMenuButton(
            itemBuilder: (ctx)=>[
            PopupMenuItem(child: Text('Only Favorite'),value: filterOption.Favorite,),
            PopupMenuItem(child: Text('Show All'),value: filterOption.All,),
          ],
            icon: Icon(Icons.more_vert_rounded),
            onSelected: (filterOption selectedValue){

            setState(() {
              if(selectedValue == filterOption.Favorite){
                _showOnlyFavorite = true;
              }else{
                _showOnlyFavorite = false;
              }}
            );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading? Center(child: CircularProgressIndicator(),) : ProductsGrid(_showOnlyFavorite),
    );
  }
}

