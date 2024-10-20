
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:shop_owner_app/ui/constants/app_consntants.dart';
import 'package:shop_owner_app/ui/screens/update_product.dart';
import 'package:shop_owner_app/ui/widgets/my_button.dart';

class FeedsDialog extends StatefulWidget {
  var product;
  FeedsDialog({Key? key, this.product}) : super(key: key);

  @override
  State<FeedsDialog> createState() => _FeedsDialogState();
}

class _FeedsDialogState extends State<FeedsDialog> {
  bool loadingOnDeletion = false;


  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);


    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: SingleChildScrollView(
        child: loadingOnDeletion? Center(
          child: SpinKitFadingCircle(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.white : Colors.green,
                ),
              );
            },
          ),
        ):Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [

              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(

                          /// TODO edited imageList
                            image: NetworkImage(widget.product.imageUrls![0]),
                            fit: BoxFit.contain)),
                  ),
                  Positioned(
                    right: 2,
                    child: MyButton.smallIcon(
                      context: context,
                      icon: mCloseIcon,
                      onPressed: () => Navigator.canPop(context)
                          ? Navigator.pop(context)
                          : null,
                    ),
                  )
                ],
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
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
                                    .removeProduct(id: widget.product.id, imageUrlsOnFirebaseStorage: widget.product.imageUrls).then((value) {
                                  setState(() {
                                    loadingOnDeletion = false;
                                  });
                                  Navigator.pop(context);
                                });

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Delete",
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
                    const VerticalDivider(width: 1, thickness: 1),
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
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateProductScreen(singleProductDtaforUpdate: widget.product,)));

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(Icons.edit_note_sharp, color: Colors.white)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
