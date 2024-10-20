import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:shop_owner_app/ui/constants/assets_path.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/ui/widgets/feeds_product.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;

  List<ProductModel> _searchList = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _focusNode.dispose();
  }

  List<ProductModel>? allProducts = [];

  @override
  Widget build(BuildContext context) {
    allProducts?.clear();
    final productsProvider = Provider.of<ProductsProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: StreamBuilder(
        stream: productsProvider.fetchProductsAsStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            allProducts?.clear();
            snapshot.data?.docs.forEach((element) {
              Map<String, dynamic> map = element.data() as Map<String, dynamic>;
              allProducts?.add(ProductModel.fromJson(map));
            });
            return Scaffold(
              appBar: AppBar(
                title: _searchBar(allProducts!),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                centerTitle: true,
              ),
              body: Center(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: _searchController.text.isEmpty || _searchList.isEmpty
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: _searchController.text.isNotEmpty
                                ? Text(
                                    'No results found :(',
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      // color: Theme.of(context).buttonColor
                                    ),
                                  )
                                : SvgPicture.asset(
                                    ImagePath.search,
                                  ),
                          )
                        : _showSearchResults()),
              ),
            );
          } else {
            return Center(
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
    );
  }

  Widget _showSearchResults() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (MediaQuery.of(context).size.width) /
          (MediaQuery.of(context).size.width + 184),
      mainAxisSpacing: 8,
      children: List.generate(
        _searchList.length,
        (index) => ChangeNotifierProvider.value(
          value: _searchList[index],
          child: Center(
            child: FeedsProduct(item: _searchList[index]),
          ),
        ),
      ),
    );
  }

  Widget _searchBar(List<ProductModel> allProducts) {
    return Material(
      elevation: 1,
      child: TextField(
        focusNode: _focusNode,
        autofocus: true,
        controller: _searchController,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Theme.of(context).cardColor,
          filled: true,
          isDense: true,
          hintText: 'Search',
          hintStyle: TextStyle(
              //color: Theme.of(context).buttonColor
              ),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: _searchController.text.isEmpty
                      ? null
                      : () {
                          _searchController.clear();
                          _focusNode.unfocus();
                        },
                  iconSize: 14,
                  //  color: Theme.of(context).buttonColor,
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                  padding: EdgeInsets.zero,
                  splashRadius: 14,
                ),
          suffixIconConstraints: const BoxConstraints(maxHeight: 14),
        ),
        onChanged: (value) {
          _searchController.text.toLowerCase();
          _searchList = allProducts
              .where((element) =>
                  element.name.toLowerCase().contains(value.toLowerCase()) ||
                  element.category
                      .toLowerCase()
                      .contains(value.toLowerCase()) ||
                  element.brand.toLowerCase().contains(value.toLowerCase()))
              .toList();
        },
      ),
    );
  }
}
