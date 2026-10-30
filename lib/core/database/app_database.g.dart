// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Typist'));
  static const VerificationMeta _profileImageMeta =
      const VerificationMeta('profileImage');
  @override
  late final GeneratedColumn<String> profileImage = GeneratedColumn<String>(
      'profile_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _preferredLanguageMeta =
      const VerificationMeta('preferredLanguage');
  @override
  late final GeneratedColumn<String> preferredLanguage =
      GeneratedColumn<String>('preferred_language', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('en'));
  static const VerificationMeta _dailyGoalSecondsMeta =
      const VerificationMeta('dailyGoalSeconds');
  @override
  late final GeneratedColumn<int> dailyGoalSeconds = GeneratedColumn<int>(
      'daily_goal_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(600));
  static const VerificationMeta _preferredTestDurationSecondsMeta =
      const VerificationMeta('preferredTestDurationSeconds');
  @override
  late final GeneratedColumn<int> preferredTestDurationSeconds =
      GeneratedColumn<int>(
          'preferred_test_duration_seconds', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(60));
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
        profileImage,
        preferredLanguage,
        dailyGoalSeconds,
        preferredTestDurationSeconds,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('profile_image')) {
      context.handle(
          _profileImageMeta,
          profileImage.isAcceptableOrUnknown(
              data['profile_image']!, _profileImageMeta));
    }
    if (data.containsKey('preferred_language')) {
      context.handle(
          _preferredLanguageMeta,
          preferredLanguage.isAcceptableOrUnknown(
              data['preferred_language']!, _preferredLanguageMeta));
    }
    if (data.containsKey('daily_goal_seconds')) {
      context.handle(
          _dailyGoalSecondsMeta,
          dailyGoalSeconds.isAcceptableOrUnknown(
              data['daily_goal_seconds']!, _dailyGoalSecondsMeta));
    }
    if (data.containsKey('preferred_test_duration_seconds')) {
      context.handle(
          _preferredTestDurationSecondsMeta,
          preferredTestDurationSeconds.isAcceptableOrUnknown(
              data['preferred_test_duration_seconds']!,
              _preferredTestDurationSecondsMeta));
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
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      profileImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_image']),
      preferredLanguage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}preferred_language'])!,
      dailyGoalSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}daily_goal_seconds'])!,
      preferredTestDurationSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}preferred_test_duration_seconds'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final String? profileImage;

  /// 'en' or 'ur'
  final String preferredLanguage;

  /// Daily goal in seconds (e.g. 600 = 10 minutes).
  final int dailyGoalSeconds;

  /// Default duration for a new typing test, in seconds.
  final int preferredTestDurationSeconds;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User(
      {required this.id,
      required this.name,
      this.profileImage,
      required this.preferredLanguage,
      required this.dailyGoalSeconds,
      required this.preferredTestDurationSeconds,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || profileImage != null) {
      map['profile_image'] = Variable<String>(profileImage);
    }
    map['preferred_language'] = Variable<String>(preferredLanguage);
    map['daily_goal_seconds'] = Variable<int>(dailyGoalSeconds);
    map['preferred_test_duration_seconds'] =
        Variable<int>(preferredTestDurationSeconds);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      profileImage: profileImage == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImage),
      preferredLanguage: Value(preferredLanguage),
      dailyGoalSeconds: Value(dailyGoalSeconds),
      preferredTestDurationSeconds: Value(preferredTestDurationSeconds),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      profileImage: serializer.fromJson<String?>(json['profileImage']),
      preferredLanguage: serializer.fromJson<String>(json['preferredLanguage']),
      dailyGoalSeconds: serializer.fromJson<int>(json['dailyGoalSeconds']),
      preferredTestDurationSeconds:
          serializer.fromJson<int>(json['preferredTestDurationSeconds']),
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
      'profileImage': serializer.toJson<String?>(profileImage),
      'preferredLanguage': serializer.toJson<String>(preferredLanguage),
      'dailyGoalSeconds': serializer.toJson<int>(dailyGoalSeconds),
      'preferredTestDurationSeconds':
          serializer.toJson<int>(preferredTestDurationSeconds),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith(
          {int? id,
          String? name,
          Value<String?> profileImage = const Value.absent(),
          String? preferredLanguage,
          int? dailyGoalSeconds,
          int? preferredTestDurationSeconds,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        profileImage:
            profileImage.present ? profileImage.value : this.profileImage,
        preferredLanguage: preferredLanguage ?? this.preferredLanguage,
        dailyGoalSeconds: dailyGoalSeconds ?? this.dailyGoalSeconds,
        preferredTestDurationSeconds:
            preferredTestDurationSeconds ?? this.preferredTestDurationSeconds,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      profileImage: data.profileImage.present
          ? data.profileImage.value
          : this.profileImage,
      preferredLanguage: data.preferredLanguage.present
          ? data.preferredLanguage.value
          : this.preferredLanguage,
      dailyGoalSeconds: data.dailyGoalSeconds.present
          ? data.dailyGoalSeconds.value
          : this.dailyGoalSeconds,
      preferredTestDurationSeconds: data.preferredTestDurationSeconds.present
          ? data.preferredTestDurationSeconds.value
          : this.preferredTestDurationSeconds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('profileImage: $profileImage, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('dailyGoalSeconds: $dailyGoalSeconds, ')
          ..write(
              'preferredTestDurationSeconds: $preferredTestDurationSeconds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, profileImage, preferredLanguage,
      dailyGoalSeconds, preferredTestDurationSeconds, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.profileImage == this.profileImage &&
          other.preferredLanguage == this.preferredLanguage &&
          other.dailyGoalSeconds == this.dailyGoalSeconds &&
          other.preferredTestDurationSeconds ==
              this.preferredTestDurationSeconds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> profileImage;
  final Value<String> preferredLanguage;
  final Value<int> dailyGoalSeconds;
  final Value<int> preferredTestDurationSeconds;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.dailyGoalSeconds = const Value.absent(),
    this.preferredTestDurationSeconds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.dailyGoalSeconds = const Value.absent(),
    this.preferredTestDurationSeconds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? profileImage,
    Expression<String>? preferredLanguage,
    Expression<int>? dailyGoalSeconds,
    Expression<int>? preferredTestDurationSeconds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (profileImage != null) 'profile_image': profileImage,
      if (preferredLanguage != null) 'preferred_language': preferredLanguage,
      if (dailyGoalSeconds != null) 'daily_goal_seconds': dailyGoalSeconds,
      if (preferredTestDurationSeconds != null)
        'preferred_test_duration_seconds': preferredTestDurationSeconds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? profileImage,
      Value<String>? preferredLanguage,
      Value<int>? dailyGoalSeconds,
      Value<int>? preferredTestDurationSeconds,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      dailyGoalSeconds: dailyGoalSeconds ?? this.dailyGoalSeconds,
      preferredTestDurationSeconds:
          preferredTestDurationSeconds ?? this.preferredTestDurationSeconds,
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
    if (profileImage.present) {
      map['profile_image'] = Variable<String>(profileImage.value);
    }
    if (preferredLanguage.present) {
      map['preferred_language'] = Variable<String>(preferredLanguage.value);
    }
    if (dailyGoalSeconds.present) {
      map['daily_goal_seconds'] = Variable<int>(dailyGoalSeconds.value);
    }
    if (preferredTestDurationSeconds.present) {
      map['preferred_test_duration_seconds'] =
          Variable<int>(preferredTestDurationSeconds.value);
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
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('profileImage: $profileImage, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('dailyGoalSeconds: $dailyGoalSeconds, ')
          ..write(
              'preferredTestDurationSeconds: $preferredTestDurationSeconds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ParagraphsTable extends Paragraphs
    with TableInfo<$ParagraphsTable, Paragraph> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParagraphsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('General'));
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isPpscMeta = const VerificationMeta('isPpsc');
  @override
  late final GeneratedColumn<bool> isPpsc = GeneratedColumn<bool>(
      'is_ppsc', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_ppsc" IN (0, 1))'),
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
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        language,
        category,
        difficulty,
        content,
        isCustom,
        isPpsc,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paragraphs';
  @override
  VerificationContext validateIntegrity(Insertable<Paragraph> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    if (data.containsKey('is_ppsc')) {
      context.handle(_isPpscMeta,
          isPpsc.isAcceptableOrUnknown(data['is_ppsc']!, _isPpscMeta));
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
  Paragraph map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Paragraph(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
      isPpsc: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_ppsc'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ParagraphsTable createAlias(String alias) {
    return $ParagraphsTable(attachedDatabase, alias);
  }
}

class Paragraph extends DataClass implements Insertable<Paragraph> {
  final int id;
  final String title;

  /// 'en' or 'ur'
  final String language;

  /// e.g. General, Education, Technology, Jobs, Office, Programming,
  /// Quotes, PPSC, Pakistan Studies, English Grammar, Urdu General,
  /// Urdu Education.
  final String category;

  /// 'easy' | 'medium' | 'hard' — used by Typing Test / PPSC difficulty
  /// filters. Nullable because a user's custom paragraph may not set one.
  final String? difficulty;
  final String content;
  final bool isCustom;

  /// True for paragraphs meant for the PPSC Urdu section specifically.
  final bool isPpsc;
  final DateTime createdAt;

  /// Set only when a custom paragraph is actually edited after creation
  /// (spec section 6: "Updated date"). Null means never edited. Added in
  /// schemaVersion 3 — see app_database.dart.
  final DateTime? updatedAt;
  const Paragraph(
      {required this.id,
      required this.title,
      required this.language,
      required this.category,
      this.difficulty,
      required this.content,
      required this.isCustom,
      required this.isPpsc,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['language'] = Variable<String>(language);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<String>(difficulty);
    }
    map['content'] = Variable<String>(content);
    map['is_custom'] = Variable<bool>(isCustom);
    map['is_ppsc'] = Variable<bool>(isPpsc);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ParagraphsCompanion toCompanion(bool nullToAbsent) {
    return ParagraphsCompanion(
      id: Value(id),
      title: Value(title),
      language: Value(language),
      category: Value(category),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      content: Value(content),
      isCustom: Value(isCustom),
      isPpsc: Value(isPpsc),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Paragraph.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Paragraph(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      language: serializer.fromJson<String>(json['language']),
      category: serializer.fromJson<String>(json['category']),
      difficulty: serializer.fromJson<String?>(json['difficulty']),
      content: serializer.fromJson<String>(json['content']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      isPpsc: serializer.fromJson<bool>(json['isPpsc']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'language': serializer.toJson<String>(language),
      'category': serializer.toJson<String>(category),
      'difficulty': serializer.toJson<String?>(difficulty),
      'content': serializer.toJson<String>(content),
      'isCustom': serializer.toJson<bool>(isCustom),
      'isPpsc': serializer.toJson<bool>(isPpsc),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Paragraph copyWith(
          {int? id,
          String? title,
          String? language,
          String? category,
          Value<String?> difficulty = const Value.absent(),
          String? content,
          bool? isCustom,
          bool? isPpsc,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Paragraph(
        id: id ?? this.id,
        title: title ?? this.title,
        language: language ?? this.language,
        category: category ?? this.category,
        difficulty: difficulty.present ? difficulty.value : this.difficulty,
        content: content ?? this.content,
        isCustom: isCustom ?? this.isCustom,
        isPpsc: isPpsc ?? this.isPpsc,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Paragraph copyWithCompanion(ParagraphsCompanion data) {
    return Paragraph(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      language: data.language.present ? data.language.value : this.language,
      category: data.category.present ? data.category.value : this.category,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      content: data.content.present ? data.content.value : this.content,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      isPpsc: data.isPpsc.present ? data.isPpsc.value : this.isPpsc,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Paragraph(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('content: $content, ')
          ..write('isCustom: $isCustom, ')
          ..write('isPpsc: $isPpsc, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, language, category, difficulty,
      content, isCustom, isPpsc, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Paragraph &&
          other.id == this.id &&
          other.title == this.title &&
          other.language == this.language &&
          other.category == this.category &&
          other.difficulty == this.difficulty &&
          other.content == this.content &&
          other.isCustom == this.isCustom &&
          other.isPpsc == this.isPpsc &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ParagraphsCompanion extends UpdateCompanion<Paragraph> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> language;
  final Value<String> category;
  final Value<String?> difficulty;
  final Value<String> content;
  final Value<bool> isCustom;
  final Value<bool> isPpsc;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const ParagraphsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.language = const Value.absent(),
    this.category = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.content = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isPpsc = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ParagraphsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String language,
    this.category = const Value.absent(),
    this.difficulty = const Value.absent(),
    required String content,
    this.isCustom = const Value.absent(),
    this.isPpsc = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : title = Value(title),
        language = Value(language),
        content = Value(content);
  static Insertable<Paragraph> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? language,
    Expression<String>? category,
    Expression<String>? difficulty,
    Expression<String>? content,
    Expression<bool>? isCustom,
    Expression<bool>? isPpsc,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (language != null) 'language': language,
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
      if (content != null) 'content': content,
      if (isCustom != null) 'is_custom': isCustom,
      if (isPpsc != null) 'is_ppsc': isPpsc,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ParagraphsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? language,
      Value<String>? category,
      Value<String?>? difficulty,
      Value<String>? content,
      Value<bool>? isCustom,
      Value<bool>? isPpsc,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return ParagraphsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      content: content ?? this.content,
      isCustom: isCustom ?? this.isCustom,
      isPpsc: isPpsc ?? this.isPpsc,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (isPpsc.present) {
      map['is_ppsc'] = Variable<bool>(isPpsc.value);
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
    return (StringBuffer('ParagraphsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('content: $content, ')
          ..write('isCustom: $isCustom, ')
          ..write('isPpsc: $isPpsc, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TypingTestsTable extends TypingTests
    with TableInfo<$TypingTestsTable, TypingTest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TypingTestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _testTypeMeta =
      const VerificationMeta('testType');
  @override
  late final GeneratedColumn<String> testType = GeneratedColumn<String>(
      'test_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paragraphIdMeta =
      const VerificationMeta('paragraphId');
  @override
  late final GeneratedColumn<int> paragraphId = GeneratedColumn<int>(
      'paragraph_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES paragraphs (id)'));
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _actualDurationSecondsMeta =
      const VerificationMeta('actualDurationSeconds');
  @override
  late final GeneratedColumn<int> actualDurationSeconds = GeneratedColumn<int>(
      'actual_duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _grossWpmMeta =
      const VerificationMeta('grossWpm');
  @override
  late final GeneratedColumn<double> grossWpm = GeneratedColumn<double>(
      'gross_wpm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _netWpmMeta = const VerificationMeta('netWpm');
  @override
  late final GeneratedColumn<double> netWpm = GeneratedColumn<double>(
      'net_wpm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _accuracyMeta =
      const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
      'accuracy', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _keystrokeAccuracyMeta =
      const VerificationMeta('keystrokeAccuracy');
  @override
  late final GeneratedColumn<double> keystrokeAccuracy =
      GeneratedColumn<double>('keystroke_accuracy', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _correctCharactersMeta =
      const VerificationMeta('correctCharacters');
  @override
  late final GeneratedColumn<int> correctCharacters = GeneratedColumn<int>(
      'correct_characters', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wrongCharactersMeta =
      const VerificationMeta('wrongCharacters');
  @override
  late final GeneratedColumn<int> wrongCharacters = GeneratedColumn<int>(
      'wrong_characters', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _correctWordsMeta =
      const VerificationMeta('correctWords');
  @override
  late final GeneratedColumn<int> correctWords = GeneratedColumn<int>(
      'correct_words', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wrongWordsMeta =
      const VerificationMeta('wrongWords');
  @override
  late final GeneratedColumn<int> wrongWords = GeneratedColumn<int>(
      'wrong_words', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _skippedWordsMeta =
      const VerificationMeta('skippedWords');
  @override
  late final GeneratedColumn<int> skippedWords = GeneratedColumn<int>(
      'skipped_words', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _backspacesMeta =
      const VerificationMeta('backspaces');
  @override
  late final GeneratedColumn<int> backspaces = GeneratedColumn<int>(
      'backspaces', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _correctedMistakesMeta =
      const VerificationMeta('correctedMistakes');
  @override
  late final GeneratedColumn<int> correctedMistakes = GeneratedColumn<int>(
      'corrected_mistakes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _uncorrectedMistakesMeta =
      const VerificationMeta('uncorrectedMistakes');
  @override
  late final GeneratedColumn<int> uncorrectedMistakes = GeneratedColumn<int>(
      'uncorrected_mistakes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalErrorsMeta =
      const VerificationMeta('totalErrors');
  @override
  late final GeneratedColumn<int> totalErrors = GeneratedColumn<int>(
      'total_errors', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        language,
        testType,
        paragraphId,
        durationSeconds,
        actualDurationSeconds,
        grossWpm,
        netWpm,
        accuracy,
        keystrokeAccuracy,
        correctCharacters,
        wrongCharacters,
        correctWords,
        wrongWords,
        skippedWords,
        backspaces,
        correctedMistakes,
        uncorrectedMistakes,
        totalErrors,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'typing_tests';
  @override
  VerificationContext validateIntegrity(Insertable<TypingTest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('test_type')) {
      context.handle(_testTypeMeta,
          testType.isAcceptableOrUnknown(data['test_type']!, _testTypeMeta));
    } else if (isInserting) {
      context.missing(_testTypeMeta);
    }
    if (data.containsKey('paragraph_id')) {
      context.handle(
          _paragraphIdMeta,
          paragraphId.isAcceptableOrUnknown(
              data['paragraph_id']!, _paragraphIdMeta));
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    if (data.containsKey('actual_duration_seconds')) {
      context.handle(
          _actualDurationSecondsMeta,
          actualDurationSeconds.isAcceptableOrUnknown(
              data['actual_duration_seconds']!, _actualDurationSecondsMeta));
    } else if (isInserting) {
      context.missing(_actualDurationSecondsMeta);
    }
    if (data.containsKey('gross_wpm')) {
      context.handle(_grossWpmMeta,
          grossWpm.isAcceptableOrUnknown(data['gross_wpm']!, _grossWpmMeta));
    } else if (isInserting) {
      context.missing(_grossWpmMeta);
    }
    if (data.containsKey('net_wpm')) {
      context.handle(_netWpmMeta,
          netWpm.isAcceptableOrUnknown(data['net_wpm']!, _netWpmMeta));
    } else if (isInserting) {
      context.missing(_netWpmMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    } else if (isInserting) {
      context.missing(_accuracyMeta);
    }
    if (data.containsKey('keystroke_accuracy')) {
      context.handle(
          _keystrokeAccuracyMeta,
          keystrokeAccuracy.isAcceptableOrUnknown(
              data['keystroke_accuracy']!, _keystrokeAccuracyMeta));
    }
    if (data.containsKey('correct_characters')) {
      context.handle(
          _correctCharactersMeta,
          correctCharacters.isAcceptableOrUnknown(
              data['correct_characters']!, _correctCharactersMeta));
    } else if (isInserting) {
      context.missing(_correctCharactersMeta);
    }
    if (data.containsKey('wrong_characters')) {
      context.handle(
          _wrongCharactersMeta,
          wrongCharacters.isAcceptableOrUnknown(
              data['wrong_characters']!, _wrongCharactersMeta));
    } else if (isInserting) {
      context.missing(_wrongCharactersMeta);
    }
    if (data.containsKey('correct_words')) {
      context.handle(
          _correctWordsMeta,
          correctWords.isAcceptableOrUnknown(
              data['correct_words']!, _correctWordsMeta));
    } else if (isInserting) {
      context.missing(_correctWordsMeta);
    }
    if (data.containsKey('wrong_words')) {
      context.handle(
          _wrongWordsMeta,
          wrongWords.isAcceptableOrUnknown(
              data['wrong_words']!, _wrongWordsMeta));
    } else if (isInserting) {
      context.missing(_wrongWordsMeta);
    }
    if (data.containsKey('skipped_words')) {
      context.handle(
          _skippedWordsMeta,
          skippedWords.isAcceptableOrUnknown(
              data['skipped_words']!, _skippedWordsMeta));
    } else if (isInserting) {
      context.missing(_skippedWordsMeta);
    }
    if (data.containsKey('backspaces')) {
      context.handle(
          _backspacesMeta,
          backspaces.isAcceptableOrUnknown(
              data['backspaces']!, _backspacesMeta));
    }
    if (data.containsKey('corrected_mistakes')) {
      context.handle(
          _correctedMistakesMeta,
          correctedMistakes.isAcceptableOrUnknown(
              data['corrected_mistakes']!, _correctedMistakesMeta));
    }
    if (data.containsKey('uncorrected_mistakes')) {
      context.handle(
          _uncorrectedMistakesMeta,
          uncorrectedMistakes.isAcceptableOrUnknown(
              data['uncorrected_mistakes']!, _uncorrectedMistakesMeta));
    }
    if (data.containsKey('total_errors')) {
      context.handle(
          _totalErrorsMeta,
          totalErrors.isAcceptableOrUnknown(
              data['total_errors']!, _totalErrorsMeta));
    } else if (isInserting) {
      context.missing(_totalErrorsMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TypingTest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TypingTest(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      testType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}test_type'])!,
      paragraphId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paragraph_id']),
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds']),
      actualDurationSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}actual_duration_seconds'])!,
      grossWpm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gross_wpm'])!,
      netWpm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_wpm'])!,
      accuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy'])!,
      keystrokeAccuracy: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}keystroke_accuracy'])!,
      correctCharacters: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}correct_characters'])!,
      wrongCharacters: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wrong_characters'])!,
      correctWords: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_words'])!,
      wrongWords: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wrong_words'])!,
      skippedWords: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}skipped_words'])!,
      backspaces: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}backspaces'])!,
      correctedMistakes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}corrected_mistakes'])!,
      uncorrectedMistakes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}uncorrected_mistakes'])!,
      totalErrors: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_errors'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
    );
  }

  @override
  $TypingTestsTable createAlias(String alias) {
    return $TypingTestsTable(attachedDatabase, alias);
  }
}

class TypingTest extends DataClass implements Insertable<TypingTest> {
  final int id;
  final int userId;

  /// 'en' or 'ur'
  final String language;

  /// 'test' | 'ppsc' | 'lesson' | 'practice'
  final String testType;

  /// Nullable: a lesson id or practice session may not point at a
  /// Paragraphs row (e.g. generated mistake-practice text).
  final int? paragraphId;

  /// Planned duration in seconds (0/null for untimed free practice).
  final int? durationSeconds;

  /// Actual elapsed typing time in seconds (excludes paused time).
  final int actualDurationSeconds;
  final double grossWpm;
  final double netWpm;

  /// Final accuracy shown as the headline result (0-100).
  final double accuracy;

  /// Keystroke-level accuracy for detailed analytics (0-100), can differ
  /// from [accuracy] once backspace-corrected keystrokes are counted in.
  final double keystrokeAccuracy;
  final int correctCharacters;
  final int wrongCharacters;
  final int correctWords;
  final int wrongWords;
  final int skippedWords;
  final int backspaces;
  final int correctedMistakes;
  final int uncorrectedMistakes;
  final int totalErrors;
  final DateTime completedAt;
  const TypingTest(
      {required this.id,
      required this.userId,
      required this.language,
      required this.testType,
      this.paragraphId,
      this.durationSeconds,
      required this.actualDurationSeconds,
      required this.grossWpm,
      required this.netWpm,
      required this.accuracy,
      required this.keystrokeAccuracy,
      required this.correctCharacters,
      required this.wrongCharacters,
      required this.correctWords,
      required this.wrongWords,
      required this.skippedWords,
      required this.backspaces,
      required this.correctedMistakes,
      required this.uncorrectedMistakes,
      required this.totalErrors,
      required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['language'] = Variable<String>(language);
    map['test_type'] = Variable<String>(testType);
    if (!nullToAbsent || paragraphId != null) {
      map['paragraph_id'] = Variable<int>(paragraphId);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    map['actual_duration_seconds'] = Variable<int>(actualDurationSeconds);
    map['gross_wpm'] = Variable<double>(grossWpm);
    map['net_wpm'] = Variable<double>(netWpm);
    map['accuracy'] = Variable<double>(accuracy);
    map['keystroke_accuracy'] = Variable<double>(keystrokeAccuracy);
    map['correct_characters'] = Variable<int>(correctCharacters);
    map['wrong_characters'] = Variable<int>(wrongCharacters);
    map['correct_words'] = Variable<int>(correctWords);
    map['wrong_words'] = Variable<int>(wrongWords);
    map['skipped_words'] = Variable<int>(skippedWords);
    map['backspaces'] = Variable<int>(backspaces);
    map['corrected_mistakes'] = Variable<int>(correctedMistakes);
    map['uncorrected_mistakes'] = Variable<int>(uncorrectedMistakes);
    map['total_errors'] = Variable<int>(totalErrors);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  TypingTestsCompanion toCompanion(bool nullToAbsent) {
    return TypingTestsCompanion(
      id: Value(id),
      userId: Value(userId),
      language: Value(language),
      testType: Value(testType),
      paragraphId: paragraphId == null && nullToAbsent
          ? const Value.absent()
          : Value(paragraphId),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      actualDurationSeconds: Value(actualDurationSeconds),
      grossWpm: Value(grossWpm),
      netWpm: Value(netWpm),
      accuracy: Value(accuracy),
      keystrokeAccuracy: Value(keystrokeAccuracy),
      correctCharacters: Value(correctCharacters),
      wrongCharacters: Value(wrongCharacters),
      correctWords: Value(correctWords),
      wrongWords: Value(wrongWords),
      skippedWords: Value(skippedWords),
      backspaces: Value(backspaces),
      correctedMistakes: Value(correctedMistakes),
      uncorrectedMistakes: Value(uncorrectedMistakes),
      totalErrors: Value(totalErrors),
      completedAt: Value(completedAt),
    );
  }

  factory TypingTest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TypingTest(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      language: serializer.fromJson<String>(json['language']),
      testType: serializer.fromJson<String>(json['testType']),
      paragraphId: serializer.fromJson<int?>(json['paragraphId']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      actualDurationSeconds:
          serializer.fromJson<int>(json['actualDurationSeconds']),
      grossWpm: serializer.fromJson<double>(json['grossWpm']),
      netWpm: serializer.fromJson<double>(json['netWpm']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
      keystrokeAccuracy: serializer.fromJson<double>(json['keystrokeAccuracy']),
      correctCharacters: serializer.fromJson<int>(json['correctCharacters']),
      wrongCharacters: serializer.fromJson<int>(json['wrongCharacters']),
      correctWords: serializer.fromJson<int>(json['correctWords']),
      wrongWords: serializer.fromJson<int>(json['wrongWords']),
      skippedWords: serializer.fromJson<int>(json['skippedWords']),
      backspaces: serializer.fromJson<int>(json['backspaces']),
      correctedMistakes: serializer.fromJson<int>(json['correctedMistakes']),
      uncorrectedMistakes:
          serializer.fromJson<int>(json['uncorrectedMistakes']),
      totalErrors: serializer.fromJson<int>(json['totalErrors']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'language': serializer.toJson<String>(language),
      'testType': serializer.toJson<String>(testType),
      'paragraphId': serializer.toJson<int?>(paragraphId),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'actualDurationSeconds': serializer.toJson<int>(actualDurationSeconds),
      'grossWpm': serializer.toJson<double>(grossWpm),
      'netWpm': serializer.toJson<double>(netWpm),
      'accuracy': serializer.toJson<double>(accuracy),
      'keystrokeAccuracy': serializer.toJson<double>(keystrokeAccuracy),
      'correctCharacters': serializer.toJson<int>(correctCharacters),
      'wrongCharacters': serializer.toJson<int>(wrongCharacters),
      'correctWords': serializer.toJson<int>(correctWords),
      'wrongWords': serializer.toJson<int>(wrongWords),
      'skippedWords': serializer.toJson<int>(skippedWords),
      'backspaces': serializer.toJson<int>(backspaces),
      'correctedMistakes': serializer.toJson<int>(correctedMistakes),
      'uncorrectedMistakes': serializer.toJson<int>(uncorrectedMistakes),
      'totalErrors': serializer.toJson<int>(totalErrors),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  TypingTest copyWith(
          {int? id,
          int? userId,
          String? language,
          String? testType,
          Value<int?> paragraphId = const Value.absent(),
          Value<int?> durationSeconds = const Value.absent(),
          int? actualDurationSeconds,
          double? grossWpm,
          double? netWpm,
          double? accuracy,
          double? keystrokeAccuracy,
          int? correctCharacters,
          int? wrongCharacters,
          int? correctWords,
          int? wrongWords,
          int? skippedWords,
          int? backspaces,
          int? correctedMistakes,
          int? uncorrectedMistakes,
          int? totalErrors,
          DateTime? completedAt}) =>
      TypingTest(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        language: language ?? this.language,
        testType: testType ?? this.testType,
        paragraphId: paragraphId.present ? paragraphId.value : this.paragraphId,
        durationSeconds: durationSeconds.present
            ? durationSeconds.value
            : this.durationSeconds,
        actualDurationSeconds:
            actualDurationSeconds ?? this.actualDurationSeconds,
        grossWpm: grossWpm ?? this.grossWpm,
        netWpm: netWpm ?? this.netWpm,
        accuracy: accuracy ?? this.accuracy,
        keystrokeAccuracy: keystrokeAccuracy ?? this.keystrokeAccuracy,
        correctCharacters: correctCharacters ?? this.correctCharacters,
        wrongCharacters: wrongCharacters ?? this.wrongCharacters,
        correctWords: correctWords ?? this.correctWords,
        wrongWords: wrongWords ?? this.wrongWords,
        skippedWords: skippedWords ?? this.skippedWords,
        backspaces: backspaces ?? this.backspaces,
        correctedMistakes: correctedMistakes ?? this.correctedMistakes,
        uncorrectedMistakes: uncorrectedMistakes ?? this.uncorrectedMistakes,
        totalErrors: totalErrors ?? this.totalErrors,
        completedAt: completedAt ?? this.completedAt,
      );
  TypingTest copyWithCompanion(TypingTestsCompanion data) {
    return TypingTest(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      language: data.language.present ? data.language.value : this.language,
      testType: data.testType.present ? data.testType.value : this.testType,
      paragraphId:
          data.paragraphId.present ? data.paragraphId.value : this.paragraphId,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      actualDurationSeconds: data.actualDurationSeconds.present
          ? data.actualDurationSeconds.value
          : this.actualDurationSeconds,
      grossWpm: data.grossWpm.present ? data.grossWpm.value : this.grossWpm,
      netWpm: data.netWpm.present ? data.netWpm.value : this.netWpm,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      keystrokeAccuracy: data.keystrokeAccuracy.present
          ? data.keystrokeAccuracy.value
          : this.keystrokeAccuracy,
      correctCharacters: data.correctCharacters.present
          ? data.correctCharacters.value
          : this.correctCharacters,
      wrongCharacters: data.wrongCharacters.present
          ? data.wrongCharacters.value
          : this.wrongCharacters,
      correctWords: data.correctWords.present
          ? data.correctWords.value
          : this.correctWords,
      wrongWords:
          data.wrongWords.present ? data.wrongWords.value : this.wrongWords,
      skippedWords: data.skippedWords.present
          ? data.skippedWords.value
          : this.skippedWords,
      backspaces:
          data.backspaces.present ? data.backspaces.value : this.backspaces,
      correctedMistakes: data.correctedMistakes.present
          ? data.correctedMistakes.value
          : this.correctedMistakes,
      uncorrectedMistakes: data.uncorrectedMistakes.present
          ? data.uncorrectedMistakes.value
          : this.uncorrectedMistakes,
      totalErrors:
          data.totalErrors.present ? data.totalErrors.value : this.totalErrors,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TypingTest(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('language: $language, ')
          ..write('testType: $testType, ')
          ..write('paragraphId: $paragraphId, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('actualDurationSeconds: $actualDurationSeconds, ')
          ..write('grossWpm: $grossWpm, ')
          ..write('netWpm: $netWpm, ')
          ..write('accuracy: $accuracy, ')
          ..write('keystrokeAccuracy: $keystrokeAccuracy, ')
          ..write('correctCharacters: $correctCharacters, ')
          ..write('wrongCharacters: $wrongCharacters, ')
          ..write('correctWords: $correctWords, ')
          ..write('wrongWords: $wrongWords, ')
          ..write('skippedWords: $skippedWords, ')
          ..write('backspaces: $backspaces, ')
          ..write('correctedMistakes: $correctedMistakes, ')
          ..write('uncorrectedMistakes: $uncorrectedMistakes, ')
          ..write('totalErrors: $totalErrors, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        language,
        testType,
        paragraphId,
        durationSeconds,
        actualDurationSeconds,
        grossWpm,
        netWpm,
        accuracy,
        keystrokeAccuracy,
        correctCharacters,
        wrongCharacters,
        correctWords,
        wrongWords,
        skippedWords,
        backspaces,
        correctedMistakes,
        uncorrectedMistakes,
        totalErrors,
        completedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TypingTest &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.language == this.language &&
          other.testType == this.testType &&
          other.paragraphId == this.paragraphId &&
          other.durationSeconds == this.durationSeconds &&
          other.actualDurationSeconds == this.actualDurationSeconds &&
          other.grossWpm == this.grossWpm &&
          other.netWpm == this.netWpm &&
          other.accuracy == this.accuracy &&
          other.keystrokeAccuracy == this.keystrokeAccuracy &&
          other.correctCharacters == this.correctCharacters &&
          other.wrongCharacters == this.wrongCharacters &&
          other.correctWords == this.correctWords &&
          other.wrongWords == this.wrongWords &&
          other.skippedWords == this.skippedWords &&
          other.backspaces == this.backspaces &&
          other.correctedMistakes == this.correctedMistakes &&
          other.uncorrectedMistakes == this.uncorrectedMistakes &&
          other.totalErrors == this.totalErrors &&
          other.completedAt == this.completedAt);
}

class TypingTestsCompanion extends UpdateCompanion<TypingTest> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> language;
  final Value<String> testType;
  final Value<int?> paragraphId;
  final Value<int?> durationSeconds;
  final Value<int> actualDurationSeconds;
  final Value<double> grossWpm;
  final Value<double> netWpm;
  final Value<double> accuracy;
  final Value<double> keystrokeAccuracy;
  final Value<int> correctCharacters;
  final Value<int> wrongCharacters;
  final Value<int> correctWords;
  final Value<int> wrongWords;
  final Value<int> skippedWords;
  final Value<int> backspaces;
  final Value<int> correctedMistakes;
  final Value<int> uncorrectedMistakes;
  final Value<int> totalErrors;
  final Value<DateTime> completedAt;
  const TypingTestsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.language = const Value.absent(),
    this.testType = const Value.absent(),
    this.paragraphId = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.actualDurationSeconds = const Value.absent(),
    this.grossWpm = const Value.absent(),
    this.netWpm = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.keystrokeAccuracy = const Value.absent(),
    this.correctCharacters = const Value.absent(),
    this.wrongCharacters = const Value.absent(),
    this.correctWords = const Value.absent(),
    this.wrongWords = const Value.absent(),
    this.skippedWords = const Value.absent(),
    this.backspaces = const Value.absent(),
    this.correctedMistakes = const Value.absent(),
    this.uncorrectedMistakes = const Value.absent(),
    this.totalErrors = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  TypingTestsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String language,
    required String testType,
    this.paragraphId = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    required int actualDurationSeconds,
    required double grossWpm,
    required double netWpm,
    required double accuracy,
    this.keystrokeAccuracy = const Value.absent(),
    required int correctCharacters,
    required int wrongCharacters,
    required int correctWords,
    required int wrongWords,
    required int skippedWords,
    this.backspaces = const Value.absent(),
    this.correctedMistakes = const Value.absent(),
    this.uncorrectedMistakes = const Value.absent(),
    required int totalErrors,
    this.completedAt = const Value.absent(),
  })  : userId = Value(userId),
        language = Value(language),
        testType = Value(testType),
        actualDurationSeconds = Value(actualDurationSeconds),
        grossWpm = Value(grossWpm),
        netWpm = Value(netWpm),
        accuracy = Value(accuracy),
        correctCharacters = Value(correctCharacters),
        wrongCharacters = Value(wrongCharacters),
        correctWords = Value(correctWords),
        wrongWords = Value(wrongWords),
        skippedWords = Value(skippedWords),
        totalErrors = Value(totalErrors);
  static Insertable<TypingTest> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? language,
    Expression<String>? testType,
    Expression<int>? paragraphId,
    Expression<int>? durationSeconds,
    Expression<int>? actualDurationSeconds,
    Expression<double>? grossWpm,
    Expression<double>? netWpm,
    Expression<double>? accuracy,
    Expression<double>? keystrokeAccuracy,
    Expression<int>? correctCharacters,
    Expression<int>? wrongCharacters,
    Expression<int>? correctWords,
    Expression<int>? wrongWords,
    Expression<int>? skippedWords,
    Expression<int>? backspaces,
    Expression<int>? correctedMistakes,
    Expression<int>? uncorrectedMistakes,
    Expression<int>? totalErrors,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (language != null) 'language': language,
      if (testType != null) 'test_type': testType,
      if (paragraphId != null) 'paragraph_id': paragraphId,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (actualDurationSeconds != null)
        'actual_duration_seconds': actualDurationSeconds,
      if (grossWpm != null) 'gross_wpm': grossWpm,
      if (netWpm != null) 'net_wpm': netWpm,
      if (accuracy != null) 'accuracy': accuracy,
      if (keystrokeAccuracy != null) 'keystroke_accuracy': keystrokeAccuracy,
      if (correctCharacters != null) 'correct_characters': correctCharacters,
      if (wrongCharacters != null) 'wrong_characters': wrongCharacters,
      if (correctWords != null) 'correct_words': correctWords,
      if (wrongWords != null) 'wrong_words': wrongWords,
      if (skippedWords != null) 'skipped_words': skippedWords,
      if (backspaces != null) 'backspaces': backspaces,
      if (correctedMistakes != null) 'corrected_mistakes': correctedMistakes,
      if (uncorrectedMistakes != null)
        'uncorrected_mistakes': uncorrectedMistakes,
      if (totalErrors != null) 'total_errors': totalErrors,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  TypingTestsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? language,
      Value<String>? testType,
      Value<int?>? paragraphId,
      Value<int?>? durationSeconds,
      Value<int>? actualDurationSeconds,
      Value<double>? grossWpm,
      Value<double>? netWpm,
      Value<double>? accuracy,
      Value<double>? keystrokeAccuracy,
      Value<int>? correctCharacters,
      Value<int>? wrongCharacters,
      Value<int>? correctWords,
      Value<int>? wrongWords,
      Value<int>? skippedWords,
      Value<int>? backspaces,
      Value<int>? correctedMistakes,
      Value<int>? uncorrectedMistakes,
      Value<int>? totalErrors,
      Value<DateTime>? completedAt}) {
    return TypingTestsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      language: language ?? this.language,
      testType: testType ?? this.testType,
      paragraphId: paragraphId ?? this.paragraphId,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      actualDurationSeconds:
          actualDurationSeconds ?? this.actualDurationSeconds,
      grossWpm: grossWpm ?? this.grossWpm,
      netWpm: netWpm ?? this.netWpm,
      accuracy: accuracy ?? this.accuracy,
      keystrokeAccuracy: keystrokeAccuracy ?? this.keystrokeAccuracy,
      correctCharacters: correctCharacters ?? this.correctCharacters,
      wrongCharacters: wrongCharacters ?? this.wrongCharacters,
      correctWords: correctWords ?? this.correctWords,
      wrongWords: wrongWords ?? this.wrongWords,
      skippedWords: skippedWords ?? this.skippedWords,
      backspaces: backspaces ?? this.backspaces,
      correctedMistakes: correctedMistakes ?? this.correctedMistakes,
      uncorrectedMistakes: uncorrectedMistakes ?? this.uncorrectedMistakes,
      totalErrors: totalErrors ?? this.totalErrors,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (testType.present) {
      map['test_type'] = Variable<String>(testType.value);
    }
    if (paragraphId.present) {
      map['paragraph_id'] = Variable<int>(paragraphId.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (actualDurationSeconds.present) {
      map['actual_duration_seconds'] =
          Variable<int>(actualDurationSeconds.value);
    }
    if (grossWpm.present) {
      map['gross_wpm'] = Variable<double>(grossWpm.value);
    }
    if (netWpm.present) {
      map['net_wpm'] = Variable<double>(netWpm.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (keystrokeAccuracy.present) {
      map['keystroke_accuracy'] = Variable<double>(keystrokeAccuracy.value);
    }
    if (correctCharacters.present) {
      map['correct_characters'] = Variable<int>(correctCharacters.value);
    }
    if (wrongCharacters.present) {
      map['wrong_characters'] = Variable<int>(wrongCharacters.value);
    }
    if (correctWords.present) {
      map['correct_words'] = Variable<int>(correctWords.value);
    }
    if (wrongWords.present) {
      map['wrong_words'] = Variable<int>(wrongWords.value);
    }
    if (skippedWords.present) {
      map['skipped_words'] = Variable<int>(skippedWords.value);
    }
    if (backspaces.present) {
      map['backspaces'] = Variable<int>(backspaces.value);
    }
    if (correctedMistakes.present) {
      map['corrected_mistakes'] = Variable<int>(correctedMistakes.value);
    }
    if (uncorrectedMistakes.present) {
      map['uncorrected_mistakes'] = Variable<int>(uncorrectedMistakes.value);
    }
    if (totalErrors.present) {
      map['total_errors'] = Variable<int>(totalErrors.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TypingTestsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('language: $language, ')
          ..write('testType: $testType, ')
          ..write('paragraphId: $paragraphId, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('actualDurationSeconds: $actualDurationSeconds, ')
          ..write('grossWpm: $grossWpm, ')
          ..write('netWpm: $netWpm, ')
          ..write('accuracy: $accuracy, ')
          ..write('keystrokeAccuracy: $keystrokeAccuracy, ')
          ..write('correctCharacters: $correctCharacters, ')
          ..write('wrongCharacters: $wrongCharacters, ')
          ..write('correctWords: $correctWords, ')
          ..write('wrongWords: $wrongWords, ')
          ..write('skippedWords: $skippedWords, ')
          ..write('backspaces: $backspaces, ')
          ..write('correctedMistakes: $correctedMistakes, ')
          ..write('uncorrectedMistakes: $uncorrectedMistakes, ')
          ..write('totalErrors: $totalErrors, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, Lesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _requiredAccuracyMeta =
      const VerificationMeta('requiredAccuracy');
  @override
  late final GeneratedColumn<double> requiredAccuracy = GeneratedColumn<double>(
      'required_accuracy', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(90));
  static const VerificationMeta _requiredWpmMeta =
      const VerificationMeta('requiredWpm');
  @override
  late final GeneratedColumn<int> requiredWpm = GeneratedColumn<int>(
      'required_wpm', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
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
        title,
        language,
        level,
        orderIndex,
        content,
        requiredAccuracy,
        requiredWpm,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(Insertable<Lesson> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('required_accuracy')) {
      context.handle(
          _requiredAccuracyMeta,
          requiredAccuracy.isAcceptableOrUnknown(
              data['required_accuracy']!, _requiredAccuracyMeta));
    }
    if (data.containsKey('required_wpm')) {
      context.handle(
          _requiredWpmMeta,
          requiredWpm.isAcceptableOrUnknown(
              data['required_wpm']!, _requiredWpmMeta));
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
  Lesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lesson(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      requiredAccuracy: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}required_accuracy'])!,
      requiredWpm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}required_wpm'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class Lesson extends DataClass implements Insertable<Lesson> {
  final int id;
  final String title;

  /// 'en' or 'ur'
  final String language;

  /// 'beginner' | 'intermediate' | 'advanced'
  final String level;

  /// Determines lesson order and unlock sequence within a language+level.
  final int orderIndex;

  /// The exercise text(s) for this lesson. Stored as plain text; multiple
  /// drills can be newline-separated and parsed by LessonController.
  final String content;
  final double requiredAccuracy;
  final int requiredWpm;
  final DateTime createdAt;
  const Lesson(
      {required this.id,
      required this.title,
      required this.language,
      required this.level,
      required this.orderIndex,
      required this.content,
      required this.requiredAccuracy,
      required this.requiredWpm,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['language'] = Variable<String>(language);
    map['level'] = Variable<String>(level);
    map['order_index'] = Variable<int>(orderIndex);
    map['content'] = Variable<String>(content);
    map['required_accuracy'] = Variable<double>(requiredAccuracy);
    map['required_wpm'] = Variable<int>(requiredWpm);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      title: Value(title),
      language: Value(language),
      level: Value(level),
      orderIndex: Value(orderIndex),
      content: Value(content),
      requiredAccuracy: Value(requiredAccuracy),
      requiredWpm: Value(requiredWpm),
      createdAt: Value(createdAt),
    );
  }

  factory Lesson.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lesson(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      language: serializer.fromJson<String>(json['language']),
      level: serializer.fromJson<String>(json['level']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      content: serializer.fromJson<String>(json['content']),
      requiredAccuracy: serializer.fromJson<double>(json['requiredAccuracy']),
      requiredWpm: serializer.fromJson<int>(json['requiredWpm']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'language': serializer.toJson<String>(language),
      'level': serializer.toJson<String>(level),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'content': serializer.toJson<String>(content),
      'requiredAccuracy': serializer.toJson<double>(requiredAccuracy),
      'requiredWpm': serializer.toJson<int>(requiredWpm),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Lesson copyWith(
          {int? id,
          String? title,
          String? language,
          String? level,
          int? orderIndex,
          String? content,
          double? requiredAccuracy,
          int? requiredWpm,
          DateTime? createdAt}) =>
      Lesson(
        id: id ?? this.id,
        title: title ?? this.title,
        language: language ?? this.language,
        level: level ?? this.level,
        orderIndex: orderIndex ?? this.orderIndex,
        content: content ?? this.content,
        requiredAccuracy: requiredAccuracy ?? this.requiredAccuracy,
        requiredWpm: requiredWpm ?? this.requiredWpm,
        createdAt: createdAt ?? this.createdAt,
      );
  Lesson copyWithCompanion(LessonsCompanion data) {
    return Lesson(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      language: data.language.present ? data.language.value : this.language,
      level: data.level.present ? data.level.value : this.level,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      content: data.content.present ? data.content.value : this.content,
      requiredAccuracy: data.requiredAccuracy.present
          ? data.requiredAccuracy.value
          : this.requiredAccuracy,
      requiredWpm:
          data.requiredWpm.present ? data.requiredWpm.value : this.requiredWpm,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lesson(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('level: $level, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('content: $content, ')
          ..write('requiredAccuracy: $requiredAccuracy, ')
          ..write('requiredWpm: $requiredWpm, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, language, level, orderIndex,
      content, requiredAccuracy, requiredWpm, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lesson &&
          other.id == this.id &&
          other.title == this.title &&
          other.language == this.language &&
          other.level == this.level &&
          other.orderIndex == this.orderIndex &&
          other.content == this.content &&
          other.requiredAccuracy == this.requiredAccuracy &&
          other.requiredWpm == this.requiredWpm &&
          other.createdAt == this.createdAt);
}

class LessonsCompanion extends UpdateCompanion<Lesson> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> language;
  final Value<String> level;
  final Value<int> orderIndex;
  final Value<String> content;
  final Value<double> requiredAccuracy;
  final Value<int> requiredWpm;
  final Value<DateTime> createdAt;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.language = const Value.absent(),
    this.level = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.content = const Value.absent(),
    this.requiredAccuracy = const Value.absent(),
    this.requiredWpm = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LessonsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String language,
    required String level,
    required int orderIndex,
    required String content,
    this.requiredAccuracy = const Value.absent(),
    this.requiredWpm = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : title = Value(title),
        language = Value(language),
        level = Value(level),
        orderIndex = Value(orderIndex),
        content = Value(content);
  static Insertable<Lesson> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? language,
    Expression<String>? level,
    Expression<int>? orderIndex,
    Expression<String>? content,
    Expression<double>? requiredAccuracy,
    Expression<int>? requiredWpm,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (language != null) 'language': language,
      if (level != null) 'level': level,
      if (orderIndex != null) 'order_index': orderIndex,
      if (content != null) 'content': content,
      if (requiredAccuracy != null) 'required_accuracy': requiredAccuracy,
      if (requiredWpm != null) 'required_wpm': requiredWpm,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LessonsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? language,
      Value<String>? level,
      Value<int>? orderIndex,
      Value<String>? content,
      Value<double>? requiredAccuracy,
      Value<int>? requiredWpm,
      Value<DateTime>? createdAt}) {
    return LessonsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      level: level ?? this.level,
      orderIndex: orderIndex ?? this.orderIndex,
      content: content ?? this.content,
      requiredAccuracy: requiredAccuracy ?? this.requiredAccuracy,
      requiredWpm: requiredWpm ?? this.requiredWpm,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (requiredAccuracy.present) {
      map['required_accuracy'] = Variable<double>(requiredAccuracy.value);
    }
    if (requiredWpm.present) {
      map['required_wpm'] = Variable<int>(requiredWpm.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('level: $level, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('content: $content, ')
          ..write('requiredAccuracy: $requiredAccuracy, ')
          ..write('requiredWpm: $requiredWpm, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressTable extends LessonProgress
    with TableInfo<$LessonProgressTable, LessonProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES lessons (id)'));
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bestAccuracyMeta =
      const VerificationMeta('bestAccuracy');
  @override
  late final GeneratedColumn<double> bestAccuracy = GeneratedColumn<double>(
      'best_accuracy', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _bestSpeedMeta =
      const VerificationMeta('bestSpeed');
  @override
  late final GeneratedColumn<double> bestSpeed = GeneratedColumn<double>(
      'best_speed', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastAttemptAtMeta =
      const VerificationMeta('lastAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>('last_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        lessonId,
        completed,
        bestAccuracy,
        bestSpeed,
        attempts,
        lastAttemptAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress';
  @override
  VerificationContext validateIntegrity(Insertable<LessonProgressData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('best_accuracy')) {
      context.handle(
          _bestAccuracyMeta,
          bestAccuracy.isAcceptableOrUnknown(
              data['best_accuracy']!, _bestAccuracyMeta));
    }
    if (data.containsKey('best_speed')) {
      context.handle(_bestSpeedMeta,
          bestSpeed.isAcceptableOrUnknown(data['best_speed']!, _bestSpeedMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
          _lastAttemptAtMeta,
          lastAttemptAt.isAcceptableOrUnknown(
              data['last_attempt_at']!, _lastAttemptAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {userId, lessonId},
      ];
  @override
  LessonProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lesson_id'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      bestAccuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}best_accuracy'])!,
      bestSpeed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}best_speed'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_attempt_at']),
    );
  }

  @override
  $LessonProgressTable createAlias(String alias) {
    return $LessonProgressTable(attachedDatabase, alias);
  }
}

class LessonProgressData extends DataClass
    implements Insertable<LessonProgressData> {
  final int id;
  final int userId;
  final int lessonId;
  final bool completed;
  final double bestAccuracy;
  final double bestSpeed;
  final int attempts;
  final DateTime? lastAttemptAt;
  const LessonProgressData(
      {required this.id,
      required this.userId,
      required this.lessonId,
      required this.completed,
      required this.bestAccuracy,
      required this.bestSpeed,
      required this.attempts,
      this.lastAttemptAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['lesson_id'] = Variable<int>(lessonId);
    map['completed'] = Variable<bool>(completed);
    map['best_accuracy'] = Variable<double>(bestAccuracy);
    map['best_speed'] = Variable<double>(bestSpeed);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    return map;
  }

  LessonProgressCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressCompanion(
      id: Value(id),
      userId: Value(userId),
      lessonId: Value(lessonId),
      completed: Value(completed),
      bestAccuracy: Value(bestAccuracy),
      bestSpeed: Value(bestSpeed),
      attempts: Value(attempts),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
    );
  }

  factory LessonProgressData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      completed: serializer.fromJson<bool>(json['completed']),
      bestAccuracy: serializer.fromJson<double>(json['bestAccuracy']),
      bestSpeed: serializer.fromJson<double>(json['bestSpeed']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'lessonId': serializer.toJson<int>(lessonId),
      'completed': serializer.toJson<bool>(completed),
      'bestAccuracy': serializer.toJson<double>(bestAccuracy),
      'bestSpeed': serializer.toJson<double>(bestSpeed),
      'attempts': serializer.toJson<int>(attempts),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
    };
  }

  LessonProgressData copyWith(
          {int? id,
          int? userId,
          int? lessonId,
          bool? completed,
          double? bestAccuracy,
          double? bestSpeed,
          int? attempts,
          Value<DateTime?> lastAttemptAt = const Value.absent()}) =>
      LessonProgressData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        lessonId: lessonId ?? this.lessonId,
        completed: completed ?? this.completed,
        bestAccuracy: bestAccuracy ?? this.bestAccuracy,
        bestSpeed: bestSpeed ?? this.bestSpeed,
        attempts: attempts ?? this.attempts,
        lastAttemptAt:
            lastAttemptAt.present ? lastAttemptAt.value : this.lastAttemptAt,
      );
  LessonProgressData copyWithCompanion(LessonProgressCompanion data) {
    return LessonProgressData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      completed: data.completed.present ? data.completed.value : this.completed,
      bestAccuracy: data.bestAccuracy.present
          ? data.bestAccuracy.value
          : this.bestAccuracy,
      bestSpeed: data.bestSpeed.present ? data.bestSpeed.value : this.bestSpeed,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('lessonId: $lessonId, ')
          ..write('completed: $completed, ')
          ..write('bestAccuracy: $bestAccuracy, ')
          ..write('bestSpeed: $bestSpeed, ')
          ..write('attempts: $attempts, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, lessonId, completed, bestAccuracy,
      bestSpeed, attempts, lastAttemptAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.lessonId == this.lessonId &&
          other.completed == this.completed &&
          other.bestAccuracy == this.bestAccuracy &&
          other.bestSpeed == this.bestSpeed &&
          other.attempts == this.attempts &&
          other.lastAttemptAt == this.lastAttemptAt);
}

class LessonProgressCompanion extends UpdateCompanion<LessonProgressData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> lessonId;
  final Value<bool> completed;
  final Value<double> bestAccuracy;
  final Value<double> bestSpeed;
  final Value<int> attempts;
  final Value<DateTime?> lastAttemptAt;
  const LessonProgressCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.completed = const Value.absent(),
    this.bestAccuracy = const Value.absent(),
    this.bestSpeed = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
  });
  LessonProgressCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int lessonId,
    this.completed = const Value.absent(),
    this.bestAccuracy = const Value.absent(),
    this.bestSpeed = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
  })  : userId = Value(userId),
        lessonId = Value(lessonId);
  static Insertable<LessonProgressData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? lessonId,
    Expression<bool>? completed,
    Expression<double>? bestAccuracy,
    Expression<double>? bestSpeed,
    Expression<int>? attempts,
    Expression<DateTime>? lastAttemptAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (completed != null) 'completed': completed,
      if (bestAccuracy != null) 'best_accuracy': bestAccuracy,
      if (bestSpeed != null) 'best_speed': bestSpeed,
      if (attempts != null) 'attempts': attempts,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
    });
  }

  LessonProgressCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? lessonId,
      Value<bool>? completed,
      Value<double>? bestAccuracy,
      Value<double>? bestSpeed,
      Value<int>? attempts,
      Value<DateTime?>? lastAttemptAt}) {
    return LessonProgressCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      completed: completed ?? this.completed,
      bestAccuracy: bestAccuracy ?? this.bestAccuracy,
      bestSpeed: bestSpeed ?? this.bestSpeed,
      attempts: attempts ?? this.attempts,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (bestAccuracy.present) {
      map['best_accuracy'] = Variable<double>(bestAccuracy.value);
    }
    if (bestSpeed.present) {
      map['best_speed'] = Variable<double>(bestSpeed.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('lessonId: $lessonId, ')
          ..write('completed: $completed, ')
          ..write('bestAccuracy: $bestAccuracy, ')
          ..write('bestSpeed: $bestSpeed, ')
          ..write('attempts: $attempts, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }
}

class $MistakesTable extends Mistakes with TableInfo<$MistakesTable, Mistake> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MistakesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _testIdMeta = const VerificationMeta('testId');
  @override
  late final GeneratedColumn<int> testId = GeneratedColumn<int>(
      'test_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES typing_tests (id)'));
  static const VerificationMeta _expectedCharacterMeta =
      const VerificationMeta('expectedCharacter');
  @override
  late final GeneratedColumn<String> expectedCharacter =
      GeneratedColumn<String>('expected_character', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typedCharacterMeta =
      const VerificationMeta('typedCharacter');
  @override
  late final GeneratedColumn<String> typedCharacter = GeneratedColumn<String>(
      'typed_character', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wordIndexMeta =
      const VerificationMeta('wordIndex');
  @override
  late final GeneratedColumn<int> wordIndex = GeneratedColumn<int>(
      'word_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isSkippedWordMeta =
      const VerificationMeta('isSkippedWord');
  @override
  late final GeneratedColumn<bool> isSkippedWord = GeneratedColumn<bool>(
      'is_skipped_word', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_skipped_word" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isWrongWordMeta =
      const VerificationMeta('isWrongWord');
  @override
  late final GeneratedColumn<bool> isWrongWord = GeneratedColumn<bool>(
      'is_wrong_word', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_wrong_word" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        testId,
        expectedCharacter,
        typedCharacter,
        count,
        position,
        wordIndex,
        isSkippedWord,
        isWrongWord
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mistakes';
  @override
  VerificationContext validateIntegrity(Insertable<Mistake> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('test_id')) {
      context.handle(_testIdMeta,
          testId.isAcceptableOrUnknown(data['test_id']!, _testIdMeta));
    } else if (isInserting) {
      context.missing(_testIdMeta);
    }
    if (data.containsKey('expected_character')) {
      context.handle(
          _expectedCharacterMeta,
          expectedCharacter.isAcceptableOrUnknown(
              data['expected_character']!, _expectedCharacterMeta));
    } else if (isInserting) {
      context.missing(_expectedCharacterMeta);
    }
    if (data.containsKey('typed_character')) {
      context.handle(
          _typedCharacterMeta,
          typedCharacter.isAcceptableOrUnknown(
              data['typed_character']!, _typedCharacterMeta));
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('word_index')) {
      context.handle(_wordIndexMeta,
          wordIndex.isAcceptableOrUnknown(data['word_index']!, _wordIndexMeta));
    } else if (isInserting) {
      context.missing(_wordIndexMeta);
    }
    if (data.containsKey('is_skipped_word')) {
      context.handle(
          _isSkippedWordMeta,
          isSkippedWord.isAcceptableOrUnknown(
              data['is_skipped_word']!, _isSkippedWordMeta));
    }
    if (data.containsKey('is_wrong_word')) {
      context.handle(
          _isWrongWordMeta,
          isWrongWord.isAcceptableOrUnknown(
              data['is_wrong_word']!, _isWrongWordMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mistake map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mistake(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      testId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}test_id'])!,
      expectedCharacter: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}expected_character'])!,
      typedCharacter: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}typed_character'])!,
      count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      wordIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}word_index'])!,
      isSkippedWord: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_skipped_word'])!,
      isWrongWord: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_wrong_word'])!,
    );
  }

  @override
  $MistakesTable createAlias(String alias) {
    return $MistakesTable(attachedDatabase, alias);
  }
}

class Mistake extends DataClass implements Insertable<Mistake> {
  final int id;
  final int testId;

  /// The character the user was supposed to type.
  final String expectedCharacter;

  /// What the user actually typed instead (empty string for a skipped
  /// character within a skipped word).
  final String typedCharacter;

  /// How many times this exact expected/typed pair occurred in this test.
  final int count;

  /// Character position within the target paragraph.
  final int position;

  /// Index of the word this character belongs to.
  final int wordIndex;

  /// True when this row represents an entire skipped word rather than a
  /// single wrong character.
  final bool isSkippedWord;

  /// True when this row represents an entire wrong (typed but incorrect)
  /// word rather than a single wrong character. Added alongside
  /// [isSkippedWord] so Word Mistake Analysis can tell which target word
  /// text a user actually got wrong — schemaVersion 2 (see app_database.dart).
  final bool isWrongWord;
  const Mistake(
      {required this.id,
      required this.testId,
      required this.expectedCharacter,
      required this.typedCharacter,
      required this.count,
      required this.position,
      required this.wordIndex,
      required this.isSkippedWord,
      required this.isWrongWord});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['test_id'] = Variable<int>(testId);
    map['expected_character'] = Variable<String>(expectedCharacter);
    map['typed_character'] = Variable<String>(typedCharacter);
    map['count'] = Variable<int>(count);
    map['position'] = Variable<int>(position);
    map['word_index'] = Variable<int>(wordIndex);
    map['is_skipped_word'] = Variable<bool>(isSkippedWord);
    map['is_wrong_word'] = Variable<bool>(isWrongWord);
    return map;
  }

  MistakesCompanion toCompanion(bool nullToAbsent) {
    return MistakesCompanion(
      id: Value(id),
      testId: Value(testId),
      expectedCharacter: Value(expectedCharacter),
      typedCharacter: Value(typedCharacter),
      count: Value(count),
      position: Value(position),
      wordIndex: Value(wordIndex),
      isSkippedWord: Value(isSkippedWord),
      isWrongWord: Value(isWrongWord),
    );
  }

  factory Mistake.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mistake(
      id: serializer.fromJson<int>(json['id']),
      testId: serializer.fromJson<int>(json['testId']),
      expectedCharacter: serializer.fromJson<String>(json['expectedCharacter']),
      typedCharacter: serializer.fromJson<String>(json['typedCharacter']),
      count: serializer.fromJson<int>(json['count']),
      position: serializer.fromJson<int>(json['position']),
      wordIndex: serializer.fromJson<int>(json['wordIndex']),
      isSkippedWord: serializer.fromJson<bool>(json['isSkippedWord']),
      isWrongWord: serializer.fromJson<bool>(json['isWrongWord']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'testId': serializer.toJson<int>(testId),
      'expectedCharacter': serializer.toJson<String>(expectedCharacter),
      'typedCharacter': serializer.toJson<String>(typedCharacter),
      'count': serializer.toJson<int>(count),
      'position': serializer.toJson<int>(position),
      'wordIndex': serializer.toJson<int>(wordIndex),
      'isSkippedWord': serializer.toJson<bool>(isSkippedWord),
      'isWrongWord': serializer.toJson<bool>(isWrongWord),
    };
  }

  Mistake copyWith(
          {int? id,
          int? testId,
          String? expectedCharacter,
          String? typedCharacter,
          int? count,
          int? position,
          int? wordIndex,
          bool? isSkippedWord,
          bool? isWrongWord}) =>
      Mistake(
        id: id ?? this.id,
        testId: testId ?? this.testId,
        expectedCharacter: expectedCharacter ?? this.expectedCharacter,
        typedCharacter: typedCharacter ?? this.typedCharacter,
        count: count ?? this.count,
        position: position ?? this.position,
        wordIndex: wordIndex ?? this.wordIndex,
        isSkippedWord: isSkippedWord ?? this.isSkippedWord,
        isWrongWord: isWrongWord ?? this.isWrongWord,
      );
  Mistake copyWithCompanion(MistakesCompanion data) {
    return Mistake(
      id: data.id.present ? data.id.value : this.id,
      testId: data.testId.present ? data.testId.value : this.testId,
      expectedCharacter: data.expectedCharacter.present
          ? data.expectedCharacter.value
          : this.expectedCharacter,
      typedCharacter: data.typedCharacter.present
          ? data.typedCharacter.value
          : this.typedCharacter,
      count: data.count.present ? data.count.value : this.count,
      position: data.position.present ? data.position.value : this.position,
      wordIndex: data.wordIndex.present ? data.wordIndex.value : this.wordIndex,
      isSkippedWord: data.isSkippedWord.present
          ? data.isSkippedWord.value
          : this.isSkippedWord,
      isWrongWord:
          data.isWrongWord.present ? data.isWrongWord.value : this.isWrongWord,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mistake(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('expectedCharacter: $expectedCharacter, ')
          ..write('typedCharacter: $typedCharacter, ')
          ..write('count: $count, ')
          ..write('position: $position, ')
          ..write('wordIndex: $wordIndex, ')
          ..write('isSkippedWord: $isSkippedWord, ')
          ..write('isWrongWord: $isWrongWord')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, testId, expectedCharacter, typedCharacter,
      count, position, wordIndex, isSkippedWord, isWrongWord);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mistake &&
          other.id == this.id &&
          other.testId == this.testId &&
          other.expectedCharacter == this.expectedCharacter &&
          other.typedCharacter == this.typedCharacter &&
          other.count == this.count &&
          other.position == this.position &&
          other.wordIndex == this.wordIndex &&
          other.isSkippedWord == this.isSkippedWord &&
          other.isWrongWord == this.isWrongWord);
}

class MistakesCompanion extends UpdateCompanion<Mistake> {
  final Value<int> id;
  final Value<int> testId;
  final Value<String> expectedCharacter;
  final Value<String> typedCharacter;
  final Value<int> count;
  final Value<int> position;
  final Value<int> wordIndex;
  final Value<bool> isSkippedWord;
  final Value<bool> isWrongWord;
  const MistakesCompanion({
    this.id = const Value.absent(),
    this.testId = const Value.absent(),
    this.expectedCharacter = const Value.absent(),
    this.typedCharacter = const Value.absent(),
    this.count = const Value.absent(),
    this.position = const Value.absent(),
    this.wordIndex = const Value.absent(),
    this.isSkippedWord = const Value.absent(),
    this.isWrongWord = const Value.absent(),
  });
  MistakesCompanion.insert({
    this.id = const Value.absent(),
    required int testId,
    required String expectedCharacter,
    this.typedCharacter = const Value.absent(),
    this.count = const Value.absent(),
    required int position,
    required int wordIndex,
    this.isSkippedWord = const Value.absent(),
    this.isWrongWord = const Value.absent(),
  })  : testId = Value(testId),
        expectedCharacter = Value(expectedCharacter),
        position = Value(position),
        wordIndex = Value(wordIndex);
  static Insertable<Mistake> custom({
    Expression<int>? id,
    Expression<int>? testId,
    Expression<String>? expectedCharacter,
    Expression<String>? typedCharacter,
    Expression<int>? count,
    Expression<int>? position,
    Expression<int>? wordIndex,
    Expression<bool>? isSkippedWord,
    Expression<bool>? isWrongWord,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (testId != null) 'test_id': testId,
      if (expectedCharacter != null) 'expected_character': expectedCharacter,
      if (typedCharacter != null) 'typed_character': typedCharacter,
      if (count != null) 'count': count,
      if (position != null) 'position': position,
      if (wordIndex != null) 'word_index': wordIndex,
      if (isSkippedWord != null) 'is_skipped_word': isSkippedWord,
      if (isWrongWord != null) 'is_wrong_word': isWrongWord,
    });
  }

  MistakesCompanion copyWith(
      {Value<int>? id,
      Value<int>? testId,
      Value<String>? expectedCharacter,
      Value<String>? typedCharacter,
      Value<int>? count,
      Value<int>? position,
      Value<int>? wordIndex,
      Value<bool>? isSkippedWord,
      Value<bool>? isWrongWord}) {
    return MistakesCompanion(
      id: id ?? this.id,
      testId: testId ?? this.testId,
      expectedCharacter: expectedCharacter ?? this.expectedCharacter,
      typedCharacter: typedCharacter ?? this.typedCharacter,
      count: count ?? this.count,
      position: position ?? this.position,
      wordIndex: wordIndex ?? this.wordIndex,
      isSkippedWord: isSkippedWord ?? this.isSkippedWord,
      isWrongWord: isWrongWord ?? this.isWrongWord,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (testId.present) {
      map['test_id'] = Variable<int>(testId.value);
    }
    if (expectedCharacter.present) {
      map['expected_character'] = Variable<String>(expectedCharacter.value);
    }
    if (typedCharacter.present) {
      map['typed_character'] = Variable<String>(typedCharacter.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (wordIndex.present) {
      map['word_index'] = Variable<int>(wordIndex.value);
    }
    if (isSkippedWord.present) {
      map['is_skipped_word'] = Variable<bool>(isSkippedWord.value);
    }
    if (isWrongWord.present) {
      map['is_wrong_word'] = Variable<bool>(isWrongWord.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MistakesCompanion(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('expectedCharacter: $expectedCharacter, ')
          ..write('typedCharacter: $typedCharacter, ')
          ..write('count: $count, ')
          ..write('position: $position, ')
          ..write('wordIndex: $wordIndex, ')
          ..write('isSkippedWord: $isSkippedWord, ')
          ..write('isWrongWord: $isWrongWord')
          ..write(')'))
        .toString();
  }
}

class $DailyProgressTable extends DailyProgress
    with TableInfo<$DailyProgressTable, DailyProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _practiceSecondsMeta =
      const VerificationMeta('practiceSeconds');
  @override
  late final GeneratedColumn<int> practiceSeconds = GeneratedColumn<int>(
      'practice_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _testsCompletedMeta =
      const VerificationMeta('testsCompleted');
  @override
  late final GeneratedColumn<int> testsCompleted = GeneratedColumn<int>(
      'tests_completed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _goalSecondsMeta =
      const VerificationMeta('goalSeconds');
  @override
  late final GeneratedColumn<int> goalSeconds = GeneratedColumn<int>(
      'goal_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, date, practiceSeconds, testsCompleted, goalSeconds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_progress';
  @override
  VerificationContext validateIntegrity(Insertable<DailyProgressData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('practice_seconds')) {
      context.handle(
          _practiceSecondsMeta,
          practiceSeconds.isAcceptableOrUnknown(
              data['practice_seconds']!, _practiceSecondsMeta));
    }
    if (data.containsKey('tests_completed')) {
      context.handle(
          _testsCompletedMeta,
          testsCompleted.isAcceptableOrUnknown(
              data['tests_completed']!, _testsCompletedMeta));
    }
    if (data.containsKey('goal_seconds')) {
      context.handle(
          _goalSecondsMeta,
          goalSeconds.isAcceptableOrUnknown(
              data['goal_seconds']!, _goalSecondsMeta));
    } else if (isInserting) {
      context.missing(_goalSecondsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {userId, date},
      ];
  @override
  DailyProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyProgressData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      practiceSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}practice_seconds'])!,
      testsCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tests_completed'])!,
      goalSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goal_seconds'])!,
    );
  }

  @override
  $DailyProgressTable createAlias(String alias) {
    return $DailyProgressTable(attachedDatabase, alias);
  }
}

class DailyProgressData extends DataClass
    implements Insertable<DailyProgressData> {
  final int id;
  final int userId;

  /// Stored as a date-only DateTime (time truncated to midnight).
  final DateTime date;
  final int practiceSeconds;
  final int testsCompleted;
  final int goalSeconds;
  const DailyProgressData(
      {required this.id,
      required this.userId,
      required this.date,
      required this.practiceSeconds,
      required this.testsCompleted,
      required this.goalSeconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['date'] = Variable<DateTime>(date);
    map['practice_seconds'] = Variable<int>(practiceSeconds);
    map['tests_completed'] = Variable<int>(testsCompleted);
    map['goal_seconds'] = Variable<int>(goalSeconds);
    return map;
  }

  DailyProgressCompanion toCompanion(bool nullToAbsent) {
    return DailyProgressCompanion(
      id: Value(id),
      userId: Value(userId),
      date: Value(date),
      practiceSeconds: Value(practiceSeconds),
      testsCompleted: Value(testsCompleted),
      goalSeconds: Value(goalSeconds),
    );
  }

  factory DailyProgressData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyProgressData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      date: serializer.fromJson<DateTime>(json['date']),
      practiceSeconds: serializer.fromJson<int>(json['practiceSeconds']),
      testsCompleted: serializer.fromJson<int>(json['testsCompleted']),
      goalSeconds: serializer.fromJson<int>(json['goalSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'date': serializer.toJson<DateTime>(date),
      'practiceSeconds': serializer.toJson<int>(practiceSeconds),
      'testsCompleted': serializer.toJson<int>(testsCompleted),
      'goalSeconds': serializer.toJson<int>(goalSeconds),
    };
  }

  DailyProgressData copyWith(
          {int? id,
          int? userId,
          DateTime? date,
          int? practiceSeconds,
          int? testsCompleted,
          int? goalSeconds}) =>
      DailyProgressData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        date: date ?? this.date,
        practiceSeconds: practiceSeconds ?? this.practiceSeconds,
        testsCompleted: testsCompleted ?? this.testsCompleted,
        goalSeconds: goalSeconds ?? this.goalSeconds,
      );
  DailyProgressData copyWithCompanion(DailyProgressCompanion data) {
    return DailyProgressData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      practiceSeconds: data.practiceSeconds.present
          ? data.practiceSeconds.value
          : this.practiceSeconds,
      testsCompleted: data.testsCompleted.present
          ? data.testsCompleted.value
          : this.testsCompleted,
      goalSeconds:
          data.goalSeconds.present ? data.goalSeconds.value : this.goalSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyProgressData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('practiceSeconds: $practiceSeconds, ')
          ..write('testsCompleted: $testsCompleted, ')
          ..write('goalSeconds: $goalSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, date, practiceSeconds, testsCompleted, goalSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyProgressData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.practiceSeconds == this.practiceSeconds &&
          other.testsCompleted == this.testsCompleted &&
          other.goalSeconds == this.goalSeconds);
}

class DailyProgressCompanion extends UpdateCompanion<DailyProgressData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<DateTime> date;
  final Value<int> practiceSeconds;
  final Value<int> testsCompleted;
  final Value<int> goalSeconds;
  const DailyProgressCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.practiceSeconds = const Value.absent(),
    this.testsCompleted = const Value.absent(),
    this.goalSeconds = const Value.absent(),
  });
  DailyProgressCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required DateTime date,
    this.practiceSeconds = const Value.absent(),
    this.testsCompleted = const Value.absent(),
    required int goalSeconds,
  })  : userId = Value(userId),
        date = Value(date),
        goalSeconds = Value(goalSeconds);
  static Insertable<DailyProgressData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<DateTime>? date,
    Expression<int>? practiceSeconds,
    Expression<int>? testsCompleted,
    Expression<int>? goalSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (practiceSeconds != null) 'practice_seconds': practiceSeconds,
      if (testsCompleted != null) 'tests_completed': testsCompleted,
      if (goalSeconds != null) 'goal_seconds': goalSeconds,
    });
  }

  DailyProgressCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<DateTime>? date,
      Value<int>? practiceSeconds,
      Value<int>? testsCompleted,
      Value<int>? goalSeconds}) {
    return DailyProgressCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      practiceSeconds: practiceSeconds ?? this.practiceSeconds,
      testsCompleted: testsCompleted ?? this.testsCompleted,
      goalSeconds: goalSeconds ?? this.goalSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (practiceSeconds.present) {
      map['practice_seconds'] = Variable<int>(practiceSeconds.value);
    }
    if (testsCompleted.present) {
      map['tests_completed'] = Variable<int>(testsCompleted.value);
    }
    if (goalSeconds.present) {
      map['goal_seconds'] = Variable<int>(goalSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyProgressCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('practiceSeconds: $practiceSeconds, ')
          ..write('testsCompleted: $testsCompleted, ')
          ..write('goalSeconds: $goalSeconds')
          ..write(')'))
        .toString();
  }
}

class $StreaksTable extends Streaks with TableInfo<$StreaksTable, Streak> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _currentStreakMeta =
      const VerificationMeta('currentStreak');
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
      'current_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _longestStreakMeta =
      const VerificationMeta('longestStreak');
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
      'longest_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastPracticeDateMeta =
      const VerificationMeta('lastPracticeDate');
  @override
  late final GeneratedColumn<DateTime> lastPracticeDate =
      GeneratedColumn<DateTime>('last_practice_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, currentStreak, longestStreak, lastPracticeDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaks';
  @override
  VerificationContext validateIntegrity(Insertable<Streak> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('current_streak')) {
      context.handle(
          _currentStreakMeta,
          currentStreak.isAcceptableOrUnknown(
              data['current_streak']!, _currentStreakMeta));
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
          _longestStreakMeta,
          longestStreak.isAcceptableOrUnknown(
              data['longest_streak']!, _longestStreakMeta));
    }
    if (data.containsKey('last_practice_date')) {
      context.handle(
          _lastPracticeDateMeta,
          lastPracticeDate.isAcceptableOrUnknown(
              data['last_practice_date']!, _lastPracticeDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {userId},
      ];
  @override
  Streak map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Streak(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      currentStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_streak'])!,
      longestStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}longest_streak'])!,
      lastPracticeDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_practice_date']),
    );
  }

  @override
  $StreaksTable createAlias(String alias) {
    return $StreaksTable(attachedDatabase, alias);
  }
}

class Streak extends DataClass implements Insertable<Streak> {
  final int id;
  final int userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastPracticeDate;
  const Streak(
      {required this.id,
      required this.userId,
      required this.currentStreak,
      required this.longestStreak,
      this.lastPracticeDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    if (!nullToAbsent || lastPracticeDate != null) {
      map['last_practice_date'] = Variable<DateTime>(lastPracticeDate);
    }
    return map;
  }

  StreaksCompanion toCompanion(bool nullToAbsent) {
    return StreaksCompanion(
      id: Value(id),
      userId: Value(userId),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      lastPracticeDate: lastPracticeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPracticeDate),
    );
  }

  factory Streak.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Streak(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      lastPracticeDate:
          serializer.fromJson<DateTime?>(json['lastPracticeDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'lastPracticeDate': serializer.toJson<DateTime?>(lastPracticeDate),
    };
  }

  Streak copyWith(
          {int? id,
          int? userId,
          int? currentStreak,
          int? longestStreak,
          Value<DateTime?> lastPracticeDate = const Value.absent()}) =>
      Streak(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastPracticeDate: lastPracticeDate.present
            ? lastPracticeDate.value
            : this.lastPracticeDate,
      );
  Streak copyWithCompanion(StreaksCompanion data) {
    return Streak(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      lastPracticeDate: data.lastPracticeDate.present
          ? data.lastPracticeDate.value
          : this.lastPracticeDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Streak(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastPracticeDate: $lastPracticeDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, currentStreak, longestStreak, lastPracticeDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Streak &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.lastPracticeDate == this.lastPracticeDate);
}

class StreaksCompanion extends UpdateCompanion<Streak> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<DateTime?> lastPracticeDate;
  const StreaksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastPracticeDate = const Value.absent(),
  });
  StreaksCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastPracticeDate = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<Streak> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<DateTime>? lastPracticeDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (lastPracticeDate != null) 'last_practice_date': lastPracticeDate,
    });
  }

  StreaksCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? currentStreak,
      Value<int>? longestStreak,
      Value<DateTime?>? lastPracticeDate}) {
    return StreaksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastPracticeDate: lastPracticeDate ?? this.lastPracticeDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (lastPracticeDate.present) {
      map['last_practice_date'] = Variable<DateTime>(lastPracticeDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreaksCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastPracticeDate: $lastPracticeDate')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
      'theme', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('system'));
  static const VerificationMeta _showLiveWpmMeta =
      const VerificationMeta('showLiveWpm');
  @override
  late final GeneratedColumn<bool> showLiveWpm = GeneratedColumn<bool>(
      'show_live_wpm', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_live_wpm" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showLiveAccuracyMeta =
      const VerificationMeta('showLiveAccuracy');
  @override
  late final GeneratedColumn<bool> showLiveAccuracy = GeneratedColumn<bool>(
      'show_live_accuracy', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_live_accuracy" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showErrorsMeta =
      const VerificationMeta('showErrors');
  @override
  late final GeneratedColumn<bool> showErrors = GeneratedColumn<bool>(
      'show_errors', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_errors" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _autoScrollMeta =
      const VerificationMeta('autoScroll');
  @override
  late final GeneratedColumn<bool> autoScroll = GeneratedColumn<bool>(
      'auto_scroll', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("auto_scroll" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _countBackspacesMeta =
      const VerificationMeta('countBackspaces');
  @override
  late final GeneratedColumn<bool> countBackspaces = GeneratedColumn<bool>(
      'count_backspaces', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("count_backspaces" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _strictSkipDetectionMeta =
      const VerificationMeta('strictSkipDetection');
  @override
  late final GeneratedColumn<bool> strictSkipDetection = GeneratedColumn<bool>(
      'strict_skip_detection', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("strict_skip_detection" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _defaultTestDurationSecondsMeta =
      const VerificationMeta('defaultTestDurationSeconds');
  @override
  late final GeneratedColumn<int> defaultTestDurationSeconds =
      GeneratedColumn<int>('default_test_duration_seconds', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(60));
  static const VerificationMeta _defaultLanguageMeta =
      const VerificationMeta('defaultLanguage');
  @override
  late final GeneratedColumn<String> defaultLanguage = GeneratedColumn<String>(
      'default_language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('en'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        theme,
        showLiveWpm,
        showLiveAccuracy,
        showErrors,
        autoScroll,
        countBackspaces,
        strictSkipDetection,
        defaultTestDurationSeconds,
        defaultLanguage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('theme')) {
      context.handle(
          _themeMeta, theme.isAcceptableOrUnknown(data['theme']!, _themeMeta));
    }
    if (data.containsKey('show_live_wpm')) {
      context.handle(
          _showLiveWpmMeta,
          showLiveWpm.isAcceptableOrUnknown(
              data['show_live_wpm']!, _showLiveWpmMeta));
    }
    if (data.containsKey('show_live_accuracy')) {
      context.handle(
          _showLiveAccuracyMeta,
          showLiveAccuracy.isAcceptableOrUnknown(
              data['show_live_accuracy']!, _showLiveAccuracyMeta));
    }
    if (data.containsKey('show_errors')) {
      context.handle(
          _showErrorsMeta,
          showErrors.isAcceptableOrUnknown(
              data['show_errors']!, _showErrorsMeta));
    }
    if (data.containsKey('auto_scroll')) {
      context.handle(
          _autoScrollMeta,
          autoScroll.isAcceptableOrUnknown(
              data['auto_scroll']!, _autoScrollMeta));
    }
    if (data.containsKey('count_backspaces')) {
      context.handle(
          _countBackspacesMeta,
          countBackspaces.isAcceptableOrUnknown(
              data['count_backspaces']!, _countBackspacesMeta));
    }
    if (data.containsKey('strict_skip_detection')) {
      context.handle(
          _strictSkipDetectionMeta,
          strictSkipDetection.isAcceptableOrUnknown(
              data['strict_skip_detection']!, _strictSkipDetectionMeta));
    }
    if (data.containsKey('default_test_duration_seconds')) {
      context.handle(
          _defaultTestDurationSecondsMeta,
          defaultTestDurationSeconds.isAcceptableOrUnknown(
              data['default_test_duration_seconds']!,
              _defaultTestDurationSecondsMeta));
    }
    if (data.containsKey('default_language')) {
      context.handle(
          _defaultLanguageMeta,
          defaultLanguage.isAcceptableOrUnknown(
              data['default_language']!, _defaultLanguageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {userId},
      ];
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      theme: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme'])!,
      showLiveWpm: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_live_wpm'])!,
      showLiveAccuracy: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}show_live_accuracy'])!,
      showErrors: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_errors'])!,
      autoScroll: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}auto_scroll'])!,
      countBackspaces: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}count_backspaces'])!,
      strictSkipDetection: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}strict_skip_detection'])!,
      defaultTestDurationSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}default_test_duration_seconds'])!,
      defaultLanguage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}default_language'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final int userId;

  /// 'light' | 'dark' | 'system'
  final String theme;
  final bool showLiveWpm;
  final bool showLiveAccuracy;
  final bool showErrors;
  final bool autoScroll;
  final bool countBackspaces;

  /// When true, any incomplete word followed by Space is immediately
  /// counted as a skipped word (see Anti-Skip Logic spec). Kept
  /// configurable in case a softer mode is wanted later, but defaults on
  /// because the spec requires skips to never be silently ignored.
  final bool strictSkipDetection;
  final int defaultTestDurationSeconds;

  /// 'en' or 'ur'
  final String defaultLanguage;
  const Setting(
      {required this.id,
      required this.userId,
      required this.theme,
      required this.showLiveWpm,
      required this.showLiveAccuracy,
      required this.showErrors,
      required this.autoScroll,
      required this.countBackspaces,
      required this.strictSkipDetection,
      required this.defaultTestDurationSeconds,
      required this.defaultLanguage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['theme'] = Variable<String>(theme);
    map['show_live_wpm'] = Variable<bool>(showLiveWpm);
    map['show_live_accuracy'] = Variable<bool>(showLiveAccuracy);
    map['show_errors'] = Variable<bool>(showErrors);
    map['auto_scroll'] = Variable<bool>(autoScroll);
    map['count_backspaces'] = Variable<bool>(countBackspaces);
    map['strict_skip_detection'] = Variable<bool>(strictSkipDetection);
    map['default_test_duration_seconds'] =
        Variable<int>(defaultTestDurationSeconds);
    map['default_language'] = Variable<String>(defaultLanguage);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      userId: Value(userId),
      theme: Value(theme),
      showLiveWpm: Value(showLiveWpm),
      showLiveAccuracy: Value(showLiveAccuracy),
      showErrors: Value(showErrors),
      autoScroll: Value(autoScroll),
      countBackspaces: Value(countBackspaces),
      strictSkipDetection: Value(strictSkipDetection),
      defaultTestDurationSeconds: Value(defaultTestDurationSeconds),
      defaultLanguage: Value(defaultLanguage),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      theme: serializer.fromJson<String>(json['theme']),
      showLiveWpm: serializer.fromJson<bool>(json['showLiveWpm']),
      showLiveAccuracy: serializer.fromJson<bool>(json['showLiveAccuracy']),
      showErrors: serializer.fromJson<bool>(json['showErrors']),
      autoScroll: serializer.fromJson<bool>(json['autoScroll']),
      countBackspaces: serializer.fromJson<bool>(json['countBackspaces']),
      strictSkipDetection:
          serializer.fromJson<bool>(json['strictSkipDetection']),
      defaultTestDurationSeconds:
          serializer.fromJson<int>(json['defaultTestDurationSeconds']),
      defaultLanguage: serializer.fromJson<String>(json['defaultLanguage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'theme': serializer.toJson<String>(theme),
      'showLiveWpm': serializer.toJson<bool>(showLiveWpm),
      'showLiveAccuracy': serializer.toJson<bool>(showLiveAccuracy),
      'showErrors': serializer.toJson<bool>(showErrors),
      'autoScroll': serializer.toJson<bool>(autoScroll),
      'countBackspaces': serializer.toJson<bool>(countBackspaces),
      'strictSkipDetection': serializer.toJson<bool>(strictSkipDetection),
      'defaultTestDurationSeconds':
          serializer.toJson<int>(defaultTestDurationSeconds),
      'defaultLanguage': serializer.toJson<String>(defaultLanguage),
    };
  }

  Setting copyWith(
          {int? id,
          int? userId,
          String? theme,
          bool? showLiveWpm,
          bool? showLiveAccuracy,
          bool? showErrors,
          bool? autoScroll,
          bool? countBackspaces,
          bool? strictSkipDetection,
          int? defaultTestDurationSeconds,
          String? defaultLanguage}) =>
      Setting(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        theme: theme ?? this.theme,
        showLiveWpm: showLiveWpm ?? this.showLiveWpm,
        showLiveAccuracy: showLiveAccuracy ?? this.showLiveAccuracy,
        showErrors: showErrors ?? this.showErrors,
        autoScroll: autoScroll ?? this.autoScroll,
        countBackspaces: countBackspaces ?? this.countBackspaces,
        strictSkipDetection: strictSkipDetection ?? this.strictSkipDetection,
        defaultTestDurationSeconds:
            defaultTestDurationSeconds ?? this.defaultTestDurationSeconds,
        defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      theme: data.theme.present ? data.theme.value : this.theme,
      showLiveWpm:
          data.showLiveWpm.present ? data.showLiveWpm.value : this.showLiveWpm,
      showLiveAccuracy: data.showLiveAccuracy.present
          ? data.showLiveAccuracy.value
          : this.showLiveAccuracy,
      showErrors:
          data.showErrors.present ? data.showErrors.value : this.showErrors,
      autoScroll:
          data.autoScroll.present ? data.autoScroll.value : this.autoScroll,
      countBackspaces: data.countBackspaces.present
          ? data.countBackspaces.value
          : this.countBackspaces,
      strictSkipDetection: data.strictSkipDetection.present
          ? data.strictSkipDetection.value
          : this.strictSkipDetection,
      defaultTestDurationSeconds: data.defaultTestDurationSeconds.present
          ? data.defaultTestDurationSeconds.value
          : this.defaultTestDurationSeconds,
      defaultLanguage: data.defaultLanguage.present
          ? data.defaultLanguage.value
          : this.defaultLanguage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('theme: $theme, ')
          ..write('showLiveWpm: $showLiveWpm, ')
          ..write('showLiveAccuracy: $showLiveAccuracy, ')
          ..write('showErrors: $showErrors, ')
          ..write('autoScroll: $autoScroll, ')
          ..write('countBackspaces: $countBackspaces, ')
          ..write('strictSkipDetection: $strictSkipDetection, ')
          ..write('defaultTestDurationSeconds: $defaultTestDurationSeconds, ')
          ..write('defaultLanguage: $defaultLanguage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      theme,
      showLiveWpm,
      showLiveAccuracy,
      showErrors,
      autoScroll,
      countBackspaces,
      strictSkipDetection,
      defaultTestDurationSeconds,
      defaultLanguage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.theme == this.theme &&
          other.showLiveWpm == this.showLiveWpm &&
          other.showLiveAccuracy == this.showLiveAccuracy &&
          other.showErrors == this.showErrors &&
          other.autoScroll == this.autoScroll &&
          other.countBackspaces == this.countBackspaces &&
          other.strictSkipDetection == this.strictSkipDetection &&
          other.defaultTestDurationSeconds == this.defaultTestDurationSeconds &&
          other.defaultLanguage == this.defaultLanguage);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> theme;
  final Value<bool> showLiveWpm;
  final Value<bool> showLiveAccuracy;
  final Value<bool> showErrors;
  final Value<bool> autoScroll;
  final Value<bool> countBackspaces;
  final Value<bool> strictSkipDetection;
  final Value<int> defaultTestDurationSeconds;
  final Value<String> defaultLanguage;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.theme = const Value.absent(),
    this.showLiveWpm = const Value.absent(),
    this.showLiveAccuracy = const Value.absent(),
    this.showErrors = const Value.absent(),
    this.autoScroll = const Value.absent(),
    this.countBackspaces = const Value.absent(),
    this.strictSkipDetection = const Value.absent(),
    this.defaultTestDurationSeconds = const Value.absent(),
    this.defaultLanguage = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.theme = const Value.absent(),
    this.showLiveWpm = const Value.absent(),
    this.showLiveAccuracy = const Value.absent(),
    this.showErrors = const Value.absent(),
    this.autoScroll = const Value.absent(),
    this.countBackspaces = const Value.absent(),
    this.strictSkipDetection = const Value.absent(),
    this.defaultTestDurationSeconds = const Value.absent(),
    this.defaultLanguage = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? theme,
    Expression<bool>? showLiveWpm,
    Expression<bool>? showLiveAccuracy,
    Expression<bool>? showErrors,
    Expression<bool>? autoScroll,
    Expression<bool>? countBackspaces,
    Expression<bool>? strictSkipDetection,
    Expression<int>? defaultTestDurationSeconds,
    Expression<String>? defaultLanguage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (theme != null) 'theme': theme,
      if (showLiveWpm != null) 'show_live_wpm': showLiveWpm,
      if (showLiveAccuracy != null) 'show_live_accuracy': showLiveAccuracy,
      if (showErrors != null) 'show_errors': showErrors,
      if (autoScroll != null) 'auto_scroll': autoScroll,
      if (countBackspaces != null) 'count_backspaces': countBackspaces,
      if (strictSkipDetection != null)
        'strict_skip_detection': strictSkipDetection,
      if (defaultTestDurationSeconds != null)
        'default_test_duration_seconds': defaultTestDurationSeconds,
      if (defaultLanguage != null) 'default_language': defaultLanguage,
    });
  }

  SettingsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? theme,
      Value<bool>? showLiveWpm,
      Value<bool>? showLiveAccuracy,
      Value<bool>? showErrors,
      Value<bool>? autoScroll,
      Value<bool>? countBackspaces,
      Value<bool>? strictSkipDetection,
      Value<int>? defaultTestDurationSeconds,
      Value<String>? defaultLanguage}) {
    return SettingsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      showLiveWpm: showLiveWpm ?? this.showLiveWpm,
      showLiveAccuracy: showLiveAccuracy ?? this.showLiveAccuracy,
      showErrors: showErrors ?? this.showErrors,
      autoScroll: autoScroll ?? this.autoScroll,
      countBackspaces: countBackspaces ?? this.countBackspaces,
      strictSkipDetection: strictSkipDetection ?? this.strictSkipDetection,
      defaultTestDurationSeconds:
          defaultTestDurationSeconds ?? this.defaultTestDurationSeconds,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (showLiveWpm.present) {
      map['show_live_wpm'] = Variable<bool>(showLiveWpm.value);
    }
    if (showLiveAccuracy.present) {
      map['show_live_accuracy'] = Variable<bool>(showLiveAccuracy.value);
    }
    if (showErrors.present) {
      map['show_errors'] = Variable<bool>(showErrors.value);
    }
    if (autoScroll.present) {
      map['auto_scroll'] = Variable<bool>(autoScroll.value);
    }
    if (countBackspaces.present) {
      map['count_backspaces'] = Variable<bool>(countBackspaces.value);
    }
    if (strictSkipDetection.present) {
      map['strict_skip_detection'] = Variable<bool>(strictSkipDetection.value);
    }
    if (defaultTestDurationSeconds.present) {
      map['default_test_duration_seconds'] =
          Variable<int>(defaultTestDurationSeconds.value);
    }
    if (defaultLanguage.present) {
      map['default_language'] = Variable<String>(defaultLanguage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('theme: $theme, ')
          ..write('showLiveWpm: $showLiveWpm, ')
          ..write('showLiveAccuracy: $showLiveAccuracy, ')
          ..write('showErrors: $showErrors, ')
          ..write('autoScroll: $autoScroll, ')
          ..write('countBackspaces: $countBackspaces, ')
          ..write('strictSkipDetection: $strictSkipDetection, ')
          ..write('defaultTestDurationSeconds: $defaultTestDurationSeconds, ')
          ..write('defaultLanguage: $defaultLanguage')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ParagraphsTable paragraphs = $ParagraphsTable(this);
  late final $TypingTestsTable typingTests = $TypingTestsTable(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $LessonProgressTable lessonProgress = $LessonProgressTable(this);
  late final $MistakesTable mistakes = $MistakesTable(this);
  late final $DailyProgressTable dailyProgress = $DailyProgressTable(this);
  late final $StreaksTable streaks = $StreaksTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        paragraphs,
        typingTests,
        lessons,
        lessonProgress,
        mistakes,
        dailyProgress,
        streaks,
        settings
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> profileImage,
  Value<String> preferredLanguage,
  Value<int> dailyGoalSeconds,
  Value<int> preferredTestDurationSeconds,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> profileImage,
  Value<String> preferredLanguage,
  Value<int> dailyGoalSeconds,
  Value<int> preferredTestDurationSeconds,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TypingTestsTable, List<TypingTest>>
      _typingTestsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.typingTests,
              aliasName: 'users__id__typing_tests__user_id');

  $$TypingTestsTableProcessedTableManager get typingTestsRefs {
    final manager = $$TypingTestsTableTableManager($_db, $_db.typingTests)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_typingTestsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LessonProgressTable, List<LessonProgressData>>
      _lessonProgressRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.lessonProgress,
              aliasName: 'users__id__lesson_progress__user_id');

  $$LessonProgressTableProcessedTableManager get lessonProgressRefs {
    final manager = $$LessonProgressTableTableManager($_db, $_db.lessonProgress)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonProgressRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DailyProgressTable, List<DailyProgressData>>
      _dailyProgressRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.dailyProgress,
              aliasName: 'users__id__daily_progress__user_id');

  $$DailyProgressTableProcessedTableManager get dailyProgressRefs {
    final manager = $$DailyProgressTableTableManager($_db, $_db.dailyProgress)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dailyProgressRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StreaksTable, List<Streak>> _streaksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.streaks,
          aliasName: 'users__id__streaks__user_id');

  $$StreaksTableProcessedTableManager get streaksRefs {
    final manager = $$StreaksTableTableManager($_db, $_db.streaks)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_streaksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SettingsTable, List<Setting>> _settingsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.settings,
          aliasName: 'users__id__settings__user_id');

  $$SettingsTableProcessedTableManager get settingsRefs {
    final manager = $$SettingsTableTableManager($_db, $_db.settings)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_settingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get profileImage => $composableBuilder(
      column: $table.profileImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferredLanguage => $composableBuilder(
      column: $table.preferredLanguage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dailyGoalSeconds => $composableBuilder(
      column: $table.dailyGoalSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get preferredTestDurationSeconds => $composableBuilder(
      column: $table.preferredTestDurationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> typingTestsRefs(
      Expression<bool> Function($$TypingTestsTableFilterComposer f) f) {
    final $$TypingTestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.typingTests,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TypingTestsTableFilterComposer(
              $db: $db,
              $table: $db.typingTests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> lessonProgressRefs(
      Expression<bool> Function($$LessonProgressTableFilterComposer f) f) {
    final $$LessonProgressTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonProgress,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonProgressTableFilterComposer(
              $db: $db,
              $table: $db.lessonProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> dailyProgressRefs(
      Expression<bool> Function($$DailyProgressTableFilterComposer f) f) {
    final $$DailyProgressTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dailyProgress,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyProgressTableFilterComposer(
              $db: $db,
              $table: $db.dailyProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> streaksRefs(
      Expression<bool> Function($$StreaksTableFilterComposer f) f) {
    final $$StreaksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.streaks,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StreaksTableFilterComposer(
              $db: $db,
              $table: $db.streaks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> settingsRefs(
      Expression<bool> Function($$SettingsTableFilterComposer f) f) {
    final $$SettingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.settings,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SettingsTableFilterComposer(
              $db: $db,
              $table: $db.settings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get profileImage => $composableBuilder(
      column: $table.profileImage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferredLanguage => $composableBuilder(
      column: $table.preferredLanguage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dailyGoalSeconds => $composableBuilder(
      column: $table.dailyGoalSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get preferredTestDurationSeconds => $composableBuilder(
      column: $table.preferredTestDurationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
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

  GeneratedColumn<String> get profileImage => $composableBuilder(
      column: $table.profileImage, builder: (column) => column);

  GeneratedColumn<String> get preferredLanguage => $composableBuilder(
      column: $table.preferredLanguage, builder: (column) => column);

  GeneratedColumn<int> get dailyGoalSeconds => $composableBuilder(
      column: $table.dailyGoalSeconds, builder: (column) => column);

  GeneratedColumn<int> get preferredTestDurationSeconds => $composableBuilder(
      column: $table.preferredTestDurationSeconds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> typingTestsRefs<T extends Object>(
      Expression<T> Function($$TypingTestsTableAnnotationComposer a) f) {
    final $$TypingTestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.typingTests,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TypingTestsTableAnnotationComposer(
              $db: $db,
              $table: $db.typingTests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> lessonProgressRefs<T extends Object>(
      Expression<T> Function($$LessonProgressTableAnnotationComposer a) f) {
    final $$LessonProgressTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonProgress,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonProgressTableAnnotationComposer(
              $db: $db,
              $table: $db.lessonProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> dailyProgressRefs<T extends Object>(
      Expression<T> Function($$DailyProgressTableAnnotationComposer a) f) {
    final $$DailyProgressTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dailyProgress,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyProgressTableAnnotationComposer(
              $db: $db,
              $table: $db.dailyProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> streaksRefs<T extends Object>(
      Expression<T> Function($$StreaksTableAnnotationComposer a) f) {
    final $$StreaksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.streaks,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StreaksTableAnnotationComposer(
              $db: $db,
              $table: $db.streaks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> settingsRefs<T extends Object>(
      Expression<T> Function($$SettingsTableAnnotationComposer a) f) {
    final $$SettingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.settings,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SettingsTableAnnotationComposer(
              $db: $db,
              $table: $db.settings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool typingTestsRefs,
        bool lessonProgressRefs,
        bool dailyProgressRefs,
        bool streaksRefs,
        bool settingsRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> profileImage = const Value.absent(),
            Value<String> preferredLanguage = const Value.absent(),
            Value<int> dailyGoalSeconds = const Value.absent(),
            Value<int> preferredTestDurationSeconds = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
            profileImage: profileImage,
            preferredLanguage: preferredLanguage,
            dailyGoalSeconds: dailyGoalSeconds,
            preferredTestDurationSeconds: preferredTestDurationSeconds,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> profileImage = const Value.absent(),
            Value<String> preferredLanguage = const Value.absent(),
            Value<int> dailyGoalSeconds = const Value.absent(),
            Value<int> preferredTestDurationSeconds = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
            profileImage: profileImage,
            preferredLanguage: preferredLanguage,
            dailyGoalSeconds: dailyGoalSeconds,
            preferredTestDurationSeconds: preferredTestDurationSeconds,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$UsersTable, User>(table),
                    $$UsersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {typingTestsRefs = false,
              lessonProgressRefs = false,
              dailyProgressRefs = false,
              streaksRefs = false,
              settingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (typingTestsRefs) db.typingTests,
                if (lessonProgressRefs) db.lessonProgress,
                if (dailyProgressRefs) db.dailyProgress,
                if (streaksRefs) db.streaks,
                if (settingsRefs) db.settings
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (typingTestsRefs)
                    await $_getPrefetchedData<User, $UsersTable, TypingTest>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._typingTestsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .typingTestsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (lessonProgressRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            LessonProgressData>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._lessonProgressRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .lessonProgressRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (dailyProgressRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            DailyProgressData>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._dailyProgressRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .dailyProgressRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (streaksRefs)
                    await $_getPrefetchedData<User, $UsersTable, Streak>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._streaksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).streaksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (settingsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Setting>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._settingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).settingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool typingTestsRefs,
        bool lessonProgressRefs,
        bool dailyProgressRefs,
        bool streaksRefs,
        bool settingsRefs})>;
typedef $$ParagraphsTableCreateCompanionBuilder = ParagraphsCompanion Function({
  Value<int> id,
  required String title,
  required String language,
  Value<String> category,
  Value<String?> difficulty,
  required String content,
  Value<bool> isCustom,
  Value<bool> isPpsc,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$ParagraphsTableUpdateCompanionBuilder = ParagraphsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> language,
  Value<String> category,
  Value<String?> difficulty,
  Value<String> content,
  Value<bool> isCustom,
  Value<bool> isPpsc,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

final class $$ParagraphsTableReferences
    extends BaseReferences<_$AppDatabase, $ParagraphsTable, Paragraph> {
  $$ParagraphsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TypingTestsTable, List<TypingTest>>
      _typingTestsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.typingTests,
              aliasName: 'paragraphs__id__typing_tests__paragraph_id');

  $$TypingTestsTableProcessedTableManager get typingTestsRefs {
    final manager = $$TypingTestsTableTableManager($_db, $_db.typingTests)
        .filter((f) => f.paragraphId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_typingTestsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ParagraphsTableFilterComposer
    extends Composer<_$AppDatabase, $ParagraphsTable> {
  $$ParagraphsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPpsc => $composableBuilder(
      column: $table.isPpsc, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> typingTestsRefs(
      Expression<bool> Function($$TypingTestsTableFilterComposer f) f) {
    final $$TypingTestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.typingTests,
        getReferencedColumn: (t) => t.paragraphId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TypingTestsTableFilterComposer(
              $db: $db,
              $table: $db.typingTests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ParagraphsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParagraphsTable> {
  $$ParagraphsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPpsc => $composableBuilder(
      column: $table.isPpsc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ParagraphsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParagraphsTable> {
  $$ParagraphsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<bool> get isPpsc =>
      $composableBuilder(column: $table.isPpsc, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> typingTestsRefs<T extends Object>(
      Expression<T> Function($$TypingTestsTableAnnotationComposer a) f) {
    final $$TypingTestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.typingTests,
        getReferencedColumn: (t) => t.paragraphId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TypingTestsTableAnnotationComposer(
              $db: $db,
              $table: $db.typingTests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ParagraphsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ParagraphsTable,
    Paragraph,
    $$ParagraphsTableFilterComposer,
    $$ParagraphsTableOrderingComposer,
    $$ParagraphsTableAnnotationComposer,
    $$ParagraphsTableCreateCompanionBuilder,
    $$ParagraphsTableUpdateCompanionBuilder,
    (Paragraph, $$ParagraphsTableReferences),
    Paragraph,
    PrefetchHooks Function({bool typingTestsRefs})> {
  $$ParagraphsTableTableManager(_$AppDatabase db, $ParagraphsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParagraphsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParagraphsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParagraphsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> difficulty = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<bool> isPpsc = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              ParagraphsCompanion(
            id: id,
            title: title,
            language: language,
            category: category,
            difficulty: difficulty,
            content: content,
            isCustom: isCustom,
            isPpsc: isPpsc,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String language,
            Value<String> category = const Value.absent(),
            Value<String?> difficulty = const Value.absent(),
            required String content,
            Value<bool> isCustom = const Value.absent(),
            Value<bool> isPpsc = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              ParagraphsCompanion.insert(
            id: id,
            title: title,
            language: language,
            category: category,
            difficulty: difficulty,
            content: content,
            isCustom: isCustom,
            isPpsc: isPpsc,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ParagraphsTable, Paragraph>(table),
                    $$ParagraphsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({typingTestsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (typingTestsRefs) db.typingTests],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (typingTestsRefs)
                    await $_getPrefetchedData<Paragraph, $ParagraphsTable,
                            TypingTest>(
                        currentTable: table,
                        referencedTable: $$ParagraphsTableReferences
                            ._typingTestsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ParagraphsTableReferences(db, table, p0)
                                .typingTestsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.paragraphId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ParagraphsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ParagraphsTable,
    Paragraph,
    $$ParagraphsTableFilterComposer,
    $$ParagraphsTableOrderingComposer,
    $$ParagraphsTableAnnotationComposer,
    $$ParagraphsTableCreateCompanionBuilder,
    $$ParagraphsTableUpdateCompanionBuilder,
    (Paragraph, $$ParagraphsTableReferences),
    Paragraph,
    PrefetchHooks Function({bool typingTestsRefs})>;
typedef $$TypingTestsTableCreateCompanionBuilder = TypingTestsCompanion
    Function({
  Value<int> id,
  required int userId,
  required String language,
  required String testType,
  Value<int?> paragraphId,
  Value<int?> durationSeconds,
  required int actualDurationSeconds,
  required double grossWpm,
  required double netWpm,
  required double accuracy,
  Value<double> keystrokeAccuracy,
  required int correctCharacters,
  required int wrongCharacters,
  required int correctWords,
  required int wrongWords,
  required int skippedWords,
  Value<int> backspaces,
  Value<int> correctedMistakes,
  Value<int> uncorrectedMistakes,
  required int totalErrors,
  Value<DateTime> completedAt,
});
typedef $$TypingTestsTableUpdateCompanionBuilder = TypingTestsCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<String> language,
  Value<String> testType,
  Value<int?> paragraphId,
  Value<int?> durationSeconds,
  Value<int> actualDurationSeconds,
  Value<double> grossWpm,
  Value<double> netWpm,
  Value<double> accuracy,
  Value<double> keystrokeAccuracy,
  Value<int> correctCharacters,
  Value<int> wrongCharacters,
  Value<int> correctWords,
  Value<int> wrongWords,
  Value<int> skippedWords,
  Value<int> backspaces,
  Value<int> correctedMistakes,
  Value<int> uncorrectedMistakes,
  Value<int> totalErrors,
  Value<DateTime> completedAt,
});

final class $$TypingTestsTableReferences
    extends BaseReferences<_$AppDatabase, $TypingTestsTable, TypingTest> {
  $$TypingTestsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('typing_tests__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ParagraphsTable _paragraphIdTable(_$AppDatabase db) =>
      db.paragraphs.createAlias('typing_tests__paragraph_id__paragraphs__id');

  $$ParagraphsTableProcessedTableManager? get paragraphId {
    final $_column = $_itemColumn<int>('paragraph_id');
    if ($_column == null) return null;
    final manager = $$ParagraphsTableTableManager($_db, $_db.paragraphs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paragraphIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MistakesTable, List<Mistake>> _mistakesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.mistakes,
          aliasName: 'typing_tests__id__mistakes__test_id');

  $$MistakesTableProcessedTableManager get mistakesRefs {
    final manager = $$MistakesTableTableManager($_db, $_db.mistakes)
        .filter((f) => f.testId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mistakesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TypingTestsTableFilterComposer
    extends Composer<_$AppDatabase, $TypingTestsTable> {
  $$TypingTestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get testType => $composableBuilder(
      column: $table.testType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get actualDurationSeconds => $composableBuilder(
      column: $table.actualDurationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get grossWpm => $composableBuilder(
      column: $table.grossWpm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get netWpm => $composableBuilder(
      column: $table.netWpm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get keystrokeAccuracy => $composableBuilder(
      column: $table.keystrokeAccuracy,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctCharacters => $composableBuilder(
      column: $table.correctCharacters,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wrongCharacters => $composableBuilder(
      column: $table.wrongCharacters,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctWords => $composableBuilder(
      column: $table.correctWords, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wrongWords => $composableBuilder(
      column: $table.wrongWords, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get skippedWords => $composableBuilder(
      column: $table.skippedWords, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get backspaces => $composableBuilder(
      column: $table.backspaces, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctedMistakes => $composableBuilder(
      column: $table.correctedMistakes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get uncorrectedMistakes => $composableBuilder(
      column: $table.uncorrectedMistakes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalErrors => $composableBuilder(
      column: $table.totalErrors, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ParagraphsTableFilterComposer get paragraphId {
    final $$ParagraphsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paragraphId,
        referencedTable: $db.paragraphs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ParagraphsTableFilterComposer(
              $db: $db,
              $table: $db.paragraphs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> mistakesRefs(
      Expression<bool> Function($$MistakesTableFilterComposer f) f) {
    final $$MistakesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mistakes,
        getReferencedColumn: (t) => t.testId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MistakesTableFilterComposer(
              $db: $db,
              $table: $db.mistakes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TypingTestsTableOrderingComposer
    extends Composer<_$AppDatabase, $TypingTestsTable> {
  $$TypingTestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get testType => $composableBuilder(
      column: $table.testType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get actualDurationSeconds => $composableBuilder(
      column: $table.actualDurationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get grossWpm => $composableBuilder(
      column: $table.grossWpm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get netWpm => $composableBuilder(
      column: $table.netWpm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get keystrokeAccuracy => $composableBuilder(
      column: $table.keystrokeAccuracy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctCharacters => $composableBuilder(
      column: $table.correctCharacters,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wrongCharacters => $composableBuilder(
      column: $table.wrongCharacters,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctWords => $composableBuilder(
      column: $table.correctWords,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wrongWords => $composableBuilder(
      column: $table.wrongWords, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get skippedWords => $composableBuilder(
      column: $table.skippedWords,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get backspaces => $composableBuilder(
      column: $table.backspaces, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctedMistakes => $composableBuilder(
      column: $table.correctedMistakes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get uncorrectedMistakes => $composableBuilder(
      column: $table.uncorrectedMistakes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalErrors => $composableBuilder(
      column: $table.totalErrors, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ParagraphsTableOrderingComposer get paragraphId {
    final $$ParagraphsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paragraphId,
        referencedTable: $db.paragraphs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ParagraphsTableOrderingComposer(
              $db: $db,
              $table: $db.paragraphs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TypingTestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TypingTestsTable> {
  $$TypingTestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get testType =>
      $composableBuilder(column: $table.testType, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<int> get actualDurationSeconds => $composableBuilder(
      column: $table.actualDurationSeconds, builder: (column) => column);

  GeneratedColumn<double> get grossWpm =>
      $composableBuilder(column: $table.grossWpm, builder: (column) => column);

  GeneratedColumn<double> get netWpm =>
      $composableBuilder(column: $table.netWpm, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get keystrokeAccuracy => $composableBuilder(
      column: $table.keystrokeAccuracy, builder: (column) => column);

  GeneratedColumn<int> get correctCharacters => $composableBuilder(
      column: $table.correctCharacters, builder: (column) => column);

  GeneratedColumn<int> get wrongCharacters => $composableBuilder(
      column: $table.wrongCharacters, builder: (column) => column);

  GeneratedColumn<int> get correctWords => $composableBuilder(
      column: $table.correctWords, builder: (column) => column);

  GeneratedColumn<int> get wrongWords => $composableBuilder(
      column: $table.wrongWords, builder: (column) => column);

  GeneratedColumn<int> get skippedWords => $composableBuilder(
      column: $table.skippedWords, builder: (column) => column);

  GeneratedColumn<int> get backspaces => $composableBuilder(
      column: $table.backspaces, builder: (column) => column);

  GeneratedColumn<int> get correctedMistakes => $composableBuilder(
      column: $table.correctedMistakes, builder: (column) => column);

  GeneratedColumn<int> get uncorrectedMistakes => $composableBuilder(
      column: $table.uncorrectedMistakes, builder: (column) => column);

  GeneratedColumn<int> get totalErrors => $composableBuilder(
      column: $table.totalErrors, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ParagraphsTableAnnotationComposer get paragraphId {
    final $$ParagraphsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paragraphId,
        referencedTable: $db.paragraphs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ParagraphsTableAnnotationComposer(
              $db: $db,
              $table: $db.paragraphs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> mistakesRefs<T extends Object>(
      Expression<T> Function($$MistakesTableAnnotationComposer a) f) {
    final $$MistakesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mistakes,
        getReferencedColumn: (t) => t.testId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MistakesTableAnnotationComposer(
              $db: $db,
              $table: $db.mistakes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TypingTestsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TypingTestsTable,
    TypingTest,
    $$TypingTestsTableFilterComposer,
    $$TypingTestsTableOrderingComposer,
    $$TypingTestsTableAnnotationComposer,
    $$TypingTestsTableCreateCompanionBuilder,
    $$TypingTestsTableUpdateCompanionBuilder,
    (TypingTest, $$TypingTestsTableReferences),
    TypingTest,
    PrefetchHooks Function(
        {bool userId, bool paragraphId, bool mistakesRefs})> {
  $$TypingTestsTableTableManager(_$AppDatabase db, $TypingTestsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TypingTestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TypingTestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TypingTestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> testType = const Value.absent(),
            Value<int?> paragraphId = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
            Value<int> actualDurationSeconds = const Value.absent(),
            Value<double> grossWpm = const Value.absent(),
            Value<double> netWpm = const Value.absent(),
            Value<double> accuracy = const Value.absent(),
            Value<double> keystrokeAccuracy = const Value.absent(),
            Value<int> correctCharacters = const Value.absent(),
            Value<int> wrongCharacters = const Value.absent(),
            Value<int> correctWords = const Value.absent(),
            Value<int> wrongWords = const Value.absent(),
            Value<int> skippedWords = const Value.absent(),
            Value<int> backspaces = const Value.absent(),
            Value<int> correctedMistakes = const Value.absent(),
            Value<int> uncorrectedMistakes = const Value.absent(),
            Value<int> totalErrors = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
          }) =>
              TypingTestsCompanion(
            id: id,
            userId: userId,
            language: language,
            testType: testType,
            paragraphId: paragraphId,
            durationSeconds: durationSeconds,
            actualDurationSeconds: actualDurationSeconds,
            grossWpm: grossWpm,
            netWpm: netWpm,
            accuracy: accuracy,
            keystrokeAccuracy: keystrokeAccuracy,
            correctCharacters: correctCharacters,
            wrongCharacters: wrongCharacters,
            correctWords: correctWords,
            wrongWords: wrongWords,
            skippedWords: skippedWords,
            backspaces: backspaces,
            correctedMistakes: correctedMistakes,
            uncorrectedMistakes: uncorrectedMistakes,
            totalErrors: totalErrors,
            completedAt: completedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required String language,
            required String testType,
            Value<int?> paragraphId = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
            required int actualDurationSeconds,
            required double grossWpm,
            required double netWpm,
            required double accuracy,
            Value<double> keystrokeAccuracy = const Value.absent(),
            required int correctCharacters,
            required int wrongCharacters,
            required int correctWords,
            required int wrongWords,
            required int skippedWords,
            Value<int> backspaces = const Value.absent(),
            Value<int> correctedMistakes = const Value.absent(),
            Value<int> uncorrectedMistakes = const Value.absent(),
            required int totalErrors,
            Value<DateTime> completedAt = const Value.absent(),
          }) =>
              TypingTestsCompanion.insert(
            id: id,
            userId: userId,
            language: language,
            testType: testType,
            paragraphId: paragraphId,
            durationSeconds: durationSeconds,
            actualDurationSeconds: actualDurationSeconds,
            grossWpm: grossWpm,
            netWpm: netWpm,
            accuracy: accuracy,
            keystrokeAccuracy: keystrokeAccuracy,
            correctCharacters: correctCharacters,
            wrongCharacters: wrongCharacters,
            correctWords: correctWords,
            wrongWords: wrongWords,
            skippedWords: skippedWords,
            backspaces: backspaces,
            correctedMistakes: correctedMistakes,
            uncorrectedMistakes: uncorrectedMistakes,
            totalErrors: totalErrors,
            completedAt: completedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TypingTestsTable, TypingTest>(table),
                    $$TypingTestsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {userId = false, paragraphId = false, mistakesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mistakesRefs) db.mistakes],
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$TypingTestsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$TypingTestsTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (paragraphId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.paragraphId,
                    referencedTable:
                        $$TypingTestsTableReferences._paragraphIdTable(db),
                    referencedColumn:
                        $$TypingTestsTableReferences._paragraphIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mistakesRefs)
                    await $_getPrefetchedData<TypingTest, $TypingTestsTable,
                            Mistake>(
                        currentTable: table,
                        referencedTable:
                            $$TypingTestsTableReferences._mistakesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TypingTestsTableReferences(db, table, p0)
                                .mistakesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.testId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TypingTestsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TypingTestsTable,
    TypingTest,
    $$TypingTestsTableFilterComposer,
    $$TypingTestsTableOrderingComposer,
    $$TypingTestsTableAnnotationComposer,
    $$TypingTestsTableCreateCompanionBuilder,
    $$TypingTestsTableUpdateCompanionBuilder,
    (TypingTest, $$TypingTestsTableReferences),
    TypingTest,
    PrefetchHooks Function({bool userId, bool paragraphId, bool mistakesRefs})>;
typedef $$LessonsTableCreateCompanionBuilder = LessonsCompanion Function({
  Value<int> id,
  required String title,
  required String language,
  required String level,
  required int orderIndex,
  required String content,
  Value<double> requiredAccuracy,
  Value<int> requiredWpm,
  Value<DateTime> createdAt,
});
typedef $$LessonsTableUpdateCompanionBuilder = LessonsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> language,
  Value<String> level,
  Value<int> orderIndex,
  Value<String> content,
  Value<double> requiredAccuracy,
  Value<int> requiredWpm,
  Value<DateTime> createdAt,
});

final class $$LessonsTableReferences
    extends BaseReferences<_$AppDatabase, $LessonsTable, Lesson> {
  $$LessonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LessonProgressTable, List<LessonProgressData>>
      _lessonProgressRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.lessonProgress,
              aliasName: 'lessons__id__lesson_progress__lesson_id');

  $$LessonProgressTableProcessedTableManager get lessonProgressRefs {
    final manager = $$LessonProgressTableTableManager($_db, $_db.lessonProgress)
        .filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonProgressRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get requiredAccuracy => $composableBuilder(
      column: $table.requiredAccuracy,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get requiredWpm => $composableBuilder(
      column: $table.requiredWpm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> lessonProgressRefs(
      Expression<bool> Function($$LessonProgressTableFilterComposer f) f) {
    final $$LessonProgressTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonProgress,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonProgressTableFilterComposer(
              $db: $db,
              $table: $db.lessonProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get requiredAccuracy => $composableBuilder(
      column: $table.requiredAccuracy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get requiredWpm => $composableBuilder(
      column: $table.requiredWpm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<double> get requiredAccuracy => $composableBuilder(
      column: $table.requiredAccuracy, builder: (column) => column);

  GeneratedColumn<int> get requiredWpm => $composableBuilder(
      column: $table.requiredWpm, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> lessonProgressRefs<T extends Object>(
      Expression<T> Function($$LessonProgressTableAnnotationComposer a) f) {
    final $$LessonProgressTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonProgress,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonProgressTableAnnotationComposer(
              $db: $db,
              $table: $db.lessonProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LessonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonsTable,
    Lesson,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (Lesson, $$LessonsTableReferences),
    Lesson,
    PrefetchHooks Function({bool lessonProgressRefs})> {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<double> requiredAccuracy = const Value.absent(),
            Value<int> requiredWpm = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              LessonsCompanion(
            id: id,
            title: title,
            language: language,
            level: level,
            orderIndex: orderIndex,
            content: content,
            requiredAccuracy: requiredAccuracy,
            requiredWpm: requiredWpm,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String language,
            required String level,
            required int orderIndex,
            required String content,
            Value<double> requiredAccuracy = const Value.absent(),
            Value<int> requiredWpm = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              LessonsCompanion.insert(
            id: id,
            title: title,
            language: language,
            level: level,
            orderIndex: orderIndex,
            content: content,
            requiredAccuracy: requiredAccuracy,
            requiredWpm: requiredWpm,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LessonsTable, Lesson>(table),
                    $$LessonsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({lessonProgressRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (lessonProgressRefs) db.lessonProgress
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lessonProgressRefs)
                    await $_getPrefetchedData<Lesson, $LessonsTable,
                            LessonProgressData>(
                        currentTable: table,
                        referencedTable: $$LessonsTableReferences
                            ._lessonProgressRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LessonsTableReferences(db, table, p0)
                                .lessonProgressRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.lessonId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LessonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonsTable,
    Lesson,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (Lesson, $$LessonsTableReferences),
    Lesson,
    PrefetchHooks Function({bool lessonProgressRefs})>;
typedef $$LessonProgressTableCreateCompanionBuilder = LessonProgressCompanion
    Function({
  Value<int> id,
  required int userId,
  required int lessonId,
  Value<bool> completed,
  Value<double> bestAccuracy,
  Value<double> bestSpeed,
  Value<int> attempts,
  Value<DateTime?> lastAttemptAt,
});
typedef $$LessonProgressTableUpdateCompanionBuilder = LessonProgressCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<int> lessonId,
  Value<bool> completed,
  Value<double> bestAccuracy,
  Value<double> bestSpeed,
  Value<int> attempts,
  Value<DateTime?> lastAttemptAt,
});

final class $$LessonProgressTableReferences extends BaseReferences<
    _$AppDatabase, $LessonProgressTable, LessonProgressData> {
  $$LessonProgressTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('lesson_progress__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias('lesson_progress__lesson_id__lessons__id');

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$LessonsTableTableManager($_db, $_db.lessons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LessonProgressTableFilterComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bestAccuracy => $composableBuilder(
      column: $table.bestAccuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bestSpeed => $composableBuilder(
      column: $table.bestSpeed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableFilterComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bestAccuracy => $composableBuilder(
      column: $table.bestAccuracy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bestSpeed => $composableBuilder(
      column: $table.bestSpeed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt,
      builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableOrderingComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<double> get bestAccuracy => $composableBuilder(
      column: $table.bestAccuracy, builder: (column) => column);

  GeneratedColumn<double> get bestSpeed =>
      $composableBuilder(column: $table.bestSpeed, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableAnnotationComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonProgressTable,
    LessonProgressData,
    $$LessonProgressTableFilterComposer,
    $$LessonProgressTableOrderingComposer,
    $$LessonProgressTableAnnotationComposer,
    $$LessonProgressTableCreateCompanionBuilder,
    $$LessonProgressTableUpdateCompanionBuilder,
    (LessonProgressData, $$LessonProgressTableReferences),
    LessonProgressData,
    PrefetchHooks Function({bool userId, bool lessonId})> {
  $$LessonProgressTableTableManager(
      _$AppDatabase db, $LessonProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> lessonId = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<double> bestAccuracy = const Value.absent(),
            Value<double> bestSpeed = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
          }) =>
              LessonProgressCompanion(
            id: id,
            userId: userId,
            lessonId: lessonId,
            completed: completed,
            bestAccuracy: bestAccuracy,
            bestSpeed: bestSpeed,
            attempts: attempts,
            lastAttemptAt: lastAttemptAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required int lessonId,
            Value<bool> completed = const Value.absent(),
            Value<double> bestAccuracy = const Value.absent(),
            Value<double> bestSpeed = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
          }) =>
              LessonProgressCompanion.insert(
            id: id,
            userId: userId,
            lessonId: lessonId,
            completed: completed,
            bestAccuracy: bestAccuracy,
            bestSpeed: bestSpeed,
            attempts: attempts,
            lastAttemptAt: lastAttemptAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LessonProgressTable, LessonProgressData>(
                        table),
                    $$LessonProgressTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, lessonId = false}) {
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$LessonProgressTableReferences._userIdTable(db),
                    referencedColumn:
                        $$LessonProgressTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (lessonId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lessonId,
                    referencedTable:
                        $$LessonProgressTableReferences._lessonIdTable(db),
                    referencedColumn:
                        $$LessonProgressTableReferences._lessonIdTable(db).id,
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

typedef $$LessonProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonProgressTable,
    LessonProgressData,
    $$LessonProgressTableFilterComposer,
    $$LessonProgressTableOrderingComposer,
    $$LessonProgressTableAnnotationComposer,
    $$LessonProgressTableCreateCompanionBuilder,
    $$LessonProgressTableUpdateCompanionBuilder,
    (LessonProgressData, $$LessonProgressTableReferences),
    LessonProgressData,
    PrefetchHooks Function({bool userId, bool lessonId})>;
typedef $$MistakesTableCreateCompanionBuilder = MistakesCompanion Function({
  Value<int> id,
  required int testId,
  required String expectedCharacter,
  Value<String> typedCharacter,
  Value<int> count,
  required int position,
  required int wordIndex,
  Value<bool> isSkippedWord,
  Value<bool> isWrongWord,
});
typedef $$MistakesTableUpdateCompanionBuilder = MistakesCompanion Function({
  Value<int> id,
  Value<int> testId,
  Value<String> expectedCharacter,
  Value<String> typedCharacter,
  Value<int> count,
  Value<int> position,
  Value<int> wordIndex,
  Value<bool> isSkippedWord,
  Value<bool> isWrongWord,
});

final class $$MistakesTableReferences
    extends BaseReferences<_$AppDatabase, $MistakesTable, Mistake> {
  $$MistakesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TypingTestsTable _testIdTable(_$AppDatabase db) =>
      db.typingTests.createAlias('mistakes__test_id__typing_tests__id');

  $$TypingTestsTableProcessedTableManager get testId {
    final $_column = $_itemColumn<int>('test_id')!;

    final manager = $$TypingTestsTableTableManager($_db, $_db.typingTests)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_testIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MistakesTableFilterComposer
    extends Composer<_$AppDatabase, $MistakesTable> {
  $$MistakesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get expectedCharacter => $composableBuilder(
      column: $table.expectedCharacter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typedCharacter => $composableBuilder(
      column: $table.typedCharacter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wordIndex => $composableBuilder(
      column: $table.wordIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSkippedWord => $composableBuilder(
      column: $table.isSkippedWord, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isWrongWord => $composableBuilder(
      column: $table.isWrongWord, builder: (column) => ColumnFilters(column));

  $$TypingTestsTableFilterComposer get testId {
    final $$TypingTestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.testId,
        referencedTable: $db.typingTests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TypingTestsTableFilterComposer(
              $db: $db,
              $table: $db.typingTests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MistakesTableOrderingComposer
    extends Composer<_$AppDatabase, $MistakesTable> {
  $$MistakesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get expectedCharacter => $composableBuilder(
      column: $table.expectedCharacter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typedCharacter => $composableBuilder(
      column: $table.typedCharacter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wordIndex => $composableBuilder(
      column: $table.wordIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSkippedWord => $composableBuilder(
      column: $table.isSkippedWord,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isWrongWord => $composableBuilder(
      column: $table.isWrongWord, builder: (column) => ColumnOrderings(column));

  $$TypingTestsTableOrderingComposer get testId {
    final $$TypingTestsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.testId,
        referencedTable: $db.typingTests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TypingTestsTableOrderingComposer(
              $db: $db,
              $table: $db.typingTests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MistakesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MistakesTable> {
  $$MistakesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get expectedCharacter => $composableBuilder(
      column: $table.expectedCharacter, builder: (column) => column);

  GeneratedColumn<String> get typedCharacter => $composableBuilder(
      column: $table.typedCharacter, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get wordIndex =>
      $composableBuilder(column: $table.wordIndex, builder: (column) => column);

  GeneratedColumn<bool> get isSkippedWord => $composableBuilder(
      column: $table.isSkippedWord, builder: (column) => column);

  GeneratedColumn<bool> get isWrongWord => $composableBuilder(
      column: $table.isWrongWord, builder: (column) => column);

  $$TypingTestsTableAnnotationComposer get testId {
    final $$TypingTestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.testId,
        referencedTable: $db.typingTests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TypingTestsTableAnnotationComposer(
              $db: $db,
              $table: $db.typingTests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MistakesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MistakesTable,
    Mistake,
    $$MistakesTableFilterComposer,
    $$MistakesTableOrderingComposer,
    $$MistakesTableAnnotationComposer,
    $$MistakesTableCreateCompanionBuilder,
    $$MistakesTableUpdateCompanionBuilder,
    (Mistake, $$MistakesTableReferences),
    Mistake,
    PrefetchHooks Function({bool testId})> {
  $$MistakesTableTableManager(_$AppDatabase db, $MistakesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MistakesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MistakesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MistakesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> testId = const Value.absent(),
            Value<String> expectedCharacter = const Value.absent(),
            Value<String> typedCharacter = const Value.absent(),
            Value<int> count = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<int> wordIndex = const Value.absent(),
            Value<bool> isSkippedWord = const Value.absent(),
            Value<bool> isWrongWord = const Value.absent(),
          }) =>
              MistakesCompanion(
            id: id,
            testId: testId,
            expectedCharacter: expectedCharacter,
            typedCharacter: typedCharacter,
            count: count,
            position: position,
            wordIndex: wordIndex,
            isSkippedWord: isSkippedWord,
            isWrongWord: isWrongWord,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int testId,
            required String expectedCharacter,
            Value<String> typedCharacter = const Value.absent(),
            Value<int> count = const Value.absent(),
            required int position,
            required int wordIndex,
            Value<bool> isSkippedWord = const Value.absent(),
            Value<bool> isWrongWord = const Value.absent(),
          }) =>
              MistakesCompanion.insert(
            id: id,
            testId: testId,
            expectedCharacter: expectedCharacter,
            typedCharacter: typedCharacter,
            count: count,
            position: position,
            wordIndex: wordIndex,
            isSkippedWord: isSkippedWord,
            isWrongWord: isWrongWord,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MistakesTable, Mistake>(table),
                    $$MistakesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({testId = false}) {
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
                if (testId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.testId,
                    referencedTable: $$MistakesTableReferences._testIdTable(db),
                    referencedColumn:
                        $$MistakesTableReferences._testIdTable(db).id,
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

typedef $$MistakesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MistakesTable,
    Mistake,
    $$MistakesTableFilterComposer,
    $$MistakesTableOrderingComposer,
    $$MistakesTableAnnotationComposer,
    $$MistakesTableCreateCompanionBuilder,
    $$MistakesTableUpdateCompanionBuilder,
    (Mistake, $$MistakesTableReferences),
    Mistake,
    PrefetchHooks Function({bool testId})>;
typedef $$DailyProgressTableCreateCompanionBuilder = DailyProgressCompanion
    Function({
  Value<int> id,
  required int userId,
  required DateTime date,
  Value<int> practiceSeconds,
  Value<int> testsCompleted,
  required int goalSeconds,
});
typedef $$DailyProgressTableUpdateCompanionBuilder = DailyProgressCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<DateTime> date,
  Value<int> practiceSeconds,
  Value<int> testsCompleted,
  Value<int> goalSeconds,
});

final class $$DailyProgressTableReferences extends BaseReferences<_$AppDatabase,
    $DailyProgressTable, DailyProgressData> {
  $$DailyProgressTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('daily_progress__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DailyProgressTableFilterComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableFilterComposer({
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

  ColumnFilters<int> get practiceSeconds => $composableBuilder(
      column: $table.practiceSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get testsCompleted => $composableBuilder(
      column: $table.testsCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get goalSeconds => $composableBuilder(
      column: $table.goalSeconds, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableOrderingComposer({
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

  ColumnOrderings<int> get practiceSeconds => $composableBuilder(
      column: $table.practiceSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get testsCompleted => $composableBuilder(
      column: $table.testsCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get goalSeconds => $composableBuilder(
      column: $table.goalSeconds, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableAnnotationComposer({
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

  GeneratedColumn<int> get practiceSeconds => $composableBuilder(
      column: $table.practiceSeconds, builder: (column) => column);

  GeneratedColumn<int> get testsCompleted => $composableBuilder(
      column: $table.testsCompleted, builder: (column) => column);

  GeneratedColumn<int> get goalSeconds => $composableBuilder(
      column: $table.goalSeconds, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyProgressTable,
    DailyProgressData,
    $$DailyProgressTableFilterComposer,
    $$DailyProgressTableOrderingComposer,
    $$DailyProgressTableAnnotationComposer,
    $$DailyProgressTableCreateCompanionBuilder,
    $$DailyProgressTableUpdateCompanionBuilder,
    (DailyProgressData, $$DailyProgressTableReferences),
    DailyProgressData,
    PrefetchHooks Function({bool userId})> {
  $$DailyProgressTableTableManager(_$AppDatabase db, $DailyProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> practiceSeconds = const Value.absent(),
            Value<int> testsCompleted = const Value.absent(),
            Value<int> goalSeconds = const Value.absent(),
          }) =>
              DailyProgressCompanion(
            id: id,
            userId: userId,
            date: date,
            practiceSeconds: practiceSeconds,
            testsCompleted: testsCompleted,
            goalSeconds: goalSeconds,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required DateTime date,
            Value<int> practiceSeconds = const Value.absent(),
            Value<int> testsCompleted = const Value.absent(),
            required int goalSeconds,
          }) =>
              DailyProgressCompanion.insert(
            id: id,
            userId: userId,
            date: date,
            practiceSeconds: practiceSeconds,
            testsCompleted: testsCompleted,
            goalSeconds: goalSeconds,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DailyProgressTable, DailyProgressData>(table),
                    $$DailyProgressTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$DailyProgressTableReferences._userIdTable(db),
                    referencedColumn:
                        $$DailyProgressTableReferences._userIdTable(db).id,
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

typedef $$DailyProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyProgressTable,
    DailyProgressData,
    $$DailyProgressTableFilterComposer,
    $$DailyProgressTableOrderingComposer,
    $$DailyProgressTableAnnotationComposer,
    $$DailyProgressTableCreateCompanionBuilder,
    $$DailyProgressTableUpdateCompanionBuilder,
    (DailyProgressData, $$DailyProgressTableReferences),
    DailyProgressData,
    PrefetchHooks Function({bool userId})>;
typedef $$StreaksTableCreateCompanionBuilder = StreaksCompanion Function({
  Value<int> id,
  required int userId,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<DateTime?> lastPracticeDate,
});
typedef $$StreaksTableUpdateCompanionBuilder = StreaksCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<DateTime?> lastPracticeDate,
});

final class $$StreaksTableReferences
    extends BaseReferences<_$AppDatabase, $StreaksTable, Streak> {
  $$StreaksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('streaks__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StreaksTableFilterComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPracticeDate => $composableBuilder(
      column: $table.lastPracticeDate,
      builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StreaksTableOrderingComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPracticeDate => $composableBuilder(
      column: $table.lastPracticeDate,
      builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StreaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak, builder: (column) => column);

  GeneratedColumn<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPracticeDate => $composableBuilder(
      column: $table.lastPracticeDate, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StreaksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StreaksTable,
    Streak,
    $$StreaksTableFilterComposer,
    $$StreaksTableOrderingComposer,
    $$StreaksTableAnnotationComposer,
    $$StreaksTableCreateCompanionBuilder,
    $$StreaksTableUpdateCompanionBuilder,
    (Streak, $$StreaksTableReferences),
    Streak,
    PrefetchHooks Function({bool userId})> {
  $$StreaksTableTableManager(_$AppDatabase db, $StreaksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> currentStreak = const Value.absent(),
            Value<int> longestStreak = const Value.absent(),
            Value<DateTime?> lastPracticeDate = const Value.absent(),
          }) =>
              StreaksCompanion(
            id: id,
            userId: userId,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            lastPracticeDate: lastPracticeDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            Value<int> currentStreak = const Value.absent(),
            Value<int> longestStreak = const Value.absent(),
            Value<DateTime?> lastPracticeDate = const Value.absent(),
          }) =>
              StreaksCompanion.insert(
            id: id,
            userId: userId,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            lastPracticeDate: lastPracticeDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$StreaksTable, Streak>(table),
                    $$StreaksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$StreaksTableReferences._userIdTable(db),
                    referencedColumn:
                        $$StreaksTableReferences._userIdTable(db).id,
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

typedef $$StreaksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StreaksTable,
    Streak,
    $$StreaksTableFilterComposer,
    $$StreaksTableOrderingComposer,
    $$StreaksTableAnnotationComposer,
    $$StreaksTableCreateCompanionBuilder,
    $$StreaksTableUpdateCompanionBuilder,
    (Streak, $$StreaksTableReferences),
    Streak,
    PrefetchHooks Function({bool userId})>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  required int userId,
  Value<String> theme,
  Value<bool> showLiveWpm,
  Value<bool> showLiveAccuracy,
  Value<bool> showErrors,
  Value<bool> autoScroll,
  Value<bool> countBackspaces,
  Value<bool> strictSkipDetection,
  Value<int> defaultTestDurationSeconds,
  Value<String> defaultLanguage,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<String> theme,
  Value<bool> showLiveWpm,
  Value<bool> showLiveAccuracy,
  Value<bool> showErrors,
  Value<bool> autoScroll,
  Value<bool> countBackspaces,
  Value<bool> strictSkipDetection,
  Value<int> defaultTestDurationSeconds,
  Value<String> defaultLanguage,
});

final class $$SettingsTableReferences
    extends BaseReferences<_$AppDatabase, $SettingsTable, Setting> {
  $$SettingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('settings__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showLiveWpm => $composableBuilder(
      column: $table.showLiveWpm, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showLiveAccuracy => $composableBuilder(
      column: $table.showLiveAccuracy,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showErrors => $composableBuilder(
      column: $table.showErrors, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoScroll => $composableBuilder(
      column: $table.autoScroll, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get countBackspaces => $composableBuilder(
      column: $table.countBackspaces,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get strictSkipDetection => $composableBuilder(
      column: $table.strictSkipDetection,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultTestDurationSeconds => $composableBuilder(
      column: $table.defaultTestDurationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultLanguage => $composableBuilder(
      column: $table.defaultLanguage,
      builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showLiveWpm => $composableBuilder(
      column: $table.showLiveWpm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showLiveAccuracy => $composableBuilder(
      column: $table.showLiveAccuracy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showErrors => $composableBuilder(
      column: $table.showErrors, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoScroll => $composableBuilder(
      column: $table.autoScroll, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get countBackspaces => $composableBuilder(
      column: $table.countBackspaces,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get strictSkipDetection => $composableBuilder(
      column: $table.strictSkipDetection,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultTestDurationSeconds => $composableBuilder(
      column: $table.defaultTestDurationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultLanguage => $composableBuilder(
      column: $table.defaultLanguage,
      builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<bool> get showLiveWpm => $composableBuilder(
      column: $table.showLiveWpm, builder: (column) => column);

  GeneratedColumn<bool> get showLiveAccuracy => $composableBuilder(
      column: $table.showLiveAccuracy, builder: (column) => column);

  GeneratedColumn<bool> get showErrors => $composableBuilder(
      column: $table.showErrors, builder: (column) => column);

  GeneratedColumn<bool> get autoScroll => $composableBuilder(
      column: $table.autoScroll, builder: (column) => column);

  GeneratedColumn<bool> get countBackspaces => $composableBuilder(
      column: $table.countBackspaces, builder: (column) => column);

  GeneratedColumn<bool> get strictSkipDetection => $composableBuilder(
      column: $table.strictSkipDetection, builder: (column) => column);

  GeneratedColumn<int> get defaultTestDurationSeconds => $composableBuilder(
      column: $table.defaultTestDurationSeconds, builder: (column) => column);

  GeneratedColumn<String> get defaultLanguage => $composableBuilder(
      column: $table.defaultLanguage, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, $$SettingsTableReferences),
    Setting,
    PrefetchHooks Function({bool userId})> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<bool> showLiveWpm = const Value.absent(),
            Value<bool> showLiveAccuracy = const Value.absent(),
            Value<bool> showErrors = const Value.absent(),
            Value<bool> autoScroll = const Value.absent(),
            Value<bool> countBackspaces = const Value.absent(),
            Value<bool> strictSkipDetection = const Value.absent(),
            Value<int> defaultTestDurationSeconds = const Value.absent(),
            Value<String> defaultLanguage = const Value.absent(),
          }) =>
              SettingsCompanion(
            id: id,
            userId: userId,
            theme: theme,
            showLiveWpm: showLiveWpm,
            showLiveAccuracy: showLiveAccuracy,
            showErrors: showErrors,
            autoScroll: autoScroll,
            countBackspaces: countBackspaces,
            strictSkipDetection: strictSkipDetection,
            defaultTestDurationSeconds: defaultTestDurationSeconds,
            defaultLanguage: defaultLanguage,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            Value<String> theme = const Value.absent(),
            Value<bool> showLiveWpm = const Value.absent(),
            Value<bool> showLiveAccuracy = const Value.absent(),
            Value<bool> showErrors = const Value.absent(),
            Value<bool> autoScroll = const Value.absent(),
            Value<bool> countBackspaces = const Value.absent(),
            Value<bool> strictSkipDetection = const Value.absent(),
            Value<int> defaultTestDurationSeconds = const Value.absent(),
            Value<String> defaultLanguage = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            id: id,
            userId: userId,
            theme: theme,
            showLiveWpm: showLiveWpm,
            showLiveAccuracy: showLiveAccuracy,
            showErrors: showErrors,
            autoScroll: autoScroll,
            countBackspaces: countBackspaces,
            strictSkipDetection: strictSkipDetection,
            defaultTestDurationSeconds: defaultTestDurationSeconds,
            defaultLanguage: defaultLanguage,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SettingsTable, Setting>(table),
                    $$SettingsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$SettingsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$SettingsTableReferences._userIdTable(db).id,
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

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, $$SettingsTableReferences),
    Setting,
    PrefetchHooks Function({bool userId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ParagraphsTableTableManager get paragraphs =>
      $$ParagraphsTableTableManager(_db, _db.paragraphs);
  $$TypingTestsTableTableManager get typingTests =>
      $$TypingTestsTableTableManager(_db, _db.typingTests);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$LessonProgressTableTableManager get lessonProgress =>
      $$LessonProgressTableTableManager(_db, _db.lessonProgress);
  $$MistakesTableTableManager get mistakes =>
      $$MistakesTableTableManager(_db, _db.mistakes);
  $$DailyProgressTableTableManager get dailyProgress =>
      $$DailyProgressTableTableManager(_db, _db.dailyProgress);
  $$StreaksTableTableManager get streaks =>
      $$StreaksTableTableManager(_db, _db.streaks);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
