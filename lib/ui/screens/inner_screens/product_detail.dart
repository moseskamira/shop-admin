import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/core/view_models/product_provider.dart';
import 'package:shop_owner_app/ui/widgets/products_images_list_on_details_view.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductModel? detailsOfProduct;
  ProductDetailScreen({super.key, this.detailsOfProduct});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductImagesListOnDetailsView(
                    product: widget.detailsOfProduct),
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
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: 10),

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
                            SizedBox(height: 10),

                            // Product sales and Wishlist Button
                          ],
                        ),
                      ),

                      // Details and Description

                      _sectionContainer(
                        'Details',
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  (widget.detailsOfProduct?.isPopular ?? true)
                                      ? 'Popular'
                                      : 'Not Popular'),

                              SizedBox(height: 10),

                              // Description

                              SizedBox(
                                  width: 90.w,
                                  child: Text(
                                    widget.detailsOfProduct?.description ?? "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17),
                                  )),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 60),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionContainer(String title, Widget child) {
    return Container(
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(height: 10),
          child,
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _detailsRow(String key, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(key)),
          Expanded(flex: 2, child: Text(value)),
        ],
      ),
    );
  }
}
