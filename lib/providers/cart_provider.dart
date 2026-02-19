import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // คำนวณราคารวมของสินค้ารายการนี้ (ราคา x จำนวน)
  double get subTotal => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  // ใช้ Map โดยมี key เป็น Product ID เพื่อให้ค้นหาและจัดการง่ายขึ้น
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  // นับจำนวนชิ้นทั้งหมดในตะกร้า
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  // คำนวณราคารวมทั้งหมดในตะกร้า
  double get totalAmount => _items.values.fold(0.0, (sum, item) => sum + item.subTotal);

  // เพิ่มสินค้าลงตะกร้า
  void addItem(ProductModel product) {
    if (_items.containsKey(product.id)) {
      // ถ้ามีอยู่แล้ว ให้เพิ่มจำนวน
      _items[product.id]!.quantity += 1;
    } else {
      // ถ้ายังไม่มี ให้สร้างใหม่
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  // ลดจำนวนสินค้า
  void decreaseQuantity(int productId) {
    if (!_items.containsKey(productId)) return;
    
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      // ถ้าเหลือ 1 แล้วกดลบอีก ให้เอาออกจากตะกร้าเลย
      _items.remove(productId);
    }
    notifyListeners();
  }

  // ลบสินค้าออกจากตะกร้าโดยตรง
  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // เคลียร์ตะกร้าทั้งหมด
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}