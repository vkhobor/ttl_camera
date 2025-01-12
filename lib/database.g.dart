// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TemporaryImagesTable extends TemporaryImages
    with TableInfo<$TemporaryImagesTable, TemporaryImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemporaryImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _savedAtMeta =
      const VerificationMeta('savedAt');
  @override
  late final GeneratedColumn<String> savedAt = GeneratedColumn<String>(
      'savedAt', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _deleteAtMeta =
      const VerificationMeta('deleteAt');
  @override
  late final GeneratedColumn<DateTime> deleteAt = GeneratedColumn<DateTime>(
      'delete_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [savedAt, deleteAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'temporary_images';
  @override
  VerificationContext validateIntegrity(Insertable<TemporaryImage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('savedAt')) {
      context.handle(_savedAtMeta,
          savedAt.isAcceptableOrUnknown(data['savedAt']!, _savedAtMeta));
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    if (data.containsKey('delete_at')) {
      context.handle(_deleteAtMeta,
          deleteAt.isAcceptableOrUnknown(data['delete_at']!, _deleteAtMeta));
    } else if (isInserting) {
      context.missing(_deleteAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TemporaryImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemporaryImage(
      savedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}savedAt'])!,
      deleteAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}delete_at'])!,
    );
  }

  @override
  $TemporaryImagesTable createAlias(String alias) {
    return $TemporaryImagesTable(attachedDatabase, alias);
  }
}

class TemporaryImage extends DataClass implements Insertable<TemporaryImage> {
  final String savedAt;
  final DateTime deleteAt;
  const TemporaryImage({required this.savedAt, required this.deleteAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['savedAt'] = Variable<String>(savedAt);
    map['delete_at'] = Variable<DateTime>(deleteAt);
    return map;
  }

  TemporaryImagesCompanion toCompanion(bool nullToAbsent) {
    return TemporaryImagesCompanion(
      savedAt: Value(savedAt),
      deleteAt: Value(deleteAt),
    );
  }

  factory TemporaryImage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemporaryImage(
      savedAt: serializer.fromJson<String>(json['savedAt']),
      deleteAt: serializer.fromJson<DateTime>(json['deleteAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'savedAt': serializer.toJson<String>(savedAt),
      'deleteAt': serializer.toJson<DateTime>(deleteAt),
    };
  }

  TemporaryImage copyWith({String? savedAt, DateTime? deleteAt}) =>
      TemporaryImage(
        savedAt: savedAt ?? this.savedAt,
        deleteAt: deleteAt ?? this.deleteAt,
      );
  TemporaryImage copyWithCompanion(TemporaryImagesCompanion data) {
    return TemporaryImage(
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
      deleteAt: data.deleteAt.present ? data.deleteAt.value : this.deleteAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemporaryImage(')
          ..write('savedAt: $savedAt, ')
          ..write('deleteAt: $deleteAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(savedAt, deleteAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemporaryImage &&
          other.savedAt == this.savedAt &&
          other.deleteAt == this.deleteAt);
}

class TemporaryImagesCompanion extends UpdateCompanion<TemporaryImage> {
  final Value<String> savedAt;
  final Value<DateTime> deleteAt;
  final Value<int> rowid;
  const TemporaryImagesCompanion({
    this.savedAt = const Value.absent(),
    this.deleteAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemporaryImagesCompanion.insert({
    required String savedAt,
    required DateTime deleteAt,
    this.rowid = const Value.absent(),
  })  : savedAt = Value(savedAt),
        deleteAt = Value(deleteAt);
  static Insertable<TemporaryImage> custom({
    Expression<String>? savedAt,
    Expression<DateTime>? deleteAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (savedAt != null) 'savedAt': savedAt,
      if (deleteAt != null) 'delete_at': deleteAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemporaryImagesCompanion copyWith(
      {Value<String>? savedAt, Value<DateTime>? deleteAt, Value<int>? rowid}) {
    return TemporaryImagesCompanion(
      savedAt: savedAt ?? this.savedAt,
      deleteAt: deleteAt ?? this.deleteAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (savedAt.present) {
      map['savedAt'] = Variable<String>(savedAt.value);
    }
    if (deleteAt.present) {
      map['delete_at'] = Variable<DateTime>(deleteAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemporaryImagesCompanion(')
          ..write('savedAt: $savedAt, ')
          ..write('deleteAt: $deleteAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TemporaryImagesTable temporaryImages =
      $TemporaryImagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [temporaryImages];
}

typedef $$TemporaryImagesTableCreateCompanionBuilder = TemporaryImagesCompanion
    Function({
  required String savedAt,
  required DateTime deleteAt,
  Value<int> rowid,
});
typedef $$TemporaryImagesTableUpdateCompanionBuilder = TemporaryImagesCompanion
    Function({
  Value<String> savedAt,
  Value<DateTime> deleteAt,
  Value<int> rowid,
});

class $$TemporaryImagesTableFilterComposer
    extends Composer<_$AppDatabase, $TemporaryImagesTable> {
  $$TemporaryImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deleteAt => $composableBuilder(
      column: $table.deleteAt, builder: (column) => ColumnFilters(column));
}

class $$TemporaryImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemporaryImagesTable> {
  $$TemporaryImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deleteAt => $composableBuilder(
      column: $table.deleteAt, builder: (column) => ColumnOrderings(column));
}

class $$TemporaryImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemporaryImagesTable> {
  $$TemporaryImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deleteAt =>
      $composableBuilder(column: $table.deleteAt, builder: (column) => column);
}

class $$TemporaryImagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TemporaryImagesTable,
    TemporaryImage,
    $$TemporaryImagesTableFilterComposer,
    $$TemporaryImagesTableOrderingComposer,
    $$TemporaryImagesTableAnnotationComposer,
    $$TemporaryImagesTableCreateCompanionBuilder,
    $$TemporaryImagesTableUpdateCompanionBuilder,
    (
      TemporaryImage,
      BaseReferences<_$AppDatabase, $TemporaryImagesTable, TemporaryImage>
    ),
    TemporaryImage,
    PrefetchHooks Function()> {
  $$TemporaryImagesTableTableManager(
      _$AppDatabase db, $TemporaryImagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemporaryImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemporaryImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemporaryImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> savedAt = const Value.absent(),
            Value<DateTime> deleteAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TemporaryImagesCompanion(
            savedAt: savedAt,
            deleteAt: deleteAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String savedAt,
            required DateTime deleteAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TemporaryImagesCompanion.insert(
            savedAt: savedAt,
            deleteAt: deleteAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TemporaryImagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TemporaryImagesTable,
    TemporaryImage,
    $$TemporaryImagesTableFilterComposer,
    $$TemporaryImagesTableOrderingComposer,
    $$TemporaryImagesTableAnnotationComposer,
    $$TemporaryImagesTableCreateCompanionBuilder,
    $$TemporaryImagesTableUpdateCompanionBuilder,
    (
      TemporaryImage,
      BaseReferences<_$AppDatabase, $TemporaryImagesTable, TemporaryImage>
    ),
    TemporaryImage,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TemporaryImagesTableTableManager get temporaryImages =>
      $$TemporaryImagesTableTableManager(_db, _db.temporaryImages);
}
