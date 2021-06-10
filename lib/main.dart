import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class Product {
  const Product({required this.name});
  final String name;
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChanged,
  }) : super(key: ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onCartChanged(product, inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(
        product.name,
        style: _getTextStyle(context),
      ),
    );
  }
}

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key, required this.products, required this.count})
      : super(key: key);

  final List<Product> products;
  final int count;

  @override
  _ShoppingListState createState() {
    print('ShoppingList createState invoked.');
    return _ShoppingListState();
  }
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingChart = Set<Product>();

  // @override
  // void didUpdateWidget(covariant ShoppingList oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   print('ShoppingListState didUpdateWidget ');
  //   oldWidget.products.forEach((element) {
  //     print(element.name + ' ');
  //   });
  //   print('old count: ' + oldWidget.count.toString());
  //   print('#################################');
  //   widget.products.forEach((element) {
  //     print(element.name + ' ');
  //   });
  //   print('new count: ' + widget.count.toString());
  //   print('-----------------------------');
  // }

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      if (!inCart) {
        _shoppingChart.add(product);
      } else {
        _shoppingChart.remove(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: widget.products.map((Product product) {
        return ShoppingListItem(
          product: product,
          inCart: _shoppingChart.contains(product),
          onCartChanged: _handleCartChanged,
        );
      }).toList(),
    );
  }
}

class ShoppingListManagement extends StatefulWidget {
  const ShoppingListManagement({Key? key, required this.products})
      : super(key: key);

  final List<Product> products;

  @override
  _ShoppingListManagementState createState() => _ShoppingListManagementState();
}

class _ShoppingListManagementState extends State<ShoppingListManagement> {
  int count = 0;

  _handleAddShoppingItem() {
    setState(() {
      widget.products.add(Product(name: WordPair.random().asPascalCase));
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: ShoppingList(
        products: widget.products,
        count: count,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Item',
        child: Icon(Icons.add),
        onPressed: _handleAddShoppingItem,
      ),
    );
  }
}

void main() {
  List<Product> products = <Product>[];
  products.add(Product(name: 'Eggs'));
  products.add(Product(name: 'Milk'));
  products.add(Product(name: 'Chocolate'));

  runApp(MaterialApp(
    title: 'Shopping App',
    home: ShoppingListManagement(
      products: products,
    ),
  ));
}
