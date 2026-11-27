import 'package:flutter/material.dart';

const kBrown = Color(0xFF211710);
const kGold = Color(0xFFC9A45C);

class Product {
  final String name;
  final String category;
  final int price;
  final String description;
  const Product(this.name, this.category, this.price, this.description);
}

const products = <Product>[
  Product('Premium Dhoop Sticks', 'Dhoop Sticks', 99, 'A rich, traditional fragrance for daily pooja.'),
  Product('Natural Dhoop Cones', 'Dhoop Cones', 149, 'Handy cones for a calm and fragrant home.'),
  Product('Classic Agarbatti', 'Agarbatti', 79, 'Everyday incense with a gentle aroma.'),
  Product('Pooja Essentials Kit', 'Pooja Items', 249, 'A useful collection of daily pooja essentials.'),
];

class CartStore {
  static final Map<Product, int> items = {};
  static int get count => items.values.fold(0, (a, b) => a + b);
  static int get total => items.entries.fold(0, (a, e) => a + e.key.price * e.value);
  static void add(Product p) => items[p] = (items[p] ?? 0) + 1;
  static void remove(Product p) {
    final n = items[p] ?? 0;
    if (n <= 1) { items.remove(p); } else { items[p] = n - 1; }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  void refresh() => setState(() {});
  @override
  Widget build(BuildContext context) {
    final pages = [
      StorePage(onChanged: refresh),
      const SellerPage(),
      const AdminPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('DhoopKart', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
              refresh();
            },
            icon: Stack(clipBehavior: Clip.none, children: [
              const Icon(Icons.shopping_bag_outlined),
              if (CartStore.count > 0)
                Positioned(right: -7, top: -7, child: CircleAvatar(
                  radius: 9, backgroundColor: kGold,
                  child: Text('${CartStore.count}', style: const TextStyle(fontSize: 10, color: kBrown)),
                )),
            ]),
          ),
        ],
      ),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront_outlined), label: 'Shop'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'Seller'),
          NavigationDestination(icon: Icon(Icons.admin_panel_settings_outlined), label: 'Admin'),
        ],
      ),
    );
  }
}

class StorePage extends StatelessWidget {
  final VoidCallback onChanged;
  const StorePage({super.key, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kBrown, borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(colors: [kBrown, Color(0xFF563A25)]),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('PURE FRAGRANCE • DIVINE FEELING', style: TextStyle(color: kGold, letterSpacing: 1, fontSize: 11)),
            SizedBox(height: 10),
            Text('Khushboo jo mann ko sukoon de.', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Dhoop, agarbatti aur pooja essentials — ek hi jagah.', style: TextStyle(color: Color(0xFFFFE7B0))),
          ]),
        ),
        const SizedBox(height: 22),
        const Text('Shop by Category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: ['Dhoop Sticks', 'Dhoop Cones', 'Agarbatti', 'Pooja Items']
          .map((s) => Chip(label: Text(s), avatar: const Icon(Icons.spa_outlined, size: 18))).toList()),
        const SizedBox(height: 18),
        const Text('Bestsellers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...products.map((p) => Card(
          child: ListTile(
            leading: CircleAvatar(backgroundColor: const Color(0xFFF1E5CE), child: const Icon(Icons.spa, color: kBrown)),
            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${p.category} • ₹${p.price}\\n${p.description}'),
            isThreeLine: true,
            trailing: IconButton(
              onPressed: () { CartStore.add(p); onChanged(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} added to cart'))); },
              icon: const Icon(Icons.add_shopping_cart, color: kBrown),
            ),
          ),
        )),
        const SizedBox(height: 8),
        const Text('Featured brand: Aayushri', style: TextStyle(color: kBrown, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}
class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final entries = CartStore.items.entries.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: entries.isEmpty
        ? const Center(child: Text('Your cart is empty'))
        : ListView(padding: const EdgeInsets.all(16), children: [
            ...entries.map((e) => ListTile(
              title: Text(e.key.name),
              subtitle: Text('₹${e.key.price} × ${e.value}'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(onPressed: () => setState(() => CartStore.remove(e.key)), icon: const Icon(Icons.remove_circle_outline)),
                Text('${e.value}'),
                IconButton(onPressed: () => setState(() => CartStore.add(e.key)), icon: const Icon(Icons.add_circle_outline)),
              ]),
            )),
            const Divider(),
            ListTile(title: const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), trailing: Text('₹${CartStore.total}', style: const TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: kBrown, padding: const EdgeInsets.all(15)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutPage())),
              child: const Text('Proceed to COD Checkout'),
            ),
          ]),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});
  @override
  Widget build(BuildContext context) {
    final name = TextEditingController();
    final phone = TextEditingController();
    final address = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Cash on Delivery')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Delivery details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: address, maxLines: 3, decoration: const InputDecoration(labelText: 'Full delivery address', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        const ListTile(leading: Icon(Icons.payments_outlined), title: Text('Payment method'), subtitle: Text('Cash on Delivery only')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: kBrown, padding: const EdgeInsets.all(15)),
          onPressed: () {
            if (name.text.trim().isEmpty || phone.text.trim().length < 10 || address.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid delivery details')));
              return;
            }
            final orderId = DateTime.now().millisecondsSinceEpoch.toString();
            CartStore.items.clear();
            showDialog(context: context, builder: (_) => AlertDialog(
              title: const Text('Order placed (demo)'),
              content: Text('Order ID: $orderId\\nPayment: Cash on Delivery\\n\\nThis is a local demo. Connect Firestore to save real orders.'),
              actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); Navigator.pop(context); }, child: const Text('Done'))],
            ));
          },
          child: const Text('Place COD Order'),
        ),
      ]),
    );
  }
}

class SellerPage extends StatelessWidget {
  const SellerPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Seller Centre', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    const Text('Seller registration and admin approval workflow will be connected to Firebase in the next phase.'),
    const SizedBox(height: 16),
    _info('Register as Seller', 'Submit shop name, phone and address for admin approval.', Icons.store),
    _info('My Products', 'Add product name, price, stock and product photo.', Icons.inventory),
    _info('Orders & Delivery', 'Accept orders and update delivery status.', Icons.local_shipping),
  ]);
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Admin Panel', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    const Text('Admin tools are UI placeholders. Secure role checks and Firestore rules are required before launch.'),
    _info('Seller approvals', 'Review and approve seller applications.', Icons.verified_user),
    _info('Products', 'Review listings and manage featured products.', Icons.inventory_2),
    _info('Orders', 'Monitor orders and delivery status.', Icons.receipt_long),
    _info('Aayushri Featured Brand', 'Manage the featured brand collection.', Icons.star),
  ]);
}

Widget _info(String title, String subtitle, IconData icon) => Card(
  child: ListTile(leading: Icon(icon, color: kGold), title: Text(title), subtitle: Text(subtitle), trailing: const Icon(Icons.chevron_right)),
);
