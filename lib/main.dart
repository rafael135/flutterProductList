
import 'package:desafio_produtos/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/product_repository.dart';
import 'cubit/product_cubit.dart';



void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Produtos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RepositoryProvider(
        create: (_) => ProductRepository(),
        child: BlocProvider(
          create: (context) => ProductCubit(context.read<ProductRepository>())..fetchProducts(),
          child: const ProductListScreen(),
        ),
      ),
    );
  }
}

