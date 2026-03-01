// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) {
  return _PlayerModel.fromJson(json);
}

/// @nodoc
mixin _$PlayerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  PlayerIds? get ids => throw _privateConstructorUsedError;
  String get team => throw _privateConstructorUsedError;
  String get league => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  String get nationality => throw _privateConstructorUsedError;
  String get dateOfBirth => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  int get weight => throw _privateConstructorUsedError;
  String get preferredFoot => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;
  String get contractUntil => throw _privateConstructorUsedError;
  double? get weeklyWage => throw _privateConstructorUsedError;
  int get marketValue => throw _privateConstructorUsedError;
  List<MarketValueEntry> get marketValueHistory =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get seasonStats => throw _privateConstructorUsedError;
  List<CareerEntry> get careerHistory => throw _privateConstructorUsedError;
  ScoutingData? get scouting => throw _privateConstructorUsedError;
  List<PlayerInjury> get injuries => throw _privateConstructorUsedError;
  NationalTeamInfo? get nationalTeam => throw _privateConstructorUsedError;
  String get dataHash => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this PlayerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerModelCopyWith<PlayerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerModelCopyWith<$Res> {
  factory $PlayerModelCopyWith(
    PlayerModel value,
    $Res Function(PlayerModel) then,
  ) = _$PlayerModelCopyWithImpl<$Res, PlayerModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String slug,
    PlayerIds? ids,
    String team,
    String league,
    String position,
    String nationality,
    String dateOfBirth,
    int height,
    int weight,
    String preferredFoot,
    int number,
    String contractUntil,
    double? weeklyWage,
    int marketValue,
    List<MarketValueEntry> marketValueHistory,
    Map<String, dynamic> seasonStats,
    List<CareerEntry> careerHistory,
    ScoutingData? scouting,
    List<PlayerInjury> injuries,
    NationalTeamInfo? nationalTeam,
    String dataHash,
    DateTime? lastUpdated,
  });

  $PlayerIdsCopyWith<$Res>? get ids;
  $ScoutingDataCopyWith<$Res>? get scouting;
  $NationalTeamInfoCopyWith<$Res>? get nationalTeam;
}

/// @nodoc
class _$PlayerModelCopyWithImpl<$Res, $Val extends PlayerModel>
    implements $PlayerModelCopyWith<$Res> {
  _$PlayerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? ids = freezed,
    Object? team = null,
    Object? league = null,
    Object? position = null,
    Object? nationality = null,
    Object? dateOfBirth = null,
    Object? height = null,
    Object? weight = null,
    Object? preferredFoot = null,
    Object? number = null,
    Object? contractUntil = null,
    Object? weeklyWage = freezed,
    Object? marketValue = null,
    Object? marketValueHistory = null,
    Object? seasonStats = null,
    Object? careerHistory = null,
    Object? scouting = freezed,
    Object? injuries = null,
    Object? nationalTeam = freezed,
    Object? dataHash = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            ids: freezed == ids
                ? _value.ids
                : ids // ignore: cast_nullable_to_non_nullable
                      as PlayerIds?,
            team: null == team
                ? _value.team
                : team // ignore: cast_nullable_to_non_nullable
                      as String,
            league: null == league
                ? _value.league
                : league // ignore: cast_nullable_to_non_nullable
                      as String,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as String,
            nationality: null == nationality
                ? _value.nationality
                : nationality // ignore: cast_nullable_to_non_nullable
                      as String,
            dateOfBirth: null == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                      as String,
            height: null == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as int,
            preferredFoot: null == preferredFoot
                ? _value.preferredFoot
                : preferredFoot // ignore: cast_nullable_to_non_nullable
                      as String,
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as int,
            contractUntil: null == contractUntil
                ? _value.contractUntil
                : contractUntil // ignore: cast_nullable_to_non_nullable
                      as String,
            weeklyWage: freezed == weeklyWage
                ? _value.weeklyWage
                : weeklyWage // ignore: cast_nullable_to_non_nullable
                      as double?,
            marketValue: null == marketValue
                ? _value.marketValue
                : marketValue // ignore: cast_nullable_to_non_nullable
                      as int,
            marketValueHistory: null == marketValueHistory
                ? _value.marketValueHistory
                : marketValueHistory // ignore: cast_nullable_to_non_nullable
                      as List<MarketValueEntry>,
            seasonStats: null == seasonStats
                ? _value.seasonStats
                : seasonStats // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            careerHistory: null == careerHistory
                ? _value.careerHistory
                : careerHistory // ignore: cast_nullable_to_non_nullable
                      as List<CareerEntry>,
            scouting: freezed == scouting
                ? _value.scouting
                : scouting // ignore: cast_nullable_to_non_nullable
                      as ScoutingData?,
            injuries: null == injuries
                ? _value.injuries
                : injuries // ignore: cast_nullable_to_non_nullable
                      as List<PlayerInjury>,
            nationalTeam: freezed == nationalTeam
                ? _value.nationalTeam
                : nationalTeam // ignore: cast_nullable_to_non_nullable
                      as NationalTeamInfo?,
            dataHash: null == dataHash
                ? _value.dataHash
                : dataHash // ignore: cast_nullable_to_non_nullable
                      as String,
            lastUpdated: freezed == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerIdsCopyWith<$Res>? get ids {
    if (_value.ids == null) {
      return null;
    }

    return $PlayerIdsCopyWith<$Res>(_value.ids!, (value) {
      return _then(_value.copyWith(ids: value) as $Val);
    });
  }

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScoutingDataCopyWith<$Res>? get scouting {
    if (_value.scouting == null) {
      return null;
    }

    return $ScoutingDataCopyWith<$Res>(_value.scouting!, (value) {
      return _then(_value.copyWith(scouting: value) as $Val);
    });
  }

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NationalTeamInfoCopyWith<$Res>? get nationalTeam {
    if (_value.nationalTeam == null) {
      return null;
    }

    return $NationalTeamInfoCopyWith<$Res>(_value.nationalTeam!, (value) {
      return _then(_value.copyWith(nationalTeam: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerModelImplCopyWith<$Res>
    implements $PlayerModelCopyWith<$Res> {
  factory _$$PlayerModelImplCopyWith(
    _$PlayerModelImpl value,
    $Res Function(_$PlayerModelImpl) then,
  ) = __$$PlayerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String slug,
    PlayerIds? ids,
    String team,
    String league,
    String position,
    String nationality,
    String dateOfBirth,
    int height,
    int weight,
    String preferredFoot,
    int number,
    String contractUntil,
    double? weeklyWage,
    int marketValue,
    List<MarketValueEntry> marketValueHistory,
    Map<String, dynamic> seasonStats,
    List<CareerEntry> careerHistory,
    ScoutingData? scouting,
    List<PlayerInjury> injuries,
    NationalTeamInfo? nationalTeam,
    String dataHash,
    DateTime? lastUpdated,
  });

  @override
  $PlayerIdsCopyWith<$Res>? get ids;
  @override
  $ScoutingDataCopyWith<$Res>? get scouting;
  @override
  $NationalTeamInfoCopyWith<$Res>? get nationalTeam;
}

/// @nodoc
class __$$PlayerModelImplCopyWithImpl<$Res>
    extends _$PlayerModelCopyWithImpl<$Res, _$PlayerModelImpl>
    implements _$$PlayerModelImplCopyWith<$Res> {
  __$$PlayerModelImplCopyWithImpl(
    _$PlayerModelImpl _value,
    $Res Function(_$PlayerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? ids = freezed,
    Object? team = null,
    Object? league = null,
    Object? position = null,
    Object? nationality = null,
    Object? dateOfBirth = null,
    Object? height = null,
    Object? weight = null,
    Object? preferredFoot = null,
    Object? number = null,
    Object? contractUntil = null,
    Object? weeklyWage = freezed,
    Object? marketValue = null,
    Object? marketValueHistory = null,
    Object? seasonStats = null,
    Object? careerHistory = null,
    Object? scouting = freezed,
    Object? injuries = null,
    Object? nationalTeam = freezed,
    Object? dataHash = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _$PlayerModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        ids: freezed == ids
            ? _value.ids
            : ids // ignore: cast_nullable_to_non_nullable
                  as PlayerIds?,
        team: null == team
            ? _value.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String,
        league: null == league
            ? _value.league
            : league // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as String,
        nationality: null == nationality
            ? _value.nationality
            : nationality // ignore: cast_nullable_to_non_nullable
                  as String,
        dateOfBirth: null == dateOfBirth
            ? _value.dateOfBirth
            : dateOfBirth // ignore: cast_nullable_to_non_nullable
                  as String,
        height: null == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as int,
        preferredFoot: null == preferredFoot
            ? _value.preferredFoot
            : preferredFoot // ignore: cast_nullable_to_non_nullable
                  as String,
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as int,
        contractUntil: null == contractUntil
            ? _value.contractUntil
            : contractUntil // ignore: cast_nullable_to_non_nullable
                  as String,
        weeklyWage: freezed == weeklyWage
            ? _value.weeklyWage
            : weeklyWage // ignore: cast_nullable_to_non_nullable
                  as double?,
        marketValue: null == marketValue
            ? _value.marketValue
            : marketValue // ignore: cast_nullable_to_non_nullable
                  as int,
        marketValueHistory: null == marketValueHistory
            ? _value._marketValueHistory
            : marketValueHistory // ignore: cast_nullable_to_non_nullable
                  as List<MarketValueEntry>,
        seasonStats: null == seasonStats
            ? _value._seasonStats
            : seasonStats // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        careerHistory: null == careerHistory
            ? _value._careerHistory
            : careerHistory // ignore: cast_nullable_to_non_nullable
                  as List<CareerEntry>,
        scouting: freezed == scouting
            ? _value.scouting
            : scouting // ignore: cast_nullable_to_non_nullable
                  as ScoutingData?,
        injuries: null == injuries
            ? _value._injuries
            : injuries // ignore: cast_nullable_to_non_nullable
                  as List<PlayerInjury>,
        nationalTeam: freezed == nationalTeam
            ? _value.nationalTeam
            : nationalTeam // ignore: cast_nullable_to_non_nullable
                  as NationalTeamInfo?,
        dataHash: null == dataHash
            ? _value.dataHash
            : dataHash // ignore: cast_nullable_to_non_nullable
                  as String,
        lastUpdated: freezed == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerModelImpl implements _PlayerModel {
  const _$PlayerModelImpl({
    required this.id,
    required this.name,
    this.slug = '',
    this.ids,
    this.team = '',
    this.league = '',
    this.position = '',
    this.nationality = '',
    this.dateOfBirth = '',
    this.height = 0,
    this.weight = 0,
    this.preferredFoot = '',
    this.number = 0,
    this.contractUntil = '',
    this.weeklyWage,
    this.marketValue = 0,
    final List<MarketValueEntry> marketValueHistory = const [],
    final Map<String, dynamic> seasonStats = const {},
    final List<CareerEntry> careerHistory = const [],
    this.scouting,
    final List<PlayerInjury> injuries = const [],
    this.nationalTeam,
    this.dataHash = '',
    this.lastUpdated,
  }) : _marketValueHistory = marketValueHistory,
       _seasonStats = seasonStats,
       _careerHistory = careerHistory,
       _injuries = injuries;

  factory _$PlayerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String slug;
  @override
  final PlayerIds? ids;
  @override
  @JsonKey()
  final String team;
  @override
  @JsonKey()
  final String league;
  @override
  @JsonKey()
  final String position;
  @override
  @JsonKey()
  final String nationality;
  @override
  @JsonKey()
  final String dateOfBirth;
  @override
  @JsonKey()
  final int height;
  @override
  @JsonKey()
  final int weight;
  @override
  @JsonKey()
  final String preferredFoot;
  @override
  @JsonKey()
  final int number;
  @override
  @JsonKey()
  final String contractUntil;
  @override
  final double? weeklyWage;
  @override
  @JsonKey()
  final int marketValue;
  final List<MarketValueEntry> _marketValueHistory;
  @override
  @JsonKey()
  List<MarketValueEntry> get marketValueHistory {
    if (_marketValueHistory is EqualUnmodifiableListView)
      return _marketValueHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_marketValueHistory);
  }

  final Map<String, dynamic> _seasonStats;
  @override
  @JsonKey()
  Map<String, dynamic> get seasonStats {
    if (_seasonStats is EqualUnmodifiableMapView) return _seasonStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_seasonStats);
  }

  final List<CareerEntry> _careerHistory;
  @override
  @JsonKey()
  List<CareerEntry> get careerHistory {
    if (_careerHistory is EqualUnmodifiableListView) return _careerHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_careerHistory);
  }

  @override
  final ScoutingData? scouting;
  final List<PlayerInjury> _injuries;
  @override
  @JsonKey()
  List<PlayerInjury> get injuries {
    if (_injuries is EqualUnmodifiableListView) return _injuries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_injuries);
  }

  @override
  final NationalTeamInfo? nationalTeam;
  @override
  @JsonKey()
  final String dataHash;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'PlayerModel(id: $id, name: $name, slug: $slug, ids: $ids, team: $team, league: $league, position: $position, nationality: $nationality, dateOfBirth: $dateOfBirth, height: $height, weight: $weight, preferredFoot: $preferredFoot, number: $number, contractUntil: $contractUntil, weeklyWage: $weeklyWage, marketValue: $marketValue, marketValueHistory: $marketValueHistory, seasonStats: $seasonStats, careerHistory: $careerHistory, scouting: $scouting, injuries: $injuries, nationalTeam: $nationalTeam, dataHash: $dataHash, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.ids, ids) || other.ids == ids) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.preferredFoot, preferredFoot) ||
                other.preferredFoot == preferredFoot) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.contractUntil, contractUntil) ||
                other.contractUntil == contractUntil) &&
            (identical(other.weeklyWage, weeklyWage) ||
                other.weeklyWage == weeklyWage) &&
            (identical(other.marketValue, marketValue) ||
                other.marketValue == marketValue) &&
            const DeepCollectionEquality().equals(
              other._marketValueHistory,
              _marketValueHistory,
            ) &&
            const DeepCollectionEquality().equals(
              other._seasonStats,
              _seasonStats,
            ) &&
            const DeepCollectionEquality().equals(
              other._careerHistory,
              _careerHistory,
            ) &&
            (identical(other.scouting, scouting) ||
                other.scouting == scouting) &&
            const DeepCollectionEquality().equals(other._injuries, _injuries) &&
            (identical(other.nationalTeam, nationalTeam) ||
                other.nationalTeam == nationalTeam) &&
            (identical(other.dataHash, dataHash) ||
                other.dataHash == dataHash) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    slug,
    ids,
    team,
    league,
    position,
    nationality,
    dateOfBirth,
    height,
    weight,
    preferredFoot,
    number,
    contractUntil,
    weeklyWage,
    marketValue,
    const DeepCollectionEquality().hash(_marketValueHistory),
    const DeepCollectionEquality().hash(_seasonStats),
    const DeepCollectionEquality().hash(_careerHistory),
    scouting,
    const DeepCollectionEquality().hash(_injuries),
    nationalTeam,
    dataHash,
    lastUpdated,
  ]);

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      __$$PlayerModelImplCopyWithImpl<_$PlayerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerModelImplToJson(this);
  }
}

abstract class _PlayerModel implements PlayerModel {
  const factory _PlayerModel({
    required final String id,
    required final String name,
    final String slug,
    final PlayerIds? ids,
    final String team,
    final String league,
    final String position,
    final String nationality,
    final String dateOfBirth,
    final int height,
    final int weight,
    final String preferredFoot,
    final int number,
    final String contractUntil,
    final double? weeklyWage,
    final int marketValue,
    final List<MarketValueEntry> marketValueHistory,
    final Map<String, dynamic> seasonStats,
    final List<CareerEntry> careerHistory,
    final ScoutingData? scouting,
    final List<PlayerInjury> injuries,
    final NationalTeamInfo? nationalTeam,
    final String dataHash,
    final DateTime? lastUpdated,
  }) = _$PlayerModelImpl;

  factory _PlayerModel.fromJson(Map<String, dynamic> json) =
      _$PlayerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  PlayerIds? get ids;
  @override
  String get team;
  @override
  String get league;
  @override
  String get position;
  @override
  String get nationality;
  @override
  String get dateOfBirth;
  @override
  int get height;
  @override
  int get weight;
  @override
  String get preferredFoot;
  @override
  int get number;
  @override
  String get contractUntil;
  @override
  double? get weeklyWage;
  @override
  int get marketValue;
  @override
  List<MarketValueEntry> get marketValueHistory;
  @override
  Map<String, dynamic> get seasonStats;
  @override
  List<CareerEntry> get careerHistory;
  @override
  ScoutingData? get scouting;
  @override
  List<PlayerInjury> get injuries;
  @override
  NationalTeamInfo? get nationalTeam;
  @override
  String get dataHash;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlayerIds _$PlayerIdsFromJson(Map<String, dynamic> json) {
  return _PlayerIds.fromJson(json);
}

/// @nodoc
mixin _$PlayerIds {
  int get sofascore => throw _privateConstructorUsedError;
  String get transfermarkt => throw _privateConstructorUsedError;
  String get fbref => throw _privateConstructorUsedError;

  /// Serializes this PlayerIds to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerIds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerIdsCopyWith<PlayerIds> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerIdsCopyWith<$Res> {
  factory $PlayerIdsCopyWith(PlayerIds value, $Res Function(PlayerIds) then) =
      _$PlayerIdsCopyWithImpl<$Res, PlayerIds>;
  @useResult
  $Res call({int sofascore, String transfermarkt, String fbref});
}

/// @nodoc
class _$PlayerIdsCopyWithImpl<$Res, $Val extends PlayerIds>
    implements $PlayerIdsCopyWith<$Res> {
  _$PlayerIdsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerIds
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sofascore = null,
    Object? transfermarkt = null,
    Object? fbref = null,
  }) {
    return _then(
      _value.copyWith(
            sofascore: null == sofascore
                ? _value.sofascore
                : sofascore // ignore: cast_nullable_to_non_nullable
                      as int,
            transfermarkt: null == transfermarkt
                ? _value.transfermarkt
                : transfermarkt // ignore: cast_nullable_to_non_nullable
                      as String,
            fbref: null == fbref
                ? _value.fbref
                : fbref // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerIdsImplCopyWith<$Res>
    implements $PlayerIdsCopyWith<$Res> {
  factory _$$PlayerIdsImplCopyWith(
    _$PlayerIdsImpl value,
    $Res Function(_$PlayerIdsImpl) then,
  ) = __$$PlayerIdsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int sofascore, String transfermarkt, String fbref});
}

/// @nodoc
class __$$PlayerIdsImplCopyWithImpl<$Res>
    extends _$PlayerIdsCopyWithImpl<$Res, _$PlayerIdsImpl>
    implements _$$PlayerIdsImplCopyWith<$Res> {
  __$$PlayerIdsImplCopyWithImpl(
    _$PlayerIdsImpl _value,
    $Res Function(_$PlayerIdsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerIds
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sofascore = null,
    Object? transfermarkt = null,
    Object? fbref = null,
  }) {
    return _then(
      _$PlayerIdsImpl(
        sofascore: null == sofascore
            ? _value.sofascore
            : sofascore // ignore: cast_nullable_to_non_nullable
                  as int,
        transfermarkt: null == transfermarkt
            ? _value.transfermarkt
            : transfermarkt // ignore: cast_nullable_to_non_nullable
                  as String,
        fbref: null == fbref
            ? _value.fbref
            : fbref // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerIdsImpl implements _PlayerIds {
  const _$PlayerIdsImpl({
    this.sofascore = 0,
    this.transfermarkt = '',
    this.fbref = '',
  });

  factory _$PlayerIdsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerIdsImplFromJson(json);

  @override
  @JsonKey()
  final int sofascore;
  @override
  @JsonKey()
  final String transfermarkt;
  @override
  @JsonKey()
  final String fbref;

  @override
  String toString() {
    return 'PlayerIds(sofascore: $sofascore, transfermarkt: $transfermarkt, fbref: $fbref)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerIdsImpl &&
            (identical(other.sofascore, sofascore) ||
                other.sofascore == sofascore) &&
            (identical(other.transfermarkt, transfermarkt) ||
                other.transfermarkt == transfermarkt) &&
            (identical(other.fbref, fbref) || other.fbref == fbref));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sofascore, transfermarkt, fbref);

  /// Create a copy of PlayerIds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerIdsImplCopyWith<_$PlayerIdsImpl> get copyWith =>
      __$$PlayerIdsImplCopyWithImpl<_$PlayerIdsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerIdsImplToJson(this);
  }
}

abstract class _PlayerIds implements PlayerIds {
  const factory _PlayerIds({
    final int sofascore,
    final String transfermarkt,
    final String fbref,
  }) = _$PlayerIdsImpl;

  factory _PlayerIds.fromJson(Map<String, dynamic> json) =
      _$PlayerIdsImpl.fromJson;

  @override
  int get sofascore;
  @override
  String get transfermarkt;
  @override
  String get fbref;

  /// Create a copy of PlayerIds
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerIdsImplCopyWith<_$PlayerIdsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketValueEntry _$MarketValueEntryFromJson(Map<String, dynamic> json) {
  return _MarketValueEntry.fromJson(json);
}

/// @nodoc
mixin _$MarketValueEntry {
  String get date => throw _privateConstructorUsedError;
  int get value => throw _privateConstructorUsedError;

  /// Serializes this MarketValueEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketValueEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketValueEntryCopyWith<MarketValueEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketValueEntryCopyWith<$Res> {
  factory $MarketValueEntryCopyWith(
    MarketValueEntry value,
    $Res Function(MarketValueEntry) then,
  ) = _$MarketValueEntryCopyWithImpl<$Res, MarketValueEntry>;
  @useResult
  $Res call({String date, int value});
}

/// @nodoc
class _$MarketValueEntryCopyWithImpl<$Res, $Val extends MarketValueEntry>
    implements $MarketValueEntryCopyWith<$Res> {
  _$MarketValueEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketValueEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarketValueEntryImplCopyWith<$Res>
    implements $MarketValueEntryCopyWith<$Res> {
  factory _$$MarketValueEntryImplCopyWith(
    _$MarketValueEntryImpl value,
    $Res Function(_$MarketValueEntryImpl) then,
  ) = __$$MarketValueEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, int value});
}

/// @nodoc
class __$$MarketValueEntryImplCopyWithImpl<$Res>
    extends _$MarketValueEntryCopyWithImpl<$Res, _$MarketValueEntryImpl>
    implements _$$MarketValueEntryImplCopyWith<$Res> {
  __$$MarketValueEntryImplCopyWithImpl(
    _$MarketValueEntryImpl _value,
    $Res Function(_$MarketValueEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketValueEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? value = null}) {
    return _then(
      _$MarketValueEntryImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketValueEntryImpl implements _MarketValueEntry {
  const _$MarketValueEntryImpl({this.date = '', this.value = 0});

  factory _$MarketValueEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketValueEntryImplFromJson(json);

  @override
  @JsonKey()
  final String date;
  @override
  @JsonKey()
  final int value;

  @override
  String toString() {
    return 'MarketValueEntry(date: $date, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketValueEntryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, value);

  /// Create a copy of MarketValueEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketValueEntryImplCopyWith<_$MarketValueEntryImpl> get copyWith =>
      __$$MarketValueEntryImplCopyWithImpl<_$MarketValueEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketValueEntryImplToJson(this);
  }
}

abstract class _MarketValueEntry implements MarketValueEntry {
  const factory _MarketValueEntry({final String date, final int value}) =
      _$MarketValueEntryImpl;

  factory _MarketValueEntry.fromJson(Map<String, dynamic> json) =
      _$MarketValueEntryImpl.fromJson;

  @override
  String get date;
  @override
  int get value;

  /// Create a copy of MarketValueEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketValueEntryImplCopyWith<_$MarketValueEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CareerEntry _$CareerEntryFromJson(Map<String, dynamic> json) {
  return _CareerEntry.fromJson(json);
}

/// @nodoc
mixin _$CareerEntry {
  String get team => throw _privateConstructorUsedError;
  String get from => throw _privateConstructorUsedError;
  String? get to => throw _privateConstructorUsedError;
  int get matches => throw _privateConstructorUsedError;
  int get goals => throw _privateConstructorUsedError;

  /// Serializes this CareerEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CareerEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CareerEntryCopyWith<CareerEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CareerEntryCopyWith<$Res> {
  factory $CareerEntryCopyWith(
    CareerEntry value,
    $Res Function(CareerEntry) then,
  ) = _$CareerEntryCopyWithImpl<$Res, CareerEntry>;
  @useResult
  $Res call({String team, String from, String? to, int matches, int goals});
}

/// @nodoc
class _$CareerEntryCopyWithImpl<$Res, $Val extends CareerEntry>
    implements $CareerEntryCopyWith<$Res> {
  _$CareerEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CareerEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? team = null,
    Object? from = null,
    Object? to = freezed,
    Object? matches = null,
    Object? goals = null,
  }) {
    return _then(
      _value.copyWith(
            team: null == team
                ? _value.team
                : team // ignore: cast_nullable_to_non_nullable
                      as String,
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as String,
            to: freezed == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as String?,
            matches: null == matches
                ? _value.matches
                : matches // ignore: cast_nullable_to_non_nullable
                      as int,
            goals: null == goals
                ? _value.goals
                : goals // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CareerEntryImplCopyWith<$Res>
    implements $CareerEntryCopyWith<$Res> {
  factory _$$CareerEntryImplCopyWith(
    _$CareerEntryImpl value,
    $Res Function(_$CareerEntryImpl) then,
  ) = __$$CareerEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String team, String from, String? to, int matches, int goals});
}

/// @nodoc
class __$$CareerEntryImplCopyWithImpl<$Res>
    extends _$CareerEntryCopyWithImpl<$Res, _$CareerEntryImpl>
    implements _$$CareerEntryImplCopyWith<$Res> {
  __$$CareerEntryImplCopyWithImpl(
    _$CareerEntryImpl _value,
    $Res Function(_$CareerEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CareerEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? team = null,
    Object? from = null,
    Object? to = freezed,
    Object? matches = null,
    Object? goals = null,
  }) {
    return _then(
      _$CareerEntryImpl(
        team: null == team
            ? _value.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String,
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: freezed == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String?,
        matches: null == matches
            ? _value.matches
            : matches // ignore: cast_nullable_to_non_nullable
                  as int,
        goals: null == goals
            ? _value.goals
            : goals // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CareerEntryImpl implements _CareerEntry {
  const _$CareerEntryImpl({
    this.team = '',
    this.from = '',
    this.to,
    this.matches = 0,
    this.goals = 0,
  });

  factory _$CareerEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CareerEntryImplFromJson(json);

  @override
  @JsonKey()
  final String team;
  @override
  @JsonKey()
  final String from;
  @override
  final String? to;
  @override
  @JsonKey()
  final int matches;
  @override
  @JsonKey()
  final int goals;

  @override
  String toString() {
    return 'CareerEntry(team: $team, from: $from, to: $to, matches: $matches, goals: $goals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CareerEntryImpl &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.matches, matches) || other.matches == matches) &&
            (identical(other.goals, goals) || other.goals == goals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, team, from, to, matches, goals);

  /// Create a copy of CareerEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CareerEntryImplCopyWith<_$CareerEntryImpl> get copyWith =>
      __$$CareerEntryImplCopyWithImpl<_$CareerEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CareerEntryImplToJson(this);
  }
}

abstract class _CareerEntry implements CareerEntry {
  const factory _CareerEntry({
    final String team,
    final String from,
    final String? to,
    final int matches,
    final int goals,
  }) = _$CareerEntryImpl;

  factory _CareerEntry.fromJson(Map<String, dynamic> json) =
      _$CareerEntryImpl.fromJson;

  @override
  String get team;
  @override
  String get from;
  @override
  String? get to;
  @override
  int get matches;
  @override
  int get goals;

  /// Create a copy of CareerEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CareerEntryImplCopyWith<_$CareerEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScoutingData _$ScoutingDataFromJson(Map<String, dynamic> json) {
  return _ScoutingData.fromJson(json);
}

/// @nodoc
mixin _$ScoutingData {
  Map<String, int> get percentiles => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;

  /// Serializes this ScoutingData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScoutingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoutingDataCopyWith<ScoutingData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoutingDataCopyWith<$Res> {
  factory $ScoutingDataCopyWith(
    ScoutingData value,
    $Res Function(ScoutingData) then,
  ) = _$ScoutingDataCopyWithImpl<$Res, ScoutingData>;
  @useResult
  $Res call({Map<String, int> percentiles, String source});
}

/// @nodoc
class _$ScoutingDataCopyWithImpl<$Res, $Val extends ScoutingData>
    implements $ScoutingDataCopyWith<$Res> {
  _$ScoutingDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScoutingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? percentiles = null, Object? source = null}) {
    return _then(
      _value.copyWith(
            percentiles: null == percentiles
                ? _value.percentiles
                : percentiles // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScoutingDataImplCopyWith<$Res>
    implements $ScoutingDataCopyWith<$Res> {
  factory _$$ScoutingDataImplCopyWith(
    _$ScoutingDataImpl value,
    $Res Function(_$ScoutingDataImpl) then,
  ) = __$$ScoutingDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, int> percentiles, String source});
}

/// @nodoc
class __$$ScoutingDataImplCopyWithImpl<$Res>
    extends _$ScoutingDataCopyWithImpl<$Res, _$ScoutingDataImpl>
    implements _$$ScoutingDataImplCopyWith<$Res> {
  __$$ScoutingDataImplCopyWithImpl(
    _$ScoutingDataImpl _value,
    $Res Function(_$ScoutingDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScoutingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? percentiles = null, Object? source = null}) {
    return _then(
      _$ScoutingDataImpl(
        percentiles: null == percentiles
            ? _value._percentiles
            : percentiles // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoutingDataImpl implements _ScoutingData {
  const _$ScoutingDataImpl({
    final Map<String, int> percentiles = const {},
    this.source = 'fbref',
  }) : _percentiles = percentiles;

  factory _$ScoutingDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoutingDataImplFromJson(json);

  final Map<String, int> _percentiles;
  @override
  @JsonKey()
  Map<String, int> get percentiles {
    if (_percentiles is EqualUnmodifiableMapView) return _percentiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_percentiles);
  }

  @override
  @JsonKey()
  final String source;

  @override
  String toString() {
    return 'ScoutingData(percentiles: $percentiles, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoutingDataImpl &&
            const DeepCollectionEquality().equals(
              other._percentiles,
              _percentiles,
            ) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_percentiles),
    source,
  );

  /// Create a copy of ScoutingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoutingDataImplCopyWith<_$ScoutingDataImpl> get copyWith =>
      __$$ScoutingDataImplCopyWithImpl<_$ScoutingDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoutingDataImplToJson(this);
  }
}

abstract class _ScoutingData implements ScoutingData {
  const factory _ScoutingData({
    final Map<String, int> percentiles,
    final String source,
  }) = _$ScoutingDataImpl;

  factory _ScoutingData.fromJson(Map<String, dynamic> json) =
      _$ScoutingDataImpl.fromJson;

  @override
  Map<String, int> get percentiles;
  @override
  String get source;

  /// Create a copy of ScoutingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoutingDataImplCopyWith<_$ScoutingDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlayerInjury _$PlayerInjuryFromJson(Map<String, dynamic> json) {
  return _PlayerInjury.fromJson(json);
}

/// @nodoc
mixin _$PlayerInjury {
  String get type => throw _privateConstructorUsedError;
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  int get days => throw _privateConstructorUsedError;

  /// Serializes this PlayerInjury to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerInjury
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerInjuryCopyWith<PlayerInjury> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerInjuryCopyWith<$Res> {
  factory $PlayerInjuryCopyWith(
    PlayerInjury value,
    $Res Function(PlayerInjury) then,
  ) = _$PlayerInjuryCopyWithImpl<$Res, PlayerInjury>;
  @useResult
  $Res call({String type, String from, String to, int days});
}

/// @nodoc
class _$PlayerInjuryCopyWithImpl<$Res, $Val extends PlayerInjury>
    implements $PlayerInjuryCopyWith<$Res> {
  _$PlayerInjuryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerInjury
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? from = null,
    Object? to = null,
    Object? days = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as String,
            to: null == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as String,
            days: null == days
                ? _value.days
                : days // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerInjuryImplCopyWith<$Res>
    implements $PlayerInjuryCopyWith<$Res> {
  factory _$$PlayerInjuryImplCopyWith(
    _$PlayerInjuryImpl value,
    $Res Function(_$PlayerInjuryImpl) then,
  ) = __$$PlayerInjuryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String from, String to, int days});
}

/// @nodoc
class __$$PlayerInjuryImplCopyWithImpl<$Res>
    extends _$PlayerInjuryCopyWithImpl<$Res, _$PlayerInjuryImpl>
    implements _$$PlayerInjuryImplCopyWith<$Res> {
  __$$PlayerInjuryImplCopyWithImpl(
    _$PlayerInjuryImpl _value,
    $Res Function(_$PlayerInjuryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerInjury
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? from = null,
    Object? to = null,
    Object? days = null,
  }) {
    return _then(
      _$PlayerInjuryImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
        days: null == days
            ? _value.days
            : days // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerInjuryImpl implements _PlayerInjury {
  const _$PlayerInjuryImpl({
    this.type = '',
    this.from = '',
    this.to = '',
    this.days = 0,
  });

  factory _$PlayerInjuryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerInjuryImplFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String from;
  @override
  @JsonKey()
  final String to;
  @override
  @JsonKey()
  final int days;

  @override
  String toString() {
    return 'PlayerInjury(type: $type, from: $from, to: $to, days: $days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerInjuryImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.days, days) || other.days == days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, from, to, days);

  /// Create a copy of PlayerInjury
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerInjuryImplCopyWith<_$PlayerInjuryImpl> get copyWith =>
      __$$PlayerInjuryImplCopyWithImpl<_$PlayerInjuryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerInjuryImplToJson(this);
  }
}

abstract class _PlayerInjury implements PlayerInjury {
  const factory _PlayerInjury({
    final String type,
    final String from,
    final String to,
    final int days,
  }) = _$PlayerInjuryImpl;

  factory _PlayerInjury.fromJson(Map<String, dynamic> json) =
      _$PlayerInjuryImpl.fromJson;

  @override
  String get type;
  @override
  String get from;
  @override
  String get to;
  @override
  int get days;

  /// Create a copy of PlayerInjury
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerInjuryImplCopyWith<_$PlayerInjuryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NationalTeamInfo _$NationalTeamInfoFromJson(Map<String, dynamic> json) {
  return _NationalTeamInfo.fromJson(json);
}

/// @nodoc
mixin _$NationalTeamInfo {
  String get team => throw _privateConstructorUsedError;
  int get caps => throw _privateConstructorUsedError;
  int get goals => throw _privateConstructorUsedError;

  /// Serializes this NationalTeamInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NationalTeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NationalTeamInfoCopyWith<NationalTeamInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NationalTeamInfoCopyWith<$Res> {
  factory $NationalTeamInfoCopyWith(
    NationalTeamInfo value,
    $Res Function(NationalTeamInfo) then,
  ) = _$NationalTeamInfoCopyWithImpl<$Res, NationalTeamInfo>;
  @useResult
  $Res call({String team, int caps, int goals});
}

/// @nodoc
class _$NationalTeamInfoCopyWithImpl<$Res, $Val extends NationalTeamInfo>
    implements $NationalTeamInfoCopyWith<$Res> {
  _$NationalTeamInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NationalTeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? team = null, Object? caps = null, Object? goals = null}) {
    return _then(
      _value.copyWith(
            team: null == team
                ? _value.team
                : team // ignore: cast_nullable_to_non_nullable
                      as String,
            caps: null == caps
                ? _value.caps
                : caps // ignore: cast_nullable_to_non_nullable
                      as int,
            goals: null == goals
                ? _value.goals
                : goals // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NationalTeamInfoImplCopyWith<$Res>
    implements $NationalTeamInfoCopyWith<$Res> {
  factory _$$NationalTeamInfoImplCopyWith(
    _$NationalTeamInfoImpl value,
    $Res Function(_$NationalTeamInfoImpl) then,
  ) = __$$NationalTeamInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String team, int caps, int goals});
}

/// @nodoc
class __$$NationalTeamInfoImplCopyWithImpl<$Res>
    extends _$NationalTeamInfoCopyWithImpl<$Res, _$NationalTeamInfoImpl>
    implements _$$NationalTeamInfoImplCopyWith<$Res> {
  __$$NationalTeamInfoImplCopyWithImpl(
    _$NationalTeamInfoImpl _value,
    $Res Function(_$NationalTeamInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NationalTeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? team = null, Object? caps = null, Object? goals = null}) {
    return _then(
      _$NationalTeamInfoImpl(
        team: null == team
            ? _value.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String,
        caps: null == caps
            ? _value.caps
            : caps // ignore: cast_nullable_to_non_nullable
                  as int,
        goals: null == goals
            ? _value.goals
            : goals // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NationalTeamInfoImpl implements _NationalTeamInfo {
  const _$NationalTeamInfoImpl({this.team = '', this.caps = 0, this.goals = 0});

  factory _$NationalTeamInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NationalTeamInfoImplFromJson(json);

  @override
  @JsonKey()
  final String team;
  @override
  @JsonKey()
  final int caps;
  @override
  @JsonKey()
  final int goals;

  @override
  String toString() {
    return 'NationalTeamInfo(team: $team, caps: $caps, goals: $goals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NationalTeamInfoImpl &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.caps, caps) || other.caps == caps) &&
            (identical(other.goals, goals) || other.goals == goals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, team, caps, goals);

  /// Create a copy of NationalTeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NationalTeamInfoImplCopyWith<_$NationalTeamInfoImpl> get copyWith =>
      __$$NationalTeamInfoImplCopyWithImpl<_$NationalTeamInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NationalTeamInfoImplToJson(this);
  }
}

abstract class _NationalTeamInfo implements NationalTeamInfo {
  const factory _NationalTeamInfo({
    final String team,
    final int caps,
    final int goals,
  }) = _$NationalTeamInfoImpl;

  factory _NationalTeamInfo.fromJson(Map<String, dynamic> json) =
      _$NationalTeamInfoImpl.fromJson;

  @override
  String get team;
  @override
  int get caps;
  @override
  int get goals;

  /// Create a copy of NationalTeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NationalTeamInfoImplCopyWith<_$NationalTeamInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
