import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductListScreen extends StatefulWidget {
  final List<Product> cart;
  final List<Product> wishlist;
  final Function(Product) addToCart;
  final Function(Product) addToWishlist;
  final Function(Product) removeFromWishlist;
  final VoidCallback toggleTheme;
  final List<Product> localProducts;
  final Function(Product) addLocalProduct;
  final Function(Product) editLocalProduct;
  final Function(Product) deleteLocalProduct;

  const ProductListScreen({
    Key? key,
    required this.cart,
    required this.wishlist,
    required this.addToCart,
    required this.addToWishlist,
    required this.removeFromWishlist,
    required this.toggleTheme,
    required this.localProducts,
    required this.addLocalProduct,
    required this.editLocalProduct,
    required this.deleteLocalProduct,
  }) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  late Future<List<Product>> _productFuture;
  bool _isGridView = true;

  final List<String> _categories = [
    'All',
    'Electronics',
    'Jewelery',
    "Men's Clothing",
    "Women's Clothing"
  ];

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService.fetchProducts();
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Filter by Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: _categories
                    .map((category) => ListTile(
                          title: Text(category),
                          leading: Radio<String>(
                            value: category,
                            groupValue: _selectedCategory,
                            onChanged: (val) {
                              setState(() {
                                _selectedCategory = val!;
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Product> _filterProducts(List<Product> products) {
    return products.where((product) {
      final matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.toLowerCase().contains(
                _selectedCategory.toLowerCase(),
              );
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showAddProductDialog() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Product', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final product = Product(
                id: DateTime.now().millisecondsSinceEpoch,
                title: titleController.text,
                price: double.tryParse(priceController.text) ?? 0.0,
                description: descriptionController.text,
                category: categoryController.text,
                image: imageController.text,
              );
              widget.addLocalProduct(product);
              setState(() {});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text('ADD PRODUCT', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products, bool isMobile) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (ctx, i) => _buildProductCard(products[i]),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      itemBuilder: (ctx, i) => _buildProductItem(products[i]),
    );
  }

  Widget _buildProductCard(Product product) {
    final isWishlisted = widget.wishlist.contains(product);
    final isInCart = widget.cart.contains(product);
    final isLocal = widget.localProducts.contains(product);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: 'product-image-${product.id}',
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.broken_image, size: 60),
                    loadingBuilder: (BuildContext context, Widget child, 
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                    color: isWishlisted ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    if (isWishlisted) widget.removeFromWishlist(product);
                    else widget.addToWishlist(product);
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: Icon(
                    isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                    color: isInCart ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    widget.addToCart(product);
                    setState(() {});
                  },
                ),
                if (isLocal)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      widget.deleteLocalProduct(product);
                      setState(() {});
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    final isWishlisted = widget.wishlist.contains(product);
    final isInCart = widget.cart.contains(product);
    final isLocal = widget.localProducts.contains(product);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // You can add product detail navigation here
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Center(
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.broken_image),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: isWishlisted ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      if (isWishlisted) widget.removeFromWishlist(product);
                      else widget.addToWishlist(product);
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                      color: isInCart ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      widget.addToCart(product);
                      setState(() {});
                    },
                  ),
                  if (isLocal)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        widget.deleteLocalProduct(product);
                        setState(() {});
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: theme.appBarTheme.titleTextStyle?.color?.withOpacity(0.7)),
                ),
                style: TextStyle(color: theme.appBarTheme.titleTextStyle?.color),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              )
            : const Text('PetStore 🐾', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            tooltip: _isGridView ? 'List view' : 'Grid view',
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: _openFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle theme',
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                const Icon(Icons.shopping_cart),
                if (widget.cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          '${widget.cart.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          // Profile button restored here
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProductDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
        elevation: 4,
      ),
      body: FutureBuilder<List<Product>>(
        future: _productFuture,
        builder: (context, snapshot) {
          List<Product> products = snapshot.data ?? [];
          List<Product> combined = [...products, ...widget.localProducts];
          List<Product> filtered = _filterProducts(combined);

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No products found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  if (_searchQuery.isNotEmpty || _selectedCategory != 'All')
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _selectedCategory = 'All';
                          _searchController.clear();
                        });
                      },
                      child: const Text('Clear filters'),
                    ),
                ],
              ),
            );
          }

          return _isGridView
              ? _buildProductGrid(filtered, isMobile)
              : _buildProductList(filtered);
        },
      ),
    );
  }
}