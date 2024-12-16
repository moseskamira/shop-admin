import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/product_model.dart';
import '../../widgets/feeds_product.dart';


class CategoryScreen extends StatelessWidget {
  final String nameOfCat;
  const CategoryScreen({super.key, required this.nameOfCat});

  @override
  Widget build(BuildContext context) { 
  final prouducts =  Provider.of<List<ProductModel>>(context)
    .where((product) => product.category == nameOfCat)
    .toList();
    final isLoading = prouducts.length == 1 && prouducts.first.id.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          nameOfCat,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body:isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : prouducts.isEmpty
              ? const Center(
                  child: Text('No products found.'),
                )
              :  Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.width) /
                    (MediaQuery.of(context).size.width + 190),
                mainAxisSpacing: 8,
              ),
              itemCount: prouducts.length,
              itemBuilder: (context, index) {

                return ChangeNotifierProvider.value(
                  value: prouducts[index],
                  child: Center(
                    child: FeedsProduct(item: prouducts[index]),
                  ),
                );
              },
            ),
          ));
          }}
        
      
    
  

