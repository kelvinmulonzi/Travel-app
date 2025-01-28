import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wanderlust/utils/api_client.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with profile
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/Group 30.svg',
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Leonardo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Welcome text image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset('assets/images/welcometext.png'),
            ),

            // Best Destinations Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Best Destination',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View all'),
                  ),
                ],
              ),
            ),

            // Destinations list
            FutureBuilder(future: ApiClient().getProducts(), builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              if(snapshot.hasError){
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if(snapshot.hasData){
                print("snapshot.data>>>>>>>>>${snapshot.data}");
                return     Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length, // Will be replaced with actual data length
                    itemBuilder: (context, index) {
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image container
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                color: Colors.blue.shade100, // Placeholder color
                              ),
                              // You'll replace this with your image from database
                              child: CachedNetworkImage(
                                imageUrl: "https://drive.google.com/uc?export=download&id=1-S3-IeGgl1ROn8whiojNZWBM6coAxfx8",
                                width: 150,
                                errorWidget: (context, url, error) => CircleAvatar(
                                  radius: 70,
                                  backgroundImage: AssetImage('assets/images/oceans.png'),
                                ),
                                placeholder: (context, url) => SizedBox(

                                  width: 50.0,
                                  child: Shimmer.fromColors(
                                    baseColor: Color(0xfff4f4f4),
                                    highlightColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 70,
                                    ),
                                  ),
                                ),
                              ),
                              // child: Image.network(snapshot.data[index]["imageUrl"]),
                            ),

                            // Location details
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Location name
                                   Text(
                                    snapshot.data[index]["name"],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Location info row
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                       Text(
                                        snapshot.data[index]["location"],
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.amber.shade700,
                                      ),
                                      const SizedBox(width: 4),
                                       Text(
                                         snapshot.data[index]["rating"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return Container();
            }),


            // Bottom navigation
            NavigationBar(
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today),
                  label: 'Calendar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                NavigationDestination(
                  icon: Icon(Icons.message_outlined),
                  label: 'Messages',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
              selectedIndex: 0,
            ),
          ],
        ),
      ),
    );
  }
}