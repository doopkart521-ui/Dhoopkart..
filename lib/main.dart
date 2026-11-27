import 'package:flutter/material.dart';

void main() => runApp(const DhoopKartApp());

const Color saffron = Color(0xFFFF8A00);
const Color deepBrown = Color(0xFF45200E);
const Color gold = Color(0xFFFFC247);
const Color cream = Color(0xFFFFF7EC);

class DhoopKartApp extends StatelessWidget {
  const DhoopKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DhoopKart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: saffron, primary: saffron),
        appBarTheme: const AppBarTheme(
          backgroundColor: deepBrown,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.brown.shade100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.brown.shade100),
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class Product {
  final String name;
  final String category;
  final int price;
  final String emoji;
  final String detail;

  const Product(this.name, this.category, this.price, this.emoji, this.detail);
}

const products = <Product>[
  Product('Premium Dhoop Cones', 'Dhoop Cones', 149, '🪔', 'Natural fragrance for pooja, meditation and daily use.'),
  Product('Natural Dhoop Sticks', 'Incense Sticks', 99, '🌿', 'A gentle, soothing aroma for your home and mandir.'),
  Product('Temple Sambrani', 'Sambrani', 129, '✨', 'Traditional sambrani fragrance for daily worship.'),
  Product('Premium Dhoop Box', 'Premium Dhoop', 199, '📦', 'A beautiful gift-ready box of devotional fragrances.'),
];

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  final List<Product> cart = [];

  void addToCart(Product product) {
    setState(() => cart.add(product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onAdd: addToCart, onOpenCart: () => setState(() => tab = 2)),
      SearchPage(onAdd: addToCart),
      CartPage(cart: cart, onRemove: (i) => setState(() => cart.removeAt(i))),
      const SellerDashboardPage(),
      const AccountPage(),
    ];
    return Scaffold(
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFFE0B2),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), label: 'Sell'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Account'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final ValueChanged<Product> onAdd;
  final VoidCallback onOpenCart;
  const HomePage({super.key, required this.onAdd, required this.onOpenCart});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: deepBrown,
          foregroundColor: Colors.white,
          title: const Text('DhoopKart', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: .3)),
          leading: const Icon(Icons.menu),
          actions: [IconButton(onPressed: onOpenCart, icon: const Icon(Icons.shopping_bag_outlined))],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(colors: [Color(0xFF3B1608), Color(0xFF9C430B), Color(0xFFFFA21A)]),
                  boxShadow: [BoxShadow(color: saffron.withOpacity(.25), blurRadius: 18, offset: const Offset(0, 8))],
                ),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('🪔  DHOOPKART', style: TextStyle(color: gold, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  SizedBox(height: 10),
                  Text('शुद्ध धूप,\\nसुखद वातावरण', style: TextStyle(color: Colors.white, fontSize: 27, height: 1.15, fontWeight: FontWeight.w900)),
                  SizedBox(height: 8),
                  Text('धूप की खुशबू, अब हर घर तक...', style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 16),
                  _Pill(text: 'Shop Now  →'),
                ]),
              ),
              const SizedBox(height: 22),
              const _SectionTitle('Explore Categories', trailing: 'See All'),
              const SizedBox(height: 12),
              Row(children: const [
                _CategoryTile(icon: '🪔', label: 'Dhoop Cones'),
                _CategoryTile(icon: '🌾', label: 'Incense Sticks'),
                _CategoryTile(icon: '✨', label: 'Sambrani'),
                _CategoryTile(icon: '🎁', label: 'Premium'),
              ]),
              const SizedBox(height: 18),
              // Aayushri is intentionally centered and placed below categories.
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(colors: [Color(0xFFFFD95A), Color(0xFFFFA000), Color(0xFFFFE58A)]),
                    border: Border.all(color: const Color(0xFFB56A00), width: 1.2),
                    boxShadow: [BoxShadow(color: Colors.orange.withOpacity(.22), blurRadius: 14, offset: const Offset(0, 5))],
                  ),
                  child: const Column(children: [
                    Text('🌼  AAYUSHRI  🌼', style: TextStyle(color: deepBrown, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    SizedBox(height: 5),
                    Text('Aayushri Section', textAlign: TextAlign.center, style: TextStyle(color: deepBrown, fontSize: 22, fontWeight: FontWeight.w900)),
                    Text('Health  •  Wellness  •  Positive Life', textAlign: TextAlign.center, style: TextStyle(color: deepBrown, fontWeight: FontWeight.w600)),
                    SizedBox(height: 9),
                    _Pill(text: 'Explore Aayushri  →', dark: true),
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              const _SectionTitle('Best Sellers', trailing: 'See All'),
              const SizedBox(height: 10),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(product: products[index], onAdd: () => onAdd(products[index])),
              childCount: products.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .78,
            ),
          ),
        ),
      ],
    );
  }
}

class SearchPage extends StatefulWidget {
  final ValueChanged<Product> onAdd;
  const SearchPage({super.key, required this.onAdd});
  @override
  State<SearchPage> createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final filtered = products.where((p) => p.name.toLowerCase().contains(query.toLowerCase()) || p.category.toLowerCase().contains(query.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Search DhoopKart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search dhoop, incense, sambrani...'), onChanged: (v) => setState(() => query = v)),
          const SizedBox(height: 14),
          Expanded(child: ListView(children: filtered.map((p) => ProductListTile(product: p, onAdd: () => widget.onAdd(p))).toList())),
        ]),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Product> cart;
  final ValueChanged<int> onRemove;
  const CartPage({super.key, required this.cart, required this.onRemove});
  @override
  Widget build(BuildContext context) {
    final total = cart.fold<int>(0, (sum, p) => sum + p.price);
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cart.isEmpty
          ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.shopping_cart_outlined, size: 58, color: Colors.brown), SizedBox(height: 10), Text('Your cart is empty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('Add your favourite dhoop products')]))
          : Column(children: [
              Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: cart.length, itemBuilder: (context, i) => Card(
                child: ListTile(leading: Text(cart[i].emoji, style: const TextStyle(fontSize: 30)), title: Text(cart[i].name), subtitle: Text('₹${cart[i].price}'), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => onRemove(i))),
              ))),
              Container(
                padding: const EdgeInsets.all(18), color: Colors.white,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text('Total Amount   ₹$total', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutPage(total: total))), child: const Text('Proceed to Checkout')),
                ]),
              )
            ]),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final int total;
  const CheckoutPage({super.key, required this.total});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}
class _CheckoutPageState extends State<CheckoutPage> {
  final address = TextEditingController();
  @override
  void dispose() { address.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Checkout')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 10),
      TextField(controller: address, maxLines: 3, decoration: const InputDecoration(hintText: 'Enter full delivery address')),
      const SizedBox(height: 22),
      const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const Card(child: ListTile(leading: Icon(Icons.payments_outlined, color: Colors.green), title: Text('Cash on Delivery (COD)'), subtitle: Text('Pay when your order arrives'), trailing: Icon(Icons.radio_button_checked, color: saffron))),
      const SizedBox(height: 18),
      Text('Order Total: ₹${widget.total}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      const SizedBox(height: 16),
      FilledButton(onPressed: () {
        if (address.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter delivery address')));
          return;
        }
        showDialog(context: context, builder: (_) => AlertDialog(
          title: const Text('Demo checkout'),
          content: const Text('Your COD checkout screen is ready. Real order placement will work after Firebase integration.'),
          actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('OK'))],
        ));
      }, child: const Text('Place COD Order')),
    ]),
  );
}

class SellerDashboardPage extends StatelessWidget {
  const SellerDashboardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Seller Dashboard'), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))]),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: deepBrown, borderRadius: BorderRadius.circular(18)), child: const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _Metric(label: 'Total Orders', value: '0'), _Metric(label: 'Total Sales', value: '₹0'),
      ])),
      const SizedBox(height: 16),
      const Row(children: [Expanded(child: _DashboardTile(icon: Icons.inventory_2_outlined, title: 'My Products')), SizedBox(width: 10), Expanded(child: _DashboardTile(icon: Icons.receipt_long, title: 'Orders'))]),
      const SizedBox(height: 10),
      const Row(children: [Expanded(child: _DashboardTile(icon: Icons.currency_rupee, title: 'Earnings')), SizedBox(width: 10), Expanded(child: _DashboardTile(icon: Icons.person_outline, title: 'Profile'))]),
      const SizedBox(height: 22),
      const Text('Upload Product', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      const ProductUploadForm(),
      const SizedBox(height: 20),
      const Text('Order Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      const Card(child: ListTile(leading: Icon(Icons.local_shipping_outlined), title: Text('Delivery status'), subtitle: Text('Confirmed  •  Shipped  •  Delivered'))),
    ]),
  );
}

class ProductUploadForm extends StatefulWidget {
  const ProductUploadForm({super.key});
  @override
  State<ProductUploadForm> createState() => _ProductUploadFormState();
}
class _ProductUploadFormState extends State<ProductUploadForm> {
  final name = TextEditingController();
  final price = TextEditingController();
  @override
  void dispose() { name.dispose(); price.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
      Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(border: Border.all(color: Colors.brown.shade200, style: BorderStyle.solid), borderRadius: BorderRadius.circular(14)), child: const Column(children: [Icon(Icons.cloud_upload_outlined, size: 36), Text('Product image upload'), Text('Image picker will be connected in next phase') ])),
      const SizedBox(height: 12),
      TextField(controller: name, decoration: const InputDecoration(labelText: 'Product Name')),
      const SizedBox(height: 10),
      TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (₹)')),
      const SizedBox(height: 12),
      FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product upload will be connected to Firebase next.'))), icon: const Icon(Icons.upload), label: const Text('Upload Product')),
    ])),
  );
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My Account')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const CircleAvatar(radius: 38, backgroundColor: Color(0xFFFFE0B2), child: Icon(Icons.person, size: 42, color: deepBrown)),
      const SizedBox(height: 10),
      const Center(child: Text('Welcome to DhoopKart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
      const SizedBox(height: 18),
      _AccountItem(icon: Icons.login, title: 'Customer Login / Signup', onTap: () => _info(context, 'Customer authentication will be connected with Firebase.')),
      _AccountItem(icon: Icons.storefront, title: 'Seller Registration', onTap: () => _info(context, 'Seller registration and approval flow will be connected next.')),
      _AccountItem(icon: Icons.spa, title: 'Aayushri Section', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AayushriPage()))),
      _AccountItem(icon: Icons.admin_panel_settings, title: 'Admin Panel', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPage()))),
      _AccountItem(icon: Icons.help_outline, title: 'Help & Support', onTap: () => _info(context, 'Support contact details can be configured here.')),
    ]),
  );
}

class AayushriPage extends StatelessWidget {
  const AayushriPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Aayushri')),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      Container(padding: const EdgeInsets.all(26), decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors: [Color(0xFFFFD45A), Color(0xFFFF9800)])), child: const Column(children: [Text('🌼', style: TextStyle(fontSize: 48)), Text('Aayushri', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: deepBrown)), Text('Health • Wellness • Positive Life', style: TextStyle(color: deepBrown, fontWeight: FontWeight.w600))])),
      const SizedBox(height: 18),
      const Text('Featured Collection', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      const Card(child: ListTile(leading: Text('🌿', style: TextStyle(fontSize: 30)), title: Text('Aayushri Featured Products'), subtitle: Text('Your premium brand collection will appear here.'))),
    ]),
  );
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Admin Panel')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: deepBrown, borderRadius: BorderRadius.circular(18)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Welcome Admin', style: TextStyle(color: gold, fontSize: 20, fontWeight: FontWeight.w900)), Text('Manage your DhoopKart marketplace', style: TextStyle(color: Colors.white70))])),
      const SizedBox(height: 14),
       GridView.count(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.8, crossAxisSpacing: 10, mainAxisSpacing: 10, children: [
        _DashboardTile(icon: Icons.people_outline, title: 'Users'),
        _DashboardTile(icon: Icons.storefront, title: 'Sellers'),
        _DashboardTile(icon: Icons.inventory_2_outlined, title: 'Products'),
        _DashboardTile(icon: Icons.shopping_bag_outlined, title: 'Orders'),
      ]),
      const SizedBox(height: 14),
      for (final item in ['All Orders', 'All Sellers', 'All Products', 'Aayushri Section', 'Offers & Discounts', 'Reports', 'Settings', 'Security Rules'])
        Card(child: ListTile(leading: const Icon(Icons.chevron_right), title: Text(item), trailing: const Icon(Icons.arrow_forward_ios, size: 14), onTap: () => _info(context, '$item management will be connected to Firebase/admin permissions.'))),
    ]),
  );
}

void _info(BuildContext context, String message) {
  showDialog(context: context, builder: (_) => AlertDialog(content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  const ProductCard({super.key, required this.product, required this.onAdd});
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    elevation: 1,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Container(width: double.infinity, color: const Color(0xFFFFE7C7), child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 58))))),
      Padding(padding: const EdgeInsets.fromLTRB(10, 8, 10, 0), child: Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), child: Text('₹${product.price}', style: const TextStyle(fontWeight: FontWeight.w900, color: deepBrown, fontSize: 17))),
      Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 8), child: SizedBox(width: double.infinity, child: FilledButton.tonal(onPressed: onAdd, child: const Text('Add to Cart')))),
    ]),
  );
}

class ProductListTile extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  const ProductListTile({super.key, required this.product, required this.onAdd});
  @override
  Widget build(BuildContext context) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: const Color(0xFFFFE7C7), child: Text(product.emoji)), title: Text(product.name), subtitle: Text('₹${product.price}'), trailing: IconButton(onPressed: onAdd, icon: const Icon(Icons.add_shopping_cart))));
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  const _SectionTitle(this.title, {this.trailing});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: deepBrown)), if (trailing != null) Text(trailing!, style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w700))]);
}
class _CategoryTile extends StatelessWidget {
  final String icon, label;
  const _CategoryTile({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [Container(margin: const EdgeInsets.symmetric(horizontal: 4), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFFD7A8))), child: Text(icon, style: const TextStyle(fontSize: 25))), const SizedBox(height: 5), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700))]));
}
class _Pill extends StatelessWidget {
  final String text;
  final bool dark;
  const _Pill({required this.text, this.dark = false});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9), decoration: BoxDecoration(color: dark ? deepBrown : gold, borderRadius: BorderRadius.circular(30)), child: Text(text, style: TextStyle(color: dark ? Colors.white : deepBrown, fontWeight: FontWeight.w900)));
}
class _Metric extends StatelessWidget {
  final String label, value;
  const _Metric({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(children: [Text(label, style: const TextStyle(color: Colors.white70)), Text(value, style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900))]);
}
class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const _DashboardTile({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: saffron, size: 28), const SizedBox(height: 6), Text(title, style: const TextStyle(fontWeight: FontWeight.w800))])));
}
class _AccountItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _AccountItem({required this.icon, required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(child: ListTile(leading: Icon(icon, color: deepBrown), title: Text(title), trailing: const Icon(Icons.chevron_right), onTap: onTap));
}
