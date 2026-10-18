import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../utils/format.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepet'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      // Sepet değiştikçe bu bölüm kendini yeniler
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          if (cart.items.isEmpty) {
            return const _EmptyCart();
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 24),
                  itemBuilder: (context, index) =>
                      _CartRow(item: cart.items[index]),
                ),
              ),
              const _CheckoutBar(),
            ],
          );
        },
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  final CartItem item;

  const _CartRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(product.imagePath, fit: BoxFit.contain),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                product.priceText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => cart.decrease(product),
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          '${item.quantity}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        IconButton(
          onPressed: () => cart.add(product),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar();

  @override
  Widget build(BuildContext context) {
    // Sepet değiştikçe toplam tutar kendiliğinden yenilenir
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Toplam', style: TextStyle(fontSize: 16)),
                    Text(
                      formatPrice(cart.totalPrice),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      cart.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Siparişiniz alındı (simülasyon)'),
                        ),
                      );
                    },
                    child: const Text('Satın Al'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'Sepetiniz boş',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Alışverişe başlamak için ürün ekleyin',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}