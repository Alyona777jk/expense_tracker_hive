import 'package:hive/hive.dart';
import '../models/expense.dart';

class ExpenseRepository {
  Box<Expense> _getBox() => Hive.box<Expense>('expenses');

  Future<void> add(Expense expense) async {
    await _getBox().add(expense);
  }

  List<Expense> getAll() {
    return _getBox().values.toList();
  }

  Future<void> update(Expense expense) async {
    await expense.save();
  }

  Future<void> delete(Expense expense) async {
    await expense.delete();
  }

  Map<String, double> getExpensesByCategory() {
    final expenses = getAll();
    final categoryMap = <String, double>{};
    for (var expense in expenses) {
      categoryMap[expense.category] =
          (categoryMap[expense.category] ?? 0) + expense.amount;
    }
    return categoryMap;
  }

  double getTotalExpenses() {
    return getAll().fold(0.0, (sum, expense) => sum + expense.amount);
  }

  List<Expense> getExpensesForPeriod(DateTime start, DateTime end) {
    return getAll()
        .where((e) => e.date.isAfter(start) && e.date.isBefore(end))
        .toList();
  }

  Expense? getBiggestExpense() {
    final expenses = getAll();
    if (expenses.isEmpty) return null;
    return expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  double getAverageExpense() {
    final expenses = getAll();
    if (expenses.isEmpty) return 0.0;
    return getTotalExpenses() / expenses.length;
  }
}