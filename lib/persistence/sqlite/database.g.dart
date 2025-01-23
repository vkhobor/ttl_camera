// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TemporaryImageDao? _personDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TemporaryImage` (`path` TEXT NOT NULL, `deleteAt` INTEGER NOT NULL, PRIMARY KEY (`path`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TemporaryImageDao get personDao {
    return _personDaoInstance ??= _$TemporaryImageDao(database, changeListener);
  }
}

class _$TemporaryImageDao extends TemporaryImageDao {
  _$TemporaryImageDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _temporaryImageInsertionAdapter = InsertionAdapter(
            database,
            'TemporaryImage',
            (TemporaryImage item) => <String, Object?>{
                  'path': item.path,
                  'deleteAt': _dateTimeConverter.encode(item.deleteAt)
                }),
        _temporaryImageDeletionAdapter = DeletionAdapter(
            database,
            'TemporaryImage',
            ['path'],
            (TemporaryImage item) => <String, Object?>{
                  'path': item.path,
                  'deleteAt': _dateTimeConverter.encode(item.deleteAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TemporaryImage> _temporaryImageInsertionAdapter;

  final DeletionAdapter<TemporaryImage> _temporaryImageDeletionAdapter;

  @override
  Future<List<TemporaryImage>> findAllTemporaryImages() async {
    return _queryAdapter.queryList('SELECT * FROM TemporaryImage',
        mapper: (Map<String, Object?> row) => TemporaryImage(
            row['path'] as String,
            _dateTimeConverter.decode(row['deleteAt'] as int)));
  }

  @override
  Future<List<TemporaryImage>> findToDeleteTemporaryImages(DateTime now) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TemporaryImage WHERE deleteAt < ?1',
        mapper: (Map<String, Object?> row) => TemporaryImage(
            row['path'] as String,
            _dateTimeConverter.decode(row['deleteAt'] as int)),
        arguments: [_dateTimeConverter.encode(now)]);
  }

  @override
  Future<void> insertTemporaryImage(TemporaryImage person) async {
    await _temporaryImageInsertionAdapter.insert(
        person, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTemporaryImage(TemporaryImage person) async {
    await _temporaryImageDeletionAdapter.delete(person);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
