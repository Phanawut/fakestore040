import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตะกร้าสินค้า'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('ไม่มีสินค้าในตะกร้า', style: TextStyle(fontSize: 18)))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, i) {
                      final item = cartItems[i];
                      return ListTile(
                        leading: Image.network(item.product.image, width: 50, fit: BoxFit.contain),
                        title: Text(item.product.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                          'ชิ้นละ \$${item.product.price.toStringAsFixed(2)}  |  รวม: \$${item.subTotal.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => cart.decreaseQuantity(item.product.id),
                            ),
                            Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => cart.addItem(item.product),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // ส่วนสรุปราคารวมด้านล่าง
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10, offset: const Offset(0, -5))],
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('ราคารวมทั้งหมด', style: TextStyle(fontSize: 16)),
                            Text(
                              '\$${cart.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ],
                        ),
                        FilledButton(
                          onPressed: cart.itemCount == 0 ? null : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('กำลังไปหน้าชำระเงิน...')),
                            );
                          },
                          child: const Text('สั่งซื้อสินค้า', style: TextStyle(fontSize: 18)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}