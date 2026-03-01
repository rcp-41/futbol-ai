// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LeagueModel _$LeagueModelFromJson(Map<String, dynamic> json) {
  return _LeagueModel.fromJson(json);
}

/// @nodoc
mixin _$LeagueModel {
  String get key => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get season => throw _privateConstructorUsedError;
  int get sofascoreId => throw _privateConstructorUsedError;
  int get fbrefId => throw _privateConstructorUsedError;
  int get sofascoreSeasonId => throw _privateConstructorUsedError;
  String get transfermarktId => throw _privateConstructorUsedError;
  LeagueStandings? get standings => throw _privateConstructorUsedError;
  List<TopPlayerEntry> get topScorers => throw _privateConstructorUsedError;
  List<TopPlayerEntry> get topAssists => throw _privateConstructorUsedError;
  List<TopPlayerEntry> get topRatings => throw _privateConstructorUsedError;
  String get dataHash => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this LeagueModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeagueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeagueModelCopyWith<LeagueModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueModelCopyWith<$Res> {
  factory $LeagueModelCopyWith(
    LeagueModel value,
    $Res Function(LeagueModel) then,
  ) = _$LeagueModelCopyWithImpl<$Res, LeagueModel>;
  @useResult
  $Res call({
    String key,
    String name,
    String country,
    String season,
    int sofascoreId,
    int fbrefId,
    int sofascoreSeasonId,
    String transfermarktId,
    LeagueStandings? standings,
    List<TopPlayerEntry> topScorers,
    List<TopPlayerEntry> topAssists,
    List<TopPlayerEntry> topRatings,
    String dataHash,
    DateTime? lastUpdated,
  });

  $LeagueStandingsCopyWith<$Res>? get standings;
}

/// @nodoc
class _$LeagueModelCopyWithImpl<$Res, $Val extends LeagueModel>
    implements $LeagueModelCopyWith<$Res> {
  _$LeagueModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeagueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? country = null,
    Object? season = null,
    Object? sofascoreId = null,
    Object? fbrefId = null,
    Object? sofascoreSeasonId = null,
    Object? transfermarktId = null,
    Object? standings = freezed,
    Object? topScorers = null,
    Object? topAssists = null,
    Object? topRatings = null,
    Object? dataHash = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _value.copyWith(
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            country: null == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String,
            season: null == season
                ? _value.season
                : season // ignore: cast_nullable_to_non_nullable
                      as String,
            sofascoreId: null == sofascoreId
                ? _value.sofascoreId
                : sofascoreId // ignore: cast_nullable_to_non_nullable
                      as int,
            fbrefId: null == fbrefId
                ? _value.fbrefId
                : fbrefId // ignore: cast_nullable_to_non_nullable
                      as int,
            sofascoreSeasonId: null == sofascoreSeasonId
                ? _value.sofascoreSeasonId
                : sofascoreSeasonId // ignore: cast_nullable_to_non_nullable
                      as int,
            transfermarktId: null == transfermarktId
                ? _value.transfermarktId
                : transfermarktId // ignore: cast_nullable_to_non_nullable
                      as String,
            standings: freezed == standings
                ? _value.standings
                : standings // ignore: cast_nullable_to_non_nullable
                      as LeagueStandings?,
            topScorers: null == topScorers
                ? _value.topScorers
                : topScorers // ignore: cast_nullable_to_non_nullable
                      as List<TopPlayerEntry>,
            topAssists: null == topAssists
                ? _value.topAssists
                : topAssists // ignore: cast_nullable_to_non_nullable
                      as List<TopPlayerEntry>,
            topRatings: null == topRatings
                ? _value.topRatings
                : topRatings // ignore: cast_nullable_to_non_nullable
                      as List<TopPlayerEntry>,
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

  /// Create a copy of LeagueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LeagueStandingsCopyWith<$Res>? get standings {
    if (_value.standings == null) {
      return null;
    }

    return $LeagueStandingsCopyWith<$Res>(_value.standings!, (value) {
      return _then(_value.copyWith(standings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LeagueModelImplCopyWith<$Res>
    implements $LeagueModelCopyWith<$Res> {
  factory _$$LeagueModelImplCopyWith(
    _$LeagueModelImpl value,
    $Res Function(_$LeagueModelImpl) then,
  ) = __$$LeagueModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String key,
    String name,
    String country,
    String season,
    int sofascoreId,
    int fbrefId,
    int sofascoreSeasonId,
    String transfermarktId,
    LeagueStandings? standings,
    List<TopPlayerEntry> topScorers,
    List<TopPlayerEntry> topAssists,
    List<TopPlayerEntry> topRatings,
    String dataHash,
    DateTime? lastUpdated,
  });

  @override
  $LeagueStandingsCopyWith<$Res>? get standings;
}

/// @nodoc
class __$$LeagueModelImplCopyWithImpl<$Res>
    extends _$LeagueModelCopyWithImpl<$Res, _$LeagueModelImpl>
    implements _$$LeagueModelImplCopyWith<$Res> {
  __$$LeagueModelImplCopyWithImpl(
    _$LeagueModelImpl _value,
    $Res Function(_$LeagueModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeagueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? country = null,
    Object? season = null,
    Object? sofascoreId = null,
    Object? fbrefId = null,
    Object? sofascoreSeasonId = null,
    Object? transfermarktId = null,
    Object? standings = freezed,
    Object? topScorers = null,
    Object? topAssists = null,
    Object? topRatings = null,
    Object? dataHash = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _$LeagueModelImpl(
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        country: null == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String,
        season: null == season
            ? _value.season
            : season // ignore: cast_nullable_to_non_nullable
                  as String,
        sofascoreId: null == sofascoreId
            ? _value.sofascoreId
            : sofascoreId // ignore: cast_nullable_to_non_nullable
                  as int,
        fbrefId: null == fbrefId
            ? _value.fbrefId
            : fbrefId // ignore: cast_nullable_to_non_nullable
                  as int,
        sofascoreSeasonId: null == sofascoreSeasonId
            ? _value.sofascoreSeasonId
            : sofascoreSeasonId // ignore: cast_nullable_to_non_nullable
                  as int,
        transfermarktId: null == transfermarktId
            ? _value.transfermarktId
            : transfermarktId // ignore: cast_nullable_to_non_nullable
                  as String,
        standings: freezed == standings
            ? _value.standings
            : standings // ignore: cast_nullable_to_non_nullable
                  as LeagueStandings?,
        topScorers: null == topScorers
            ? _value._topScorers
            : topScorers // ignore: cast_nullable_to_non_nullable
                  as List<TopPlayerEntry>,
        topAssists: null == topAssists
            ? _value._topAssists
            : topAssists // ignore: cast_nullable_to_non_nullable
                  as List<TopPlayerEntry>,
        topRatings: null == topRatings
            ? _value._topRatings
            : topRatings // ignore: cast_nullable_to_non_nullable
                  as List<TopPlayerEntry>,
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
class _$LeagueModelImpl implements _LeagueModel {
  const _$LeagueModelImpl({
    required this.key,
    required this.name,
    this.country = '',
    this.season = '',
    this.sofascoreId = 0,
    this.fbrefId = 0,
    this.sofascoreSeasonId = 0,
    this.transfermarktId = '',
    this.standings,
    final List<TopPlayerEntry> topScorers = const [],
    final List<TopPlayerEntry> topAssists = const [],
    final List<TopPlayerEntry> topRatings = const [],
    this.dataHash = '',
    this.lastUpdated,
  }) : _topScorers = topScorers,
       _topAssists = topAssists,
       _topRatings = topRatings;

  factory _$LeagueModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeagueModelImplFromJson(json);

  @override
  final String key;
  @override
  final String name;
  @override
  @JsonKey()
  final String country;
  @override
  @JsonKey()
  final String season;
  @override
  @JsonKey()
  final int sofascoreId;
  @override
  @JsonKey()
  final int fbrefId;
  @override
  @JsonKey()
  final int sofascoreSeasonId;
  @override
  @JsonKey()
  final String transfermarktId;
  @override
  final LeagueStandings? standings;
  final List<TopPlayerEntry> _topScorers;
  @override
  @JsonKey()
  List<TopPlayerEntry> get topScorers {
    if (_topScorers is EqualUnmodifiableListView) return _topScorers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topScorers);
  }

  final List<TopPlayerEntry> _topAssists;
  @override
  @JsonKey()
  List<TopPlayerEntry> get topAssists {
    if (_topAssists is EqualUnmodifiableListView) return _topAssists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topAssists);
  }

  final List<TopPlayerEntry> _topRatings;
  @override
  @JsonKey()
  List<TopPlayerEntry> get topRatings {
    if (_topRatings is EqualUnmodifiableListView) return _topRatings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topRatings);
  }

  @override
  @JsonKey()
  final String dataHash;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'LeagueModel(key: $key, name: $name, country: $country, season: $season, sofascoreId: $sofascoreId, fbrefId: $fbrefId, sofascoreSeasonId: $sofascoreSeasonId, transfermarktId: $transfermarktId, standings: $standings, topScorers: $topScorers, topAssists: $topAssists, topRatings: $topRatings, dataHash: $dataHash, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueModelImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.season, season) || other.season == season) &&
            (identical(other.sofascoreId, sofascoreId) ||
                other.sofascoreId == sofascoreId) &&
            (identical(other.fbrefId, fbrefId) || other.fbrefId == fbrefId) &&
            (identical(other.sofascoreSeasonId, sofascoreSeasonId) ||
                other.sofascoreSeasonId == sofascoreSeasonId) &&
            (identical(other.transfermarktId, transfermarktId) ||
                other.transfermarktId == transfermarktId) &&
            (identical(other.standings, standings) ||
                other.standings == standings) &&
            const DeepCollectionEquality().equals(
              other._topScorers,
              _topScorers,
            ) &&
            const DeepCollectionEquality().equals(
              other._topAssists,
              _topAssists,
            ) &&
            const DeepCollectionEquality().equals(
              other._topRatings,
              _topRatings,
            ) &&
            (identical(other.dataHash, dataHash) ||
                other.dataHash == dataHash) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    key,
    name,
    country,
    season,
    sofascoreId,
    fbrefId,
    sofascoreSeasonId,
    transfermarktId,
    standings,
    const DeepCollectionEquality().hash(_topScorers),
    const DeepCollectionEquality().hash(_topAssists),
    const DeepCollectionEquality().hash(_topRatings),
    dataHash,
    lastUpdated,
  );

  /// Create a copy of LeagueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueModelImplCopyWith<_$LeagueModelImpl> get copyWith =>
      __$$LeagueModelImplCopyWithImpl<_$LeagueModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeagueModelImplToJson(this);
  }
}

abstract class _LeagueModel implements LeagueModel {
  const factory _LeagueModel({
    required final String key,
    required final String name,
    final String country,
    final String season,
    final int sofascoreId,
    final int fbrefId,
    final int sofascoreSeasonId,
    final String transfermarktId,
    final LeagueStandings? standings,
    final List<TopPlayerEntry> topScorers,
    final List<TopPlayerEntry> topAssists,
    final List<TopPlayerEntry> topRatings,
    final String dataHash,
    final DateTime? lastUpdated,
  }) = _$LeagueModelImpl;

  factory _LeagueModel.fromJson(Map<String, dynamic> json) =
      _$LeagueModelImpl.fromJson;

  @override
  String get key;
  @override
  String get name;
  @override
  String get country;
  @override
  String get season;
  @override
  int get sofascoreId;
  @override
  int get fbrefId;
  @override
  int get sofascoreSeasonId;
  @override
  String get transfermarktId;
  @override
  LeagueStandings? get standings;
  @override
  List<TopPlayerEntry> get topScorers;
  @override
  List<TopPlayerEntry> get topAssists;
  @override
  List<TopPlayerEntry> get topRatings;
  @override
  String get dataHash;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of LeagueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeagueModelImplCopyWith<_$LeagueModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LeagueStandings _$LeagueStandingsFromJson(Map<String, dynamic> json) {
  return _LeagueStandings.fromJson(json);
}

/// @nodoc
mixin _$LeagueStandings {
  List<StandingEntry> get total => throw _privateConstructorUsedError;
  List<StandingEntry> get home => throw _privateConstructorUsedError;
  List<StandingEntry> get away => throw _privateConstructorUsedError;

  /// Serializes this LeagueStandings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeagueStandings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeagueStandingsCopyWith<LeagueStandings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueStandingsCopyWith<$Res> {
  factory $LeagueStandingsCopyWith(
    LeagueStandings value,
    $Res Function(LeagueStandings) then,
  ) = _$LeagueStandingsCopyWithImpl<$Res, LeagueStandings>;
  @useResult
  $Res call({
    List<StandingEntry> total,
    List<StandingEntry> home,
    List<StandingEntry> away,
  });
}

/// @nodoc
class _$LeagueStandingsCopyWithImpl<$Res, $Val extends LeagueStandings>
    implements $LeagueStandingsCopyWith<$Res> {
  _$LeagueStandingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeagueStandings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? total = null, Object? home = null, Object? away = null}) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as List<StandingEntry>,
            home: null == home
                ? _value.home
                : home // ignore: cast_nullable_to_non_nullable
                      as List<StandingEntry>,
            away: null == away
                ? _value.away
                : away // ignore: cast_nullable_to_non_nullable
                      as List<StandingEntry>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeagueStandingsImplCopyWith<$Res>
    implements $LeagueStandingsCopyWith<$Res> {
  factory _$$LeagueStandingsImplCopyWith(
    _$LeagueStandingsImpl value,
    $Res Function(_$LeagueStandingsImpl) then,
  ) = __$$LeagueStandingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<StandingEntry> total,
    List<StandingEntry> home,
    List<StandingEntry> away,
  });
}

/// @nodoc
class __$$LeagueStandingsImplCopyWithImpl<$Res>
    extends _$LeagueStandingsCopyWithImpl<$Res, _$LeagueStandingsImpl>
    implements _$$LeagueStandingsImplCopyWith<$Res> {
  __$$LeagueStandingsImplCopyWithImpl(
    _$LeagueStandingsImpl _value,
    $Res Function(_$LeagueStandingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeagueStandings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? total = null, Object? home = null, Object? away = null}) {
    return _then(
      _$LeagueStandingsImpl(
        total: null == total
            ? _value._total
            : total // ignore: cast_nullable_to_non_nullable
                  as List<StandingEntry>,
        home: null == home
            ? _value._home
            : home // ignore: cast_nullable_to_non_nullable
                  as List<StandingEntry>,
        away: null == away
            ? _value._away
            : away // ignore: cast_nullable_to_non_nullable
                  as List<StandingEntry>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeagueStandingsImpl implements _LeagueStandings {
  const _$LeagueStandingsImpl({
    final List<StandingEntry> total = const [],
    final List<StandingEntry> home = const [],
    final List<StandingEntry> away = const [],
  }) : _total = total,
       _home = home,
       _away = away;

  factory _$LeagueStandingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeagueStandingsImplFromJson(json);

  final List<StandingEntry> _total;
  @override
  @JsonKey()
  List<StandingEntry> get total {
    if (_total is EqualUnmodifiableListView) return _total;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_total);
  }

  final List<StandingEntry> _home;
  @override
  @JsonKey()
  List<StandingEntry> get home {
    if (_home is EqualUnmodifiableListView) return _home;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_home);
  }

  final List<StandingEntry> _away;
  @override
  @JsonKey()
  List<StandingEntry> get away {
    if (_away is EqualUnmodifiableListView) return _away;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_away);
  }

  @override
  String toString() {
    return 'LeagueStandings(total: $total, home: $home, away: $away)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueStandingsImpl &&
            const DeepCollectionEquality().equals(other._total, _total) &&
            const DeepCollectionEquality().equals(other._home, _home) &&
            const DeepCollectionEquality().equals(other._away, _away));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_total),
    const DeepCollectionEquality().hash(_home),
    const DeepCollectionEquality().hash(_away),
  );

  /// Create a copy of LeagueStandings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueStandingsImplCopyWith<_$LeagueStandingsImpl> get copyWith =>
      __$$LeagueStandingsImplCopyWithImpl<_$LeagueStandingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LeagueStandingsImplToJson(this);
  }
}

abstract class _LeagueStandings implements LeagueStandings {
  const factory _LeagueStandings({
    final List<StandingEntry> total,
    final List<StandingEntry> home,
    final List<StandingEntry> away,
  }) = _$LeagueStandingsImpl;

  factory _LeagueStandings.fromJson(Map<String, dynamic> json) =
      _$LeagueStandingsImpl.fromJson;

  @override
  List<StandingEntry> get total;
  @override
  List<StandingEntry> get home;
  @override
  List<StandingEntry> get away;

  /// Create a copy of LeagueStandings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeagueStandingsImplCopyWith<_$LeagueStandingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StandingEntry _$StandingEntryFromJson(Map<String, dynamic> json) {
  return _StandingEntry.fromJson(json);
}

/// @nodoc
mixin _$StandingEntry {
  int get rank => throw _privateConstructorUsedError;
  String get team => throw _privateConstructorUsedError;
  int get played => throw _privateConstructorUsedError;
  int get won => throw _privateConstructorUsedError;
  int get drawn => throw _privateConstructorUsedError;
  int get lost => throw _privateConstructorUsedError;
  int get goalsFor => throw _privateConstructorUsedError;
  int get goalsAgainst => throw _privateConstructorUsedError;
  int get goalDifference => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  List<String> get form => throw _privateConstructorUsedError;

  /// Serializes this StandingEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StandingEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StandingEntryCopyWith<StandingEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StandingEntryCopyWith<$Res> {
  factory $StandingEntryCopyWith(
    StandingEntry value,
    $Res Function(StandingEntry) then,
  ) = _$StandingEntryCopyWithImpl<$Res, StandingEntry>;
  @useResult
  $Res call({
    int rank,
    String team,
    int played,
    int won,
    int drawn,
    int lost,
    int goalsFor,
    int goalsAgainst,
    int goalDifference,
    int points,
    List<String> form,
  });
}

/// @nodoc
class _$StandingEntryCopyWithImpl<$Res, $Val extends StandingEntry>
    implements $StandingEntryCopyWith<$Res> {
  _$StandingEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StandingEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? team = null,
    Object? played = null,
    Object? won = null,
    Object? drawn = null,
    Object? lost = null,
    Object? goalsFor = null,
    Object? goalsAgainst = null,
    Object? goalDifference = null,
    Object? points = null,
    Object? form = null,
  }) {
    return _then(
      _value.copyWith(
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as int,
            team: null == team
                ? _value.team
                : team // ignore: cast_nullable_to_non_nullable
                      as String,
            played: null == played
                ? _value.played
                : played // ignore: cast_nullable_to_non_nullable
                      as int,
            won: null == won
                ? _value.won
                : won // ignore: cast_nullable_to_non_nullable
                      as int,
            drawn: null == drawn
                ? _value.drawn
                : drawn // ignore: cast_nullable_to_non_nullable
                      as int,
            lost: null == lost
                ? _value.lost
                : lost // ignore: cast_nullable_to_non_nullable
                      as int,
            goalsFor: null == goalsFor
                ? _value.goalsFor
                : goalsFor // ignore: cast_nullable_to_non_nullable
                      as int,
            goalsAgainst: null == goalsAgainst
                ? _value.goalsAgainst
                : goalsAgainst // ignore: cast_nullable_to_non_nullable
                      as int,
            goalDifference: null == goalDifference
                ? _value.goalDifference
                : goalDifference // ignore: cast_nullable_to_non_nullable
                      as int,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            form: null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StandingEntryImplCopyWith<$Res>
    implements $StandingEntryCopyWith<$Res> {
  factory _$$StandingEntryImplCopyWith(
    _$StandingEntryImpl value,
    $Res Function(_$StandingEntryImpl) then,
  ) = __$$StandingEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int rank,
    String team,
    int played,
    int won,
    int drawn,
    int lost,
    int goalsFor,
    int goalsAgainst,
    int goalDifference,
    int points,
    List<String> form,
  });
}

/// @nodoc
class __$$StandingEntryImplCopyWithImpl<$Res>
    extends _$StandingEntryCopyWithImpl<$Res, _$StandingEntryImpl>
    implements _$$StandingEntryImplCopyWith<$Res> {
  __$$StandingEntryImplCopyWithImpl(
    _$StandingEntryImpl _value,
    $Res Function(_$StandingEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StandingEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? team = null,
    Object? played = null,
    Object? won = null,
    Object? drawn = null,
    Object? lost = null,
    Object? goalsFor = null,
    Object? goalsAgainst = null,
    Object? goalDifference = null,
    Object? points = null,
    Object? form = null,
  }) {
    return _then(
      _$StandingEntryImpl(
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as int,
        team: null == team
            ? _value.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String,
        played: null == played
            ? _value.played
            : played // ignore: cast_nullable_to_non_nullable
                  as int,
        won: null == won
            ? _value.won
            : won // ignore: cast_nullable_to_non_nullable
                  as int,
        drawn: null == drawn
            ? _value.drawn
            : drawn // ignore: cast_nullable_to_non_nullable
                  as int,
        lost: null == lost
            ? _value.lost
            : lost // ignore: cast_nullable_to_non_nullable
                  as int,
        goalsFor: null == goalsFor
            ? _value.goalsFor
            : goalsFor // ignore: cast_nullable_to_non_nullable
                  as int,
        goalsAgainst: null == goalsAgainst
            ? _value.goalsAgainst
            : goalsAgainst // ignore: cast_nullable_to_non_nullable
                  as int,
        goalDifference: null == goalDifference
            ? _value.goalDifference
            : goalDifference // ignore: cast_nullable_to_non_nullable
                  as int,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        form: null == form
            ? _value._form
            : form // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StandingEntryImpl implements _StandingEntry {
  const _$StandingEntryImpl({
    this.rank = 0,
    this.team = '',
    this.played = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.goalDifference = 0,
    this.points = 0,
    final List<String> form = const [],
  }) : _form = form;

  factory _$StandingEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StandingEntryImplFromJson(json);

  @override
  @JsonKey()
  final int rank;
  @override
  @JsonKey()
  final String team;
  @override
  @JsonKey()
  final int played;
  @override
  @JsonKey()
  final int won;
  @override
  @JsonKey()
  final int drawn;
  @override
  @JsonKey()
  final int lost;
  @override
  @JsonKey()
  final int goalsFor;
  @override
  @JsonKey()
  final int goalsAgainst;
  @override
  @JsonKey()
  final int goalDifference;
  @override
  @JsonKey()
  final int points;
  final List<String> _form;
  @override
  @JsonKey()
  List<String> get form {
    if (_form is EqualUnmodifiableListView) return _form;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_form);
  }

  @override
  String toString() {
    return 'StandingEntry(rank: $rank, team: $team, played: $played, won: $won, drawn: $drawn, lost: $lost, goalsFor: $goalsFor, goalsAgainst: $goalsAgainst, goalDifference: $goalDifference, points: $points, form: $form)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StandingEntryImpl &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.played, played) || other.played == played) &&
            (identical(other.won, won) || other.won == won) &&
            (identical(other.drawn, drawn) || other.drawn == drawn) &&
            (identical(other.lost, lost) || other.lost == lost) &&
            (identical(other.goalsFor, goalsFor) ||
                other.goalsFor == goalsFor) &&
            (identical(other.goalsAgainst, goalsAgainst) ||
                other.goalsAgainst == goalsAgainst) &&
            (identical(other.goalDifference, goalDifference) ||
                other.goalDifference == goalDifference) &&
            (identical(other.points, points) || other.points == points) &&
            const DeepCollectionEquality().equals(other._form, _form));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rank,
    team,
    played,
    won,
    drawn,
    lost,
    goalsFor,
    goalsAgainst,
    goalDifference,
    points,
    const DeepCollectionEquality().hash(_form),
  );

  /// Create a copy of StandingEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StandingEntryImplCopyWith<_$StandingEntryImpl> get copyWith =>
      __$$StandingEntryImplCopyWithImpl<_$StandingEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StandingEntryImplToJson(this);
  }
}

abstract class _StandingEntry implements StandingEntry {
  const factory _StandingEntry({
    final int rank,
    final String team,
    final int played,
    final int won,
    final int drawn,
    final int lost,
    final int goalsFor,
    final int goalsAgainst,
    final int goalDifference,
    final int points,
    final List<String> form,
  }) = _$StandingEntryImpl;

  factory _StandingEntry.fromJson(Map<String, dynamic> json) =
      _$StandingEntryImpl.fromJson;

  @override
  int get rank;
  @override
  String get team;
  @override
  int get played;
  @override
  int get won;
  @override
  int get drawn;
  @override
  int get lost;
  @override
  int get goalsFor;
  @override
  int get goalsAgainst;
  @override
  int get goalDifference;
  @override
  int get points;
  @override
  List<String> get form;

  /// Create a copy of StandingEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StandingEntryImplCopyWith<_$StandingEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopPlayerEntry _$TopPlayerEntryFromJson(Map<String, dynamic> json) {
  return _TopPlayerEntry.fromJson(json);
}

/// @nodoc
mixin _$TopPlayerEntry {
  String get player => throw _privateConstructorUsedError;
  String get team => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  int get goals => throw _privateConstructorUsedError;
  int get assists => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;

  /// Serializes this TopPlayerEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopPlayerEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopPlayerEntryCopyWith<TopPlayerEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopPlayerEntryCopyWith<$Res> {
  factory $TopPlayerEntryCopyWith(
    TopPlayerEntry value,
    $Res Function(TopPlayerEntry) then,
  ) = _$TopPlayerEntryCopyWithImpl<$Res, TopPlayerEntry>;
  @useResult
  $Res call({
    String player,
    String team,
    String playerId,
    int goals,
    int assists,
    double rating,
  });
}

/// @nodoc
class _$TopPlayerEntryCopyWithImpl<$Res, $Val extends TopPlayerEntry>
    implements $TopPlayerEntryCopyWith<$Res> {
  _$TopPlayerEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopPlayerEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? team = null,
    Object? playerId = null,
    Object? goals = null,
    Object? assists = null,
    Object? rating = null,
  }) {
    return _then(
      _value.copyWith(
            player: null == player
                ? _value.player
                : player // ignore: cast_nullable_to_non_nullable
                      as String,
            team: null == team
                ? _value.team
                : team // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            goals: null == goals
                ? _value.goals
                : goals // ignore: cast_nullable_to_non_nullable
                      as int,
            assists: null == assists
                ? _value.assists
                : assists // ignore: cast_nullable_to_non_nullable
                      as int,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TopPlayerEntryImplCopyWith<$Res>
    implements $TopPlayerEntryCopyWith<$Res> {
  factory _$$TopPlayerEntryImplCopyWith(
    _$TopPlayerEntryImpl value,
    $Res Function(_$TopPlayerEntryImpl) then,
  ) = __$$TopPlayerEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String player,
    String team,
    String playerId,
    int goals,
    int assists,
    double rating,
  });
}

/// @nodoc
class __$$TopPlayerEntryImplCopyWithImpl<$Res>
    extends _$TopPlayerEntryCopyWithImpl<$Res, _$TopPlayerEntryImpl>
    implements _$$TopPlayerEntryImplCopyWith<$Res> {
  __$$TopPlayerEntryImplCopyWithImpl(
    _$TopPlayerEntryImpl _value,
    $Res Function(_$TopPlayerEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopPlayerEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? team = null,
    Object? playerId = null,
    Object? goals = null,
    Object? assists = null,
    Object? rating = null,
  }) {
    return _then(
      _$TopPlayerEntryImpl(
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as String,
        team: null == team
            ? _value.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        goals: null == goals
            ? _value.goals
            : goals // ignore: cast_nullable_to_non_nullable
                  as int,
        assists: null == assists
            ? _value.assists
            : assists // ignore: cast_nullable_to_non_nullable
                  as int,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopPlayerEntryImpl implements _TopPlayerEntry {
  const _$TopPlayerEntryImpl({
    this.player = '',
    this.team = '',
    this.playerId = '',
    this.goals = 0,
    this.assists = 0,
    this.rating = 0.0,
  });

  factory _$TopPlayerEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopPlayerEntryImplFromJson(json);

  @override
  @JsonKey()
  final String player;
  @override
  @JsonKey()
  final String team;
  @override
  @JsonKey()
  final String playerId;
  @override
  @JsonKey()
  final int goals;
  @override
  @JsonKey()
  final int assists;
  @override
  @JsonKey()
  final double rating;

  @override
  String toString() {
    return 'TopPlayerEntry(player: $player, team: $team, playerId: $playerId, goals: $goals, assists: $assists, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopPlayerEntryImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.goals, goals) || other.goals == goals) &&
            (identical(other.assists, assists) || other.assists == assists) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, player, team, playerId, goals, assists, rating);

  /// Create a copy of TopPlayerEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopPlayerEntryImplCopyWith<_$TopPlayerEntryImpl> get copyWith =>
      __$$TopPlayerEntryImplCopyWithImpl<_$TopPlayerEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TopPlayerEntryImplToJson(this);
  }
}

abstract class _TopPlayerEntry implements TopPlayerEntry {
  const factory _TopPlayerEntry({
    final String player,
    final String team,
    final String playerId,
    final int goals,
    final int assists,
    final double rating,
  }) = _$TopPlayerEntryImpl;

  factory _TopPlayerEntry.fromJson(Map<String, dynamic> json) =
      _$TopPlayerEntryImpl.fromJson;

  @override
  String get player;
  @override
  String get team;
  @override
  String get playerId;
  @override
  int get goals;
  @override
  int get assists;
  @override
  double get rating;

  /// Create a copy of TopPlayerEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopPlayerEntryImplCopyWith<_$TopPlayerEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
