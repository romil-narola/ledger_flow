import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'daos/wallet_dao.dart';
import 'daos/supplier_dao.dart';
import 'daos/customer_dao.dart';
import 'daos/purchase_dao.dart';
import 'daos/sales_dao.dart';
import 'daos/ledger_dao.dart';
import 'daos/expense_dao.dart';

part 'app_database.g.dart';

// ═══════════════════════════════════════════════════════════════════
// TABLE DEFINITIONS
// ═══════════════════════════════════════════════════════════════════

/// Wallet accounts table
class WalletAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get openingBalance => real().withDefault(const Constant(0.0))();
  RealColumn get currentBalance => real().withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get overdraftEnabled =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Suppliers table
class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  RealColumn get totalPurchases => real().withDefault(const Constant(0.0))();
  RealColumn get totalPayments => real().withDefault(const Constant(0.0))();
  RealColumn get outstanding => real().withDefault(const Constant(0.0))();
  RealColumn get creditBalance => real().withDefault(const Constant(0.0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Customers table
class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  RealColumn get totalSales => real().withDefault(const Constant(0.0))();
  RealColumn get totalPayments => real().withDefault(const Constant(0.0))();
  RealColumn get outstanding => real().withDefault(const Constant(0.0))();
  RealColumn get advanceBalance => real().withDefault(const Constant(0.0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Purchases table
class Purchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get referenceNumber => text()();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  IntColumn get walletAccountId => integer().references(WalletAccounts, #id)();
  RealColumn get amount => real()();
  RealColumn get creditApplied => real().withDefault(const Constant(0.0))();
  RealColumn get netAmount => real()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Sales table
class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get referenceNumber => text()();
  IntColumn get customerId => integer().references(Customers, #id)();
  RealColumn get amount => real()();
  RealColumn get advanceApplied => real().withDefault(const Constant(0.0))();
  RealColumn get netAmount => real()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Supplier payments table
class SupplierPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get referenceNumber => text()();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  IntColumn get walletAccountId => integer().references(WalletAccounts, #id)();
  RealColumn get amount => real()();
  RealColumn get outstandingSettled =>
      real().withDefault(const Constant(0.0))();
  RealColumn get creditGenerated => real().withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Customer payments table
class CustomerPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get referenceNumber => text()();
  IntColumn get customerId => integer().references(Customers, #id)();
  IntColumn get walletAccountId => integer().references(WalletAccounts, #id)();
  RealColumn get amount => real()();
  RealColumn get outstandingSettled =>
      real().withDefault(const Constant(0.0))();
  RealColumn get advanceGenerated => real().withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Expense categories table
class ExpenseCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get iconCodepoint =>
      integer().withDefault(const Constant(0xe0b0))(); // default receipt icon
  TextColumn get colorHex =>
      text().withDefault(const Constant('#6366F1'))(); // default indigo
  RealColumn get monthlyBudget => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Expenses table - personal/general expenses
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get referenceNumber => text()();
  IntColumn get categoryId => integer().references(ExpenseCategories, #id)();
  IntColumn get walletAccountId =>
      integer().nullable().references(WalletAccounts, #id)();
  RealColumn get amount => real()();
  TextColumn get description => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Ledger entries table - complete transaction audit trail
class LedgerEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get referenceNumber => text()();
  TextColumn get transactionType => text()(); // TransactionType enum value
  IntColumn get walletAccountId =>
      integer().nullable().references(WalletAccounts, #id)();
  IntColumn get supplierId => integer().nullable().references(Suppliers, #id)();
  IntColumn get customerId => integer().nullable().references(Customers, #id)();
  IntColumn get relatedTransactionId => integer().nullable()();
  RealColumn get debit => real().withDefault(const Constant(0.0))();
  RealColumn get credit => real().withDefault(const Constant(0.0))();
  RealColumn get walletBalance => real().withDefault(const Constant(0.0))();
  TextColumn get description => text()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ═══════════════════════════════════════════════════════════════════
// DATABASE
// ═══════════════════════════════════════════════════════════════════

@DriftDatabase(
  tables: [
    WalletAccounts,
    Suppliers,
    Customers,
    Purchases,
    Sales,
    SupplierPayments,
    CustomerPayments,
    LedgerEntries,
    ExpenseCategories,
    Expenses,
  ],
  daos: [
    WalletDao,
    SupplierDao,
    CustomerDao,
    PurchaseDao,
    SalesDao,
    LedgerDao,
    ExpenseDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Seed default expense categories
          await _seedDefaultCategories();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(expenseCategories);
            await m.createTable(expenses);
            await _seedDefaultCategories();
          }
        },
      );

  Future<void> _seedDefaultCategories() async {
    final defaults = [
      ExpenseCategoriesCompanion.insert(
          name: 'Food & Dining',
          iconCodepoint: const Value(0xe56c),
          colorHex: const Value('#EF4444')),
      ExpenseCategoriesCompanion.insert(
          name: 'Transport',
          iconCodepoint: const Value(0xe531),
          colorHex: const Value('#F59E0B')),
      ExpenseCategoriesCompanion.insert(
          name: 'Rent',
          iconCodepoint: const Value(0xe318),
          colorHex: const Value('#8B5CF6')),
      ExpenseCategoriesCompanion.insert(
          name: 'Utilities',
          iconCodepoint: const Value(0xe1a4),
          colorHex: const Value('#06B6D4')),
      ExpenseCategoriesCompanion.insert(
          name: 'Entertainment',
          iconCodepoint: const Value(0xe40b),
          colorHex: const Value('#EC4899')),
      ExpenseCategoriesCompanion.insert(
          name: 'Medical',
          iconCodepoint: const Value(0xe548),
          colorHex: const Value('#10B981')),
      ExpenseCategoriesCompanion.insert(
          name: 'Education',
          iconCodepoint: const Value(0xe80c),
          colorHex: const Value('#3B82F6')),
      ExpenseCategoriesCompanion.insert(
          name: 'Other',
          iconCodepoint: const Value(0xe8b8),
          colorHex: const Value('#6B7280')),
    ];
    for (final cat in defaults) {
      await into(expenseCategories)
          .insert(cat, mode: InsertMode.insertOrIgnore);
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ledger_flow.db'));
    return NativeDatabase.createInBackground(file);
  });
}
