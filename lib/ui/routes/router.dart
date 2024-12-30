import 'package:flutter/material.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/ui/screens/bottom_bar.dart';
import 'package:shop_owner_app/ui/screens/feeds.dart';
import 'package:shop_owner_app/ui/screens/inner_screens/category_screen.dart';
import 'package:shop_owner_app/ui/screens/inner_screens/forgot_password.dart';
import 'package:shop_owner_app/ui/screens/inner_screens/users_location.dart';
import 'package:shop_owner_app/ui/screens/inner_screens/product_detail.dart';
import 'package:shop_owner_app/ui/screens/log_in.dart';
import 'package:shop_owner_app/ui/screens/main_screen.dart';
import 'package:shop_owner_app/ui/screens/orders_list.dart';
import 'package:shop_owner_app/ui/screens/search.dart';
import 'package:shop_owner_app/ui/screens/sign_up.dart';
import 'package:shop_owner_app/ui/screens/upload_product.dart';
import 'package:shop_owner_app/ui/screens/user_details.dart';
import '../../core/models/product_model.dart';
import '../../core/models/user_model.dart';
import '../screens/update_product.dart';
import '../screens/update_users_inofrmation.dart';

class Routes {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.mainScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen());
      case RouteName.bottomBarScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const BottomBarScreen());
      case RouteName.logInScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LogInScreen());
      case RouteName.searchScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SearchScreen());
      case RouteName.signUpScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUpScreen());
      case RouteName.forgotPasswordScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ForgotPasswordScreen());
      case RouteName.productDetailScreen:
        Map<String, Object>? args = settings.arguments as Map<String, Object>;
        String productId = args['productId'] as String;
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductDetailScreen(
                  productId: productId,
                ));

      case RouteName.updateProductScreen:
        Map<String, Object>? args = settings.arguments as Map<String, Object>;
        ProductModel productModel = args['productModel'] as ProductModel;
        return MaterialPageRoute(
            builder: (BuildContext context) => UpdateProductScreen(
                  singleProductDtaforUpdate: productModel,
                ));

      case RouteName.feedsScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FeedsScreen());
      case RouteName.categoryScreen:
        Map<String, Object>? args = settings.arguments as Map<String, Object>;
        String cat = args['cat'] as String;
        return MaterialPageRoute(
            builder: (BuildContext context) => CategoryScreen(
                  nameOfCat: cat,
                ));
      case RouteName.uploadProductScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UploadProductScreen());
      case RouteName.ordersListScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const OrdersList());

      case RouteName.userDetailsScreen:
        Map<String, Object>? args = settings.arguments as Map<String, Object>;
        UserModel user = args['user'] as UserModel;
        return MaterialPageRoute(
            builder: (BuildContext context) => UserDetails(
                  user: user,
                ));

      case RouteName.usersLocation:
        Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>;
        double lat = args['lat'] as double;
        double lon = args['lon'] as double;
        String name = args['name'] as String; //'name'
        return MaterialPageRoute(
            builder: (BuildContext context) => UsersLocations(
                  latitude: lat,
                  longitude: lon,
                  name: name,
                ));

      case RouteName.updateUserInfo:
        final UserModel userModel = settings.arguments as UserModel;

        return MaterialPageRoute(
            builder: (BuildContext context) =>
                UpdateUsersInformation(userModel: userModel));

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text("No route defined"),
            ),
          );
        });
    }
  }
}
