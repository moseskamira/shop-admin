import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/ui/widgets/feeds_product.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feeds',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: Provider.of<ProductsProvider>(context).fetchProductsStream,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred. Please try again later.'),
            );
          }

          if (snapshot.hasData) {
            final products = snapshot.data!;

            if (products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (MediaQuery.of(context).size.width) /
                      (MediaQuery.of(context).size.width + 190),
                  mainAxisSpacing: 8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: products[index],
                    child: Center(
                      child: FeedsProduct(product: products[index]),
                    ),
                  );
                },
              ),
            );
          }

          // No data fallback
          return const Center(child: Text('No products found.'));
        },
      ),
    );
  }
}
