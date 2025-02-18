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

    return Scaffold(
      backgroundColor: _palette.containerGrey,
      body: Row(
        children: [
          /// 🔹 Sidebar Navigation Panel
          if (isDesktop || !isSidebarCollapsed)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSidebarCollapsed ? 70 : 230,
              decoration: BoxDecoration(
                color: _palette.primaryBlue,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  /// 🔹 Logo & Toggle Button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: isSidebarCollapsed
                          ? Alignment.center
                          : Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(
                          isSidebarCollapsed ? Icons.menu : Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isSidebarCollapsed = !isSidebarCollapsed;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// 🔹 Sidebar Menu Items
                  _sidebarItem(icon: Icons.dashboard, label: "Dashboard"),
                  _sidebarItem(icon: Icons.receipt_long, label: "Invoices"),
                  _sidebarItem(icon: Icons.people, label: "Clients"),
                  _sidebarItem(icon: Icons.settings, label: "Settings"),
                  _sidebarItem(icon: Icons.logout, label: "Logout"),
                ],
              ),
            ),

          /// 🔹 Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24), // Better Spacing
              child: Column(
                children: [
                  /// 🔹 Top Navigation Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 6)
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _palette.primaryBlue,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.notifications,
                              color: _palette.primaryText),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// 🔹 Dashboard Metrics
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _dashboardCard(
                          title: "Total Invoices",
                          value: "120",
                          icon: Icons.receipt),
                      _dashboardCard(
                          title: "Total Revenue",
                          value: "\$12,500",
                          icon: Icons.attach_money),
                      _dashboardCard(
                          title: "Pending Payments",
                          value: "\$3,200",
                          icon: Icons.pending_actions),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// 🔹 Recent Transactions & Quick Actions
                  Expanded(
                    child: Row(
                      children: [
                        /// 🔹 Recent Transactions Table
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 6)
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Recent Transactions",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: ListView(
                                    children: [
                                      _transactionItem("INV-1001", "Client A",
                                          "\$500", "Paid"),
                                      _transactionItem("INV-1002", "Client B",
                                          "\$700", "Pending"),
                                      _transactionItem("INV-1003", "Client C",
                                          "\$1200", "Paid"),
                                      _transactionItem("INV-1004", "Client D",
                                          "\$450", "Pending"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 24),

                        /// 🔹 Quick Actions Panel
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 6)
                              ],
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Quick Actions",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                _quickActionButton("Create Invoice", Icons.add),
                                _quickActionButton(
                                    "Manage Clients", Icons.people),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Sidebar Item Widget
  Widget _sidebarItem({required IconData icon, required String label}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            if (!isSidebarCollapsed) ...[
              const SizedBox(width: 10),
              Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ],
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
}
