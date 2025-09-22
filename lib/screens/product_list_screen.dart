
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../widgets/product_list_item.dart';
import '../widgets/category_dropdown.dart';

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
						CategoryDropdown(
							categories: categories,
							selected: selected,
							onChanged: (value) {
								cubit.filterByCategory(value == "Todas" ? null : value);
							},
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
											return ProductListItem(product: product);
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

