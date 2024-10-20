import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:shop_owner_app/core/view_models/product_provider.dart';
import 'package:shop_owner_app/ui/widgets/feeds_product.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<ProductModel>? allProducts = [];
  List<ProductModel>? categorizedItems = [];

  @override
  Widget build(BuildContext context) {
    allProducts?.clear();
    categorizedItems?.clear();

    final productsProvider = Provider.of<ProductsProvider>(context);
    final title = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: productsProvider.fetchProductsAsStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            allProducts?.clear();
            categorizedItems?.clear();
            snapshot.data?.docs.forEach((element) {
              Map<String, dynamic> map = element.data() as Map<String, dynamic>;
              allProducts?.add(ProductModel.fromJson(map));
            });

            if (allProducts != null) {
              for (ProductModel category in allProducts!) {
                if (category.category == title) {
                  categorizedItems?.add(category);
                }
              }
            }
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.width) /
                    (MediaQuery.of(context).size.width + 190),
                mainAxisSpacing: 8,
                children: List.generate(
                  categorizedItems?.length ?? 0,
                  (index) => ChangeNotifierProvider.value(
                    value: categorizedItems?[index],
                    child: Center(
                      child: FeedsProduct(item: categorizedItems![index]),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: SpinKitFadingCircle(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.white : Colors.green,
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
