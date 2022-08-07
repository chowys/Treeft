import 'package:code/Blocs/product/product_bloc.dart';
import 'package:code/Blocs/wishlist/wishlist_bloc.dart';
import 'package:code/Configuration/app_router.dart';
import 'package:code/Models/models.dart';
import 'package:code/Page/Login.dart';
import 'package:code/Repositories/Category/category_repository.dart';
import 'package:code/Repositories/Local_storage/local_storage_repository.dart';
import 'package:code/Repositories/Product/product_repository.dart';
import 'package:code/Reusable/theme.dart';
import 'package:code/simple_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:code/Reusable/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/Blocs/blocs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => WishlistBloc(
                  localStorageRepository: LocalStorageRepository(),
                )..add(LoadWishlist())),
        BlocProvider(
          create: (_) => CategoryBloc(
            categoryRepository: CategoryRepository(),
          )..add(
              LoadCategories(),
            ),
        ),
        BlocProvider(
          create: (_) => ProductBloc(
            productRepository: ProductRepository(),
          )..add(LoadProducts()),
        ),
      ],
      child: MaterialApp(
        theme: theme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: LogIn.routeName,
      ),
    );
  }
}
