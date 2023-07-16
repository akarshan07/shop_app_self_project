import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {

  final bool isFavorite;
  ProductsGrid(this.isFavorite);

  @override
  Widget build(BuildContext context) {
    final products =  Provider.of<Products>(context);
    final productsData = isFavorite ? products.favoriteProduct : products.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: productsData[index],
        child: ProductItem(
          // id: productsData[index].id,
          // title: productsData[index].title,
          // imageUrl: productsData[index].imageUrl,
        ),
      ),
      itemCount: productsData.length,
    );
  }
}
