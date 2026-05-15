import 'package:flutter/material.dart';
import '../model/account.dart';
import '../model/credit.dart';

class HomeViewModel extends ChangeNotifier {
  // Datos hardcodeados para S9
  final String clientName = "Juan Pérez";
  final Account savingsAccount = Account(
    accountNumber: "0011-2233-4455-6677",
    balance: 5000.0,
    accountType: "Ahorros",
  );
  final Credit activeCredit = Credit(
    creditNumber: "CR-987654321",
    pendingAmount: 1200.0,
    status: "Activo",
  );
}
