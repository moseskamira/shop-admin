import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
 import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/ui/screens/inner_screens/product_detail.dart';
import 'package:shop_owner_app/ui/widgets/feeds_dialog.dart';
import 'package:shop_owner_app/ui/widgets/my_button.dart';

class FeedsProduct extends StatelessWidget {
  ProductModel item;
  FeedsProduct({required this.item});
  @override
  Widget build(BuildContext context) {
    double _productImageSize = MediaQuery.of(context).size.width * 0.45;
    return Container(
      width: _productImageSize,
      height: _productImageSize + 90,
      child: Material(
        elevation: 0.4,
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailScreen(detailsOfProduct: item,)));
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(
              children: [
                Container(
                  height: _productImageSize,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        /// TODO edited imageList
                          image: NetworkImage(item.imageUrls![0]),
                          onError: (object, stacktrace) => {},
                          fit: BoxFit.contain)),
                ),

                Padding(
                  padding:   EdgeInsets.only(left: 15.w, top: 9.h),
                  child: Container(
                    height: 3.5.h,
                    width: 7.w,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
                    child: Center(
                      child: Text('${item.imageUrls?.length??0}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                    )
                  ),
                ),
                Padding(
                  padding:   EdgeInsets.only(left: 35.w, top: 2.h),
                  child: Container(
                    height: 3.5.h,
                    width: 7.w,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)),
                    child: Center(
                      child: MyButton.smallIcon(
                        context: context,
                        icon: Icons.more_vert,
                       // color: Theme.of(context).buttonColor,
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => FeedsDialog(
                            product: item,
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
              margin: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '\$ ${item.price.toString()}',
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
