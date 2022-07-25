import 'package:code/Blocs/blocs.dart';
import 'package:code/Blocs/product/product_bloc.dart';
import 'package:code/Models/category_model.dart';
import 'package:code/Models/models.dart';
import 'package:code/Reusable/widget.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homescreen extends StatelessWidget {
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => Homescreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Navigation Tabs
      appBar: CustomAppBar(title: 'Treeft'),
      bottomNavigationBar: CustomNavBar(screen: routeName),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CategoryLoaded) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 1.5,
                      viewportFraction: 0.9,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                    items: state.categories
                        .map((category) => CarouselCard(category: category))
                        .toList(),
                  );
                } else {
                  return Text('Something went wrong.');
                }
              },
            ),
            SectionTitle(title: 'FEATURED'),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductLoaded) {
                  return ProductCarousel(
                    products: state.products
                        .where((product) => product.featured)
                        .toList(),
                  );
                } else {
                  return Text('Something went wrong.');
                }
              },
            ),
            SectionTitle(title: 'BROWSE ALL'),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductLoaded) {
                  return ProductCarousel(
                    products: state.products
                        .where((product) => product.general)
                        .toList(),
                  );
                } else {
                  return Text('Something went wrong.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
