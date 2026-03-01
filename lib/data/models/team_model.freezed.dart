// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) {
  return _TeamModel.fromJson(json);
}

/// @nodoc
mixin _$TeamModel {
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get league => throw _privateConstructorUsedError;
  TeamIds? get ids => throw _privateConstructorUsedError;
  ManagerInfo? get manager => throw _privateConstructorUsedError;
  StadiumInfo? get stadium => throw _privateConstructorUsedError;
  List<SquadPlayer> get squad => throw _privateConstructorUsedError;
  List<InjuryInfo> get injuries => throw _privateConstructorUsedError;
  List<SuspendedPlayer> get suspended => throw _privateConstructorUsedError;
  List<TransferRumor> get transferRumors => throw _privateConstructorUsedError;
  TeamTransfers? get transfers => throw _privateConstructorUsedError;
  List<TeamNewsItem> get news => throw _privateConstructorUsedError;
  List<String> get recentForm => throw _privateConstructorUsedError;
  int get totalSquadValue => throw _privateConstructorUsedError;
  double get averageAge => throw _privateConstructorUsedError;
  List<ManagerHistoryEntry> get managerHistory =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get seasonStats => throw _privateConstructorUsedError;
  String get dataHash => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this TeamModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamModelCopyWith<TeamModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamModelCopyWith<$Res> {
  factory $TeamModelCopyWith(TeamModel value, $Res Function(TeamModel) then) =
      _$TeamModelCopyWithImpl<$Res, TeamModel>;
  @useResult
  $Res call({
    String slug,
    String name,
    String league,
    TeamIds? ids,
    ManagerInfo? manager,
    StadiumInfo? stadium,
    List<SquadPlayer> squad,
    List<InjuryInfo> injuries,
    List<SuspendedPlayer> suspended,
    List<TransferRumor> transferRumors,
    TeamTransfers? transfers,
    List<TeamNewsItem> news,
    List<String> recentForm,
    int totalSquadValue,
    double averageAge,
    List<ManagerHistoryEntry> managerHistory,
    Map<String, dynamic> seasonStats,
    String dataHash,
    DateTime? lastUpdated,
  });

  $TeamIdsCopyWith<$Res>? get ids;
  $ManagerInfoCopyWith<$Res>? get manager;
  $StadiumInfoCopyWith<$Res>? get stadium;
  $TeamTransfersCopyWith<$Res>? get transfers;
}

/// @nodoc
class _$TeamModelCopyWithImpl<$Res, $Val extends TeamModel>
    implements $TeamModelCopyWith<$Res> {
  _$TeamModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
    Object? league = null,
    Object? ids = freezed,
    Object? manager = freezed,
    Object? stadium = freezed,
    Object? squad = null,
    Object? injuries = null,
    Object? suspended = null,
    Object? transferRumors = null,
    Object? transfers = freezed,
    Object? news = null,
    Object? recentForm = null,
    Object? totalSquadValue = null,
    Object? averageAge = null,
    Object? managerHistory = null,
    Object? seasonStats = null,
    Object? dataHash = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _value.copyWith(
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            league: null == league
                ? _value.league
                : league // ignore: cast_nullable_to_non_nullable
                      as String,
            ids: freezed == ids
                ? _value.ids
                : ids // ignore: cast_nullable_to_non_nullable
                      as TeamIds?,
            manager: freezed == manager
                ? _value.manager
                : manager // ignore: cast_nullable_to_non_nullable
                      as ManagerInfo?,
            stadium: freezed == stadium
                ? _value.stadium
                : stadium // ignore: cast_nullable_to_non_nullable
                      as StadiumInfo?,
            squad: null == squad
                ? _value.squad
                : squad // ignore: cast_nullable_to_non_nullable
                      as List<SquadPlayer>,
            injuries: null == injuries
                ? _value.injuries
                : injuries // ignore: cast_nullable_to_non_nullable
                      as List<InjuryInfo>,
            suspended: null == suspended
                ? _value.suspended
                : suspended // ignore: cast_nullable_to_non_nullable
                      as List<SuspendedPlayer>,
            transferRumors: null == transferRumors
                ? _value.transferRumors
                : transferRumors // ignore: cast_nullable_to_non_nullable
                      as List<TransferRumor>,
            transfers: freezed == transfers
                ? _value.transfers
                : transfers // ignore: cast_nullable_to_non_nullable
                      as TeamTransfers?,
            news: null == news
                ? _value.news
                : news // ignore: cast_nullable_to_non_nullable
                      as List<TeamNewsItem>,
            recentForm: null == recentForm
                ? _value.recentForm
                : recentForm // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            totalSquadValue: null == totalSquadValue
                ? _value.totalSquadValue
                : totalSquadValue // ignore: cast_nullable_to_non_nullable
                      as int,
            averageAge: null == averageAge
                ? _value.averageAge
                : averageAge // ignore: cast_nullable_to_non_nullable
                      as double,
            managerHistory: null == managerHistory
                ? _value.managerHistory
                : managerHistory // ignore: cast_nullable_to_non_nullable
                      as List<ManagerHistoryEntry>,
            seasonStats: null == seasonStats
                ? _value.seasonStats
                : seasonStats // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
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

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamIdsCopyWith<$Res>? get ids {
    if (_value.ids == null) {
      return null;
    }

    return $TeamIdsCopyWith<$Res>(_value.ids!, (value) {
      return _then(_value.copyWith(ids: value) as $Val);
    });
  }

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ManagerInfoCopyWith<$Res>? get manager {
    if (_value.manager == null) {
      return null;
    }

    return $ManagerInfoCopyWith<$Res>(_value.manager!, (value) {
      return _then(_value.copyWith(manager: value) as $Val);
    });
  }

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StadiumInfoCopyWith<$Res>? get stadium {
    if (_value.stadium == null) {
      return null;
    }

    return $StadiumInfoCopyWith<$Res>(_value.stadium!, (value) {
      return _then(_value.copyWith(stadium: value) as $Val);
    });
  }

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamTransfersCopyWith<$Res>? get transfers {
    if (_value.transfers == null) {
      return null;
    }

    return $TeamTransfersCopyWith<$Res>(_value.transfers!, (value) {
      return _then(_value.copyWith(transfers: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeamModelImplCopyWith<$Res>
    implements $TeamModelCopyWith<$Res> {
  factory _$$TeamModelImplCopyWith(
    _$TeamModelImpl value,
    $Res Function(_$TeamModelImpl) then,
  ) = __$$TeamModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String slug,
    String name,
    String league,
    TeamIds? ids,
    ManagerInfo? manager,
    StadiumInfo? stadium,
    List<SquadPlayer> squad,
    List<InjuryInfo> injuries,
    List<SuspendedPlayer> suspended,
    List<TransferRumor> transferRumors,
    TeamTransfers? transfers,
    List<TeamNewsItem> news,
    List<String> recentForm,
    int totalSquadValue,
    double averageAge,
    List<ManagerHistoryEntry> managerHistory,
    Map<String, dynamic> seasonStats,
    String dataHash,
    DateTime? lastUpdated,
  });

  @override
  $TeamIdsCopyWith<$Res>? get ids;
  @override
  $ManagerInfoCopyWith<$Res>? get manager;
  @override
  $StadiumInfoCopyWith<$Res>? get stadium;
  @override
  $TeamTransfersCopyWith<$Res>? get transfers;
}

/// @nodoc
class __$$TeamModelImplCopyWithImpl<$Res>
    extends _$TeamModelCopyWithImpl<$Res, _$TeamModelImpl>
    implements _$$TeamModelImplCopyWith<$Res> {
  __$$TeamModelImplCopyWithImpl(
    _$TeamModelImpl _value,
    $Res Function(_$TeamModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
    Object? league = null,
    Object? ids = freezed,
    Object? manager = freezed,
    Object? stadium = freezed,
    Object? squad = null,
    Object? injuries = null,
    Object? suspended = null,
    Object? transferRumors = null,
    Object? transfers = freezed,
    Object? news = null,
    Object? recentForm = null,
    Object? totalSquadValue = null,
    Object? averageAge = null,
    Object? managerHistory = null,
    Object? seasonStats = null,
    Object? dataHash = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _$TeamModelImpl(
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        league: null == league
            ? _value.league
            : league // ignore: cast_nullable_to_non_nullable
                  as String,
        ids: freezed == ids
            ? _value.ids
            : ids // ignore: cast_nullable_to_non_nullable
                  as TeamIds?,
        manager: freezed == manager
            ? _value.manager
            : manager // ignore: cast_nullable_to_non_nullable
                  as ManagerInfo?,
        stadium: freezed == stadium
            ? _value.stadium
            : stadium // ignore: cast_nullable_to_non_nullable
                  as StadiumInfo?,
        squad: null == squad
            ? _value._squad
            : squad // ignore: cast_nullable_to_non_nullable
                  as List<SquadPlayer>,
        injuries: null == injuries
            ? _value._injuries
            : injuries // ignore: cast_nullable_to_non_nullable
                  as List<InjuryInfo>,
        suspended: null == suspended
            ? _value._suspended
            : suspended // ignore: cast_nullable_to_non_nullable
                  as List<SuspendedPlayer>,
        transferRumors: null == transferRumors
            ? _value._transferRumors
            : transferRumors // ignore: cast_nullable_to_non_nullable
                  as List<TransferRumor>,
        transfers: freezed == transfers
            ? _value.transfers
            : transfers // ignore: cast_nullable_to_non_nullable
                  as TeamTransfers?,
        news: null == news
            ? _value._news
            : news // ignore: cast_nullable_to_non_nullable
                  as List<TeamNewsItem>,
        recentForm: null == recentForm
            ? _value._recentForm
            : recentForm // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        totalSquadValue: null == totalSquadValue
            ? _value.totalSquadValue
            : totalSquadValue // ignore: cast_nullable_to_non_nullable
                  as int,
        averageAge: null == averageAge
            ? _value.averageAge
            : averageAge // ignore: cast_nullable_to_non_nullable
                  as double,
        managerHistory: null == managerHistory
            ? _value._managerHistory
            : managerHistory // ignore: cast_nullable_to_non_nullable
                  as List<ManagerHistoryEntry>,
        seasonStats: null == seasonStats
            ? _value._seasonStats
            : seasonStats // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
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
class _$TeamModelImpl implements _TeamModel {
  const _$TeamModelImpl({
    required this.slug,
    required this.name,
    this.league = '',
    this.ids,
    this.manager,
    this.stadium,
    final List<SquadPlayer> squad = const [],
    final List<InjuryInfo> injuries = const [],
    final List<SuspendedPlayer> suspended = const [],
    final List<TransferRumor> transferRumors = const [],
    this.transfers,
    final List<TeamNewsItem> news = const [],
    final List<String> recentForm = const [],
    this.totalSquadValue = 0,
    this.averageAge = 0.0,
    final List<ManagerHistoryEntry> managerHistory = const [],
    final Map<String, dynamic> seasonStats = const {},
    this.dataHash = '',
    this.lastUpdated,
  }) : _squad = squad,
       _injuries = injuries,
       _suspended = suspended,
       _transferRumors = transferRumors,
       _news = news,
       _recentForm = recentForm,
       _managerHistory = managerHistory,
       _seasonStats = seasonStats;

  factory _$TeamModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamModelImplFromJson(json);

  @override
  final String slug;
  @override
  final String name;
  @override
  @JsonKey()
  final String league;
  @override
  final TeamIds? ids;
  @override
  final ManagerInfo? manager;
  @override
  final StadiumInfo? stadium;
  final List<SquadPlayer> _squad;
  @override
  @JsonKey()
  List<SquadPlayer> get squad {
    if (_squad is EqualUnmodifiableListView) return _squad;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_squad);
  }

  final List<InjuryInfo> _injuries;
  @override
  @JsonKey()
  List<InjuryInfo> get injuries {
    if (_injuries is EqualUnmodifiableListView) return _injuries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_injuries);
  }

  final List<SuspendedPlayer> _suspended;
  @override
  @JsonKey()
  List<SuspendedPlayer> get suspended {
    if (_suspended is EqualUnmodifiableListView) return _suspended;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suspended);
  }

  final List<TransferRumor> _transferRumors;
  @override
  @JsonKey()
  List<TransferRumor> get transferRumors {
    if (_transferRumors is EqualUnmodifiableListView) return _transferRumors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transferRumors);
  }

  @override
  final TeamTransfers? transfers;
  final List<TeamNewsItem> _news;
  @override
  @JsonKey()
  List<TeamNewsItem> get news {
    if (_news is EqualUnmodifiableListView) return _news;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_news);
  }

  final List<String> _recentForm;
  @override
  @JsonKey()
  List<String> get recentForm {
    if (_recentForm is EqualUnmodifiableListView) return _recentForm;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentForm);
  }

  @override
  @JsonKey()
  final int totalSquadValue;
  @override
  @JsonKey()
  final double averageAge;
  final List<ManagerHistoryEntry> _managerHistory;
  @override
  @JsonKey()
  List<ManagerHistoryEntry> get managerHistory {
    if (_managerHistory is EqualUnmodifiableListView) return _managerHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_managerHistory);
  }

  final Map<String, dynamic> _seasonStats;
  @override
  @JsonKey()
  Map<String, dynamic> get seasonStats {
    if (_seasonStats is EqualUnmodifiableMapView) return _seasonStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_seasonStats);
  }

  @override
  @JsonKey()
  final String dataHash;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'TeamModel(slug: $slug, name: $name, league: $league, ids: $ids, manager: $manager, stadium: $stadium, squad: $squad, injuries: $injuries, suspended: $suspended, transferRumors: $transferRumors, transfers: $transfers, news: $news, recentForm: $recentForm, totalSquadValue: $totalSquadValue, averageAge: $averageAge, managerHistory: $managerHistory, seasonStats: $seasonStats, dataHash: $dataHash, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamModelImpl &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.ids, ids) || other.ids == ids) &&
            (identical(other.manager, manager) || other.manager == manager) &&
            (identical(other.stadium, stadium) || other.stadium == stadium) &&
            const DeepCollectionEquality().equals(other._squad, _squad) &&
            const DeepCollectionEquality().equals(other._injuries, _injuries) &&
            const DeepCollectionEquality().equals(
              other._suspended,
              _suspended,
            ) &&
            const DeepCollectionEquality().equals(
              other._transferRumors,
              _transferRumors,
            ) &&
            (identical(other.transfers, transfers) ||
                other.transfers == transfers) &&
            const DeepCollectionEquality().equals(other._news, _news) &&
            const DeepCollectionEquality().equals(
              other._recentForm,
              _recentForm,
            ) &&
            (identical(other.totalSquadValue, totalSquadValue) ||
                other.totalSquadValue == totalSquadValue) &&
            (identical(other.averageAge, averageAge) ||
                other.averageAge == averageAge) &&
            const DeepCollectionEquality().equals(
              other._managerHistory,
              _managerHistory,
            ) &&
            const DeepCollectionEquality().equals(
              other._seasonStats,
              _seasonStats,
            ) &&
            (identical(other.dataHash, dataHash) ||
                other.dataHash == dataHash) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    slug,
    name,
    league,
    ids,
    manager,
    stadium,
    const DeepCollectionEquality().hash(_squad),
    const DeepCollectionEquality().hash(_injuries),
    const DeepCollectionEquality().hash(_suspended),
    const DeepCollectionEquality().hash(_transferRumors),
    transfers,
    const DeepCollectionEquality().hash(_news),
    const DeepCollectionEquality().hash(_recentForm),
    totalSquadValue,
    averageAge,
    const DeepCollectionEquality().hash(_managerHistory),
    const DeepCollectionEquality().hash(_seasonStats),
    dataHash,
    lastUpdated,
  ]);

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamModelImplCopyWith<_$TeamModelImpl> get copyWith =>
      __$$TeamModelImplCopyWithImpl<_$TeamModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamModelImplToJson(this);
  }
}

abstract class _TeamModel implements TeamModel {
  const factory _TeamModel({
    required final String slug,
    required final String name,
    final String league,
    final TeamIds? ids,
    final ManagerInfo? manager,
    final StadiumInfo? stadium,
    final List<SquadPlayer> squad,
    final List<InjuryInfo> injuries,
    final List<SuspendedPlayer> suspended,
    final List<TransferRumor> transferRumors,
    final TeamTransfers? transfers,
    final List<TeamNewsItem> news,
    final List<String> recentForm,
    final int totalSquadValue,
    final double averageAge,
    final List<ManagerHistoryEntry> managerHistory,
    final Map<String, dynamic> seasonStats,
    final String dataHash,
    final DateTime? lastUpdated,
  }) = _$TeamModelImpl;

  factory _TeamModel.fromJson(Map<String, dynamic> json) =
      _$TeamModelImpl.fromJson;

  @override
  String get slug;
  @override
  String get name;
  @override
  String get league;
  @override
  TeamIds? get ids;
  @override
  ManagerInfo? get manager;
  @override
  StadiumInfo? get stadium;
  @override
  List<SquadPlayer> get squad;
  @override
  List<InjuryInfo> get injuries;
  @override
  List<SuspendedPlayer> get suspended;
  @override
  List<TransferRumor> get transferRumors;
  @override
  TeamTransfers? get transfers;
  @override
  List<TeamNewsItem> get news;
  @override
  List<String> get recentForm;
  @override
  int get totalSquadValue;
  @override
  double get averageAge;
  @override
  List<ManagerHistoryEntry> get managerHistory;
  @override
  Map<String, dynamic> get seasonStats;
  @override
  String get dataHash;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamModelImplCopyWith<_$TeamModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamIds _$TeamIdsFromJson(Map<String, dynamic> json) {
  return _TeamIds.fromJson(json);
}

/// @nodoc
mixin _$TeamIds {
  int get sofascore => throw _privateConstructorUsedError;
  String get transfermarkt => throw _privateConstructorUsedError;
  String get fbref => throw _privateConstructorUsedError;

  /// Serializes this TeamIds to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamIds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamIdsCopyWith<TeamIds> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamIdsCopyWith<$Res> {
  factory $TeamIdsCopyWith(TeamIds value, $Res Function(TeamIds) then) =
      _$TeamIdsCopyWithImpl<$Res, TeamIds>;
  @useResult
  $Res call({int sofascore, String transfermarkt, String fbref});
}

/// @nodoc
class _$TeamIdsCopyWithImpl<$Res, $Val extends TeamIds>
    implements $TeamIdsCopyWith<$Res> {
  _$TeamIdsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamIds
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
abstract class _$$TeamIdsImplCopyWith<$Res> implements $TeamIdsCopyWith<$Res> {
  factory _$$TeamIdsImplCopyWith(
    _$TeamIdsImpl value,
    $Res Function(_$TeamIdsImpl) then,
  ) = __$$TeamIdsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int sofascore, String transfermarkt, String fbref});
}

/// @nodoc
class __$$TeamIdsImplCopyWithImpl<$Res>
    extends _$TeamIdsCopyWithImpl<$Res, _$TeamIdsImpl>
    implements _$$TeamIdsImplCopyWith<$Res> {
  __$$TeamIdsImplCopyWithImpl(
    _$TeamIdsImpl _value,
    $Res Function(_$TeamIdsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamIds
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sofascore = null,
    Object? transfermarkt = null,
    Object? fbref = null,
  }) {
    return _then(
      _$TeamIdsImpl(
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
class _$TeamIdsImpl implements _TeamIds {
  const _$TeamIdsImpl({
    this.sofascore = 0,
    this.transfermarkt = '',
    this.fbref = '',
  });

  factory _$TeamIdsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamIdsImplFromJson(json);

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
    return 'TeamIds(sofascore: $sofascore, transfermarkt: $transfermarkt, fbref: $fbref)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamIdsImpl &&
            (identical(other.sofascore, sofascore) ||
                other.sofascore == sofascore) &&
            (identical(other.transfermarkt, transfermarkt) ||
                other.transfermarkt == transfermarkt) &&
            (identical(other.fbref, fbref) || other.fbref == fbref));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sofascore, transfermarkt, fbref);

  /// Create a copy of TeamIds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamIdsImplCopyWith<_$TeamIdsImpl> get copyWith =>
      __$$TeamIdsImplCopyWithImpl<_$TeamIdsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamIdsImplToJson(this);
  }
}

abstract class _TeamIds implements TeamIds {
  const factory _TeamIds({
    final int sofascore,
    final String transfermarkt,
    final String fbref,
  }) = _$TeamIdsImpl;

  factory _TeamIds.fromJson(Map<String, dynamic> json) = _$TeamIdsImpl.fromJson;

  @override
  int get sofascore;
  @override
  String get transfermarkt;
  @override
  String get fbref;

  /// Create a copy of TeamIds
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamIdsImplCopyWith<_$TeamIdsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ManagerInfo _$ManagerInfoFromJson(Map<String, dynamic> json) {
  return _ManagerInfo.fromJson(json);
}

/// @nodoc
mixin _$ManagerInfo {
  String get name => throw _privateConstructorUsedError;
  String get since => throw _privateConstructorUsedError;
  int get matches => throw _privateConstructorUsedError;
  double get winRate => throw _privateConstructorUsedError;
  String get nationality => throw _privateConstructorUsedError;
  List<String> get previousClubs => throw _privateConstructorUsedError;

  /// Serializes this ManagerInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerInfoCopyWith<ManagerInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerInfoCopyWith<$Res> {
  factory $ManagerInfoCopyWith(
    ManagerInfo value,
    $Res Function(ManagerInfo) then,
  ) = _$ManagerInfoCopyWithImpl<$Res, ManagerInfo>;
  @useResult
  $Res call({
    String name,
    String since,
    int matches,
    double winRate,
    String nationality,
    List<String> previousClubs,
  });
}

/// @nodoc
class _$ManagerInfoCopyWithImpl<$Res, $Val extends ManagerInfo>
    implements $ManagerInfoCopyWith<$Res> {
  _$ManagerInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? since = null,
    Object? matches = null,
    Object? winRate = null,
    Object? nationality = null,
    Object? previousClubs = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            since: null == since
                ? _value.since
                : since // ignore: cast_nullable_to_non_nullable
                      as String,
            matches: null == matches
                ? _value.matches
                : matches // ignore: cast_nullable_to_non_nullable
                      as int,
            winRate: null == winRate
                ? _value.winRate
                : winRate // ignore: cast_nullable_to_non_nullable
                      as double,
            nationality: null == nationality
                ? _value.nationality
                : nationality // ignore: cast_nullable_to_non_nullable
                      as String,
            previousClubs: null == previousClubs
                ? _value.previousClubs
                : previousClubs // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ManagerInfoImplCopyWith<$Res>
    implements $ManagerInfoCopyWith<$Res> {
  factory _$$ManagerInfoImplCopyWith(
    _$ManagerInfoImpl value,
    $Res Function(_$ManagerInfoImpl) then,
  ) = __$$ManagerInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String since,
    int matches,
    double winRate,
    String nationality,
    List<String> previousClubs,
  });
}

/// @nodoc
class __$$ManagerInfoImplCopyWithImpl<$Res>
    extends _$ManagerInfoCopyWithImpl<$Res, _$ManagerInfoImpl>
    implements _$$ManagerInfoImplCopyWith<$Res> {
  __$$ManagerInfoImplCopyWithImpl(
    _$ManagerInfoImpl _value,
    $Res Function(_$ManagerInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ManagerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? since = null,
    Object? matches = null,
    Object? winRate = null,
    Object? nationality = null,
    Object? previousClubs = null,
  }) {
    return _then(
      _$ManagerInfoImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        since: null == since
            ? _value.since
            : since // ignore: cast_nullable_to_non_nullable
                  as String,
        matches: null == matches
            ? _value.matches
            : matches // ignore: cast_nullable_to_non_nullable
                  as int,
        winRate: null == winRate
            ? _value.winRate
            : winRate // ignore: cast_nullable_to_non_nullable
                  as double,
        nationality: null == nationality
            ? _value.nationality
            : nationality // ignore: cast_nullable_to_non_nullable
                  as String,
        previousClubs: null == previousClubs
            ? _value._previousClubs
            : previousClubs // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerInfoImpl implements _ManagerInfo {
  const _$ManagerInfoImpl({
    this.name = '',
    this.since = '',
    this.matches = 0,
    this.winRate = 0.0,
    this.nationality = '',
    final List<String> previousClubs = const [],
  }) : _previousClubs = previousClubs;

  factory _$ManagerInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerInfoImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String since;
  @override
  @JsonKey()
  final int matches;
  @override
  @JsonKey()
  final double winRate;
  @override
  @JsonKey()
  final String nationality;
  final List<String> _previousClubs;
  @override
  @JsonKey()
  List<String> get previousClubs {
    if (_previousClubs is EqualUnmodifiableListView) return _previousClubs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_previousClubs);
  }

  @override
  String toString() {
    return 'ManagerInfo(name: $name, since: $since, matches: $matches, winRate: $winRate, nationality: $nationality, previousClubs: $previousClubs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerInfoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.since, since) || other.since == since) &&
            (identical(other.matches, matches) || other.matches == matches) &&
            (identical(other.winRate, winRate) || other.winRate == winRate) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            const DeepCollectionEquality().equals(
              other._previousClubs,
              _previousClubs,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    since,
    matches,
    winRate,
    nationality,
    const DeepCollectionEquality().hash(_previousClubs),
  );

  /// Create a copy of ManagerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerInfoImplCopyWith<_$ManagerInfoImpl> get copyWith =>
      __$$ManagerInfoImplCopyWithImpl<_$ManagerInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerInfoImplToJson(this);
  }
}

abstract class _ManagerInfo implements ManagerInfo {
  const factory _ManagerInfo({
    final String name,
    final String since,
    final int matches,
    final double winRate,
    final String nationality,
    final List<String> previousClubs,
  }) = _$ManagerInfoImpl;

  factory _ManagerInfo.fromJson(Map<String, dynamic> json) =
      _$ManagerInfoImpl.fromJson;

  @override
  String get name;
  @override
  String get since;
  @override
  int get matches;
  @override
  double get winRate;
  @override
  String get nationality;
  @override
  List<String> get previousClubs;

  /// Create a copy of ManagerInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerInfoImplCopyWith<_$ManagerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StadiumInfo _$StadiumInfoFromJson(Map<String, dynamic> json) {
  return _StadiumInfo.fromJson(json);
}

/// @nodoc
mixin _$StadiumInfo {
  String get name => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  int get builtYear => throw _privateConstructorUsedError;

  /// Serializes this StadiumInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StadiumInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StadiumInfoCopyWith<StadiumInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StadiumInfoCopyWith<$Res> {
  factory $StadiumInfoCopyWith(
    StadiumInfo value,
    $Res Function(StadiumInfo) then,
  ) = _$StadiumInfoCopyWithImpl<$Res, StadiumInfo>;
  @useResult
  $Res call({String name, int capacity, String city, int builtYear});
}

/// @nodoc
class _$StadiumInfoCopyWithImpl<$Res, $Val extends StadiumInfo>
    implements $StadiumInfoCopyWith<$Res> {
  _$StadiumInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StadiumInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? capacity = null,
    Object? city = null,
    Object? builtYear = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            builtYear: null == builtYear
                ? _value.builtYear
                : builtYear // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StadiumInfoImplCopyWith<$Res>
    implements $StadiumInfoCopyWith<$Res> {
  factory _$$StadiumInfoImplCopyWith(
    _$StadiumInfoImpl value,
    $Res Function(_$StadiumInfoImpl) then,
  ) = __$$StadiumInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int capacity, String city, int builtYear});
}

/// @nodoc
class __$$StadiumInfoImplCopyWithImpl<$Res>
    extends _$StadiumInfoCopyWithImpl<$Res, _$StadiumInfoImpl>
    implements _$$StadiumInfoImplCopyWith<$Res> {
  __$$StadiumInfoImplCopyWithImpl(
    _$StadiumInfoImpl _value,
    $Res Function(_$StadiumInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StadiumInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? capacity = null,
    Object? city = null,
    Object? builtYear = null,
  }) {
    return _then(
      _$StadiumInfoImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        builtYear: null == builtYear
            ? _value.builtYear
            : builtYear // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StadiumInfoImpl implements _StadiumInfo {
  const _$StadiumInfoImpl({
    this.name = '',
    this.capacity = 0,
    this.city = '',
    this.builtYear = 0,
  });

  factory _$StadiumInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StadiumInfoImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final int capacity;
  @override
  @JsonKey()
  final String city;
  @override
  @JsonKey()
  final int builtYear;

  @override
  String toString() {
    return 'StadiumInfo(name: $name, capacity: $capacity, city: $city, builtYear: $builtYear)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StadiumInfoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.builtYear, builtYear) ||
                other.builtYear == builtYear));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, capacity, city, builtYear);

  /// Create a copy of StadiumInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StadiumInfoImplCopyWith<_$StadiumInfoImpl> get copyWith =>
      __$$StadiumInfoImplCopyWithImpl<_$StadiumInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StadiumInfoImplToJson(this);
  }
}

abstract class _StadiumInfo implements StadiumInfo {
  const factory _StadiumInfo({
    final String name,
    final int capacity,
    final String city,
    final int builtYear,
  }) = _$StadiumInfoImpl;

  factory _StadiumInfo.fromJson(Map<String, dynamic> json) =
      _$StadiumInfoImpl.fromJson;

  @override
  String get name;
  @override
  int get capacity;
  @override
  String get city;
  @override
  int get builtYear;

  /// Create a copy of StadiumInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StadiumInfoImplCopyWith<_$StadiumInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SquadPlayer _$SquadPlayerFromJson(Map<String, dynamic> json) {
  return _SquadPlayer.fromJson(json);
}

/// @nodoc
mixin _$SquadPlayer {
  String get name => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  int get marketValue => throw _privateConstructorUsedError;
  String get contractUntil => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get nationality => throw _privateConstructorUsedError;
  int get sofascoreId => throw _privateConstructorUsedError;
  String get transfermarktId => throw _privateConstructorUsedError;
  double? get weeklyWage => throw _privateConstructorUsedError;

  /// Serializes this SquadPlayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SquadPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SquadPlayerCopyWith<SquadPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SquadPlayerCopyWith<$Res> {
  factory $SquadPlayerCopyWith(
    SquadPlayer value,
    $Res Function(SquadPlayer) then,
  ) = _$SquadPlayerCopyWithImpl<$Res, SquadPlayer>;
  @useResult
  $Res call({
    String name,
    String position,
    int number,
    int age,
    int marketValue,
    String contractUntil,
    String status,
    String nationality,
    int sofascoreId,
    String transfermarktId,
    double? weeklyWage,
  });
}

/// @nodoc
class _$SquadPlayerCopyWithImpl<$Res, $Val extends SquadPlayer>
    implements $SquadPlayerCopyWith<$Res> {
  _$SquadPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SquadPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? position = null,
    Object? number = null,
    Object? age = null,
    Object? marketValue = null,
    Object? contractUntil = null,
    Object? status = null,
    Object? nationality = null,
    Object? sofascoreId = null,
    Object? transfermarktId = null,
    Object? weeklyWage = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as String,
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as int,
            age: null == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int,
            marketValue: null == marketValue
                ? _value.marketValue
                : marketValue // ignore: cast_nullable_to_non_nullable
                      as int,
            contractUntil: null == contractUntil
                ? _value.contractUntil
                : contractUntil // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            nationality: null == nationality
                ? _value.nationality
                : nationality // ignore: cast_nullable_to_non_nullable
                      as String,
            sofascoreId: null == sofascoreId
                ? _value.sofascoreId
                : sofascoreId // ignore: cast_nullable_to_non_nullable
                      as int,
            transfermarktId: null == transfermarktId
                ? _value.transfermarktId
                : transfermarktId // ignore: cast_nullable_to_non_nullable
                      as String,
            weeklyWage: freezed == weeklyWage
                ? _value.weeklyWage
                : weeklyWage // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SquadPlayerImplCopyWith<$Res>
    implements $SquadPlayerCopyWith<$Res> {
  factory _$$SquadPlayerImplCopyWith(
    _$SquadPlayerImpl value,
    $Res Function(_$SquadPlayerImpl) then,
  ) = __$$SquadPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String position,
    int number,
    int age,
    int marketValue,
    String contractUntil,
    String status,
    String nationality,
    int sofascoreId,
    String transfermarktId,
    double? weeklyWage,
  });
}

/// @nodoc
class __$$SquadPlayerImplCopyWithImpl<$Res>
    extends _$SquadPlayerCopyWithImpl<$Res, _$SquadPlayerImpl>
    implements _$$SquadPlayerImplCopyWith<$Res> {
  __$$SquadPlayerImplCopyWithImpl(
    _$SquadPlayerImpl _value,
    $Res Function(_$SquadPlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SquadPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? position = null,
    Object? number = null,
    Object? age = null,
    Object? marketValue = null,
    Object? contractUntil = null,
    Object? status = null,
    Object? nationality = null,
    Object? sofascoreId = null,
    Object? transfermarktId = null,
    Object? weeklyWage = freezed,
  }) {
    return _then(
      _$SquadPlayerImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as String,
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as int,
        age: null == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int,
        marketValue: null == marketValue
            ? _value.marketValue
            : marketValue // ignore: cast_nullable_to_non_nullable
                  as int,
        contractUntil: null == contractUntil
            ? _value.contractUntil
            : contractUntil // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        nationality: null == nationality
            ? _value.nationality
            : nationality // ignore: cast_nullable_to_non_nullable
                  as String,
        sofascoreId: null == sofascoreId
            ? _value.sofascoreId
            : sofascoreId // ignore: cast_nullable_to_non_nullable
                  as int,
        transfermarktId: null == transfermarktId
            ? _value.transfermarktId
            : transfermarktId // ignore: cast_nullable_to_non_nullable
                  as String,
        weeklyWage: freezed == weeklyWage
            ? _value.weeklyWage
            : weeklyWage // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SquadPlayerImpl implements _SquadPlayer {
  const _$SquadPlayerImpl({
    required this.name,
    this.position = '',
    this.number = 0,
    this.age = 0,
    this.marketValue = 0,
    this.contractUntil = '',
    this.status = 'fit',
    this.nationality = '',
    this.sofascoreId = 0,
    this.transfermarktId = '',
    this.weeklyWage,
  });

  factory _$SquadPlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$SquadPlayerImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey()
  final String position;
  @override
  @JsonKey()
  final int number;
  @override
  @JsonKey()
  final int age;
  @override
  @JsonKey()
  final int marketValue;
  @override
  @JsonKey()
  final String contractUntil;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String nationality;
  @override
  @JsonKey()
  final int sofascoreId;
  @override
  @JsonKey()
  final String transfermarktId;
  @override
  final double? weeklyWage;

  @override
  String toString() {
    return 'SquadPlayer(name: $name, position: $position, number: $number, age: $age, marketValue: $marketValue, contractUntil: $contractUntil, status: $status, nationality: $nationality, sofascoreId: $sofascoreId, transfermarktId: $transfermarktId, weeklyWage: $weeklyWage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SquadPlayerImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.marketValue, marketValue) ||
                other.marketValue == marketValue) &&
            (identical(other.contractUntil, contractUntil) ||
                other.contractUntil == contractUntil) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.sofascoreId, sofascoreId) ||
                other.sofascoreId == sofascoreId) &&
            (identical(other.transfermarktId, transfermarktId) ||
                other.transfermarktId == transfermarktId) &&
            (identical(other.weeklyWage, weeklyWage) ||
                other.weeklyWage == weeklyWage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    position,
    number,
    age,
    marketValue,
    contractUntil,
    status,
    nationality,
    sofascoreId,
    transfermarktId,
    weeklyWage,
  );

  /// Create a copy of SquadPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SquadPlayerImplCopyWith<_$SquadPlayerImpl> get copyWith =>
      __$$SquadPlayerImplCopyWithImpl<_$SquadPlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SquadPlayerImplToJson(this);
  }
}

abstract class _SquadPlayer implements SquadPlayer {
  const factory _SquadPlayer({
    required final String name,
    final String position,
    final int number,
    final int age,
    final int marketValue,
    final String contractUntil,
    final String status,
    final String nationality,
    final int sofascoreId,
    final String transfermarktId,
    final double? weeklyWage,
  }) = _$SquadPlayerImpl;

  factory _SquadPlayer.fromJson(Map<String, dynamic> json) =
      _$SquadPlayerImpl.fromJson;

  @override
  String get name;
  @override
  String get position;
  @override
  int get number;
  @override
  int get age;
  @override
  int get marketValue;
  @override
  String get contractUntil;
  @override
  String get status;
  @override
  String get nationality;
  @override
  int get sofascoreId;
  @override
  String get transfermarktId;
  @override
  double? get weeklyWage;

  /// Create a copy of SquadPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SquadPlayerImplCopyWith<_$SquadPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InjuryInfo _$InjuryInfoFromJson(Map<String, dynamic> json) {
  return _InjuryInfo.fromJson(json);
}

/// @nodoc
mixin _$InjuryInfo {
  String get player => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get since => throw _privateConstructorUsedError;
  String get expectedReturn => throw _privateConstructorUsedError;
  int get gamesMissed => throw _privateConstructorUsedError;

  /// Serializes this InjuryInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InjuryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InjuryInfoCopyWith<InjuryInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InjuryInfoCopyWith<$Res> {
  factory $InjuryInfoCopyWith(
    InjuryInfo value,
    $Res Function(InjuryInfo) then,
  ) = _$InjuryInfoCopyWithImpl<$Res, InjuryInfo>;
  @useResult
  $Res call({
    String player,
    String type,
    String since,
    String expectedReturn,
    int gamesMissed,
  });
}

/// @nodoc
class _$InjuryInfoCopyWithImpl<$Res, $Val extends InjuryInfo>
    implements $InjuryInfoCopyWith<$Res> {
  _$InjuryInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InjuryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? type = null,
    Object? since = null,
    Object? expectedReturn = null,
    Object? gamesMissed = null,
  }) {
    return _then(
      _value.copyWith(
            player: null == player
                ? _value.player
                : player // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            since: null == since
                ? _value.since
                : since // ignore: cast_nullable_to_non_nullable
                      as String,
            expectedReturn: null == expectedReturn
                ? _value.expectedReturn
                : expectedReturn // ignore: cast_nullable_to_non_nullable
                      as String,
            gamesMissed: null == gamesMissed
                ? _value.gamesMissed
                : gamesMissed // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InjuryInfoImplCopyWith<$Res>
    implements $InjuryInfoCopyWith<$Res> {
  factory _$$InjuryInfoImplCopyWith(
    _$InjuryInfoImpl value,
    $Res Function(_$InjuryInfoImpl) then,
  ) = __$$InjuryInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String player,
    String type,
    String since,
    String expectedReturn,
    int gamesMissed,
  });
}

/// @nodoc
class __$$InjuryInfoImplCopyWithImpl<$Res>
    extends _$InjuryInfoCopyWithImpl<$Res, _$InjuryInfoImpl>
    implements _$$InjuryInfoImplCopyWith<$Res> {
  __$$InjuryInfoImplCopyWithImpl(
    _$InjuryInfoImpl _value,
    $Res Function(_$InjuryInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InjuryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? type = null,
    Object? since = null,
    Object? expectedReturn = null,
    Object? gamesMissed = null,
  }) {
    return _then(
      _$InjuryInfoImpl(
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        since: null == since
            ? _value.since
            : since // ignore: cast_nullable_to_non_nullable
                  as String,
        expectedReturn: null == expectedReturn
            ? _value.expectedReturn
            : expectedReturn // ignore: cast_nullable_to_non_nullable
                  as String,
        gamesMissed: null == gamesMissed
            ? _value.gamesMissed
            : gamesMissed // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InjuryInfoImpl implements _InjuryInfo {
  const _$InjuryInfoImpl({
    this.player = '',
    this.type = '',
    this.since = '',
    this.expectedReturn = '',
    this.gamesMissed = 0,
  });

  factory _$InjuryInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InjuryInfoImplFromJson(json);

  @override
  @JsonKey()
  final String player;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String since;
  @override
  @JsonKey()
  final String expectedReturn;
  @override
  @JsonKey()
  final int gamesMissed;

  @override
  String toString() {
    return 'InjuryInfo(player: $player, type: $type, since: $since, expectedReturn: $expectedReturn, gamesMissed: $gamesMissed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InjuryInfoImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.since, since) || other.since == since) &&
            (identical(other.expectedReturn, expectedReturn) ||
                other.expectedReturn == expectedReturn) &&
            (identical(other.gamesMissed, gamesMissed) ||
                other.gamesMissed == gamesMissed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    player,
    type,
    since,
    expectedReturn,
    gamesMissed,
  );

  /// Create a copy of InjuryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InjuryInfoImplCopyWith<_$InjuryInfoImpl> get copyWith =>
      __$$InjuryInfoImplCopyWithImpl<_$InjuryInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InjuryInfoImplToJson(this);
  }
}

abstract class _InjuryInfo implements InjuryInfo {
  const factory _InjuryInfo({
    final String player,
    final String type,
    final String since,
    final String expectedReturn,
    final int gamesMissed,
  }) = _$InjuryInfoImpl;

  factory _InjuryInfo.fromJson(Map<String, dynamic> json) =
      _$InjuryInfoImpl.fromJson;

  @override
  String get player;
  @override
  String get type;
  @override
  String get since;
  @override
  String get expectedReturn;
  @override
  int get gamesMissed;

  /// Create a copy of InjuryInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InjuryInfoImplCopyWith<_$InjuryInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuspendedPlayer _$SuspendedPlayerFromJson(Map<String, dynamic> json) {
  return _SuspendedPlayer.fromJson(json);
}

/// @nodoc
mixin _$SuspendedPlayer {
  String get player => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String get returnDate => throw _privateConstructorUsedError;

  /// Serializes this SuspendedPlayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuspendedPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuspendedPlayerCopyWith<SuspendedPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuspendedPlayerCopyWith<$Res> {
  factory $SuspendedPlayerCopyWith(
    SuspendedPlayer value,
    $Res Function(SuspendedPlayer) then,
  ) = _$SuspendedPlayerCopyWithImpl<$Res, SuspendedPlayer>;
  @useResult
  $Res call({String player, String reason, String returnDate});
}

/// @nodoc
class _$SuspendedPlayerCopyWithImpl<$Res, $Val extends SuspendedPlayer>
    implements $SuspendedPlayerCopyWith<$Res> {
  _$SuspendedPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuspendedPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? reason = null,
    Object? returnDate = null,
  }) {
    return _then(
      _value.copyWith(
            player: null == player
                ? _value.player
                : player // ignore: cast_nullable_to_non_nullable
                      as String,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            returnDate: null == returnDate
                ? _value.returnDate
                : returnDate // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SuspendedPlayerImplCopyWith<$Res>
    implements $SuspendedPlayerCopyWith<$Res> {
  factory _$$SuspendedPlayerImplCopyWith(
    _$SuspendedPlayerImpl value,
    $Res Function(_$SuspendedPlayerImpl) then,
  ) = __$$SuspendedPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String player, String reason, String returnDate});
}

/// @nodoc
class __$$SuspendedPlayerImplCopyWithImpl<$Res>
    extends _$SuspendedPlayerCopyWithImpl<$Res, _$SuspendedPlayerImpl>
    implements _$$SuspendedPlayerImplCopyWith<$Res> {
  __$$SuspendedPlayerImplCopyWithImpl(
    _$SuspendedPlayerImpl _value,
    $Res Function(_$SuspendedPlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SuspendedPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? reason = null,
    Object? returnDate = null,
  }) {
    return _then(
      _$SuspendedPlayerImpl(
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        returnDate: null == returnDate
            ? _value.returnDate
            : returnDate // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SuspendedPlayerImpl implements _SuspendedPlayer {
  const _$SuspendedPlayerImpl({
    this.player = '',
    this.reason = '',
    this.returnDate = '',
  });

  factory _$SuspendedPlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuspendedPlayerImplFromJson(json);

  @override
  @JsonKey()
  final String player;
  @override
  @JsonKey()
  final String reason;
  @override
  @JsonKey()
  final String returnDate;

  @override
  String toString() {
    return 'SuspendedPlayer(player: $player, reason: $reason, returnDate: $returnDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuspendedPlayerImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.returnDate, returnDate) ||
                other.returnDate == returnDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, player, reason, returnDate);

  /// Create a copy of SuspendedPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuspendedPlayerImplCopyWith<_$SuspendedPlayerImpl> get copyWith =>
      __$$SuspendedPlayerImplCopyWithImpl<_$SuspendedPlayerImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SuspendedPlayerImplToJson(this);
  }
}

abstract class _SuspendedPlayer implements SuspendedPlayer {
  const factory _SuspendedPlayer({
    final String player,
    final String reason,
    final String returnDate,
  }) = _$SuspendedPlayerImpl;

  factory _SuspendedPlayer.fromJson(Map<String, dynamic> json) =
      _$SuspendedPlayerImpl.fromJson;

  @override
  String get player;
  @override
  String get reason;
  @override
  String get returnDate;

  /// Create a copy of SuspendedPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuspendedPlayerImplCopyWith<_$SuspendedPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferRumor _$TransferRumorFromJson(Map<String, dynamic> json) {
  return _TransferRumor.fromJson(json);
}

/// @nodoc
mixin _$TransferRumor {
  String get player => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get reliability => throw _privateConstructorUsedError;

  /// Serializes this TransferRumor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferRumor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferRumorCopyWith<TransferRumor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferRumorCopyWith<$Res> {
  factory $TransferRumorCopyWith(
    TransferRumor value,
    $Res Function(TransferRumor) then,
  ) = _$TransferRumorCopyWithImpl<$Res, TransferRumor>;
  @useResult
  $Res call({
    String player,
    String type,
    String source,
    String date,
    String reliability,
  });
}

/// @nodoc
class _$TransferRumorCopyWithImpl<$Res, $Val extends TransferRumor>
    implements $TransferRumorCopyWith<$Res> {
  _$TransferRumorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferRumor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? type = null,
    Object? source = null,
    Object? date = null,
    Object? reliability = null,
  }) {
    return _then(
      _value.copyWith(
            player: null == player
                ? _value.player
                : player // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            reliability: null == reliability
                ? _value.reliability
                : reliability // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransferRumorImplCopyWith<$Res>
    implements $TransferRumorCopyWith<$Res> {
  factory _$$TransferRumorImplCopyWith(
    _$TransferRumorImpl value,
    $Res Function(_$TransferRumorImpl) then,
  ) = __$$TransferRumorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String player,
    String type,
    String source,
    String date,
    String reliability,
  });
}

/// @nodoc
class __$$TransferRumorImplCopyWithImpl<$Res>
    extends _$TransferRumorCopyWithImpl<$Res, _$TransferRumorImpl>
    implements _$$TransferRumorImplCopyWith<$Res> {
  __$$TransferRumorImplCopyWithImpl(
    _$TransferRumorImpl _value,
    $Res Function(_$TransferRumorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferRumor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? type = null,
    Object? source = null,
    Object? date = null,
    Object? reliability = null,
  }) {
    return _then(
      _$TransferRumorImpl(
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        reliability: null == reliability
            ? _value.reliability
            : reliability // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferRumorImpl implements _TransferRumor {
  const _$TransferRumorImpl({
    this.player = '',
    this.type = '',
    this.source = '',
    this.date = '',
    this.reliability = '',
  });

  factory _$TransferRumorImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferRumorImplFromJson(json);

  @override
  @JsonKey()
  final String player;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String source;
  @override
  @JsonKey()
  final String date;
  @override
  @JsonKey()
  final String reliability;

  @override
  String toString() {
    return 'TransferRumor(player: $player, type: $type, source: $source, date: $date, reliability: $reliability)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferRumorImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.reliability, reliability) ||
                other.reliability == reliability));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, player, type, source, date, reliability);

  /// Create a copy of TransferRumor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferRumorImplCopyWith<_$TransferRumorImpl> get copyWith =>
      __$$TransferRumorImplCopyWithImpl<_$TransferRumorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferRumorImplToJson(this);
  }
}

abstract class _TransferRumor implements TransferRumor {
  const factory _TransferRumor({
    final String player,
    final String type,
    final String source,
    final String date,
    final String reliability,
  }) = _$TransferRumorImpl;

  factory _TransferRumor.fromJson(Map<String, dynamic> json) =
      _$TransferRumorImpl.fromJson;

  @override
  String get player;
  @override
  String get type;
  @override
  String get source;
  @override
  String get date;
  @override
  String get reliability;

  /// Create a copy of TransferRumor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferRumorImplCopyWith<_$TransferRumorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamTransfers _$TeamTransfersFromJson(Map<String, dynamic> json) {
  return _TeamTransfers.fromJson(json);
}

/// @nodoc
mixin _$TeamTransfers {
  List<TransferEntry> get transferIn => throw _privateConstructorUsedError;
  List<TransferEntry> get transferOut => throw _privateConstructorUsedError;

  /// Serializes this TeamTransfers to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamTransfers
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamTransfersCopyWith<TeamTransfers> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamTransfersCopyWith<$Res> {
  factory $TeamTransfersCopyWith(
    TeamTransfers value,
    $Res Function(TeamTransfers) then,
  ) = _$TeamTransfersCopyWithImpl<$Res, TeamTransfers>;
  @useResult
  $Res call({List<TransferEntry> transferIn, List<TransferEntry> transferOut});
}

/// @nodoc
class _$TeamTransfersCopyWithImpl<$Res, $Val extends TeamTransfers>
    implements $TeamTransfersCopyWith<$Res> {
  _$TeamTransfersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamTransfers
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? transferIn = null, Object? transferOut = null}) {
    return _then(
      _value.copyWith(
            transferIn: null == transferIn
                ? _value.transferIn
                : transferIn // ignore: cast_nullable_to_non_nullable
                      as List<TransferEntry>,
            transferOut: null == transferOut
                ? _value.transferOut
                : transferOut // ignore: cast_nullable_to_non_nullable
                      as List<TransferEntry>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamTransfersImplCopyWith<$Res>
    implements $TeamTransfersCopyWith<$Res> {
  factory _$$TeamTransfersImplCopyWith(
    _$TeamTransfersImpl value,
    $Res Function(_$TeamTransfersImpl) then,
  ) = __$$TeamTransfersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TransferEntry> transferIn, List<TransferEntry> transferOut});
}

/// @nodoc
class __$$TeamTransfersImplCopyWithImpl<$Res>
    extends _$TeamTransfersCopyWithImpl<$Res, _$TeamTransfersImpl>
    implements _$$TeamTransfersImplCopyWith<$Res> {
  __$$TeamTransfersImplCopyWithImpl(
    _$TeamTransfersImpl _value,
    $Res Function(_$TeamTransfersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamTransfers
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? transferIn = null, Object? transferOut = null}) {
    return _then(
      _$TeamTransfersImpl(
        transferIn: null == transferIn
            ? _value._transferIn
            : transferIn // ignore: cast_nullable_to_non_nullable
                  as List<TransferEntry>,
        transferOut: null == transferOut
            ? _value._transferOut
            : transferOut // ignore: cast_nullable_to_non_nullable
                  as List<TransferEntry>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamTransfersImpl implements _TeamTransfers {
  const _$TeamTransfersImpl({
    final List<TransferEntry> transferIn = const [],
    final List<TransferEntry> transferOut = const [],
  }) : _transferIn = transferIn,
       _transferOut = transferOut;

  factory _$TeamTransfersImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamTransfersImplFromJson(json);

  final List<TransferEntry> _transferIn;
  @override
  @JsonKey()
  List<TransferEntry> get transferIn {
    if (_transferIn is EqualUnmodifiableListView) return _transferIn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transferIn);
  }

  final List<TransferEntry> _transferOut;
  @override
  @JsonKey()
  List<TransferEntry> get transferOut {
    if (_transferOut is EqualUnmodifiableListView) return _transferOut;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transferOut);
  }

  @override
  String toString() {
    return 'TeamTransfers(transferIn: $transferIn, transferOut: $transferOut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamTransfersImpl &&
            const DeepCollectionEquality().equals(
              other._transferIn,
              _transferIn,
            ) &&
            const DeepCollectionEquality().equals(
              other._transferOut,
              _transferOut,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_transferIn),
    const DeepCollectionEquality().hash(_transferOut),
  );

  /// Create a copy of TeamTransfers
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamTransfersImplCopyWith<_$TeamTransfersImpl> get copyWith =>
      __$$TeamTransfersImplCopyWithImpl<_$TeamTransfersImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamTransfersImplToJson(this);
  }
}

abstract class _TeamTransfers implements TeamTransfers {
  const factory _TeamTransfers({
    final List<TransferEntry> transferIn,
    final List<TransferEntry> transferOut,
  }) = _$TeamTransfersImpl;

  factory _TeamTransfers.fromJson(Map<String, dynamic> json) =
      _$TeamTransfersImpl.fromJson;

  @override
  List<TransferEntry> get transferIn;
  @override
  List<TransferEntry> get transferOut;

  /// Create a copy of TeamTransfers
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamTransfersImplCopyWith<_$TeamTransfersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferEntry _$TransferEntryFromJson(Map<String, dynamic> json) {
  return _TransferEntry.fromJson(json);
}

/// @nodoc
mixin _$TransferEntry {
  String get player => throw _privateConstructorUsedError;
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  int get fee => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;

  /// Serializes this TransferEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferEntryCopyWith<TransferEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferEntryCopyWith<$Res> {
  factory $TransferEntryCopyWith(
    TransferEntry value,
    $Res Function(TransferEntry) then,
  ) = _$TransferEntryCopyWithImpl<$Res, TransferEntry>;
  @useResult
  $Res call({String player, String from, String to, int fee, String date});
}

/// @nodoc
class _$TransferEntryCopyWithImpl<$Res, $Val extends TransferEntry>
    implements $TransferEntryCopyWith<$Res> {
  _$TransferEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? from = null,
    Object? to = null,
    Object? fee = null,
    Object? date = null,
  }) {
    return _then(
      _value.copyWith(
            player: null == player
                ? _value.player
                : player // ignore: cast_nullable_to_non_nullable
                      as String,
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as String,
            to: null == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as String,
            fee: null == fee
                ? _value.fee
                : fee // ignore: cast_nullable_to_non_nullable
                      as int,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransferEntryImplCopyWith<$Res>
    implements $TransferEntryCopyWith<$Res> {
  factory _$$TransferEntryImplCopyWith(
    _$TransferEntryImpl value,
    $Res Function(_$TransferEntryImpl) then,
  ) = __$$TransferEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String player, String from, String to, int fee, String date});
}

/// @nodoc
class __$$TransferEntryImplCopyWithImpl<$Res>
    extends _$TransferEntryCopyWithImpl<$Res, _$TransferEntryImpl>
    implements _$$TransferEntryImplCopyWith<$Res> {
  __$$TransferEntryImplCopyWithImpl(
    _$TransferEntryImpl _value,
    $Res Function(_$TransferEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? from = null,
    Object? to = null,
    Object? fee = null,
    Object? date = null,
  }) {
    return _then(
      _$TransferEntryImpl(
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as String,
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
        fee: null == fee
            ? _value.fee
            : fee // ignore: cast_nullable_to_non_nullable
                  as int,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferEntryImpl implements _TransferEntry {
  const _$TransferEntryImpl({
    this.player = '',
    this.from = '',
    this.to = '',
    this.fee = 0,
    this.date = '',
  });

  factory _$TransferEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferEntryImplFromJson(json);

  @override
  @JsonKey()
  final String player;
  @override
  @JsonKey()
  final String from;
  @override
  @JsonKey()
  final String to;
  @override
  @JsonKey()
  final int fee;
  @override
  @JsonKey()
  final String date;

  @override
  String toString() {
    return 'TransferEntry(player: $player, from: $from, to: $to, fee: $fee, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferEntryImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.fee, fee) || other.fee == fee) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, player, from, to, fee, date);

  /// Create a copy of TransferEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferEntryImplCopyWith<_$TransferEntryImpl> get copyWith =>
      __$$TransferEntryImplCopyWithImpl<_$TransferEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferEntryImplToJson(this);
  }
}

abstract class _TransferEntry implements TransferEntry {
  const factory _TransferEntry({
    final String player,
    final String from,
    final String to,
    final int fee,
    final String date,
  }) = _$TransferEntryImpl;

  factory _TransferEntry.fromJson(Map<String, dynamic> json) =
      _$TransferEntryImpl.fromJson;

  @override
  String get player;
  @override
  String get from;
  @override
  String get to;
  @override
  int get fee;
  @override
  String get date;

  /// Create a copy of TransferEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferEntryImplCopyWith<_$TransferEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamNewsItem _$TeamNewsItemFromJson(Map<String, dynamic> json) {
  return _TeamNewsItem.fromJson(json);
}

/// @nodoc
mixin _$TeamNewsItem {
  String get title => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  /// Serializes this TeamNewsItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamNewsItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamNewsItemCopyWith<TeamNewsItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamNewsItemCopyWith<$Res> {
  factory $TeamNewsItemCopyWith(
    TeamNewsItem value,
    $Res Function(TeamNewsItem) then,
  ) = _$TeamNewsItemCopyWithImpl<$Res, TeamNewsItem>;
  @useResult
  $Res call({
    String title,
    String date,
    String summary,
    String source,
    String url,
  });
}

/// @nodoc
class _$TeamNewsItemCopyWithImpl<$Res, $Val extends TeamNewsItem>
    implements $TeamNewsItemCopyWith<$Res> {
  _$TeamNewsItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamNewsItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? date = null,
    Object? summary = null,
    Object? source = null,
    Object? url = null,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamNewsItemImplCopyWith<$Res>
    implements $TeamNewsItemCopyWith<$Res> {
  factory _$$TeamNewsItemImplCopyWith(
    _$TeamNewsItemImpl value,
    $Res Function(_$TeamNewsItemImpl) then,
  ) = __$$TeamNewsItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String date,
    String summary,
    String source,
    String url,
  });
}

/// @nodoc
class __$$TeamNewsItemImplCopyWithImpl<$Res>
    extends _$TeamNewsItemCopyWithImpl<$Res, _$TeamNewsItemImpl>
    implements _$$TeamNewsItemImplCopyWith<$Res> {
  __$$TeamNewsItemImplCopyWithImpl(
    _$TeamNewsItemImpl _value,
    $Res Function(_$TeamNewsItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamNewsItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? date = null,
    Object? summary = null,
    Object? source = null,
    Object? url = null,
  }) {
    return _then(
      _$TeamNewsItemImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamNewsItemImpl implements _TeamNewsItem {
  const _$TeamNewsItemImpl({
    this.title = '',
    this.date = '',
    this.summary = '',
    this.source = '',
    this.url = '',
  });

  factory _$TeamNewsItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamNewsItemImplFromJson(json);

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String date;
  @override
  @JsonKey()
  final String summary;
  @override
  @JsonKey()
  final String source;
  @override
  @JsonKey()
  final String url;

  @override
  String toString() {
    return 'TeamNewsItem(title: $title, date: $date, summary: $summary, source: $source, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamNewsItemImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, date, summary, source, url);

  /// Create a copy of TeamNewsItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamNewsItemImplCopyWith<_$TeamNewsItemImpl> get copyWith =>
      __$$TeamNewsItemImplCopyWithImpl<_$TeamNewsItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamNewsItemImplToJson(this);
  }
}

abstract class _TeamNewsItem implements TeamNewsItem {
  const factory _TeamNewsItem({
    final String title,
    final String date,
    final String summary,
    final String source,
    final String url,
  }) = _$TeamNewsItemImpl;

  factory _TeamNewsItem.fromJson(Map<String, dynamic> json) =
      _$TeamNewsItemImpl.fromJson;

  @override
  String get title;
  @override
  String get date;
  @override
  String get summary;
  @override
  String get source;
  @override
  String get url;

  /// Create a copy of TeamNewsItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamNewsItemImplCopyWith<_$TeamNewsItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ManagerHistoryEntry _$ManagerHistoryEntryFromJson(Map<String, dynamic> json) {
  return _ManagerHistoryEntry.fromJson(json);
}

/// @nodoc
mixin _$ManagerHistoryEntry {
  String get name => throw _privateConstructorUsedError;
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  int get matches => throw _privateConstructorUsedError;
  double get winRate => throw _privateConstructorUsedError;

  /// Serializes this ManagerHistoryEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerHistoryEntryCopyWith<ManagerHistoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerHistoryEntryCopyWith<$Res> {
  factory $ManagerHistoryEntryCopyWith(
    ManagerHistoryEntry value,
    $Res Function(ManagerHistoryEntry) then,
  ) = _$ManagerHistoryEntryCopyWithImpl<$Res, ManagerHistoryEntry>;
  @useResult
  $Res call({String name, String from, String to, int matches, double winRate});
}

/// @nodoc
class _$ManagerHistoryEntryCopyWithImpl<$Res, $Val extends ManagerHistoryEntry>
    implements $ManagerHistoryEntryCopyWith<$Res> {
  _$ManagerHistoryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? from = null,
    Object? to = null,
    Object? matches = null,
    Object? winRate = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as String,
            to: null == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as String,
            matches: null == matches
                ? _value.matches
                : matches // ignore: cast_nullable_to_non_nullable
                      as int,
            winRate: null == winRate
                ? _value.winRate
                : winRate // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ManagerHistoryEntryImplCopyWith<$Res>
    implements $ManagerHistoryEntryCopyWith<$Res> {
  factory _$$ManagerHistoryEntryImplCopyWith(
    _$ManagerHistoryEntryImpl value,
    $Res Function(_$ManagerHistoryEntryImpl) then,
  ) = __$$ManagerHistoryEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String from, String to, int matches, double winRate});
}

/// @nodoc
class __$$ManagerHistoryEntryImplCopyWithImpl<$Res>
    extends _$ManagerHistoryEntryCopyWithImpl<$Res, _$ManagerHistoryEntryImpl>
    implements _$$ManagerHistoryEntryImplCopyWith<$Res> {
  __$$ManagerHistoryEntryImplCopyWithImpl(
    _$ManagerHistoryEntryImpl _value,
    $Res Function(_$ManagerHistoryEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ManagerHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? from = null,
    Object? to = null,
    Object? matches = null,
    Object? winRate = null,
  }) {
    return _then(
      _$ManagerHistoryEntryImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
        matches: null == matches
            ? _value.matches
            : matches // ignore: cast_nullable_to_non_nullable
                  as int,
        winRate: null == winRate
            ? _value.winRate
            : winRate // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerHistoryEntryImpl implements _ManagerHistoryEntry {
  const _$ManagerHistoryEntryImpl({
    this.name = '',
    this.from = '',
    this.to = '',
    this.matches = 0,
    this.winRate = 0.0,
  });

  factory _$ManagerHistoryEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerHistoryEntryImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String from;
  @override
  @JsonKey()
  final String to;
  @override
  @JsonKey()
  final int matches;
  @override
  @JsonKey()
  final double winRate;

  @override
  String toString() {
    return 'ManagerHistoryEntry(name: $name, from: $from, to: $to, matches: $matches, winRate: $winRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerHistoryEntryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.matches, matches) || other.matches == matches) &&
            (identical(other.winRate, winRate) || other.winRate == winRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, from, to, matches, winRate);

  /// Create a copy of ManagerHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerHistoryEntryImplCopyWith<_$ManagerHistoryEntryImpl> get copyWith =>
      __$$ManagerHistoryEntryImplCopyWithImpl<_$ManagerHistoryEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerHistoryEntryImplToJson(this);
  }
}

abstract class _ManagerHistoryEntry implements ManagerHistoryEntry {
  const factory _ManagerHistoryEntry({
    final String name,
    final String from,
    final String to,
    final int matches,
    final double winRate,
  }) = _$ManagerHistoryEntryImpl;

  factory _ManagerHistoryEntry.fromJson(Map<String, dynamic> json) =
      _$ManagerHistoryEntryImpl.fromJson;

  @override
  String get name;
  @override
  String get from;
  @override
  String get to;
  @override
  int get matches;
  @override
  double get winRate;

  /// Create a copy of ManagerHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerHistoryEntryImplCopyWith<_$ManagerHistoryEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
