// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WalletAccountsTable extends WalletAccounts
    with TableInfo<$WalletAccountsTable, WalletAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _openingBalanceMeta =
      const VerificationMeta('openingBalance');
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
      'opening_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _currentBalanceMeta =
      const VerificationMeta('currentBalance');
  @override
  late final GeneratedColumn<double> currentBalance = GeneratedColumn<double>(
      'current_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _overdraftEnabledMeta =
      const VerificationMeta('overdraftEnabled');
  @override
  late final GeneratedColumn<bool> overdraftEnabled = GeneratedColumn<bool>(
      'overdraft_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("overdraft_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        openingBalance,
        currentBalance,
        notes,
        isActive,
        overdraftEnabled,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_accounts';
  @override
  VerificationContext validateIntegrity(Insertable<WalletAccount> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
          _openingBalanceMeta,
          openingBalance.isAcceptableOrUnknown(
              data['opening_balance']!, _openingBalanceMeta));
    }
    if (data.containsKey('current_balance')) {
      context.handle(
          _currentBalanceMeta,
          currentBalance.isAcceptableOrUnknown(
              data['current_balance']!, _currentBalanceMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('overdraft_enabled')) {
      context.handle(
          _overdraftEnabledMeta,
          overdraftEnabled.isAcceptableOrUnknown(
              data['overdraft_enabled']!, _overdraftEnabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletAccount(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      openingBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}opening_balance'])!,
      currentBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}current_balance'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      overdraftEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}overdraft_enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $WalletAccountsTable createAlias(String alias) {
    return $WalletAccountsTable(attachedDatabase, alias);
  }
}

class WalletAccount extends DataClass implements Insertable<WalletAccount> {
  final int id;
  final String name;
  final double openingBalance;
  final double currentBalance;
  final String? notes;
  final bool isActive;
  final bool overdraftEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WalletAccount(
      {required this.id,
      required this.name,
      required this.openingBalance,
      required this.currentBalance,
      this.notes,
      required this.isActive,
      required this.overdraftEnabled,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['opening_balance'] = Variable<double>(openingBalance);
    map['current_balance'] = Variable<double>(currentBalance);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['overdraft_enabled'] = Variable<bool>(overdraftEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WalletAccountsCompanion toCompanion(bool nullToAbsent) {
    return WalletAccountsCompanion(
      id: Value(id),
      name: Value(name),
      openingBalance: Value(openingBalance),
      currentBalance: Value(currentBalance),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isActive: Value(isActive),
      overdraftEnabled: Value(overdraftEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WalletAccount.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletAccount(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      currentBalance: serializer.fromJson<double>(json['currentBalance']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      overdraftEnabled: serializer.fromJson<bool>(json['overdraftEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'currentBalance': serializer.toJson<double>(currentBalance),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'overdraftEnabled': serializer.toJson<bool>(overdraftEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WalletAccount copyWith(
          {int? id,
          String? name,
          double? openingBalance,
          double? currentBalance,
          Value<String?> notes = const Value.absent(),
          bool? isActive,
          bool? overdraftEnabled,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      WalletAccount(
        id: id ?? this.id,
        name: name ?? this.name,
        openingBalance: openingBalance ?? this.openingBalance,
        currentBalance: currentBalance ?? this.currentBalance,
        notes: notes.present ? notes.value : this.notes,
        isActive: isActive ?? this.isActive,
        overdraftEnabled: overdraftEnabled ?? this.overdraftEnabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WalletAccount copyWithCompanion(WalletAccountsCompanion data) {
    return WalletAccount(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      currentBalance: data.currentBalance.present
          ? data.currentBalance.value
          : this.currentBalance,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      overdraftEnabled: data.overdraftEnabled.present
          ? data.overdraftEnabled.value
          : this.overdraftEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletAccount(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('overdraftEnabled: $overdraftEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, openingBalance, currentBalance,
      notes, isActive, overdraftEnabled, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletAccount &&
          other.id == this.id &&
          other.name == this.name &&
          other.openingBalance == this.openingBalance &&
          other.currentBalance == this.currentBalance &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.overdraftEnabled == this.overdraftEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WalletAccountsCompanion extends UpdateCompanion<WalletAccount> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> openingBalance;
  final Value<double> currentBalance;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<bool> overdraftEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WalletAccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.overdraftEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WalletAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.openingBalance = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.overdraftEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<WalletAccount> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? openingBalance,
    Expression<double>? currentBalance,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<bool>? overdraftEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (currentBalance != null) 'current_balance': currentBalance,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (overdraftEnabled != null) 'overdraft_enabled': overdraftEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WalletAccountsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? openingBalance,
      Value<double>? currentBalance,
      Value<String?>? notes,
      Value<bool>? isActive,
      Value<bool>? overdraftEnabled,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return WalletAccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      openingBalance: openingBalance ?? this.openingBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      overdraftEnabled: overdraftEnabled ?? this.overdraftEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (currentBalance.present) {
      map['current_balance'] = Variable<double>(currentBalance.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (overdraftEnabled.present) {
      map['overdraft_enabled'] = Variable<bool>(overdraftEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletAccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('overdraftEnabled: $overdraftEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalPurchasesMeta =
      const VerificationMeta('totalPurchases');
  @override
  late final GeneratedColumn<double> totalPurchases = GeneratedColumn<double>(
      'total_purchases', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalPaymentsMeta =
      const VerificationMeta('totalPayments');
  @override
  late final GeneratedColumn<double> totalPayments = GeneratedColumn<double>(
      'total_payments', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _outstandingMeta =
      const VerificationMeta('outstanding');
  @override
  late final GeneratedColumn<double> outstanding = GeneratedColumn<double>(
      'outstanding', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _creditBalanceMeta =
      const VerificationMeta('creditBalance');
  @override
  late final GeneratedColumn<double> creditBalance = GeneratedColumn<double>(
      'credit_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        email,
        address,
        totalPurchases,
        totalPayments,
        outstanding,
        creditBalance,
        isActive,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(Insertable<Supplier> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('total_purchases')) {
      context.handle(
          _totalPurchasesMeta,
          totalPurchases.isAcceptableOrUnknown(
              data['total_purchases']!, _totalPurchasesMeta));
    }
    if (data.containsKey('total_payments')) {
      context.handle(
          _totalPaymentsMeta,
          totalPayments.isAcceptableOrUnknown(
              data['total_payments']!, _totalPaymentsMeta));
    }
    if (data.containsKey('outstanding')) {
      context.handle(
          _outstandingMeta,
          outstanding.isAcceptableOrUnknown(
              data['outstanding']!, _outstandingMeta));
    }
    if (data.containsKey('credit_balance')) {
      context.handle(
          _creditBalanceMeta,
          creditBalance.isAcceptableOrUnknown(
              data['credit_balance']!, _creditBalanceMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      totalPurchases: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_purchases'])!,
      totalPayments: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_payments'])!,
      outstanding: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}outstanding'])!,
      creditBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_balance'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final double totalPurchases;
  final double totalPayments;
  final double outstanding;
  final double creditBalance;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Supplier(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.address,
      required this.totalPurchases,
      required this.totalPayments,
      required this.outstanding,
      required this.creditBalance,
      required this.isActive,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['total_purchases'] = Variable<double>(totalPurchases);
    map['total_payments'] = Variable<double>(totalPayments);
    map['outstanding'] = Variable<double>(outstanding);
    map['credit_balance'] = Variable<double>(creditBalance);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      totalPurchases: Value(totalPurchases),
      totalPayments: Value(totalPayments),
      outstanding: Value(outstanding),
      creditBalance: Value(creditBalance),
      isActive: Value(isActive),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Supplier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      totalPurchases: serializer.fromJson<double>(json['totalPurchases']),
      totalPayments: serializer.fromJson<double>(json['totalPayments']),
      outstanding: serializer.fromJson<double>(json['outstanding']),
      creditBalance: serializer.fromJson<double>(json['creditBalance']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'totalPurchases': serializer.toJson<double>(totalPurchases),
      'totalPayments': serializer.toJson<double>(totalPayments),
      'outstanding': serializer.toJson<double>(outstanding),
      'creditBalance': serializer.toJson<double>(creditBalance),
      'isActive': serializer.toJson<bool>(isActive),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Supplier copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          double? totalPurchases,
          double? totalPayments,
          double? outstanding,
          double? creditBalance,
          bool? isActive,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Supplier(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        totalPurchases: totalPurchases ?? this.totalPurchases,
        totalPayments: totalPayments ?? this.totalPayments,
        outstanding: outstanding ?? this.outstanding,
        creditBalance: creditBalance ?? this.creditBalance,
        isActive: isActive ?? this.isActive,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      totalPurchases: data.totalPurchases.present
          ? data.totalPurchases.value
          : this.totalPurchases,
      totalPayments: data.totalPayments.present
          ? data.totalPayments.value
          : this.totalPayments,
      outstanding:
          data.outstanding.present ? data.outstanding.value : this.outstanding,
      creditBalance: data.creditBalance.present
          ? data.creditBalance.value
          : this.creditBalance,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('totalPurchases: $totalPurchases, ')
          ..write('totalPayments: $totalPayments, ')
          ..write('outstanding: $outstanding, ')
          ..write('creditBalance: $creditBalance, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      phone,
      email,
      address,
      totalPurchases,
      totalPayments,
      outstanding,
      creditBalance,
      isActive,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.totalPurchases == this.totalPurchases &&
          other.totalPayments == this.totalPayments &&
          other.outstanding == this.outstanding &&
          other.creditBalance == this.creditBalance &&
          other.isActive == this.isActive &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<double> totalPurchases;
  final Value<double> totalPayments;
  final Value<double> outstanding;
  final Value<double> creditBalance;
  final Value<bool> isActive;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.totalPurchases = const Value.absent(),
    this.totalPayments = const Value.absent(),
    this.outstanding = const Value.absent(),
    this.creditBalance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.totalPurchases = const Value.absent(),
    this.totalPayments = const Value.absent(),
    this.outstanding = const Value.absent(),
    this.creditBalance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<double>? totalPurchases,
    Expression<double>? totalPayments,
    Expression<double>? outstanding,
    Expression<double>? creditBalance,
    Expression<bool>? isActive,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (totalPurchases != null) 'total_purchases': totalPurchases,
      if (totalPayments != null) 'total_payments': totalPayments,
      if (outstanding != null) 'outstanding': outstanding,
      if (creditBalance != null) 'credit_balance': creditBalance,
      if (isActive != null) 'is_active': isActive,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SuppliersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<double>? totalPurchases,
      Value<double>? totalPayments,
      Value<double>? outstanding,
      Value<double>? creditBalance,
      Value<bool>? isActive,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      totalPayments: totalPayments ?? this.totalPayments,
      outstanding: outstanding ?? this.outstanding,
      creditBalance: creditBalance ?? this.creditBalance,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (totalPurchases.present) {
      map['total_purchases'] = Variable<double>(totalPurchases.value);
    }
    if (totalPayments.present) {
      map['total_payments'] = Variable<double>(totalPayments.value);
    }
    if (outstanding.present) {
      map['outstanding'] = Variable<double>(outstanding.value);
    }
    if (creditBalance.present) {
      map['credit_balance'] = Variable<double>(creditBalance.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('totalPurchases: $totalPurchases, ')
          ..write('totalPayments: $totalPayments, ')
          ..write('outstanding: $outstanding, ')
          ..write('creditBalance: $creditBalance, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalSalesMeta =
      const VerificationMeta('totalSales');
  @override
  late final GeneratedColumn<double> totalSales = GeneratedColumn<double>(
      'total_sales', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalPaymentsMeta =
      const VerificationMeta('totalPayments');
  @override
  late final GeneratedColumn<double> totalPayments = GeneratedColumn<double>(
      'total_payments', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _outstandingMeta =
      const VerificationMeta('outstanding');
  @override
  late final GeneratedColumn<double> outstanding = GeneratedColumn<double>(
      'outstanding', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _advanceBalanceMeta =
      const VerificationMeta('advanceBalance');
  @override
  late final GeneratedColumn<double> advanceBalance = GeneratedColumn<double>(
      'advance_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        email,
        address,
        totalSales,
        totalPayments,
        outstanding,
        advanceBalance,
        isActive,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('total_sales')) {
      context.handle(
          _totalSalesMeta,
          totalSales.isAcceptableOrUnknown(
              data['total_sales']!, _totalSalesMeta));
    }
    if (data.containsKey('total_payments')) {
      context.handle(
          _totalPaymentsMeta,
          totalPayments.isAcceptableOrUnknown(
              data['total_payments']!, _totalPaymentsMeta));
    }
    if (data.containsKey('outstanding')) {
      context.handle(
          _outstandingMeta,
          outstanding.isAcceptableOrUnknown(
              data['outstanding']!, _outstandingMeta));
    }
    if (data.containsKey('advance_balance')) {
      context.handle(
          _advanceBalanceMeta,
          advanceBalance.isAcceptableOrUnknown(
              data['advance_balance']!, _advanceBalanceMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      totalSales: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_sales'])!,
      totalPayments: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_payments'])!,
      outstanding: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}outstanding'])!,
      advanceBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}advance_balance'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final double totalSales;
  final double totalPayments;
  final double outstanding;
  final double advanceBalance;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Customer(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.address,
      required this.totalSales,
      required this.totalPayments,
      required this.outstanding,
      required this.advanceBalance,
      required this.isActive,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['total_sales'] = Variable<double>(totalSales);
    map['total_payments'] = Variable<double>(totalPayments);
    map['outstanding'] = Variable<double>(outstanding);
    map['advance_balance'] = Variable<double>(advanceBalance);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      totalSales: Value(totalSales),
      totalPayments: Value(totalPayments),
      outstanding: Value(outstanding),
      advanceBalance: Value(advanceBalance),
      isActive: Value(isActive),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      totalSales: serializer.fromJson<double>(json['totalSales']),
      totalPayments: serializer.fromJson<double>(json['totalPayments']),
      outstanding: serializer.fromJson<double>(json['outstanding']),
      advanceBalance: serializer.fromJson<double>(json['advanceBalance']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'totalSales': serializer.toJson<double>(totalSales),
      'totalPayments': serializer.toJson<double>(totalPayments),
      'outstanding': serializer.toJson<double>(outstanding),
      'advanceBalance': serializer.toJson<double>(advanceBalance),
      'isActive': serializer.toJson<bool>(isActive),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Customer copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          double? totalSales,
          double? totalPayments,
          double? outstanding,
          double? advanceBalance,
          bool? isActive,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        totalSales: totalSales ?? this.totalSales,
        totalPayments: totalPayments ?? this.totalPayments,
        outstanding: outstanding ?? this.outstanding,
        advanceBalance: advanceBalance ?? this.advanceBalance,
        isActive: isActive ?? this.isActive,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      totalSales:
          data.totalSales.present ? data.totalSales.value : this.totalSales,
      totalPayments: data.totalPayments.present
          ? data.totalPayments.value
          : this.totalPayments,
      outstanding:
          data.outstanding.present ? data.outstanding.value : this.outstanding,
      advanceBalance: data.advanceBalance.present
          ? data.advanceBalance.value
          : this.advanceBalance,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('totalSales: $totalSales, ')
          ..write('totalPayments: $totalPayments, ')
          ..write('outstanding: $outstanding, ')
          ..write('advanceBalance: $advanceBalance, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      phone,
      email,
      address,
      totalSales,
      totalPayments,
      outstanding,
      advanceBalance,
      isActive,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.totalSales == this.totalSales &&
          other.totalPayments == this.totalPayments &&
          other.outstanding == this.outstanding &&
          other.advanceBalance == this.advanceBalance &&
          other.isActive == this.isActive &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<double> totalSales;
  final Value<double> totalPayments;
  final Value<double> outstanding;
  final Value<double> advanceBalance;
  final Value<bool> isActive;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.totalSales = const Value.absent(),
    this.totalPayments = const Value.absent(),
    this.outstanding = const Value.absent(),
    this.advanceBalance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.totalSales = const Value.absent(),
    this.totalPayments = const Value.absent(),
    this.outstanding = const Value.absent(),
    this.advanceBalance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<double>? totalSales,
    Expression<double>? totalPayments,
    Expression<double>? outstanding,
    Expression<double>? advanceBalance,
    Expression<bool>? isActive,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (totalSales != null) 'total_sales': totalSales,
      if (totalPayments != null) 'total_payments': totalPayments,
      if (outstanding != null) 'outstanding': outstanding,
      if (advanceBalance != null) 'advance_balance': advanceBalance,
      if (isActive != null) 'is_active': isActive,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<double>? totalSales,
      Value<double>? totalPayments,
      Value<double>? outstanding,
      Value<double>? advanceBalance,
      Value<bool>? isActive,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      totalSales: totalSales ?? this.totalSales,
      totalPayments: totalPayments ?? this.totalPayments,
      outstanding: outstanding ?? this.outstanding,
      advanceBalance: advanceBalance ?? this.advanceBalance,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (totalSales.present) {
      map['total_sales'] = Variable<double>(totalSales.value);
    }
    if (totalPayments.present) {
      map['total_payments'] = Variable<double>(totalPayments.value);
    }
    if (outstanding.present) {
      map['outstanding'] = Variable<double>(outstanding.value);
    }
    if (advanceBalance.present) {
      map['advance_balance'] = Variable<double>(advanceBalance.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('totalSales: $totalSales, ')
          ..write('totalPayments: $totalPayments, ')
          ..write('outstanding: $outstanding, ')
          ..write('advanceBalance: $advanceBalance, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _referenceNumberMeta =
      const VerificationMeta('referenceNumber');
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
      'reference_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _walletAccountIdMeta =
      const VerificationMeta('walletAccountId');
  @override
  late final GeneratedColumn<int> walletAccountId = GeneratedColumn<int>(
      'wallet_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES wallet_accounts (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _creditAppliedMeta =
      const VerificationMeta('creditApplied');
  @override
  late final GeneratedColumn<double> creditApplied = GeneratedColumn<double>(
      'credit_applied', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _netAmountMeta =
      const VerificationMeta('netAmount');
  @override
  late final GeneratedColumn<double> netAmount = GeneratedColumn<double>(
      'net_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        referenceNumber,
        supplierId,
        walletAccountId,
        amount,
        creditApplied,
        netAmount,
        notes,
        date,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(Insertable<Purchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference_number')) {
      context.handle(
          _referenceNumberMeta,
          referenceNumber.isAcceptableOrUnknown(
              data['reference_number']!, _referenceNumberMeta));
    } else if (isInserting) {
      context.missing(_referenceNumberMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('wallet_account_id')) {
      context.handle(
          _walletAccountIdMeta,
          walletAccountId.isAcceptableOrUnknown(
              data['wallet_account_id']!, _walletAccountIdMeta));
    } else if (isInserting) {
      context.missing(_walletAccountIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('credit_applied')) {
      context.handle(
          _creditAppliedMeta,
          creditApplied.isAcceptableOrUnknown(
              data['credit_applied']!, _creditAppliedMeta));
    }
    if (data.containsKey('net_amount')) {
      context.handle(_netAmountMeta,
          netAmount.isAcceptableOrUnknown(data['net_amount']!, _netAmountMeta));
    } else if (isInserting) {
      context.missing(_netAmountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      referenceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_number'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id'])!,
      walletAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wallet_account_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      creditApplied: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_applied'])!,
      netAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_amount'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final int id;
  final String referenceNumber;
  final int supplierId;
  final int walletAccountId;
  final double amount;
  final double creditApplied;
  final double netAmount;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;
  const Purchase(
      {required this.id,
      required this.referenceNumber,
      required this.supplierId,
      required this.walletAccountId,
      required this.amount,
      required this.creditApplied,
      required this.netAmount,
      this.notes,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference_number'] = Variable<String>(referenceNumber);
    map['supplier_id'] = Variable<int>(supplierId);
    map['wallet_account_id'] = Variable<int>(walletAccountId);
    map['amount'] = Variable<double>(amount);
    map['credit_applied'] = Variable<double>(creditApplied);
    map['net_amount'] = Variable<double>(netAmount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      referenceNumber: Value(referenceNumber),
      supplierId: Value(supplierId),
      walletAccountId: Value(walletAccountId),
      amount: Value(amount),
      creditApplied: Value(creditApplied),
      netAmount: Value(netAmount),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory Purchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<int>(json['id']),
      referenceNumber: serializer.fromJson<String>(json['referenceNumber']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      walletAccountId: serializer.fromJson<int>(json['walletAccountId']),
      amount: serializer.fromJson<double>(json['amount']),
      creditApplied: serializer.fromJson<double>(json['creditApplied']),
      netAmount: serializer.fromJson<double>(json['netAmount']),
      notes: serializer.fromJson<String?>(json['notes']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'referenceNumber': serializer.toJson<String>(referenceNumber),
      'supplierId': serializer.toJson<int>(supplierId),
      'walletAccountId': serializer.toJson<int>(walletAccountId),
      'amount': serializer.toJson<double>(amount),
      'creditApplied': serializer.toJson<double>(creditApplied),
      'netAmount': serializer.toJson<double>(netAmount),
      'notes': serializer.toJson<String?>(notes),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Purchase copyWith(
          {int? id,
          String? referenceNumber,
          int? supplierId,
          int? walletAccountId,
          double? amount,
          double? creditApplied,
          double? netAmount,
          Value<String?> notes = const Value.absent(),
          DateTime? date,
          DateTime? createdAt}) =>
      Purchase(
        id: id ?? this.id,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        supplierId: supplierId ?? this.supplierId,
        walletAccountId: walletAccountId ?? this.walletAccountId,
        amount: amount ?? this.amount,
        creditApplied: creditApplied ?? this.creditApplied,
        netAmount: netAmount ?? this.netAmount,
        notes: notes.present ? notes.value : this.notes,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      walletAccountId: data.walletAccountId.present
          ? data.walletAccountId.value
          : this.walletAccountId,
      amount: data.amount.present ? data.amount.value : this.amount,
      creditApplied: data.creditApplied.present
          ? data.creditApplied.value
          : this.creditApplied,
      netAmount: data.netAmount.present ? data.netAmount.value : this.netAmount,
      notes: data.notes.present ? data.notes.value : this.notes,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('walletAccountId: $walletAccountId, ')
          ..write('amount: $amount, ')
          ..write('creditApplied: $creditApplied, ')
          ..write('netAmount: $netAmount, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      referenceNumber,
      supplierId,
      walletAccountId,
      amount,
      creditApplied,
      netAmount,
      notes,
      date,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.referenceNumber == this.referenceNumber &&
          other.supplierId == this.supplierId &&
          other.walletAccountId == this.walletAccountId &&
          other.amount == this.amount &&
          other.creditApplied == this.creditApplied &&
          other.netAmount == this.netAmount &&
          other.notes == this.notes &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<int> id;
  final Value<String> referenceNumber;
  final Value<int> supplierId;
  final Value<int> walletAccountId;
  final Value<double> amount;
  final Value<double> creditApplied;
  final Value<double> netAmount;
  final Value<String?> notes;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.walletAccountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.creditApplied = const Value.absent(),
    this.netAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PurchasesCompanion.insert({
    this.id = const Value.absent(),
    required String referenceNumber,
    required int supplierId,
    required int walletAccountId,
    required double amount,
    this.creditApplied = const Value.absent(),
    required double netAmount,
    this.notes = const Value.absent(),
    required DateTime date,
    this.createdAt = const Value.absent(),
  })  : referenceNumber = Value(referenceNumber),
        supplierId = Value(supplierId),
        walletAccountId = Value(walletAccountId),
        amount = Value(amount),
        netAmount = Value(netAmount),
        date = Value(date);
  static Insertable<Purchase> custom({
    Expression<int>? id,
    Expression<String>? referenceNumber,
    Expression<int>? supplierId,
    Expression<int>? walletAccountId,
    Expression<double>? amount,
    Expression<double>? creditApplied,
    Expression<double>? netAmount,
    Expression<String>? notes,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (supplierId != null) 'supplier_id': supplierId,
      if (walletAccountId != null) 'wallet_account_id': walletAccountId,
      if (amount != null) 'amount': amount,
      if (creditApplied != null) 'credit_applied': creditApplied,
      if (netAmount != null) 'net_amount': netAmount,
      if (notes != null) 'notes': notes,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PurchasesCompanion copyWith(
      {Value<int>? id,
      Value<String>? referenceNumber,
      Value<int>? supplierId,
      Value<int>? walletAccountId,
      Value<double>? amount,
      Value<double>? creditApplied,
      Value<double>? netAmount,
      Value<String?>? notes,
      Value<DateTime>? date,
      Value<DateTime>? createdAt}) {
    return PurchasesCompanion(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      supplierId: supplierId ?? this.supplierId,
      walletAccountId: walletAccountId ?? this.walletAccountId,
      amount: amount ?? this.amount,
      creditApplied: creditApplied ?? this.creditApplied,
      netAmount: netAmount ?? this.netAmount,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (walletAccountId.present) {
      map['wallet_account_id'] = Variable<int>(walletAccountId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (creditApplied.present) {
      map['credit_applied'] = Variable<double>(creditApplied.value);
    }
    if (netAmount.present) {
      map['net_amount'] = Variable<double>(netAmount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('walletAccountId: $walletAccountId, ')
          ..write('amount: $amount, ')
          ..write('creditApplied: $creditApplied, ')
          ..write('netAmount: $netAmount, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _referenceNumberMeta =
      const VerificationMeta('referenceNumber');
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
      'reference_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _advanceAppliedMeta =
      const VerificationMeta('advanceApplied');
  @override
  late final GeneratedColumn<double> advanceApplied = GeneratedColumn<double>(
      'advance_applied', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _netAmountMeta =
      const VerificationMeta('netAmount');
  @override
  late final GeneratedColumn<double> netAmount = GeneratedColumn<double>(
      'net_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        referenceNumber,
        customerId,
        amount,
        advanceApplied,
        netAmount,
        notes,
        date,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(Insertable<Sale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference_number')) {
      context.handle(
          _referenceNumberMeta,
          referenceNumber.isAcceptableOrUnknown(
              data['reference_number']!, _referenceNumberMeta));
    } else if (isInserting) {
      context.missing(_referenceNumberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('advance_applied')) {
      context.handle(
          _advanceAppliedMeta,
          advanceApplied.isAcceptableOrUnknown(
              data['advance_applied']!, _advanceAppliedMeta));
    }
    if (data.containsKey('net_amount')) {
      context.handle(_netAmountMeta,
          netAmount.isAcceptableOrUnknown(data['net_amount']!, _netAmountMeta));
    } else if (isInserting) {
      context.missing(_netAmountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      referenceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_number'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      advanceApplied: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}advance_applied'])!,
      netAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_amount'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final int id;
  final String referenceNumber;
  final int customerId;
  final double amount;
  final double advanceApplied;
  final double netAmount;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;
  const Sale(
      {required this.id,
      required this.referenceNumber,
      required this.customerId,
      required this.amount,
      required this.advanceApplied,
      required this.netAmount,
      this.notes,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference_number'] = Variable<String>(referenceNumber);
    map['customer_id'] = Variable<int>(customerId);
    map['amount'] = Variable<double>(amount);
    map['advance_applied'] = Variable<double>(advanceApplied);
    map['net_amount'] = Variable<double>(netAmount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      referenceNumber: Value(referenceNumber),
      customerId: Value(customerId),
      amount: Value(amount),
      advanceApplied: Value(advanceApplied),
      netAmount: Value(netAmount),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory Sale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      referenceNumber: serializer.fromJson<String>(json['referenceNumber']),
      customerId: serializer.fromJson<int>(json['customerId']),
      amount: serializer.fromJson<double>(json['amount']),
      advanceApplied: serializer.fromJson<double>(json['advanceApplied']),
      netAmount: serializer.fromJson<double>(json['netAmount']),
      notes: serializer.fromJson<String?>(json['notes']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'referenceNumber': serializer.toJson<String>(referenceNumber),
      'customerId': serializer.toJson<int>(customerId),
      'amount': serializer.toJson<double>(amount),
      'advanceApplied': serializer.toJson<double>(advanceApplied),
      'netAmount': serializer.toJson<double>(netAmount),
      'notes': serializer.toJson<String?>(notes),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Sale copyWith(
          {int? id,
          String? referenceNumber,
          int? customerId,
          double? amount,
          double? advanceApplied,
          double? netAmount,
          Value<String?> notes = const Value.absent(),
          DateTime? date,
          DateTime? createdAt}) =>
      Sale(
        id: id ?? this.id,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        customerId: customerId ?? this.customerId,
        amount: amount ?? this.amount,
        advanceApplied: advanceApplied ?? this.advanceApplied,
        netAmount: netAmount ?? this.netAmount,
        notes: notes.present ? notes.value : this.notes,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      amount: data.amount.present ? data.amount.value : this.amount,
      advanceApplied: data.advanceApplied.present
          ? data.advanceApplied.value
          : this.advanceApplied,
      netAmount: data.netAmount.present ? data.netAmount.value : this.netAmount,
      notes: data.notes.present ? data.notes.value : this.notes,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('amount: $amount, ')
          ..write('advanceApplied: $advanceApplied, ')
          ..write('netAmount: $netAmount, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, referenceNumber, customerId, amount,
      advanceApplied, netAmount, notes, date, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.referenceNumber == this.referenceNumber &&
          other.customerId == this.customerId &&
          other.amount == this.amount &&
          other.advanceApplied == this.advanceApplied &&
          other.netAmount == this.netAmount &&
          other.notes == this.notes &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<String> referenceNumber;
  final Value<int> customerId;
  final Value<double> amount;
  final Value<double> advanceApplied;
  final Value<double> netAmount;
  final Value<String?> notes;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.amount = const Value.absent(),
    this.advanceApplied = const Value.absent(),
    this.netAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required String referenceNumber,
    required int customerId,
    required double amount,
    this.advanceApplied = const Value.absent(),
    required double netAmount,
    this.notes = const Value.absent(),
    required DateTime date,
    this.createdAt = const Value.absent(),
  })  : referenceNumber = Value(referenceNumber),
        customerId = Value(customerId),
        amount = Value(amount),
        netAmount = Value(netAmount),
        date = Value(date);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<String>? referenceNumber,
    Expression<int>? customerId,
    Expression<double>? amount,
    Expression<double>? advanceApplied,
    Expression<double>? netAmount,
    Expression<String>? notes,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (customerId != null) 'customer_id': customerId,
      if (amount != null) 'amount': amount,
      if (advanceApplied != null) 'advance_applied': advanceApplied,
      if (netAmount != null) 'net_amount': netAmount,
      if (notes != null) 'notes': notes,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SalesCompanion copyWith(
      {Value<int>? id,
      Value<String>? referenceNumber,
      Value<int>? customerId,
      Value<double>? amount,
      Value<double>? advanceApplied,
      Value<double>? netAmount,
      Value<String?>? notes,
      Value<DateTime>? date,
      Value<DateTime>? createdAt}) {
    return SalesCompanion(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      customerId: customerId ?? this.customerId,
      amount: amount ?? this.amount,
      advanceApplied: advanceApplied ?? this.advanceApplied,
      netAmount: netAmount ?? this.netAmount,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (advanceApplied.present) {
      map['advance_applied'] = Variable<double>(advanceApplied.value);
    }
    if (netAmount.present) {
      map['net_amount'] = Variable<double>(netAmount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('amount: $amount, ')
          ..write('advanceApplied: $advanceApplied, ')
          ..write('netAmount: $netAmount, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SupplierPaymentsTable extends SupplierPayments
    with TableInfo<$SupplierPaymentsTable, SupplierPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplierPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _referenceNumberMeta =
      const VerificationMeta('referenceNumber');
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
      'reference_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _walletAccountIdMeta =
      const VerificationMeta('walletAccountId');
  @override
  late final GeneratedColumn<int> walletAccountId = GeneratedColumn<int>(
      'wallet_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES wallet_accounts (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _outstandingSettledMeta =
      const VerificationMeta('outstandingSettled');
  @override
  late final GeneratedColumn<double> outstandingSettled =
      GeneratedColumn<double>('outstanding_settled', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _creditGeneratedMeta =
      const VerificationMeta('creditGenerated');
  @override
  late final GeneratedColumn<double> creditGenerated = GeneratedColumn<double>(
      'credit_generated', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        referenceNumber,
        supplierId,
        walletAccountId,
        amount,
        outstandingSettled,
        creditGenerated,
        notes,
        date,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplier_payments';
  @override
  VerificationContext validateIntegrity(Insertable<SupplierPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference_number')) {
      context.handle(
          _referenceNumberMeta,
          referenceNumber.isAcceptableOrUnknown(
              data['reference_number']!, _referenceNumberMeta));
    } else if (isInserting) {
      context.missing(_referenceNumberMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('wallet_account_id')) {
      context.handle(
          _walletAccountIdMeta,
          walletAccountId.isAcceptableOrUnknown(
              data['wallet_account_id']!, _walletAccountIdMeta));
    } else if (isInserting) {
      context.missing(_walletAccountIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('outstanding_settled')) {
      context.handle(
          _outstandingSettledMeta,
          outstandingSettled.isAcceptableOrUnknown(
              data['outstanding_settled']!, _outstandingSettledMeta));
    }
    if (data.containsKey('credit_generated')) {
      context.handle(
          _creditGeneratedMeta,
          creditGenerated.isAcceptableOrUnknown(
              data['credit_generated']!, _creditGeneratedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplierPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      referenceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_number'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id'])!,
      walletAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wallet_account_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      outstandingSettled: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}outstanding_settled'])!,
      creditGenerated: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}credit_generated'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SupplierPaymentsTable createAlias(String alias) {
    return $SupplierPaymentsTable(attachedDatabase, alias);
  }
}

class SupplierPayment extends DataClass implements Insertable<SupplierPayment> {
  final int id;
  final String referenceNumber;
  final int supplierId;
  final int walletAccountId;
  final double amount;
  final double outstandingSettled;
  final double creditGenerated;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;
  const SupplierPayment(
      {required this.id,
      required this.referenceNumber,
      required this.supplierId,
      required this.walletAccountId,
      required this.amount,
      required this.outstandingSettled,
      required this.creditGenerated,
      this.notes,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference_number'] = Variable<String>(referenceNumber);
    map['supplier_id'] = Variable<int>(supplierId);
    map['wallet_account_id'] = Variable<int>(walletAccountId);
    map['amount'] = Variable<double>(amount);
    map['outstanding_settled'] = Variable<double>(outstandingSettled);
    map['credit_generated'] = Variable<double>(creditGenerated);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SupplierPaymentsCompanion toCompanion(bool nullToAbsent) {
    return SupplierPaymentsCompanion(
      id: Value(id),
      referenceNumber: Value(referenceNumber),
      supplierId: Value(supplierId),
      walletAccountId: Value(walletAccountId),
      amount: Value(amount),
      outstandingSettled: Value(outstandingSettled),
      creditGenerated: Value(creditGenerated),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory SupplierPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierPayment(
      id: serializer.fromJson<int>(json['id']),
      referenceNumber: serializer.fromJson<String>(json['referenceNumber']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      walletAccountId: serializer.fromJson<int>(json['walletAccountId']),
      amount: serializer.fromJson<double>(json['amount']),
      outstandingSettled:
          serializer.fromJson<double>(json['outstandingSettled']),
      creditGenerated: serializer.fromJson<double>(json['creditGenerated']),
      notes: serializer.fromJson<String?>(json['notes']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'referenceNumber': serializer.toJson<String>(referenceNumber),
      'supplierId': serializer.toJson<int>(supplierId),
      'walletAccountId': serializer.toJson<int>(walletAccountId),
      'amount': serializer.toJson<double>(amount),
      'outstandingSettled': serializer.toJson<double>(outstandingSettled),
      'creditGenerated': serializer.toJson<double>(creditGenerated),
      'notes': serializer.toJson<String?>(notes),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SupplierPayment copyWith(
          {int? id,
          String? referenceNumber,
          int? supplierId,
          int? walletAccountId,
          double? amount,
          double? outstandingSettled,
          double? creditGenerated,
          Value<String?> notes = const Value.absent(),
          DateTime? date,
          DateTime? createdAt}) =>
      SupplierPayment(
        id: id ?? this.id,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        supplierId: supplierId ?? this.supplierId,
        walletAccountId: walletAccountId ?? this.walletAccountId,
        amount: amount ?? this.amount,
        outstandingSettled: outstandingSettled ?? this.outstandingSettled,
        creditGenerated: creditGenerated ?? this.creditGenerated,
        notes: notes.present ? notes.value : this.notes,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  SupplierPayment copyWithCompanion(SupplierPaymentsCompanion data) {
    return SupplierPayment(
      id: data.id.present ? data.id.value : this.id,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      walletAccountId: data.walletAccountId.present
          ? data.walletAccountId.value
          : this.walletAccountId,
      amount: data.amount.present ? data.amount.value : this.amount,
      outstandingSettled: data.outstandingSettled.present
          ? data.outstandingSettled.value
          : this.outstandingSettled,
      creditGenerated: data.creditGenerated.present
          ? data.creditGenerated.value
          : this.creditGenerated,
      notes: data.notes.present ? data.notes.value : this.notes,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierPayment(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('walletAccountId: $walletAccountId, ')
          ..write('amount: $amount, ')
          ..write('outstandingSettled: $outstandingSettled, ')
          ..write('creditGenerated: $creditGenerated, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      referenceNumber,
      supplierId,
      walletAccountId,
      amount,
      outstandingSettled,
      creditGenerated,
      notes,
      date,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierPayment &&
          other.id == this.id &&
          other.referenceNumber == this.referenceNumber &&
          other.supplierId == this.supplierId &&
          other.walletAccountId == this.walletAccountId &&
          other.amount == this.amount &&
          other.outstandingSettled == this.outstandingSettled &&
          other.creditGenerated == this.creditGenerated &&
          other.notes == this.notes &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class SupplierPaymentsCompanion extends UpdateCompanion<SupplierPayment> {
  final Value<int> id;
  final Value<String> referenceNumber;
  final Value<int> supplierId;
  final Value<int> walletAccountId;
  final Value<double> amount;
  final Value<double> outstandingSettled;
  final Value<double> creditGenerated;
  final Value<String?> notes;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const SupplierPaymentsCompanion({
    this.id = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.walletAccountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.outstandingSettled = const Value.absent(),
    this.creditGenerated = const Value.absent(),
    this.notes = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SupplierPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required String referenceNumber,
    required int supplierId,
    required int walletAccountId,
    required double amount,
    this.outstandingSettled = const Value.absent(),
    this.creditGenerated = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime date,
    this.createdAt = const Value.absent(),
  })  : referenceNumber = Value(referenceNumber),
        supplierId = Value(supplierId),
        walletAccountId = Value(walletAccountId),
        amount = Value(amount),
        date = Value(date);
  static Insertable<SupplierPayment> custom({
    Expression<int>? id,
    Expression<String>? referenceNumber,
    Expression<int>? supplierId,
    Expression<int>? walletAccountId,
    Expression<double>? amount,
    Expression<double>? outstandingSettled,
    Expression<double>? creditGenerated,
    Expression<String>? notes,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (supplierId != null) 'supplier_id': supplierId,
      if (walletAccountId != null) 'wallet_account_id': walletAccountId,
      if (amount != null) 'amount': amount,
      if (outstandingSettled != null) 'outstanding_settled': outstandingSettled,
      if (creditGenerated != null) 'credit_generated': creditGenerated,
      if (notes != null) 'notes': notes,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SupplierPaymentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? referenceNumber,
      Value<int>? supplierId,
      Value<int>? walletAccountId,
      Value<double>? amount,
      Value<double>? outstandingSettled,
      Value<double>? creditGenerated,
      Value<String?>? notes,
      Value<DateTime>? date,
      Value<DateTime>? createdAt}) {
    return SupplierPaymentsCompanion(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      supplierId: supplierId ?? this.supplierId,
      walletAccountId: walletAccountId ?? this.walletAccountId,
      amount: amount ?? this.amount,
      outstandingSettled: outstandingSettled ?? this.outstandingSettled,
      creditGenerated: creditGenerated ?? this.creditGenerated,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (walletAccountId.present) {
      map['wallet_account_id'] = Variable<int>(walletAccountId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (outstandingSettled.present) {
      map['outstanding_settled'] = Variable<double>(outstandingSettled.value);
    }
    if (creditGenerated.present) {
      map['credit_generated'] = Variable<double>(creditGenerated.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplierPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('walletAccountId: $walletAccountId, ')
          ..write('amount: $amount, ')
          ..write('outstandingSettled: $outstandingSettled, ')
          ..write('creditGenerated: $creditGenerated, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomerPaymentsTable extends CustomerPayments
    with TableInfo<$CustomerPaymentsTable, CustomerPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomerPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _referenceNumberMeta =
      const VerificationMeta('referenceNumber');
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
      'reference_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _walletAccountIdMeta =
      const VerificationMeta('walletAccountId');
  @override
  late final GeneratedColumn<int> walletAccountId = GeneratedColumn<int>(
      'wallet_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES wallet_accounts (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _outstandingSettledMeta =
      const VerificationMeta('outstandingSettled');
  @override
  late final GeneratedColumn<double> outstandingSettled =
      GeneratedColumn<double>('outstanding_settled', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _advanceGeneratedMeta =
      const VerificationMeta('advanceGenerated');
  @override
  late final GeneratedColumn<double> advanceGenerated = GeneratedColumn<double>(
      'advance_generated', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        referenceNumber,
        customerId,
        walletAccountId,
        amount,
        outstandingSettled,
        advanceGenerated,
        notes,
        date,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer_payments';
  @override
  VerificationContext validateIntegrity(Insertable<CustomerPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference_number')) {
      context.handle(
          _referenceNumberMeta,
          referenceNumber.isAcceptableOrUnknown(
              data['reference_number']!, _referenceNumberMeta));
    } else if (isInserting) {
      context.missing(_referenceNumberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('wallet_account_id')) {
      context.handle(
          _walletAccountIdMeta,
          walletAccountId.isAcceptableOrUnknown(
              data['wallet_account_id']!, _walletAccountIdMeta));
    } else if (isInserting) {
      context.missing(_walletAccountIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('outstanding_settled')) {
      context.handle(
          _outstandingSettledMeta,
          outstandingSettled.isAcceptableOrUnknown(
              data['outstanding_settled']!, _outstandingSettledMeta));
    }
    if (data.containsKey('advance_generated')) {
      context.handle(
          _advanceGeneratedMeta,
          advanceGenerated.isAcceptableOrUnknown(
              data['advance_generated']!, _advanceGeneratedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      referenceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_number'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      walletAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wallet_account_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      outstandingSettled: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}outstanding_settled'])!,
      advanceGenerated: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}advance_generated'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomerPaymentsTable createAlias(String alias) {
    return $CustomerPaymentsTable(attachedDatabase, alias);
  }
}

class CustomerPayment extends DataClass implements Insertable<CustomerPayment> {
  final int id;
  final String referenceNumber;
  final int customerId;
  final int walletAccountId;
  final double amount;
  final double outstandingSettled;
  final double advanceGenerated;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;
  const CustomerPayment(
      {required this.id,
      required this.referenceNumber,
      required this.customerId,
      required this.walletAccountId,
      required this.amount,
      required this.outstandingSettled,
      required this.advanceGenerated,
      this.notes,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference_number'] = Variable<String>(referenceNumber);
    map['customer_id'] = Variable<int>(customerId);
    map['wallet_account_id'] = Variable<int>(walletAccountId);
    map['amount'] = Variable<double>(amount);
    map['outstanding_settled'] = Variable<double>(outstandingSettled);
    map['advance_generated'] = Variable<double>(advanceGenerated);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomerPaymentsCompanion toCompanion(bool nullToAbsent) {
    return CustomerPaymentsCompanion(
      id: Value(id),
      referenceNumber: Value(referenceNumber),
      customerId: Value(customerId),
      walletAccountId: Value(walletAccountId),
      amount: Value(amount),
      outstandingSettled: Value(outstandingSettled),
      advanceGenerated: Value(advanceGenerated),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory CustomerPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerPayment(
      id: serializer.fromJson<int>(json['id']),
      referenceNumber: serializer.fromJson<String>(json['referenceNumber']),
      customerId: serializer.fromJson<int>(json['customerId']),
      walletAccountId: serializer.fromJson<int>(json['walletAccountId']),
      amount: serializer.fromJson<double>(json['amount']),
      outstandingSettled:
          serializer.fromJson<double>(json['outstandingSettled']),
      advanceGenerated: serializer.fromJson<double>(json['advanceGenerated']),
      notes: serializer.fromJson<String?>(json['notes']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'referenceNumber': serializer.toJson<String>(referenceNumber),
      'customerId': serializer.toJson<int>(customerId),
      'walletAccountId': serializer.toJson<int>(walletAccountId),
      'amount': serializer.toJson<double>(amount),
      'outstandingSettled': serializer.toJson<double>(outstandingSettled),
      'advanceGenerated': serializer.toJson<double>(advanceGenerated),
      'notes': serializer.toJson<String?>(notes),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomerPayment copyWith(
          {int? id,
          String? referenceNumber,
          int? customerId,
          int? walletAccountId,
          double? amount,
          double? outstandingSettled,
          double? advanceGenerated,
          Value<String?> notes = const Value.absent(),
          DateTime? date,
          DateTime? createdAt}) =>
      CustomerPayment(
        id: id ?? this.id,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        customerId: customerId ?? this.customerId,
        walletAccountId: walletAccountId ?? this.walletAccountId,
        amount: amount ?? this.amount,
        outstandingSettled: outstandingSettled ?? this.outstandingSettled,
        advanceGenerated: advanceGenerated ?? this.advanceGenerated,
        notes: notes.present ? notes.value : this.notes,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  CustomerPayment copyWithCompanion(CustomerPaymentsCompanion data) {
    return CustomerPayment(
      id: data.id.present ? data.id.value : this.id,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      walletAccountId: data.walletAccountId.present
          ? data.walletAccountId.value
          : this.walletAccountId,
      amount: data.amount.present ? data.amount.value : this.amount,
      outstandingSettled: data.outstandingSettled.present
          ? data.outstandingSettled.value
          : this.outstandingSettled,
      advanceGenerated: data.advanceGenerated.present
          ? data.advanceGenerated.value
          : this.advanceGenerated,
      notes: data.notes.present ? data.notes.value : this.notes,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerPayment(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('walletAccountId: $walletAccountId, ')
          ..write('amount: $amount, ')
          ..write('outstandingSettled: $outstandingSettled, ')
          ..write('advanceGenerated: $advanceGenerated, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      referenceNumber,
      customerId,
      walletAccountId,
      amount,
      outstandingSettled,
      advanceGenerated,
      notes,
      date,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerPayment &&
          other.id == this.id &&
          other.referenceNumber == this.referenceNumber &&
          other.customerId == this.customerId &&
          other.walletAccountId == this.walletAccountId &&
          other.amount == this.amount &&
          other.outstandingSettled == this.outstandingSettled &&
          other.advanceGenerated == this.advanceGenerated &&
          other.notes == this.notes &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class CustomerPaymentsCompanion extends UpdateCompanion<CustomerPayment> {
  final Value<int> id;
  final Value<String> referenceNumber;
  final Value<int> customerId;
  final Value<int> walletAccountId;
  final Value<double> amount;
  final Value<double> outstandingSettled;
  final Value<double> advanceGenerated;
  final Value<String?> notes;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const CustomerPaymentsCompanion({
    this.id = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.walletAccountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.outstandingSettled = const Value.absent(),
    this.advanceGenerated = const Value.absent(),
    this.notes = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomerPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required String referenceNumber,
    required int customerId,
    required int walletAccountId,
    required double amount,
    this.outstandingSettled = const Value.absent(),
    this.advanceGenerated = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime date,
    this.createdAt = const Value.absent(),
  })  : referenceNumber = Value(referenceNumber),
        customerId = Value(customerId),
        walletAccountId = Value(walletAccountId),
        amount = Value(amount),
        date = Value(date);
  static Insertable<CustomerPayment> custom({
    Expression<int>? id,
    Expression<String>? referenceNumber,
    Expression<int>? customerId,
    Expression<int>? walletAccountId,
    Expression<double>? amount,
    Expression<double>? outstandingSettled,
    Expression<double>? advanceGenerated,
    Expression<String>? notes,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (customerId != null) 'customer_id': customerId,
      if (walletAccountId != null) 'wallet_account_id': walletAccountId,
      if (amount != null) 'amount': amount,
      if (outstandingSettled != null) 'outstanding_settled': outstandingSettled,
      if (advanceGenerated != null) 'advance_generated': advanceGenerated,
      if (notes != null) 'notes': notes,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomerPaymentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? referenceNumber,
      Value<int>? customerId,
      Value<int>? walletAccountId,
      Value<double>? amount,
      Value<double>? outstandingSettled,
      Value<double>? advanceGenerated,
      Value<String?>? notes,
      Value<DateTime>? date,
      Value<DateTime>? createdAt}) {
    return CustomerPaymentsCompanion(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      customerId: customerId ?? this.customerId,
      walletAccountId: walletAccountId ?? this.walletAccountId,
      amount: amount ?? this.amount,
      outstandingSettled: outstandingSettled ?? this.outstandingSettled,
      advanceGenerated: advanceGenerated ?? this.advanceGenerated,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (walletAccountId.present) {
      map['wallet_account_id'] = Variable<int>(walletAccountId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (outstandingSettled.present) {
      map['outstanding_settled'] = Variable<double>(outstandingSettled.value);
    }
    if (advanceGenerated.present) {
      map['advance_generated'] = Variable<double>(advanceGenerated.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('walletAccountId: $walletAccountId, ')
          ..write('amount: $amount, ')
          ..write('outstandingSettled: $outstandingSettled, ')
          ..write('advanceGenerated: $advanceGenerated, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LedgerEntriesTable extends LedgerEntries
    with TableInfo<$LedgerEntriesTable, LedgerEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _referenceNumberMeta =
      const VerificationMeta('referenceNumber');
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
      'reference_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transactionTypeMeta =
      const VerificationMeta('transactionType');
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
      'transaction_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _walletAccountIdMeta =
      const VerificationMeta('walletAccountId');
  @override
  late final GeneratedColumn<int> walletAccountId = GeneratedColumn<int>(
      'wallet_account_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES wallet_accounts (id)'));
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _relatedTransactionIdMeta =
      const VerificationMeta('relatedTransactionId');
  @override
  late final GeneratedColumn<int> relatedTransactionId = GeneratedColumn<int>(
      'related_transaction_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<double> debit = GeneratedColumn<double>(
      'debit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _creditMeta = const VerificationMeta('credit');
  @override
  late final GeneratedColumn<double> credit = GeneratedColumn<double>(
      'credit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _walletBalanceMeta =
      const VerificationMeta('walletBalance');
  @override
  late final GeneratedColumn<double> walletBalance = GeneratedColumn<double>(
      'wallet_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        referenceNumber,
        transactionType,
        walletAccountId,
        supplierId,
        customerId,
        relatedTransactionId,
        debit,
        credit,
        walletBalance,
        description,
        date,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_entries';
  @override
  VerificationContext validateIntegrity(Insertable<LedgerEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference_number')) {
      context.handle(
          _referenceNumberMeta,
          referenceNumber.isAcceptableOrUnknown(
              data['reference_number']!, _referenceNumberMeta));
    } else if (isInserting) {
      context.missing(_referenceNumberMeta);
    }
    if (data.containsKey('transaction_type')) {
      context.handle(
          _transactionTypeMeta,
          transactionType.isAcceptableOrUnknown(
              data['transaction_type']!, _transactionTypeMeta));
    } else if (isInserting) {
      context.missing(_transactionTypeMeta);
    }
    if (data.containsKey('wallet_account_id')) {
      context.handle(
          _walletAccountIdMeta,
          walletAccountId.isAcceptableOrUnknown(
              data['wallet_account_id']!, _walletAccountIdMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('related_transaction_id')) {
      context.handle(
          _relatedTransactionIdMeta,
          relatedTransactionId.isAcceptableOrUnknown(
              data['related_transaction_id']!, _relatedTransactionIdMeta));
    }
    if (data.containsKey('debit')) {
      context.handle(
          _debitMeta, debit.isAcceptableOrUnknown(data['debit']!, _debitMeta));
    }
    if (data.containsKey('credit')) {
      context.handle(_creditMeta,
          credit.isAcceptableOrUnknown(data['credit']!, _creditMeta));
    }
    if (data.containsKey('wallet_balance')) {
      context.handle(
          _walletBalanceMeta,
          walletBalance.isAcceptableOrUnknown(
              data['wallet_balance']!, _walletBalanceMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      referenceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_number'])!,
      transactionType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transaction_type'])!,
      walletAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wallet_account_id']),
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id']),
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id']),
      relatedTransactionId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}related_transaction_id']),
      debit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}debit'])!,
      credit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit'])!,
      walletBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}wallet_balance'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $LedgerEntriesTable createAlias(String alias) {
    return $LedgerEntriesTable(attachedDatabase, alias);
  }
}

class LedgerEntry extends DataClass implements Insertable<LedgerEntry> {
  final int id;
  final String referenceNumber;
  final String transactionType;
  final int? walletAccountId;
  final int? supplierId;
  final int? customerId;
  final int? relatedTransactionId;
  final double debit;
  final double credit;
  final double walletBalance;
  final String description;
  final DateTime date;
  final DateTime createdAt;
  const LedgerEntry(
      {required this.id,
      required this.referenceNumber,
      required this.transactionType,
      this.walletAccountId,
      this.supplierId,
      this.customerId,
      this.relatedTransactionId,
      required this.debit,
      required this.credit,
      required this.walletBalance,
      required this.description,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference_number'] = Variable<String>(referenceNumber);
    map['transaction_type'] = Variable<String>(transactionType);
    if (!nullToAbsent || walletAccountId != null) {
      map['wallet_account_id'] = Variable<int>(walletAccountId);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<int>(supplierId);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    if (!nullToAbsent || relatedTransactionId != null) {
      map['related_transaction_id'] = Variable<int>(relatedTransactionId);
    }
    map['debit'] = Variable<double>(debit);
    map['credit'] = Variable<double>(credit);
    map['wallet_balance'] = Variable<double>(walletBalance);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LedgerEntriesCompanion toCompanion(bool nullToAbsent) {
    return LedgerEntriesCompanion(
      id: Value(id),
      referenceNumber: Value(referenceNumber),
      transactionType: Value(transactionType),
      walletAccountId: walletAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(walletAccountId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      relatedTransactionId: relatedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedTransactionId),
      debit: Value(debit),
      credit: Value(credit),
      walletBalance: Value(walletBalance),
      description: Value(description),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory LedgerEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerEntry(
      id: serializer.fromJson<int>(json['id']),
      referenceNumber: serializer.fromJson<String>(json['referenceNumber']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      walletAccountId: serializer.fromJson<int?>(json['walletAccountId']),
      supplierId: serializer.fromJson<int?>(json['supplierId']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      relatedTransactionId:
          serializer.fromJson<int?>(json['relatedTransactionId']),
      debit: serializer.fromJson<double>(json['debit']),
      credit: serializer.fromJson<double>(json['credit']),
      walletBalance: serializer.fromJson<double>(json['walletBalance']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'referenceNumber': serializer.toJson<String>(referenceNumber),
      'transactionType': serializer.toJson<String>(transactionType),
      'walletAccountId': serializer.toJson<int?>(walletAccountId),
      'supplierId': serializer.toJson<int?>(supplierId),
      'customerId': serializer.toJson<int?>(customerId),
      'relatedTransactionId': serializer.toJson<int?>(relatedTransactionId),
      'debit': serializer.toJson<double>(debit),
      'credit': serializer.toJson<double>(credit),
      'walletBalance': serializer.toJson<double>(walletBalance),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LedgerEntry copyWith(
          {int? id,
          String? referenceNumber,
          String? transactionType,
          Value<int?> walletAccountId = const Value.absent(),
          Value<int?> supplierId = const Value.absent(),
          Value<int?> customerId = const Value.absent(),
          Value<int?> relatedTransactionId = const Value.absent(),
          double? debit,
          double? credit,
          double? walletBalance,
          String? description,
          DateTime? date,
          DateTime? createdAt}) =>
      LedgerEntry(
        id: id ?? this.id,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        transactionType: transactionType ?? this.transactionType,
        walletAccountId: walletAccountId.present
            ? walletAccountId.value
            : this.walletAccountId,
        supplierId: supplierId.present ? supplierId.value : this.supplierId,
        customerId: customerId.present ? customerId.value : this.customerId,
        relatedTransactionId: relatedTransactionId.present
            ? relatedTransactionId.value
            : this.relatedTransactionId,
        debit: debit ?? this.debit,
        credit: credit ?? this.credit,
        walletBalance: walletBalance ?? this.walletBalance,
        description: description ?? this.description,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  LedgerEntry copyWithCompanion(LedgerEntriesCompanion data) {
    return LedgerEntry(
      id: data.id.present ? data.id.value : this.id,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      walletAccountId: data.walletAccountId.present
          ? data.walletAccountId.value
          : this.walletAccountId,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      relatedTransactionId: data.relatedTransactionId.present
          ? data.relatedTransactionId.value
          : this.relatedTransactionId,
      debit: data.debit.present ? data.debit.value : this.debit,
      credit: data.credit.present ? data.credit.value : this.credit,
      walletBalance: data.walletBalance.present
          ? data.walletBalance.value
          : this.walletBalance,
      description:
          data.description.present ? data.description.value : this.description,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEntry(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('transactionType: $transactionType, ')
          ..write('walletAccountId: $walletAccountId, ')
          ..write('supplierId: $supplierId, ')
          ..write('customerId: $customerId, ')
          ..write('relatedTransactionId: $relatedTransactionId, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('walletBalance: $walletBalance, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      referenceNumber,
      transactionType,
      walletAccountId,
      supplierId,
      customerId,
      relatedTransactionId,
      debit,
      credit,
      walletBalance,
      description,
      date,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerEntry &&
          other.id == this.id &&
          other.referenceNumber == this.referenceNumber &&
          other.transactionType == this.transactionType &&
          other.walletAccountId == this.walletAccountId &&
          other.supplierId == this.supplierId &&
          other.customerId == this.customerId &&
          other.relatedTransactionId == this.relatedTransactionId &&
          other.debit == this.debit &&
          other.credit == this.credit &&
          other.walletBalance == this.walletBalance &&
          other.description == this.description &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class LedgerEntriesCompanion extends UpdateCompanion<LedgerEntry> {
  final Value<int> id;
  final Value<String> referenceNumber;
  final Value<String> transactionType;
  final Value<int?> walletAccountId;
  final Value<int?> supplierId;
  final Value<int?> customerId;
  final Value<int?> relatedTransactionId;
  final Value<double> debit;
  final Value<double> credit;
  final Value<double> walletBalance;
  final Value<String> description;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const LedgerEntriesCompanion({
    this.id = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.walletAccountId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.relatedTransactionId = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.walletBalance = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LedgerEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String referenceNumber,
    required String transactionType,
    this.walletAccountId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.relatedTransactionId = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.walletBalance = const Value.absent(),
    required String description,
    required DateTime date,
    this.createdAt = const Value.absent(),
  })  : referenceNumber = Value(referenceNumber),
        transactionType = Value(transactionType),
        description = Value(description),
        date = Value(date);
  static Insertable<LedgerEntry> custom({
    Expression<int>? id,
    Expression<String>? referenceNumber,
    Expression<String>? transactionType,
    Expression<int>? walletAccountId,
    Expression<int>? supplierId,
    Expression<int>? customerId,
    Expression<int>? relatedTransactionId,
    Expression<double>? debit,
    Expression<double>? credit,
    Expression<double>? walletBalance,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (transactionType != null) 'transaction_type': transactionType,
      if (walletAccountId != null) 'wallet_account_id': walletAccountId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (customerId != null) 'customer_id': customerId,
      if (relatedTransactionId != null)
        'related_transaction_id': relatedTransactionId,
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
      if (walletBalance != null) 'wallet_balance': walletBalance,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LedgerEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? referenceNumber,
      Value<String>? transactionType,
      Value<int?>? walletAccountId,
      Value<int?>? supplierId,
      Value<int?>? customerId,
      Value<int?>? relatedTransactionId,
      Value<double>? debit,
      Value<double>? credit,
      Value<double>? walletBalance,
      Value<String>? description,
      Value<DateTime>? date,
      Value<DateTime>? createdAt}) {
    return LedgerEntriesCompanion(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      transactionType: transactionType ?? this.transactionType,
      walletAccountId: walletAccountId ?? this.walletAccountId,
      supplierId: supplierId ?? this.supplierId,
      customerId: customerId ?? this.customerId,
      relatedTransactionId: relatedTransactionId ?? this.relatedTransactionId,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      walletBalance: walletBalance ?? this.walletBalance,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (walletAccountId.present) {
      map['wallet_account_id'] = Variable<int>(walletAccountId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (relatedTransactionId.present) {
      map['related_transaction_id'] = Variable<int>(relatedTransactionId.value);
    }
    if (debit.present) {
      map['debit'] = Variable<double>(debit.value);
    }
    if (credit.present) {
      map['credit'] = Variable<double>(credit.value);
    }
    if (walletBalance.present) {
      map['wallet_balance'] = Variable<double>(walletBalance.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEntriesCompanion(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('transactionType: $transactionType, ')
          ..write('walletAccountId: $walletAccountId, ')
          ..write('supplierId: $supplierId, ')
          ..write('customerId: $customerId, ')
          ..write('relatedTransactionId: $relatedTransactionId, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('walletBalance: $walletBalance, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTable extends ExpenseCategories
    with TableInfo<$ExpenseCategoriesTable, ExpenseCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _iconCodepointMeta =
      const VerificationMeta('iconCodepoint');
  @override
  late final GeneratedColumn<int> iconCodepoint = GeneratedColumn<int>(
      'icon_codepoint', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xe0b0));
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#6366F1'));
  static const VerificationMeta _monthlyBudgetMeta =
      const VerificationMeta('monthlyBudget');
  @override
  late final GeneratedColumn<double> monthlyBudget = GeneratedColumn<double>(
      'monthly_budget', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, iconCodepoint, colorHex, monthlyBudget, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_codepoint')) {
      context.handle(
          _iconCodepointMeta,
          iconCodepoint.isAcceptableOrUnknown(
              data['icon_codepoint']!, _iconCodepointMeta));
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    }
    if (data.containsKey('monthly_budget')) {
      context.handle(
          _monthlyBudgetMeta,
          monthlyBudget.isAcceptableOrUnknown(
              data['monthly_budget']!, _monthlyBudgetMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      iconCodepoint: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_codepoint'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      monthlyBudget: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monthly_budget']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpenseCategoriesTable createAlias(String alias) {
    return $ExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class ExpenseCategory extends DataClass implements Insertable<ExpenseCategory> {
  final int id;
  final String name;
  final int iconCodepoint;
  final String colorHex;
  final double? monthlyBudget;
  final bool isActive;
  final DateTime createdAt;
  const ExpenseCategory(
      {required this.id,
      required this.name,
      required this.iconCodepoint,
      required this.colorHex,
      this.monthlyBudget,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon_codepoint'] = Variable<int>(iconCodepoint);
    map['color_hex'] = Variable<String>(colorHex);
    if (!nullToAbsent || monthlyBudget != null) {
      map['monthly_budget'] = Variable<double>(monthlyBudget);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      iconCodepoint: Value(iconCodepoint),
      colorHex: Value(colorHex),
      monthlyBudget: monthlyBudget == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyBudget),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconCodepoint: serializer.fromJson<int>(json['iconCodepoint']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      monthlyBudget: serializer.fromJson<double?>(json['monthlyBudget']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'iconCodepoint': serializer.toJson<int>(iconCodepoint),
      'colorHex': serializer.toJson<String>(colorHex),
      'monthlyBudget': serializer.toJson<double?>(monthlyBudget),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseCategory copyWith(
          {int? id,
          String? name,
          int? iconCodepoint,
          String? colorHex,
          Value<double?> monthlyBudget = const Value.absent(),
          bool? isActive,
          DateTime? createdAt}) =>
      ExpenseCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        iconCodepoint: iconCodepoint ?? this.iconCodepoint,
        colorHex: colorHex ?? this.colorHex,
        monthlyBudget:
            monthlyBudget.present ? monthlyBudget.value : this.monthlyBudget,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  ExpenseCategory copyWithCompanion(ExpenseCategoriesCompanion data) {
    return ExpenseCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconCodepoint: data.iconCodepoint.present
          ? data.iconCodepoint.value
          : this.iconCodepoint,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      monthlyBudget: data.monthlyBudget.present
          ? data.monthlyBudget.value
          : this.monthlyBudget,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCodepoint: $iconCodepoint, ')
          ..write('colorHex: $colorHex, ')
          ..write('monthlyBudget: $monthlyBudget, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, iconCodepoint, colorHex, monthlyBudget, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconCodepoint == this.iconCodepoint &&
          other.colorHex == this.colorHex &&
          other.monthlyBudget == this.monthlyBudget &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class ExpenseCategoriesCompanion extends UpdateCompanion<ExpenseCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> iconCodepoint;
  final Value<String> colorHex;
  final Value<double?> monthlyBudget;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const ExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconCodepoint = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.monthlyBudget = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpenseCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.iconCodepoint = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.monthlyBudget = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ExpenseCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? iconCodepoint,
    Expression<String>? colorHex,
    Expression<double>? monthlyBudget,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconCodepoint != null) 'icon_codepoint': iconCodepoint,
      if (colorHex != null) 'color_hex': colorHex,
      if (monthlyBudget != null) 'monthly_budget': monthlyBudget,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpenseCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? iconCodepoint,
      Value<String>? colorHex,
      Value<double?>? monthlyBudget,
      Value<bool>? isActive,
      Value<DateTime>? createdAt}) {
    return ExpenseCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodepoint: iconCodepoint ?? this.iconCodepoint,
      colorHex: colorHex ?? this.colorHex,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconCodepoint.present) {
      map['icon_codepoint'] = Variable<int>(iconCodepoint.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (monthlyBudget.present) {
      map['monthly_budget'] = Variable<double>(monthlyBudget.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCodepoint: $iconCodepoint, ')
          ..write('colorHex: $colorHex, ')
          ..write('monthlyBudget: $monthlyBudget, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _referenceNumberMeta =
      const VerificationMeta('referenceNumber');
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
      'reference_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_categories (id)'));
  static const VerificationMeta _walletAccountIdMeta =
      const VerificationMeta('walletAccountId');
  @override
  late final GeneratedColumn<int> walletAccountId = GeneratedColumn<int>(
      'wallet_account_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES wallet_accounts (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        referenceNumber,
        categoryId,
        walletAccountId,
        amount,
        description,
        notes,
        date,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference_number')) {
      context.handle(
          _referenceNumberMeta,
          referenceNumber.isAcceptableOrUnknown(
              data['reference_number']!, _referenceNumberMeta));
    } else if (isInserting) {
      context.missing(_referenceNumberMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('wallet_account_id')) {
      context.handle(
          _walletAccountIdMeta,
          walletAccountId.isAcceptableOrUnknown(
              data['wallet_account_id']!, _walletAccountIdMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      referenceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_number'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      walletAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wallet_account_id']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final String referenceNumber;
  final int categoryId;
  final int? walletAccountId;
  final double amount;
  final String description;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;
  const Expense(
      {required this.id,
      required this.referenceNumber,
      required this.categoryId,
      this.walletAccountId,
      required this.amount,
      required this.description,
      this.notes,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference_number'] = Variable<String>(referenceNumber);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || walletAccountId != null) {
      map['wallet_account_id'] = Variable<int>(walletAccountId);
    }
    map['amount'] = Variable<double>(amount);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      referenceNumber: Value(referenceNumber),
      categoryId: Value(categoryId),
      walletAccountId: walletAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(walletAccountId),
      amount: Value(amount),
      description: Value(description),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      referenceNumber: serializer.fromJson<String>(json['referenceNumber']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      walletAccountId: serializer.fromJson<int?>(json['walletAccountId']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String>(json['description']),
      notes: serializer.fromJson<String?>(json['notes']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'referenceNumber': serializer.toJson<String>(referenceNumber),
      'categoryId': serializer.toJson<int>(categoryId),
      'walletAccountId': serializer.toJson<int?>(walletAccountId),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String>(description),
      'notes': serializer.toJson<String?>(notes),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Expense copyWith(
          {int? id,
          String? referenceNumber,
          int? categoryId,
          Value<int?> walletAccountId = const Value.absent(),
          double? amount,
          String? description,
          Value<String?> notes = const Value.absent(),
          DateTime? date,
          DateTime? createdAt}) =>
      Expense(
        id: id ?? this.id,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        categoryId: categoryId ?? this.categoryId,
        walletAccountId: walletAccountId.present
            ? walletAccountId.value
            : this.walletAccountId,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        notes: notes.present ? notes.value : this.notes,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      walletAccountId: data.walletAccountId.present
          ? data.walletAccountId.value
          : this.walletAccountId,
      amount: data.amount.present ? data.amount.value : this.amount,
      description:
          data.description.present ? data.description.value : this.description,
      notes: data.notes.present ? data.notes.value : this.notes,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('categoryId: $categoryId, ')
          ..write('walletAccountId: $walletAccountId, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, referenceNumber, categoryId,
      walletAccountId, amount, description, notes, date, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.referenceNumber == this.referenceNumber &&
          other.categoryId == this.categoryId &&
          other.walletAccountId == this.walletAccountId &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.notes == this.notes &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<String> referenceNumber;
  final Value<int> categoryId;
  final Value<int?> walletAccountId;
  final Value<double> amount;
  final Value<String> description;
  final Value<String?> notes;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.walletAccountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String referenceNumber,
    required int categoryId,
    this.walletAccountId = const Value.absent(),
    required double amount,
    required String description,
    this.notes = const Value.absent(),
    required DateTime date,
    this.createdAt = const Value.absent(),
  })  : referenceNumber = Value(referenceNumber),
        categoryId = Value(categoryId),
        amount = Value(amount),
        description = Value(description),
        date = Value(date);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<String>? referenceNumber,
    Expression<int>? categoryId,
    Expression<int>? walletAccountId,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<String>? notes,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (categoryId != null) 'category_id': categoryId,
      if (walletAccountId != null) 'wallet_account_id': walletAccountId,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<String>? referenceNumber,
      Value<int>? categoryId,
      Value<int?>? walletAccountId,
      Value<double>? amount,
      Value<String>? description,
      Value<String?>? notes,
      Value<DateTime>? date,
      Value<DateTime>? createdAt}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      categoryId: categoryId ?? this.categoryId,
      walletAccountId: walletAccountId ?? this.walletAccountId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (walletAccountId.present) {
      map['wallet_account_id'] = Variable<int>(walletAccountId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('categoryId: $categoryId, ')
          ..write('walletAccountId: $walletAccountId, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WalletAccountsTable walletAccounts = $WalletAccountsTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SupplierPaymentsTable supplierPayments =
      $SupplierPaymentsTable(this);
  late final $CustomerPaymentsTable customerPayments =
      $CustomerPaymentsTable(this);
  late final $LedgerEntriesTable ledgerEntries = $LedgerEntriesTable(this);
  late final $ExpenseCategoriesTable expenseCategories =
      $ExpenseCategoriesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final WalletDao walletDao = WalletDao(this as AppDatabase);
  late final SupplierDao supplierDao = SupplierDao(this as AppDatabase);
  late final CustomerDao customerDao = CustomerDao(this as AppDatabase);
  late final PurchaseDao purchaseDao = PurchaseDao(this as AppDatabase);
  late final SalesDao salesDao = SalesDao(this as AppDatabase);
  late final LedgerDao ledgerDao = LedgerDao(this as AppDatabase);
  late final ExpenseDao expenseDao = ExpenseDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        walletAccounts,
        suppliers,
        customers,
        purchases,
        sales,
        supplierPayments,
        customerPayments,
        ledgerEntries,
        expenseCategories,
        expenses
      ];
}

typedef $$WalletAccountsTableCreateCompanionBuilder = WalletAccountsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<double> openingBalance,
  Value<double> currentBalance,
  Value<String?> notes,
  Value<bool> isActive,
  Value<bool> overdraftEnabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$WalletAccountsTableUpdateCompanionBuilder = WalletAccountsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<double> openingBalance,
  Value<double> currentBalance,
  Value<String?> notes,
  Value<bool> isActive,
  Value<bool> overdraftEnabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$WalletAccountsTableReferences
    extends BaseReferences<_$AppDatabase, $WalletAccountsTable, WalletAccount> {
  $$WalletAccountsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PurchasesTable, List<Purchase>>
      _purchasesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchases,
              aliasName: $_aliasNameGenerator(
                  db.walletAccounts.id, db.purchases.walletAccountId));

  $$PurchasesTableProcessedTableManager get purchasesRefs {
    final manager = $$PurchasesTableTableManager($_db, $_db.purchases).filter(
        (f) => f.walletAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchasesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SupplierPaymentsTable, List<SupplierPayment>>
      _supplierPaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.supplierPayments,
              aliasName: $_aliasNameGenerator(
                  db.walletAccounts.id, db.supplierPayments.walletAccountId));

  $$SupplierPaymentsTableProcessedTableManager get supplierPaymentsRefs {
    final manager =
        $$SupplierPaymentsTableTableManager($_db, $_db.supplierPayments).filter(
            (f) => f.walletAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_supplierPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CustomerPaymentsTable, List<CustomerPayment>>
      _customerPaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.customerPayments,
              aliasName: $_aliasNameGenerator(
                  db.walletAccounts.id, db.customerPayments.walletAccountId));

  $$CustomerPaymentsTableProcessedTableManager get customerPaymentsRefs {
    final manager =
        $$CustomerPaymentsTableTableManager($_db, $_db.customerPayments).filter(
            (f) => f.walletAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_customerPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LedgerEntriesTable, List<LedgerEntry>>
      _ledgerEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ledgerEntries,
              aliasName: $_aliasNameGenerator(
                  db.walletAccounts.id, db.ledgerEntries.walletAccountId));

  $$LedgerEntriesTableProcessedTableManager get ledgerEntriesRefs {
    final manager = $$LedgerEntriesTableTableManager($_db, $_db.ledgerEntries)
        .filter(
            (f) => f.walletAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ledgerEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenses,
          aliasName: $_aliasNameGenerator(
              db.walletAccounts.id, db.expenses.walletAccountId));

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager($_db, $_db.expenses).filter(
        (f) => f.walletAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WalletAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletAccountsTable> {
  $$WalletAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentBalance => $composableBuilder(
      column: $table.currentBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get overdraftEnabled => $composableBuilder(
      column: $table.overdraftEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> purchasesRefs(
      Expression<bool> Function($$PurchasesTableFilterComposer f) f) {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.walletAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableFilterComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> supplierPaymentsRefs(
      Expression<bool> Function($$SupplierPaymentsTableFilterComposer f) f) {
    final $$SupplierPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.supplierPayments,
        getReferencedColumn: (t) => t.walletAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SupplierPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.supplierPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> customerPaymentsRefs(
      Expression<bool> Function($$CustomerPaymentsTableFilterComposer f) f) {
    final $$CustomerPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.customerPayments,
        getReferencedColumn: (t) => t.walletAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomerPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.customerPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> ledgerEntriesRefs(
      Expression<bool> Function($$LedgerEntriesTableFilterComposer f) f) {
    final $$LedgerEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ledgerEntries,
        getReferencedColumn: (t) => t.walletAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LedgerEntriesTableFilterComposer(
              $db: $db,
              $table: $db.ledgerEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> expensesRefs(
      Expression<bool> Function($$ExpensesTableFilterComposer f) f) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.walletAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableFilterComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WalletAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletAccountsTable> {
  $$WalletAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentBalance => $composableBuilder(
      column: $table.currentBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get overdraftEnabled => $composableBuilder(
      column: $table.overdraftEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$WalletAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletAccountsTable> {
  $$WalletAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance, builder: (column) => column);

  GeneratedColumn<double> get currentBalance => $composableBuilder(
      column: $table.currentBalance, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get overdraftEnabled => $composableBuilder(
      column: $table.overdraftEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> purchasesRefs<T extends Object>(
      Expression<T> Function($$PurchasesTableAnnotationComposer a) f) {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.walletAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> supplierPaymentsRefs<T extends Object>(
      Expression<T> Function($$SupplierPaymentsTableAnnotationComposer a) f) {
    final $$SupplierPaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.supplierPayments,
        getReferencedColumn: (t) => t.walletAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SupplierPaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.supplierPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> customerPaymentsRefs<T extends Object>(
      Expression<T> Function($$CustomerPaymentsTableAnnotationComposer a) f) {
    final $$CustomerPaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.customerPayments,
        getReferencedColumn: (t) => t.walletAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomerPaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.customerPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> ledgerEntriesRefs<T extends Object>(
      Expression<T> Function($$LedgerEntriesTableAnnotationComposer a) f) {
    final $$LedgerEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ledgerEntries,
        getReferencedColumn: (t) => t.walletAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LedgerEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.ledgerEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
      Expression<T> Function($$ExpensesTableAnnotationComposer a) f) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.walletAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WalletAccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WalletAccountsTable,
    WalletAccount,
    $$WalletAccountsTableFilterComposer,
    $$WalletAccountsTableOrderingComposer,
    $$WalletAccountsTableAnnotationComposer,
    $$WalletAccountsTableCreateCompanionBuilder,
    $$WalletAccountsTableUpdateCompanionBuilder,
    (WalletAccount, $$WalletAccountsTableReferences),
    WalletAccount,
    PrefetchHooks Function(
        {bool purchasesRefs,
        bool supplierPaymentsRefs,
        bool customerPaymentsRefs,
        bool ledgerEntriesRefs,
        bool expensesRefs})> {
  $$WalletAccountsTableTableManager(
      _$AppDatabase db, $WalletAccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<double> currentBalance = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> overdraftEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              WalletAccountsCompanion(
            id: id,
            name: name,
            openingBalance: openingBalance,
            currentBalance: currentBalance,
            notes: notes,
            isActive: isActive,
            overdraftEnabled: overdraftEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<double> openingBalance = const Value.absent(),
            Value<double> currentBalance = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> overdraftEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              WalletAccountsCompanion.insert(
            id: id,
            name: name,
            openingBalance: openingBalance,
            currentBalance: currentBalance,
            notes: notes,
            isActive: isActive,
            overdraftEnabled: overdraftEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WalletAccountsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {purchasesRefs = false,
              supplierPaymentsRefs = false,
              customerPaymentsRefs = false,
              ledgerEntriesRefs = false,
              expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchasesRefs) db.purchases,
                if (supplierPaymentsRefs) db.supplierPayments,
                if (customerPaymentsRefs) db.customerPayments,
                if (ledgerEntriesRefs) db.ledgerEntries,
                if (expensesRefs) db.expenses
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchasesRefs)
                    await $_getPrefetchedData<WalletAccount,
                            $WalletAccountsTable, Purchase>(
                        currentTable: table,
                        referencedTable: $$WalletAccountsTableReferences
                            ._purchasesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WalletAccountsTableReferences(db, table, p0)
                                .purchasesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.walletAccountId == item.id),
                        typedResults: items),
                  if (supplierPaymentsRefs)
                    await $_getPrefetchedData<WalletAccount,
                            $WalletAccountsTable, SupplierPayment>(
                        currentTable: table,
                        referencedTable: $$WalletAccountsTableReferences
                            ._supplierPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WalletAccountsTableReferences(db, table, p0)
                                .supplierPaymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.walletAccountId == item.id),
                        typedResults: items),
                  if (customerPaymentsRefs)
                    await $_getPrefetchedData<WalletAccount,
                            $WalletAccountsTable, CustomerPayment>(
                        currentTable: table,
                        referencedTable: $$WalletAccountsTableReferences
                            ._customerPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WalletAccountsTableReferences(db, table, p0)
                                .customerPaymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.walletAccountId == item.id),
                        typedResults: items),
                  if (ledgerEntriesRefs)
                    await $_getPrefetchedData<WalletAccount,
                            $WalletAccountsTable, LedgerEntry>(
                        currentTable: table,
                        referencedTable: $$WalletAccountsTableReferences
                            ._ledgerEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WalletAccountsTableReferences(db, table, p0)
                                .ledgerEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.walletAccountId == item.id),
                        typedResults: items),
                  if (expensesRefs)
                    await $_getPrefetchedData<WalletAccount,
                            $WalletAccountsTable, Expense>(
                        currentTable: table,
                        referencedTable: $$WalletAccountsTableReferences
                            ._expensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WalletAccountsTableReferences(db, table, p0)
                                .expensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.walletAccountId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WalletAccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WalletAccountsTable,
    WalletAccount,
    $$WalletAccountsTableFilterComposer,
    $$WalletAccountsTableOrderingComposer,
    $$WalletAccountsTableAnnotationComposer,
    $$WalletAccountsTableCreateCompanionBuilder,
    $$WalletAccountsTableUpdateCompanionBuilder,
    (WalletAccount, $$WalletAccountsTableReferences),
    WalletAccount,
    PrefetchHooks Function(
        {bool purchasesRefs,
        bool supplierPaymentsRefs,
        bool customerPaymentsRefs,
        bool ledgerEntriesRefs,
        bool expensesRefs})>;
typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<double> totalPurchases,
  Value<double> totalPayments,
  Value<double> outstanding,
  Value<double> creditBalance,
  Value<bool> isActive,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<double> totalPurchases,
  Value<double> totalPayments,
  Value<double> outstanding,
  Value<double> creditBalance,
  Value<bool> isActive,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$SuppliersTableReferences
    extends BaseReferences<_$AppDatabase, $SuppliersTable, Supplier> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PurchasesTable, List<Purchase>>
      _purchasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.purchases,
          aliasName:
              $_aliasNameGenerator(db.suppliers.id, db.purchases.supplierId));

  $$PurchasesTableProcessedTableManager get purchasesRefs {
    final manager = $$PurchasesTableTableManager($_db, $_db.purchases)
        .filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchasesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SupplierPaymentsTable, List<SupplierPayment>>
      _supplierPaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.supplierPayments,
              aliasName: $_aliasNameGenerator(
                  db.suppliers.id, db.supplierPayments.supplierId));

  $$SupplierPaymentsTableProcessedTableManager get supplierPaymentsRefs {
    final manager =
        $$SupplierPaymentsTableTableManager($_db, $_db.supplierPayments)
            .filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_supplierPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LedgerEntriesTable, List<LedgerEntry>>
      _ledgerEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ledgerEntries,
              aliasName: $_aliasNameGenerator(
                  db.suppliers.id, db.ledgerEntries.supplierId));

  $$LedgerEntriesTableProcessedTableManager get ledgerEntriesRefs {
    final manager = $$LedgerEntriesTableTableManager($_db, $_db.ledgerEntries)
        .filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ledgerEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalPurchases => $composableBuilder(
      column: $table.totalPurchases,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalPayments => $composableBuilder(
      column: $table.totalPayments, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get outstanding => $composableBuilder(
      column: $table.outstanding, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditBalance => $composableBuilder(
      column: $table.creditBalance, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> purchasesRefs(
      Expression<bool> Function($$PurchasesTableFilterComposer f) f) {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableFilterComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> supplierPaymentsRefs(
      Expression<bool> Function($$SupplierPaymentsTableFilterComposer f) f) {
    final $$SupplierPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.supplierPayments,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SupplierPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.supplierPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> ledgerEntriesRefs(
      Expression<bool> Function($$LedgerEntriesTableFilterComposer f) f) {
    final $$LedgerEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ledgerEntries,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LedgerEntriesTableFilterComposer(
              $db: $db,
              $table: $db.ledgerEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalPurchases => $composableBuilder(
      column: $table.totalPurchases,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalPayments => $composableBuilder(
      column: $table.totalPayments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get outstanding => $composableBuilder(
      column: $table.outstanding, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditBalance => $composableBuilder(
      column: $table.creditBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get totalPurchases => $composableBuilder(
      column: $table.totalPurchases, builder: (column) => column);

  GeneratedColumn<double> get totalPayments => $composableBuilder(
      column: $table.totalPayments, builder: (column) => column);

  GeneratedColumn<double> get outstanding => $composableBuilder(
      column: $table.outstanding, builder: (column) => column);

  GeneratedColumn<double> get creditBalance => $composableBuilder(
      column: $table.creditBalance, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> purchasesRefs<T extends Object>(
      Expression<T> Function($$PurchasesTableAnnotationComposer a) f) {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> supplierPaymentsRefs<T extends Object>(
      Expression<T> Function($$SupplierPaymentsTableAnnotationComposer a) f) {
    final $$SupplierPaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.supplierPayments,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SupplierPaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.supplierPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> ledgerEntriesRefs<T extends Object>(
      Expression<T> Function($$LedgerEntriesTableAnnotationComposer a) f) {
    final $$LedgerEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ledgerEntries,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LedgerEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.ledgerEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function(
        {bool purchasesRefs,
        bool supplierPaymentsRefs,
        bool ledgerEntriesRefs})> {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<double> totalPurchases = const Value.absent(),
            Value<double> totalPayments = const Value.absent(),
            Value<double> outstanding = const Value.absent(),
            Value<double> creditBalance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SuppliersCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            totalPurchases: totalPurchases,
            totalPayments: totalPayments,
            outstanding: outstanding,
            creditBalance: creditBalance,
            isActive: isActive,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<double> totalPurchases = const Value.absent(),
            Value<double> totalPayments = const Value.absent(),
            Value<double> outstanding = const Value.absent(),
            Value<double> creditBalance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SuppliersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            totalPurchases: totalPurchases,
            totalPayments: totalPayments,
            outstanding: outstanding,
            creditBalance: creditBalance,
            isActive: isActive,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SuppliersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {purchasesRefs = false,
              supplierPaymentsRefs = false,
              ledgerEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchasesRefs) db.purchases,
                if (supplierPaymentsRefs) db.supplierPayments,
                if (ledgerEntriesRefs) db.ledgerEntries
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchasesRefs)
                    await $_getPrefetchedData<Supplier, $SuppliersTable,
                            Purchase>(
                        currentTable: table,
                        referencedTable:
                            $$SuppliersTableReferences._purchasesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SuppliersTableReferences(db, table, p0)
                                .purchasesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.supplierId == item.id),
                        typedResults: items),
                  if (supplierPaymentsRefs)
                    await $_getPrefetchedData<Supplier, $SuppliersTable,
                            SupplierPayment>(
                        currentTable: table,
                        referencedTable: $$SuppliersTableReferences
                            ._supplierPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SuppliersTableReferences(db, table, p0)
                                .supplierPaymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.supplierId == item.id),
                        typedResults: items),
                  if (ledgerEntriesRefs)
                    await $_getPrefetchedData<Supplier, $SuppliersTable,
                            LedgerEntry>(
                        currentTable: table,
                        referencedTable: $$SuppliersTableReferences
                            ._ledgerEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SuppliersTableReferences(db, table, p0)
                                .ledgerEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.supplierId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SuppliersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function(
        {bool purchasesRefs,
        bool supplierPaymentsRefs,
        bool ledgerEntriesRefs})>;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<double> totalSales,
  Value<double> totalPayments,
  Value<double> outstanding,
  Value<double> advanceBalance,
  Value<bool> isActive,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<double> totalSales,
  Value<double> totalPayments,
  Value<double> outstanding,
  Value<double> advanceBalance,
  Value<bool> isActive,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sales,
          aliasName:
              $_aliasNameGenerator(db.customers.id, db.sales.customerId));

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager($_db, $_db.sales)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CustomerPaymentsTable, List<CustomerPayment>>
      _customerPaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.customerPayments,
              aliasName: $_aliasNameGenerator(
                  db.customers.id, db.customerPayments.customerId));

  $$CustomerPaymentsTableProcessedTableManager get customerPaymentsRefs {
    final manager =
        $$CustomerPaymentsTableTableManager($_db, $_db.customerPayments)
            .filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_customerPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LedgerEntriesTable, List<LedgerEntry>>
      _ledgerEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ledgerEntries,
              aliasName: $_aliasNameGenerator(
                  db.customers.id, db.ledgerEntries.customerId));

  $$LedgerEntriesTableProcessedTableManager get ledgerEntriesRefs {
    final manager = $$LedgerEntriesTableTableManager($_db, $_db.ledgerEntries)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ledgerEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalSales => $composableBuilder(
      column: $table.totalSales, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalPayments => $composableBuilder(
      column: $table.totalPayments, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get outstanding => $composableBuilder(
      column: $table.outstanding, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get advanceBalance => $composableBuilder(
      column: $table.advanceBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> salesRefs(
      Expression<bool> Function($$SalesTableFilterComposer f) f) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> customerPaymentsRefs(
      Expression<bool> Function($$CustomerPaymentsTableFilterComposer f) f) {
    final $$CustomerPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.customerPayments,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomerPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.customerPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> ledgerEntriesRefs(
      Expression<bool> Function($$LedgerEntriesTableFilterComposer f) f) {
    final $$LedgerEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ledgerEntries,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LedgerEntriesTableFilterComposer(
              $db: $db,
              $table: $db.ledgerEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalSales => $composableBuilder(
      column: $table.totalSales, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalPayments => $composableBuilder(
      column: $table.totalPayments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get outstanding => $composableBuilder(
      column: $table.outstanding, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get advanceBalance => $composableBuilder(
      column: $table.advanceBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get totalSales => $composableBuilder(
      column: $table.totalSales, builder: (column) => column);

  GeneratedColumn<double> get totalPayments => $composableBuilder(
      column: $table.totalPayments, builder: (column) => column);

  GeneratedColumn<double> get outstanding => $composableBuilder(
      column: $table.outstanding, builder: (column) => column);

  GeneratedColumn<double> get advanceBalance => $composableBuilder(
      column: $table.advanceBalance, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> salesRefs<T extends Object>(
      Expression<T> Function($$SalesTableAnnotationComposer a) f) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> customerPaymentsRefs<T extends Object>(
      Expression<T> Function($$CustomerPaymentsTableAnnotationComposer a) f) {
    final $$CustomerPaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.customerPayments,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomerPaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.customerPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> ledgerEntriesRefs<T extends Object>(
      Expression<T> Function($$LedgerEntriesTableAnnotationComposer a) f) {
    final $$LedgerEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ledgerEntries,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LedgerEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.ledgerEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function(
        {bool salesRefs, bool customerPaymentsRefs, bool ledgerEntriesRefs})> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<double> totalSales = const Value.absent(),
            Value<double> totalPayments = const Value.absent(),
            Value<double> outstanding = const Value.absent(),
            Value<double> advanceBalance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            totalSales: totalSales,
            totalPayments: totalPayments,
            outstanding: outstanding,
            advanceBalance: advanceBalance,
            isActive: isActive,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<double> totalSales = const Value.absent(),
            Value<double> totalPayments = const Value.absent(),
            Value<double> outstanding = const Value.absent(),
            Value<double> advanceBalance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            totalSales: totalSales,
            totalPayments: totalPayments,
            outstanding: outstanding,
            advanceBalance: advanceBalance,
            isActive: isActive,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CustomersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {salesRefs = false,
              customerPaymentsRefs = false,
              ledgerEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (salesRefs) db.sales,
                if (customerPaymentsRefs) db.customerPayments,
                if (ledgerEntriesRefs) db.ledgerEntries
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (salesRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable, Sale>(
                        currentTable: table,
                        referencedTable:
                            $$CustomersTableReferences._salesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0).salesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items),
                  if (customerPaymentsRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable,
                            CustomerPayment>(
                        currentTable: table,
                        referencedTable: $$CustomersTableReferences
                            ._customerPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0)
                                .customerPaymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items),
                  if (ledgerEntriesRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable,
                            LedgerEntry>(
                        currentTable: table,
                        referencedTable: $$CustomersTableReferences
                            ._ledgerEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0)
                                .ledgerEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function(
        {bool salesRefs, bool customerPaymentsRefs, bool ledgerEntriesRefs})>;
typedef $$PurchasesTableCreateCompanionBuilder = PurchasesCompanion Function({
  Value<int> id,
  required String referenceNumber,
  required int supplierId,
  required int walletAccountId,
  required double amount,
  Value<double> creditApplied,
  required double netAmount,
  Value<String?> notes,
  required DateTime date,
  Value<DateTime> createdAt,
});
typedef $$PurchasesTableUpdateCompanionBuilder = PurchasesCompanion Function({
  Value<int> id,
  Value<String> referenceNumber,
  Value<int> supplierId,
  Value<int> walletAccountId,
  Value<double> amount,
  Value<double> creditApplied,
  Value<double> netAmount,
  Value<String?> notes,
  Value<DateTime> date,
  Value<DateTime> createdAt,
});

final class $$PurchasesTableReferences
    extends BaseReferences<_$AppDatabase, $PurchasesTable, Purchase> {
  $$PurchasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias(
          $_aliasNameGenerator(db.purchases.supplierId, db.suppliers.id));

  $$SuppliersTableProcessedTableManager get supplierId {
    final $_column = $_itemColumn<int>('supplier_id')!;

    final manager = $$SuppliersTableTableManager($_db, $_db.suppliers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $WalletAccountsTable _walletAccountIdTable(_$AppDatabase db) =>
      db.walletAccounts.createAlias($_aliasNameGenerator(
          db.purchases.walletAccountId, db.walletAccounts.id));

  $$WalletAccountsTableProcessedTableManager get walletAccountId {
    final $_column = $_itemColumn<int>('wallet_account_id')!;

    final manager = $$WalletAccountsTableTableManager($_db, $_db.walletAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walletAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditApplied => $composableBuilder(
      column: $table.creditApplied, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get netAmount => $composableBuilder(
      column: $table.netAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableFilterComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletAccountsTableFilterComposer get walletAccountId {
    final $$WalletAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableFilterComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditApplied => $composableBuilder(
      column: $table.creditApplied,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get netAmount => $composableBuilder(
      column: $table.netAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableOrderingComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletAccountsTableOrderingComposer get walletAccountId {
    final $$WalletAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get creditApplied => $composableBuilder(
      column: $table.creditApplied, builder: (column) => column);

  GeneratedColumn<double> get netAmount =>
      $composableBuilder(column: $table.netAmount, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableAnnotationComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletAccountsTableAnnotationComposer get walletAccountId {
    final $$WalletAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchasesTable,
    Purchase,
    $$PurchasesTableFilterComposer,
    $$PurchasesTableOrderingComposer,
    $$PurchasesTableAnnotationComposer,
    $$PurchasesTableCreateCompanionBuilder,
    $$PurchasesTableUpdateCompanionBuilder,
    (Purchase, $$PurchasesTableReferences),
    Purchase,
    PrefetchHooks Function({bool supplierId, bool walletAccountId})> {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> referenceNumber = const Value.absent(),
            Value<int> supplierId = const Value.absent(),
            Value<int> walletAccountId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> creditApplied = const Value.absent(),
            Value<double> netAmount = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PurchasesCompanion(
            id: id,
            referenceNumber: referenceNumber,
            supplierId: supplierId,
            walletAccountId: walletAccountId,
            amount: amount,
            creditApplied: creditApplied,
            netAmount: netAmount,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String referenceNumber,
            required int supplierId,
            required int walletAccountId,
            required double amount,
            Value<double> creditApplied = const Value.absent(),
            required double netAmount,
            Value<String?> notes = const Value.absent(),
            required DateTime date,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PurchasesCompanion.insert(
            id: id,
            referenceNumber: referenceNumber,
            supplierId: supplierId,
            walletAccountId: walletAccountId,
            amount: amount,
            creditApplied: creditApplied,
            netAmount: netAmount,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PurchasesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {supplierId = false, walletAccountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (supplierId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supplierId,
                    referencedTable:
                        $$PurchasesTableReferences._supplierIdTable(db),
                    referencedColumn:
                        $$PurchasesTableReferences._supplierIdTable(db).id,
                  ) as T;
                }
                if (walletAccountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.walletAccountId,
                    referencedTable:
                        $$PurchasesTableReferences._walletAccountIdTable(db),
                    referencedColumn:
                        $$PurchasesTableReferences._walletAccountIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PurchasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchasesTable,
    Purchase,
    $$PurchasesTableFilterComposer,
    $$PurchasesTableOrderingComposer,
    $$PurchasesTableAnnotationComposer,
    $$PurchasesTableCreateCompanionBuilder,
    $$PurchasesTableUpdateCompanionBuilder,
    (Purchase, $$PurchasesTableReferences),
    Purchase,
    PrefetchHooks Function({bool supplierId, bool walletAccountId})>;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  required String referenceNumber,
  required int customerId,
  required double amount,
  Value<double> advanceApplied,
  required double netAmount,
  Value<String?> notes,
  required DateTime date,
  Value<DateTime> createdAt,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  Value<String> referenceNumber,
  Value<int> customerId,
  Value<double> amount,
  Value<double> advanceApplied,
  Value<double> netAmount,
  Value<String?> notes,
  Value<DateTime> date,
  Value<DateTime> createdAt,
});

final class $$SalesTableReferences
    extends BaseReferences<_$AppDatabase, $SalesTable, Sale> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) => db.customers
      .createAlias($_aliasNameGenerator(db.sales.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get advanceApplied => $composableBuilder(
      column: $table.advanceApplied,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get netAmount => $composableBuilder(
      column: $table.netAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get advanceApplied => $composableBuilder(
      column: $table.advanceApplied,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get netAmount => $composableBuilder(
      column: $table.netAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get advanceApplied => $composableBuilder(
      column: $table.advanceApplied, builder: (column) => column);

  GeneratedColumn<double> get netAmount =>
      $composableBuilder(column: $table.netAmount, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, $$SalesTableReferences),
    Sale,
    PrefetchHooks Function({bool customerId})> {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> referenceNumber = const Value.absent(),
            Value<int> customerId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> advanceApplied = const Value.absent(),
            Value<double> netAmount = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            referenceNumber: referenceNumber,
            customerId: customerId,
            amount: amount,
            advanceApplied: advanceApplied,
            netAmount: netAmount,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String referenceNumber,
            required int customerId,
            required double amount,
            Value<double> advanceApplied = const Value.absent(),
            required double netAmount,
            Value<String?> notes = const Value.absent(),
            required DateTime date,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            referenceNumber: referenceNumber,
            customerId: customerId,
            amount: amount,
            advanceApplied: advanceApplied,
            netAmount: netAmount,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SalesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({customerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$SalesTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$SalesTableReferences._customerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SalesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, $$SalesTableReferences),
    Sale,
    PrefetchHooks Function({bool customerId})>;
typedef $$SupplierPaymentsTableCreateCompanionBuilder
    = SupplierPaymentsCompanion Function({
  Value<int> id,
  required String referenceNumber,
  required int supplierId,
  required int walletAccountId,
  required double amount,
  Value<double> outstandingSettled,
  Value<double> creditGenerated,
  Value<String?> notes,
  required DateTime date,
  Value<DateTime> createdAt,
});
typedef $$SupplierPaymentsTableUpdateCompanionBuilder
    = SupplierPaymentsCompanion Function({
  Value<int> id,
  Value<String> referenceNumber,
  Value<int> supplierId,
  Value<int> walletAccountId,
  Value<double> amount,
  Value<double> outstandingSettled,
  Value<double> creditGenerated,
  Value<String?> notes,
  Value<DateTime> date,
  Value<DateTime> createdAt,
});

final class $$SupplierPaymentsTableReferences extends BaseReferences<
    _$AppDatabase, $SupplierPaymentsTable, SupplierPayment> {
  $$SupplierPaymentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias($_aliasNameGenerator(
          db.supplierPayments.supplierId, db.suppliers.id));

  $$SuppliersTableProcessedTableManager get supplierId {
    final $_column = $_itemColumn<int>('supplier_id')!;

    final manager = $$SuppliersTableTableManager($_db, $_db.suppliers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $WalletAccountsTable _walletAccountIdTable(_$AppDatabase db) =>
      db.walletAccounts.createAlias($_aliasNameGenerator(
          db.supplierPayments.walletAccountId, db.walletAccounts.id));

  $$WalletAccountsTableProcessedTableManager get walletAccountId {
    final $_column = $_itemColumn<int>('wallet_account_id')!;

    final manager = $$WalletAccountsTableTableManager($_db, $_db.walletAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walletAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SupplierPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplierPaymentsTable> {
  $$SupplierPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get outstandingSettled => $composableBuilder(
      column: $table.outstandingSettled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditGenerated => $composableBuilder(
      column: $table.creditGenerated,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableFilterComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletAccountsTableFilterComposer get walletAccountId {
    final $$WalletAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableFilterComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SupplierPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplierPaymentsTable> {
  $$SupplierPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get outstandingSettled => $composableBuilder(
      column: $table.outstandingSettled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditGenerated => $composableBuilder(
      column: $table.creditGenerated,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableOrderingComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletAccountsTableOrderingComposer get walletAccountId {
    final $$WalletAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SupplierPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplierPaymentsTable> {
  $$SupplierPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get outstandingSettled => $composableBuilder(
      column: $table.outstandingSettled, builder: (column) => column);

  GeneratedColumn<double> get creditGenerated => $composableBuilder(
      column: $table.creditGenerated, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableAnnotationComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletAccountsTableAnnotationComposer get walletAccountId {
    final $$WalletAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SupplierPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SupplierPaymentsTable,
    SupplierPayment,
    $$SupplierPaymentsTableFilterComposer,
    $$SupplierPaymentsTableOrderingComposer,
    $$SupplierPaymentsTableAnnotationComposer,
    $$SupplierPaymentsTableCreateCompanionBuilder,
    $$SupplierPaymentsTableUpdateCompanionBuilder,
    (SupplierPayment, $$SupplierPaymentsTableReferences),
    SupplierPayment,
    PrefetchHooks Function({bool supplierId, bool walletAccountId})> {
  $$SupplierPaymentsTableTableManager(
      _$AppDatabase db, $SupplierPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplierPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplierPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplierPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> referenceNumber = const Value.absent(),
            Value<int> supplierId = const Value.absent(),
            Value<int> walletAccountId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> outstandingSettled = const Value.absent(),
            Value<double> creditGenerated = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SupplierPaymentsCompanion(
            id: id,
            referenceNumber: referenceNumber,
            supplierId: supplierId,
            walletAccountId: walletAccountId,
            amount: amount,
            outstandingSettled: outstandingSettled,
            creditGenerated: creditGenerated,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String referenceNumber,
            required int supplierId,
            required int walletAccountId,
            required double amount,
            Value<double> outstandingSettled = const Value.absent(),
            Value<double> creditGenerated = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime date,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SupplierPaymentsCompanion.insert(
            id: id,
            referenceNumber: referenceNumber,
            supplierId: supplierId,
            walletAccountId: walletAccountId,
            amount: amount,
            outstandingSettled: outstandingSettled,
            creditGenerated: creditGenerated,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SupplierPaymentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {supplierId = false, walletAccountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (supplierId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supplierId,
                    referencedTable:
                        $$SupplierPaymentsTableReferences._supplierIdTable(db),
                    referencedColumn: $$SupplierPaymentsTableReferences
                        ._supplierIdTable(db)
                        .id,
                  ) as T;
                }
                if (walletAccountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.walletAccountId,
                    referencedTable: $$SupplierPaymentsTableReferences
                        ._walletAccountIdTable(db),
                    referencedColumn: $$SupplierPaymentsTableReferences
                        ._walletAccountIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SupplierPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SupplierPaymentsTable,
    SupplierPayment,
    $$SupplierPaymentsTableFilterComposer,
    $$SupplierPaymentsTableOrderingComposer,
    $$SupplierPaymentsTableAnnotationComposer,
    $$SupplierPaymentsTableCreateCompanionBuilder,
    $$SupplierPaymentsTableUpdateCompanionBuilder,
    (SupplierPayment, $$SupplierPaymentsTableReferences),
    SupplierPayment,
    PrefetchHooks Function({bool supplierId, bool walletAccountId})>;
typedef $$CustomerPaymentsTableCreateCompanionBuilder
    = CustomerPaymentsCompanion Function({
  Value<int> id,
  required String referenceNumber,
  required int customerId,
  required int walletAccountId,
  required double amount,
  Value<double> outstandingSettled,
  Value<double> advanceGenerated,
  Value<String?> notes,
  required DateTime date,
  Value<DateTime> createdAt,
});
typedef $$CustomerPaymentsTableUpdateCompanionBuilder
    = CustomerPaymentsCompanion Function({
  Value<int> id,
  Value<String> referenceNumber,
  Value<int> customerId,
  Value<int> walletAccountId,
  Value<double> amount,
  Value<double> outstandingSettled,
  Value<double> advanceGenerated,
  Value<String?> notes,
  Value<DateTime> date,
  Value<DateTime> createdAt,
});

final class $$CustomerPaymentsTableReferences extends BaseReferences<
    _$AppDatabase, $CustomerPaymentsTable, CustomerPayment> {
  $$CustomerPaymentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias($_aliasNameGenerator(
          db.customerPayments.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $WalletAccountsTable _walletAccountIdTable(_$AppDatabase db) =>
      db.walletAccounts.createAlias($_aliasNameGenerator(
          db.customerPayments.walletAccountId, db.walletAccounts.id));

  $$WalletAccountsTableProcessedTableManager get walletAccountId {
    final $_column = $_itemColumn<int>('wallet_account_id')!;

    final manager = $$WalletAccountsTableTableManager($_db, $_db.walletAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walletAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CustomerPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomerPaymentsTable> {
  $$CustomerPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get outstandingSettled => $composableBuilder(
      column: $table.outstandingSettled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get advanceGenerated => $composableBuilder(
      column: $table.advanceGenerated,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletAccountsTableFilterComposer get walletAccountId {
    final $$WalletAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableFilterComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CustomerPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomerPaymentsTable> {
  $$CustomerPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get outstandingSettled => $composableBuilder(
      column: $table.outstandingSettled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get advanceGenerated => $composableBuilder(
      column: $table.advanceGenerated,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletAccountsTableOrderingComposer get walletAccountId {
    final $$WalletAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CustomerPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomerPaymentsTable> {
  $$CustomerPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get outstandingSettled => $composableBuilder(
      column: $table.outstandingSettled, builder: (column) => column);

  GeneratedColumn<double> get advanceGenerated => $composableBuilder(
      column: $table.advanceGenerated, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletAccountsTableAnnotationComposer get walletAccountId {
    final $$WalletAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CustomerPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomerPaymentsTable,
    CustomerPayment,
    $$CustomerPaymentsTableFilterComposer,
    $$CustomerPaymentsTableOrderingComposer,
    $$CustomerPaymentsTableAnnotationComposer,
    $$CustomerPaymentsTableCreateCompanionBuilder,
    $$CustomerPaymentsTableUpdateCompanionBuilder,
    (CustomerPayment, $$CustomerPaymentsTableReferences),
    CustomerPayment,
    PrefetchHooks Function({bool customerId, bool walletAccountId})> {
  $$CustomerPaymentsTableTableManager(
      _$AppDatabase db, $CustomerPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomerPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomerPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomerPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> referenceNumber = const Value.absent(),
            Value<int> customerId = const Value.absent(),
            Value<int> walletAccountId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> outstandingSettled = const Value.absent(),
            Value<double> advanceGenerated = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomerPaymentsCompanion(
            id: id,
            referenceNumber: referenceNumber,
            customerId: customerId,
            walletAccountId: walletAccountId,
            amount: amount,
            outstandingSettled: outstandingSettled,
            advanceGenerated: advanceGenerated,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String referenceNumber,
            required int customerId,
            required int walletAccountId,
            required double amount,
            Value<double> outstandingSettled = const Value.absent(),
            Value<double> advanceGenerated = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime date,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomerPaymentsCompanion.insert(
            id: id,
            referenceNumber: referenceNumber,
            customerId: customerId,
            walletAccountId: walletAccountId,
            amount: amount,
            outstandingSettled: outstandingSettled,
            advanceGenerated: advanceGenerated,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CustomerPaymentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {customerId = false, walletAccountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$CustomerPaymentsTableReferences._customerIdTable(db),
                    referencedColumn: $$CustomerPaymentsTableReferences
                        ._customerIdTable(db)
                        .id,
                  ) as T;
                }
                if (walletAccountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.walletAccountId,
                    referencedTable: $$CustomerPaymentsTableReferences
                        ._walletAccountIdTable(db),
                    referencedColumn: $$CustomerPaymentsTableReferences
                        ._walletAccountIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CustomerPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomerPaymentsTable,
    CustomerPayment,
    $$CustomerPaymentsTableFilterComposer,
    $$CustomerPaymentsTableOrderingComposer,
    $$CustomerPaymentsTableAnnotationComposer,
    $$CustomerPaymentsTableCreateCompanionBuilder,
    $$CustomerPaymentsTableUpdateCompanionBuilder,
    (CustomerPayment, $$CustomerPaymentsTableReferences),
    CustomerPayment,
    PrefetchHooks Function({bool customerId, bool walletAccountId})>;
typedef $$LedgerEntriesTableCreateCompanionBuilder = LedgerEntriesCompanion
    Function({
  Value<int> id,
  required String referenceNumber,
  required String transactionType,
  Value<int?> walletAccountId,
  Value<int?> supplierId,
  Value<int?> customerId,
  Value<int?> relatedTransactionId,
  Value<double> debit,
  Value<double> credit,
  Value<double> walletBalance,
  required String description,
  required DateTime date,
  Value<DateTime> createdAt,
});
typedef $$LedgerEntriesTableUpdateCompanionBuilder = LedgerEntriesCompanion
    Function({
  Value<int> id,
  Value<String> referenceNumber,
  Value<String> transactionType,
  Value<int?> walletAccountId,
  Value<int?> supplierId,
  Value<int?> customerId,
  Value<int?> relatedTransactionId,
  Value<double> debit,
  Value<double> credit,
  Value<double> walletBalance,
  Value<String> description,
  Value<DateTime> date,
  Value<DateTime> createdAt,
});

final class $$LedgerEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $LedgerEntriesTable, LedgerEntry> {
  $$LedgerEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WalletAccountsTable _walletAccountIdTable(_$AppDatabase db) =>
      db.walletAccounts.createAlias($_aliasNameGenerator(
          db.ledgerEntries.walletAccountId, db.walletAccounts.id));

  $$WalletAccountsTableProcessedTableManager? get walletAccountId {
    final $_column = $_itemColumn<int>('wallet_account_id');
    if ($_column == null) return null;
    final manager = $$WalletAccountsTableTableManager($_db, $_db.walletAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walletAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias(
          $_aliasNameGenerator(db.ledgerEntries.supplierId, db.suppliers.id));

  $$SuppliersTableProcessedTableManager? get supplierId {
    final $_column = $_itemColumn<int>('supplier_id');
    if ($_column == null) return null;
    final manager = $$SuppliersTableTableManager($_db, $_db.suppliers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias(
          $_aliasNameGenerator(db.ledgerEntries.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LedgerEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionType => $composableBuilder(
      column: $table.transactionType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get relatedTransactionId => $composableBuilder(
      column: $table.relatedTransactionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get credit => $composableBuilder(
      column: $table.credit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get walletBalance => $composableBuilder(
      column: $table.walletBalance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$WalletAccountsTableFilterComposer get walletAccountId {
    final $$WalletAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableFilterComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableFilterComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LedgerEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionType => $composableBuilder(
      column: $table.transactionType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get relatedTransactionId => $composableBuilder(
      column: $table.relatedTransactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get credit => $composableBuilder(
      column: $table.credit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get walletBalance => $composableBuilder(
      column: $table.walletBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$WalletAccountsTableOrderingComposer get walletAccountId {
    final $$WalletAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableOrderingComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LedgerEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber, builder: (column) => column);

  GeneratedColumn<String> get transactionType => $composableBuilder(
      column: $table.transactionType, builder: (column) => column);

  GeneratedColumn<int> get relatedTransactionId => $composableBuilder(
      column: $table.relatedTransactionId, builder: (column) => column);

  GeneratedColumn<double> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<double> get credit =>
      $composableBuilder(column: $table.credit, builder: (column) => column);

  GeneratedColumn<double> get walletBalance => $composableBuilder(
      column: $table.walletBalance, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WalletAccountsTableAnnotationComposer get walletAccountId {
    final $$WalletAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableAnnotationComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LedgerEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LedgerEntriesTable,
    LedgerEntry,
    $$LedgerEntriesTableFilterComposer,
    $$LedgerEntriesTableOrderingComposer,
    $$LedgerEntriesTableAnnotationComposer,
    $$LedgerEntriesTableCreateCompanionBuilder,
    $$LedgerEntriesTableUpdateCompanionBuilder,
    (LedgerEntry, $$LedgerEntriesTableReferences),
    LedgerEntry,
    PrefetchHooks Function(
        {bool walletAccountId, bool supplierId, bool customerId})> {
  $$LedgerEntriesTableTableManager(_$AppDatabase db, $LedgerEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> referenceNumber = const Value.absent(),
            Value<String> transactionType = const Value.absent(),
            Value<int?> walletAccountId = const Value.absent(),
            Value<int?> supplierId = const Value.absent(),
            Value<int?> customerId = const Value.absent(),
            Value<int?> relatedTransactionId = const Value.absent(),
            Value<double> debit = const Value.absent(),
            Value<double> credit = const Value.absent(),
            Value<double> walletBalance = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              LedgerEntriesCompanion(
            id: id,
            referenceNumber: referenceNumber,
            transactionType: transactionType,
            walletAccountId: walletAccountId,
            supplierId: supplierId,
            customerId: customerId,
            relatedTransactionId: relatedTransactionId,
            debit: debit,
            credit: credit,
            walletBalance: walletBalance,
            description: description,
            date: date,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String referenceNumber,
            required String transactionType,
            Value<int?> walletAccountId = const Value.absent(),
            Value<int?> supplierId = const Value.absent(),
            Value<int?> customerId = const Value.absent(),
            Value<int?> relatedTransactionId = const Value.absent(),
            Value<double> debit = const Value.absent(),
            Value<double> credit = const Value.absent(),
            Value<double> walletBalance = const Value.absent(),
            required String description,
            required DateTime date,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              LedgerEntriesCompanion.insert(
            id: id,
            referenceNumber: referenceNumber,
            transactionType: transactionType,
            walletAccountId: walletAccountId,
            supplierId: supplierId,
            customerId: customerId,
            relatedTransactionId: relatedTransactionId,
            debit: debit,
            credit: credit,
            walletBalance: walletBalance,
            description: description,
            date: date,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LedgerEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {walletAccountId = false,
              supplierId = false,
              customerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (walletAccountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.walletAccountId,
                    referencedTable: $$LedgerEntriesTableReferences
                        ._walletAccountIdTable(db),
                    referencedColumn: $$LedgerEntriesTableReferences
                        ._walletAccountIdTable(db)
                        .id,
                  ) as T;
                }
                if (supplierId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supplierId,
                    referencedTable:
                        $$LedgerEntriesTableReferences._supplierIdTable(db),
                    referencedColumn:
                        $$LedgerEntriesTableReferences._supplierIdTable(db).id,
                  ) as T;
                }
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$LedgerEntriesTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$LedgerEntriesTableReferences._customerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LedgerEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LedgerEntriesTable,
    LedgerEntry,
    $$LedgerEntriesTableFilterComposer,
    $$LedgerEntriesTableOrderingComposer,
    $$LedgerEntriesTableAnnotationComposer,
    $$LedgerEntriesTableCreateCompanionBuilder,
    $$LedgerEntriesTableUpdateCompanionBuilder,
    (LedgerEntry, $$LedgerEntriesTableReferences),
    LedgerEntry,
    PrefetchHooks Function(
        {bool walletAccountId, bool supplierId, bool customerId})>;
typedef $$ExpenseCategoriesTableCreateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<int> iconCodepoint,
  Value<String> colorHex,
  Value<double?> monthlyBudget,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$ExpenseCategoriesTableUpdateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> iconCodepoint,
  Value<String> colorHex,
  Value<double?> monthlyBudget,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$ExpenseCategoriesTableReferences extends BaseReferences<
    _$AppDatabase, $ExpenseCategoriesTable, ExpenseCategory> {
  $$ExpenseCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenses,
          aliasName: $_aliasNameGenerator(
              db.expenseCategories.id, db.expenses.categoryId));

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager($_db, $_db.expenses)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExpenseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get iconCodepoint => $composableBuilder(
      column: $table.iconCodepoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monthlyBudget => $composableBuilder(
      column: $table.monthlyBudget, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> expensesRefs(
      Expression<bool> Function($$ExpensesTableFilterComposer f) f) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableFilterComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExpenseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get iconCodepoint => $composableBuilder(
      column: $table.iconCodepoint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monthlyBudget => $composableBuilder(
      column: $table.monthlyBudget,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ExpenseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get iconCodepoint => $composableBuilder(
      column: $table.iconCodepoint, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<double> get monthlyBudget => $composableBuilder(
      column: $table.monthlyBudget, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> expensesRefs<T extends Object>(
      Expression<T> Function($$ExpensesTableAnnotationComposer a) f) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExpenseCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (ExpenseCategory, $$ExpenseCategoriesTableReferences),
    ExpenseCategory,
    PrefetchHooks Function({bool expensesRefs})> {
  $$ExpenseCategoriesTableTableManager(
      _$AppDatabase db, $ExpenseCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> iconCodepoint = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<double?> monthlyBudget = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion(
            id: id,
            name: name,
            iconCodepoint: iconCodepoint,
            colorHex: colorHex,
            monthlyBudget: monthlyBudget,
            isActive: isActive,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> iconCodepoint = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<double?> monthlyBudget = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion.insert(
            id: id,
            name: name,
            iconCodepoint: iconCodepoint,
            colorHex: colorHex,
            monthlyBudget: monthlyBudget,
            isActive: isActive,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExpenseCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<ExpenseCategory, $ExpenseCategoriesTable,
                            Expense>(
                        currentTable: table,
                        referencedTable: $$ExpenseCategoriesTableReferences
                            ._expensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseCategoriesTableReferences(db, table, p0)
                                .expensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExpenseCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (ExpenseCategory, $$ExpenseCategoriesTableReferences),
    ExpenseCategory,
    PrefetchHooks Function({bool expensesRefs})>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required String referenceNumber,
  required int categoryId,
  Value<int?> walletAccountId,
  required double amount,
  required String description,
  Value<String?> notes,
  required DateTime date,
  Value<DateTime> createdAt,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<String> referenceNumber,
  Value<int> categoryId,
  Value<int?> walletAccountId,
  Value<double> amount,
  Value<String> description,
  Value<String?> notes,
  Value<DateTime> date,
  Value<DateTime> createdAt,
});

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExpenseCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.expenseCategories.createAlias($_aliasNameGenerator(
          db.expenses.categoryId, db.expenseCategories.id));

  $$ExpenseCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager =
        $$ExpenseCategoriesTableTableManager($_db, $_db.expenseCategories)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $WalletAccountsTable _walletAccountIdTable(_$AppDatabase db) =>
      db.walletAccounts.createAlias($_aliasNameGenerator(
          db.expenses.walletAccountId, db.walletAccounts.id));

  $$WalletAccountsTableProcessedTableManager? get walletAccountId {
    final $_column = $_itemColumn<int>('wallet_account_id');
    if ($_column == null) return null;
    final manager = $$WalletAccountsTableTableManager($_db, $_db.walletAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walletAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ExpenseCategoriesTableFilterComposer get categoryId {
    final $$ExpenseCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.expenseCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.expenseCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletAccountsTableFilterComposer get walletAccountId {
    final $$WalletAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableFilterComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ExpenseCategoriesTableOrderingComposer get categoryId {
    final $$ExpenseCategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.expenseCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseCategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.expenseCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletAccountsTableOrderingComposer get walletAccountId {
    final $$WalletAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ExpenseCategoriesTableAnnotationComposer get categoryId {
    final $$ExpenseCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $db.expenseCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExpenseCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.expenseCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$WalletAccountsTableAnnotationComposer get walletAccountId {
    final $$WalletAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletAccountId,
        referencedTable: $db.walletAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.walletAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, $$ExpensesTableReferences),
    Expense,
    PrefetchHooks Function({bool categoryId, bool walletAccountId})> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> referenceNumber = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<int?> walletAccountId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            referenceNumber: referenceNumber,
            categoryId: categoryId,
            walletAccountId: walletAccountId,
            amount: amount,
            description: description,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String referenceNumber,
            required int categoryId,
            Value<int?> walletAccountId = const Value.absent(),
            required double amount,
            required String description,
            Value<String?> notes = const Value.absent(),
            required DateTime date,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            referenceNumber: referenceNumber,
            categoryId: categoryId,
            walletAccountId: walletAccountId,
            amount: amount,
            description: description,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ExpensesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false, walletAccountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$ExpensesTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$ExpensesTableReferences._categoryIdTable(db).id,
                  ) as T;
                }
                if (walletAccountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.walletAccountId,
                    referencedTable:
                        $$ExpensesTableReferences._walletAccountIdTable(db),
                    referencedColumn:
                        $$ExpensesTableReferences._walletAccountIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, $$ExpensesTableReferences),
    Expense,
    PrefetchHooks Function({bool categoryId, bool walletAccountId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WalletAccountsTableTableManager get walletAccounts =>
      $$WalletAccountsTableTableManager(_db, _db.walletAccounts);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SupplierPaymentsTableTableManager get supplierPayments =>
      $$SupplierPaymentsTableTableManager(_db, _db.supplierPayments);
  $$CustomerPaymentsTableTableManager get customerPayments =>
      $$CustomerPaymentsTableTableManager(_db, _db.customerPayments);
  $$LedgerEntriesTableTableManager get ledgerEntries =>
      $$LedgerEntriesTableTableManager(_db, _db.ledgerEntries);
  $$ExpenseCategoriesTableTableManager get expenseCategories =>
      $$ExpenseCategoriesTableTableManager(_db, _db.expenseCategories);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
}
