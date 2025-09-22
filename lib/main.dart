
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/product_repository.dart';
import 'cubit/product_cubit.dart';
import 'cubit/product_state.dart';



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




class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<ProductCubit>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && cubit.hasMore) {
      cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ProductCubit>();
    final categories = ["Todas", ...cubit.categories];
    final selected = cubit.selectedCategory ?? "Todas";

    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: Column(
        children: [
          if (categories.length > 1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: selected,
                items: categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (value) {
                  cubit.filterByCategory(value == "Todas" ? null : value);
                },
                isExpanded: true,
              ),
            ),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(child: Text('Nenhum produto encontrado.'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: cubit.hasMore ? state.products.length + 1 : state.products.length,
                    itemBuilder: (context, index) {
                      if (index >= state.products.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final product = state.products[index];
                      return ListTile(
                        leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(product.title),
                        subtitle: Text('${product.category}\nR\$ ${product.price.toStringAsFixed(2)}'),
                        isThreeLine: true,
                      );
                    },
                  );
                } else if (state is ProductError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<ProductCubit>().fetchProducts(),
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
