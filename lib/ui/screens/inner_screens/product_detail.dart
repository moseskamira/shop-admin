import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:sizer/sizer.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/ui/widgets/products_images_list_on_details_view.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel? detailsOfProduct;
  const ProductDetailScreen({super.key, required this.detailsOfProduct});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool loadingOnDeletion = false;
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: loadingOnDeletion,
      progressIndicator: Center(
        child: SpinKitFadingCircle(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.white : Colors.green,
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductImagesListWidget(
                        productImgList:
                            widget.detailsOfProduct?.imageUrls ?? []),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).cardColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Product Name
                                Text(
                                  widget.detailsOfProduct?.name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(height: 10),

                                //Product Price

                                Text(
                                  '\$ ${widget.detailsOfProduct?.price}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Product sales and Wishlist Button
                              ],
                            ),
                          ),

                          // Details and Description

                          _sectionContainer(
                            'Details',
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _detailsRow('Brand',
                                      widget.detailsOfProduct?.brand ?? ""),
                                  _detailsRow(
                                      'Quatity',
                                      widget.detailsOfProduct?.quantity
                                              .toString() ??
                                          ""),
                                  _detailsRow('Category',
                                      widget.detailsOfProduct?.category ?? ""),
                                  _detailsRow(
                                      'Popularity',
                                      (widget.detailsOfProduct?.isPopular ??
                                              true)
                                          ? 'Popular'
                                          : 'Not Popular'),

                                  const SizedBox(height: 10),

                                  // Description

                                  SizedBox(
                                      width: 90.w,
                                      child: Text(
                                        widget.detailsOfProduct?.description ??
                                            "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17),
                                      )),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 60),
                        ],
                      )),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(7)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  loadingOnDeletion = true;
                                });
                                await productsProvider
                                    .deleteProduct(
                                        id: widget.detailsOfProduct!.id,
                                        imageUrlsOnFirebaseStorage: widget
                                                .detailsOfProduct!.imageUrls ??
                                            [])
                                    .then((value) {
                                  setState(() {
                                    loadingOnDeletion = false;
                                  });
                                  Navigator.pop(context);
                                });
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "DELETE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(Icons.delete, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(7)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    RouteName.updateProductScreen,
                                    arguments: {
                                      'productModel': widget.detailsOfProduct!,
                                    });
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "EDIT",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(Icons.edit_note_sharp,
                                      color: Colors.white)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _sectionContainer(String title, Widget child) {
    return Container(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 10),
          child,
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _detailsRow(String key, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(key)),
          Expanded(flex: 2, child: Text(value)),
        ],
      ),
    );
  }
}
