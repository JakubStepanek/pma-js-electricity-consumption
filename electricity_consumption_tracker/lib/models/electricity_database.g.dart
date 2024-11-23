// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electricity_database.dart';

// ignore_for_file: type=lint
class $ElectricityConsumptionsTable extends ElectricityConsumptions
    with TableInfo<$ElectricityConsumptionsTable, ElectricityConsumptionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ElectricityConsumptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _consumptionTarifLowMeta =
      const VerificationMeta('consumptionTarifLow');
  @override
  late final GeneratedColumn<double> consumptionTarifLow =
      GeneratedColumn<double>('consumption_tarif_low', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _consumptionTarifHighMeta =
      const VerificationMeta('consumptionTarifHigh');
  @override
  late final GeneratedColumn<double> consumptionTarifHigh =
      GeneratedColumn<double>('consumption_tarif_high', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _consumptionTarifOutMeta =
      const VerificationMeta('consumptionTarifOut');
  @override
  late final GeneratedColumn<double> consumptionTarifOut =
      GeneratedColumn<double>('consumption_tarif_out', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        consumptionTarifLow,
        consumptionTarifHigh,
        consumptionTarifOut
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'electricity_consumptions';
  @override
  VerificationContext validateIntegrity(
      Insertable<ElectricityConsumptionEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('consumption_tarif_low')) {
      context.handle(
          _consumptionTarifLowMeta,
          consumptionTarifLow.isAcceptableOrUnknown(
              data['consumption_tarif_low']!, _consumptionTarifLowMeta));
    } else if (isInserting) {
      context.missing(_consumptionTarifLowMeta);
    }
    if (data.containsKey('consumption_tarif_high')) {
      context.handle(
          _consumptionTarifHighMeta,
          consumptionTarifHigh.isAcceptableOrUnknown(
              data['consumption_tarif_high']!, _consumptionTarifHighMeta));
    } else if (isInserting) {
      context.missing(_consumptionTarifHighMeta);
    }
    if (data.containsKey('consumption_tarif_out')) {
      context.handle(
          _consumptionTarifOutMeta,
          consumptionTarifOut.isAcceptableOrUnknown(
              data['consumption_tarif_out']!, _consumptionTarifOutMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ElectricityConsumptionEntry map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ElectricityConsumptionEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      consumptionTarifLow: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}consumption_tarif_low'])!,
      consumptionTarifHigh: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}consumption_tarif_high'])!,
      consumptionTarifOut: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}consumption_tarif_out']),
    );
  }

  @override
  $ElectricityConsumptionsTable createAlias(String alias) {
    return $ElectricityConsumptionsTable(attachedDatabase, alias);
  }
}

class ElectricityConsumptionEntry extends DataClass
    implements Insertable<ElectricityConsumptionEntry> {
  final int id;
  final DateTime date;
  final double consumptionTarifLow;
  final double consumptionTarifHigh;
  final double? consumptionTarifOut;
  const ElectricityConsumptionEntry(
      {required this.id,
      required this.date,
      required this.consumptionTarifLow,
      required this.consumptionTarifHigh,
      this.consumptionTarifOut});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['consumption_tarif_low'] = Variable<double>(consumptionTarifLow);
    map['consumption_tarif_high'] = Variable<double>(consumptionTarifHigh);
    if (!nullToAbsent || consumptionTarifOut != null) {
      map['consumption_tarif_out'] = Variable<double>(consumptionTarifOut);
    }
    return map;
  }

  ElectricityConsumptionsCompanion toCompanion(bool nullToAbsent) {
    return ElectricityConsumptionsCompanion(
      id: Value(id),
      date: Value(date),
      consumptionTarifLow: Value(consumptionTarifLow),
      consumptionTarifHigh: Value(consumptionTarifHigh),
      consumptionTarifOut: consumptionTarifOut == null && nullToAbsent
          ? const Value.absent()
          : Value(consumptionTarifOut),
    );
  }

  factory ElectricityConsumptionEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ElectricityConsumptionEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      consumptionTarifLow:
          serializer.fromJson<double>(json['consumptionTarifLow']),
      consumptionTarifHigh:
          serializer.fromJson<double>(json['consumptionTarifHigh']),
      consumptionTarifOut:
          serializer.fromJson<double?>(json['consumptionTarifOut']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'consumptionTarifLow': serializer.toJson<double>(consumptionTarifLow),
      'consumptionTarifHigh': serializer.toJson<double>(consumptionTarifHigh),
      'consumptionTarifOut': serializer.toJson<double?>(consumptionTarifOut),
    };
  }

  ElectricityConsumptionEntry copyWith(
          {int? id,
          DateTime? date,
          double? consumptionTarifLow,
          double? consumptionTarifHigh,
          Value<double?> consumptionTarifOut = const Value.absent()}) =>
      ElectricityConsumptionEntry(
        id: id ?? this.id,
        date: date ?? this.date,
        consumptionTarifLow: consumptionTarifLow ?? this.consumptionTarifLow,
        consumptionTarifHigh: consumptionTarifHigh ?? this.consumptionTarifHigh,
        consumptionTarifOut: consumptionTarifOut.present
            ? consumptionTarifOut.value
            : this.consumptionTarifOut,
      );
  ElectricityConsumptionEntry copyWithCompanion(
      ElectricityConsumptionsCompanion data) {
    return ElectricityConsumptionEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      consumptionTarifLow: data.consumptionTarifLow.present
          ? data.consumptionTarifLow.value
          : this.consumptionTarifLow,
      consumptionTarifHigh: data.consumptionTarifHigh.present
          ? data.consumptionTarifHigh.value
          : this.consumptionTarifHigh,
      consumptionTarifOut: data.consumptionTarifOut.present
          ? data.consumptionTarifOut.value
          : this.consumptionTarifOut,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ElectricityConsumptionEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('consumptionTarifLow: $consumptionTarifLow, ')
          ..write('consumptionTarifHigh: $consumptionTarifHigh, ')
          ..write('consumptionTarifOut: $consumptionTarifOut')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, date, consumptionTarifLow, consumptionTarifHigh, consumptionTarifOut);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ElectricityConsumptionEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.consumptionTarifLow == this.consumptionTarifLow &&
          other.consumptionTarifHigh == this.consumptionTarifHigh &&
          other.consumptionTarifOut == this.consumptionTarifOut);
}

class ElectricityConsumptionsCompanion
    extends UpdateCompanion<ElectricityConsumptionEntry> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double> consumptionTarifLow;
  final Value<double> consumptionTarifHigh;
  final Value<double?> consumptionTarifOut;
  const ElectricityConsumptionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.consumptionTarifLow = const Value.absent(),
    this.consumptionTarifHigh = const Value.absent(),
    this.consumptionTarifOut = const Value.absent(),
  });
  ElectricityConsumptionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required double consumptionTarifLow,
    required double consumptionTarifHigh,
    this.consumptionTarifOut = const Value.absent(),
  })  : date = Value(date),
        consumptionTarifLow = Value(consumptionTarifLow),
        consumptionTarifHigh = Value(consumptionTarifHigh);
  static Insertable<ElectricityConsumptionEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? consumptionTarifLow,
    Expression<double>? consumptionTarifHigh,
    Expression<double>? consumptionTarifOut,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (consumptionTarifLow != null)
        'consumption_tarif_low': consumptionTarifLow,
      if (consumptionTarifHigh != null)
        'consumption_tarif_high': consumptionTarifHigh,
      if (consumptionTarifOut != null)
        'consumption_tarif_out': consumptionTarifOut,
    });
  }

  ElectricityConsumptionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<double>? consumptionTarifLow,
      Value<double>? consumptionTarifHigh,
      Value<double?>? consumptionTarifOut}) {
    return ElectricityConsumptionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      consumptionTarifLow: consumptionTarifLow ?? this.consumptionTarifLow,
      consumptionTarifHigh: consumptionTarifHigh ?? this.consumptionTarifHigh,
      consumptionTarifOut: consumptionTarifOut ?? this.consumptionTarifOut,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (consumptionTarifLow.present) {
      map['consumption_tarif_low'] =
          Variable<double>(consumptionTarifLow.value);
    }
    if (consumptionTarifHigh.present) {
      map['consumption_tarif_high'] =
          Variable<double>(consumptionTarifHigh.value);
    }
    if (consumptionTarifOut.present) {
      map['consumption_tarif_out'] =
          Variable<double>(consumptionTarifOut.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ElectricityConsumptionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('consumptionTarifLow: $consumptionTarifLow, ')
          ..write('consumptionTarifHigh: $consumptionTarifHigh, ')
          ..write('consumptionTarifOut: $consumptionTarifOut')
          ..write(')'))
        .toString();
  }
}

abstract class _$ElectricityDatabase extends GeneratedDatabase {
  _$ElectricityDatabase(QueryExecutor e) : super(e);
  $ElectricityDatabaseManager get managers => $ElectricityDatabaseManager(this);
  late final $ElectricityConsumptionsTable electricityConsumptions =
      $ElectricityConsumptionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [electricityConsumptions];
}

typedef $$ElectricityConsumptionsTableCreateCompanionBuilder
    = ElectricityConsumptionsCompanion Function({
  Value<int> id,
  required DateTime date,
  required double consumptionTarifLow,
  required double consumptionTarifHigh,
  Value<double?> consumptionTarifOut,
});
typedef $$ElectricityConsumptionsTableUpdateCompanionBuilder
    = ElectricityConsumptionsCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<double> consumptionTarifLow,
  Value<double> consumptionTarifHigh,
  Value<double?> consumptionTarifOut,
});

class $$ElectricityConsumptionsTableFilterComposer
    extends Composer<_$ElectricityDatabase, $ElectricityConsumptionsTable> {
  $$ElectricityConsumptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get consumptionTarifLow => $composableBuilder(
      column: $table.consumptionTarifLow,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get consumptionTarifHigh => $composableBuilder(
      column: $table.consumptionTarifHigh,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get consumptionTarifOut => $composableBuilder(
      column: $table.consumptionTarifOut,
      builder: (column) => ColumnFilters(column));
}

class $$ElectricityConsumptionsTableOrderingComposer
    extends Composer<_$ElectricityDatabase, $ElectricityConsumptionsTable> {
  $$ElectricityConsumptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get consumptionTarifLow => $composableBuilder(
      column: $table.consumptionTarifLow,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get consumptionTarifHigh => $composableBuilder(
      column: $table.consumptionTarifHigh,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get consumptionTarifOut => $composableBuilder(
      column: $table.consumptionTarifOut,
      builder: (column) => ColumnOrderings(column));
}

class $$ElectricityConsumptionsTableAnnotationComposer
    extends Composer<_$ElectricityDatabase, $ElectricityConsumptionsTable> {
  $$ElectricityConsumptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get consumptionTarifLow => $composableBuilder(
      column: $table.consumptionTarifLow, builder: (column) => column);

  GeneratedColumn<double> get consumptionTarifHigh => $composableBuilder(
      column: $table.consumptionTarifHigh, builder: (column) => column);

  GeneratedColumn<double> get consumptionTarifOut => $composableBuilder(
      column: $table.consumptionTarifOut, builder: (column) => column);
}

class $$ElectricityConsumptionsTableTableManager extends RootTableManager<
    _$ElectricityDatabase,
    $ElectricityConsumptionsTable,
    ElectricityConsumptionEntry,
    $$ElectricityConsumptionsTableFilterComposer,
    $$ElectricityConsumptionsTableOrderingComposer,
    $$ElectricityConsumptionsTableAnnotationComposer,
    $$ElectricityConsumptionsTableCreateCompanionBuilder,
    $$ElectricityConsumptionsTableUpdateCompanionBuilder,
    (
      ElectricityConsumptionEntry,
      BaseReferences<_$ElectricityDatabase, $ElectricityConsumptionsTable,
          ElectricityConsumptionEntry>
    ),
    ElectricityConsumptionEntry,
    PrefetchHooks Function()> {
  $$ElectricityConsumptionsTableTableManager(
      _$ElectricityDatabase db, $ElectricityConsumptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ElectricityConsumptionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ElectricityConsumptionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ElectricityConsumptionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> consumptionTarifLow = const Value.absent(),
            Value<double> consumptionTarifHigh = const Value.absent(),
            Value<double?> consumptionTarifOut = const Value.absent(),
          }) =>
              ElectricityConsumptionsCompanion(
            id: id,
            date: date,
            consumptionTarifLow: consumptionTarifLow,
            consumptionTarifHigh: consumptionTarifHigh,
            consumptionTarifOut: consumptionTarifOut,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required double consumptionTarifLow,
            required double consumptionTarifHigh,
            Value<double?> consumptionTarifOut = const Value.absent(),
          }) =>
              ElectricityConsumptionsCompanion.insert(
            id: id,
            date: date,
            consumptionTarifLow: consumptionTarifLow,
            consumptionTarifHigh: consumptionTarifHigh,
            consumptionTarifOut: consumptionTarifOut,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ElectricityConsumptionsTableProcessedTableManager
    = ProcessedTableManager<
        _$ElectricityDatabase,
        $ElectricityConsumptionsTable,
        ElectricityConsumptionEntry,
        $$ElectricityConsumptionsTableFilterComposer,
        $$ElectricityConsumptionsTableOrderingComposer,
        $$ElectricityConsumptionsTableAnnotationComposer,
        $$ElectricityConsumptionsTableCreateCompanionBuilder,
        $$ElectricityConsumptionsTableUpdateCompanionBuilder,
        (
          ElectricityConsumptionEntry,
          BaseReferences<_$ElectricityDatabase, $ElectricityConsumptionsTable,
              ElectricityConsumptionEntry>
        ),
        ElectricityConsumptionEntry,
        PrefetchHooks Function()>;

class $ElectricityDatabaseManager {
  final _$ElectricityDatabase _db;
  $ElectricityDatabaseManager(this._db);
  $$ElectricityConsumptionsTableTableManager get electricityConsumptions =>
      $$ElectricityConsumptionsTableTableManager(
          _db, _db.electricityConsumptions);
}
