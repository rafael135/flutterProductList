
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/product_repository.dart';
import 'product_state.dart';
import '../models/product.dart';


class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;
  List<Product> _allProducts = [];
  List<String> _categories = [];
  String? _selectedCategory;
  int _page = 1;
  final int _pageSize = 10;
  List<Product> _currentList = [];
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  ProductCubit(this.repository) : super(const ProductInitial());

  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;

  Future<void> fetchProducts() async {
    try {
      emit(const ProductLoading());
      _allProducts = await repository.fetchProducts();
      await fetchCategories();
      _page = 1;
      _hasMore = true;
      _currentList = _getPage(_allProducts, _page);
      if (_currentList.length < _allProducts.length) {
        _hasMore = true;
      } else {
        _hasMore = false;
      }
      emit(ProductLoaded(_currentList));
    } catch (e) {
      emit(ProductError(_parseError(e)));
    }
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await repository.fetchCategories();
    } catch (e) {
      _categories = [];
    }
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    _page = 1;
    List<Product> filtered;
    if (category == null || category == 'Todas') {
      filtered = _allProducts;
    } else {
      filtered = _allProducts.where((p) => p.category == category).toList();
    }
    _currentList = _getPage(filtered, _page);
    _hasMore = _currentList.length < filtered.length;
    emit(ProductLoaded(_currentList));
  }

  void loadMore() {
    List<Product> filtered;
    if (_selectedCategory == null || _selectedCategory == 'Todas') {
      filtered = _allProducts;
    } else {
      filtered = _allProducts.where((p) => p.category == _selectedCategory).toList();
    }
    if (_currentList.length >= filtered.length) {
      _hasMore = false;
      return;
    }
    _page++;
    final nextPage = _getPage(filtered, _page);
    _currentList = [..._currentList, ...nextPage.skip(_currentList.length)];
    _hasMore = _currentList.length < filtered.length;
    emit(ProductLoaded(_currentList));
  }

  List<Product> _getPage(List<Product> list, int page) {
    final start = (page - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, list.length);
    return list.sublist(0, end);
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException')) {
      return 'Sem conexão com a internet.';
    }
    return 'Erro ao carregar produtos.';
  }
}
