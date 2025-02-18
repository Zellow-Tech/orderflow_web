import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:ofg_web/constants/color_palette.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isSidebarCollapsed = false;
  final OFGColorPalette _palette = OFGColorPalette();

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 900;

    final sidebar = CollapsibleSidebar(
      avatarImg: AssetImage('assets/avatar.jpg'), // Your avatar image
      title: 'OrderFlow', // Title of the sidebar
      body: ListView(
        children: [
          ListTile(title: Text('Item 1')),
          ListTile(title: Text('Item 2')),
          ListTile(title: Text('Item 3')),
          ListTile(title: Text('Item 4')),
          // Add more items as needed
        ],
      ),
      isCollapsed: isSidebarCollapsed, // Set to true for collapsed by default
      items: [],
    );

    return Scaffold(
      backgroundColor: _palette.containerGrey,
      drawer: sidebar,
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildTopNavBar(),
              const SizedBox(height: 24),
              _buildDashboardMetrics(),
              const SizedBox(height: 24),
              Expanded(child: _buildContentSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Dashboard",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _palette.primaryBlue)),
          IconButton(
            icon: Icon(Icons.notifications, color: _palette.primaryText),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  /// 🔹 Quick Action Button
  Widget _quickActionButton(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: _palette.primaryBlue,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// 🔹 Recent Transactions Item
  Widget _transactionItem(
      String id, String client, String amount, String status) {
    return ListTile(
      leading: Icon(Icons.receipt, color: Colors.blue.shade900),
      title: Text("$id - $client"),
      subtitle: Text(amount),
      trailing: Text(
        status,
        style: TextStyle(
            color: status == "Paid" ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 🔹 Dashboard Summary Card
  Widget _dashboardCard(
      {required String title, required String value, required IconData icon}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: _palette.primaryBlue),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 14, color: _palette.secondaryText)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardMetrics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _dashboardCard(
            title: "Total Invoices", value: "120", icon: Icons.receipt),
        _dashboardCard(
            title: "Total Revenue",
            value: "\$12,500",
            icon: Icons.attach_money),
        _dashboardCard(
            title: "Pending Payments",
            value: "\$3,200",
            icon: Icons.pending_actions),
      ],
    );
  }

  Widget _buildContentSection() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildRecentTransactions(),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: _buildQuickActions(),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recent Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                _transactionItem("INV-1001", "Client A", "\$500", "Paid"),
                _transactionItem("INV-1002", "Client B", "\$700", "Pending"),
                _transactionItem("INV-1003", "Client C", "\$1200", "Paid"),
                _transactionItem("INV-1004", "Client D", "\$450", "Pending"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          const Text("Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _quickActionButton("Create Invoice", Icons.add),
          _quickActionButton("Manage Clients", Icons.people),
        ],
      ),
    );
  }
}
