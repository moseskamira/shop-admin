import 'package:flutter/material.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/core/models/category_model.dart';
import 'package:shop_owner_app/ui/screens/nav_bar.dart';
import 'package:shop_owner_app/ui/widgets/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];

  getCategories() {
    categories = CategoryModel().getCategories();
    categories.sortByTitle();
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text("CATEGORIES"),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.remove_red_eye_sharp,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RouteName.searchScreen);
              },
              child: const SizedBox(
                height: 20,
                width: 30,
                child: Icon(
                  Icons.search,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 120,
                ),
                itemCount: categories.length + 1,
                itemBuilder: (ctx, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        // Handle add category action
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Add A New Category"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                addNewCategory(context, 'Category Icon'),
                                const TextField(
                                  decoration: InputDecoration(
                                      hintText: 'Type a category name..'),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("CANCEL"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("ADD"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: addNewCategory(context, 'New Category'),
                    );
                  }
                  return Category(category: categories[index - 1]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension CategoryList on List<CategoryModel> {
  void sortByTitle() {
    sort((a, b) => a.title.compareTo(b.title));
  }
}

Widget addNewCategory(BuildContext context, String name) {
  double imageSize = 70;
  return SizedBox(
    width: 100,
    height: 100,
    child: Column(
      children: [
        Container(
          height: imageSize,
          width: imageSize,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Colors.deepPurple[50],
          ),
          child: Center(
            child: Icon(
              Icons.add,
              size: 35,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ],
    ),
  );
}
