import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';
import '../providers/transaction_provider.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  int? _selectedAccountId;
  String _selectedType = 'EXPENSE';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedAccountId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an account')),
        );
        return;
      }

      final amount = double.parse(_amountController.text.trim());
      final note = _noteController.text.trim();

      final success = await Provider.of<TransactionProvider>(context, listen: false).addTransaction(
        accountId: _selectedAccountId!,
        amount: amount,
        type: _selectedType,
        note: note,
      );

      if (!mounted) return;
      if (success) {
        // Refresh account balance on dashboard
        Provider.of<AccountProvider>(context, listen: false).fetchAccounts();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction recorded!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to record transaction')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = Provider.of<AccountProvider>(context).accounts;

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Record Transaction', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              hint: const Text('Select Account'),
              value: _selectedAccountId,
              decoration: const InputDecoration(labelText: 'Account', border: OutlineInputBorder()),
              items: accounts
                  .map((acc) => DropdownMenuItem(value: acc.id, child: Text(acc.name)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedAccountId = val),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'EXPENSE', label: Text('Expense'), icon: Icon(Icons.arrow_downward)),
                ButtonSegment(value: 'INCOME', label: Text('Income'), icon: Icon(Icons.arrow_upward)),
              ],
              selected: {_selectedType},
              onSelectionChanged: (val) => setState(() => _selectedType = val.first),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (val) => val != null && double.tryParse(val) != null ? null : 'Enter valid amount',
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note / Description', border: OutlineInputBorder()),
              validator: (val) => val != null && val.isNotEmpty ? null : 'Enter a note',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Save Transaction', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}