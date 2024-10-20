 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:shop_owner_app/ui/widgets/feeds_product.dart';

class FeedsScreen extends StatefulWidget {
  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  List<ProductModel>? allProducts = [];
  bool isLoadingOnDeletion = false;
  @override
  Widget build(BuildContext context) {
    allProducts?.clear();
      final productsProvider = Provider.of<ProductsProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: isLoadingOnDeletion,
      child: Scaffold(
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
           body:  StreamBuilder(
             stream: productsProvider.fetchProductsAsStream(),
             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
               if (snapshot.hasData) {
                 allProducts?.clear();
                 snapshot.data?.docs.forEach((element) {
                   Map<String, dynamic> map =
                   element.data() as Map<String, dynamic>;
                   allProducts?.add(ProductModel.fromJson(map));
                 });
                 return Container(
                   margin:const  EdgeInsets.symmetric(horizontal: 8),
                   child: GridView.count(
                     crossAxisCount: 2,
                     childAspectRatio: (MediaQuery.of(context).size.width) /
                         (MediaQuery.of(context).size.width + 190),
                     mainAxisSpacing: 8,
                     children: List.generate(
                       allProducts?.length ?? 0,
                           (index) => ChangeNotifierProvider.value(
                         value: allProducts?[index],
                         child: Center(
                           child: FeedsProduct(item: allProducts![index]),
                         ),
                       ),
                     ),
                   ),
                 );
               } else {
                 return   Center(
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
           // body: SingleChildScrollView(
           //   scrollDirection: Axis.vertical,
           //   child: Column(
           //     children: [
           //       Padding(
           //         padding:   EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
           //         child: Container(height: 5.h,
           //           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7),
           //
           //           border: Border.all(color: Colors.black12)
           //           ),
           //           child: Center(
           //             child: Row(
           //               mainAxisAlignment: MainAxisAlignment.center,
           //               children: [
           //                 Text("Total Products", style: TextStyle(color: Colors.black, fontSize: 17),),
           //                 Gap(5.w),
           //
           //                 Text("33", style: TextStyle(color: Colors.black, fontSize: 17),),
           //               ],
           //             ),
           //           ),),
           //       ),
           //
           //     ],
           //   ),
           // )


      ),
    );
  }
}


