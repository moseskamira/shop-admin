import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ecommerce_admin_app/ui/constants/app_consntants.dart';
import 'package:ecommerce_admin_app/ui/routes/route_name.dart';

class PendingOrdersList extends StatefulWidget {
  const PendingOrdersList({Key? key}) : super(key: key);

  @override
  State<PendingOrdersList> createState() => _PendingOrdersListState();
}

class _PendingOrdersListState extends State<PendingOrdersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7)),
                  child: const Center(
                      child: Text(
                    "Total Sales 77",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                ),
              ),
              /// one oder static

               SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Order Date: May 12-2023"),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Divider(
                      height: 4,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            /// TODO will have to pass id as argument for fetching users information...
                            Navigator.of(context).pushNamed(RouteName.userInfoScreen);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue,size: 26,),

                              Text("Mr. Andrew", style: TextStyle(color: Colors.blue, fontSize: 18, ),),
                            ],
                          ),
                        ),

                        Container(
                          height: 19,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4)),
                          child: Center(
                            child: Text("Received"),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: const [

                            Icon(Icons.phone_android),
                            SizedBox(
                              width: 4,
                            ),
                            Text("01***********"),
                          ],
                        ),
                        Text(
                          "Via Paypal",
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                    SizedBox(height: 4,),

                    Row(
                      children: [
                        Icon(mShippingAddress),
                        SizedBox(
                          width: 4,
                        ),
                        Text("47RM+9FH Dubai - United Arab Emirates"),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // height and width depend on your your requirement.
                          height: 10.h,
                          width: 20.w,
                          decoration: const BoxDecoration(
                            // radius circular depend on your requirement
                            borderRadius:    BorderRadius.all(
                              Radius.circular(10),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              // image url your network image url
                              image: NetworkImage(
                                'https://www.apple.com/newsroom/images/product/iphone/standard/Apple_iPhone-13-Pro_iPhone-13-Pro-Max_09142021_inline.jpg.large.jpg',
                              ) ),
                          ),
                        ),
                        Padding(
                          padding:   EdgeInsets.only(top: 10, left: 2.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(width: 200,
                                child: Text("I Phone 13 pro", style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17
                                ),),),
                              SizedBox(height: 10,),
                              Text("Total Item ordered(10)"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 4,
                color: Colors.black,
              ),
              /// one oder static



              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Order Date: May 01-2023"),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Divider(
                      height: 4,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            ///Navigating to specific users profile
                          },
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue,size: 26,),

                              Text("Lawrance al bhagi", style: TextStyle(color: Colors.blue, fontSize: 18, ),),
                            ],
                          ),
                        ),

                        Container(
                          height: 19,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4)),
                          child: Center(
                            child: Text("Pending"),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: const [

                            Icon(Icons.phone_android),
                            SizedBox(
                              width: 4,
                            ),
                            Text("0***********"),
                          ],
                        ),
                        Text(
                          "Google Pay",
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                    SizedBox(height: 4,),

                    Row(
                      children: [
                        Icon(mShippingAddress),
                        SizedBox(
                          width: 4,
                        ),
                        Text("47RM+9FH Dubai - East ghala"),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // height and width depend on your your requirement.
                          height: 10.h,
                          width: 20.w,
                          decoration: const BoxDecoration(
                            // radius circular depend on your requirement
                            borderRadius:    BorderRadius.all(
                              Radius.circular(10),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              // image url your network image url
                              image: NetworkImage(
                               'https://www.pcworld.com/wp-content/uploads/2023/04/oneplus-5-logo-100727167-orig-1.jpg?quality=50&strip=all&w=1024',                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:   EdgeInsets.only(top: 10, left: 2.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(width: 200,
                                child: Text("One+5", style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17
                                ),),),
                              SizedBox(height: 10,),
                              Text("Total Item ordered(1)"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 4,
                color: Colors.black,
              ),
              /// one oder static


                SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Order Date: April 01-2023"),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Divider(
                      height: 4,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            ///Navigating to specific users profile
                          },
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue,size: 26,),

                              Text("Shakila al zaman", style: TextStyle(color: Colors.blue, fontSize: 18, ),),
                            ],
                          ),
                        ),

                        Container(
                          height: 19,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4)),
                          child: Center(
                            child: Text("Received"),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: const [

                            Icon(Icons.phone_android),
                            SizedBox(
                              width: 4,
                            ),
                            Text("1***********"),
                          ],
                        ),
                        Text(
                          "Via Paypal",
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                    SizedBox(height: 4,),

                    Row(
                      children: [
                        Icon(mShippingAddress),
                        SizedBox(
                          width: 4,
                        ),
                        Text("East Coast Uttar Pradesh"),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // height and width depend on your your requirement.
                          height: 10.h,
                          width: 20.w,
                          decoration: const BoxDecoration(
                            // radius circular depend on your requirement
                            borderRadius:    BorderRadius.all(
                              Radius.circular(10),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              // image url your network image url
                              image: NetworkImage(
                               'https://www.bankslyon.co.uk/wp-content/uploads/2023/02/01064960.jpg',                  ),
                            ),
                          ),
                        ),
                       Padding(
                         padding:   EdgeInsets.only(top: 10, left: 2.w),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: const [
                             SizedBox(width: 200,
                               child: Text("Diamond Ring ", style: TextStyle(
                                 color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17
                               ),),),
                             SizedBox(height: 10,),
                             Text("Total Item ordered(2)"),
                           ],
                         ),
                       )
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 4,
                color: Colors.black,
              ),
            ],
          ),
        ));
  }
}
