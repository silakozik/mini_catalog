import '../models/cart_model.dart';
import '../routes.dart';
import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<Product>> _productsFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductRepository.loadProducts();
  }

  // Arama metnine göre ürün listesini süzer (ad veya slogan içinde arar)
  List<Product> _filter(List<Product> all) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.tagline.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            }
            final products = _filter(snapshot.data!);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildSearchField(),
                  const SizedBox(height: 16),
                  _buildBanner(),
                  const SizedBox(height: 16),
                  if (products.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: Text('Ürün bulunamadı')),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.detail,
                              arguments: product, // Route Arguments: ürünü detay sayfasına taşır
                            );                        
                          },
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Keşfet',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                'Mükemmel cihazını bul.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        // Sepet değişince rozet otomatik güncellenir
        ListenableBuilder(
          listenable: cart,
          builder: (context, _) {
            return IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              icon: Badge(
                label: Text('${cart.totalCount}'),
                isLabelVisible: cart.totalCount > 0,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) => setState(() => _query = value),
      decoration: InputDecoration(
        hintText: 'Ürün ara...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/banner.png',
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}