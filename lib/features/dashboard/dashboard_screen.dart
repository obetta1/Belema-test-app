import 'package:belema_test_app/core/models/transaction_model.dart';
import 'package:belema_test_app/core/utils/app_colors.dart';
import 'package:belema_test_app/features/dashboard/dashboard_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/routes/app_routes.dart';
import '../../core/states/app_states.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(dashboardServiceProvider)
        .getTransactions(ref: ref, onError: (message) {});
    ref
        .read(dashboardServiceProvider)
        .getAccountDetails(ref: ref, onError: (message) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildShortcuts(),
          Expanded(child: _buildTransactionList(ref.watch(transactions))),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.white,
                    child: Icon(Icons.person, color: AppColors.primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Hello,", style: TextStyle(color: Colors.white70)),
                      Text("Oluwatobi",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.notifications_none, color: Colors.white),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              _buildBadge("Tier 1"),
              const SizedBox(width: 8),
              _buildBadge(
                ref.read(accountDetail).accountNumber,
                icon: Icons.copy,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
              NumberFormat.currency(decimalDigits: 2, symbol: '₦')
                  .format(ref.read(accountDetail).balance),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
          const Text("Book balance ₦ 1,500,000.34",
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 25),
          Row(
            children: [
              _buildActionButton(
                  label: "Send Money",
                  bg: Colors.amber,
                  textCol: Colors.black,
                  icon: Icons.send,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.transferScreen);
                  }),
              const SizedBox(width: 12),
              _buildActionButton(
                  label: "Top Up",
                  bg: Colors.white24,
                  textCol: Colors.white,
                  icon: Icons.add,
                  onTap: () {}),
              const SizedBox(width: 12),
              const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.more_horiz, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcuts() {
    return Container(
      color: AppColors.green,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Shortcuts",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.white)),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildShortcutCard("Cards", Icons.credit_card, Colors.green),
                  _buildShortcutCard(
                      "Bills Payment", Icons.receipt_long, Colors.green),
                  _buildShortcutCard(
                      "Expenses", Icons.account_balance_wallet, Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactionData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Transactions",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87)),
              TextButton(
                  onPressed: () {},
                  child: const Text("See more >",
                      style: TextStyle(color: Colors.grey))),
            ],
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: transactionData.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
              itemBuilder: (context, index) {
                final item = transactionData[index];
                return _buildTransactionItem(
                    title: item.toAccount,
                    time: item.timeAgo,
                    amount: item.amount,
                    isCredit: index % 2 == 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String time,
    required String amount,
    required bool isCredit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send_rounded, size: 20, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  "Transfer",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          // Amount and Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${isCredit ? '+' : '-'} ₦ $amount",
                style: TextStyle(
                  color: isCredit
                      ? const Color(0xFF0066FF)
                      : Colors.black, // Blue for credit per screenshot
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widgets for repeated elements
  Widget _buildBadge(
    String text, {
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 12, color: Colors.white)
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color bg,
    required Color textCol,
    required IconData icon,
    void Function()? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration:
              BoxDecoration(color: bg, borderRadius: BorderRadius.circular(25)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style:
                      TextStyle(color: textCol, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Icon(icon, color: textCol, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutCard(String title, IconData icon, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.grid_view), label: 'Dashboard'),
        BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz), label: 'Payments'),
        BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Saving'),
        BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
        BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Loans'),
      ],
    );
  }
}
