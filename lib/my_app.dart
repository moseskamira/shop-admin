import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/ui/constants/app_theme.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/ui/routes/router.dart';
import 'package:sizer/sizer.dart';

import 'core/l10n/l10n.dart';
import 'core/view_models/auth_provider.dart';
import 'core/view_models/orders_provider.dart';
import 'core/view_models/picture_provider.dart';
import 'core/view_models/product_upload_image_provider.dart';
import 'core/view_models/products_provider.dart';
import 'core/view_models/search_provider.dart';
import 'core/view_models/theme_change_provider.dart';
import 'core/view_models/update_image_provider.dart';
import 'core/view_models/user_data_provider.dart';

class MyApp extends StatelessWidget {
  final bool isDarkTheme;

  const MyApp({super.key, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    const List<LocalizationsDelegate> localizationDelegates = [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => UserDataProvider()),
            ChangeNotifierProvider(create: (_) => ProductsProvider()),
            ChangeNotifierProvider(create: (_) => PicturesProvider()),
            ChangeNotifierProvider(create: (_) => ImageListProductUpload()),
            ChangeNotifierProvider(create: (_) => UpdateImageProvider()),
            ChangeNotifierProvider(create: (_) => OrdersProvider()),
            ChangeNotifierProvider(create: (_) => SearchProvider()),
            ChangeNotifierProvider(
              create: (_) => ThemeChangeProvider(isDarkTheme),
            ),
          ],
          child: Consumer<ThemeChangeProvider>(
            builder: (_, themeChangeProvider, __) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Store App',
                theme: AppTheme.getThemeData(themeChangeProvider.isDarkTheme),
                initialRoute: RouteName.mainScreen,
                onGenerateRoute: Routes.generatedRoute,
                supportedLocales: L10n.allLocals,
                locale: const Locale('en'),
                localizationsDelegates: localizationDelegates,
              );
            },
          ),
        );
      },
    );
  }
}
