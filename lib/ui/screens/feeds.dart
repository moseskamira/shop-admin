import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/ui/widgets/feeds_product.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  bool isLoadingOnDeletion = false;

  @override
  Widget build(BuildContext context) {

  final prouducts = Provider.of<List<ProductModel>>(context);
    final isLoading = prouducts.length == 1 && prouducts.first.id.isEmpty;

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
      body: isLoading
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
        
      
    
  

