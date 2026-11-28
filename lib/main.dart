
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DhoopKartApp());
}

// COLORS
const Color saffron = Color(0xFFFF8A00);
const Color deepBrown = Color(0xFF45200E);
const Color gold = Color(0xFFFFC247);
const Color cream = Color(0xFFFFF7EC);
const Color lightBrown = Color(0xFFFFE8CC);

// PRODUCT MODEL
class Product {
  final String name;
  final int price;
  final String emoji;
  final String category;
  final String description;

  Product({
    required this.name,
    required this.price,
    required this.emoji,
    required this.category,
    required this.description,
  });
}

// DEMO PRODUCTS
final List<Product> products = [
  Product(
    name: 'Premium Dhoop Sticks',
    price: 99,
    emoji: '🪔',
    category: 'Dhoop',
    description: 'Premium quality aromatic dhoop sticks.',
  ),
  Product(
    name: 'Chandan Dhoop',
    price: 149,
    emoji: '🌿',
    category: 'Dhoop',
    description: 'Chandan fragrance dhoop.',
  ),
  Product(
    name: 'Rose Agarbatti',
    price: 79,
    emoji: '🌹',
    category: 'Agarbatti',
    description: 'Pleasant rose fragrance agarbatti.',
  ),
  Product(
    name: 'Camphor',
    price: 59,
    emoji: '✨',
    category: 'Puja Items',
    description: 'Daily puja camphor.',
  ),
  Product(
    name: 'Puja Combo',
    price: 249,
    emoji: '🎁',
    category: 'Combo',
    description: 'Useful items for daily puja.',
  ),
  Product(
    name: 'Temple Dhoop',
    price: 129,
    emoji: '🙏',
    category: 'Dhoop',
    description: 'Traditional temple fragrance.',
  ),
];

// MAIN APP
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: saffron,
          primary: saffron,
          secondary: deepBrown,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          foregroundColor: deepBrown,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (snapshot.hasData) {
      return const MainShell();
    }

    return LoginScreen(
  onLoginSuccess: () {
    // Login successful hone ke baad kya karna hai
    // Example:
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()), // apna home screen daalo
    );
  },
);
  },
),
    );
  }
}

// MAIN NAVIGATION
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedIndex = 0;
  final List<Product> cart = [];

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} cart mein add ho gaya'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void removeFromCart(int index) {
    setState(() {
      cart.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onAdd: addToCart),
      SearchPage(onAdd: addToCart),
      CartPage(
        cart: cart,
        onRemove: removeFromCart,
      ),
      AccountPage(
        onSeller: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SellerDashboardPage(
                onSave: (product) {
                  setState(() {
                    products.add(product);
                  });
                },
              ),
            ),
          );
        },
        onAdmin: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminPage(),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: Colors.white,
        indicatorColor: lightBrown,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

// HOME PAGE
class HomePage extends StatelessWidget {
  final ValueChanged<Product> onAdd;

  const HomePage({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_fire_department, color: saffron),
            SizedBox(width: 8),
            Text(
              'DhoopKart',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: deepBrown,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AayushriPage(),
                ),
              );
            },
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [saffron, gold],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to DhoopKart',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Har puja ko banaye aur bhi khaas.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  '🪔  Dhoop • Agarbatti • Puja Items',
                  style: TextStyle(
                    color: deepBrown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle(title: 'Shop by Category'),
          const SizedBox(height: 12),
          SizedBox(
            height: 105,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CategoryTile(emoji: '🪔', title: 'Dhoop'),
                CategoryTile(emoji: '🌹', title: 'Agarbatti'),
                CategoryTile(emoji: '🙏', title: 'Puja Items'),
                CategoryTile(emoji: '🎁', title: 'Combo'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle(title: 'Popular Products'),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: .72,
            ),
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                onAdd: () => onAdd(products[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

// SEARCH PAGE
class SearchPage extends StatefulWidget {
  final ValueChanged<Product> onAdd;

  const SearchPage({
    super.key,
    required this.onAdd,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final results = products.where((product) {
      return product.name.toLowerCase().contains(
            searchText.toLowerCase(),
          ) ||
          product.category.toLowerCase().contains(
            searchText.toLowerCase(),
          );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search dhoop, agarbatti...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text('No products found'),
                    )
                  : GridView.builder(
                      itemCount: results.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: .72,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: results[index],
                          onAdd: () => widget.onAdd(results[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// CART PAGE
class CartPage extends StatelessWidget {
  final List<Product> cart;
  final ValueChanged<int> onRemove;

  const CartPage({
    super.key,
    required this.cart,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final total = cart.fold<int>(
      0,
      (sum, product) => sum + product.price,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: cart.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 75,
                    color: saffron,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Add some products to continue.'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final product = cart[index];

                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Text(
                            product.emoji,
                            style: const TextStyle(fontSize: 30),
                          ),
                          title: Text(product.name),
                          subtitle: Text('₹${product.price}'),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => onRemove(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(18),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            '₹$total',
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: deepBrown,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: saffron,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutPage(
                                  total: total,
                                ),
                              ),
                            );
                          },
                          child: const Text('Proceed to Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// CHECKOUT PAGE
class CheckoutPage extends StatefulWidget {
  final int total;

  const CheckoutPage({
    super.key,
    required this.total,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void placeOrder() {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all delivery details'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Demo Checkout'),
        content: const Text(
          'Your details have been entered. Online order placement is not connected yet.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Delivery Details',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: deepBrown,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: addressController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Full Address',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 25),
          Card(
            color: Colors.white,
            child: ListTile(
              title: const Text('Total Amount'),
              trailing: Text(
                '₹${widget.total}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: deepBrown,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: saffron,
                foregroundColor: Colors.white,
              ),
              onPressed: placeOrder,
              child: const Text('Continue - Cash on Delivery'),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Note: Checkout is currently a demo. Real orders are not connected.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// SELLER DASHBOARD
class SellerDashboardPage extends StatelessWidget {
  final ValueChanged<Product> onSave;

  const SellerDashboardPage({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: deepBrown,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Seller!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Manage your products on DhoopKart.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: 'Products',
                  value: '${products.length}',
                  icon: Icons.inventory_2,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: MetricCard(
                  title: 'Orders',
                  value: '0',
                  icon: Icons.shopping_bag,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: saffron,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductUploadForm(
                      onSave: onSave,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Upload New Product'),
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Your Products'),
          const SizedBox(height: 10),
          ...products.map(
            (product) => Card(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  product.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(product.name),
                subtitle: Text(product.category),
                trailing: Text(
                  '₹${product.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// PRODUCT UPLOAD FORM
class ProductUploadForm extends StatefulWidget {
  final ValueChanged<Product> onSave;

  const ProductUploadForm({
    super.key,
    required this.onSave,
  });

  @override
  State<ProductUploadForm> createState() => _ProductUploadFormState();
}

class _ProductUploadFormState extends State<ProductUploadForm> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  String category = 'Dhoop';
  String emoji = '🪔';

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveProduct() {
    final name = nameController.text.trim();
    final price = int.tryParse(priceController.text.trim());

    if (name.isEmpty || price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid product name and price'),
        ),
      );
      return;
    }

    final product = Product(
      name: name,
      price: price,
      emoji: emoji,
      category: category,
      description: descriptionController.text.trim(),
    );

    widget.onSave(product);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added to demo catalogue'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Product Information',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: deepBrown,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Product Name',
              hintText: 'Example: Premium Chandan Dhoop',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Price (₹)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            value: category,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Dhoop',
                child: Text('Dhoop'),
              ),
              DropdownMenuItem(
                value: 'Agarbatti',
                child: Text('Agarbatti'),
              ),
              DropdownMenuItem(
                value: 'Puja Items',
                child: Text('Puja Items'),
              ),
              DropdownMenuItem(
                value: 'Combo',
                child: Text('Combo'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  category = value;
                });
              }
            },
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            value: emoji,
            decoration: const InputDecoration(
              labelText: 'Product Icon',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: '🪔', child: Text('🪔 Diya')),
              DropdownMenuItem(value: '🌹', child: Text('🌹 Rose')),
              DropdownMenuItem(value: '🌿', child: Text('🌿 Leaves')),
              DropdownMenuItem(value: '🙏', child: Text('🙏 Puja')),
              DropdownMenuItem(value: '🎁', child: Text('🎁 Gift')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  emoji = value;
                });
              }
            },
          ),
          const SizedBox(height: 15),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Product Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: saffron,
                foregroundColor: Colors.white,
              ),
              onPressed: saveProduct,
              child: const Text('Save Product'),
            ),
          ),
        ],
      ),
    );
  }
}

// ACCOUNT PAGE
class AccountPage extends StatelessWidget {
  final VoidCallback onSeller;
  final VoidCallback onAdmin;

  const AccountPage({
    super.key,
    required this.onSeller,
    required this.onAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: lightBrown,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: saffron,
                  child: Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Welcome to DhoopKart',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: deepBrown,
                  ),
                ),
                Text('Your shopping account'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AccountItem(
            icon: Icons.storefront,
            title: 'Seller Dashboard',
            subtitle: 'Manage and upload products',
            onTap: onSeller,
          ),
          AccountItem(
            icon: Icons.admin_panel_settings,
            title: 'Admin Panel',
            subtitle: 'View app management options',
            onTap: onAdmin,
          ),
          AccountItem(
            icon: Icons.favorite,
            title: 'Aayushri',
            subtitle: 'Explore our special collection',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AayushriPage(),
                ),
              );
            },
          ),
          AccountItem(
            icon: Icons.info_outline,
            title: 'About DhoopKart',
            subtitle: 'Online puja products marketplace',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'DhoopKart',
                applicationVersion: '1.0.0',
                applicationLegalese: 'DhoopKart Demo App',
              );
            },
          ),
        ],
      ),
    );
  }
}

// AAYUSHRI PAGE
class AayushriPage extends StatelessWidget {
  const AayushriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aayushri Collection'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: lightBrown,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Text('🌸', style: TextStyle(fontSize: 55)),
                SizedBox(height: 12),
                Text(
                  'Aayushri',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: deepBrown,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'A special collection for your spiritual moments.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Featured Products'),
          const SizedBox(height: 10),
          ...products.map(
            (product) => Card(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  product.emoji,
                  style: const TextStyle(fontSize: 30),
                ),
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: Text('₹${product.price}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ADMIN PAGE
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const MetricCard(
            title: 'Total Products',
            value: 'Demo',
            icon: Icons.inventory,
          ),
          const SizedBox(height: 12),
          MetricCard(
            title: 'Catalogue Items',
            value: '${products.length}',
            icon: Icons.shopping_bag,
          ),
          const SizedBox(height: 20),
          const Text(
            'Admin Features',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: deepBrown,
            ),
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.people),
              title: Text('User Management'),
              subtitle: Text('Coming soon'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('Order Management'),
              subtitle: Text('Coming soon'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('App Settings'),
              subtitle: Text('Coming soon'),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Note: Admin features are demo placeholders. Login and permissions are not connected.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// PRODUCT CARD
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: lightBrown,
              alignment: Alignment.center,
              child: Text(
                product.emoji,
                style: const TextStyle(fontSize: 58),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 2),
            child: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: deepBrown,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              product.category,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${product.price}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: deepBrown,
                  ),
                ),
                IconButton.filled(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: saffron,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// CATEGORY TILE
class CategoryTile extends StatelessWidget {
  final String emoji;
  final String title;

  const CategoryTile({
    super.key,
    required this.emoji,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 29)),
          const SizedBox(height: 7),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: deepBrown,
            ),
          ),
        ],
      ),
    );
  }
}

// SECTION TITLE
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: deepBrown,
      ),
    );
  }
}

// METRIC CARD
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: saffron, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: deepBrown,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ACCOUNT ITEM
class AccountItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AccountItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: lightBrown,
          child: Icon(icon, color: deepBrown),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
