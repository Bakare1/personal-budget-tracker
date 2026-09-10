import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AccountProvider>(context, listen: false).fetchAccounts();
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final accountProv = Provider.of<AccountProvider>(context);
    final txProv = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${auth.userName ?? "User"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await accountProv.fetchAccounts();
          await txProv.fetchTransactions();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Balance Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Net Worth',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${accountProv.totalBalance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Accounts Section
              const Text(
                'Accounts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              accountProv.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : accountProv.accounts.isEmpty
                  ? const Text('No accounts created yet.')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: accountProv.accounts.length,
                      itemBuilder: (ctx, i) {
                        final acc = accountProv.accounts[i];
                        return ListTile(
                          leading: const Icon(Icons.account_balance),
                          title: Text(acc.name),
                          subtitle: Text(acc.type),
                          trailing: Text(
                            '\$${acc.balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 24),

              // Recent Transactions Section
              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              txProv.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : txProv.transactions.isEmpty
                  ? const Text('No transactions recorded.')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: txProv.transactions.length,
                      itemBuilder: (ctx, i) {
                        final tx = txProv.transactions[i];
                        final isExpense = tx.type == 'EXPENSE';
                        return ListTile(
                          leading: Icon(
                            isExpense
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: isExpense ? Colors.red : Colors.green,
                          ),
                          title: Text(tx.note ?? 'Transaction'),
                          subtitle: Text(tx.accountName ?? ''),
                          trailing: Text(
                            '${isExpense ? "-" : "+"}\$${tx.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: isExpense ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
