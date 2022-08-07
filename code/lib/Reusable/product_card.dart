import 'package:code/Blocs/wishlist/wishlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Models/models.dart';
import 'package:flutter/cupertino.dart';

class ProductCard extends StatelessWidget {
  const ProductCard.catalog({
    Key? key,
    required this.product,
    this.widthFactor = 2.25,
    this.height = 150,
    this.isCatalog = true,
    this.isWishlist = false,
    this.isSummary = false,
    this.iconColor = Colors.white,
    this.fontColor = Colors.white,
  }) : super(key: key);

  const ProductCard.wishlist({
    Key? key,
    required this.product,
    this.widthFactor = 1.1,
    this.height = 150,
    this.isCatalog = false,
    this.isWishlist = true,
    this.isSummary = false,
    this.iconColor = Colors.white,
    this.fontColor = Colors.white,
  }) : super(key: key);

  const ProductCard.summary({
    Key? key,
    required this.product,
    this.widthFactor = 3,
    this.height = 150,
    this.isCatalog = false,
    this.isWishlist = false,
    this.isSummary = true,
    this.iconColor = Colors.black,
    this.fontColor = Colors.black,
  }) : super(key: key);

  final Product product;
  final double widthFactor;
  final double height;
  final bool isCatalog;
  final bool isWishlist;
  final bool isSummary;
  final Color iconColor;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double adjWidth = width / widthFactor;

    return InkWell(
      onTap: () {
        if (isCatalog || isWishlist)
          Navigator.pushNamed(context, '/product', arguments: product);
      },
      child: isSummary
          ? Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  ProductImage(
                    adjWidth: 150,
                    product: product,
                    height: height,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ProductInformation(
                      product: product,
                      fontColor: fontColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ProductActions(
                    product: product,
                    isCatalog: isCatalog,
                    isWishlist: isWishlist,
                    iconColor: iconColor,
                  ),
                ],
              ),
            )
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ProductImage(
                  adjWidth: 100,
                  product: product,
                  height: height,
                ),
                ProductBackground(
                  adjWidth: adjWidth,
                  widgets: [
                    ProductInformation(
                      product: product,
                      fontColor: fontColor,
                    ),
                    ProductActions(
                      product: product,
                      isCatalog: isCatalog,
                      isWishlist: isWishlist,
                      iconColor: iconColor,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class ProductActions extends StatelessWidget {
  const ProductActions({
    Key? key,
    required this.product,
    required this.isCatalog,
    required this.isWishlist,
    required this.iconColor,
  }) : super(key: key);

  final Product product;
  final bool isCatalog;
  final bool isWishlist;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistBloc, WishlistState>(
      builder: (context, state) {
        if (state is WishlistLoading) {
          return Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (state is WishlistLoaded) {
          IconButton addToWishlist = IconButton(
            icon: Icon(
              Icons.favorite,
              color: iconColor,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added to your Wishlist!'),
                ),
              );
              context.read<WishlistBloc>().add(AddProductToWishlist(product));
            },
          );

          IconButton removeFromWishlist = IconButton(
            icon: Icon(
              Icons.delete,
              color: iconColor,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed from your Wishlist!'),
                ),
              );
              context
                  .read<WishlistBloc>()
                  .add(RemoveProductFromWishlist(product));
            },
          );

          if (isCatalog) {
            return Row(children: [addToWishlist]);
          } else if (isWishlist) {
            return Row(children: [removeFromWishlist]);
          } else {
            return SizedBox();
          }
        } else {
          return Text('Something went wrong.');
        }
      },
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Row(
//     children: [
//       Expanded(
//         flex: 3,
//         child: Expanded(
//           children: [
//             IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 (Icons.message),
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
// isWishList
//     ? Expanded(
//         child: BlocBuilder<WishlistBloc, WishlistState>(
//           builder: (context, state) {
//             return IconButton(
//                 onPressed: () {
//                   context.read<WishlistBloc>().add(
//                       RemoveProductFromWishlist(product));

//                   final snackBar = SnackBar(
//                       content:
//                           Text('Remove from Wishlist'));
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(snackBar);
//                 },
//                 icon: Icon(
//                   (Icons.delete),
//                   color: Colors.white,
//                 ));
//           },
//         ),
//       )
//          : SizedBox(),
//       ],
//     );
//   }
// }

class ProductInformation extends StatelessWidget {
  const ProductInformation({
    Key? key,
    required this.product,
    required this.fontColor,
  }) : super(key: key);

  final Product product;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style:
              Theme.of(context).textTheme.headline5!.copyWith(color: fontColor),
        ),
        Text(
          '\$${(product.price).toStringAsFixed(2)}',
          style:
              Theme.of(context).textTheme.headline6!.copyWith(color: fontColor),
        ),
        Text(
          '\@' + product.username,
          style:
              Theme.of(context).textTheme.headline6!.copyWith(color: fontColor),
        ),
      ],
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
    Key? key,
    required this.adjWidth,
    required this.product,
    required this.height,
  }) : super(key: key);

  final double adjWidth;
  final double height;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: adjWidth,
      height: height,
      child: Image.network(
        product.images[0],
        fit: BoxFit.cover,
      ),
    );
  }
}

class ProductBackground extends StatelessWidget {
  const ProductBackground({
    Key? key,
    required this.adjWidth,
    required this.widgets,
  }) : super(key: key);
  final double adjWidth;
  final List<Widget> widgets;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: adjWidth - 10,
      height: 80,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(50),
      ),
      child: Container(
        width: adjWidth - 20,
        height: 70,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...widgets,
            ],
          ),
        ),
      ),
    );
  }
}
