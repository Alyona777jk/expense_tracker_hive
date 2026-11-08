import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../repositories/expense_repository.dart';

class ExpensesScreen extends StatelessWidget {
  final ExpenseRepository repository = ExpenseRepository();

  ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Expense>('expenses');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Журнал витрат (Hive)'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Expense> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Витрат поки немає'));
          }

          final expenses = box.values.toList();
          final total = repository.getTotalExpenses();
          final avg = repository.getAverageExpense();
          final biggest = repository.getBiggestExpense();
          final categoryData = repository.getExpensesByCategory();

          return SingleChildScrollView(
            child: Column(
              children: [
                // Блок загальної аналітики
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Загалом: \$${total.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Середня витрата: \$${avg.toStringAsFixed(2)}'),
                        if (biggest != null)
                          Text('Найбільша: ${biggest.title} (\$${biggest.amount.toStringAsFixed(2)})'),
                        const Divider(),
                        const Text('Витрати за категоріями:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...categoryData.entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key),
                              Text('\$${e.value.toStringAsFixed(2)}'),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                // Список витрат
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return ListTile(
                      title: Text(expense.title),
                      subtitle: Text(
                        '${expense.category} • ${DateFormat('dd.MM.yyyy').format(expense.date)}'
                        '${expense.description != null && expense.description!.isNotEmpty ? "\n" + expense.description! : ""}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${expense.amount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => repository.delete(expense),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final descController = TextEditingController();
    String selectedCategory = 'Food';
    final categories = ['Food', 'Transport', 'Entertainment', 'Shopping', 'Other'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Додати витрату'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Назва'),
                    ),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Сума (\$)'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedCategory = val!),
                      decoration: const InputDecoration(labelText: 'Категорія'),
                    ),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'Опис (необов\'язково)'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Скасувати'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final amount = double.tryParse(amountController.text) ?? 0.0;
                    if (title.isNotEmpty && amount > 0) {
                      repository.add(
                        Expense(
                          title: title,
                          amount: amount,
                          category: selectedCategory,
                          date: DateTime.now(),
                          description: descController.text.trim(),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Зберегти'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}