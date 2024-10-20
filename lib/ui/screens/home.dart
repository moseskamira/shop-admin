import 'package:flutter/material.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/core/models/category_model.dart';
import 'package:shop_owner_app/ui/screens/nav_bar.dart';
import 'package:shop_owner_app/ui/widgets/category.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];

  getCategories() {
    categories = CategoryModel().getCategories();
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text("CATEGORIES"),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.remove_red_eye_sharp,
                color: Colors.white, // Change Custom Drawer Icon Color
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RouteName.searchScreen);
              },
              child: Icon(
                Icons.search,
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
              // Padding(
              //   padding:   EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
              //   child: Container(height: 5.h,
              //   decoration: BoxDecoration(
              //       border: Border.all(color: Colors.black, width: .3),
              //       color: Colors.white, borderRadius: BorderRadius.circular(7)),
              //   child: Center(
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text("Add new Category", style: TextStyle(color: Colors.black, fontSize: 17),),
              //         Gap(5.w),
              //         Gap(5.w),
              //         Icon(Icons.add, color: Colors.black,)
              //       ],
              //     ),
              //   ),),
              // ),
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
                  itemCount: categories.length,
                  itemBuilder: (ctx, index) {
                    return Category(category: categories[index]);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
