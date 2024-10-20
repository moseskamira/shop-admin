import 'package:flutter/material.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/ui/screens/bottom_bar.dart';
import 'package:shop_owner_app/ui/screens/feeds.dart';
import 'package:shop_owner_app/ui/screens/inner_screens/category_screen.dart';
import 'package:shop_owner_app/ui/screens/inner_screens/forgot_password.dart';
import 'package:shop_owner_app/ui/screens/inner_screens/product_detail.dart';
import 'package:shop_owner_app/ui/screens/log_in.dart';
import 'package:shop_owner_app/ui/screens/main_screen.dart';
import 'package:shop_owner_app/ui/screens/orders_list.dart';
import 'package:shop_owner_app/ui/screens/search.dart';
import 'package:shop_owner_app/ui/screens/sign_up.dart';
import 'package:shop_owner_app/ui/screens/upload_product.dart';


class Routes {
  static Route<dynamic> generatedRoute(RouteSettings settings){
    switch(settings.name){
      case RouteName.mainScreen:
        return MaterialPageRoute(builder: (BuildContext context) =>   MainScreen());
        case RouteName.bottomBarScreen:
        return MaterialPageRoute(builder: (BuildContext context) =>   BottomBarScreen());
        case RouteName.logInScreen:
        return MaterialPageRoute(builder: (BuildContext context) =>   LogInScreen());
        case RouteName.searchScreen:
        return MaterialPageRoute(builder: (BuildContext context) =>   SearchScreen());
        case RouteName.signUpScreen:
        return MaterialPageRoute(builder: (BuildContext context) =>   SignUpScreen());
        case RouteName.forgotPasswordScreen:
        return MaterialPageRoute(builder: (BuildContext context) =>   ForgotPasswordScreen());
        case RouteName.productDetailScreen:
        return MaterialPageRoute(builder: (BuildContext context) =>   ProductDetailScreen());
        case RouteName.feedsScreen:
        return MaterialPageRoute(builder: (BuildContext context) =>   FeedsScreen());
        case RouteName.categoryScreen:
        return MaterialPageRoute(builder: (BuildContext context) =>   CategoryScreen());
        case RouteName.uploadProductScreen:
        return MaterialPageRoute(builder: (BuildContext context) =>   UploadProductScreen());
        case RouteName.ordersListScreen:
        return MaterialPageRoute(builder: (BuildContext context) =>   PendingOrdersList());


      default:
        return MaterialPageRoute(builder: (_){
          return const Scaffold(
            body: Center(
              child: Text("No route defined"),
            ),
          );
        });
    }}
}