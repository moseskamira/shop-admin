import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/firebase_api.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/orders_provider.dart';
import 'package:shop_owner_app/core/view_models/products_stream_provider.dart';
import 'package:shop_owner_app/core/view_models/update_image_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shop_owner_app/core/models/theme_preferences.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:shop_owner_app/core/view_models/picture_provider.dart';
import 'package:shop_owner_app/core/view_models/user_data_provider.dart';
import 'package:shop_owner_app/core/view_models/theme_change_provider.dart';
import 'package:shop_owner_app/core/view_models/auth_provider.dart';
import 'core/models/orders_model.dart';
import 'core/view_models/product_upload_image_provider.dart';
import 'ui/routes/route_name.dart';
import 'ui/constants/theme_data.dart';
import 'ui/routes/router.dart';
import 'dart:developer' as devtools show log;
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  final isDarkTheme = await ThemePreferences().getTheme();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  int imageCount = await countImages();
  print("Number of images: $imageCount");

  //Number of images: 61
  runApp(MyApp(isDarkTheme: isDarkTheme));
}

Future<int> countImages() async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp();

  // Create a reference to your 'productimages' folder
  final storageRef = FirebaseStorage.instance.ref().child('productimages');

  try {
    // List all the items in the 'productimages' folder
    final result = await storageRef.listAll();

    // Return the count of images (files) in the folder
    return result.items.length;
  } catch (e) {
    print("Error counting images: $e");
    return 0;
  }
}

class MyApp extends StatelessWidget {
  final bool isDarkTheme;
  const MyApp({super.key, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            // Add other ChangeNotifierProviders
            ChangeNotifierProvider(create: (_) => ProductsProvider()),
            ChangeNotifierProvider(create: (_) => PicturesProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ImageListProductUpload()),
            ChangeNotifierProvider(create: (_) => UpdateImageProvider()),
            ChangeNotifierProvider(
                create: (_) => ThemeChangeProvider(isDarkTheme)),

            // StreamProvider for ordersWithUsers
            StreamProvider<List<Map<String, dynamic>>>(
              create: (_) => OrdersProvider().ordersWithUsers,
              initialData: [
                {
                  'order': OrdersModel.loading(),
                  'user': UserModel(),
                },
              ],
              catchError: (_, __) => [],
            ),

            // StreamProvider for usersStream
            StreamProvider<List<UserModel>>(
              create: (_) => UserDataProvider().usersStream,
              initialData: [UserModel.loading()],
              catchError: (_, __) => [UserModel.loading()],
            ),

            // StreamProvider for products
            StreamProvider<List<ProductModel>>(
              create: (_) => ProductsStreamProvider().fetchProductsStream,
              initialData: [ProductModel.loading()],
              catchError: (_, __) => [ProductModel.loading()],
            ),
          ],
          child: Consumer<ThemeChangeProvider>(
            builder: (_, themeChangeProvider, __) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Store App',
                theme: Styles.getThemeData(themeChangeProvider.isDarkTheme),
                initialRoute: RouteName.mainScreen,
                onGenerateRoute: Routes.generatedRoute,
              );
            },
          ),
        );
      },
    );
  }
}

extension Log on Object {
  void log() => devtools.log(toString());
}
