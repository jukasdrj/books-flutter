// ignore_for_file: type=lint
part of 'database.dart';

class $WorksTable extends Works with TableInfo<$WorksTable, Work> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subjectTagsMeta =
      const VerificationMeta('subjectTags');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      subjectTags = GeneratedColumn<String>('subject_tags', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant(''))
          .withConverter<List<String>>($WorksTable.$convertersubjectTags);
  static const VerificationMeta _reviewStatusMeta =
      const VerificationMeta('reviewStatus');
  @override
  late final GeneratedColumnWithTypeConverter<ReviewStatus, int> reviewStatus =
      GeneratedColumn<int>('review_status', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<ReviewStatus>($WorksTable.$converterreviewStatus);
  static const VerificationMeta _originalImagePathMeta =
      const VerificationMeta('originalImagePath');
  @override
  late final GeneratedColumn<String> originalImagePath =
      GeneratedColumn<String>('original_image_path', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _boundingBoxMeta =
      const VerificationMeta('boundingBox');
  @override
  late final GeneratedColumn<String> boundingBox = GeneratedColumn<String>(
      'bounding_box', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _aiConfidenceMeta =
      const VerificationMeta('aiConfidence');
  @override
  late final GeneratedColumn<double> aiConfidence = GeneratedColumn<double>(
      'ai_confidence', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _syntheticMeta =
      const VerificationMeta('synthetic');
  @override
  late final GeneratedColumn<bool> synthetic = GeneratedColumn<bool>(
      'synthetic', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synthetic" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _primaryProviderMeta =
      const VerificationMeta('primaryProvider');
  @override
  late final GeneratedColumn<String> primaryProvider = GeneratedColumn<String>(
      'primary_provider', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contributorsMeta =
      const VerificationMeta('contributors');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
      contributors = GeneratedColumn<String>('contributors', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>($WorksTable.$convertercontributorsn);
  static const VerificationMeta _googleBooksVolumeIDsMeta =
      const VerificationMeta('googleBooksVolumeIDs');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
      googleBooksVolumeIDs = GeneratedColumn<String>(
              'google_books_volume_i_ds', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>(
              $WorksTable.$convertergoogleBooksVolumeIDsn);
  static const VerificationMeta _openLibraryWorkIDMeta =
      const VerificationMeta('openLibraryWorkID');
  @override
  late final GeneratedColumn<String> openLibraryWorkID =
      GeneratedColumn<String>('open_library_work_i_d', aliasedName, true,
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
        title,
        author,
        subjectTags,
        reviewStatus,
        originalImagePath,
        boundingBox,
        aiConfidence,
        synthetic,
        primaryProvider,
        contributors,
        googleBooksVolumeIDs,
        openLibraryWorkID,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'works';
  @override
  VerificationContext validateIntegrity(Insertable<Work> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    context.handle(_subjectTagsMeta, const VerificationResult.success());
    context.handle(_reviewStatusMeta, const VerificationResult.success());
    if (data.containsKey('original_image_path')) {
      context.handle(
          _originalImagePathMeta,
          originalImagePath.isAcceptableOrUnknown(
              data['original_image_path']!, _originalImagePathMeta));
    }
    if (data.containsKey('bounding_box')) {
      context.handle(
          _boundingBoxMeta,
          boundingBox.isAcceptableOrUnknown(
              data['bounding_box']!, _boundingBoxMeta));
    }
    if (data.containsKey('ai_confidence')) {
      context.handle(
          _aiConfidenceMeta,
          aiConfidence.isAcceptableOrUnknown(
              data['ai_confidence']!, _aiConfidenceMeta));
    }
    if (data.containsKey('synthetic')) {
      context.handle(_syntheticMeta,
          synthetic.isAcceptableOrUnknown(data['synthetic']!, _syntheticMeta));
    }
    if (data.containsKey('primary_provider')) {
      context.handle(
          _primaryProviderMeta,
          primaryProvider.isAcceptableOrUnknown(
              data['primary_provider']!, _primaryProviderMeta));
    }
    context.handle(_contributorsMeta, const VerificationResult.success());
    context.handle(
        _googleBooksVolumeIDsMeta, const VerificationResult.success());
    if (data.containsKey('open_library_work_i_d')) {
      context.handle(
          _openLibraryWorkIDMeta,
          openLibraryWorkID.isAcceptableOrUnknown(
              data['open_library_work_i_d']!, _openLibraryWorkIDMeta));
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
  Work map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Work(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      subjectTags: $WorksTable.$convertersubjectTags.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_tags'])!),
      reviewStatus: $WorksTable.$converterreviewStatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}review_status'])!),
      originalImagePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}original_image_path']),
      boundingBox: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bounding_box']),
      aiConfidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ai_confidence']),
      synthetic: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synthetic'])!,
      primaryProvider: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_provider']),
      contributors: $WorksTable.$convertercontributorsn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contributors'])),
      googleBooksVolumeIDs: $WorksTable.$convertergoogleBooksVolumeIDsn.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}google_books_volume_i_ds'])),
      openLibraryWorkID: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}open_library_work_i_d']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $WorksTable createAlias(String alias) {
    return $WorksTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertersubjectTags =
      const StringListConverter();
  static JsonTypeConverter2<ReviewStatus, int, int> $converterreviewStatus =
      const EnumIndexConverter<ReviewStatus>(ReviewStatus.values);
  static TypeConverter<List<String>, String> $convertercontributors =
      const StringListConverter();
  static TypeConverter<List<String>?, String?> $convertercontributorsn =
      NullAwareTypeConverter.wrap($convertercontributors);
  static TypeConverter<List<String>, String> $convertergoogleBooksVolumeIDs =
      const StringListConverter();
  static TypeConverter<List<String>?, String?> $convertergoogleBooksVolumeIDsn =
      NullAwareTypeConverter.wrap($convertergoogleBooksVolumeIDs);
}

class Work extends DataClass implements Insertable<Work> {
  final String id;
  final String title;
  final String? author;
  final List<String> subjectTags;
  final ReviewStatus reviewStatus;
  final String? originalImagePath;
  final String? boundingBox;
  final double? aiConfidence;
  final bool synthetic;
  final String? primaryProvider;
  final List<String>? contributors;
  final List<String>? googleBooksVolumeIDs;
  final String? openLibraryWorkID;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Work(
      {required this.id,
      required this.title,
      this.author,
      required this.subjectTags,
      required this.reviewStatus,
      this.originalImagePath,
      this.boundingBox,
      this.aiConfidence,
      required this.synthetic,
      this.primaryProvider,
      this.contributors,
      this.googleBooksVolumeIDs,
      this.openLibraryWorkID,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    {
      map['subject_tags'] = Variable<String>(
          $WorksTable.$convertersubjectTags.toSql(subjectTags));
    }
    {
      map['review_status'] =
          Variable<int>($WorksTable.$converterreviewStatus.toSql(reviewStatus));
    }
    if (!nullToAbsent || originalImagePath != null) {
      map['original_image_path'] = Variable<String>(originalImagePath);
    }
    if (!nullToAbsent || boundingBox != null) {
      map['bounding_box'] = Variable<String>(boundingBox);
    }
    if (!nullToAbsent || aiConfidence != null) {
      map['ai_confidence'] = Variable<double>(aiConfidence);
    }
    map['synthetic'] = Variable<bool>(synthetic);
    if (!nullToAbsent || primaryProvider != null) {
      map['primary_provider'] = Variable<String>(primaryProvider);
    }
    if (!nullToAbsent || contributors != null) {
      map['contributors'] = Variable<String>(
          $WorksTable.$convertercontributorsn.toSql(contributors));
    }
    if (!nullToAbsent || googleBooksVolumeIDs != null) {
      map['google_books_volume_i_ds'] = Variable<String>($WorksTable
          .$convertergoogleBooksVolumeIDsn
          .toSql(googleBooksVolumeIDs));
    }
    if (!nullToAbsent || openLibraryWorkID != null) {
      map['open_library_work_i_d'] = Variable<String>(openLibraryWorkID);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorksCompanion toCompanion(bool nullToAbsent) {
    return WorksCompanion(
      id: Value(id),
      title: Value(title),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      subjectTags: Value(subjectTags),
      reviewStatus: Value(reviewStatus),
      originalImagePath: originalImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(originalImagePath),
      boundingBox: boundingBox == null && nullToAbsent
          ? const Value.absent()
          : Value(boundingBox),
      aiConfidence: aiConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(aiConfidence),
      synthetic: Value(synthetic),
      primaryProvider: primaryProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryProvider),
      contributors: contributors == null && nullToAbsent
          ? const Value.absent()
          : Value(contributors),
      googleBooksVolumeIDs: googleBooksVolumeIDs == null && nullToAbsent
          ? const Value.absent()
          : Value(googleBooksVolumeIDs),
      openLibraryWorkID: openLibraryWorkID == null && nullToAbsent
          ? const Value.absent()
          : Value(openLibraryWorkID),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Work.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Work(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      subjectTags: serializer.fromJson<List<String>>(json['subjectTags']),
      reviewStatus: $WorksTable.$converterreviewStatus
          .fromJson(serializer.fromJson<int>(json['reviewStatus'])),
      originalImagePath:
          serializer.fromJson<String?>(json['originalImagePath']),
      boundingBox: serializer.fromJson<String?>(json['boundingBox']),
      aiConfidence: serializer.fromJson<double?>(json['aiConfidence']),
      synthetic: serializer.fromJson<bool>(json['synthetic']),
      primaryProvider: serializer.fromJson<String?>(json['primaryProvider']),
      contributors: serializer.fromJson<List<String>?>(json['contributors']),
      googleBooksVolumeIDs:
          serializer.fromJson<List<String>?>(json['googleBooksVolumeIDs']),
      openLibraryWorkID:
          serializer.fromJson<String?>(json['openLibraryWorkID']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'subjectTags': serializer.toJson<List<String>>(subjectTags),
      'reviewStatus': serializer
          .toJson<int>($WorksTable.$converterreviewStatus.toJson(reviewStatus)),
      'originalImagePath': serializer.toJson<String?>(originalImagePath),
      'boundingBox': serializer.toJson<String?>(boundingBox),
      'aiConfidence': serializer.toJson<double?>(aiConfidence),
      'synthetic': serializer.toJson<bool>(synthetic),
      'primaryProvider': serializer.toJson<String?>(primaryProvider),
      'contributors': serializer.toJson<List<String>?>(contributors),
      'googleBooksVolumeIDs':
          serializer.toJson<List<String>?>(googleBooksVolumeIDs),
      'openLibraryWorkID': serializer.toJson<String?>(openLibraryWorkID),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Work copyWith(
          {String? id,
          String? title,
          Value<String?> author = const Value.absent(),
          List<String>? subjectTags,
          ReviewStatus? reviewStatus,
          Value<String?> originalImagePath = const Value.absent(),
          Value<String?> boundingBox = const Value.absent(),
          Value<double?> aiConfidence = const Value.absent(),
          bool? synthetic,
          Value<String?> primaryProvider = const Value.absent(),
          Value<List<String>?> contributors = const Value.absent(),
          Value<List<String>?> googleBooksVolumeIDs = const Value.absent(),
          Value<String?> openLibraryWorkID = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Work(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author.present ? author.value : this.author,
        subjectTags: subjectTags ?? this.subjectTags,
        reviewStatus: reviewStatus ?? this.reviewStatus,
        originalImagePath: originalImagePath.present
            ? originalImagePath.value
            : this.originalImagePath,
        boundingBox: boundingBox.present ? boundingBox.value : this.boundingBox,
        aiConfidence:
            aiConfidence.present ? aiConfidence.value : this.aiConfidence,
        synthetic: synthetic ?? this.synthetic,
        primaryProvider: primaryProvider.present
            ? primaryProvider.value
            : this.primaryProvider,
        contributors:
            contributors.present ? contributors.value : this.contributors,
        googleBooksVolumeIDs: googleBooksVolumeIDs.present
            ? googleBooksVolumeIDs.value
            : this.googleBooksVolumeIDs,
        openLibraryWorkID: openLibraryWorkID.present
            ? openLibraryWorkID.value
            : this.openLibraryWorkID,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Work copyWithCompanion(WorksCompanion data) {
    return Work(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      subjectTags:
          data.subjectTags.present ? data.subjectTags.value : this.subjectTags,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      originalImagePath: data.originalImagePath.present
          ? data.originalImagePath.value
          : this.originalImagePath,
      boundingBox:
          data.boundingBox.present ? data.boundingBox.value : this.boundingBox,
      aiConfidence: data.aiConfidence.present
          ? data.aiConfidence.value
          : this.aiConfidence,
      synthetic: data.synthetic.present ? data.synthetic.value : this.synthetic,
      primaryProvider: data.primaryProvider.present
          ? data.primaryProvider.value
          : this.primaryProvider,
      contributors: data.contributors.present
          ? data.contributors.value
          : this.contributors,
      googleBooksVolumeIDs: data.googleBooksVolumeIDs.present
          ? data.googleBooksVolumeIDs.value
          : this.googleBooksVolumeIDs,
      openLibraryWorkID: data.openLibraryWorkID.present
          ? data.openLibraryWorkID.value
          : this.openLibraryWorkID,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Work(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('subjectTags: $subjectTags, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('originalImagePath: $originalImagePath, ')
          ..write('boundingBox: $boundingBox, ')
          ..write('aiConfidence: $aiConfidence, ')
          ..write('synthetic: $synthetic, ')
          ..write('primaryProvider: $primaryProvider, ')
          ..write('contributors: $contributors, ')
          ..write('googleBooksVolumeIDs: $googleBooksVolumeIDs, ')
          ..write('openLibraryWorkID: $openLibraryWorkID, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      author,
      subjectTags,
      reviewStatus,
      originalImagePath,
      boundingBox,
      aiConfidence,
      synthetic,
      primaryProvider,
      contributors,
      googleBooksVolumeIDs,
      openLibraryWorkID,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Work &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.subjectTags == this.subjectTags &&
          other.reviewStatus == this.reviewStatus &&
          other.originalImagePath == this.originalImagePath &&
          other.boundingBox == this.boundingBox &&
          other.aiConfidence == this.aiConfidence &&
          other.synthetic == this.synthetic &&
          other.primaryProvider == this.primaryProvider &&
          other.contributors == this.contributors &&
          other.googleBooksVolumeIDs == this.googleBooksVolumeIDs &&
          other.openLibraryWorkID == this.openLibraryWorkID &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorksCompanion extends UpdateCompanion<Work> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> author;
  final Value<List<String>> subjectTags;
  final Value<ReviewStatus> reviewStatus;
  final Value<String?> originalImagePath;
  final Value<String?> boundingBox;
  final Value<double?> aiConfidence;
  final Value<bool> synthetic;
  final Value<String?> primaryProvider;
  final Value<List<String>?> contributors;
  final Value<List<String>?> googleBooksVolumeIDs;
  final Value<String?> openLibraryWorkID;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.subjectTags = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.originalImagePath = const Value.absent(),
    this.boundingBox = const Value.absent(),
    this.aiConfidence = const Value.absent(),
    this.synthetic = const Value.absent(),
    this.primaryProvider = const Value.absent(),
    this.contributors = const Value.absent(),
    this.googleBooksVolumeIDs = const Value.absent(),
    this.openLibraryWorkID = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorksCompanion.insert({
    required String id,
    required String title,
    this.author = const Value.absent(),
    this.subjectTags = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.originalImagePath = const Value.absent(),
    this.boundingBox = const Value.absent(),
    this.aiConfidence = const Value.absent(),
    this.synthetic = const Value.absent(),
    this.primaryProvider = const Value.absent(),
    this.contributors = const Value.absent(),
    this.googleBooksVolumeIDs = const Value.absent(),
    this.openLibraryWorkID = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title);
  static Insertable<Work> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? subjectTags,
    Expression<int>? reviewStatus,
    Expression<String>? originalImagePath,
    Expression<String>? boundingBox,
    Expression<double>? aiConfidence,
    Expression<bool>? synthetic,
    Expression<String>? primaryProvider,
    Expression<String>? contributors,
    Expression<String>? googleBooksVolumeIDs,
    Expression<String>? openLibraryWorkID,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (subjectTags != null) 'subject_tags': subjectTags,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (originalImagePath != null) 'original_image_path': originalImagePath,
      if (boundingBox != null) 'bounding_box': boundingBox,
      if (aiConfidence != null) 'ai_confidence': aiConfidence,
      if (synthetic != null) 'synthetic': synthetic,
      if (primaryProvider != null) 'primary_provider': primaryProvider,
      if (contributors != null) 'contributors': contributors,
      if (googleBooksVolumeIDs != null)
        'google_books_volume_i_ds': googleBooksVolumeIDs,
      if (openLibraryWorkID != null) 'open_library_work_i_d': openLibraryWorkID,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? author,
      Value<List<String>>? subjectTags,
      Value<ReviewStatus>? reviewStatus,
      Value<String?>? originalImagePath,
      Value<String?>? boundingBox,
      Value<double?>? aiConfidence,
      Value<bool>? synthetic,
      Value<String?>? primaryProvider,
      Value<List<String>?>? contributors,
      Value<List<String>?>? googleBooksVolumeIDs,
      Value<String?>? openLibraryWorkID,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return WorksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      subjectTags: subjectTags ?? this.subjectTags,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      boundingBox: boundingBox ?? this.boundingBox,
      aiConfidence: aiConfidence ?? this.aiConfidence,
      synthetic: synthetic ?? this.synthetic,
      primaryProvider: primaryProvider ?? this.primaryProvider,
      contributors: contributors ?? this.contributors,
      googleBooksVolumeIDs: googleBooksVolumeIDs ?? this.googleBooksVolumeIDs,
      openLibraryWorkID: openLibraryWorkID ?? this.openLibraryWorkID,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (subjectTags.present) {
      map['subject_tags'] = Variable<String>(
          $WorksTable.$convertersubjectTags.toSql(subjectTags.value));
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<int>(
          $WorksTable.$converterreviewStatus.toSql(reviewStatus.value));
    }
    if (originalImagePath.present) {
      map['original_image_path'] = Variable<String>(originalImagePath.value);
    }
    if (boundingBox.present) {
      map['bounding_box'] = Variable<String>(boundingBox.value);
    }
    if (aiConfidence.present) {
      map['ai_confidence'] = Variable<double>(aiConfidence.value);
    }
    if (synthetic.present) {
      map['synthetic'] = Variable<bool>(synthetic.value);
    }
    if (primaryProvider.present) {
      map['primary_provider'] = Variable<String>(primaryProvider.value);
    }
    if (contributors.present) {
      map['contributors'] = Variable<String>(
          $WorksTable.$convertercontributorsn.toSql(contributors.value));
    }
    if (googleBooksVolumeIDs.present) {
      map['google_books_volume_i_ds'] = Variable<String>($WorksTable
          .$convertergoogleBooksVolumeIDsn
          .toSql(googleBooksVolumeIDs.value));
    }
    if (openLibraryWorkID.present) {
      map['open_library_work_i_d'] = Variable<String>(openLibraryWorkID.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('subjectTags: $subjectTags, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('originalImagePath: $originalImagePath, ')
          ..write('boundingBox: $boundingBox, ')
          ..write('aiConfidence: $aiConfidence, ')
          ..write('synthetic: $synthetic, ')
          ..write('primaryProvider: $primaryProvider, ')
          ..write('contributors: $contributors, ')
          ..write('googleBooksVolumeIDs: $googleBooksVolumeIDs, ')
          ..write('openLibraryWorkID: $openLibraryWorkID, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EditionsTable extends Editions with TableInfo<$EditionsTable, Edition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workIdMeta = const VerificationMeta('workId');
  @override
  late final GeneratedColumn<String> workId = GeneratedColumn<String>(
      'work_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES works (id) ON DELETE CASCADE'));
  static const VerificationMeta _isbnMeta = const VerificationMeta('isbn');
  @override
  late final GeneratedColumn<String> isbn = GeneratedColumn<String>(
      'isbn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isbnsMeta = const VerificationMeta('isbns');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> isbns =
      GeneratedColumn<String>('isbns', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant(''))
          .withConverter<List<String>>($EditionsTable.$converterisbns);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publisherMeta =
      const VerificationMeta('publisher');
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
      'publisher', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishedYearMeta =
      const VerificationMeta('publishedYear');
  @override
  late final GeneratedColumn<int> publishedYear = GeneratedColumn<int>(
      'published_year', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _coverImageURLMeta =
      const VerificationMeta('coverImageURL');
  @override
  late final GeneratedColumn<String> coverImageURL = GeneratedColumn<String>(
      'cover_image_u_r_l', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumnWithTypeConverter<EditionFormat, int> format =
      GeneratedColumn<int>('format', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(4))
          .withConverter<EditionFormat>($EditionsTable.$converterformat);
  static const VerificationMeta _pageCountMeta =
      const VerificationMeta('pageCount');
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
      'page_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _primaryProviderMeta =
      const VerificationMeta('primaryProvider');
  @override
  late final GeneratedColumn<String> primaryProvider = GeneratedColumn<String>(
      'primary_provider', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _googleBooksVolumeIDMeta =
      const VerificationMeta('googleBooksVolumeID');
  @override
  late final GeneratedColumn<String> googleBooksVolumeID =
      GeneratedColumn<String>('google_books_volume_i_d', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _openLibraryEditionIDMeta =
      const VerificationMeta('openLibraryEditionID');
  @override
  late final GeneratedColumn<String> openLibraryEditionID =
      GeneratedColumn<String>('open_library_edition_i_d', aliasedName, true,
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
        workId,
        isbn,
        isbns,
        title,
        publisher,
        publishedYear,
        coverImageURL,
        format,
        pageCount,
        primaryProvider,
        googleBooksVolumeID,
        openLibraryEditionID,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'editions';
  @override
  VerificationContext validateIntegrity(Insertable<Edition> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('work_id')) {
      context.handle(_workIdMeta,
          workId.isAcceptableOrUnknown(data['work_id']!, _workIdMeta));
    } else if (isInserting) {
      context.missing(_workIdMeta);
    }
    if (data.containsKey('isbn')) {
      context.handle(
          _isbnMeta, isbn.isAcceptableOrUnknown(data['isbn']!, _isbnMeta));
    }
    context.handle(_isbnsMeta, const VerificationResult.success());
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('publisher')) {
      context.handle(_publisherMeta,
          publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta));
    }
    if (data.containsKey('published_year')) {
      context.handle(
          _publishedYearMeta,
          publishedYear.isAcceptableOrUnknown(
              data['published_year']!, _publishedYearMeta));
    }
    if (data.containsKey('cover_image_u_r_l')) {
      context.handle(
          _coverImageURLMeta,
          coverImageURL.isAcceptableOrUnknown(
              data['cover_image_u_r_l']!, _coverImageURLMeta));
    }
    context.handle(_formatMeta, const VerificationResult.success());
    if (data.containsKey('page_count')) {
      context.handle(_pageCountMeta,
          pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta));
    }
    if (data.containsKey('primary_provider')) {
      context.handle(
          _primaryProviderMeta,
          primaryProvider.isAcceptableOrUnknown(
              data['primary_provider']!, _primaryProviderMeta));
    }
    if (data.containsKey('google_books_volume_i_d')) {
      context.handle(
          _googleBooksVolumeIDMeta,
          googleBooksVolumeID.isAcceptableOrUnknown(
              data['google_books_volume_i_d']!, _googleBooksVolumeIDMeta));
    }
    if (data.containsKey('open_library_edition_i_d')) {
      context.handle(
          _openLibraryEditionIDMeta,
          openLibraryEditionID.isAcceptableOrUnknown(
              data['open_library_edition_i_d']!, _openLibraryEditionIDMeta));
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
  Edition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Edition(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_id'])!,
      isbn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}isbn']),
      isbns: $EditionsTable.$converterisbns.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}isbns'])!),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      publisher: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}publisher']),
      publishedYear: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}published_year']),
      coverImageURL: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cover_image_u_r_l']),
      format: $EditionsTable.$converterformat.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}format'])!),
      pageCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_count']),
      primaryProvider: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_provider']),
      googleBooksVolumeID: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}google_books_volume_i_d']),
      openLibraryEditionID: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}open_library_edition_i_d']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $EditionsTable createAlias(String alias) {
    return $EditionsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterisbns =
      const StringListConverter();
  static JsonTypeConverter2<EditionFormat, int, int> $converterformat =
      const EnumIndexConverter<EditionFormat>(EditionFormat.values);
}

class Edition extends DataClass implements Insertable<Edition> {
  final String id;
  final String workId;
  final String? isbn;
  final List<String> isbns;
  final String? title;
  final String? publisher;
  final int? publishedYear;
  final String? coverImageURL;
  final EditionFormat format;
  final int? pageCount;
  final String? primaryProvider;
  final String? googleBooksVolumeID;
  final String? openLibraryEditionID;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Edition(
      {required this.id,
      required this.workId,
      this.isbn,
      required this.isbns,
      this.title,
      this.publisher,
      this.publishedYear,
      this.coverImageURL,
      required this.format,
      this.pageCount,
      this.primaryProvider,
      this.googleBooksVolumeID,
      this.openLibraryEditionID,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['work_id'] = Variable<String>(workId);
    if (!nullToAbsent || isbn != null) {
      map['isbn'] = Variable<String>(isbn);
    }
    {
      map['isbns'] =
          Variable<String>($EditionsTable.$converterisbns.toSql(isbns));
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || publishedYear != null) {
      map['published_year'] = Variable<int>(publishedYear);
    }
    if (!nullToAbsent || coverImageURL != null) {
      map['cover_image_u_r_l'] = Variable<String>(coverImageURL);
    }
    {
      map['format'] =
          Variable<int>($EditionsTable.$converterformat.toSql(format));
    }
    if (!nullToAbsent || pageCount != null) {
      map['page_count'] = Variable<int>(pageCount);
    }
    if (!nullToAbsent || primaryProvider != null) {
      map['primary_provider'] = Variable<String>(primaryProvider);
    }
    if (!nullToAbsent || googleBooksVolumeID != null) {
      map['google_books_volume_i_d'] = Variable<String>(googleBooksVolumeID);
    }
    if (!nullToAbsent || openLibraryEditionID != null) {
      map['open_library_edition_i_d'] = Variable<String>(openLibraryEditionID);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EditionsCompanion toCompanion(bool nullToAbsent) {
    return EditionsCompanion(
      id: Value(id),
      workId: Value(workId),
      isbn: isbn == null && nullToAbsent ? const Value.absent() : Value(isbn),
      isbns: Value(isbns),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      publishedYear: publishedYear == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedYear),
      coverImageURL: coverImageURL == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImageURL),
      format: Value(format),
      pageCount: pageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(pageCount),
      primaryProvider: primaryProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryProvider),
      googleBooksVolumeID: googleBooksVolumeID == null && nullToAbsent
          ? const Value.absent()
          : Value(googleBooksVolumeID),
      openLibraryEditionID: openLibraryEditionID == null && nullToAbsent
          ? const Value.absent()
          : Value(openLibraryEditionID),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Edition.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Edition(
      id: serializer.fromJson<String>(json['id']),
      workId: serializer.fromJson<String>(json['workId']),
      isbn: serializer.fromJson<String?>(json['isbn']),
      isbns: serializer.fromJson<List<String>>(json['isbns']),
      title: serializer.fromJson<String?>(json['title']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      publishedYear: serializer.fromJson<int?>(json['publishedYear']),
      coverImageURL: serializer.fromJson<String?>(json['coverImageURL']),
      format: $EditionsTable.$converterformat
          .fromJson(serializer.fromJson<int>(json['format'])),
      pageCount: serializer.fromJson<int?>(json['pageCount']),
      primaryProvider: serializer.fromJson<String?>(json['primaryProvider']),
      googleBooksVolumeID:
          serializer.fromJson<String?>(json['googleBooksVolumeID']),
      openLibraryEditionID:
          serializer.fromJson<String?>(json['openLibraryEditionID']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workId': serializer.toJson<String>(workId),
      'isbn': serializer.toJson<String?>(isbn),
      'isbns': serializer.toJson<List<String>>(isbns),
      'title': serializer.toJson<String?>(title),
      'publisher': serializer.toJson<String?>(publisher),
      'publishedYear': serializer.toJson<int?>(publishedYear),
      'coverImageURL': serializer.toJson<String?>(coverImageURL),
      'format': serializer
          .toJson<int>($EditionsTable.$converterformat.toJson(format)),
      'pageCount': serializer.toJson<int?>(pageCount),
      'primaryProvider': serializer.toJson<String?>(primaryProvider),
      'googleBooksVolumeID': serializer.toJson<String?>(googleBooksVolumeID),
      'openLibraryEditionID': serializer.toJson<String?>(openLibraryEditionID),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Edition copyWith(
          {String? id,
          String? workId,
          Value<String?> isbn = const Value.absent(),
          List<String>? isbns,
          Value<String?> title = const Value.absent(),
          Value<String?> publisher = const Value.absent(),
          Value<int?> publishedYear = const Value.absent(),
          Value<String?> coverImageURL = const Value.absent(),
          EditionFormat? format,
          Value<int?> pageCount = const Value.absent(),
          Value<String?> primaryProvider = const Value.absent(),
          Value<String?> googleBooksVolumeID = const Value.absent(),
          Value<String?> openLibraryEditionID = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Edition(
        id: id ?? this.id,
        workId: workId ?? this.workId,
        isbn: isbn.present ? isbn.value : this.isbn,
        isbns: isbns ?? this.isbns,
        title: title.present ? title.value : this.title,
        publisher: publisher.present ? publisher.value : this.publisher,
        publishedYear:
            publishedYear.present ? publishedYear.value : this.publishedYear,
        coverImageURL:
            coverImageURL.present ? coverImageURL.value : this.coverImageURL,
        format: format ?? this.format,
        pageCount: pageCount.present ? pageCount.value : this.pageCount,
        primaryProvider: primaryProvider.present
            ? primaryProvider.value
            : this.primaryProvider,
        googleBooksVolumeID: googleBooksVolumeID.present
            ? googleBooksVolumeID.value
            : this.googleBooksVolumeID,
        openLibraryEditionID: openLibraryEditionID.present
            ? openLibraryEditionID.value
            : this.openLibraryEditionID,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Edition copyWithCompanion(EditionsCompanion data) {
    return Edition(
      id: data.id.present ? data.id.value : this.id,
      workId: data.workId.present ? data.workId.value : this.workId,
      isbn: data.isbn.present ? data.isbn.value : this.isbn,
      isbns: data.isbns.present ? data.isbns.value : this.isbns,
      title: data.title.present ? data.title.value : this.title,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      publishedYear: data.publishedYear.present
          ? data.publishedYear.value
          : this.publishedYear,
      coverImageURL: data.coverImageURL.present
          ? data.coverImageURL.value
          : this.coverImageURL,
      format: data.format.present ? data.format.value : this.format,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      primaryProvider: data.primaryProvider.present
          ? data.primaryProvider.value
          : this.primaryProvider,
      googleBooksVolumeID: data.googleBooksVolumeID.present
          ? data.googleBooksVolumeID.value
          : this.googleBooksVolumeID,
      openLibraryEditionID: data.openLibraryEditionID.present
          ? data.openLibraryEditionID.value
          : this.openLibraryEditionID,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Edition(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('isbn: $isbn, ')
          ..write('isbns: $isbns, ')
          ..write('title: $title, ')
          ..write('publisher: $publisher, ')
          ..write('publishedYear: $publishedYear, ')
          ..write('coverImageURL: $coverImageURL, ')
          ..write('format: $format, ')
          ..write('pageCount: $pageCount, ')
          ..write('primaryProvider: $primaryProvider, ')
          ..write('googleBooksVolumeID: $googleBooksVolumeID, ')
          ..write('openLibraryEditionID: $openLibraryEditionID, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      workId,
      isbn,
      isbns,
      title,
      publisher,
      publishedYear,
      coverImageURL,
      format,
      pageCount,
      primaryProvider,
      googleBooksVolumeID,
      openLibraryEditionID,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Edition &&
          other.id == this.id &&
          other.workId == this.workId &&
          other.isbn == this.isbn &&
          other.isbns == this.isbns &&
          other.title == this.title &&
          other.publisher == this.publisher &&
          other.publishedYear == this.publishedYear &&
          other.coverImageURL == this.coverImageURL &&
          other.format == this.format &&
          other.pageCount == this.pageCount &&
          other.primaryProvider == this.primaryProvider &&
          other.googleBooksVolumeID == this.googleBooksVolumeID &&
          other.openLibraryEditionID == this.openLibraryEditionID &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EditionsCompanion extends UpdateCompanion<Edition> {
  final Value<String> id;
  final Value<String> workId;
  final Value<String?> isbn;
  final Value<List<String>> isbns;
  final Value<String?> title;
  final Value<String?> publisher;
  final Value<int?> publishedYear;
  final Value<String?> coverImageURL;
  final Value<EditionFormat> format;
  final Value<int?> pageCount;
  final Value<String?> primaryProvider;
  final Value<String?> googleBooksVolumeID;
  final Value<String?> openLibraryEditionID;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EditionsCompanion({
    this.id = const Value.absent(),
    this.workId = const Value.absent(),
    this.isbn = const Value.absent(),
    this.isbns = const Value.absent(),
    this.title = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publishedYear = const Value.absent(),
    this.coverImageURL = const Value.absent(),
    this.format = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.primaryProvider = const Value.absent(),
    this.googleBooksVolumeID = const Value.absent(),
    this.openLibraryEditionID = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EditionsCompanion.insert({
    required String id,
    required String workId,
    this.isbn = const Value.absent(),
    this.isbns = const Value.absent(),
    this.title = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publishedYear = const Value.absent(),
    this.coverImageURL = const Value.absent(),
    this.format = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.primaryProvider = const Value.absent(),
    this.googleBooksVolumeID = const Value.absent(),
    this.openLibraryEditionID = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        workId = Value(workId);
  static Insertable<Edition> custom({
    Expression<String>? id,
    Expression<String>? workId,
    Expression<String>? isbn,
    Expression<String>? isbns,
    Expression<String>? title,
    Expression<String>? publisher,
    Expression<int>? publishedYear,
    Expression<String>? coverImageURL,
    Expression<int>? format,
    Expression<int>? pageCount,
    Expression<String>? primaryProvider,
    Expression<String>? googleBooksVolumeID,
    Expression<String>? openLibraryEditionID,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workId != null) 'work_id': workId,
      if (isbn != null) 'isbn': isbn,
      if (isbns != null) 'isbns': isbns,
      if (title != null) 'title': title,
      if (publisher != null) 'publisher': publisher,
      if (publishedYear != null) 'published_year': publishedYear,
      if (coverImageURL != null) 'cover_image_u_r_l': coverImageURL,
      if (format != null) 'format': format,
      if (pageCount != null) 'page_count': pageCount,
      if (primaryProvider != null) 'primary_provider': primaryProvider,
      if (googleBooksVolumeID != null)
        'google_books_volume_i_d': googleBooksVolumeID,
      if (openLibraryEditionID != null)
        'open_library_edition_i_d': openLibraryEditionID,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EditionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? workId,
      Value<String?>? isbn,
      Value<List<String>>? isbns,
      Value<String?>? title,
      Value<String?>? publisher,
      Value<int?>? publishedYear,
      Value<String?>? coverImageURL,
      Value<EditionFormat>? format,
      Value<int?>? pageCount,
      Value<String?>? primaryProvider,
      Value<String?>? googleBooksVolumeID,
      Value<String?>? openLibraryEditionID,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return EditionsCompanion(
      id: id ?? this.id,
      workId: workId ?? this.workId,
      isbn: isbn ?? this.isbn,
      isbns: isbns ?? this.isbns,
      title: title ?? this.title,
      publisher: publisher ?? this.publisher,
      publishedYear: publishedYear ?? this.publishedYear,
      coverImageURL: coverImageURL ?? this.coverImageURL,
      format: format ?? this.format,
      pageCount: pageCount ?? this.pageCount,
      primaryProvider: primaryProvider ?? this.primaryProvider,
      googleBooksVolumeID: googleBooksVolumeID ?? this.googleBooksVolumeID,
      openLibraryEditionID: openLibraryEditionID ?? this.openLibraryEditionID,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workId.present) {
      map['work_id'] = Variable<String>(workId.value);
    }
    if (isbn.present) {
      map['isbn'] = Variable<String>(isbn.value);
    }
    if (isbns.present) {
      map['isbns'] =
          Variable<String>($EditionsTable.$converterisbns.toSql(isbns.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (publishedYear.present) {
      map['published_year'] = Variable<int>(publishedYear.value);
    }
    if (coverImageURL.present) {
      map['cover_image_u_r_l'] = Variable<String>(coverImageURL.value);
    }
    if (format.present) {
      map['format'] =
          Variable<int>($EditionsTable.$converterformat.toSql(format.value));
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (primaryProvider.present) {
      map['primary_provider'] = Variable<String>(primaryProvider.value);
    }
    if (googleBooksVolumeID.present) {
      map['google_books_volume_i_d'] =
          Variable<String>(googleBooksVolumeID.value);
    }
    if (openLibraryEditionID.present) {
      map['open_library_edition_i_d'] =
          Variable<String>(openLibraryEditionID.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EditionsCompanion(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('isbn: $isbn, ')
          ..write('isbns: $isbns, ')
          ..write('title: $title, ')
          ..write('publisher: $publisher, ')
          ..write('publishedYear: $publishedYear, ')
          ..write('coverImageURL: $coverImageURL, ')
          ..write('format: $format, ')
          ..write('pageCount: $pageCount, ')
          ..write('primaryProvider: $primaryProvider, ')
          ..write('googleBooksVolumeID: $googleBooksVolumeID, ')
          ..write('openLibraryEditionID: $openLibraryEditionID, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuthorsTable extends Authors with TableInfo<$AuthorsTable, Author> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumnWithTypeConverter<AuthorGender, int> gender =
      GeneratedColumn<int>('gender', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(3))
          .withConverter<AuthorGender>($AuthorsTable.$convertergender);
  static const VerificationMeta _culturalRegionMeta =
      const VerificationMeta('culturalRegion');
  @override
  late final GeneratedColumnWithTypeConverter<CulturalRegion?, int>
      culturalRegion = GeneratedColumn<int>(
              'cultural_region', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<CulturalRegion?>(
              $AuthorsTable.$converterculturalRegionn);
  static const VerificationMeta _openLibraryAuthorIDMeta =
      const VerificationMeta('openLibraryAuthorID');
  @override
  late final GeneratedColumn<String> openLibraryAuthorID =
      GeneratedColumn<String>('open_library_author_i_d', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _googleBooksAuthorIDMeta =
      const VerificationMeta('googleBooksAuthorID');
  @override
  late final GeneratedColumn<String> googleBooksAuthorID =
      GeneratedColumn<String>('google_books_author_i_d', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
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
        name,
        gender,
        culturalRegion,
        openLibraryAuthorID,
        googleBooksAuthorID,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'authors';
  @override
  VerificationContext validateIntegrity(Insertable<Author> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_genderMeta, const VerificationResult.success());
    context.handle(_culturalRegionMeta, const VerificationResult.success());
    if (data.containsKey('open_library_author_i_d')) {
      context.handle(
          _openLibraryAuthorIDMeta,
          openLibraryAuthorID.isAcceptableOrUnknown(
              data['open_library_author_i_d']!, _openLibraryAuthorIDMeta));
    }
    if (data.containsKey('google_books_author_i_d')) {
      context.handle(
          _googleBooksAuthorIDMeta,
          googleBooksAuthorID.isAcceptableOrUnknown(
              data['google_books_author_i_d']!, _googleBooksAuthorIDMeta));
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
  Author map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Author(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      gender: $AuthorsTable.$convertergender.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender'])!),
      culturalRegion: $AuthorsTable.$converterculturalRegionn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}cultural_region'])),
      openLibraryAuthorID: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}open_library_author_i_d']),
      googleBooksAuthorID: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}google_books_author_i_d']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AuthorsTable createAlias(String alias) {
    return $AuthorsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AuthorGender, int, int> $convertergender =
      const EnumIndexConverter<AuthorGender>(AuthorGender.values);
  static JsonTypeConverter2<CulturalRegion, int, int> $converterculturalRegion =
      const EnumIndexConverter<CulturalRegion>(CulturalRegion.values);
  static JsonTypeConverter2<CulturalRegion?, int?, int?>
      $converterculturalRegionn =
      JsonTypeConverter2.asNullable($converterculturalRegion);
}

class Author extends DataClass implements Insertable<Author> {
  final String id;
  final String name;
  final AuthorGender gender;
  final CulturalRegion? culturalRegion;
  final String? openLibraryAuthorID;
  final String? googleBooksAuthorID;
  final DateTime createdAt;
  const Author(
      {required this.id,
      required this.name,
      required this.gender,
      this.culturalRegion,
      this.openLibraryAuthorID,
      this.googleBooksAuthorID,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['gender'] =
          Variable<int>($AuthorsTable.$convertergender.toSql(gender));
    }
    if (!nullToAbsent || culturalRegion != null) {
      map['cultural_region'] = Variable<int>(
          $AuthorsTable.$converterculturalRegionn.toSql(culturalRegion));
    }
    if (!nullToAbsent || openLibraryAuthorID != null) {
      map['open_library_author_i_d'] = Variable<String>(openLibraryAuthorID);
    }
    if (!nullToAbsent || googleBooksAuthorID != null) {
      map['google_books_author_i_d'] = Variable<String>(googleBooksAuthorID);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuthorsCompanion toCompanion(bool nullToAbsent) {
    return AuthorsCompanion(
      id: Value(id),
      name: Value(name),
      gender: Value(gender),
      culturalRegion: culturalRegion == null && nullToAbsent
          ? const Value.absent()
          : Value(culturalRegion),
      openLibraryAuthorID: openLibraryAuthorID == null && nullToAbsent
          ? const Value.absent()
          : Value(openLibraryAuthorID),
      googleBooksAuthorID: googleBooksAuthorID == null && nullToAbsent
          ? const Value.absent()
          : Value(googleBooksAuthorID),
      createdAt: Value(createdAt),
    );
  }

  factory Author.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Author(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gender: $AuthorsTable.$convertergender
          .fromJson(serializer.fromJson<int>(json['gender'])),
      culturalRegion: $AuthorsTable.$converterculturalRegionn
          .fromJson(serializer.fromJson<int?>(json['culturalRegion'])),
      openLibraryAuthorID:
          serializer.fromJson<String?>(json['openLibraryAuthorID']),
      googleBooksAuthorID:
          serializer.fromJson<String?>(json['googleBooksAuthorID']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'gender':
          serializer.toJson<int>($AuthorsTable.$convertergender.toJson(gender)),
      'culturalRegion': serializer.toJson<int?>(
          $AuthorsTable.$converterculturalRegionn.toJson(culturalRegion)),
      'openLibraryAuthorID': serializer.toJson<String?>(openLibraryAuthorID),
      'googleBooksAuthorID': serializer.toJson<String?>(googleBooksAuthorID),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Author copyWith(
          {String? id,
          String? name,
          AuthorGender? gender,
          Value<CulturalRegion?> culturalRegion = const Value.absent(),
          Value<String?> openLibraryAuthorID = const Value.absent(),
          Value<String?> googleBooksAuthorID = const Value.absent(),
          DateTime? createdAt}) =>
      Author(
        id: id ?? this.id,
        name: name ?? this.name,
        gender: gender ?? this.gender,
        culturalRegion:
            culturalRegion.present ? culturalRegion.value : this.culturalRegion,
        openLibraryAuthorID: openLibraryAuthorID.present
            ? openLibraryAuthorID.value
            : this.openLibraryAuthorID,
        googleBooksAuthorID: googleBooksAuthorID.present
            ? googleBooksAuthorID.value
            : this.googleBooksAuthorID,
        createdAt: createdAt ?? this.createdAt,
      );
  Author copyWithCompanion(AuthorsCompanion data) {
    return Author(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      culturalRegion: data.culturalRegion.present
          ? data.culturalRegion.value
          : this.culturalRegion,
      openLibraryAuthorID: data.openLibraryAuthorID.present
          ? data.openLibraryAuthorID.value
          : this.openLibraryAuthorID,
      googleBooksAuthorID: data.googleBooksAuthorID.present
          ? data.googleBooksAuthorID.value
          : this.googleBooksAuthorID,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Author(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('culturalRegion: $culturalRegion, ')
          ..write('openLibraryAuthorID: $openLibraryAuthorID, ')
          ..write('googleBooksAuthorID: $googleBooksAuthorID, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, gender, culturalRegion,
      openLibraryAuthorID, googleBooksAuthorID, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Author &&
          other.id == this.id &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.culturalRegion == this.culturalRegion &&
          other.openLibraryAuthorID == this.openLibraryAuthorID &&
          other.googleBooksAuthorID == this.googleBooksAuthorID &&
          other.createdAt == this.createdAt);
}

class AuthorsCompanion extends UpdateCompanion<Author> {
  final Value<String> id;
  final Value<String> name;
  final Value<AuthorGender> gender;
  final Value<CulturalRegion?> culturalRegion;
  final Value<String?> openLibraryAuthorID;
  final Value<String?> googleBooksAuthorID;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AuthorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.culturalRegion = const Value.absent(),
    this.openLibraryAuthorID = const Value.absent(),
    this.googleBooksAuthorID = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthorsCompanion.insert({
    required String id,
    required String name,
    this.gender = const Value.absent(),
    this.culturalRegion = const Value.absent(),
    this.openLibraryAuthorID = const Value.absent(),
    this.googleBooksAuthorID = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Author> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? gender,
    Expression<int>? culturalRegion,
    Expression<String>? openLibraryAuthorID,
    Expression<String>? googleBooksAuthorID,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (culturalRegion != null) 'cultural_region': culturalRegion,
      if (openLibraryAuthorID != null)
        'open_library_author_i_d': openLibraryAuthorID,
      if (googleBooksAuthorID != null)
        'google_books_author_i_d': googleBooksAuthorID,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthorsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<AuthorGender>? gender,
      Value<CulturalRegion?>? culturalRegion,
      Value<String?>? openLibraryAuthorID,
      Value<String?>? googleBooksAuthorID,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AuthorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      culturalRegion: culturalRegion ?? this.culturalRegion,
      openLibraryAuthorID: openLibraryAuthorID ?? this.openLibraryAuthorID,
      googleBooksAuthorID: googleBooksAuthorID ?? this.googleBooksAuthorID,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] =
          Variable<int>($AuthorsTable.$convertergender.toSql(gender.value));
    }
    if (culturalRegion.present) {
      map['cultural_region'] = Variable<int>(
          $AuthorsTable.$converterculturalRegionn.toSql(culturalRegion.value));
    }
    if (openLibraryAuthorID.present) {
      map['open_library_author_i_d'] =
          Variable<String>(openLibraryAuthorID.value);
    }
    if (googleBooksAuthorID.present) {
      map['google_books_author_i_d'] =
          Variable<String>(googleBooksAuthorID.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('culturalRegion: $culturalRegion, ')
          ..write('openLibraryAuthorID: $openLibraryAuthorID, ')
          ..write('googleBooksAuthorID: $googleBooksAuthorID, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkAuthorsTable extends WorkAuthors
    with TableInfo<$WorkAuthorsTable, WorkAuthor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkAuthorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workIdMeta = const VerificationMeta('workId');
  @override
  late final GeneratedColumn<String> workId = GeneratedColumn<String>(
      'work_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES works (id) ON DELETE CASCADE'));
  static const VerificationMeta _authorIdMeta =
      const VerificationMeta('authorId');
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
      'author_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES authors (id) ON DELETE CASCADE'));
  static const VerificationMeta _authorOrderMeta =
      const VerificationMeta('authorOrder');
  @override
  late final GeneratedColumn<int> authorOrder = GeneratedColumn<int>(
      'author_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [workId, authorId, authorOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_authors';
  @override
  VerificationContext validateIntegrity(Insertable<WorkAuthor> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('work_id')) {
      context.handle(_workIdMeta,
          workId.isAcceptableOrUnknown(data['work_id']!, _workIdMeta));
    } else if (isInserting) {
      context.missing(_workIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(_authorIdMeta,
          authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta));
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_order')) {
      context.handle(
          _authorOrderMeta,
          authorOrder.isAcceptableOrUnknown(
              data['author_order']!, _authorOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workId, authorId};
  @override
  WorkAuthor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkAuthor(
      workId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_id'])!,
      authorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_id'])!,
      authorOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}author_order'])!,
    );
  }

  @override
  $WorkAuthorsTable createAlias(String alias) {
    return $WorkAuthorsTable(attachedDatabase, alias);
  }
}

class WorkAuthor extends DataClass implements Insertable<WorkAuthor> {
  final String workId;
  final String authorId;
  final int authorOrder;
  const WorkAuthor(
      {required this.workId,
      required this.authorId,
      required this.authorOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['work_id'] = Variable<String>(workId);
    map['author_id'] = Variable<String>(authorId);
    map['author_order'] = Variable<int>(authorOrder);
    return map;
  }

  WorkAuthorsCompanion toCompanion(bool nullToAbsent) {
    return WorkAuthorsCompanion(
      workId: Value(workId),
      authorId: Value(authorId),
      authorOrder: Value(authorOrder),
    );
  }

  factory WorkAuthor.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkAuthor(
      workId: serializer.fromJson<String>(json['workId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorOrder: serializer.fromJson<int>(json['authorOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workId': serializer.toJson<String>(workId),
      'authorId': serializer.toJson<String>(authorId),
      'authorOrder': serializer.toJson<int>(authorOrder),
    };
  }

  WorkAuthor copyWith({String? workId, String? authorId, int? authorOrder}) =>
      WorkAuthor(
        workId: workId ?? this.workId,
        authorId: authorId ?? this.authorId,
        authorOrder: authorOrder ?? this.authorOrder,
      );
  WorkAuthor copyWithCompanion(WorkAuthorsCompanion data) {
    return WorkAuthor(
      workId: data.workId.present ? data.workId.value : this.workId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorOrder:
          data.authorOrder.present ? data.authorOrder.value : this.authorOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkAuthor(')
          ..write('workId: $workId, ')
          ..write('authorId: $authorId, ')
          ..write('authorOrder: $authorOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(workId, authorId, authorOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkAuthor &&
          other.workId == this.workId &&
          other.authorId == this.authorId &&
          other.authorOrder == this.authorOrder);
}

class WorkAuthorsCompanion extends UpdateCompanion<WorkAuthor> {
  final Value<String> workId;
  final Value<String> authorId;
  final Value<int> authorOrder;
  final Value<int> rowid;
  const WorkAuthorsCompanion({
    this.workId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkAuthorsCompanion.insert({
    required String workId,
    required String authorId,
    this.authorOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : workId = Value(workId),
        authorId = Value(authorId);
  static Insertable<WorkAuthor> custom({
    Expression<String>? workId,
    Expression<String>? authorId,
    Expression<int>? authorOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workId != null) 'work_id': workId,
      if (authorId != null) 'author_id': authorId,
      if (authorOrder != null) 'author_order': authorOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkAuthorsCompanion copyWith(
      {Value<String>? workId,
      Value<String>? authorId,
      Value<int>? authorOrder,
      Value<int>? rowid}) {
    return WorkAuthorsCompanion(
      workId: workId ?? this.workId,
      authorId: authorId ?? this.authorId,
      authorOrder: authorOrder ?? this.authorOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workId.present) {
      map['work_id'] = Variable<String>(workId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorOrder.present) {
      map['author_order'] = Variable<int>(authorOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkAuthorsCompanion(')
          ..write('workId: $workId, ')
          ..write('authorId: $authorId, ')
          ..write('authorOrder: $authorOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserLibraryEntriesTable extends UserLibraryEntries
    with TableInfo<$UserLibraryEntriesTable, UserLibraryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserLibraryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workIdMeta = const VerificationMeta('workId');
  @override
  late final GeneratedColumn<String> workId = GeneratedColumn<String>(
      'work_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES works (id) ON DELETE CASCADE'));
  static const VerificationMeta _editionIdMeta =
      const VerificationMeta('editionId');
  @override
  late final GeneratedColumn<String> editionId = GeneratedColumn<String>(
      'edition_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES editions (id) ON DELETE SET NULL'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<ReadingStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<ReadingStatus>(
              $UserLibraryEntriesTable.$converterstatus);
  static const VerificationMeta _currentPageMeta =
      const VerificationMeta('currentPage');
  @override
  late final GeneratedColumn<int> currentPage = GeneratedColumn<int>(
      'current_page', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _completionDateMeta =
      const VerificationMeta('completionDate');
  @override
  late final GeneratedColumn<DateTime> completionDate =
      GeneratedColumn<DateTime>('completion_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _personalRatingMeta =
      const VerificationMeta('personalRating');
  @override
  late final GeneratedColumn<int> personalRating = GeneratedColumn<int>(
      'personal_rating', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
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
        workId,
        editionId,
        status,
        currentPage,
        completionDate,
        personalRating,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_library_entries';
  @override
  VerificationContext validateIntegrity(Insertable<UserLibraryEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('work_id')) {
      context.handle(_workIdMeta,
          workId.isAcceptableOrUnknown(data['work_id']!, _workIdMeta));
    } else if (isInserting) {
      context.missing(_workIdMeta);
    }
    if (data.containsKey('edition_id')) {
      context.handle(_editionIdMeta,
          editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('current_page')) {
      context.handle(
          _currentPageMeta,
          currentPage.isAcceptableOrUnknown(
              data['current_page']!, _currentPageMeta));
    }
    if (data.containsKey('completion_date')) {
      context.handle(
          _completionDateMeta,
          completionDate.isAcceptableOrUnknown(
              data['completion_date']!, _completionDateMeta));
    }
    if (data.containsKey('personal_rating')) {
      context.handle(
          _personalRatingMeta,
          personalRating.isAcceptableOrUnknown(
              data['personal_rating']!, _personalRatingMeta));
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {workId},
      ];
  @override
  UserLibraryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserLibraryEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_id'])!,
      editionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}edition_id']),
      status: $UserLibraryEntriesTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      currentPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_page']),
      completionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}completion_date']),
      personalRating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}personal_rating']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserLibraryEntriesTable createAlias(String alias) {
    return $UserLibraryEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReadingStatus, int, int> $converterstatus =
      const EnumIndexConverter<ReadingStatus>(ReadingStatus.values);
}

class UserLibraryEntry extends DataClass
    implements Insertable<UserLibraryEntry> {
  final String id;
  final String workId;
  final String? editionId;
  final ReadingStatus status;
  final int? currentPage;
  final DateTime? completionDate;
  final int? personalRating;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserLibraryEntry(
      {required this.id,
      required this.workId,
      this.editionId,
      required this.status,
      this.currentPage,
      this.completionDate,
      this.personalRating,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['work_id'] = Variable<String>(workId);
    if (!nullToAbsent || editionId != null) {
      map['edition_id'] = Variable<String>(editionId);
    }
    {
      map['status'] = Variable<int>(
          $UserLibraryEntriesTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || currentPage != null) {
      map['current_page'] = Variable<int>(currentPage);
    }
    if (!nullToAbsent || completionDate != null) {
      map['completion_date'] = Variable<DateTime>(completionDate);
    }
    if (!nullToAbsent || personalRating != null) {
      map['personal_rating'] = Variable<int>(personalRating);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserLibraryEntriesCompanion toCompanion(bool nullToAbsent) {
    return UserLibraryEntriesCompanion(
      id: Value(id),
      workId: Value(workId),
      editionId: editionId == null && nullToAbsent
          ? const Value.absent()
          : Value(editionId),
      status: Value(status),
      currentPage: currentPage == null && nullToAbsent
          ? const Value.absent()
          : Value(currentPage),
      completionDate: completionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(completionDate),
      personalRating: personalRating == null && nullToAbsent
          ? const Value.absent()
          : Value(personalRating),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserLibraryEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserLibraryEntry(
      id: serializer.fromJson<String>(json['id']),
      workId: serializer.fromJson<String>(json['workId']),
      editionId: serializer.fromJson<String?>(json['editionId']),
      status: $UserLibraryEntriesTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      currentPage: serializer.fromJson<int?>(json['currentPage']),
      completionDate: serializer.fromJson<DateTime?>(json['completionDate']),
      personalRating: serializer.fromJson<int?>(json['personalRating']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workId': serializer.toJson<String>(workId),
      'editionId': serializer.toJson<String?>(editionId),
      'status': serializer.toJson<int>(
          $UserLibraryEntriesTable.$converterstatus.toJson(status)),
      'currentPage': serializer.toJson<int?>(currentPage),
      'completionDate': serializer.toJson<DateTime?>(completionDate),
      'personalRating': serializer.toJson<int?>(personalRating),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserLibraryEntry copyWith(
          {String? id,
          String? workId,
          Value<String?> editionId = const Value.absent(),
          ReadingStatus? status,
          Value<int?> currentPage = const Value.absent(),
          Value<DateTime?> completionDate = const Value.absent(),
          Value<int?> personalRating = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UserLibraryEntry(
        id: id ?? this.id,
        workId: workId ?? this.workId,
        editionId: editionId.present ? editionId.value : this.editionId,
        status: status ?? this.status,
        currentPage: currentPage.present ? currentPage.value : this.currentPage,
        completionDate:
            completionDate.present ? completionDate.value : this.completionDate,
        personalRating:
            personalRating.present ? personalRating.value : this.personalRating,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserLibraryEntry copyWithCompanion(UserLibraryEntriesCompanion data) {
    return UserLibraryEntry(
      id: data.id.present ? data.id.value : this.id,
      workId: data.workId.present ? data.workId.value : this.workId,
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      status: data.status.present ? data.status.value : this.status,
      currentPage:
          data.currentPage.present ? data.currentPage.value : this.currentPage,
      completionDate: data.completionDate.present
          ? data.completionDate.value
          : this.completionDate,
      personalRating: data.personalRating.present
          ? data.personalRating.value
          : this.personalRating,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserLibraryEntry(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('editionId: $editionId, ')
          ..write('status: $status, ')
          ..write('currentPage: $currentPage, ')
          ..write('completionDate: $completionDate, ')
          ..write('personalRating: $personalRating, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workId, editionId, status, currentPage,
      completionDate, personalRating, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserLibraryEntry &&
          other.id == this.id &&
          other.workId == this.workId &&
          other.editionId == this.editionId &&
          other.status == this.status &&
          other.currentPage == this.currentPage &&
          other.completionDate == this.completionDate &&
          other.personalRating == this.personalRating &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserLibraryEntriesCompanion extends UpdateCompanion<UserLibraryEntry> {
  final Value<String> id;
  final Value<String> workId;
  final Value<String?> editionId;
  final Value<ReadingStatus> status;
  final Value<int?> currentPage;
  final Value<DateTime?> completionDate;
  final Value<int?> personalRating;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserLibraryEntriesCompanion({
    this.id = const Value.absent(),
    this.workId = const Value.absent(),
    this.editionId = const Value.absent(),
    this.status = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.completionDate = const Value.absent(),
    this.personalRating = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserLibraryEntriesCompanion.insert({
    required String id,
    required String workId,
    this.editionId = const Value.absent(),
    this.status = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.completionDate = const Value.absent(),
    this.personalRating = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        workId = Value(workId);
  static Insertable<UserLibraryEntry> custom({
    Expression<String>? id,
    Expression<String>? workId,
    Expression<String>? editionId,
    Expression<int>? status,
    Expression<int>? currentPage,
    Expression<DateTime>? completionDate,
    Expression<int>? personalRating,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workId != null) 'work_id': workId,
      if (editionId != null) 'edition_id': editionId,
      if (status != null) 'status': status,
      if (currentPage != null) 'current_page': currentPage,
      if (completionDate != null) 'completion_date': completionDate,
      if (personalRating != null) 'personal_rating': personalRating,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserLibraryEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? workId,
      Value<String?>? editionId,
      Value<ReadingStatus>? status,
      Value<int?>? currentPage,
      Value<DateTime?>? completionDate,
      Value<int?>? personalRating,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return UserLibraryEntriesCompanion(
      id: id ?? this.id,
      workId: workId ?? this.workId,
      editionId: editionId ?? this.editionId,
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
      completionDate: completionDate ?? this.completionDate,
      personalRating: personalRating ?? this.personalRating,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workId.present) {
      map['work_id'] = Variable<String>(workId.value);
    }
    if (editionId.present) {
      map['edition_id'] = Variable<String>(editionId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $UserLibraryEntriesTable.$converterstatus.toSql(status.value));
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
    }
    if (completionDate.present) {
      map['completion_date'] = Variable<DateTime>(completionDate.value);
    }
    if (personalRating.present) {
      map['personal_rating'] = Variable<int>(personalRating.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserLibraryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('editionId: $editionId, ')
          ..write('status: $status, ')
          ..write('currentPage: $currentPage, ')
          ..write('completionDate: $completionDate, ')
          ..write('personalRating: $personalRating, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScanSessionsTable extends ScanSessions
    with TableInfo<$ScanSessionsTable, ScanSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _totalDetectedMeta =
      const VerificationMeta('totalDetected');
  @override
  late final GeneratedColumn<int> totalDetected = GeneratedColumn<int>(
      'total_detected', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reviewedCountMeta =
      const VerificationMeta('reviewedCount');
  @override
  late final GeneratedColumn<int> reviewedCount = GeneratedColumn<int>(
      'reviewed_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _acceptedCountMeta =
      const VerificationMeta('acceptedCount');
  @override
  late final GeneratedColumn<int> acceptedCount = GeneratedColumn<int>(
      'accepted_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _rejectedCountMeta =
      const VerificationMeta('rejectedCount');
  @override
  late final GeneratedColumn<int> rejectedCount = GeneratedColumn<int>(
      'rejected_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('in_progress'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        totalDetected,
        reviewedCount,
        acceptedCount,
        rejectedCount,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<ScanSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('total_detected')) {
      context.handle(
          _totalDetectedMeta,
          totalDetected.isAcceptableOrUnknown(
              data['total_detected']!, _totalDetectedMeta));
    }
    if (data.containsKey('reviewed_count')) {
      context.handle(
          _reviewedCountMeta,
          reviewedCount.isAcceptableOrUnknown(
              data['reviewed_count']!, _reviewedCountMeta));
    }
    if (data.containsKey('accepted_count')) {
      context.handle(
          _acceptedCountMeta,
          acceptedCount.isAcceptableOrUnknown(
              data['accepted_count']!, _acceptedCountMeta));
    }
    if (data.containsKey('rejected_count')) {
      context.handle(
          _rejectedCountMeta,
          rejectedCount.isAcceptableOrUnknown(
              data['rejected_count']!, _rejectedCountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      totalDetected: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_detected'])!,
      reviewedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reviewed_count'])!,
      acceptedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}accepted_count'])!,
      rejectedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rejected_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $ScanSessionsTable createAlias(String alias) {
    return $ScanSessionsTable(attachedDatabase, alias);
  }
}

class ScanSession extends DataClass implements Insertable<ScanSession> {
  final String id;
  final DateTime createdAt;
  final int totalDetected;
  final int reviewedCount;
  final int acceptedCount;
  final int rejectedCount;
  final String status;
  const ScanSession(
      {required this.id,
      required this.createdAt,
      required this.totalDetected,
      required this.reviewedCount,
      required this.acceptedCount,
      required this.rejectedCount,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['total_detected'] = Variable<int>(totalDetected);
    map['reviewed_count'] = Variable<int>(reviewedCount);
    map['accepted_count'] = Variable<int>(acceptedCount);
    map['rejected_count'] = Variable<int>(rejectedCount);
    map['status'] = Variable<String>(status);
    return map;
  }

  ScanSessionsCompanion toCompanion(bool nullToAbsent) {
    return ScanSessionsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      totalDetected: Value(totalDetected),
      reviewedCount: Value(reviewedCount),
      acceptedCount: Value(acceptedCount),
      rejectedCount: Value(rejectedCount),
      status: Value(status),
    );
  }

  factory ScanSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanSession(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      totalDetected: serializer.fromJson<int>(json['totalDetected']),
      reviewedCount: serializer.fromJson<int>(json['reviewedCount']),
      acceptedCount: serializer.fromJson<int>(json['acceptedCount']),
      rejectedCount: serializer.fromJson<int>(json['rejectedCount']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'totalDetected': serializer.toJson<int>(totalDetected),
      'reviewedCount': serializer.toJson<int>(reviewedCount),
      'acceptedCount': serializer.toJson<int>(acceptedCount),
      'rejectedCount': serializer.toJson<int>(rejectedCount),
      'status': serializer.toJson<String>(status),
    };
  }

  ScanSession copyWith(
          {String? id,
          DateTime? createdAt,
          int? totalDetected,
          int? reviewedCount,
          int? acceptedCount,
          int? rejectedCount,
          String? status}) =>
      ScanSession(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        totalDetected: totalDetected ?? this.totalDetected,
        reviewedCount: reviewedCount ?? this.reviewedCount,
        acceptedCount: acceptedCount ?? this.acceptedCount,
        rejectedCount: rejectedCount ?? this.rejectedCount,
        status: status ?? this.status,
      );
  ScanSession copyWithCompanion(ScanSessionsCompanion data) {
    return ScanSession(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      totalDetected: data.totalDetected.present
          ? data.totalDetected.value
          : this.totalDetected,
      reviewedCount: data.reviewedCount.present
          ? data.reviewedCount.value
          : this.reviewedCount,
      acceptedCount: data.acceptedCount.present
          ? data.acceptedCount.value
          : this.acceptedCount,
      rejectedCount: data.rejectedCount.present
          ? data.rejectedCount.value
          : this.rejectedCount,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanSession(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('totalDetected: $totalDetected, ')
          ..write('reviewedCount: $reviewedCount, ')
          ..write('acceptedCount: $acceptedCount, ')
          ..write('rejectedCount: $rejectedCount, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, totalDetected, reviewedCount,
      acceptedCount, rejectedCount, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanSession &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.totalDetected == this.totalDetected &&
          other.reviewedCount == this.reviewedCount &&
          other.acceptedCount == this.acceptedCount &&
          other.rejectedCount == this.rejectedCount &&
          other.status == this.status);
}

class ScanSessionsCompanion extends UpdateCompanion<ScanSession> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<int> totalDetected;
  final Value<int> reviewedCount;
  final Value<int> acceptedCount;
  final Value<int> rejectedCount;
  final Value<String> status;
  final Value<int> rowid;
  const ScanSessionsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.totalDetected = const Value.absent(),
    this.reviewedCount = const Value.absent(),
    this.acceptedCount = const Value.absent(),
    this.rejectedCount = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScanSessionsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.totalDetected = const Value.absent(),
    this.reviewedCount = const Value.absent(),
    this.acceptedCount = const Value.absent(),
    this.rejectedCount = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ScanSession> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<int>? totalDetected,
    Expression<int>? reviewedCount,
    Expression<int>? acceptedCount,
    Expression<int>? rejectedCount,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (totalDetected != null) 'total_detected': totalDetected,
      if (reviewedCount != null) 'reviewed_count': reviewedCount,
      if (acceptedCount != null) 'accepted_count': acceptedCount,
      if (rejectedCount != null) 'rejected_count': rejectedCount,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScanSessionsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<int>? totalDetected,
      Value<int>? reviewedCount,
      Value<int>? acceptedCount,
      Value<int>? rejectedCount,
      Value<String>? status,
      Value<int>? rowid}) {
    return ScanSessionsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      totalDetected: totalDetected ?? this.totalDetected,
      reviewedCount: reviewedCount ?? this.reviewedCount,
      acceptedCount: acceptedCount ?? this.acceptedCount,
      rejectedCount: rejectedCount ?? this.rejectedCount,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (totalDetected.present) {
      map['total_detected'] = Variable<int>(totalDetected.value);
    }
    if (reviewedCount.present) {
      map['reviewed_count'] = Variable<int>(reviewedCount.value);
    }
    if (acceptedCount.present) {
      map['accepted_count'] = Variable<int>(acceptedCount.value);
    }
    if (rejectedCount.present) {
      map['rejected_count'] = Variable<int>(rejectedCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanSessionsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('totalDetected: $totalDetected, ')
          ..write('reviewedCount: $reviewedCount, ')
          ..write('acceptedCount: $acceptedCount, ')
          ..write('rejectedCount: $rejectedCount, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DetectedItemsTable extends DetectedItems
    with TableInfo<$DetectedItemsTable, DetectedItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DetectedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES scan_sessions (id) ON DELETE CASCADE'));
  static const VerificationMeta _workIdMeta = const VerificationMeta('workId');
  @override
  late final GeneratedColumn<String> workId = GeneratedColumn<String>(
      'work_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES works (id) ON DELETE SET NULL'));
  static const VerificationMeta _titleGuessMeta =
      const VerificationMeta('titleGuess');
  @override
  late final GeneratedColumn<String> titleGuess = GeneratedColumn<String>(
      'title_guess', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorGuessMeta =
      const VerificationMeta('authorGuess');
  @override
  late final GeneratedColumn<String> authorGuess = GeneratedColumn<String>(
      'author_guess', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _boundingBoxMeta =
      const VerificationMeta('boundingBox');
  @override
  late final GeneratedColumn<String> boundingBox = GeneratedColumn<String>(
      'bounding_box', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reviewStatusMeta =
      const VerificationMeta('reviewStatus');
  @override
  late final GeneratedColumnWithTypeConverter<ReviewStatus, int> reviewStatus =
      GeneratedColumn<int>('review_status', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<ReviewStatus>(
              $DetectedItemsTable.$converterreviewStatus);
  static const VerificationMeta _reviewedAtMeta =
      const VerificationMeta('reviewedAt');
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
      'reviewed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
        sessionId,
        workId,
        titleGuess,
        authorGuess,
        confidence,
        imagePath,
        boundingBox,
        reviewStatus,
        reviewedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'detected_items';
  @override
  VerificationContext validateIntegrity(Insertable<DetectedItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('work_id')) {
      context.handle(_workIdMeta,
          workId.isAcceptableOrUnknown(data['work_id']!, _workIdMeta));
    }
    if (data.containsKey('title_guess')) {
      context.handle(
          _titleGuessMeta,
          titleGuess.isAcceptableOrUnknown(
              data['title_guess']!, _titleGuessMeta));
    } else if (isInserting) {
      context.missing(_titleGuessMeta);
    }
    if (data.containsKey('author_guess')) {
      context.handle(
          _authorGuessMeta,
          authorGuess.isAcceptableOrUnknown(
              data['author_guess']!, _authorGuessMeta));
    } else if (isInserting) {
      context.missing(_authorGuessMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('bounding_box')) {
      context.handle(
          _boundingBoxMeta,
          boundingBox.isAcceptableOrUnknown(
              data['bounding_box']!, _boundingBoxMeta));
    }
    context.handle(_reviewStatusMeta, const VerificationResult.success());
    if (data.containsKey('reviewed_at')) {
      context.handle(
          _reviewedAtMeta,
          reviewedAt.isAcceptableOrUnknown(
              data['reviewed_at']!, _reviewedAtMeta));
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
  DetectedItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DetectedItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      workId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_id']),
      titleGuess: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_guess'])!,
      authorGuess: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_guess'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      boundingBox: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bounding_box']),
      reviewStatus: $DetectedItemsTable.$converterreviewStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}review_status'])!),
      reviewedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reviewed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DetectedItemsTable createAlias(String alias) {
    return $DetectedItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReviewStatus, int, int> $converterreviewStatus =
      const EnumIndexConverter<ReviewStatus>(ReviewStatus.values);
}

class DetectedItem extends DataClass implements Insertable<DetectedItem> {
  final String id;
  final String sessionId;
  final String? workId;
  final String titleGuess;
  final String authorGuess;
  final double confidence;
  final String? imagePath;
  final String? boundingBox;
  final ReviewStatus reviewStatus;
  final DateTime? reviewedAt;
  final DateTime createdAt;
  const DetectedItem(
      {required this.id,
      required this.sessionId,
      this.workId,
      required this.titleGuess,
      required this.authorGuess,
      required this.confidence,
      this.imagePath,
      this.boundingBox,
      required this.reviewStatus,
      this.reviewedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    if (!nullToAbsent || workId != null) {
      map['work_id'] = Variable<String>(workId);
    }
    map['title_guess'] = Variable<String>(titleGuess);
    map['author_guess'] = Variable<String>(authorGuess);
    map['confidence'] = Variable<double>(confidence);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || boundingBox != null) {
      map['bounding_box'] = Variable<String>(boundingBox);
    }
    {
      map['review_status'] = Variable<int>(
          $DetectedItemsTable.$converterreviewStatus.toSql(reviewStatus));
    }
    if (!nullToAbsent || reviewedAt != null) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DetectedItemsCompanion toCompanion(bool nullToAbsent) {
    return DetectedItemsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      workId:
          workId == null && nullToAbsent ? const Value.absent() : Value(workId),
      titleGuess: Value(titleGuess),
      authorGuess: Value(authorGuess),
      confidence: Value(confidence),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      boundingBox: boundingBox == null && nullToAbsent
          ? const Value.absent()
          : Value(boundingBox),
      reviewStatus: Value(reviewStatus),
      reviewedAt: reviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedAt),
      createdAt: Value(createdAt),
    );
  }

  factory DetectedItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DetectedItem(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      workId: serializer.fromJson<String?>(json['workId']),
      titleGuess: serializer.fromJson<String>(json['titleGuess']),
      authorGuess: serializer.fromJson<String>(json['authorGuess']),
      confidence: serializer.fromJson<double>(json['confidence']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      boundingBox: serializer.fromJson<String?>(json['boundingBox']),
      reviewStatus: $DetectedItemsTable.$converterreviewStatus
          .fromJson(serializer.fromJson<int>(json['reviewStatus'])),
      reviewedAt: serializer.fromJson<DateTime?>(json['reviewedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'workId': serializer.toJson<String?>(workId),
      'titleGuess': serializer.toJson<String>(titleGuess),
      'authorGuess': serializer.toJson<String>(authorGuess),
      'confidence': serializer.toJson<double>(confidence),
      'imagePath': serializer.toJson<String?>(imagePath),
      'boundingBox': serializer.toJson<String?>(boundingBox),
      'reviewStatus': serializer.toJson<int>(
          $DetectedItemsTable.$converterreviewStatus.toJson(reviewStatus)),
      'reviewedAt': serializer.toJson<DateTime?>(reviewedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DetectedItem copyWith(
          {String? id,
          String? sessionId,
          Value<String?> workId = const Value.absent(),
          String? titleGuess,
          String? authorGuess,
          double? confidence,
          Value<String?> imagePath = const Value.absent(),
          Value<String?> boundingBox = const Value.absent(),
          ReviewStatus? reviewStatus,
          Value<DateTime?> reviewedAt = const Value.absent(),
          DateTime? createdAt}) =>
      DetectedItem(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        workId: workId.present ? workId.value : this.workId,
        titleGuess: titleGuess ?? this.titleGuess,
        authorGuess: authorGuess ?? this.authorGuess,
        confidence: confidence ?? this.confidence,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        boundingBox: boundingBox.present ? boundingBox.value : this.boundingBox,
        reviewStatus: reviewStatus ?? this.reviewStatus,
        reviewedAt: reviewedAt.present ? reviewedAt.value : this.reviewedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  DetectedItem copyWithCompanion(DetectedItemsCompanion data) {
    return DetectedItem(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      workId: data.workId.present ? data.workId.value : this.workId,
      titleGuess:
          data.titleGuess.present ? data.titleGuess.value : this.titleGuess,
      authorGuess:
          data.authorGuess.present ? data.authorGuess.value : this.authorGuess,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      boundingBox:
          data.boundingBox.present ? data.boundingBox.value : this.boundingBox,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      reviewedAt:
          data.reviewedAt.present ? data.reviewedAt.value : this.reviewedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DetectedItem(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('workId: $workId, ')
          ..write('titleGuess: $titleGuess, ')
          ..write('authorGuess: $authorGuess, ')
          ..write('confidence: $confidence, ')
          ..write('imagePath: $imagePath, ')
          ..write('boundingBox: $boundingBox, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sessionId,
      workId,
      titleGuess,
      authorGuess,
      confidence,
      imagePath,
      boundingBox,
      reviewStatus,
      reviewedAt,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DetectedItem &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.workId == this.workId &&
          other.titleGuess == this.titleGuess &&
          other.authorGuess == this.authorGuess &&
          other.confidence == this.confidence &&
          other.imagePath == this.imagePath &&
          other.boundingBox == this.boundingBox &&
          other.reviewStatus == this.reviewStatus &&
          other.reviewedAt == this.reviewedAt &&
          other.createdAt == this.createdAt);
}

class DetectedItemsCompanion extends UpdateCompanion<DetectedItem> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String?> workId;
  final Value<String> titleGuess;
  final Value<String> authorGuess;
  final Value<double> confidence;
  final Value<String?> imagePath;
  final Value<String?> boundingBox;
  final Value<ReviewStatus> reviewStatus;
  final Value<DateTime?> reviewedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DetectedItemsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.workId = const Value.absent(),
    this.titleGuess = const Value.absent(),
    this.authorGuess = const Value.absent(),
    this.confidence = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.boundingBox = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DetectedItemsCompanion.insert({
    required String id,
    required String sessionId,
    this.workId = const Value.absent(),
    required String titleGuess,
    required String authorGuess,
    required double confidence,
    this.imagePath = const Value.absent(),
    this.boundingBox = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sessionId = Value(sessionId),
        titleGuess = Value(titleGuess),
        authorGuess = Value(authorGuess),
        confidence = Value(confidence);
  static Insertable<DetectedItem> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? workId,
    Expression<String>? titleGuess,
    Expression<String>? authorGuess,
    Expression<double>? confidence,
    Expression<String>? imagePath,
    Expression<String>? boundingBox,
    Expression<int>? reviewStatus,
    Expression<DateTime>? reviewedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (workId != null) 'work_id': workId,
      if (titleGuess != null) 'title_guess': titleGuess,
      if (authorGuess != null) 'author_guess': authorGuess,
      if (confidence != null) 'confidence': confidence,
      if (imagePath != null) 'image_path': imagePath,
      if (boundingBox != null) 'bounding_box': boundingBox,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DetectedItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sessionId,
      Value<String?>? workId,
      Value<String>? titleGuess,
      Value<String>? authorGuess,
      Value<double>? confidence,
      Value<String?>? imagePath,
      Value<String?>? boundingBox,
      Value<ReviewStatus>? reviewStatus,
      Value<DateTime?>? reviewedAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return DetectedItemsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      workId: workId ?? this.workId,
      titleGuess: titleGuess ?? this.titleGuess,
      authorGuess: authorGuess ?? this.authorGuess,
      confidence: confidence ?? this.confidence,
      imagePath: imagePath ?? this.imagePath,
      boundingBox: boundingBox ?? this.boundingBox,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (workId.present) {
      map['work_id'] = Variable<String>(workId.value);
    }
    if (titleGuess.present) {
      map['title_guess'] = Variable<String>(titleGuess.value);
    }
    if (authorGuess.present) {
      map['author_guess'] = Variable<String>(authorGuess.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (boundingBox.present) {
      map['bounding_box'] = Variable<String>(boundingBox.value);
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<int>(
          $DetectedItemsTable.$converterreviewStatus.toSql(reviewStatus.value));
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DetectedItemsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('workId: $workId, ')
          ..write('titleGuess: $titleGuess, ')
          ..write('authorGuess: $authorGuess, ')
          ..write('confidence: $confidence, ')
          ..write('imagePath: $imagePath, ')
          ..write('boundingBox: $boundingBox, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorksTable works = $WorksTable(this);
  late final $EditionsTable editions = $EditionsTable(this);
  late final $AuthorsTable authors = $AuthorsTable(this);
  late final $WorkAuthorsTable workAuthors = $WorkAuthorsTable(this);
  late final $UserLibraryEntriesTable userLibraryEntries =
      $UserLibraryEntriesTable(this);
  late final $ScanSessionsTable scanSessions = $ScanSessionsTable(this);
  late final $DetectedItemsTable detectedItems = $DetectedItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        works,
        editions,
        authors,
        workAuthors,
        userLibraryEntries,
        scanSessions,
        detectedItems
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('works',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('editions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('works',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('work_authors', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('authors',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('work_authors', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('works',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('user_library_entries', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('editions',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('user_library_entries', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('scan_sessions',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('detected_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('works',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('detected_items', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$WorksTableCreateCompanionBuilder = WorksCompanion Function({
  required String id,
  required String title,
  Value<String?> author,
  Value<List<String>> subjectTags,
  Value<ReviewStatus> reviewStatus,
  Value<String?> originalImagePath,
  Value<String?> boundingBox,
  Value<double?> aiConfidence,
  Value<bool> synthetic,
  Value<String?> primaryProvider,
  Value<List<String>?> contributors,
  Value<List<String>?> googleBooksVolumeIDs,
  Value<String?> openLibraryWorkID,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$WorksTableUpdateCompanionBuilder = WorksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> author,
  Value<List<String>> subjectTags,
  Value<ReviewStatus> reviewStatus,
  Value<String?> originalImagePath,
  Value<String?> boundingBox,
  Value<double?> aiConfidence,
  Value<bool> synthetic,
  Value<String?> primaryProvider,
  Value<List<String>?> contributors,
  Value<List<String>?> googleBooksVolumeIDs,
  Value<String?> openLibraryWorkID,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$WorksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorksTable,
    Work,
    $$WorksTableFilterComposer,
    $$WorksTableOrderingComposer,
    $$WorksTableCreateCompanionBuilder,
    $$WorksTableUpdateCompanionBuilder> {
  $$WorksTableTableManager(_$AppDatabase db, $WorksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$WorksTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$WorksTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<List<String>> subjectTags = const Value.absent(),
            Value<ReviewStatus> reviewStatus = const Value.absent(),
            Value<String?> originalImagePath = const Value.absent(),
            Value<String?> boundingBox = const Value.absent(),
            Value<double?> aiConfidence = const Value.absent(),
            Value<bool> synthetic = const Value.absent(),
            Value<String?> primaryProvider = const Value.absent(),
            Value<List<String>?> contributors = const Value.absent(),
            Value<List<String>?> googleBooksVolumeIDs = const Value.absent(),
            Value<String?> openLibraryWorkID = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorksCompanion(
            id: id,
            title: title,
            author: author,
            subjectTags: subjectTags,
            reviewStatus: reviewStatus,
            originalImagePath: originalImagePath,
            boundingBox: boundingBox,
            aiConfidence: aiConfidence,
            synthetic: synthetic,
            primaryProvider: primaryProvider,
            contributors: contributors,
            googleBooksVolumeIDs: googleBooksVolumeIDs,
            openLibraryWorkID: openLibraryWorkID,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> author = const Value.absent(),
            Value<List<String>> subjectTags = const Value.absent(),
            Value<ReviewStatus> reviewStatus = const Value.absent(),
            Value<String?> originalImagePath = const Value.absent(),
            Value<String?> boundingBox = const Value.absent(),
            Value<double?> aiConfidence = const Value.absent(),
            Value<bool> synthetic = const Value.absent(),
            Value<String?> primaryProvider = const Value.absent(),
            Value<List<String>?> contributors = const Value.absent(),
            Value<List<String>?> googleBooksVolumeIDs = const Value.absent(),
            Value<String?> openLibraryWorkID = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorksCompanion.insert(
            id: id,
            title: title,
            author: author,
            subjectTags: subjectTags,
            reviewStatus: reviewStatus,
            originalImagePath: originalImagePath,
            boundingBox: boundingBox,
            aiConfidence: aiConfidence,
            synthetic: synthetic,
            primaryProvider: primaryProvider,
            contributors: contributors,
            googleBooksVolumeIDs: googleBooksVolumeIDs,
            openLibraryWorkID: openLibraryWorkID,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$WorksTableFilterComposer
    extends FilterComposer<_$AppDatabase, $WorksTable> {
  $$WorksTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get author => $state.composableBuilder(
      column: $state.table.author,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get subjectTags => $state.composableBuilder(
          column: $state.table.subjectTags,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<ReviewStatus, ReviewStatus, int>
      get reviewStatus => $state.composableBuilder(
          column: $state.table.reviewStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get originalImagePath => $state.composableBuilder(
      column: $state.table.originalImagePath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get boundingBox => $state.composableBuilder(
      column: $state.table.boundingBox,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get aiConfidence => $state.composableBuilder(
      column: $state.table.aiConfidence,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get synthetic => $state.composableBuilder(
      column: $state.table.synthetic,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get primaryProvider => $state.composableBuilder(
      column: $state.table.primaryProvider,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get contributors => $state.composableBuilder(
          column: $state.table.contributors,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get googleBooksVolumeIDs => $state.composableBuilder(
          column: $state.table.googleBooksVolumeIDs,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get openLibraryWorkID => $state.composableBuilder(
      column: $state.table.openLibraryWorkID,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter editionsRefs(
      ComposableFilter Function($$EditionsTableFilterComposer f) f) {
    final $$EditionsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.editions,
        getReferencedColumn: (t) => t.workId,
        builder: (joinBuilder, parentComposers) =>
            $$EditionsTableFilterComposer(ComposerState(
                $state.db, $state.db.editions, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter workAuthorsRefs(
      ComposableFilter Function($$WorkAuthorsTableFilterComposer f) f) {
    final $$WorkAuthorsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.workAuthors,
        getReferencedColumn: (t) => t.workId,
        builder: (joinBuilder, parentComposers) =>
            $$WorkAuthorsTableFilterComposer(ComposerState($state.db,
                $state.db.workAuthors, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter userLibraryEntriesRefs(
      ComposableFilter Function($$UserLibraryEntriesTableFilterComposer f) f) {
    final $$UserLibraryEntriesTableFilterComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.userLibraryEntries,
            getReferencedColumn: (t) => t.workId,
            builder: (joinBuilder, parentComposers) =>
                $$UserLibraryEntriesTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.userLibraryEntries,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }

  ComposableFilter detectedItemsRefs(
      ComposableFilter Function($$DetectedItemsTableFilterComposer f) f) {
    final $$DetectedItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.detectedItems,
        getReferencedColumn: (t) => t.workId,
        builder: (joinBuilder, parentComposers) =>
            $$DetectedItemsTableFilterComposer(ComposerState($state.db,
                $state.db.detectedItems, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$WorksTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $WorksTable> {
  $$WorksTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get author => $state.composableBuilder(
      column: $state.table.author,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get subjectTags => $state.composableBuilder(
      column: $state.table.subjectTags,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get reviewStatus => $state.composableBuilder(
      column: $state.table.reviewStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get originalImagePath => $state.composableBuilder(
      column: $state.table.originalImagePath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get boundingBox => $state.composableBuilder(
      column: $state.table.boundingBox,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get aiConfidence => $state.composableBuilder(
      column: $state.table.aiConfidence,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get synthetic => $state.composableBuilder(
      column: $state.table.synthetic,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get primaryProvider => $state.composableBuilder(
      column: $state.table.primaryProvider,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get contributors => $state.composableBuilder(
      column: $state.table.contributors,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get googleBooksVolumeIDs => $state.composableBuilder(
      column: $state.table.googleBooksVolumeIDs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get openLibraryWorkID => $state.composableBuilder(
      column: $state.table.openLibraryWorkID,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$EditionsTableCreateCompanionBuilder = EditionsCompanion Function({
  required String id,
  required String workId,
  Value<String?> isbn,
  Value<List<String>> isbns,
  Value<String?> title,
  Value<String?> publisher,
  Value<int?> publishedYear,
  Value<String?> coverImageURL,
  Value<EditionFormat> format,
  Value<int?> pageCount,
  Value<String?> primaryProvider,
  Value<String?> googleBooksVolumeID,
  Value<String?> openLibraryEditionID,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$EditionsTableUpdateCompanionBuilder = EditionsCompanion Function({
  Value<String> id,
  Value<String> workId,
  Value<String?> isbn,
  Value<List<String>> isbns,
  Value<String?> title,
  Value<String?> publisher,
  Value<int?> publishedYear,
  Value<String?> coverImageURL,
  Value<EditionFormat> format,
  Value<int?> pageCount,
  Value<String?> primaryProvider,
  Value<String?> googleBooksVolumeID,
  Value<String?> openLibraryEditionID,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$EditionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EditionsTable,
    Edition,
    $$EditionsTableFilterComposer,
    $$EditionsTableOrderingComposer,
    $$EditionsTableCreateCompanionBuilder,
    $$EditionsTableUpdateCompanionBuilder> {
  $$EditionsTableTableManager(_$AppDatabase db, $EditionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$EditionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$EditionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> workId = const Value.absent(),
            Value<String?> isbn = const Value.absent(),
            Value<List<String>> isbns = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> publisher = const Value.absent(),
            Value<int?> publishedYear = const Value.absent(),
            Value<String?> coverImageURL = const Value.absent(),
            Value<EditionFormat> format = const Value.absent(),
            Value<int?> pageCount = const Value.absent(),
            Value<String?> primaryProvider = const Value.absent(),
            Value<String?> googleBooksVolumeID = const Value.absent(),
            Value<String?> openLibraryEditionID = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EditionsCompanion(
            id: id,
            workId: workId,
            isbn: isbn,
            isbns: isbns,
            title: title,
            publisher: publisher,
            publishedYear: publishedYear,
            coverImageURL: coverImageURL,
            format: format,
            pageCount: pageCount,
            primaryProvider: primaryProvider,
            googleBooksVolumeID: googleBooksVolumeID,
            openLibraryEditionID: openLibraryEditionID,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String workId,
            Value<String?> isbn = const Value.absent(),
            Value<List<String>> isbns = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> publisher = const Value.absent(),
            Value<int?> publishedYear = const Value.absent(),
            Value<String?> coverImageURL = const Value.absent(),
            Value<EditionFormat> format = const Value.absent(),
            Value<int?> pageCount = const Value.absent(),
            Value<String?> primaryProvider = const Value.absent(),
            Value<String?> googleBooksVolumeID = const Value.absent(),
            Value<String?> openLibraryEditionID = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EditionsCompanion.insert(
            id: id,
            workId: workId,
            isbn: isbn,
            isbns: isbns,
            title: title,
            publisher: publisher,
            publishedYear: publishedYear,
            coverImageURL: coverImageURL,
            format: format,
            pageCount: pageCount,
            primaryProvider: primaryProvider,
            googleBooksVolumeID: googleBooksVolumeID,
            openLibraryEditionID: openLibraryEditionID,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$EditionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $EditionsTable> {
  $$EditionsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get isbn => $state.composableBuilder(
      column: $state.table.isbn,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get isbns => $state.composableBuilder(
          column: $state.table.isbns,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get publisher => $state.composableBuilder(
      column: $state.table.publisher,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get publishedYear => $state.composableBuilder(
      column: $state.table.publishedYear,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get coverImageURL => $state.composableBuilder(
      column: $state.table.coverImageURL,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<EditionFormat, EditionFormat, int>
      get format => $state.composableBuilder(
          column: $state.table.format,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<int> get pageCount => $state.composableBuilder(
      column: $state.table.pageCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get primaryProvider => $state.composableBuilder(
      column: $state.table.primaryProvider,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get googleBooksVolumeID => $state.composableBuilder(
      column: $state.table.googleBooksVolumeID,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get openLibraryEditionID => $state.composableBuilder(
      column: $state.table.openLibraryEditionID,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$WorksTableFilterComposer get workId {
    final $$WorksTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workId,
        referencedTable: $state.db.works,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$WorksTableFilterComposer(
            ComposerState(
                $state.db, $state.db.works, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter userLibraryEntriesRefs(
      ComposableFilter Function($$UserLibraryEntriesTableFilterComposer f) f) {
    final $$UserLibraryEntriesTableFilterComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.userLibraryEntries,
            getReferencedColumn: (t) => t.editionId,
            builder: (joinBuilder, parentComposers) =>
                $$UserLibraryEntriesTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.userLibraryEntries,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$EditionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $EditionsTable> {
  $$EditionsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get isbn => $state.composableBuilder(
      column: $state.table.isbn,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get isbns => $state.composableBuilder(
      column: $state.table.isbns,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get publisher => $state.composableBuilder(
      column: $state.table.publisher,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get publishedYear => $state.composableBuilder(
      column: $state.table.publishedYear,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get coverImageURL => $state.composableBuilder(
      column: $state.table.coverImageURL,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get format => $state.composableBuilder(
      column: $state.table.format,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get pageCount => $state.composableBuilder(
      column: $state.table.pageCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get primaryProvider => $state.composableBuilder(
      column: $state.table.primaryProvider,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get googleBooksVolumeID => $state.composableBuilder(
      column: $state.table.googleBooksVolumeID,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get openLibraryEditionID => $state.composableBuilder(
      column: $state.table.openLibraryEditionID,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$WorksTableOrderingComposer get workId {
    final $$WorksTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workId,
        referencedTable: $state.db.works,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$WorksTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.works, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$AuthorsTableCreateCompanionBuilder = AuthorsCompanion Function({
  required String id,
  required String name,
  Value<AuthorGender> gender,
  Value<CulturalRegion?> culturalRegion,
  Value<String?> openLibraryAuthorID,
  Value<String?> googleBooksAuthorID,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AuthorsTableUpdateCompanionBuilder = AuthorsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<AuthorGender> gender,
  Value<CulturalRegion?> culturalRegion,
  Value<String?> openLibraryAuthorID,
  Value<String?> googleBooksAuthorID,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$AuthorsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuthorsTable,
    Author,
    $$AuthorsTableFilterComposer,
    $$AuthorsTableOrderingComposer,
    $$AuthorsTableCreateCompanionBuilder,
    $$AuthorsTableUpdateCompanionBuilder> {
  $$AuthorsTableTableManager(_$AppDatabase db, $AuthorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AuthorsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AuthorsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<AuthorGender> gender = const Value.absent(),
            Value<CulturalRegion?> culturalRegion = const Value.absent(),
            Value<String?> openLibraryAuthorID = const Value.absent(),
            Value<String?> googleBooksAuthorID = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthorsCompanion(
            id: id,
            name: name,
            gender: gender,
            culturalRegion: culturalRegion,
            openLibraryAuthorID: openLibraryAuthorID,
            googleBooksAuthorID: googleBooksAuthorID,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<AuthorGender> gender = const Value.absent(),
            Value<CulturalRegion?> culturalRegion = const Value.absent(),
            Value<String?> openLibraryAuthorID = const Value.absent(),
            Value<String?> googleBooksAuthorID = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthorsCompanion.insert(
            id: id,
            name: name,
            gender: gender,
            culturalRegion: culturalRegion,
            openLibraryAuthorID: openLibraryAuthorID,
            googleBooksAuthorID: googleBooksAuthorID,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$AuthorsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AuthorsTable> {
  $$AuthorsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<AuthorGender, AuthorGender, int> get gender =>
      $state.composableBuilder(
          column: $state.table.gender,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<CulturalRegion?, CulturalRegion, int>
      get culturalRegion => $state.composableBuilder(
          column: $state.table.culturalRegion,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get openLibraryAuthorID => $state.composableBuilder(
      column: $state.table.openLibraryAuthorID,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get googleBooksAuthorID => $state.composableBuilder(
      column: $state.table.googleBooksAuthorID,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter workAuthorsRefs(
      ComposableFilter Function($$WorkAuthorsTableFilterComposer f) f) {
    final $$WorkAuthorsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.workAuthors,
        getReferencedColumn: (t) => t.authorId,
        builder: (joinBuilder, parentComposers) =>
            $$WorkAuthorsTableFilterComposer(ComposerState($state.db,
                $state.db.workAuthors, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$AuthorsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AuthorsTable> {
  $$AuthorsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get culturalRegion => $state.composableBuilder(
      column: $state.table.culturalRegion,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get openLibraryAuthorID => $state.composableBuilder(
      column: $state.table.openLibraryAuthorID,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get googleBooksAuthorID => $state.composableBuilder(
      column: $state.table.googleBooksAuthorID,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$WorkAuthorsTableCreateCompanionBuilder = WorkAuthorsCompanion
    Function({
  required String workId,
  required String authorId,
  Value<int> authorOrder,
  Value<int> rowid,
});
typedef $$WorkAuthorsTableUpdateCompanionBuilder = WorkAuthorsCompanion
    Function({
  Value<String> workId,
  Value<String> authorId,
  Value<int> authorOrder,
  Value<int> rowid,
});

class $$WorkAuthorsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkAuthorsTable,
    WorkAuthor,
    $$WorkAuthorsTableFilterComposer,
    $$WorkAuthorsTableOrderingComposer,
    $$WorkAuthorsTableCreateCompanionBuilder,
    $$WorkAuthorsTableUpdateCompanionBuilder> {
  $$WorkAuthorsTableTableManager(_$AppDatabase db, $WorkAuthorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$WorkAuthorsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$WorkAuthorsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> workId = const Value.absent(),
            Value<String> authorId = const Value.absent(),
            Value<int> authorOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkAuthorsCompanion(
            workId: workId,
            authorId: authorId,
            authorOrder: authorOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String workId,
            required String authorId,
            Value<int> authorOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkAuthorsCompanion.insert(
            workId: workId,
            authorId: authorId,
            authorOrder: authorOrder,
            rowid: rowid,
          ),
        ));
}

class $$WorkAuthorsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $WorkAuthorsTable> {
  $$WorkAuthorsTableFilterComposer(super.$state);
  ColumnFilters<int> get authorOrder => $state.composableBuilder(
      column: $state.table.authorOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$WorksTableFilterComposer get workId {
    final $$WorksTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workId,
        referencedTable: $state.db.works,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$WorksTableFilterComposer(
            ComposerState(
                $state.db, $state.db.works, joinBuilder, parentComposers)));
    return composer;
  }

  $$AuthorsTableFilterComposer get authorId {
    final $$AuthorsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.authorId,
        referencedTable: $state.db.authors,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$AuthorsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.authors, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$WorkAuthorsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $WorkAuthorsTable> {
  $$WorkAuthorsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get authorOrder => $state.composableBuilder(
      column: $state.table.authorOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$WorksTableOrderingComposer get workId {
    final $$WorksTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workId,
        referencedTable: $state.db.works,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$WorksTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.works, joinBuilder, parentComposers)));
    return composer;
  }

  $$AuthorsTableOrderingComposer get authorId {
    final $$AuthorsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.authorId,
        referencedTable: $state.db.authors,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$AuthorsTableOrderingComposer(ComposerState(
                $state.db, $state.db.authors, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$UserLibraryEntriesTableCreateCompanionBuilder
    = UserLibraryEntriesCompanion Function({
  required String id,
  required String workId,
  Value<String?> editionId,
  Value<ReadingStatus> status,
  Value<int?> currentPage,
  Value<DateTime?> completionDate,
  Value<int?> personalRating,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$UserLibraryEntriesTableUpdateCompanionBuilder
    = UserLibraryEntriesCompanion Function({
  Value<String> id,
  Value<String> workId,
  Value<String?> editionId,
  Value<ReadingStatus> status,
  Value<int?> currentPage,
  Value<DateTime?> completionDate,
  Value<int?> personalRating,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$UserLibraryEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserLibraryEntriesTable,
    UserLibraryEntry,
    $$UserLibraryEntriesTableFilterComposer,
    $$UserLibraryEntriesTableOrderingComposer,
    $$UserLibraryEntriesTableCreateCompanionBuilder,
    $$UserLibraryEntriesTableUpdateCompanionBuilder> {
  $$UserLibraryEntriesTableTableManager(
      _$AppDatabase db, $UserLibraryEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$UserLibraryEntriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$UserLibraryEntriesTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> workId = const Value.absent(),
            Value<String?> editionId = const Value.absent(),
            Value<ReadingStatus> status = const Value.absent(),
            Value<int?> currentPage = const Value.absent(),
            Value<DateTime?> completionDate = const Value.absent(),
            Value<int?> personalRating = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserLibraryEntriesCompanion(
            id: id,
            workId: workId,
            editionId: editionId,
            status: status,
            currentPage: currentPage,
            completionDate: completionDate,
            personalRating: personalRating,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String workId,
            Value<String?> editionId = const Value.absent(),
            Value<ReadingStatus> status = const Value.absent(),
            Value<int?> currentPage = const Value.absent(),
            Value<DateTime?> completionDate = const Value.absent(),
            Value<int?> personalRating = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserLibraryEntriesCompanion.insert(
            id: id,
            workId: workId,
            editionId: editionId,
            status: status,
            currentPage: currentPage,
            completionDate: completionDate,
            personalRating: personalRating,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$UserLibraryEntriesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UserLibraryEntriesTable> {
  $$UserLibraryEntriesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<ReadingStatus, ReadingStatus, int>
      get status => $state.composableBuilder(
          column: $state.table.status,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<int> get currentPage => $state.composableBuilder(
      column: $state.table.currentPage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get completionDate => $state.composableBuilder(
      column: $state.table.completionDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get personalRating => $state.composableBuilder(
      column: $state.table.personalRating,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$WorksTableFilterComposer get workId {
    final $$WorksTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workId,
        referencedTable: $state.db.works,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$WorksTableFilterComposer(
            ComposerState(
                $state.db, $state.db.works, joinBuilder, parentComposers)));
    return composer;
  }

  $$EditionsTableFilterComposer get editionId {
    final $$EditionsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.editionId,
        referencedTable: $state.db.editions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$EditionsTableFilterComposer(ComposerState(
                $state.db, $state.db.editions, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$UserLibraryEntriesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UserLibraryEntriesTable> {
  $$UserLibraryEntriesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get currentPage => $state.composableBuilder(
      column: $state.table.currentPage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get completionDate => $state.composableBuilder(
      column: $state.table.completionDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get personalRating => $state.composableBuilder(
      column: $state.table.personalRating,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$WorksTableOrderingComposer get workId {
    final $$WorksTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workId,
        referencedTable: $state.db.works,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$WorksTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.works, joinBuilder, parentComposers)));
    return composer;
  }

  $$EditionsTableOrderingComposer get editionId {
    final $$EditionsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.editionId,
        referencedTable: $state.db.editions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$EditionsTableOrderingComposer(ComposerState(
                $state.db, $state.db.editions, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ScanSessionsTableCreateCompanionBuilder = ScanSessionsCompanion
    Function({
  required String id,
  Value<DateTime> createdAt,
  Value<int> totalDetected,
  Value<int> reviewedCount,
  Value<int> acceptedCount,
  Value<int> rejectedCount,
  Value<String> status,
  Value<int> rowid,
});
typedef $$ScanSessionsTableUpdateCompanionBuilder = ScanSessionsCompanion
    Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<int> totalDetected,
  Value<int> reviewedCount,
  Value<int> acceptedCount,
  Value<int> rejectedCount,
  Value<String> status,
  Value<int> rowid,
});

class $$ScanSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScanSessionsTable,
    ScanSession,
    $$ScanSessionsTableFilterComposer,
    $$ScanSessionsTableOrderingComposer,
    $$ScanSessionsTableCreateCompanionBuilder,
    $$ScanSessionsTableUpdateCompanionBuilder> {
  $$ScanSessionsTableTableManager(_$AppDatabase db, $ScanSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ScanSessionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ScanSessionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> totalDetected = const Value.absent(),
            Value<int> reviewedCount = const Value.absent(),
            Value<int> acceptedCount = const Value.absent(),
            Value<int> rejectedCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScanSessionsCompanion(
            id: id,
            createdAt: createdAt,
            totalDetected: totalDetected,
            reviewedCount: reviewedCount,
            acceptedCount: acceptedCount,
            rejectedCount: rejectedCount,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> totalDetected = const Value.absent(),
            Value<int> reviewedCount = const Value.absent(),
            Value<int> acceptedCount = const Value.absent(),
            Value<int> rejectedCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScanSessionsCompanion.insert(
            id: id,
            createdAt: createdAt,
            totalDetected: totalDetected,
            reviewedCount: reviewedCount,
            acceptedCount: acceptedCount,
            rejectedCount: rejectedCount,
            status: status,
            rowid: rowid,
          ),
        ));
}

class $$ScanSessionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ScanSessionsTable> {
  $$ScanSessionsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get totalDetected => $state.composableBuilder(
      column: $state.table.totalDetected,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get reviewedCount => $state.composableBuilder(
      column: $state.table.reviewedCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get acceptedCount => $state.composableBuilder(
      column: $state.table.acceptedCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get rejectedCount => $state.composableBuilder(
      column: $state.table.rejectedCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter detectedItemsRefs(
      ComposableFilter Function($$DetectedItemsTableFilterComposer f) f) {
    final $$DetectedItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.detectedItems,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder, parentComposers) =>
            $$DetectedItemsTableFilterComposer(ComposerState($state.db,
                $state.db.detectedItems, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ScanSessionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ScanSessionsTable> {
  $$ScanSessionsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get totalDetected => $state.composableBuilder(
      column: $state.table.totalDetected,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get reviewedCount => $state.composableBuilder(
      column: $state.table.reviewedCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get acceptedCount => $state.composableBuilder(
      column: $state.table.acceptedCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get rejectedCount => $state.composableBuilder(
      column: $state.table.rejectedCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$DetectedItemsTableCreateCompanionBuilder = DetectedItemsCompanion
    Function({
  required String id,
  required String sessionId,
  Value<String?> workId,
  required String titleGuess,
  required String authorGuess,
  required double confidence,
  Value<String?> imagePath,
  Value<String?> boundingBox,
  Value<ReviewStatus> reviewStatus,
  Value<DateTime?> reviewedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$DetectedItemsTableUpdateCompanionBuilder = DetectedItemsCompanion
    Function({
  Value<String> id,
  Value<String> sessionId,
  Value<String?> workId,
  Value<String> titleGuess,
  Value<String> authorGuess,
  Value<double> confidence,
  Value<String?> imagePath,
  Value<String?> boundingBox,
  Value<ReviewStatus> reviewStatus,
  Value<DateTime?> reviewedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$DetectedItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DetectedItemsTable,
    DetectedItem,
    $$DetectedItemsTableFilterComposer,
    $$DetectedItemsTableOrderingComposer,
    $$DetectedItemsTableCreateCompanionBuilder,
    $$DetectedItemsTableUpdateCompanionBuilder> {
  $$DetectedItemsTableTableManager(_$AppDatabase db, $DetectedItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DetectedItemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DetectedItemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<String?> workId = const Value.absent(),
            Value<String> titleGuess = const Value.absent(),
            Value<String> authorGuess = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<String?> boundingBox = const Value.absent(),
            Value<ReviewStatus> reviewStatus = const Value.absent(),
            Value<DateTime?> reviewedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DetectedItemsCompanion(
            id: id,
            sessionId: sessionId,
            workId: workId,
            titleGuess: titleGuess,
            authorGuess: authorGuess,
            confidence: confidence,
            imagePath: imagePath,
            boundingBox: boundingBox,
            reviewStatus: reviewStatus,
            reviewedAt: reviewedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sessionId,
            Value<String?> workId = const Value.absent(),
            required String titleGuess,
            required String authorGuess,
            required double confidence,
            Value<String?> imagePath = const Value.absent(),
            Value<String?> boundingBox = const Value.absent(),
            Value<ReviewStatus> reviewStatus = const Value.absent(),
            Value<DateTime?> reviewedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DetectedItemsCompanion.insert(
            id: id,
            sessionId: sessionId,
            workId: workId,
            titleGuess: titleGuess,
            authorGuess: authorGuess,
            confidence: confidence,
            imagePath: imagePath,
            boundingBox: boundingBox,
            reviewStatus: reviewStatus,
            reviewedAt: reviewedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$DetectedItemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $DetectedItemsTable> {
  $$DetectedItemsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get titleGuess => $state.composableBuilder(
      column: $state.table.titleGuess,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get authorGuess => $state.composableBuilder(
      column: $state.table.authorGuess,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get confidence => $state.composableBuilder(
      column: $state.table.confidence,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get imagePath => $state.composableBuilder(
      column: $state.table.imagePath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get boundingBox => $state.composableBuilder(
      column: $state.table.boundingBox,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<ReviewStatus, ReviewStatus, int>
      get reviewStatus => $state.composableBuilder(
          column: $state.table.reviewStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get reviewedAt => $state.composableBuilder(
      column: $state.table.reviewedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ScanSessionsTableFilterComposer get sessionId {
    final $$ScanSessionsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $state.db.scanSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ScanSessionsTableFilterComposer(ComposerState($state.db,
                $state.db.scanSessions, joinBuilder, parentComposers)));
    return composer;
  }

  $$WorksTableFilterComposer get workId {
    final $$WorksTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workId,
        referencedTable: $state.db.works,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$WorksTableFilterComposer(
            ComposerState(
                $state.db, $state.db.works, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$DetectedItemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $DetectedItemsTable> {
  $$DetectedItemsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get titleGuess => $state.composableBuilder(
      column: $state.table.titleGuess,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get authorGuess => $state.composableBuilder(
      column: $state.table.authorGuess,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get confidence => $state.composableBuilder(
      column: $state.table.confidence,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get imagePath => $state.composableBuilder(
      column: $state.table.imagePath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get boundingBox => $state.composableBuilder(
      column: $state.table.boundingBox,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get reviewStatus => $state.composableBuilder(
      column: $state.table.reviewStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get reviewedAt => $state.composableBuilder(
      column: $state.table.reviewedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ScanSessionsTableOrderingComposer get sessionId {
    final $$ScanSessionsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $state.db.scanSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ScanSessionsTableOrderingComposer(ComposerState($state.db,
                $state.db.scanSessions, joinBuilder, parentComposers)));
    return composer;
  }

  $$WorksTableOrderingComposer get workId {
    final $$WorksTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workId,
        referencedTable: $state.db.works,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$WorksTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.works, joinBuilder, parentComposers)));
    return composer;
  }
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorksTableTableManager get works =>
      $$WorksTableTableManager(_db, _db.works);
  $$EditionsTableTableManager get editions =>
      $$EditionsTableTableManager(_db, _db.editions);
  $$AuthorsTableTableManager get authors =>
      $$AuthorsTableTableManager(_db, _db.authors);
  $$WorkAuthorsTableTableManager get workAuthors =>
      $$WorkAuthorsTableTableManager(_db, _db.workAuthors);
  $$UserLibraryEntriesTableTableManager get userLibraryEntries =>
      $$UserLibraryEntriesTableTableManager(_db, _db.userLibraryEntries);
  $$ScanSessionsTableTableManager get scanSessions =>
      $$ScanSessionsTableTableManager(_db, _db.scanSessions);
  $$DetectedItemsTableTableManager get detectedItems =>
      $$DetectedItemsTableTableManager(_db, _db.detectedItems);
}
