// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) {
  return _MatchModel.fromJson(json);
}

/// @nodoc
mixin _$MatchModel {
  String get id => throw _privateConstructorUsedError;
  TeamInfo get homeTeam => throw _privateConstructorUsedError;
  TeamInfo get awayTeam => throw _privateConstructorUsedError;
  String get league => throw _privateConstructorUsedError;
  String get leagueCountry => throw _privateConstructorUsedError;
  int get week => throw _privateConstructorUsedError;
  DateTime get matchDate => throw _privateConstructorUsedError;
  String get stadium => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  MatchScore? get score => throw _privateConstructorUsedError;
  MatchOdds? get odds => throw _privateConstructorUsedError;
  String get importance => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MatchModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchModelCopyWith<MatchModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchModelCopyWith<$Res> {
  factory $MatchModelCopyWith(
    MatchModel value,
    $Res Function(MatchModel) then,
  ) = _$MatchModelCopyWithImpl<$Res, MatchModel>;
  @useResult
  $Res call({
    String id,
    TeamInfo homeTeam,
    TeamInfo awayTeam,
    String league,
    String leagueCountry,
    int week,
    DateTime matchDate,
    String stadium,
    String status,
    MatchScore? score,
    MatchOdds? odds,
    String importance,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $TeamInfoCopyWith<$Res> get homeTeam;
  $TeamInfoCopyWith<$Res> get awayTeam;
  $MatchScoreCopyWith<$Res>? get score;
  $MatchOddsCopyWith<$Res>? get odds;
}

/// @nodoc
class _$MatchModelCopyWithImpl<$Res, $Val extends MatchModel>
    implements $MatchModelCopyWith<$Res> {
  _$MatchModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? homeTeam = null,
    Object? awayTeam = null,
    Object? league = null,
    Object? leagueCountry = null,
    Object? week = null,
    Object? matchDate = null,
    Object? stadium = null,
    Object? status = null,
    Object? score = freezed,
    Object? odds = freezed,
    Object? importance = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            homeTeam: null == homeTeam
                ? _value.homeTeam
                : homeTeam // ignore: cast_nullable_to_non_nullable
                      as TeamInfo,
            awayTeam: null == awayTeam
                ? _value.awayTeam
                : awayTeam // ignore: cast_nullable_to_non_nullable
                      as TeamInfo,
            league: null == league
                ? _value.league
                : league // ignore: cast_nullable_to_non_nullable
                      as String,
            leagueCountry: null == leagueCountry
                ? _value.leagueCountry
                : leagueCountry // ignore: cast_nullable_to_non_nullable
                      as String,
            week: null == week
                ? _value.week
                : week // ignore: cast_nullable_to_non_nullable
                      as int,
            matchDate: null == matchDate
                ? _value.matchDate
                : matchDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            stadium: null == stadium
                ? _value.stadium
                : stadium // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as MatchScore?,
            odds: freezed == odds
                ? _value.odds
                : odds // ignore: cast_nullable_to_non_nullable
                      as MatchOdds?,
            importance: null == importance
                ? _value.importance
                : importance // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamInfoCopyWith<$Res> get homeTeam {
    return $TeamInfoCopyWith<$Res>(_value.homeTeam, (value) {
      return _then(_value.copyWith(homeTeam: value) as $Val);
    });
  }

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamInfoCopyWith<$Res> get awayTeam {
    return $TeamInfoCopyWith<$Res>(_value.awayTeam, (value) {
      return _then(_value.copyWith(awayTeam: value) as $Val);
    });
  }

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchScoreCopyWith<$Res>? get score {
    if (_value.score == null) {
      return null;
    }

    return $MatchScoreCopyWith<$Res>(_value.score!, (value) {
      return _then(_value.copyWith(score: value) as $Val);
    });
  }

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchOddsCopyWith<$Res>? get odds {
    if (_value.odds == null) {
      return null;
    }

    return $MatchOddsCopyWith<$Res>(_value.odds!, (value) {
      return _then(_value.copyWith(odds: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MatchModelImplCopyWith<$Res>
    implements $MatchModelCopyWith<$Res> {
  factory _$$MatchModelImplCopyWith(
    _$MatchModelImpl value,
    $Res Function(_$MatchModelImpl) then,
  ) = __$$MatchModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    TeamInfo homeTeam,
    TeamInfo awayTeam,
    String league,
    String leagueCountry,
    int week,
    DateTime matchDate,
    String stadium,
    String status,
    MatchScore? score,
    MatchOdds? odds,
    String importance,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $TeamInfoCopyWith<$Res> get homeTeam;
  @override
  $TeamInfoCopyWith<$Res> get awayTeam;
  @override
  $MatchScoreCopyWith<$Res>? get score;
  @override
  $MatchOddsCopyWith<$Res>? get odds;
}

/// @nodoc
class __$$MatchModelImplCopyWithImpl<$Res>
    extends _$MatchModelCopyWithImpl<$Res, _$MatchModelImpl>
    implements _$$MatchModelImplCopyWith<$Res> {
  __$$MatchModelImplCopyWithImpl(
    _$MatchModelImpl _value,
    $Res Function(_$MatchModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? homeTeam = null,
    Object? awayTeam = null,
    Object? league = null,
    Object? leagueCountry = null,
    Object? week = null,
    Object? matchDate = null,
    Object? stadium = null,
    Object? status = null,
    Object? score = freezed,
    Object? odds = freezed,
    Object? importance = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$MatchModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        homeTeam: null == homeTeam
            ? _value.homeTeam
            : homeTeam // ignore: cast_nullable_to_non_nullable
                  as TeamInfo,
        awayTeam: null == awayTeam
            ? _value.awayTeam
            : awayTeam // ignore: cast_nullable_to_non_nullable
                  as TeamInfo,
        league: null == league
            ? _value.league
            : league // ignore: cast_nullable_to_non_nullable
                  as String,
        leagueCountry: null == leagueCountry
            ? _value.leagueCountry
            : leagueCountry // ignore: cast_nullable_to_non_nullable
                  as String,
        week: null == week
            ? _value.week
            : week // ignore: cast_nullable_to_non_nullable
                  as int,
        matchDate: null == matchDate
            ? _value.matchDate
            : matchDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        stadium: null == stadium
            ? _value.stadium
            : stadium // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as MatchScore?,
        odds: freezed == odds
            ? _value.odds
            : odds // ignore: cast_nullable_to_non_nullable
                  as MatchOdds?,
        importance: null == importance
            ? _value.importance
            : importance // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchModelImpl implements _MatchModel {
  const _$MatchModelImpl({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.league,
    this.leagueCountry = '',
    this.week = 0,
    required this.matchDate,
    this.stadium = '',
    this.status = 'upcoming',
    this.score,
    this.odds,
    this.importance = 'normal',
    this.createdAt,
    this.updatedAt,
  });

  factory _$MatchModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchModelImplFromJson(json);

  @override
  final String id;
  @override
  final TeamInfo homeTeam;
  @override
  final TeamInfo awayTeam;
  @override
  final String league;
  @override
  @JsonKey()
  final String leagueCountry;
  @override
  @JsonKey()
  final int week;
  @override
  final DateTime matchDate;
  @override
  @JsonKey()
  final String stadium;
  @override
  @JsonKey()
  final String status;
  @override
  final MatchScore? score;
  @override
  final MatchOdds? odds;
  @override
  @JsonKey()
  final String importance;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MatchModel(id: $id, homeTeam: $homeTeam, awayTeam: $awayTeam, league: $league, leagueCountry: $leagueCountry, week: $week, matchDate: $matchDate, stadium: $stadium, status: $status, score: $score, odds: $odds, importance: $importance, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.homeTeam, homeTeam) ||
                other.homeTeam == homeTeam) &&
            (identical(other.awayTeam, awayTeam) ||
                other.awayTeam == awayTeam) &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.leagueCountry, leagueCountry) ||
                other.leagueCountry == leagueCountry) &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.matchDate, matchDate) ||
                other.matchDate == matchDate) &&
            (identical(other.stadium, stadium) || other.stadium == stadium) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.odds, odds) || other.odds == odds) &&
            (identical(other.importance, importance) ||
                other.importance == importance) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    homeTeam,
    awayTeam,
    league,
    leagueCountry,
    week,
    matchDate,
    stadium,
    status,
    score,
    odds,
    importance,
    createdAt,
    updatedAt,
  );

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchModelImplCopyWith<_$MatchModelImpl> get copyWith =>
      __$$MatchModelImplCopyWithImpl<_$MatchModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchModelImplToJson(this);
  }
}

abstract class _MatchModel implements MatchModel {
  const factory _MatchModel({
    required final String id,
    required final TeamInfo homeTeam,
    required final TeamInfo awayTeam,
    required final String league,
    final String leagueCountry,
    final int week,
    required final DateTime matchDate,
    final String stadium,
    final String status,
    final MatchScore? score,
    final MatchOdds? odds,
    final String importance,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$MatchModelImpl;

  factory _MatchModel.fromJson(Map<String, dynamic> json) =
      _$MatchModelImpl.fromJson;

  @override
  String get id;
  @override
  TeamInfo get homeTeam;
  @override
  TeamInfo get awayTeam;
  @override
  String get league;
  @override
  String get leagueCountry;
  @override
  int get week;
  @override
  DateTime get matchDate;
  @override
  String get stadium;
  @override
  String get status;
  @override
  MatchScore? get score;
  @override
  MatchOdds? get odds;
  @override
  String get importance;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchModelImplCopyWith<_$MatchModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamInfo _$TeamInfoFromJson(Map<String, dynamic> json) {
  return _TeamInfo.fromJson(json);
}

/// @nodoc
mixin _$TeamInfo {
  String get name => throw _privateConstructorUsedError;
  String get shortName => throw _privateConstructorUsedError;
  String get logoUrl => throw _privateConstructorUsedError;
  String get formLast5 => throw _privateConstructorUsedError;

  /// Serializes this TeamInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamInfoCopyWith<TeamInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamInfoCopyWith<$Res> {
  factory $TeamInfoCopyWith(TeamInfo value, $Res Function(TeamInfo) then) =
      _$TeamInfoCopyWithImpl<$Res, TeamInfo>;
  @useResult
  $Res call({String name, String shortName, String logoUrl, String formLast5});
}

/// @nodoc
class _$TeamInfoCopyWithImpl<$Res, $Val extends TeamInfo>
    implements $TeamInfoCopyWith<$Res> {
  _$TeamInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? shortName = null,
    Object? logoUrl = null,
    Object? formLast5 = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            shortName: null == shortName
                ? _value.shortName
                : shortName // ignore: cast_nullable_to_non_nullable
                      as String,
            logoUrl: null == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            formLast5: null == formLast5
                ? _value.formLast5
                : formLast5 // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamInfoImplCopyWith<$Res>
    implements $TeamInfoCopyWith<$Res> {
  factory _$$TeamInfoImplCopyWith(
    _$TeamInfoImpl value,
    $Res Function(_$TeamInfoImpl) then,
  ) = __$$TeamInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String shortName, String logoUrl, String formLast5});
}

/// @nodoc
class __$$TeamInfoImplCopyWithImpl<$Res>
    extends _$TeamInfoCopyWithImpl<$Res, _$TeamInfoImpl>
    implements _$$TeamInfoImplCopyWith<$Res> {
  __$$TeamInfoImplCopyWithImpl(
    _$TeamInfoImpl _value,
    $Res Function(_$TeamInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? shortName = null,
    Object? logoUrl = null,
    Object? formLast5 = null,
  }) {
    return _then(
      _$TeamInfoImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        shortName: null == shortName
            ? _value.shortName
            : shortName // ignore: cast_nullable_to_non_nullable
                  as String,
        logoUrl: null == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        formLast5: null == formLast5
            ? _value.formLast5
            : formLast5 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamInfoImpl implements _TeamInfo {
  const _$TeamInfoImpl({
    required this.name,
    this.shortName = '',
    this.logoUrl = '',
    this.formLast5 = '',
  });

  factory _$TeamInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamInfoImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey()
  final String shortName;
  @override
  @JsonKey()
  final String logoUrl;
  @override
  @JsonKey()
  final String formLast5;

  @override
  String toString() {
    return 'TeamInfo(name: $name, shortName: $shortName, logoUrl: $logoUrl, formLast5: $formLast5)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamInfoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.formLast5, formLast5) ||
                other.formLast5 == formLast5));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, shortName, logoUrl, formLast5);

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamInfoImplCopyWith<_$TeamInfoImpl> get copyWith =>
      __$$TeamInfoImplCopyWithImpl<_$TeamInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamInfoImplToJson(this);
  }
}

abstract class _TeamInfo implements TeamInfo {
  const factory _TeamInfo({
    required final String name,
    final String shortName,
    final String logoUrl,
    final String formLast5,
  }) = _$TeamInfoImpl;

  factory _TeamInfo.fromJson(Map<String, dynamic> json) =
      _$TeamInfoImpl.fromJson;

  @override
  String get name;
  @override
  String get shortName;
  @override
  String get logoUrl;
  @override
  String get formLast5;

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamInfoImplCopyWith<_$TeamInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchScore _$MatchScoreFromJson(Map<String, dynamic> json) {
  return _MatchScore.fromJson(json);
}

/// @nodoc
mixin _$MatchScore {
  int get home => throw _privateConstructorUsedError;
  int get away => throw _privateConstructorUsedError;

  /// Serializes this MatchScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchScoreCopyWith<MatchScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchScoreCopyWith<$Res> {
  factory $MatchScoreCopyWith(
    MatchScore value,
    $Res Function(MatchScore) then,
  ) = _$MatchScoreCopyWithImpl<$Res, MatchScore>;
  @useResult
  $Res call({int home, int away});
}

/// @nodoc
class _$MatchScoreCopyWithImpl<$Res, $Val extends MatchScore>
    implements $MatchScoreCopyWith<$Res> {
  _$MatchScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? home = null, Object? away = null}) {
    return _then(
      _value.copyWith(
            home: null == home
                ? _value.home
                : home // ignore: cast_nullable_to_non_nullable
                      as int,
            away: null == away
                ? _value.away
                : away // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchScoreImplCopyWith<$Res>
    implements $MatchScoreCopyWith<$Res> {
  factory _$$MatchScoreImplCopyWith(
    _$MatchScoreImpl value,
    $Res Function(_$MatchScoreImpl) then,
  ) = __$$MatchScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int home, int away});
}

/// @nodoc
class __$$MatchScoreImplCopyWithImpl<$Res>
    extends _$MatchScoreCopyWithImpl<$Res, _$MatchScoreImpl>
    implements _$$MatchScoreImplCopyWith<$Res> {
  __$$MatchScoreImplCopyWithImpl(
    _$MatchScoreImpl _value,
    $Res Function(_$MatchScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? home = null, Object? away = null}) {
    return _then(
      _$MatchScoreImpl(
        home: null == home
            ? _value.home
            : home // ignore: cast_nullable_to_non_nullable
                  as int,
        away: null == away
            ? _value.away
            : away // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchScoreImpl implements _MatchScore {
  const _$MatchScoreImpl({this.home = 0, this.away = 0});

  factory _$MatchScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchScoreImplFromJson(json);

  @override
  @JsonKey()
  final int home;
  @override
  @JsonKey()
  final int away;

  @override
  String toString() {
    return 'MatchScore(home: $home, away: $away)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchScoreImpl &&
            (identical(other.home, home) || other.home == home) &&
            (identical(other.away, away) || other.away == away));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, home, away);

  /// Create a copy of MatchScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchScoreImplCopyWith<_$MatchScoreImpl> get copyWith =>
      __$$MatchScoreImplCopyWithImpl<_$MatchScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchScoreImplToJson(this);
  }
}

abstract class _MatchScore implements MatchScore {
  const factory _MatchScore({final int home, final int away}) =
      _$MatchScoreImpl;

  factory _MatchScore.fromJson(Map<String, dynamic> json) =
      _$MatchScoreImpl.fromJson;

  @override
  int get home;
  @override
  int get away;

  /// Create a copy of MatchScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchScoreImplCopyWith<_$MatchScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchOdds _$MatchOddsFromJson(Map<String, dynamic> json) {
  return _MatchOdds.fromJson(json);
}

/// @nodoc
mixin _$MatchOdds {
  double get home => throw _privateConstructorUsedError;
  double get draw => throw _privateConstructorUsedError;
  double get away => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;

  /// Serializes this MatchOdds to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchOdds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchOddsCopyWith<MatchOdds> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchOddsCopyWith<$Res> {
  factory $MatchOddsCopyWith(MatchOdds value, $Res Function(MatchOdds) then) =
      _$MatchOddsCopyWithImpl<$Res, MatchOdds>;
  @useResult
  $Res call({double home, double draw, double away, String source});
}

/// @nodoc
class _$MatchOddsCopyWithImpl<$Res, $Val extends MatchOdds>
    implements $MatchOddsCopyWith<$Res> {
  _$MatchOddsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchOdds
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? home = null,
    Object? draw = null,
    Object? away = null,
    Object? source = null,
  }) {
    return _then(
      _value.copyWith(
            home: null == home
                ? _value.home
                : home // ignore: cast_nullable_to_non_nullable
                      as double,
            draw: null == draw
                ? _value.draw
                : draw // ignore: cast_nullable_to_non_nullable
                      as double,
            away: null == away
                ? _value.away
                : away // ignore: cast_nullable_to_non_nullable
                      as double,
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
abstract class _$$MatchOddsImplCopyWith<$Res>
    implements $MatchOddsCopyWith<$Res> {
  factory _$$MatchOddsImplCopyWith(
    _$MatchOddsImpl value,
    $Res Function(_$MatchOddsImpl) then,
  ) = __$$MatchOddsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double home, double draw, double away, String source});
}

/// @nodoc
class __$$MatchOddsImplCopyWithImpl<$Res>
    extends _$MatchOddsCopyWithImpl<$Res, _$MatchOddsImpl>
    implements _$$MatchOddsImplCopyWith<$Res> {
  __$$MatchOddsImplCopyWithImpl(
    _$MatchOddsImpl _value,
    $Res Function(_$MatchOddsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchOdds
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? home = null,
    Object? draw = null,
    Object? away = null,
    Object? source = null,
  }) {
    return _then(
      _$MatchOddsImpl(
        home: null == home
            ? _value.home
            : home // ignore: cast_nullable_to_non_nullable
                  as double,
        draw: null == draw
            ? _value.draw
            : draw // ignore: cast_nullable_to_non_nullable
                  as double,
        away: null == away
            ? _value.away
            : away // ignore: cast_nullable_to_non_nullable
                  as double,
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
class _$MatchOddsImpl implements _MatchOdds {
  const _$MatchOddsImpl({
    this.home = 0.0,
    this.draw = 0.0,
    this.away = 0.0,
    this.source = '',
  });

  factory _$MatchOddsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchOddsImplFromJson(json);

  @override
  @JsonKey()
  final double home;
  @override
  @JsonKey()
  final double draw;
  @override
  @JsonKey()
  final double away;
  @override
  @JsonKey()
  final String source;

  @override
  String toString() {
    return 'MatchOdds(home: $home, draw: $draw, away: $away, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchOddsImpl &&
            (identical(other.home, home) || other.home == home) &&
            (identical(other.draw, draw) || other.draw == draw) &&
            (identical(other.away, away) || other.away == away) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, home, draw, away, source);

  /// Create a copy of MatchOdds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchOddsImplCopyWith<_$MatchOddsImpl> get copyWith =>
      __$$MatchOddsImplCopyWithImpl<_$MatchOddsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchOddsImplToJson(this);
  }
}

abstract class _MatchOdds implements MatchOdds {
  const factory _MatchOdds({
    final double home,
    final double draw,
    final double away,
    final String source,
  }) = _$MatchOddsImpl;

  factory _MatchOdds.fromJson(Map<String, dynamic> json) =
      _$MatchOddsImpl.fromJson;

  @override
  double get home;
  @override
  double get draw;
  @override
  double get away;
  @override
  String get source;

  /// Create a copy of MatchOdds
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchOddsImplCopyWith<_$MatchOddsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
