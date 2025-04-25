import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data
  Map<String, dynamic> userData = {
    'username': 'DemoUser',
    'email': 'demo@example.com',
    'name': 'John Doe',
    'phone': '+1 123-456-7890',
    'address': '123 Main St, Anytown, USA',
    'memberSince': 'January 2023',
    'profileImage': 'https://i.pravatar.cc/150?img=8',
  };

  // Settings toggle states
  bool _notifications = true;
  bool _darkMode = false;
  bool _locationServices = true;

  // Mock order history
  final List<Map<String, dynamic>> _orderHistory = [
    {
      'id': '#ORD-3921',
      'date': '15 Apr 2025',
      'amount': '₹1,249.99',
      'status': 'Delivered'
    },
    {
      'id': '#ORD-3657',
      'date': '02 Apr 2025',
      'amount': '₹845.50',
      'status': 'Processing'
    },
    {
      'id': '#ORD-3245',
      'date': '18 Mar 2025',
      'amount': '₹2,199.00',
      'status': 'Delivered'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _showEditProfileDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userData['profileImage']),
                    ),
                    SizedBox(height: 16),
                    Text(
                      userData['name'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userData['email'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      "Member since ${userData['memberSince']}",
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              
              Divider(height: 32),
              
              // User Info Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(Icons.person, 'Username', userData['username']),
                      _buildInfoRow(Icons.phone, 'Phone', userData['phone']),
                      _buildInfoRow(Icons.location_on, 'Address', userData['address']),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Settings Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SwitchListTile(
                        title: Text('Push Notifications'),
                        value: _notifications,
                        onChanged: (value) {
                          setState(() {
                            _notifications = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text('Dark Mode'),
                        value: _darkMode,
                        onChanged: (value) {
                          setState(() {
                            _darkMode = value;
                            // In a real app, you would update the theme here
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text('Location Services'),
                        value: _locationServices,
                        onChanged: (value) {
                          setState(() {
                            _locationServices = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Order History Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Orders',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _orderHistory.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          final order = _orderHistory[index];
                          return ListTile(
                            title: Text(order['id']),
                            subtitle: Text('${order['date']} • ${order['amount']}'),
                            trailing: Chip(
                              label: Text(
                                order['status'],
                                style: TextStyle(
                                  color: order['status'] == 'Delivered'
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                              backgroundColor: order['status'] == 'Delivered'
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                            ),
                            onTap: () => _showOrderDetails(order),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Logout Button
              ElevatedButton(
                onPressed: () => _showLogoutDialog(),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: userData['name']);
    final emailController = TextEditingController(text: userData['email']);
    final phoneController = TextEditingController(text: userData['phone']);
    final addressController = TextEditingController(text: userData['address']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userData['name'] = nameController.text;
                userData['email'] = emailController.text;
                userData['phone'] = phoneController.text;
                userData['address'] = addressController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile updated successfully')),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildOrderDetailRow('Order ID', order['id']),
            _buildOrderDetailRow('Date', order['date']),
            _buildOrderDetailRow('Amount', order['amount']),
            _buildOrderDetailRow('Status', order['status']),
            SizedBox(height: 16),
            Text(
              'Items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.inventory_2),
              title: Text('Mock Product 1'),
              subtitle: Text('₹599.99 × 1'),
            ),
            ListTile(
              leading: Icon(Icons.inventory_2),
              title: Text('Mock Product 2'),
              subtitle: Text('₹649.99 × 1'),
            ),
            SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, you would implement logout logic here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}