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
	String _search = '';

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
							body: SafeArea(
								child: Column(
									children: [
										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
											child: TextField(
												decoration: const InputDecoration(
													labelText: 'Pesquisar produto',
													border: OutlineInputBorder(),
													prefixIcon: Icon(Icons.search),
													enabled: true,
													enabledBorder: OutlineInputBorder(
														borderSide: BorderSide(color: Colors.grey),
													),
													fillColor: Color(0x00000000),
												),
												onChanged: (value) {
													setState(() {
														_search = value;
													});
												},
											),
										),
										if (categories.length > 1)
											Padding(
												padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
												child: CategoryDropdown(
													categories: categories,
													selected: selected,
													onChanged: (value) {
														cubit.filterByCategory(value == "Todos" ? null : value);
													},
												),
											),
										Expanded(
											child: BlocBuilder<ProductCubit, ProductState>(
												builder: (context, state) {
													if (state is ProductLoading) {
														return const Center(child: CircularProgressIndicator());
													} else if (state is ProductLoaded) {
														final filtered = _search.isEmpty
																? state.products
																: state.products.where((p) => p.title.toLowerCase().contains(_search.toLowerCase())).toList();
														if (filtered.isEmpty) {
															return const Center(child: Text('Nenhum produto encontrado.'));
														}
														return ListView.builder(
															controller: _scrollController,
															itemCount: cubit.hasMore && filtered.length == state.products.length
																	? filtered.length + 1
																	: filtered.length,
															itemBuilder: (context, index) {
																if (index >= filtered.length) {
																	return const Padding(
																		padding: EdgeInsets.symmetric(vertical: 16),
																		child: Center(child: CircularProgressIndicator()),
																	);
																}
																final product = filtered[index];
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
							),
						);
	}
}

