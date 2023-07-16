import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './providers/cart.dart';
import 'package:provider/provider.dart';
import './screens/product_overview_screen.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/products.dart';
import './providers/orders.dart';

void main(){
runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]
    );
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (ctx)=>Auth(),),
        ChangeNotifierProxyProvider<Auth,Products>(
        create: (ctx)=> Products(null,null,[]),
        update: (ctx,authData,previousProducts)=>Products(authData.token,authData.userId,previousProducts?.items??[]),
        ),
        ChangeNotifierProvider(
          create: (ctx)=> Cart(),),
        ChangeNotifierProxyProvider<Auth,Orders>(
          create: (ctx)=>Orders(null,null,[]),
          update: (ctx,authData,previousOrders)=>Orders(authData.token,authData.userId,previousOrders?.items??[]),
        ),
    ],
      child: Consumer<Auth>(
        builder:(ctx,authData,_)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Shop App',
          theme: ThemeData(
            //appBarTheme: AppBarTheme(color: Colors.purple),
            primaryColor: Colors.deepOrange,
            primarySwatch: Colors.purple,
            chipTheme: ChipThemeData(backgroundColor: Colors.purple.shade500,labelStyle: const TextStyle(color: Colors.white)),
            fontFamily: 'Lato',
          ),
          home: authData.isAuth ? ProductOverviewScreen() : FutureBuilder(
            future: authData.tryAutoLogin(),
            builder: (ctx,snapShotData) => snapShotData.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
          ),
          routes: {
            ProductDetailScreen.routeName : (ctx)=>ProductDetailScreen(),
            CartScreen.routeName: (ctx)=> CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
