// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CardsTable extends Cards with TableInfo<$CardsTable, Card> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardNumberMeta = const VerificationMeta(
    'cardNumber',
  );
  @override
  late final GeneratedColumn<String> cardNumber = GeneratedColumn<String>(
    'card_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelsJsonMeta = const VerificationMeta(
    'levelsJson',
  );
  @override
  late final GeneratedColumn<String> levelsJson = GeneratedColumn<String>(
    'levels_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
    'rarity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setCodeMeta = const VerificationMeta(
    'setCode',
  );
  @override
  late final GeneratedColumn<String> setCode = GeneratedColumn<String>(
    'set_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _effectTextRewriteMeta = const VerificationMeta(
    'effectTextRewrite',
  );
  @override
  late final GeneratedColumn<String> effectTextRewrite =
      GeneratedColumn<String>(
        'effect_text_rewrite',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _keywordsJsonMeta = const VerificationMeta(
    'keywordsJson',
  );
  @override
  late final GeneratedColumn<String> keywordsJson = GeneratedColumn<String>(
    'keywords_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parallelVariantsJsonMeta =
      const VerificationMeta('parallelVariantsJson');
  @override
  late final GeneratedColumn<String> parallelVariantsJson =
      GeneratedColumn<String>(
        'parallel_variants_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _releaseDateMeta = const VerificationMeta(
    'releaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
    'release_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardNumber,
    nameEn,
    type,
    color,
    cost,
    levelsJson,
    rarity,
    setCode,
    imageUrl,
    effectTextRewrite,
    keywordsJson,
    parallelVariantsJson,
    releaseDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Card> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_number')) {
      context.handle(
        _cardNumberMeta,
        cardNumber.isAcceptableOrUnknown(data['card_number']!, _cardNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_cardNumberMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('levels_json')) {
      context.handle(
        _levelsJsonMeta,
        levelsJson.isAcceptableOrUnknown(data['levels_json']!, _levelsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_levelsJsonMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(
        _rarityMeta,
        rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta),
      );
    } else if (isInserting) {
      context.missing(_rarityMeta);
    }
    if (data.containsKey('set_code')) {
      context.handle(
        _setCodeMeta,
        setCode.isAcceptableOrUnknown(data['set_code']!, _setCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_setCodeMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('effect_text_rewrite')) {
      context.handle(
        _effectTextRewriteMeta,
        effectTextRewrite.isAcceptableOrUnknown(
          data['effect_text_rewrite']!,
          _effectTextRewriteMeta,
        ),
      );
    }
    if (data.containsKey('keywords_json')) {
      context.handle(
        _keywordsJsonMeta,
        keywordsJson.isAcceptableOrUnknown(
          data['keywords_json']!,
          _keywordsJsonMeta,
        ),
      );
    }
    if (data.containsKey('parallel_variants_json')) {
      context.handle(
        _parallelVariantsJsonMeta,
        parallelVariantsJson.isAcceptableOrUnknown(
          data['parallel_variants_json']!,
          _parallelVariantsJsonMeta,
        ),
      );
    }
    if (data.containsKey('release_date')) {
      context.handle(
        _releaseDateMeta,
        releaseDate.isAcceptableOrUnknown(
          data['release_date']!,
          _releaseDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Card map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Card(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_number'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost'],
      )!,
      levelsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}levels_json'],
      )!,
      rarity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rarity'],
      )!,
      setCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_code'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      effectTextRewrite: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effect_text_rewrite'],
      ),
      keywordsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keywords_json'],
      ),
      parallelVariantsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parallel_variants_json'],
      ),
      releaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}release_date'],
      ),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class Card extends DataClass implements Insertable<Card> {
  final String id;
  final String cardNumber;
  final String nameEn;
  final String type;
  final String color;
  final int cost;
  final String levelsJson;
  final String rarity;
  final String setCode;
  final String? imageUrl;
  final String? effectTextRewrite;
  final String? keywordsJson;
  final String? parallelVariantsJson;
  final DateTime? releaseDate;
  const Card({
    required this.id,
    required this.cardNumber,
    required this.nameEn,
    required this.type,
    required this.color,
    required this.cost,
    required this.levelsJson,
    required this.rarity,
    required this.setCode,
    this.imageUrl,
    this.effectTextRewrite,
    this.keywordsJson,
    this.parallelVariantsJson,
    this.releaseDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_number'] = Variable<String>(cardNumber);
    map['name_en'] = Variable<String>(nameEn);
    map['type'] = Variable<String>(type);
    map['color'] = Variable<String>(color);
    map['cost'] = Variable<int>(cost);
    map['levels_json'] = Variable<String>(levelsJson);
    map['rarity'] = Variable<String>(rarity);
    map['set_code'] = Variable<String>(setCode);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || effectTextRewrite != null) {
      map['effect_text_rewrite'] = Variable<String>(effectTextRewrite);
    }
    if (!nullToAbsent || keywordsJson != null) {
      map['keywords_json'] = Variable<String>(keywordsJson);
    }
    if (!nullToAbsent || parallelVariantsJson != null) {
      map['parallel_variants_json'] = Variable<String>(parallelVariantsJson);
    }
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<DateTime>(releaseDate);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      cardNumber: Value(cardNumber),
      nameEn: Value(nameEn),
      type: Value(type),
      color: Value(color),
      cost: Value(cost),
      levelsJson: Value(levelsJson),
      rarity: Value(rarity),
      setCode: Value(setCode),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      effectTextRewrite: effectTextRewrite == null && nullToAbsent
          ? const Value.absent()
          : Value(effectTextRewrite),
      keywordsJson: keywordsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(keywordsJson),
      parallelVariantsJson: parallelVariantsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(parallelVariantsJson),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
    );
  }

  factory Card.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Card(
      id: serializer.fromJson<String>(json['id']),
      cardNumber: serializer.fromJson<String>(json['cardNumber']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      type: serializer.fromJson<String>(json['type']),
      color: serializer.fromJson<String>(json['color']),
      cost: serializer.fromJson<int>(json['cost']),
      levelsJson: serializer.fromJson<String>(json['levelsJson']),
      rarity: serializer.fromJson<String>(json['rarity']),
      setCode: serializer.fromJson<String>(json['setCode']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      effectTextRewrite: serializer.fromJson<String?>(
        json['effectTextRewrite'],
      ),
      keywordsJson: serializer.fromJson<String?>(json['keywordsJson']),
      parallelVariantsJson: serializer.fromJson<String?>(
        json['parallelVariantsJson'],
      ),
      releaseDate: serializer.fromJson<DateTime?>(json['releaseDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardNumber': serializer.toJson<String>(cardNumber),
      'nameEn': serializer.toJson<String>(nameEn),
      'type': serializer.toJson<String>(type),
      'color': serializer.toJson<String>(color),
      'cost': serializer.toJson<int>(cost),
      'levelsJson': serializer.toJson<String>(levelsJson),
      'rarity': serializer.toJson<String>(rarity),
      'setCode': serializer.toJson<String>(setCode),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'effectTextRewrite': serializer.toJson<String?>(effectTextRewrite),
      'keywordsJson': serializer.toJson<String?>(keywordsJson),
      'parallelVariantsJson': serializer.toJson<String?>(parallelVariantsJson),
      'releaseDate': serializer.toJson<DateTime?>(releaseDate),
    };
  }

  Card copyWith({
    String? id,
    String? cardNumber,
    String? nameEn,
    String? type,
    String? color,
    int? cost,
    String? levelsJson,
    String? rarity,
    String? setCode,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> effectTextRewrite = const Value.absent(),
    Value<String?> keywordsJson = const Value.absent(),
    Value<String?> parallelVariantsJson = const Value.absent(),
    Value<DateTime?> releaseDate = const Value.absent(),
  }) => Card(
    id: id ?? this.id,
    cardNumber: cardNumber ?? this.cardNumber,
    nameEn: nameEn ?? this.nameEn,
    type: type ?? this.type,
    color: color ?? this.color,
    cost: cost ?? this.cost,
    levelsJson: levelsJson ?? this.levelsJson,
    rarity: rarity ?? this.rarity,
    setCode: setCode ?? this.setCode,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    effectTextRewrite: effectTextRewrite.present
        ? effectTextRewrite.value
        : this.effectTextRewrite,
    keywordsJson: keywordsJson.present ? keywordsJson.value : this.keywordsJson,
    parallelVariantsJson: parallelVariantsJson.present
        ? parallelVariantsJson.value
        : this.parallelVariantsJson,
    releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
  );
  Card copyWithCompanion(CardsCompanion data) {
    return Card(
      id: data.id.present ? data.id.value : this.id,
      cardNumber: data.cardNumber.present
          ? data.cardNumber.value
          : this.cardNumber,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      type: data.type.present ? data.type.value : this.type,
      color: data.color.present ? data.color.value : this.color,
      cost: data.cost.present ? data.cost.value : this.cost,
      levelsJson: data.levelsJson.present
          ? data.levelsJson.value
          : this.levelsJson,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      setCode: data.setCode.present ? data.setCode.value : this.setCode,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      effectTextRewrite: data.effectTextRewrite.present
          ? data.effectTextRewrite.value
          : this.effectTextRewrite,
      keywordsJson: data.keywordsJson.present
          ? data.keywordsJson.value
          : this.keywordsJson,
      parallelVariantsJson: data.parallelVariantsJson.present
          ? data.parallelVariantsJson.value
          : this.parallelVariantsJson,
      releaseDate: data.releaseDate.present
          ? data.releaseDate.value
          : this.releaseDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Card(')
          ..write('id: $id, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('nameEn: $nameEn, ')
          ..write('type: $type, ')
          ..write('color: $color, ')
          ..write('cost: $cost, ')
          ..write('levelsJson: $levelsJson, ')
          ..write('rarity: $rarity, ')
          ..write('setCode: $setCode, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('effectTextRewrite: $effectTextRewrite, ')
          ..write('keywordsJson: $keywordsJson, ')
          ..write('parallelVariantsJson: $parallelVariantsJson, ')
          ..write('releaseDate: $releaseDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardNumber,
    nameEn,
    type,
    color,
    cost,
    levelsJson,
    rarity,
    setCode,
    imageUrl,
    effectTextRewrite,
    keywordsJson,
    parallelVariantsJson,
    releaseDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Card &&
          other.id == this.id &&
          other.cardNumber == this.cardNumber &&
          other.nameEn == this.nameEn &&
          other.type == this.type &&
          other.color == this.color &&
          other.cost == this.cost &&
          other.levelsJson == this.levelsJson &&
          other.rarity == this.rarity &&
          other.setCode == this.setCode &&
          other.imageUrl == this.imageUrl &&
          other.effectTextRewrite == this.effectTextRewrite &&
          other.keywordsJson == this.keywordsJson &&
          other.parallelVariantsJson == this.parallelVariantsJson &&
          other.releaseDate == this.releaseDate);
}

class CardsCompanion extends UpdateCompanion<Card> {
  final Value<String> id;
  final Value<String> cardNumber;
  final Value<String> nameEn;
  final Value<String> type;
  final Value<String> color;
  final Value<int> cost;
  final Value<String> levelsJson;
  final Value<String> rarity;
  final Value<String> setCode;
  final Value<String?> imageUrl;
  final Value<String?> effectTextRewrite;
  final Value<String?> keywordsJson;
  final Value<String?> parallelVariantsJson;
  final Value<DateTime?> releaseDate;
  final Value<int> rowid;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.cardNumber = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.type = const Value.absent(),
    this.color = const Value.absent(),
    this.cost = const Value.absent(),
    this.levelsJson = const Value.absent(),
    this.rarity = const Value.absent(),
    this.setCode = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.effectTextRewrite = const Value.absent(),
    this.keywordsJson = const Value.absent(),
    this.parallelVariantsJson = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardsCompanion.insert({
    required String id,
    required String cardNumber,
    required String nameEn,
    required String type,
    required String color,
    required int cost,
    required String levelsJson,
    required String rarity,
    required String setCode,
    this.imageUrl = const Value.absent(),
    this.effectTextRewrite = const Value.absent(),
    this.keywordsJson = const Value.absent(),
    this.parallelVariantsJson = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardNumber = Value(cardNumber),
       nameEn = Value(nameEn),
       type = Value(type),
       color = Value(color),
       cost = Value(cost),
       levelsJson = Value(levelsJson),
       rarity = Value(rarity),
       setCode = Value(setCode);
  static Insertable<Card> custom({
    Expression<String>? id,
    Expression<String>? cardNumber,
    Expression<String>? nameEn,
    Expression<String>? type,
    Expression<String>? color,
    Expression<int>? cost,
    Expression<String>? levelsJson,
    Expression<String>? rarity,
    Expression<String>? setCode,
    Expression<String>? imageUrl,
    Expression<String>? effectTextRewrite,
    Expression<String>? keywordsJson,
    Expression<String>? parallelVariantsJson,
    Expression<DateTime>? releaseDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardNumber != null) 'card_number': cardNumber,
      if (nameEn != null) 'name_en': nameEn,
      if (type != null) 'type': type,
      if (color != null) 'color': color,
      if (cost != null) 'cost': cost,
      if (levelsJson != null) 'levels_json': levelsJson,
      if (rarity != null) 'rarity': rarity,
      if (setCode != null) 'set_code': setCode,
      if (imageUrl != null) 'image_url': imageUrl,
      if (effectTextRewrite != null) 'effect_text_rewrite': effectTextRewrite,
      if (keywordsJson != null) 'keywords_json': keywordsJson,
      if (parallelVariantsJson != null)
        'parallel_variants_json': parallelVariantsJson,
      if (releaseDate != null) 'release_date': releaseDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardsCompanion copyWith({
    Value<String>? id,
    Value<String>? cardNumber,
    Value<String>? nameEn,
    Value<String>? type,
    Value<String>? color,
    Value<int>? cost,
    Value<String>? levelsJson,
    Value<String>? rarity,
    Value<String>? setCode,
    Value<String?>? imageUrl,
    Value<String?>? effectTextRewrite,
    Value<String?>? keywordsJson,
    Value<String?>? parallelVariantsJson,
    Value<DateTime?>? releaseDate,
    Value<int>? rowid,
  }) {
    return CardsCompanion(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      nameEn: nameEn ?? this.nameEn,
      type: type ?? this.type,
      color: color ?? this.color,
      cost: cost ?? this.cost,
      levelsJson: levelsJson ?? this.levelsJson,
      rarity: rarity ?? this.rarity,
      setCode: setCode ?? this.setCode,
      imageUrl: imageUrl ?? this.imageUrl,
      effectTextRewrite: effectTextRewrite ?? this.effectTextRewrite,
      keywordsJson: keywordsJson ?? this.keywordsJson,
      parallelVariantsJson: parallelVariantsJson ?? this.parallelVariantsJson,
      releaseDate: releaseDate ?? this.releaseDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardNumber.present) {
      map['card_number'] = Variable<String>(cardNumber.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (levelsJson.present) {
      map['levels_json'] = Variable<String>(levelsJson.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (setCode.present) {
      map['set_code'] = Variable<String>(setCode.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (effectTextRewrite.present) {
      map['effect_text_rewrite'] = Variable<String>(effectTextRewrite.value);
    }
    if (keywordsJson.present) {
      map['keywords_json'] = Variable<String>(keywordsJson.value);
    }
    if (parallelVariantsJson.present) {
      map['parallel_variants_json'] = Variable<String>(
        parallelVariantsJson.value,
      );
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('nameEn: $nameEn, ')
          ..write('type: $type, ')
          ..write('color: $color, ')
          ..write('cost: $cost, ')
          ..write('levelsJson: $levelsJson, ')
          ..write('rarity: $rarity, ')
          ..write('setCode: $setCode, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('effectTextRewrite: $effectTextRewrite, ')
          ..write('keywordsJson: $keywordsJson, ')
          ..write('parallelVariantsJson: $parallelVariantsJson, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardsTable cards = $CardsTable(this);
  late final CardsDao cardsDao = CardsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cards];
}

typedef $$CardsTableCreateCompanionBuilder =
    CardsCompanion Function({
      required String id,
      required String cardNumber,
      required String nameEn,
      required String type,
      required String color,
      required int cost,
      required String levelsJson,
      required String rarity,
      required String setCode,
      Value<String?> imageUrl,
      Value<String?> effectTextRewrite,
      Value<String?> keywordsJson,
      Value<String?> parallelVariantsJson,
      Value<DateTime?> releaseDate,
      Value<int> rowid,
    });
typedef $$CardsTableUpdateCompanionBuilder =
    CardsCompanion Function({
      Value<String> id,
      Value<String> cardNumber,
      Value<String> nameEn,
      Value<String> type,
      Value<String> color,
      Value<int> cost,
      Value<String> levelsJson,
      Value<String> rarity,
      Value<String> setCode,
      Value<String?> imageUrl,
      Value<String?> effectTextRewrite,
      Value<String?> keywordsJson,
      Value<String?> parallelVariantsJson,
      Value<DateTime?> releaseDate,
      Value<int> rowid,
    });

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get levelsJson => $composableBuilder(
    column: $table.levelsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectTextRewrite => $composableBuilder(
    column: $table.effectTextRewrite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keywordsJson => $composableBuilder(
    column: $table.keywordsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parallelVariantsJson => $composableBuilder(
    column: $table.parallelVariantsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get levelsJson => $composableBuilder(
    column: $table.levelsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectTextRewrite => $composableBuilder(
    column: $table.effectTextRewrite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keywordsJson => $composableBuilder(
    column: $table.keywordsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parallelVariantsJson => $composableBuilder(
    column: $table.parallelVariantsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get levelsJson => $composableBuilder(
    column: $table.levelsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<String> get setCode =>
      $composableBuilder(column: $table.setCode, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get effectTextRewrite => $composableBuilder(
    column: $table.effectTextRewrite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get keywordsJson => $composableBuilder(
    column: $table.keywordsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parallelVariantsJson => $composableBuilder(
    column: $table.parallelVariantsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => column,
  );
}

class $$CardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTable,
          Card,
          $$CardsTableFilterComposer,
          $$CardsTableOrderingComposer,
          $$CardsTableAnnotationComposer,
          $$CardsTableCreateCompanionBuilder,
          $$CardsTableUpdateCompanionBuilder,
          (Card, BaseReferences<_$AppDatabase, $CardsTable, Card>),
          Card,
          PrefetchHooks Function()
        > {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cardNumber = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<int> cost = const Value.absent(),
                Value<String> levelsJson = const Value.absent(),
                Value<String> rarity = const Value.absent(),
                Value<String> setCode = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> effectTextRewrite = const Value.absent(),
                Value<String?> keywordsJson = const Value.absent(),
                Value<String?> parallelVariantsJson = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion(
                id: id,
                cardNumber: cardNumber,
                nameEn: nameEn,
                type: type,
                color: color,
                cost: cost,
                levelsJson: levelsJson,
                rarity: rarity,
                setCode: setCode,
                imageUrl: imageUrl,
                effectTextRewrite: effectTextRewrite,
                keywordsJson: keywordsJson,
                parallelVariantsJson: parallelVariantsJson,
                releaseDate: releaseDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cardNumber,
                required String nameEn,
                required String type,
                required String color,
                required int cost,
                required String levelsJson,
                required String rarity,
                required String setCode,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> effectTextRewrite = const Value.absent(),
                Value<String?> keywordsJson = const Value.absent(),
                Value<String?> parallelVariantsJson = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion.insert(
                id: id,
                cardNumber: cardNumber,
                nameEn: nameEn,
                type: type,
                color: color,
                cost: cost,
                levelsJson: levelsJson,
                rarity: rarity,
                setCode: setCode,
                imageUrl: imageUrl,
                effectTextRewrite: effectTextRewrite,
                keywordsJson: keywordsJson,
                parallelVariantsJson: parallelVariantsJson,
                releaseDate: releaseDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTable,
      Card,
      $$CardsTableFilterComposer,
      $$CardsTableOrderingComposer,
      $$CardsTableAnnotationComposer,
      $$CardsTableCreateCompanionBuilder,
      $$CardsTableUpdateCompanionBuilder,
      (Card, BaseReferences<_$AppDatabase, $CardsTable, Card>),
      Card,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
}
