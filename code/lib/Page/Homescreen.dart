import 'package:code/Models/category_model.dart';
import 'package:code/Models/models.dart';
import 'package:code/Reusable/widget.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Navigation Tabs
      appBar: CustomAppBar(title: 'Treeft'),
      bottomNavigationBar: CustomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 1.5,
                  viewportFraction: 0.9,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  enableInfiniteScroll: false,
                ),
                items: Category.categories
                    .map((category) => CarouselCard(category: category))
                    .toList(),
              ),
            ),
            SectionTitle(title: 'FEATURED'),
            ProductCarousel(
                products: Product.products
                    .where((product) => product.isFeatured)
                    .toList()),
            SectionTitle(title: 'BROWSE ALL'),
            ProductCarousel(
                products: Product.products
                    .where((product) => product.isFeatured)
                    .toList()),
          ],
        ),
      ),
    );
  }
}








/*Drawer
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffFFDE59),
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Treeft Tree'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                // Change to tree page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Tree()),
                );
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                // Change to Settings
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/
