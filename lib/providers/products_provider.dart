import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/common/http-exception.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Product lastProduct;
  final databaseReference = Firestore.instance;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return [..._items.where((prod) => prod.isFavorite).toList()];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchProducts() async {
    const url = 'https://amajon-flutter.firebaseio.com/products.json';
    try {
      final res = await http.get(url);
      print(json.decode(res.body));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          isFavorite: productData['isFavorite'],
          imageUrl: productData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fecthProductsFirestore() async {
    try {
      final List<Product> loadedProducts = [];
      await databaseReference
          .collection("products")
          .getDocuments()
          .then((QuerySnapshot snapshot) async {
        snapshot.documents.forEach((prod) {
          ;
          loadedProducts.add(Product(
            id: prod.documentID,
            title: prod.data['title'],
            imageUrl: prod.data['imageUrl'],
            description: prod.data['description'],
            isFavorite: prod.data['isFavorite'],
            price: prod.data['price'] as dynamic,
          ));
        });
        
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProduct(Product prod) async {
    // _items.add(value);
    const url = 'https://amajon-flutter.firebaseio.com/products.json';
    try {
      final res = await http.post(
        url,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'imageUrl': prod.imageUrl,
          'price': prod.price,
          'isFavorite': prod.isFavorite,
        }),
      );
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: prod.title,
        description: prod.description,
        price: prod.price,
        imageUrl: prod.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addProductFirestore(Product prod) async {
    try {
      await databaseReference.collection('products').add({
        'title': prod.title,
        'description': prod.description,
        'imageUrl': prod.imageUrl,
        'price': prod.price,
        'isFavorite': prod.isFavorite,
      });
      final newProduct = Product(
        id: prod.id,
        title: prod.title,
        description: prod.description,
        price: prod.price,
        imageUrl: prod.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product selectedProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        final url = 'https://amajon-flutter.firebaseio.com/products/$id.json';
        await http.patch(url,
            body: json.encode({
              'title': selectedProduct.title,
              'description': selectedProduct.description,
              'price': selectedProduct.price,
              'imageUrl': selectedProduct.imageUrl,
            }));
        _items[prodIndex] = selectedProduct;
        notifyListeners();
      } catch (error) {
        throw (error);
      }
    } else {
      print('....');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://amajon-flutter.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product :(');
    }
    existingProduct = null;
  }
}
