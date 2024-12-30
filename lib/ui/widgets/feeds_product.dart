import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:sizer/sizer.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/ui/widgets/feeds_dialog.dart';
import 'package:shop_owner_app/ui/widgets/my_button.dart';

class FeedsProduct extends StatelessWidget {
  final ProductModel product;
  const FeedsProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double productImageSize = MediaQuery.of(context).size.width * 0.45;
    return SizedBox(
      width: productImageSize,
      height: productImageSize + 90,
      child: Material(
        elevation: 0.4,
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(RouteName.productDetailScreen,
                arguments: {'productId': product.id});
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(
              children: [
                Container(
                  height: productImageSize,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrls![0],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w, top: 9.h),
                  child: Container(
                      height: 3.5.h,
                      width: 7.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(17)),
                      child: Center(
                        child: Text(
                          '${product.imageUrls?.length ?? 0}',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35.w, top: 2.h),
                  child: Container(
                    height: 3.5.h,
                    width: 7.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                      child: MyButton.smallIcon(
                        context: context,
                        icon: Icons.more_vert,
                        color: Theme.of(context).colorScheme.tertiary,
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => FeedsDialog(
                              product: product,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$ ${product.price.toString()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
