import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shop_owner_app/ui/constants/assets_path.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import '../constants/app_consntants.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart' as LatLon;

class UserDetails extends StatefulWidget {
  final UserModel user;
  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = widget.user;
    double latitude =
       double.tryParse(user.latitude) ?? 51.509364;
    double longitude =
       double.tryParse(user.longitude) ?? -0.128928;

    return SafeArea(
      child: Scaffold(
      
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: user.imageUrl.isNotEmpty && !kIsWeb
                        ? Hero(
                            tag: user.imageUrl,
                            child: CachedNetworkImage(
                              imageUrl: user.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          )
                        : Image.asset(
                            ImagePath.profilePlaceholder,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 28.0, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //    User information section
                        _sectionTitle('User Details'),
                        Card(
                          child: Column(
                            children: [
                              _userInformationListTile(
                                user.fullName,
                                mUserIcon,
                                context,
                              ),
                              _userInformationListTile(
                                user.email,
                                mEmailIcon,
                                context,
                              ),
                              _userInformationListTile(
                                user.phoneNumber,
                                mPhoneIcon,
                                context,
                              ),
                              _userInformationListTile(
                                user.address,
                                mShippingAddress,
                                context,
                              ),
                              _userInformationListTile(
                                'Joined ${user.joinedAt}',
                                mJoinDateIcon,
                                context,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Detail address

                SliverToBoxAdapter(
                  child: _userFullDetailsSection(user),
                ),
                SliverToBoxAdapter(
                  child: _buildMapSection(
                      latitude: latitude, longitude: longitude, name: user.fullName),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection({required double latitude, required double longitude, required String name}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('User Location'),
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: flutter_map.FlutterMap(
                  options: flutter_map.MapOptions(
                    initialCenter: LatLon.LatLng(latitude, longitude),
                    initialZoom: 11,
                    interactionOptions:
                        const flutter_map.InteractionOptions(flags: 0),
                  ),
                  children: [
                    // Map Tiles
                    flutter_map.TileLayer(
                      urlTemplate:
                          'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                      subdomains: const ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'com.example.app',
                      retinaMode: flutter_map.RetinaMode.isHighDensity(context),
                    ),
                    flutter_map.MarkerLayer(
                      markers: [
                        flutter_map.Marker(
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                          point: LatLon.LatLng(latitude, longitude),
                          width: 80,
                          height: 80,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Transparent overlay to capture gestures
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RouteName.usersLocation,
                        arguments: {'lat': latitude, 'lon': longitude, 'name':name},
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _userInformationListTile(title, icon, context) {
    return ListTile(
      title: Text(title),
      leading: _customIcon(icon),
      onTap: () {},
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 0, 0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _customIcon(IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
  }

  Widget _userFullDetailsSection(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Full Address'),
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _userDetailRow('Address Line 1', user.addressLine1),
                  const Divider(),
                  _userDetailRow('Address Line 2', user.addressLine2),
                  const Divider(),
                  _userDetailRow('City', user.city),
                  const Divider(),
                  _userDetailRow('State', user.state),
                  const Divider(),
                  _userDetailRow('Postal Code', user.postalCode),
                  const Divider(),
                  _userDetailRow('Country', user.country),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
