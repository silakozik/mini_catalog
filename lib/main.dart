import 'package:flutter/material.dart';
import 'data/product_repository.dart';
import 'models/product.dart';

void main() {
  runApp(const MiniKatalogApp());
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog',
      debugShowCheckedModeBanner: false,
      home: const ProductTestPage(),
    );
  }
}

class ProductTestPage extends StatelessWidget {
  const ProductTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Katalog')),
      body: FutureBuilder<List<Product>>(
        future: ProductRepository.loadProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                leading: Image.asset(
                  p.imagePath,
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                ),
                title: Text(p.name),
                subtitle: Text(p.tagline),
                trailing: Text(p.priceText),
              );
            },
          );
        },
      ),
    );
  }
}