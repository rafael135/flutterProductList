# Desafio Produtos - Flutter

Este projeto é uma solução para o desafio de listagem de produtos, simulando parte da funcionalidade de um sistema "fura fila" para lojas de vestuário, utilizando Flutter, arquitetura Cubit + Repository e boas práticas de modularização.

## Funcionalidades
- Listagem de produtos consumindo a API pública [FakeStoreAPI](https://fakestoreapi.com/products)
- Exibição de imagem, título, preço e categoria
- Filtro por categoria
- Paginação dinâmica (carregamento incremental ao rolar)
- Tratamento amigável de erros e botão de tentar novamente

## Estrutura do Projeto

```
lib/
  main.dart                # Setup do app e providers
  models/
    product.dart           # Modelo de dados Product
  repository/
    product_repository.dart# Lógica de acesso à API
  cubit/
    product_cubit.dart     # Gerenciamento de estado (Cubit)
    product_state.dart     # Definição dos estados
  screens/
    product_list_screen.dart # Tela principal de produtos
  widgets/
    product_list_item.dart # Widget para exibir um produto
    category_dropdown.dart # Widget para filtro de categoria
```

## Fluxo de Dados
1. **main.dart**: Inicializa o app, injeta o repositório e o Cubit, e exibe a tela principal.
2. **ProductRepository**: Responsável por buscar produtos e categorias na API.
3. **ProductCubit**: Gerencia o estado da tela (carregando, erro, lista, filtros, paginação) e expõe métodos para interação.
4. **ProductListScreen**: Tela principal, consome o estado do Cubit e renderiza a UI.
5. **Widgets**: Componentes reutilizáveis para itens de produto e filtro de categoria.

## Como rodar
1. Instale as dependências:
   ```
   flutter pub get
   ```
2. Execute o app:
   ```
   flutter run
   ```

## Principais arquivos

### main.dart
- Responsável por montar o MaterialApp, injetar o ProductRepository e ProductCubit, e exibir a tela principal.

### models/product.dart
- Define a classe Product, que representa um produto retornado pela API.

### repository/product_repository.dart
- Contém métodos para buscar produtos e categorias na FakeStoreAPI.

### cubit/product_cubit.dart & cubit/product_state.dart
- Gerenciam o estado da tela de produtos, incluindo carregamento, erro, filtros e paginação.

### screens/product_list_screen.dart
- Tela principal, exibe a lista de produtos, filtro de categoria, loading, erro e paginação.

### widgets/product_list_item.dart
- Widget para exibir um produto individual (imagem, título, preço, categoria).

### widgets/category_dropdown.dart
- Widget para exibir o filtro de categoria.

## Diferenciais implementados
- Filtro por categoria
- Paginação dinâmica
- Mensagens de erro amigáveis e botão de tentar novamente

## API utilizada
- [FakeStoreAPI](https://fakestoreapi.com/products)

## Observações
- O projeto segue boas práticas de separação de responsabilidades e modularização, facilitando manutenção e testes.

---

Desenvolvido para fins de estudo e demonstração de arquitetura Flutter moderna.
