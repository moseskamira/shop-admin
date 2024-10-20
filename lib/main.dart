/// this section is my main app

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shop_owner_app/core/models/theme_preferences.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:shop_owner_app/core/view_models/product_provider.dart';
import 'package:shop_owner_app/core/view_models/picture_provider.dart';
import 'package:shop_owner_app/core/view_models/user_data_provider.dart';
import 'package:shop_owner_app/firebase_options.dart';
import 'package:shop_owner_app/core/view_models/theme_change_provider.dart';
import 'package:shop_owner_app/core/view_models/auth_provider.dart';
import 'package:shop_owner_app/ui/screens/update_product.dart';
import 'package:shop_owner_app/ui/screens/user_info.dart';
import 'ui/routes/route_name.dart';
import 'ui/constants/theme_data.dart';
import 'ui/screens/bottom_bar.dart';
import 'ui/screens/feeds.dart';
import 'ui/screens/inner_screens/category_screen.dart';
import 'ui/screens/inner_screens/forgot_password.dart';
import 'ui/screens/inner_screens/product_detail.dart';
import 'ui/screens/log_in.dart';
import 'ui/screens/main_screen.dart';
import 'ui/screens/orders_list.dart';
import 'ui/screens/search.dart';
import 'ui/screens/sign_up.dart';
import 'ui/screens/upload_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  final isDarkTheme = await ThemePreferences().getTheme();
  // Step 3
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(
        MyApp(
          isDarkTheme: isDarkTheme,
        ),
      ));
}

class MyApp extends StatelessWidget {
  final bool isDarkTheme;

  const MyApp({Key? key, required this.isDarkTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return ChangeNotifierProvider(
        create: (_) => ThemeChangeProvider(isDarkTheme),
        child: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return MultiProvider(
                  providers: [
                    /// fetching category products using api locator
                    ChangeNotifierProvider(create: (_) => ProductsProvider()),
                    ChangeNotifierProvider(create: (_) => PicturesProvider()),

                    ChangeNotifierProvider(create: (_) => AuthProvider()),
                    ChangeNotifierProvider(create: (_) => UserDataProvider()),
                  //  ChangeNotifierProvider(create: (_) => ProductProvider()),
                  ],
                  child: Consumer<ThemeChangeProvider>(
                    builder: (_, themeChangeProvider, __) {
                      return MaterialApp(
                          debugShowCheckedModeBanner: false,
                          title: 'Store App',
                          theme: Styles.getThemeData(
                              themeChangeProvider.isDarkTheme),

                          /// onGenerateRoute: Routes.generatedRoute,
                          routes: {
                            RouteName.mainScreen: (context) => MainScreen(),
                            RouteName.bottomBarScreen: (context) =>
                                BottomBarScreen(),
                            RouteName.logInScreen: (contex) =>
                                const LogInScreen(),
                            RouteName.signUpScreen: (context) =>
                                const SignUpScreen(),
                            RouteName.forgotPasswordScreen: (context) =>
                                const ForgotPasswordScreen(),
                            RouteName.productDetailScreen: (context) =>
                                  ProductDetailScreen(),
                            RouteName.feedsScreen: (context) => FeedsScreen(),
                            RouteName.categoryScreen: (context) =>
                                CategoryScreen(),
                            RouteName.searchScreen: (context) => const SearchScreen(),
                            RouteName.updateProductScreen: (context) =>
                                UpdateProductScreen(),
                            RouteName.userInfoScreen: (context) =>
                                UserInfoScreen(),
                          });
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Consumer<ThemeChangeProvider>(
                  builder: (_, themeChangeProvider, __) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: Styles.getThemeData(themeChangeProvider.isDarkTheme),
                    home: const Scaffold(
                      body: Center(child: Text('Something went wrong :(')),
                    ),
                  ),
                );
              }
              return Consumer<ThemeChangeProvider>(
                builder: (_, themeChangeProvider, __) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: Styles.getThemeData(themeChangeProvider.isDarkTheme),
                  home: Scaffold(
                    body: Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )),
                  ),
                ),
              );
            }),
      );
    });
  }
}
