# Language selector
<p align="right">
	<b>🌐 Languages:</b>
	<a href="README.md">English</a> |
	<a href="README.pt-br.md">Português (BR)</a>
</p>

# Flutter Product List Challenge

This project is a solution for a product listing challenge, simulating part of a "queue skipping" system for clothing stores, using Flutter, Cubit + Repository architecture, and best modularization practices.

## Features
- Product listing consuming the public API [FakeStoreAPI](https://fakestoreapi.com/products)
- Displays image, title, price, and category
- Category filter
- Dynamic pagination (incremental loading on scroll)
- Friendly error handling and retry button

## Project Structure

```
lib/
	main.dart                # App setup and providers
	models/
		product.dart           # Product data model
	repository/
		product_repository.dart# API access logic
	cubit/
		product_cubit.dart     # State management (Cubit)
		product_state.dart     # State definitions
	screens/
		product_list_screen.dart # Main product screen
	widgets/
		product_list_item.dart # Widget to display a product
		category_dropdown.dart # Widget for category filter
```

## Data Flow
1. **main.dart**: Initializes the app, injects the repository and Cubit, and displays the main screen.
2. **ProductRepository**: Responsible for fetching products and categories from the API.
3. **ProductCubit**: Manages the screen state (loading, error, list, filters, pagination) and exposes interaction methods.
4. **ProductListScreen**: Main screen, consumes Cubit state and renders the UI.
5. **Widgets**: Reusable components for product items and category filter.

## How to run
1. Install dependencies:
	 ```
	 flutter pub get
	 ```
2. Run the app:
	 ```
	 flutter run
	 ```

## Main files

### main.dart
- Responsible for building the MaterialApp, injecting ProductRepository and ProductCubit, and displaying the main screen.

### models/product.dart
- Defines the Product class, representing a product returned by the API.

### repository/product_repository.dart
- Contains methods to fetch products and categories from FakeStoreAPI.

### cubit/product_cubit.dart & cubit/product_state.dart
- Manage the product screen state, including loading, error, filters, and pagination.

### screens/product_list_screen.dart
- Main screen, displays the product list, category filter, loading, error, and pagination.

### widgets/product_list_item.dart
- Widget to display an individual product (image, title, price, category).

### widgets/category_dropdown.dart
- Widget to display the category filter.

## Implemented features
- Category filter
- Dynamic pagination
- Friendly error messages and retry button

## API used
- [FakeStoreAPI](https://fakestoreapi.com/products)

## Notes
- The project follows best practices for separation of concerns and modularization, making maintenance and testing easier.

---

Developed for study and demonstration of modern Flutter architecture.