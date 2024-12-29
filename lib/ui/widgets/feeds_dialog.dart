import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:shop_owner_app/ui/constants/app_consntants.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/ui/widgets/my_button.dart';
import '../../core/models/product_model.dart';

class FeedsDialog extends StatefulWidget {
  final ProductModel product;
  const FeedsDialog({super.key, required this.product});

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
        child: loadingOnDeletion
            ? Center(
                child: SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.white : Colors.green,
                      ),
                    );
                  },
                ),
              )
            : SizedBox(
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
                                  image: NetworkImage(
                                      widget.product.imageUrls![0]),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        loadingOnDeletion = true;
                                      });
                                      await productsProvider
                                          .deleteProduct(
                                              id: widget.product.id,
                                              imageUrlsOnFirebaseStorage:
                                                  widget.product.imageUrls ??
                                                      [])
                                          .then((value) {
                                        setState(() {
                                          loadingOnDeletion = false;
                                        });
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    onTap: () {
                                      
                                       Navigator.of(context).pushNamed(
                                  RouteName.updateProductScreen,
                                  arguments: {
                                    'productModel':  widget.product,
                                  }).then((_){
                                    Navigator.pop(context);
                                  });
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Edit",
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
                          const SizedBox(
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
