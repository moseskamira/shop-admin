import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shop_owner_app/core/models/category_model.dart';
import 'package:shop_owner_app/ui/screens/nav_bar.dart';
import 'package:shop_owner_app/ui/utils/common_functions.dart';
import 'package:shop_owner_app/ui/widgets/category.dart';

import '../routes/route_name.dart';
import '../widgets/add_category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => setState(() {
        categories = CategoryModel.getCategories().sortedBy((k) => k.title);
      }),
    );
  }

  void _showAddCategoryDialog(AppLocalizations appLocal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          appLocal.addNewCategory,
          style: CommonFunctions.appTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            textColor: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AddCategoryCard(
              name: appLocal.categoryIcon,
            ),
            TextField(
              decoration: InputDecoration(hintText: appLocal.typeCategoryName),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(appLocal.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(appLocal.add),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      endDrawer: const NavBar(),
      appBar: AppBar(
        title: Text(appLocalizations.categories.toUpperCase()),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            onTap: () =>
                Navigator.of(context).pushNamed(RouteName.searchScreen),
            child: const Icon(Icons.search),
          ),
        ),
        actions: [
          Builder(
            builder: (BuildContext ctx) {
              return IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                tooltip: MaterialLocalizations.of(ctx).openAppDrawerTooltip,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 120,
            ),
            itemCount: categories.length + 1,
            itemBuilder: (ctx, index) {
              return index == 0
                  ? GestureDetector(
                      onTap: () {
                        _showAddCategoryDialog(appLocalizations);
                      },
                      child: AddCategoryCard(
                        name: appLocalizations.newCategory,
                      ),
                    )
                  : Category(category: categories[index - 1]);
            },
          ),
        ),
      ),
    );
  }
}
