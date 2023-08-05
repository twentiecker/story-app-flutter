import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/api/api_service.dart';
import 'package:story_app_flutter/db/auth_repository.dart';
import 'package:story_app_flutter/provider/detail_story_response_provider.dart';
import 'package:story_app_flutter/utils/color_theme.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../utils/result_state.dart';
import '../utils/style_theme.dart';
import '../widget/state_widget.dart';

class StoryDetailScreen extends StatefulWidget {
  final String quoteId;
  final Function() onListStory;

  const StoryDetailScreen(
      {Key? key, required this.quoteId, required this.onListStory})
      : super(key: key);

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.height / 803.137269;
    return ChangeNotifierProvider(
      create: (BuildContext context) => DetailStoryResponseProvider(
        apiService: ApiService(),
        authRepository: AuthRepository(),
        id: widget.quoteId,
      ),
      child: Consumer<DetailStoryResponseProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Scaffold(
              backgroundColor: grey,
              body: Center(
                child: CircularProgressIndicator(color: white),
              ),
            );
          } else if (state.state == ResultState.hasData) {
            return Scaffold(
              backgroundColor: grey,
              body: Stack(
                children: [
                  state.result.story.lat != 0.0 && state.result.story.lon != 0.0
                      ? Center(
                          child: Stack(
                            children: [
                              GoogleMap(
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      state.result.story.lat,
                                      state.result.story.lon,
                                    ),
                                    zoom: 18),
                                onMapCreated: (controller) async {
                                  final info =
                                      await geo.placemarkFromCoordinates(
                                          state.result.story.lat,
                                          state.result.story.lon);

                                  final place = info[0];
                                  final street = place.street!;
                                  final address =
                                      '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                                  setState(() {
                                    placemark = place;
                                  });

                                  defineMarker(
                                      LatLng(
                                        state.result.story.lat,
                                        state.result.story.lon,
                                      ),
                                      street,
                                      address);

                                  setState(() {
                                    mapController = controller;
                                  });
                                },
                                markers: markers,
                              ),
                              if (placemark == null)
                                const SizedBox()
                              else
                                Positioned(
                                  top: screenSize.height * 0.35,
                                  right: 16,
                                  left: 16,
                                  child: PlacemarkWidget(
                                    placemark: placemark!,
                                    ratio: ratio,
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Container(
                          color: lightGrey,
                          child: const Center(
                            child: StateWidget(
                              icon: Icons.location_off_outlined,
                              message: 'No location provided',
                            ),
                          ),
                        ),
                  Container(
                    margin: EdgeInsets.only(top: screenSize.height * 0.4),
                    child: DraggableScrollableSheet(
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: grey,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          padding: const EdgeInsets.only(top: 20),
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                          height: screenSize.height * 0.01),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: state
                                                        .result.story.photoUrl,
                                                    width: ratio * 40,
                                                    height: ratio * 40,
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                progress) =>
                                                            CircularProgressIndicator(
                                                      value: progress.progress,
                                                      color: white,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: screenSize.width *
                                                        0.02),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      state.result.story.name,
                                                      style: titleMedium(
                                                        context,
                                                        ratio,
                                                        white,
                                                        null,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            screenSize.height *
                                                                0.002),
                                                    Text(
                                                      Jiffy.parse(state.result
                                                              .story.createdAt
                                                              .toLocal()
                                                              .toString())
                                                          .fromNow(),
                                                      style: bodyMedium(
                                                        context,
                                                        ratio,
                                                        Colors.grey,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Icon(
                                                  Icons.circle_rounded,
                                                  color: white,
                                                  size: ratio * 5,
                                                ),
                                                SizedBox(
                                                    height: screenSize.height *
                                                        0.002),
                                                Icon(
                                                  Icons.circle_rounded,
                                                  color: white,
                                                  size: ratio * 5,
                                                ),
                                                SizedBox(
                                                    height: screenSize.height *
                                                        0.002),
                                                Icon(
                                                  Icons.circle_rounded,
                                                  color: white,
                                                  size: ratio * 5,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: screenSize.height * 0.03),
                                      SizedBox(
                                        height: screenSize.height * 0.31,
                                        child: CachedNetworkImage(
                                          imageUrl: state.result.story.photoUrl,
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  Transform.scale(
                                            scaleX: 0.3,
                                            scaleY: 0.5,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 10,
                                              value: progress.progress,
                                              color: white,
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                          height: screenSize.height * 0.03),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.favorite_rounded,
                                                  color: Colors.red,
                                                  size: ratio * 20,
                                                ),
                                                SizedBox(
                                                    width: screenSize.width *
                                                        0.01),
                                                Text(
                                                  'Like',
                                                  style: titleSmall(
                                                    context,
                                                    ratio,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: screenSize.width *
                                                        0.05),
                                                Icon(
                                                  Icons.comment_outlined,
                                                  color: white,
                                                  size: ratio * 20,
                                                ),
                                                SizedBox(
                                                    width: screenSize.width *
                                                        0.01),
                                                Text(
                                                  'Comment',
                                                  style: titleSmall(
                                                    context,
                                                    ratio,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Share',
                                                  style: titleSmall(
                                                    context,
                                                    ratio,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: screenSize.width *
                                                        0.01),
                                                Icon(
                                                  Icons.share_outlined,
                                                  color: white,
                                                  size: ratio * 20,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: screenSize.height * 0.03),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          state.result.story.description,
                                          style: bodyMedium(
                                            context,
                                            ratio,
                                            white,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  color: lightGreen,
                                  height: 4,
                                  width: 48,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      minChildSize: 0.25,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: InkWell(
                      onTap: () => widget.onListStory(),
                      child: ClipOval(
                        child: Container(
                          width: 40,
                          height: 40,
                          color: green,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: white,
                            size: ratio * 24,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (state.state == ResultState.noData) {
            return Scaffold(
              backgroundColor: grey,
              body: Center(
                child: StateWidget(
                  icon: Icons.not_interested_rounded,
                  message: state.message,
                ),
              ),
            );
          } else if (state.state == ResultState.error) {
            return const Scaffold(
              backgroundColor: grey,
              body: Center(
                child: StateWidget(
                  icon: Icons.signal_wifi_connected_no_internet_4_rounded,
                  message: 'No Internet Connection',
                ),
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: grey,
              body: Center(
                child: Text(''),
              ),
            );
          }
        },
      ),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}

class PlacemarkWidget extends StatelessWidget {
  final geo.Placemark placemark;
  final double ratio;

  const PlacemarkWidget({
    super.key,
    required this.placemark,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        color: green,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: Colors.grey.withOpacity(0.5),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  placemark.street!,
                  style: titleMedium(
                    context,
                    ratio,
                    white,
                    FontWeight.w500,
                  ),
                ),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                  style: bodyMedium(
                    context,
                    ratio,
                    white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
