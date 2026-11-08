import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense.dart';
import 'screens/expenses_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ініціалізація Hive
  await Hive.initFlutter();
  
  // Реєстрація TypeAdapter (згенерованого build_runner)
  Hive.registerAdapter(ExpenseAdapter());
  
  // Відкриття Box
  await Hive.openBox<Expense>('expenses');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ExpensesScreen(),
    );
  }
}