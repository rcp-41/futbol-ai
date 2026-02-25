// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnalysisModel _$AnalysisModelFromJson(Map<String, dynamic> json) {
  return _AnalysisModel.fromJson(json);
}

/// @nodoc
mixin _$AnalysisModel {
  String get matchId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  PredictionModel? get prediction => throw _privateConstructorUsedError;
  AnalysisCategories? get categories => throw _privateConstructorUsedError;
  List<VetoRule> get vetoRules => throw _privateConstructorUsedError;
  WeightedTotal? get weightedTotal => throw _privateConstructorUsedError;
  DataIntelligence? get dataIntelligence => throw _privateConstructorUsedError;
  String get xgAnalysis => throw _privateConstructorUsedError;
  String get fixtureAnalysis => throw _privateConstructorUsedError;
  String get injuryReport => throw _privateConstructorUsedError;
  String get setPieceBreakdown => throw _privateConstructorUsedError;
  String get refereeImpact => throw _privateConstructorUsedError;
  String get detailedNarrative => throw _privateConstructorUsedError;
  String get rawGeminiResponse => throw _privateConstructorUsedError;
  String get modelUsed => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this AnalysisModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisModelCopyWith<AnalysisModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisModelCopyWith<$Res> {
  factory $AnalysisModelCopyWith(
    AnalysisModel value,
    $Res Function(AnalysisModel) then,
  ) = _$AnalysisModelCopyWithImpl<$Res, AnalysisModel>;
  @useResult
  $Res call({
    String matchId,
    String userId,
    String status,
    PredictionModel? prediction,
    AnalysisCategories? categories,
    List<VetoRule> vetoRules,
    WeightedTotal? weightedTotal,
    DataIntelligence? dataIntelligence,
    String xgAnalysis,
    String fixtureAnalysis,
    String injuryReport,
    String setPieceBreakdown,
    String refereeImpact,
    String detailedNarrative,
    String rawGeminiResponse,
    String modelUsed,
    DateTime? createdAt,
    DateTime? expiresAt,
  });

  $PredictionModelCopyWith<$Res>? get prediction;
  $AnalysisCategoriesCopyWith<$Res>? get categories;
  $WeightedTotalCopyWith<$Res>? get weightedTotal;
  $DataIntelligenceCopyWith<$Res>? get dataIntelligence;
}

/// @nodoc
class _$AnalysisModelCopyWithImpl<$Res, $Val extends AnalysisModel>
    implements $AnalysisModelCopyWith<$Res> {
  _$AnalysisModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? userId = null,
    Object? status = null,
    Object? prediction = freezed,
    Object? categories = freezed,
    Object? vetoRules = null,
    Object? weightedTotal = freezed,
    Object? dataIntelligence = freezed,
    Object? xgAnalysis = null,
    Object? fixtureAnalysis = null,
    Object? injuryReport = null,
    Object? setPieceBreakdown = null,
    Object? refereeImpact = null,
    Object? detailedNarrative = null,
    Object? rawGeminiResponse = null,
    Object? modelUsed = null,
    Object? createdAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            matchId: null == matchId
                ? _value.matchId
                : matchId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            prediction: freezed == prediction
                ? _value.prediction
                : prediction // ignore: cast_nullable_to_non_nullable
                      as PredictionModel?,
            categories: freezed == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as AnalysisCategories?,
            vetoRules: null == vetoRules
                ? _value.vetoRules
                : vetoRules // ignore: cast_nullable_to_non_nullable
                      as List<VetoRule>,
            weightedTotal: freezed == weightedTotal
                ? _value.weightedTotal
                : weightedTotal // ignore: cast_nullable_to_non_nullable
                      as WeightedTotal?,
            dataIntelligence: freezed == dataIntelligence
                ? _value.dataIntelligence
                : dataIntelligence // ignore: cast_nullable_to_non_nullable
                      as DataIntelligence?,
            xgAnalysis: null == xgAnalysis
                ? _value.xgAnalysis
                : xgAnalysis // ignore: cast_nullable_to_non_nullable
                      as String,
            fixtureAnalysis: null == fixtureAnalysis
                ? _value.fixtureAnalysis
                : fixtureAnalysis // ignore: cast_nullable_to_non_nullable
                      as String,
            injuryReport: null == injuryReport
                ? _value.injuryReport
                : injuryReport // ignore: cast_nullable_to_non_nullable
                      as String,
            setPieceBreakdown: null == setPieceBreakdown
                ? _value.setPieceBreakdown
                : setPieceBreakdown // ignore: cast_nullable_to_non_nullable
                      as String,
            refereeImpact: null == refereeImpact
                ? _value.refereeImpact
                : refereeImpact // ignore: cast_nullable_to_non_nullable
                      as String,
            detailedNarrative: null == detailedNarrative
                ? _value.detailedNarrative
                : detailedNarrative // ignore: cast_nullable_to_non_nullable
                      as String,
            rawGeminiResponse: null == rawGeminiResponse
                ? _value.rawGeminiResponse
                : rawGeminiResponse // ignore: cast_nullable_to_non_nullable
                      as String,
            modelUsed: null == modelUsed
                ? _value.modelUsed
                : modelUsed // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of AnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PredictionModelCopyWith<$Res>? get prediction {
    if (_value.prediction == null) {
      return null;
    }

    return $PredictionModelCopyWith<$Res>(_value.prediction!, (value) {
      return _then(_value.copyWith(prediction: value) as $Val);
    });
  }

  /// Create a copy of AnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisCategoriesCopyWith<$Res>? get categories {
    if (_value.categories == null) {
      return null;
    }

    return $AnalysisCategoriesCopyWith<$Res>(_value.categories!, (value) {
      return _then(_value.copyWith(categories: value) as $Val);
    });
  }

  /// Create a copy of AnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightedTotalCopyWith<$Res>? get weightedTotal {
    if (_value.weightedTotal == null) {
      return null;
    }

    return $WeightedTotalCopyWith<$Res>(_value.weightedTotal!, (value) {
      return _then(_value.copyWith(weightedTotal: value) as $Val);
    });
  }

  /// Create a copy of AnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DataIntelligenceCopyWith<$Res>? get dataIntelligence {
    if (_value.dataIntelligence == null) {
      return null;
    }

    return $DataIntelligenceCopyWith<$Res>(_value.dataIntelligence!, (value) {
      return _then(_value.copyWith(dataIntelligence: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalysisModelImplCopyWith<$Res>
    implements $AnalysisModelCopyWith<$Res> {
  factory _$$AnalysisModelImplCopyWith(
    _$AnalysisModelImpl value,
    $Res Function(_$AnalysisModelImpl) then,
  ) = __$$AnalysisModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String matchId,
    String userId,
    String status,
    PredictionModel? prediction,
    AnalysisCategories? categories,
    List<VetoRule> vetoRules,
    WeightedTotal? weightedTotal,
    DataIntelligence? dataIntelligence,
    String xgAnalysis,
    String fixtureAnalysis,
    String injuryReport,
    String setPieceBreakdown,
    String refereeImpact,
    String detailedNarrative,
    String rawGeminiResponse,
    String modelUsed,
    DateTime? createdAt,
    DateTime? expiresAt,
  });

  @override
  $PredictionModelCopyWith<$Res>? get prediction;
  @override
  $AnalysisCategoriesCopyWith<$Res>? get categories;
  @override
  $WeightedTotalCopyWith<$Res>? get weightedTotal;
  @override
  $DataIntelligenceCopyWith<$Res>? get dataIntelligence;
}

/// @nodoc
class __$$AnalysisModelImplCopyWithImpl<$Res>
    extends _$AnalysisModelCopyWithImpl<$Res, _$AnalysisModelImpl>
    implements _$$AnalysisModelImplCopyWith<$Res> {
  __$$AnalysisModelImplCopyWithImpl(
    _$AnalysisModelImpl _value,
    $Res Function(_$AnalysisModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? userId = null,
    Object? status = null,
    Object? prediction = freezed,
    Object? categories = freezed,
    Object? vetoRules = null,
    Object? weightedTotal = freezed,
    Object? dataIntelligence = freezed,
    Object? xgAnalysis = null,
    Object? fixtureAnalysis = null,
    Object? injuryReport = null,
    Object? setPieceBreakdown = null,
    Object? refereeImpact = null,
    Object? detailedNarrative = null,
    Object? rawGeminiResponse = null,
    Object? modelUsed = null,
    Object? createdAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _$AnalysisModelImpl(
        matchId: null == matchId
            ? _value.matchId
            : matchId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        prediction: freezed == prediction
            ? _value.prediction
            : prediction // ignore: cast_nullable_to_non_nullable
                  as PredictionModel?,
        categories: freezed == categories
            ? _value.categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as AnalysisCategories?,
        vetoRules: null == vetoRules
            ? _value._vetoRules
            : vetoRules // ignore: cast_nullable_to_non_nullable
                  as List<VetoRule>,
        weightedTotal: freezed == weightedTotal
            ? _value.weightedTotal
            : weightedTotal // ignore: cast_nullable_to_non_nullable
                  as WeightedTotal?,
        dataIntelligence: freezed == dataIntelligence
            ? _value.dataIntelligence
            : dataIntelligence // ignore: cast_nullable_to_non_nullable
                  as DataIntelligence?,
        xgAnalysis: null == xgAnalysis
            ? _value.xgAnalysis
            : xgAnalysis // ignore: cast_nullable_to_non_nullable
                  as String,
        fixtureAnalysis: null == fixtureAnalysis
            ? _value.fixtureAnalysis
            : fixtureAnalysis // ignore: cast_nullable_to_non_nullable
                  as String,
        injuryReport: null == injuryReport
            ? _value.injuryReport
            : injuryReport // ignore: cast_nullable_to_non_nullable
                  as String,
        setPieceBreakdown: null == setPieceBreakdown
            ? _value.setPieceBreakdown
            : setPieceBreakdown // ignore: cast_nullable_to_non_nullable
                  as String,
        refereeImpact: null == refereeImpact
            ? _value.refereeImpact
            : refereeImpact // ignore: cast_nullable_to_non_nullable
                  as String,
        detailedNarrative: null == detailedNarrative
            ? _value.detailedNarrative
            : detailedNarrative // ignore: cast_nullable_to_non_nullable
                  as String,
        rawGeminiResponse: null == rawGeminiResponse
            ? _value.rawGeminiResponse
            : rawGeminiResponse // ignore: cast_nullable_to_non_nullable
                  as String,
        modelUsed: null == modelUsed
            ? _value.modelUsed
            : modelUsed // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisModelImpl implements _AnalysisModel {
  const _$AnalysisModelImpl({
    required this.matchId,
    required this.userId,
    this.status = 'pending',
    this.prediction,
    this.categories,
    final List<VetoRule> vetoRules = const [],
    this.weightedTotal,
    this.dataIntelligence,
    this.xgAnalysis = '',
    this.fixtureAnalysis = '',
    this.injuryReport = '',
    this.setPieceBreakdown = '',
    this.refereeImpact = '',
    this.detailedNarrative = '',
    this.rawGeminiResponse = '',
    this.modelUsed = 'gemini-3.1-pro-preview',
    this.createdAt,
    this.expiresAt,
  }) : _vetoRules = vetoRules;

  factory _$AnalysisModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisModelImplFromJson(json);

  @override
  final String matchId;
  @override
  final String userId;
  @override
  @JsonKey()
  final String status;
  @override
  final PredictionModel? prediction;
  @override
  final AnalysisCategories? categories;
  final List<VetoRule> _vetoRules;
  @override
  @JsonKey()
  List<VetoRule> get vetoRules {
    if (_vetoRules is EqualUnmodifiableListView) return _vetoRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vetoRules);
  }

  @override
  final WeightedTotal? weightedTotal;
  @override
  final DataIntelligence? dataIntelligence;
  @override
  @JsonKey()
  final String xgAnalysis;
  @override
  @JsonKey()
  final String fixtureAnalysis;
  @override
  @JsonKey()
  final String injuryReport;
  @override
  @JsonKey()
  final String setPieceBreakdown;
  @override
  @JsonKey()
  final String refereeImpact;
  @override
  @JsonKey()
  final String detailedNarrative;
  @override
  @JsonKey()
  final String rawGeminiResponse;
  @override
  @JsonKey()
  final String modelUsed;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'AnalysisModel(matchId: $matchId, userId: $userId, status: $status, prediction: $prediction, categories: $categories, vetoRules: $vetoRules, weightedTotal: $weightedTotal, dataIntelligence: $dataIntelligence, xgAnalysis: $xgAnalysis, fixtureAnalysis: $fixtureAnalysis, injuryReport: $injuryReport, setPieceBreakdown: $setPieceBreakdown, refereeImpact: $refereeImpact, detailedNarrative: $detailedNarrative, rawGeminiResponse: $rawGeminiResponse, modelUsed: $modelUsed, createdAt: $createdAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisModelImpl &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.prediction, prediction) ||
                other.prediction == prediction) &&
            (identical(other.categories, categories) ||
                other.categories == categories) &&
            const DeepCollectionEquality().equals(
              other._vetoRules,
              _vetoRules,
            ) &&
            (identical(other.weightedTotal, weightedTotal) ||
                other.weightedTotal == weightedTotal) &&
            (identical(other.dataIntelligence, dataIntelligence) ||
                other.dataIntelligence == dataIntelligence) &&
            (identical(other.xgAnalysis, xgAnalysis) ||
                other.xgAnalysis == xgAnalysis) &&
            (identical(other.fixtureAnalysis, fixtureAnalysis) ||
                other.fixtureAnalysis == fixtureAnalysis) &&
            (identical(other.injuryReport, injuryReport) ||
                other.injuryReport == injuryReport) &&
            (identical(other.setPieceBreakdown, setPieceBreakdown) ||
                other.setPieceBreakdown == setPieceBreakdown) &&
            (identical(other.refereeImpact, refereeImpact) ||
                other.refereeImpact == refereeImpact) &&
            (identical(other.detailedNarrative, detailedNarrative) ||
                other.detailedNarrative == detailedNarrative) &&
            (identical(other.rawGeminiResponse, rawGeminiResponse) ||
                other.rawGeminiResponse == rawGeminiResponse) &&
            (identical(other.modelUsed, modelUsed) ||
                other.modelUsed == modelUsed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    matchId,
    userId,
    status,
    prediction,
    categories,
    const DeepCollectionEquality().hash(_vetoRules),
    weightedTotal,
    dataIntelligence,
    xgAnalysis,
    fixtureAnalysis,
    injuryReport,
    setPieceBreakdown,
    refereeImpact,
    detailedNarrative,
    rawGeminiResponse,
    modelUsed,
    createdAt,
    expiresAt,
  );

  /// Create a copy of AnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisModelImplCopyWith<_$AnalysisModelImpl> get copyWith =>
      __$$AnalysisModelImplCopyWithImpl<_$AnalysisModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisModelImplToJson(this);
  }
}

abstract class _AnalysisModel implements AnalysisModel {
  const factory _AnalysisModel({
    required final String matchId,
    required final String userId,
    final String status,
    final PredictionModel? prediction,
    final AnalysisCategories? categories,
    final List<VetoRule> vetoRules,
    final WeightedTotal? weightedTotal,
    final DataIntelligence? dataIntelligence,
    final String xgAnalysis,
    final String fixtureAnalysis,
    final String injuryReport,
    final String setPieceBreakdown,
    final String refereeImpact,
    final String detailedNarrative,
    final String rawGeminiResponse,
    final String modelUsed,
    final DateTime? createdAt,
    final DateTime? expiresAt,
  }) = _$AnalysisModelImpl;

  factory _AnalysisModel.fromJson(Map<String, dynamic> json) =
      _$AnalysisModelImpl.fromJson;

  @override
  String get matchId;
  @override
  String get userId;
  @override
  String get status;
  @override
  PredictionModel? get prediction;
  @override
  AnalysisCategories? get categories;
  @override
  List<VetoRule> get vetoRules;
  @override
  WeightedTotal? get weightedTotal;
  @override
  DataIntelligence? get dataIntelligence;
  @override
  String get xgAnalysis;
  @override
  String get fixtureAnalysis;
  @override
  String get injuryReport;
  @override
  String get setPieceBreakdown;
  @override
  String get refereeImpact;
  @override
  String get detailedNarrative;
  @override
  String get rawGeminiResponse;
  @override
  String get modelUsed;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get expiresAt;

  /// Create a copy of AnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisModelImplCopyWith<_$AnalysisModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PredictionModel _$PredictionModelFromJson(Map<String, dynamic> json) {
  return _PredictionModel.fromJson(json);
}

/// @nodoc
mixin _$PredictionModel {
  String get result => throw _privateConstructorUsedError;
  String get resultLabel => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  bool get surpriseAlert => throw _privateConstructorUsedError;
  String get bankoLevel => throw _privateConstructorUsedError;
  String get mainReason => throw _privateConstructorUsedError;

  /// Serializes this PredictionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PredictionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PredictionModelCopyWith<PredictionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictionModelCopyWith<$Res> {
  factory $PredictionModelCopyWith(
    PredictionModel value,
    $Res Function(PredictionModel) then,
  ) = _$PredictionModelCopyWithImpl<$Res, PredictionModel>;
  @useResult
  $Res call({
    String result,
    String resultLabel,
    double confidence,
    bool surpriseAlert,
    String bankoLevel,
    String mainReason,
  });
}

/// @nodoc
class _$PredictionModelCopyWithImpl<$Res, $Val extends PredictionModel>
    implements $PredictionModelCopyWith<$Res> {
  _$PredictionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PredictionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? resultLabel = null,
    Object? confidence = null,
    Object? surpriseAlert = null,
    Object? bankoLevel = null,
    Object? mainReason = null,
  }) {
    return _then(
      _value.copyWith(
            result: null == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as String,
            resultLabel: null == resultLabel
                ? _value.resultLabel
                : resultLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            surpriseAlert: null == surpriseAlert
                ? _value.surpriseAlert
                : surpriseAlert // ignore: cast_nullable_to_non_nullable
                      as bool,
            bankoLevel: null == bankoLevel
                ? _value.bankoLevel
                : bankoLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            mainReason: null == mainReason
                ? _value.mainReason
                : mainReason // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PredictionModelImplCopyWith<$Res>
    implements $PredictionModelCopyWith<$Res> {
  factory _$$PredictionModelImplCopyWith(
    _$PredictionModelImpl value,
    $Res Function(_$PredictionModelImpl) then,
  ) = __$$PredictionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String result,
    String resultLabel,
    double confidence,
    bool surpriseAlert,
    String bankoLevel,
    String mainReason,
  });
}

/// @nodoc
class __$$PredictionModelImplCopyWithImpl<$Res>
    extends _$PredictionModelCopyWithImpl<$Res, _$PredictionModelImpl>
    implements _$$PredictionModelImplCopyWith<$Res> {
  __$$PredictionModelImplCopyWithImpl(
    _$PredictionModelImpl _value,
    $Res Function(_$PredictionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PredictionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? resultLabel = null,
    Object? confidence = null,
    Object? surpriseAlert = null,
    Object? bankoLevel = null,
    Object? mainReason = null,
  }) {
    return _then(
      _$PredictionModelImpl(
        result: null == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                  as String,
        resultLabel: null == resultLabel
            ? _value.resultLabel
            : resultLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        surpriseAlert: null == surpriseAlert
            ? _value.surpriseAlert
            : surpriseAlert // ignore: cast_nullable_to_non_nullable
                  as bool,
        bankoLevel: null == bankoLevel
            ? _value.bankoLevel
            : bankoLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        mainReason: null == mainReason
            ? _value.mainReason
            : mainReason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PredictionModelImpl implements _PredictionModel {
  const _$PredictionModelImpl({
    this.result = '',
    this.resultLabel = '',
    this.confidence = 0.0,
    this.surpriseAlert = false,
    this.bankoLevel = '',
    this.mainReason = '',
  });

  factory _$PredictionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictionModelImplFromJson(json);

  @override
  @JsonKey()
  final String result;
  @override
  @JsonKey()
  final String resultLabel;
  @override
  @JsonKey()
  final double confidence;
  @override
  @JsonKey()
  final bool surpriseAlert;
  @override
  @JsonKey()
  final String bankoLevel;
  @override
  @JsonKey()
  final String mainReason;

  @override
  String toString() {
    return 'PredictionModel(result: $result, resultLabel: $resultLabel, confidence: $confidence, surpriseAlert: $surpriseAlert, bankoLevel: $bankoLevel, mainReason: $mainReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictionModelImpl &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.resultLabel, resultLabel) ||
                other.resultLabel == resultLabel) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.surpriseAlert, surpriseAlert) ||
                other.surpriseAlert == surpriseAlert) &&
            (identical(other.bankoLevel, bankoLevel) ||
                other.bankoLevel == bankoLevel) &&
            (identical(other.mainReason, mainReason) ||
                other.mainReason == mainReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    result,
    resultLabel,
    confidence,
    surpriseAlert,
    bankoLevel,
    mainReason,
  );

  /// Create a copy of PredictionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictionModelImplCopyWith<_$PredictionModelImpl> get copyWith =>
      __$$PredictionModelImplCopyWithImpl<_$PredictionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictionModelImplToJson(this);
  }
}

abstract class _PredictionModel implements PredictionModel {
  const factory _PredictionModel({
    final String result,
    final String resultLabel,
    final double confidence,
    final bool surpriseAlert,
    final String bankoLevel,
    final String mainReason,
  }) = _$PredictionModelImpl;

  factory _PredictionModel.fromJson(Map<String, dynamic> json) =
      _$PredictionModelImpl.fromJson;

  @override
  String get result;
  @override
  String get resultLabel;
  @override
  double get confidence;
  @override
  bool get surpriseAlert;
  @override
  String get bankoLevel;
  @override
  String get mainReason;

  /// Create a copy of PredictionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PredictionModelImplCopyWith<_$PredictionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryScore _$CategoryScoreFromJson(Map<String, dynamic> json) {
  return _CategoryScore.fromJson(json);
}

/// @nodoc
mixin _$CategoryScore {
  double get homeScore => throw _privateConstructorUsedError;
  double get awayScore => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  String get detail => throw _privateConstructorUsedError;

  /// Serializes this CategoryScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryScoreCopyWith<CategoryScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryScoreCopyWith<$Res> {
  factory $CategoryScoreCopyWith(
    CategoryScore value,
    $Res Function(CategoryScore) then,
  ) = _$CategoryScoreCopyWithImpl<$Res, CategoryScore>;
  @useResult
  $Res call({double homeScore, double awayScore, double weight, String detail});
}

/// @nodoc
class _$CategoryScoreCopyWithImpl<$Res, $Val extends CategoryScore>
    implements $CategoryScoreCopyWith<$Res> {
  _$CategoryScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? homeScore = null,
    Object? awayScore = null,
    Object? weight = null,
    Object? detail = null,
  }) {
    return _then(
      _value.copyWith(
            homeScore: null == homeScore
                ? _value.homeScore
                : homeScore // ignore: cast_nullable_to_non_nullable
                      as double,
            awayScore: null == awayScore
                ? _value.awayScore
                : awayScore // ignore: cast_nullable_to_non_nullable
                      as double,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            detail: null == detail
                ? _value.detail
                : detail // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryScoreImplCopyWith<$Res>
    implements $CategoryScoreCopyWith<$Res> {
  factory _$$CategoryScoreImplCopyWith(
    _$CategoryScoreImpl value,
    $Res Function(_$CategoryScoreImpl) then,
  ) = __$$CategoryScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double homeScore, double awayScore, double weight, String detail});
}

/// @nodoc
class __$$CategoryScoreImplCopyWithImpl<$Res>
    extends _$CategoryScoreCopyWithImpl<$Res, _$CategoryScoreImpl>
    implements _$$CategoryScoreImplCopyWith<$Res> {
  __$$CategoryScoreImplCopyWithImpl(
    _$CategoryScoreImpl _value,
    $Res Function(_$CategoryScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? homeScore = null,
    Object? awayScore = null,
    Object? weight = null,
    Object? detail = null,
  }) {
    return _then(
      _$CategoryScoreImpl(
        homeScore: null == homeScore
            ? _value.homeScore
            : homeScore // ignore: cast_nullable_to_non_nullable
                  as double,
        awayScore: null == awayScore
            ? _value.awayScore
            : awayScore // ignore: cast_nullable_to_non_nullable
                  as double,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        detail: null == detail
            ? _value.detail
            : detail // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryScoreImpl implements _CategoryScore {
  const _$CategoryScoreImpl({
    this.homeScore = 0.0,
    this.awayScore = 0.0,
    this.weight = 0.0,
    this.detail = '',
  });

  factory _$CategoryScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryScoreImplFromJson(json);

  @override
  @JsonKey()
  final double homeScore;
  @override
  @JsonKey()
  final double awayScore;
  @override
  @JsonKey()
  final double weight;
  @override
  @JsonKey()
  final String detail;

  @override
  String toString() {
    return 'CategoryScore(homeScore: $homeScore, awayScore: $awayScore, weight: $weight, detail: $detail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryScoreImpl &&
            (identical(other.homeScore, homeScore) ||
                other.homeScore == homeScore) &&
            (identical(other.awayScore, awayScore) ||
                other.awayScore == awayScore) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, homeScore, awayScore, weight, detail);

  /// Create a copy of CategoryScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryScoreImplCopyWith<_$CategoryScoreImpl> get copyWith =>
      __$$CategoryScoreImplCopyWithImpl<_$CategoryScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryScoreImplToJson(this);
  }
}

abstract class _CategoryScore implements CategoryScore {
  const factory _CategoryScore({
    final double homeScore,
    final double awayScore,
    final double weight,
    final String detail,
  }) = _$CategoryScoreImpl;

  factory _CategoryScore.fromJson(Map<String, dynamic> json) =
      _$CategoryScoreImpl.fromJson;

  @override
  double get homeScore;
  @override
  double get awayScore;
  @override
  double get weight;
  @override
  String get detail;

  /// Create a copy of CategoryScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryScoreImplCopyWith<_$CategoryScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalysisCategories _$AnalysisCategoriesFromJson(Map<String, dynamic> json) {
  return _AnalysisCategories.fromJson(json);
}

/// @nodoc
mixin _$AnalysisCategories {
  CategoryScore? get power => throw _privateConstructorUsedError;
  CategoryScore? get tactics => throw _privateConstructorUsedError;
  CategoryScore? get psychology => throw _privateConstructorUsedError;
  CategoryScore? get externalFactors => throw _privateConstructorUsedError;
  CategoryScore? get market => throw _privateConstructorUsedError;
  CategoryScore? get referee => throw _privateConstructorUsedError;
  CategoryScore? get setPieces => throw _privateConstructorUsedError;
  CategoryScore? get physical => throw _privateConstructorUsedError;

  /// Serializes this AnalysisCategories to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisCategoriesCopyWith<AnalysisCategories> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisCategoriesCopyWith<$Res> {
  factory $AnalysisCategoriesCopyWith(
    AnalysisCategories value,
    $Res Function(AnalysisCategories) then,
  ) = _$AnalysisCategoriesCopyWithImpl<$Res, AnalysisCategories>;
  @useResult
  $Res call({
    CategoryScore? power,
    CategoryScore? tactics,
    CategoryScore? psychology,
    CategoryScore? externalFactors,
    CategoryScore? market,
    CategoryScore? referee,
    CategoryScore? setPieces,
    CategoryScore? physical,
  });

  $CategoryScoreCopyWith<$Res>? get power;
  $CategoryScoreCopyWith<$Res>? get tactics;
  $CategoryScoreCopyWith<$Res>? get psychology;
  $CategoryScoreCopyWith<$Res>? get externalFactors;
  $CategoryScoreCopyWith<$Res>? get market;
  $CategoryScoreCopyWith<$Res>? get referee;
  $CategoryScoreCopyWith<$Res>? get setPieces;
  $CategoryScoreCopyWith<$Res>? get physical;
}

/// @nodoc
class _$AnalysisCategoriesCopyWithImpl<$Res, $Val extends AnalysisCategories>
    implements $AnalysisCategoriesCopyWith<$Res> {
  _$AnalysisCategoriesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? power = freezed,
    Object? tactics = freezed,
    Object? psychology = freezed,
    Object? externalFactors = freezed,
    Object? market = freezed,
    Object? referee = freezed,
    Object? setPieces = freezed,
    Object? physical = freezed,
  }) {
    return _then(
      _value.copyWith(
            power: freezed == power
                ? _value.power
                : power // ignore: cast_nullable_to_non_nullable
                      as CategoryScore?,
            tactics: freezed == tactics
                ? _value.tactics
                : tactics // ignore: cast_nullable_to_non_nullable
                      as CategoryScore?,
            psychology: freezed == psychology
                ? _value.psychology
                : psychology // ignore: cast_nullable_to_non_nullable
                      as CategoryScore?,
            externalFactors: freezed == externalFactors
                ? _value.externalFactors
                : externalFactors // ignore: cast_nullable_to_non_nullable
                      as CategoryScore?,
            market: freezed == market
                ? _value.market
                : market // ignore: cast_nullable_to_non_nullable
                      as CategoryScore?,
            referee: freezed == referee
                ? _value.referee
                : referee // ignore: cast_nullable_to_non_nullable
                      as CategoryScore?,
            setPieces: freezed == setPieces
                ? _value.setPieces
                : setPieces // ignore: cast_nullable_to_non_nullable
                      as CategoryScore?,
            physical: freezed == physical
                ? _value.physical
                : physical // ignore: cast_nullable_to_non_nullable
                      as CategoryScore?,
          )
          as $Val,
    );
  }

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryScoreCopyWith<$Res>? get power {
    if (_value.power == null) {
      return null;
    }

    return $CategoryScoreCopyWith<$Res>(_value.power!, (value) {
      return _then(_value.copyWith(power: value) as $Val);
    });
  }

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryScoreCopyWith<$Res>? get tactics {
    if (_value.tactics == null) {
      return null;
    }

    return $CategoryScoreCopyWith<$Res>(_value.tactics!, (value) {
      return _then(_value.copyWith(tactics: value) as $Val);
    });
  }

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryScoreCopyWith<$Res>? get psychology {
    if (_value.psychology == null) {
      return null;
    }

    return $CategoryScoreCopyWith<$Res>(_value.psychology!, (value) {
      return _then(_value.copyWith(psychology: value) as $Val);
    });
  }

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryScoreCopyWith<$Res>? get externalFactors {
    if (_value.externalFactors == null) {
      return null;
    }

    return $CategoryScoreCopyWith<$Res>(_value.externalFactors!, (value) {
      return _then(_value.copyWith(externalFactors: value) as $Val);
    });
  }

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryScoreCopyWith<$Res>? get market {
    if (_value.market == null) {
      return null;
    }

    return $CategoryScoreCopyWith<$Res>(_value.market!, (value) {
      return _then(_value.copyWith(market: value) as $Val);
    });
  }

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryScoreCopyWith<$Res>? get referee {
    if (_value.referee == null) {
      return null;
    }

    return $CategoryScoreCopyWith<$Res>(_value.referee!, (value) {
      return _then(_value.copyWith(referee: value) as $Val);
    });
  }

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryScoreCopyWith<$Res>? get setPieces {
    if (_value.setPieces == null) {
      return null;
    }

    return $CategoryScoreCopyWith<$Res>(_value.setPieces!, (value) {
      return _then(_value.copyWith(setPieces: value) as $Val);
    });
  }

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryScoreCopyWith<$Res>? get physical {
    if (_value.physical == null) {
      return null;
    }

    return $CategoryScoreCopyWith<$Res>(_value.physical!, (value) {
      return _then(_value.copyWith(physical: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalysisCategoriesImplCopyWith<$Res>
    implements $AnalysisCategoriesCopyWith<$Res> {
  factory _$$AnalysisCategoriesImplCopyWith(
    _$AnalysisCategoriesImpl value,
    $Res Function(_$AnalysisCategoriesImpl) then,
  ) = __$$AnalysisCategoriesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CategoryScore? power,
    CategoryScore? tactics,
    CategoryScore? psychology,
    CategoryScore? externalFactors,
    CategoryScore? market,
    CategoryScore? referee,
    CategoryScore? setPieces,
    CategoryScore? physical,
  });

  @override
  $CategoryScoreCopyWith<$Res>? get power;
  @override
  $CategoryScoreCopyWith<$Res>? get tactics;
  @override
  $CategoryScoreCopyWith<$Res>? get psychology;
  @override
  $CategoryScoreCopyWith<$Res>? get externalFactors;
  @override
  $CategoryScoreCopyWith<$Res>? get market;
  @override
  $CategoryScoreCopyWith<$Res>? get referee;
  @override
  $CategoryScoreCopyWith<$Res>? get setPieces;
  @override
  $CategoryScoreCopyWith<$Res>? get physical;
}

/// @nodoc
class __$$AnalysisCategoriesImplCopyWithImpl<$Res>
    extends _$AnalysisCategoriesCopyWithImpl<$Res, _$AnalysisCategoriesImpl>
    implements _$$AnalysisCategoriesImplCopyWith<$Res> {
  __$$AnalysisCategoriesImplCopyWithImpl(
    _$AnalysisCategoriesImpl _value,
    $Res Function(_$AnalysisCategoriesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? power = freezed,
    Object? tactics = freezed,
    Object? psychology = freezed,
    Object? externalFactors = freezed,
    Object? market = freezed,
    Object? referee = freezed,
    Object? setPieces = freezed,
    Object? physical = freezed,
  }) {
    return _then(
      _$AnalysisCategoriesImpl(
        power: freezed == power
            ? _value.power
            : power // ignore: cast_nullable_to_non_nullable
                  as CategoryScore?,
        tactics: freezed == tactics
            ? _value.tactics
            : tactics // ignore: cast_nullable_to_non_nullable
                  as CategoryScore?,
        psychology: freezed == psychology
            ? _value.psychology
            : psychology // ignore: cast_nullable_to_non_nullable
                  as CategoryScore?,
        externalFactors: freezed == externalFactors
            ? _value.externalFactors
            : externalFactors // ignore: cast_nullable_to_non_nullable
                  as CategoryScore?,
        market: freezed == market
            ? _value.market
            : market // ignore: cast_nullable_to_non_nullable
                  as CategoryScore?,
        referee: freezed == referee
            ? _value.referee
            : referee // ignore: cast_nullable_to_non_nullable
                  as CategoryScore?,
        setPieces: freezed == setPieces
            ? _value.setPieces
            : setPieces // ignore: cast_nullable_to_non_nullable
                  as CategoryScore?,
        physical: freezed == physical
            ? _value.physical
            : physical // ignore: cast_nullable_to_non_nullable
                  as CategoryScore?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisCategoriesImpl implements _AnalysisCategories {
  const _$AnalysisCategoriesImpl({
    this.power,
    this.tactics,
    this.psychology,
    this.externalFactors,
    this.market,
    this.referee,
    this.setPieces,
    this.physical,
  });

  factory _$AnalysisCategoriesImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisCategoriesImplFromJson(json);

  @override
  final CategoryScore? power;
  @override
  final CategoryScore? tactics;
  @override
  final CategoryScore? psychology;
  @override
  final CategoryScore? externalFactors;
  @override
  final CategoryScore? market;
  @override
  final CategoryScore? referee;
  @override
  final CategoryScore? setPieces;
  @override
  final CategoryScore? physical;

  @override
  String toString() {
    return 'AnalysisCategories(power: $power, tactics: $tactics, psychology: $psychology, externalFactors: $externalFactors, market: $market, referee: $referee, setPieces: $setPieces, physical: $physical)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisCategoriesImpl &&
            (identical(other.power, power) || other.power == power) &&
            (identical(other.tactics, tactics) || other.tactics == tactics) &&
            (identical(other.psychology, psychology) ||
                other.psychology == psychology) &&
            (identical(other.externalFactors, externalFactors) ||
                other.externalFactors == externalFactors) &&
            (identical(other.market, market) || other.market == market) &&
            (identical(other.referee, referee) || other.referee == referee) &&
            (identical(other.setPieces, setPieces) ||
                other.setPieces == setPieces) &&
            (identical(other.physical, physical) ||
                other.physical == physical));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    power,
    tactics,
    psychology,
    externalFactors,
    market,
    referee,
    setPieces,
    physical,
  );

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisCategoriesImplCopyWith<_$AnalysisCategoriesImpl> get copyWith =>
      __$$AnalysisCategoriesImplCopyWithImpl<_$AnalysisCategoriesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisCategoriesImplToJson(this);
  }
}

abstract class _AnalysisCategories implements AnalysisCategories {
  const factory _AnalysisCategories({
    final CategoryScore? power,
    final CategoryScore? tactics,
    final CategoryScore? psychology,
    final CategoryScore? externalFactors,
    final CategoryScore? market,
    final CategoryScore? referee,
    final CategoryScore? setPieces,
    final CategoryScore? physical,
  }) = _$AnalysisCategoriesImpl;

  factory _AnalysisCategories.fromJson(Map<String, dynamic> json) =
      _$AnalysisCategoriesImpl.fromJson;

  @override
  CategoryScore? get power;
  @override
  CategoryScore? get tactics;
  @override
  CategoryScore? get psychology;
  @override
  CategoryScore? get externalFactors;
  @override
  CategoryScore? get market;
  @override
  CategoryScore? get referee;
  @override
  CategoryScore? get setPieces;
  @override
  CategoryScore? get physical;

  /// Create a copy of AnalysisCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisCategoriesImplCopyWith<_$AnalysisCategoriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VetoRule _$VetoRuleFromJson(Map<String, dynamic> json) {
  return _VetoRule.fromJson(json);
}

/// @nodoc
mixin _$VetoRule {
  String get rule => throw _privateConstructorUsedError;
  String get affectedTeam => throw _privateConstructorUsedError;
  String get penalty => throw _privateConstructorUsedError;
  String get affectedCategory => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;

  /// Serializes this VetoRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VetoRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VetoRuleCopyWith<VetoRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VetoRuleCopyWith<$Res> {
  factory $VetoRuleCopyWith(VetoRule value, $Res Function(VetoRule) then) =
      _$VetoRuleCopyWithImpl<$Res, VetoRule>;
  @useResult
  $Res call({
    String rule,
    String affectedTeam,
    String penalty,
    String affectedCategory,
    String reason,
  });
}

/// @nodoc
class _$VetoRuleCopyWithImpl<$Res, $Val extends VetoRule>
    implements $VetoRuleCopyWith<$Res> {
  _$VetoRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VetoRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rule = null,
    Object? affectedTeam = null,
    Object? penalty = null,
    Object? affectedCategory = null,
    Object? reason = null,
  }) {
    return _then(
      _value.copyWith(
            rule: null == rule
                ? _value.rule
                : rule // ignore: cast_nullable_to_non_nullable
                      as String,
            affectedTeam: null == affectedTeam
                ? _value.affectedTeam
                : affectedTeam // ignore: cast_nullable_to_non_nullable
                      as String,
            penalty: null == penalty
                ? _value.penalty
                : penalty // ignore: cast_nullable_to_non_nullable
                      as String,
            affectedCategory: null == affectedCategory
                ? _value.affectedCategory
                : affectedCategory // ignore: cast_nullable_to_non_nullable
                      as String,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VetoRuleImplCopyWith<$Res>
    implements $VetoRuleCopyWith<$Res> {
  factory _$$VetoRuleImplCopyWith(
    _$VetoRuleImpl value,
    $Res Function(_$VetoRuleImpl) then,
  ) = __$$VetoRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String rule,
    String affectedTeam,
    String penalty,
    String affectedCategory,
    String reason,
  });
}

/// @nodoc
class __$$VetoRuleImplCopyWithImpl<$Res>
    extends _$VetoRuleCopyWithImpl<$Res, _$VetoRuleImpl>
    implements _$$VetoRuleImplCopyWith<$Res> {
  __$$VetoRuleImplCopyWithImpl(
    _$VetoRuleImpl _value,
    $Res Function(_$VetoRuleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VetoRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rule = null,
    Object? affectedTeam = null,
    Object? penalty = null,
    Object? affectedCategory = null,
    Object? reason = null,
  }) {
    return _then(
      _$VetoRuleImpl(
        rule: null == rule
            ? _value.rule
            : rule // ignore: cast_nullable_to_non_nullable
                  as String,
        affectedTeam: null == affectedTeam
            ? _value.affectedTeam
            : affectedTeam // ignore: cast_nullable_to_non_nullable
                  as String,
        penalty: null == penalty
            ? _value.penalty
            : penalty // ignore: cast_nullable_to_non_nullable
                  as String,
        affectedCategory: null == affectedCategory
            ? _value.affectedCategory
            : affectedCategory // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VetoRuleImpl implements _VetoRule {
  const _$VetoRuleImpl({
    this.rule = '',
    this.affectedTeam = '',
    this.penalty = '',
    this.affectedCategory = '',
    this.reason = '',
  });

  factory _$VetoRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$VetoRuleImplFromJson(json);

  @override
  @JsonKey()
  final String rule;
  @override
  @JsonKey()
  final String affectedTeam;
  @override
  @JsonKey()
  final String penalty;
  @override
  @JsonKey()
  final String affectedCategory;
  @override
  @JsonKey()
  final String reason;

  @override
  String toString() {
    return 'VetoRule(rule: $rule, affectedTeam: $affectedTeam, penalty: $penalty, affectedCategory: $affectedCategory, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VetoRuleImpl &&
            (identical(other.rule, rule) || other.rule == rule) &&
            (identical(other.affectedTeam, affectedTeam) ||
                other.affectedTeam == affectedTeam) &&
            (identical(other.penalty, penalty) || other.penalty == penalty) &&
            (identical(other.affectedCategory, affectedCategory) ||
                other.affectedCategory == affectedCategory) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rule,
    affectedTeam,
    penalty,
    affectedCategory,
    reason,
  );

  /// Create a copy of VetoRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VetoRuleImplCopyWith<_$VetoRuleImpl> get copyWith =>
      __$$VetoRuleImplCopyWithImpl<_$VetoRuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VetoRuleImplToJson(this);
  }
}

abstract class _VetoRule implements VetoRule {
  const factory _VetoRule({
    final String rule,
    final String affectedTeam,
    final String penalty,
    final String affectedCategory,
    final String reason,
  }) = _$VetoRuleImpl;

  factory _VetoRule.fromJson(Map<String, dynamic> json) =
      _$VetoRuleImpl.fromJson;

  @override
  String get rule;
  @override
  String get affectedTeam;
  @override
  String get penalty;
  @override
  String get affectedCategory;
  @override
  String get reason;

  /// Create a copy of VetoRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VetoRuleImplCopyWith<_$VetoRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeightedTotal _$WeightedTotalFromJson(Map<String, dynamic> json) {
  return _WeightedTotal.fromJson(json);
}

/// @nodoc
mixin _$WeightedTotal {
  double get home => throw _privateConstructorUsedError;
  double get away => throw _privateConstructorUsedError;

  /// Serializes this WeightedTotal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeightedTotal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeightedTotalCopyWith<WeightedTotal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightedTotalCopyWith<$Res> {
  factory $WeightedTotalCopyWith(
    WeightedTotal value,
    $Res Function(WeightedTotal) then,
  ) = _$WeightedTotalCopyWithImpl<$Res, WeightedTotal>;
  @useResult
  $Res call({double home, double away});
}

/// @nodoc
class _$WeightedTotalCopyWithImpl<$Res, $Val extends WeightedTotal>
    implements $WeightedTotalCopyWith<$Res> {
  _$WeightedTotalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeightedTotal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? home = null, Object? away = null}) {
    return _then(
      _value.copyWith(
            home: null == home
                ? _value.home
                : home // ignore: cast_nullable_to_non_nullable
                      as double,
            away: null == away
                ? _value.away
                : away // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeightedTotalImplCopyWith<$Res>
    implements $WeightedTotalCopyWith<$Res> {
  factory _$$WeightedTotalImplCopyWith(
    _$WeightedTotalImpl value,
    $Res Function(_$WeightedTotalImpl) then,
  ) = __$$WeightedTotalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double home, double away});
}

/// @nodoc
class __$$WeightedTotalImplCopyWithImpl<$Res>
    extends _$WeightedTotalCopyWithImpl<$Res, _$WeightedTotalImpl>
    implements _$$WeightedTotalImplCopyWith<$Res> {
  __$$WeightedTotalImplCopyWithImpl(
    _$WeightedTotalImpl _value,
    $Res Function(_$WeightedTotalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeightedTotal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? home = null, Object? away = null}) {
    return _then(
      _$WeightedTotalImpl(
        home: null == home
            ? _value.home
            : home // ignore: cast_nullable_to_non_nullable
                  as double,
        away: null == away
            ? _value.away
            : away // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeightedTotalImpl implements _WeightedTotal {
  const _$WeightedTotalImpl({this.home = 0.0, this.away = 0.0});

  factory _$WeightedTotalImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeightedTotalImplFromJson(json);

  @override
  @JsonKey()
  final double home;
  @override
  @JsonKey()
  final double away;

  @override
  String toString() {
    return 'WeightedTotal(home: $home, away: $away)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeightedTotalImpl &&
            (identical(other.home, home) || other.home == home) &&
            (identical(other.away, away) || other.away == away));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, home, away);

  /// Create a copy of WeightedTotal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightedTotalImplCopyWith<_$WeightedTotalImpl> get copyWith =>
      __$$WeightedTotalImplCopyWithImpl<_$WeightedTotalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightedTotalImplToJson(this);
  }
}

abstract class _WeightedTotal implements WeightedTotal {
  const factory _WeightedTotal({final double home, final double away}) =
      _$WeightedTotalImpl;

  factory _WeightedTotal.fromJson(Map<String, dynamic> json) =
      _$WeightedTotalImpl.fromJson;

  @override
  double get home;
  @override
  double get away;

  /// Create a copy of WeightedTotal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeightedTotalImplCopyWith<_$WeightedTotalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DataIntelligence _$DataIntelligenceFromJson(Map<String, dynamic> json) {
  return _DataIntelligence.fromJson(json);
}

/// @nodoc
mixin _$DataIntelligence {
  WeatherData? get weather => throw _privateConstructorUsedError;
  InjuryData? get injuries => throw _privateConstructorUsedError;
  RefereeData? get referee => throw _privateConstructorUsedError;
  RestDaysData? get restDays => throw _privateConstructorUsedError;
  XgData? get xgData => throw _privateConstructorUsedError;
  HeadToHeadData? get headToHead => throw _privateConstructorUsedError;
  StadiumData? get stadiumInfo => throw _privateConstructorUsedError;
  FixtureContext? get fixtureContext => throw _privateConstructorUsedError;

  /// Serializes this DataIntelligence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DataIntelligenceCopyWith<DataIntelligence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataIntelligenceCopyWith<$Res> {
  factory $DataIntelligenceCopyWith(
    DataIntelligence value,
    $Res Function(DataIntelligence) then,
  ) = _$DataIntelligenceCopyWithImpl<$Res, DataIntelligence>;
  @useResult
  $Res call({
    WeatherData? weather,
    InjuryData? injuries,
    RefereeData? referee,
    RestDaysData? restDays,
    XgData? xgData,
    HeadToHeadData? headToHead,
    StadiumData? stadiumInfo,
    FixtureContext? fixtureContext,
  });

  $WeatherDataCopyWith<$Res>? get weather;
  $InjuryDataCopyWith<$Res>? get injuries;
  $RefereeDataCopyWith<$Res>? get referee;
  $RestDaysDataCopyWith<$Res>? get restDays;
  $XgDataCopyWith<$Res>? get xgData;
  $HeadToHeadDataCopyWith<$Res>? get headToHead;
  $StadiumDataCopyWith<$Res>? get stadiumInfo;
  $FixtureContextCopyWith<$Res>? get fixtureContext;
}

/// @nodoc
class _$DataIntelligenceCopyWithImpl<$Res, $Val extends DataIntelligence>
    implements $DataIntelligenceCopyWith<$Res> {
  _$DataIntelligenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weather = freezed,
    Object? injuries = freezed,
    Object? referee = freezed,
    Object? restDays = freezed,
    Object? xgData = freezed,
    Object? headToHead = freezed,
    Object? stadiumInfo = freezed,
    Object? fixtureContext = freezed,
  }) {
    return _then(
      _value.copyWith(
            weather: freezed == weather
                ? _value.weather
                : weather // ignore: cast_nullable_to_non_nullable
                      as WeatherData?,
            injuries: freezed == injuries
                ? _value.injuries
                : injuries // ignore: cast_nullable_to_non_nullable
                      as InjuryData?,
            referee: freezed == referee
                ? _value.referee
                : referee // ignore: cast_nullable_to_non_nullable
                      as RefereeData?,
            restDays: freezed == restDays
                ? _value.restDays
                : restDays // ignore: cast_nullable_to_non_nullable
                      as RestDaysData?,
            xgData: freezed == xgData
                ? _value.xgData
                : xgData // ignore: cast_nullable_to_non_nullable
                      as XgData?,
            headToHead: freezed == headToHead
                ? _value.headToHead
                : headToHead // ignore: cast_nullable_to_non_nullable
                      as HeadToHeadData?,
            stadiumInfo: freezed == stadiumInfo
                ? _value.stadiumInfo
                : stadiumInfo // ignore: cast_nullable_to_non_nullable
                      as StadiumData?,
            fixtureContext: freezed == fixtureContext
                ? _value.fixtureContext
                : fixtureContext // ignore: cast_nullable_to_non_nullable
                      as FixtureContext?,
          )
          as $Val,
    );
  }

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeatherDataCopyWith<$Res>? get weather {
    if (_value.weather == null) {
      return null;
    }

    return $WeatherDataCopyWith<$Res>(_value.weather!, (value) {
      return _then(_value.copyWith(weather: value) as $Val);
    });
  }

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InjuryDataCopyWith<$Res>? get injuries {
    if (_value.injuries == null) {
      return null;
    }

    return $InjuryDataCopyWith<$Res>(_value.injuries!, (value) {
      return _then(_value.copyWith(injuries: value) as $Val);
    });
  }

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RefereeDataCopyWith<$Res>? get referee {
    if (_value.referee == null) {
      return null;
    }

    return $RefereeDataCopyWith<$Res>(_value.referee!, (value) {
      return _then(_value.copyWith(referee: value) as $Val);
    });
  }

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RestDaysDataCopyWith<$Res>? get restDays {
    if (_value.restDays == null) {
      return null;
    }

    return $RestDaysDataCopyWith<$Res>(_value.restDays!, (value) {
      return _then(_value.copyWith(restDays: value) as $Val);
    });
  }

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $XgDataCopyWith<$Res>? get xgData {
    if (_value.xgData == null) {
      return null;
    }

    return $XgDataCopyWith<$Res>(_value.xgData!, (value) {
      return _then(_value.copyWith(xgData: value) as $Val);
    });
  }

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HeadToHeadDataCopyWith<$Res>? get headToHead {
    if (_value.headToHead == null) {
      return null;
    }

    return $HeadToHeadDataCopyWith<$Res>(_value.headToHead!, (value) {
      return _then(_value.copyWith(headToHead: value) as $Val);
    });
  }

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StadiumDataCopyWith<$Res>? get stadiumInfo {
    if (_value.stadiumInfo == null) {
      return null;
    }

    return $StadiumDataCopyWith<$Res>(_value.stadiumInfo!, (value) {
      return _then(_value.copyWith(stadiumInfo: value) as $Val);
    });
  }

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FixtureContextCopyWith<$Res>? get fixtureContext {
    if (_value.fixtureContext == null) {
      return null;
    }

    return $FixtureContextCopyWith<$Res>(_value.fixtureContext!, (value) {
      return _then(_value.copyWith(fixtureContext: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DataIntelligenceImplCopyWith<$Res>
    implements $DataIntelligenceCopyWith<$Res> {
  factory _$$DataIntelligenceImplCopyWith(
    _$DataIntelligenceImpl value,
    $Res Function(_$DataIntelligenceImpl) then,
  ) = __$$DataIntelligenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    WeatherData? weather,
    InjuryData? injuries,
    RefereeData? referee,
    RestDaysData? restDays,
    XgData? xgData,
    HeadToHeadData? headToHead,
    StadiumData? stadiumInfo,
    FixtureContext? fixtureContext,
  });

  @override
  $WeatherDataCopyWith<$Res>? get weather;
  @override
  $InjuryDataCopyWith<$Res>? get injuries;
  @override
  $RefereeDataCopyWith<$Res>? get referee;
  @override
  $RestDaysDataCopyWith<$Res>? get restDays;
  @override
  $XgDataCopyWith<$Res>? get xgData;
  @override
  $HeadToHeadDataCopyWith<$Res>? get headToHead;
  @override
  $StadiumDataCopyWith<$Res>? get stadiumInfo;
  @override
  $FixtureContextCopyWith<$Res>? get fixtureContext;
}

/// @nodoc
class __$$DataIntelligenceImplCopyWithImpl<$Res>
    extends _$DataIntelligenceCopyWithImpl<$Res, _$DataIntelligenceImpl>
    implements _$$DataIntelligenceImplCopyWith<$Res> {
  __$$DataIntelligenceImplCopyWithImpl(
    _$DataIntelligenceImpl _value,
    $Res Function(_$DataIntelligenceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weather = freezed,
    Object? injuries = freezed,
    Object? referee = freezed,
    Object? restDays = freezed,
    Object? xgData = freezed,
    Object? headToHead = freezed,
    Object? stadiumInfo = freezed,
    Object? fixtureContext = freezed,
  }) {
    return _then(
      _$DataIntelligenceImpl(
        weather: freezed == weather
            ? _value.weather
            : weather // ignore: cast_nullable_to_non_nullable
                  as WeatherData?,
        injuries: freezed == injuries
            ? _value.injuries
            : injuries // ignore: cast_nullable_to_non_nullable
                  as InjuryData?,
        referee: freezed == referee
            ? _value.referee
            : referee // ignore: cast_nullable_to_non_nullable
                  as RefereeData?,
        restDays: freezed == restDays
            ? _value.restDays
            : restDays // ignore: cast_nullable_to_non_nullable
                  as RestDaysData?,
        xgData: freezed == xgData
            ? _value.xgData
            : xgData // ignore: cast_nullable_to_non_nullable
                  as XgData?,
        headToHead: freezed == headToHead
            ? _value.headToHead
            : headToHead // ignore: cast_nullable_to_non_nullable
                  as HeadToHeadData?,
        stadiumInfo: freezed == stadiumInfo
            ? _value.stadiumInfo
            : stadiumInfo // ignore: cast_nullable_to_non_nullable
                  as StadiumData?,
        fixtureContext: freezed == fixtureContext
            ? _value.fixtureContext
            : fixtureContext // ignore: cast_nullable_to_non_nullable
                  as FixtureContext?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DataIntelligenceImpl implements _DataIntelligence {
  const _$DataIntelligenceImpl({
    this.weather,
    this.injuries,
    this.referee,
    this.restDays,
    this.xgData,
    this.headToHead,
    this.stadiumInfo,
    this.fixtureContext,
  });

  factory _$DataIntelligenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$DataIntelligenceImplFromJson(json);

  @override
  final WeatherData? weather;
  @override
  final InjuryData? injuries;
  @override
  final RefereeData? referee;
  @override
  final RestDaysData? restDays;
  @override
  final XgData? xgData;
  @override
  final HeadToHeadData? headToHead;
  @override
  final StadiumData? stadiumInfo;
  @override
  final FixtureContext? fixtureContext;

  @override
  String toString() {
    return 'DataIntelligence(weather: $weather, injuries: $injuries, referee: $referee, restDays: $restDays, xgData: $xgData, headToHead: $headToHead, stadiumInfo: $stadiumInfo, fixtureContext: $fixtureContext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataIntelligenceImpl &&
            (identical(other.weather, weather) || other.weather == weather) &&
            (identical(other.injuries, injuries) ||
                other.injuries == injuries) &&
            (identical(other.referee, referee) || other.referee == referee) &&
            (identical(other.restDays, restDays) ||
                other.restDays == restDays) &&
            (identical(other.xgData, xgData) || other.xgData == xgData) &&
            (identical(other.headToHead, headToHead) ||
                other.headToHead == headToHead) &&
            (identical(other.stadiumInfo, stadiumInfo) ||
                other.stadiumInfo == stadiumInfo) &&
            (identical(other.fixtureContext, fixtureContext) ||
                other.fixtureContext == fixtureContext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    weather,
    injuries,
    referee,
    restDays,
    xgData,
    headToHead,
    stadiumInfo,
    fixtureContext,
  );

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DataIntelligenceImplCopyWith<_$DataIntelligenceImpl> get copyWith =>
      __$$DataIntelligenceImplCopyWithImpl<_$DataIntelligenceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DataIntelligenceImplToJson(this);
  }
}

abstract class _DataIntelligence implements DataIntelligence {
  const factory _DataIntelligence({
    final WeatherData? weather,
    final InjuryData? injuries,
    final RefereeData? referee,
    final RestDaysData? restDays,
    final XgData? xgData,
    final HeadToHeadData? headToHead,
    final StadiumData? stadiumInfo,
    final FixtureContext? fixtureContext,
  }) = _$DataIntelligenceImpl;

  factory _DataIntelligence.fromJson(Map<String, dynamic> json) =
      _$DataIntelligenceImpl.fromJson;

  @override
  WeatherData? get weather;
  @override
  InjuryData? get injuries;
  @override
  RefereeData? get referee;
  @override
  RestDaysData? get restDays;
  @override
  XgData? get xgData;
  @override
  HeadToHeadData? get headToHead;
  @override
  StadiumData? get stadiumInfo;
  @override
  FixtureContext? get fixtureContext;

  /// Create a copy of DataIntelligence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DataIntelligenceImplCopyWith<_$DataIntelligenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) {
  return _WeatherData.fromJson(json);
}

/// @nodoc
mixin _$WeatherData {
  String get temperature => throw _privateConstructorUsedError;
  String get humidity => throw _privateConstructorUsedError;
  String get rain => throw _privateConstructorUsedError;
  String get wind => throw _privateConstructorUsedError;
  String get impact => throw _privateConstructorUsedError;

  /// Serializes this WeatherData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeatherData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherDataCopyWith<WeatherData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherDataCopyWith<$Res> {
  factory $WeatherDataCopyWith(
    WeatherData value,
    $Res Function(WeatherData) then,
  ) = _$WeatherDataCopyWithImpl<$Res, WeatherData>;
  @useResult
  $Res call({
    String temperature,
    String humidity,
    String rain,
    String wind,
    String impact,
  });
}

/// @nodoc
class _$WeatherDataCopyWithImpl<$Res, $Val extends WeatherData>
    implements $WeatherDataCopyWith<$Res> {
  _$WeatherDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeatherData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? humidity = null,
    Object? rain = null,
    Object? wind = null,
    Object? impact = null,
  }) {
    return _then(
      _value.copyWith(
            temperature: null == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as String,
            humidity: null == humidity
                ? _value.humidity
                : humidity // ignore: cast_nullable_to_non_nullable
                      as String,
            rain: null == rain
                ? _value.rain
                : rain // ignore: cast_nullable_to_non_nullable
                      as String,
            wind: null == wind
                ? _value.wind
                : wind // ignore: cast_nullable_to_non_nullable
                      as String,
            impact: null == impact
                ? _value.impact
                : impact // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeatherDataImplCopyWith<$Res>
    implements $WeatherDataCopyWith<$Res> {
  factory _$$WeatherDataImplCopyWith(
    _$WeatherDataImpl value,
    $Res Function(_$WeatherDataImpl) then,
  ) = __$$WeatherDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String temperature,
    String humidity,
    String rain,
    String wind,
    String impact,
  });
}

/// @nodoc
class __$$WeatherDataImplCopyWithImpl<$Res>
    extends _$WeatherDataCopyWithImpl<$Res, _$WeatherDataImpl>
    implements _$$WeatherDataImplCopyWith<$Res> {
  __$$WeatherDataImplCopyWithImpl(
    _$WeatherDataImpl _value,
    $Res Function(_$WeatherDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeatherData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? humidity = null,
    Object? rain = null,
    Object? wind = null,
    Object? impact = null,
  }) {
    return _then(
      _$WeatherDataImpl(
        temperature: null == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as String,
        humidity: null == humidity
            ? _value.humidity
            : humidity // ignore: cast_nullable_to_non_nullable
                  as String,
        rain: null == rain
            ? _value.rain
            : rain // ignore: cast_nullable_to_non_nullable
                  as String,
        wind: null == wind
            ? _value.wind
            : wind // ignore: cast_nullable_to_non_nullable
                  as String,
        impact: null == impact
            ? _value.impact
            : impact // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherDataImpl implements _WeatherData {
  const _$WeatherDataImpl({
    this.temperature = '',
    this.humidity = '',
    this.rain = '',
    this.wind = '',
    this.impact = '',
  });

  factory _$WeatherDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherDataImplFromJson(json);

  @override
  @JsonKey()
  final String temperature;
  @override
  @JsonKey()
  final String humidity;
  @override
  @JsonKey()
  final String rain;
  @override
  @JsonKey()
  final String wind;
  @override
  @JsonKey()
  final String impact;

  @override
  String toString() {
    return 'WeatherData(temperature: $temperature, humidity: $humidity, rain: $rain, wind: $wind, impact: $impact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherDataImpl &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.rain, rain) || other.rain == rain) &&
            (identical(other.wind, wind) || other.wind == wind) &&
            (identical(other.impact, impact) || other.impact == impact));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, temperature, humidity, rain, wind, impact);

  /// Create a copy of WeatherData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherDataImplCopyWith<_$WeatherDataImpl> get copyWith =>
      __$$WeatherDataImplCopyWithImpl<_$WeatherDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherDataImplToJson(this);
  }
}

abstract class _WeatherData implements WeatherData {
  const factory _WeatherData({
    final String temperature,
    final String humidity,
    final String rain,
    final String wind,
    final String impact,
  }) = _$WeatherDataImpl;

  factory _WeatherData.fromJson(Map<String, dynamic> json) =
      _$WeatherDataImpl.fromJson;

  @override
  String get temperature;
  @override
  String get humidity;
  @override
  String get rain;
  @override
  String get wind;
  @override
  String get impact;

  /// Create a copy of WeatherData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherDataImplCopyWith<_$WeatherDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InjuryData _$InjuryDataFromJson(Map<String, dynamic> json) {
  return _InjuryData.fromJson(json);
}

/// @nodoc
mixin _$InjuryData {
  List<String> get homeTeamOut => throw _privateConstructorUsedError;
  List<String> get awayTeamOut => throw _privateConstructorUsedError;
  List<String> get homeTeamDoubtful => throw _privateConstructorUsedError;
  List<String> get awayTeamDoubtful => throw _privateConstructorUsedError;

  /// Serializes this InjuryData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InjuryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InjuryDataCopyWith<InjuryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InjuryDataCopyWith<$Res> {
  factory $InjuryDataCopyWith(
    InjuryData value,
    $Res Function(InjuryData) then,
  ) = _$InjuryDataCopyWithImpl<$Res, InjuryData>;
  @useResult
  $Res call({
    List<String> homeTeamOut,
    List<String> awayTeamOut,
    List<String> homeTeamDoubtful,
    List<String> awayTeamDoubtful,
  });
}

/// @nodoc
class _$InjuryDataCopyWithImpl<$Res, $Val extends InjuryData>
    implements $InjuryDataCopyWith<$Res> {
  _$InjuryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InjuryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? homeTeamOut = null,
    Object? awayTeamOut = null,
    Object? homeTeamDoubtful = null,
    Object? awayTeamDoubtful = null,
  }) {
    return _then(
      _value.copyWith(
            homeTeamOut: null == homeTeamOut
                ? _value.homeTeamOut
                : homeTeamOut // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            awayTeamOut: null == awayTeamOut
                ? _value.awayTeamOut
                : awayTeamOut // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            homeTeamDoubtful: null == homeTeamDoubtful
                ? _value.homeTeamDoubtful
                : homeTeamDoubtful // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            awayTeamDoubtful: null == awayTeamDoubtful
                ? _value.awayTeamDoubtful
                : awayTeamDoubtful // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InjuryDataImplCopyWith<$Res>
    implements $InjuryDataCopyWith<$Res> {
  factory _$$InjuryDataImplCopyWith(
    _$InjuryDataImpl value,
    $Res Function(_$InjuryDataImpl) then,
  ) = __$$InjuryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> homeTeamOut,
    List<String> awayTeamOut,
    List<String> homeTeamDoubtful,
    List<String> awayTeamDoubtful,
  });
}

/// @nodoc
class __$$InjuryDataImplCopyWithImpl<$Res>
    extends _$InjuryDataCopyWithImpl<$Res, _$InjuryDataImpl>
    implements _$$InjuryDataImplCopyWith<$Res> {
  __$$InjuryDataImplCopyWithImpl(
    _$InjuryDataImpl _value,
    $Res Function(_$InjuryDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InjuryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? homeTeamOut = null,
    Object? awayTeamOut = null,
    Object? homeTeamDoubtful = null,
    Object? awayTeamDoubtful = null,
  }) {
    return _then(
      _$InjuryDataImpl(
        homeTeamOut: null == homeTeamOut
            ? _value._homeTeamOut
            : homeTeamOut // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        awayTeamOut: null == awayTeamOut
            ? _value._awayTeamOut
            : awayTeamOut // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        homeTeamDoubtful: null == homeTeamDoubtful
            ? _value._homeTeamDoubtful
            : homeTeamDoubtful // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        awayTeamDoubtful: null == awayTeamDoubtful
            ? _value._awayTeamDoubtful
            : awayTeamDoubtful // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InjuryDataImpl implements _InjuryData {
  const _$InjuryDataImpl({
    final List<String> homeTeamOut = const [],
    final List<String> awayTeamOut = const [],
    final List<String> homeTeamDoubtful = const [],
    final List<String> awayTeamDoubtful = const [],
  }) : _homeTeamOut = homeTeamOut,
       _awayTeamOut = awayTeamOut,
       _homeTeamDoubtful = homeTeamDoubtful,
       _awayTeamDoubtful = awayTeamDoubtful;

  factory _$InjuryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$InjuryDataImplFromJson(json);

  final List<String> _homeTeamOut;
  @override
  @JsonKey()
  List<String> get homeTeamOut {
    if (_homeTeamOut is EqualUnmodifiableListView) return _homeTeamOut;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_homeTeamOut);
  }

  final List<String> _awayTeamOut;
  @override
  @JsonKey()
  List<String> get awayTeamOut {
    if (_awayTeamOut is EqualUnmodifiableListView) return _awayTeamOut;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_awayTeamOut);
  }

  final List<String> _homeTeamDoubtful;
  @override
  @JsonKey()
  List<String> get homeTeamDoubtful {
    if (_homeTeamDoubtful is EqualUnmodifiableListView)
      return _homeTeamDoubtful;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_homeTeamDoubtful);
  }

  final List<String> _awayTeamDoubtful;
  @override
  @JsonKey()
  List<String> get awayTeamDoubtful {
    if (_awayTeamDoubtful is EqualUnmodifiableListView)
      return _awayTeamDoubtful;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_awayTeamDoubtful);
  }

  @override
  String toString() {
    return 'InjuryData(homeTeamOut: $homeTeamOut, awayTeamOut: $awayTeamOut, homeTeamDoubtful: $homeTeamDoubtful, awayTeamDoubtful: $awayTeamDoubtful)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InjuryDataImpl &&
            const DeepCollectionEquality().equals(
              other._homeTeamOut,
              _homeTeamOut,
            ) &&
            const DeepCollectionEquality().equals(
              other._awayTeamOut,
              _awayTeamOut,
            ) &&
            const DeepCollectionEquality().equals(
              other._homeTeamDoubtful,
              _homeTeamDoubtful,
            ) &&
            const DeepCollectionEquality().equals(
              other._awayTeamDoubtful,
              _awayTeamDoubtful,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_homeTeamOut),
    const DeepCollectionEquality().hash(_awayTeamOut),
    const DeepCollectionEquality().hash(_homeTeamDoubtful),
    const DeepCollectionEquality().hash(_awayTeamDoubtful),
  );

  /// Create a copy of InjuryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InjuryDataImplCopyWith<_$InjuryDataImpl> get copyWith =>
      __$$InjuryDataImplCopyWithImpl<_$InjuryDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InjuryDataImplToJson(this);
  }
}

abstract class _InjuryData implements InjuryData {
  const factory _InjuryData({
    final List<String> homeTeamOut,
    final List<String> awayTeamOut,
    final List<String> homeTeamDoubtful,
    final List<String> awayTeamDoubtful,
  }) = _$InjuryDataImpl;

  factory _InjuryData.fromJson(Map<String, dynamic> json) =
      _$InjuryDataImpl.fromJson;

  @override
  List<String> get homeTeamOut;
  @override
  List<String> get awayTeamOut;
  @override
  List<String> get homeTeamDoubtful;
  @override
  List<String> get awayTeamDoubtful;

  /// Create a copy of InjuryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InjuryDataImplCopyWith<_$InjuryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefereeData _$RefereeDataFromJson(Map<String, dynamic> json) {
  return _RefereeData.fromJson(json);
}

/// @nodoc
mixin _$RefereeData {
  String get name => throw _privateConstructorUsedError;
  double get avgFoulsPerMatch => throw _privateConstructorUsedError;
  double get avgYellowCards => throw _privateConstructorUsedError;
  double get avgPenalties => throw _privateConstructorUsedError;
  String get varReferee => throw _privateConstructorUsedError;

  /// Serializes this RefereeData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefereeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefereeDataCopyWith<RefereeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefereeDataCopyWith<$Res> {
  factory $RefereeDataCopyWith(
    RefereeData value,
    $Res Function(RefereeData) then,
  ) = _$RefereeDataCopyWithImpl<$Res, RefereeData>;
  @useResult
  $Res call({
    String name,
    double avgFoulsPerMatch,
    double avgYellowCards,
    double avgPenalties,
    String varReferee,
  });
}

/// @nodoc
class _$RefereeDataCopyWithImpl<$Res, $Val extends RefereeData>
    implements $RefereeDataCopyWith<$Res> {
  _$RefereeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefereeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? avgFoulsPerMatch = null,
    Object? avgYellowCards = null,
    Object? avgPenalties = null,
    Object? varReferee = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            avgFoulsPerMatch: null == avgFoulsPerMatch
                ? _value.avgFoulsPerMatch
                : avgFoulsPerMatch // ignore: cast_nullable_to_non_nullable
                      as double,
            avgYellowCards: null == avgYellowCards
                ? _value.avgYellowCards
                : avgYellowCards // ignore: cast_nullable_to_non_nullable
                      as double,
            avgPenalties: null == avgPenalties
                ? _value.avgPenalties
                : avgPenalties // ignore: cast_nullable_to_non_nullable
                      as double,
            varReferee: null == varReferee
                ? _value.varReferee
                : varReferee // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RefereeDataImplCopyWith<$Res>
    implements $RefereeDataCopyWith<$Res> {
  factory _$$RefereeDataImplCopyWith(
    _$RefereeDataImpl value,
    $Res Function(_$RefereeDataImpl) then,
  ) = __$$RefereeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    double avgFoulsPerMatch,
    double avgYellowCards,
    double avgPenalties,
    String varReferee,
  });
}

/// @nodoc
class __$$RefereeDataImplCopyWithImpl<$Res>
    extends _$RefereeDataCopyWithImpl<$Res, _$RefereeDataImpl>
    implements _$$RefereeDataImplCopyWith<$Res> {
  __$$RefereeDataImplCopyWithImpl(
    _$RefereeDataImpl _value,
    $Res Function(_$RefereeDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RefereeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? avgFoulsPerMatch = null,
    Object? avgYellowCards = null,
    Object? avgPenalties = null,
    Object? varReferee = null,
  }) {
    return _then(
      _$RefereeDataImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        avgFoulsPerMatch: null == avgFoulsPerMatch
            ? _value.avgFoulsPerMatch
            : avgFoulsPerMatch // ignore: cast_nullable_to_non_nullable
                  as double,
        avgYellowCards: null == avgYellowCards
            ? _value.avgYellowCards
            : avgYellowCards // ignore: cast_nullable_to_non_nullable
                  as double,
        avgPenalties: null == avgPenalties
            ? _value.avgPenalties
            : avgPenalties // ignore: cast_nullable_to_non_nullable
                  as double,
        varReferee: null == varReferee
            ? _value.varReferee
            : varReferee // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RefereeDataImpl implements _RefereeData {
  const _$RefereeDataImpl({
    this.name = '',
    this.avgFoulsPerMatch = 0.0,
    this.avgYellowCards = 0.0,
    this.avgPenalties = 0.0,
    this.varReferee = '',
  });

  factory _$RefereeDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefereeDataImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final double avgFoulsPerMatch;
  @override
  @JsonKey()
  final double avgYellowCards;
  @override
  @JsonKey()
  final double avgPenalties;
  @override
  @JsonKey()
  final String varReferee;

  @override
  String toString() {
    return 'RefereeData(name: $name, avgFoulsPerMatch: $avgFoulsPerMatch, avgYellowCards: $avgYellowCards, avgPenalties: $avgPenalties, varReferee: $varReferee)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefereeDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avgFoulsPerMatch, avgFoulsPerMatch) ||
                other.avgFoulsPerMatch == avgFoulsPerMatch) &&
            (identical(other.avgYellowCards, avgYellowCards) ||
                other.avgYellowCards == avgYellowCards) &&
            (identical(other.avgPenalties, avgPenalties) ||
                other.avgPenalties == avgPenalties) &&
            (identical(other.varReferee, varReferee) ||
                other.varReferee == varReferee));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    avgFoulsPerMatch,
    avgYellowCards,
    avgPenalties,
    varReferee,
  );

  /// Create a copy of RefereeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefereeDataImplCopyWith<_$RefereeDataImpl> get copyWith =>
      __$$RefereeDataImplCopyWithImpl<_$RefereeDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefereeDataImplToJson(this);
  }
}

abstract class _RefereeData implements RefereeData {
  const factory _RefereeData({
    final String name,
    final double avgFoulsPerMatch,
    final double avgYellowCards,
    final double avgPenalties,
    final String varReferee,
  }) = _$RefereeDataImpl;

  factory _RefereeData.fromJson(Map<String, dynamic> json) =
      _$RefereeDataImpl.fromJson;

  @override
  String get name;
  @override
  double get avgFoulsPerMatch;
  @override
  double get avgYellowCards;
  @override
  double get avgPenalties;
  @override
  String get varReferee;

  /// Create a copy of RefereeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefereeDataImplCopyWith<_$RefereeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RestDaysData _$RestDaysDataFromJson(Map<String, dynamic> json) {
  return _RestDaysData.fromJson(json);
}

/// @nodoc
mixin _$RestDaysData {
  int get home => throw _privateConstructorUsedError;
  int get away => throw _privateConstructorUsedError;
  String get lastMatchHome => throw _privateConstructorUsedError;
  String get lastMatchAway => throw _privateConstructorUsedError;

  /// Serializes this RestDaysData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestDaysData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestDaysDataCopyWith<RestDaysData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestDaysDataCopyWith<$Res> {
  factory $RestDaysDataCopyWith(
    RestDaysData value,
    $Res Function(RestDaysData) then,
  ) = _$RestDaysDataCopyWithImpl<$Res, RestDaysData>;
  @useResult
  $Res call({int home, int away, String lastMatchHome, String lastMatchAway});
}

/// @nodoc
class _$RestDaysDataCopyWithImpl<$Res, $Val extends RestDaysData>
    implements $RestDaysDataCopyWith<$Res> {
  _$RestDaysDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestDaysData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? home = null,
    Object? away = null,
    Object? lastMatchHome = null,
    Object? lastMatchAway = null,
  }) {
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
            lastMatchHome: null == lastMatchHome
                ? _value.lastMatchHome
                : lastMatchHome // ignore: cast_nullable_to_non_nullable
                      as String,
            lastMatchAway: null == lastMatchAway
                ? _value.lastMatchAway
                : lastMatchAway // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RestDaysDataImplCopyWith<$Res>
    implements $RestDaysDataCopyWith<$Res> {
  factory _$$RestDaysDataImplCopyWith(
    _$RestDaysDataImpl value,
    $Res Function(_$RestDaysDataImpl) then,
  ) = __$$RestDaysDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int home, int away, String lastMatchHome, String lastMatchAway});
}

/// @nodoc
class __$$RestDaysDataImplCopyWithImpl<$Res>
    extends _$RestDaysDataCopyWithImpl<$Res, _$RestDaysDataImpl>
    implements _$$RestDaysDataImplCopyWith<$Res> {
  __$$RestDaysDataImplCopyWithImpl(
    _$RestDaysDataImpl _value,
    $Res Function(_$RestDaysDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RestDaysData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? home = null,
    Object? away = null,
    Object? lastMatchHome = null,
    Object? lastMatchAway = null,
  }) {
    return _then(
      _$RestDaysDataImpl(
        home: null == home
            ? _value.home
            : home // ignore: cast_nullable_to_non_nullable
                  as int,
        away: null == away
            ? _value.away
            : away // ignore: cast_nullable_to_non_nullable
                  as int,
        lastMatchHome: null == lastMatchHome
            ? _value.lastMatchHome
            : lastMatchHome // ignore: cast_nullable_to_non_nullable
                  as String,
        lastMatchAway: null == lastMatchAway
            ? _value.lastMatchAway
            : lastMatchAway // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RestDaysDataImpl implements _RestDaysData {
  const _$RestDaysDataImpl({
    this.home = 0,
    this.away = 0,
    this.lastMatchHome = '',
    this.lastMatchAway = '',
  });

  factory _$RestDaysDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestDaysDataImplFromJson(json);

  @override
  @JsonKey()
  final int home;
  @override
  @JsonKey()
  final int away;
  @override
  @JsonKey()
  final String lastMatchHome;
  @override
  @JsonKey()
  final String lastMatchAway;

  @override
  String toString() {
    return 'RestDaysData(home: $home, away: $away, lastMatchHome: $lastMatchHome, lastMatchAway: $lastMatchAway)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestDaysDataImpl &&
            (identical(other.home, home) || other.home == home) &&
            (identical(other.away, away) || other.away == away) &&
            (identical(other.lastMatchHome, lastMatchHome) ||
                other.lastMatchHome == lastMatchHome) &&
            (identical(other.lastMatchAway, lastMatchAway) ||
                other.lastMatchAway == lastMatchAway));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, home, away, lastMatchHome, lastMatchAway);

  /// Create a copy of RestDaysData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestDaysDataImplCopyWith<_$RestDaysDataImpl> get copyWith =>
      __$$RestDaysDataImplCopyWithImpl<_$RestDaysDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestDaysDataImplToJson(this);
  }
}

abstract class _RestDaysData implements RestDaysData {
  const factory _RestDaysData({
    final int home,
    final int away,
    final String lastMatchHome,
    final String lastMatchAway,
  }) = _$RestDaysDataImpl;

  factory _RestDaysData.fromJson(Map<String, dynamic> json) =
      _$RestDaysDataImpl.fromJson;

  @override
  int get home;
  @override
  int get away;
  @override
  String get lastMatchHome;
  @override
  String get lastMatchAway;

  /// Create a copy of RestDaysData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestDaysDataImplCopyWith<_$RestDaysDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

XgData _$XgDataFromJson(Map<String, dynamic> json) {
  return _XgData.fromJson(json);
}

/// @nodoc
mixin _$XgData {
  double get homeXg => throw _privateConstructorUsedError;
  double get homeXga => throw _privateConstructorUsedError;
  double get awayXg => throw _privateConstructorUsedError;
  double get awayXga => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;

  /// Serializes this XgData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of XgData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $XgDataCopyWith<XgData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $XgDataCopyWith<$Res> {
  factory $XgDataCopyWith(XgData value, $Res Function(XgData) then) =
      _$XgDataCopyWithImpl<$Res, XgData>;
  @useResult
  $Res call({
    double homeXg,
    double homeXga,
    double awayXg,
    double awayXga,
    String source,
  });
}

/// @nodoc
class _$XgDataCopyWithImpl<$Res, $Val extends XgData>
    implements $XgDataCopyWith<$Res> {
  _$XgDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of XgData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? homeXg = null,
    Object? homeXga = null,
    Object? awayXg = null,
    Object? awayXga = null,
    Object? source = null,
  }) {
    return _then(
      _value.copyWith(
            homeXg: null == homeXg
                ? _value.homeXg
                : homeXg // ignore: cast_nullable_to_non_nullable
                      as double,
            homeXga: null == homeXga
                ? _value.homeXga
                : homeXga // ignore: cast_nullable_to_non_nullable
                      as double,
            awayXg: null == awayXg
                ? _value.awayXg
                : awayXg // ignore: cast_nullable_to_non_nullable
                      as double,
            awayXga: null == awayXga
                ? _value.awayXga
                : awayXga // ignore: cast_nullable_to_non_nullable
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
abstract class _$$XgDataImplCopyWith<$Res> implements $XgDataCopyWith<$Res> {
  factory _$$XgDataImplCopyWith(
    _$XgDataImpl value,
    $Res Function(_$XgDataImpl) then,
  ) = __$$XgDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double homeXg,
    double homeXga,
    double awayXg,
    double awayXga,
    String source,
  });
}

/// @nodoc
class __$$XgDataImplCopyWithImpl<$Res>
    extends _$XgDataCopyWithImpl<$Res, _$XgDataImpl>
    implements _$$XgDataImplCopyWith<$Res> {
  __$$XgDataImplCopyWithImpl(
    _$XgDataImpl _value,
    $Res Function(_$XgDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of XgData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? homeXg = null,
    Object? homeXga = null,
    Object? awayXg = null,
    Object? awayXga = null,
    Object? source = null,
  }) {
    return _then(
      _$XgDataImpl(
        homeXg: null == homeXg
            ? _value.homeXg
            : homeXg // ignore: cast_nullable_to_non_nullable
                  as double,
        homeXga: null == homeXga
            ? _value.homeXga
            : homeXga // ignore: cast_nullable_to_non_nullable
                  as double,
        awayXg: null == awayXg
            ? _value.awayXg
            : awayXg // ignore: cast_nullable_to_non_nullable
                  as double,
        awayXga: null == awayXga
            ? _value.awayXga
            : awayXga // ignore: cast_nullable_to_non_nullable
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
class _$XgDataImpl implements _XgData {
  const _$XgDataImpl({
    this.homeXg = 0.0,
    this.homeXga = 0.0,
    this.awayXg = 0.0,
    this.awayXga = 0.0,
    this.source = '',
  });

  factory _$XgDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$XgDataImplFromJson(json);

  @override
  @JsonKey()
  final double homeXg;
  @override
  @JsonKey()
  final double homeXga;
  @override
  @JsonKey()
  final double awayXg;
  @override
  @JsonKey()
  final double awayXga;
  @override
  @JsonKey()
  final String source;

  @override
  String toString() {
    return 'XgData(homeXg: $homeXg, homeXga: $homeXga, awayXg: $awayXg, awayXga: $awayXga, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$XgDataImpl &&
            (identical(other.homeXg, homeXg) || other.homeXg == homeXg) &&
            (identical(other.homeXga, homeXga) || other.homeXga == homeXga) &&
            (identical(other.awayXg, awayXg) || other.awayXg == awayXg) &&
            (identical(other.awayXga, awayXga) || other.awayXga == awayXga) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, homeXg, homeXga, awayXg, awayXga, source);

  /// Create a copy of XgData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$XgDataImplCopyWith<_$XgDataImpl> get copyWith =>
      __$$XgDataImplCopyWithImpl<_$XgDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$XgDataImplToJson(this);
  }
}

abstract class _XgData implements XgData {
  const factory _XgData({
    final double homeXg,
    final double homeXga,
    final double awayXg,
    final double awayXga,
    final String source,
  }) = _$XgDataImpl;

  factory _XgData.fromJson(Map<String, dynamic> json) = _$XgDataImpl.fromJson;

  @override
  double get homeXg;
  @override
  double get homeXga;
  @override
  double get awayXg;
  @override
  double get awayXga;
  @override
  String get source;

  /// Create a copy of XgData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$XgDataImplCopyWith<_$XgDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HeadToHeadData _$HeadToHeadDataFromJson(Map<String, dynamic> json) {
  return _HeadToHeadData.fromJson(json);
}

/// @nodoc
mixin _$HeadToHeadData {
  String get last5 => throw _privateConstructorUsedError;
  int get homeWins => throw _privateConstructorUsedError;
  int get draws => throw _privateConstructorUsedError;
  int get awayWins => throw _privateConstructorUsedError;

  /// Serializes this HeadToHeadData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HeadToHeadData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeadToHeadDataCopyWith<HeadToHeadData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeadToHeadDataCopyWith<$Res> {
  factory $HeadToHeadDataCopyWith(
    HeadToHeadData value,
    $Res Function(HeadToHeadData) then,
  ) = _$HeadToHeadDataCopyWithImpl<$Res, HeadToHeadData>;
  @useResult
  $Res call({String last5, int homeWins, int draws, int awayWins});
}

/// @nodoc
class _$HeadToHeadDataCopyWithImpl<$Res, $Val extends HeadToHeadData>
    implements $HeadToHeadDataCopyWith<$Res> {
  _$HeadToHeadDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeadToHeadData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? last5 = null,
    Object? homeWins = null,
    Object? draws = null,
    Object? awayWins = null,
  }) {
    return _then(
      _value.copyWith(
            last5: null == last5
                ? _value.last5
                : last5 // ignore: cast_nullable_to_non_nullable
                      as String,
            homeWins: null == homeWins
                ? _value.homeWins
                : homeWins // ignore: cast_nullable_to_non_nullable
                      as int,
            draws: null == draws
                ? _value.draws
                : draws // ignore: cast_nullable_to_non_nullable
                      as int,
            awayWins: null == awayWins
                ? _value.awayWins
                : awayWins // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HeadToHeadDataImplCopyWith<$Res>
    implements $HeadToHeadDataCopyWith<$Res> {
  factory _$$HeadToHeadDataImplCopyWith(
    _$HeadToHeadDataImpl value,
    $Res Function(_$HeadToHeadDataImpl) then,
  ) = __$$HeadToHeadDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String last5, int homeWins, int draws, int awayWins});
}

/// @nodoc
class __$$HeadToHeadDataImplCopyWithImpl<$Res>
    extends _$HeadToHeadDataCopyWithImpl<$Res, _$HeadToHeadDataImpl>
    implements _$$HeadToHeadDataImplCopyWith<$Res> {
  __$$HeadToHeadDataImplCopyWithImpl(
    _$HeadToHeadDataImpl _value,
    $Res Function(_$HeadToHeadDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HeadToHeadData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? last5 = null,
    Object? homeWins = null,
    Object? draws = null,
    Object? awayWins = null,
  }) {
    return _then(
      _$HeadToHeadDataImpl(
        last5: null == last5
            ? _value.last5
            : last5 // ignore: cast_nullable_to_non_nullable
                  as String,
        homeWins: null == homeWins
            ? _value.homeWins
            : homeWins // ignore: cast_nullable_to_non_nullable
                  as int,
        draws: null == draws
            ? _value.draws
            : draws // ignore: cast_nullable_to_non_nullable
                  as int,
        awayWins: null == awayWins
            ? _value.awayWins
            : awayWins // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HeadToHeadDataImpl implements _HeadToHeadData {
  const _$HeadToHeadDataImpl({
    this.last5 = '',
    this.homeWins = 0,
    this.draws = 0,
    this.awayWins = 0,
  });

  factory _$HeadToHeadDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeadToHeadDataImplFromJson(json);

  @override
  @JsonKey()
  final String last5;
  @override
  @JsonKey()
  final int homeWins;
  @override
  @JsonKey()
  final int draws;
  @override
  @JsonKey()
  final int awayWins;

  @override
  String toString() {
    return 'HeadToHeadData(last5: $last5, homeWins: $homeWins, draws: $draws, awayWins: $awayWins)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeadToHeadDataImpl &&
            (identical(other.last5, last5) || other.last5 == last5) &&
            (identical(other.homeWins, homeWins) ||
                other.homeWins == homeWins) &&
            (identical(other.draws, draws) || other.draws == draws) &&
            (identical(other.awayWins, awayWins) ||
                other.awayWins == awayWins));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, last5, homeWins, draws, awayWins);

  /// Create a copy of HeadToHeadData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeadToHeadDataImplCopyWith<_$HeadToHeadDataImpl> get copyWith =>
      __$$HeadToHeadDataImplCopyWithImpl<_$HeadToHeadDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HeadToHeadDataImplToJson(this);
  }
}

abstract class _HeadToHeadData implements HeadToHeadData {
  const factory _HeadToHeadData({
    final String last5,
    final int homeWins,
    final int draws,
    final int awayWins,
  }) = _$HeadToHeadDataImpl;

  factory _HeadToHeadData.fromJson(Map<String, dynamic> json) =
      _$HeadToHeadDataImpl.fromJson;

  @override
  String get last5;
  @override
  int get homeWins;
  @override
  int get draws;
  @override
  int get awayWins;

  /// Create a copy of HeadToHeadData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeadToHeadDataImplCopyWith<_$HeadToHeadDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StadiumData _$StadiumDataFromJson(Map<String, dynamic> json) {
  return _StadiumData.fromJson(json);
}

/// @nodoc
mixin _$StadiumData {
  String get name => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  int get altitude => throw _privateConstructorUsedError;
  String get pitchType => throw _privateConstructorUsedError;
  String get pitchDimensions => throw _privateConstructorUsedError;

  /// Serializes this StadiumData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StadiumData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StadiumDataCopyWith<StadiumData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StadiumDataCopyWith<$Res> {
  factory $StadiumDataCopyWith(
    StadiumData value,
    $Res Function(StadiumData) then,
  ) = _$StadiumDataCopyWithImpl<$Res, StadiumData>;
  @useResult
  $Res call({
    String name,
    int capacity,
    int altitude,
    String pitchType,
    String pitchDimensions,
  });
}

/// @nodoc
class _$StadiumDataCopyWithImpl<$Res, $Val extends StadiumData>
    implements $StadiumDataCopyWith<$Res> {
  _$StadiumDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StadiumData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? capacity = null,
    Object? altitude = null,
    Object? pitchType = null,
    Object? pitchDimensions = null,
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
            altitude: null == altitude
                ? _value.altitude
                : altitude // ignore: cast_nullable_to_non_nullable
                      as int,
            pitchType: null == pitchType
                ? _value.pitchType
                : pitchType // ignore: cast_nullable_to_non_nullable
                      as String,
            pitchDimensions: null == pitchDimensions
                ? _value.pitchDimensions
                : pitchDimensions // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StadiumDataImplCopyWith<$Res>
    implements $StadiumDataCopyWith<$Res> {
  factory _$$StadiumDataImplCopyWith(
    _$StadiumDataImpl value,
    $Res Function(_$StadiumDataImpl) then,
  ) = __$$StadiumDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    int capacity,
    int altitude,
    String pitchType,
    String pitchDimensions,
  });
}

/// @nodoc
class __$$StadiumDataImplCopyWithImpl<$Res>
    extends _$StadiumDataCopyWithImpl<$Res, _$StadiumDataImpl>
    implements _$$StadiumDataImplCopyWith<$Res> {
  __$$StadiumDataImplCopyWithImpl(
    _$StadiumDataImpl _value,
    $Res Function(_$StadiumDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StadiumData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? capacity = null,
    Object? altitude = null,
    Object? pitchType = null,
    Object? pitchDimensions = null,
  }) {
    return _then(
      _$StadiumDataImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        altitude: null == altitude
            ? _value.altitude
            : altitude // ignore: cast_nullable_to_non_nullable
                  as int,
        pitchType: null == pitchType
            ? _value.pitchType
            : pitchType // ignore: cast_nullable_to_non_nullable
                  as String,
        pitchDimensions: null == pitchDimensions
            ? _value.pitchDimensions
            : pitchDimensions // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StadiumDataImpl implements _StadiumData {
  const _$StadiumDataImpl({
    this.name = '',
    this.capacity = 0,
    this.altitude = 0,
    this.pitchType = '',
    this.pitchDimensions = '',
  });

  factory _$StadiumDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$StadiumDataImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final int capacity;
  @override
  @JsonKey()
  final int altitude;
  @override
  @JsonKey()
  final String pitchType;
  @override
  @JsonKey()
  final String pitchDimensions;

  @override
  String toString() {
    return 'StadiumData(name: $name, capacity: $capacity, altitude: $altitude, pitchType: $pitchType, pitchDimensions: $pitchDimensions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StadiumDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.pitchType, pitchType) ||
                other.pitchType == pitchType) &&
            (identical(other.pitchDimensions, pitchDimensions) ||
                other.pitchDimensions == pitchDimensions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    capacity,
    altitude,
    pitchType,
    pitchDimensions,
  );

  /// Create a copy of StadiumData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StadiumDataImplCopyWith<_$StadiumDataImpl> get copyWith =>
      __$$StadiumDataImplCopyWithImpl<_$StadiumDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StadiumDataImplToJson(this);
  }
}

abstract class _StadiumData implements StadiumData {
  const factory _StadiumData({
    final String name,
    final int capacity,
    final int altitude,
    final String pitchType,
    final String pitchDimensions,
  }) = _$StadiumDataImpl;

  factory _StadiumData.fromJson(Map<String, dynamic> json) =
      _$StadiumDataImpl.fromJson;

  @override
  String get name;
  @override
  int get capacity;
  @override
  int get altitude;
  @override
  String get pitchType;
  @override
  String get pitchDimensions;

  /// Create a copy of StadiumData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StadiumDataImplCopyWith<_$StadiumDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FixtureContext _$FixtureContextFromJson(Map<String, dynamic> json) {
  return _FixtureContext.fromJson(json);
}

/// @nodoc
mixin _$FixtureContext {
  String get homeNextMatch => throw _privateConstructorUsedError;
  String get awayNextMatch => throw _privateConstructorUsedError;
  String get targetMatchSyndrome => throw _privateConstructorUsedError;

  /// Serializes this FixtureContext to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FixtureContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FixtureContextCopyWith<FixtureContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixtureContextCopyWith<$Res> {
  factory $FixtureContextCopyWith(
    FixtureContext value,
    $Res Function(FixtureContext) then,
  ) = _$FixtureContextCopyWithImpl<$Res, FixtureContext>;
  @useResult
  $Res call({
    String homeNextMatch,
    String awayNextMatch,
    String targetMatchSyndrome,
  });
}

/// @nodoc
class _$FixtureContextCopyWithImpl<$Res, $Val extends FixtureContext>
    implements $FixtureContextCopyWith<$Res> {
  _$FixtureContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FixtureContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? homeNextMatch = null,
    Object? awayNextMatch = null,
    Object? targetMatchSyndrome = null,
  }) {
    return _then(
      _value.copyWith(
            homeNextMatch: null == homeNextMatch
                ? _value.homeNextMatch
                : homeNextMatch // ignore: cast_nullable_to_non_nullable
                      as String,
            awayNextMatch: null == awayNextMatch
                ? _value.awayNextMatch
                : awayNextMatch // ignore: cast_nullable_to_non_nullable
                      as String,
            targetMatchSyndrome: null == targetMatchSyndrome
                ? _value.targetMatchSyndrome
                : targetMatchSyndrome // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FixtureContextImplCopyWith<$Res>
    implements $FixtureContextCopyWith<$Res> {
  factory _$$FixtureContextImplCopyWith(
    _$FixtureContextImpl value,
    $Res Function(_$FixtureContextImpl) then,
  ) = __$$FixtureContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String homeNextMatch,
    String awayNextMatch,
    String targetMatchSyndrome,
  });
}

/// @nodoc
class __$$FixtureContextImplCopyWithImpl<$Res>
    extends _$FixtureContextCopyWithImpl<$Res, _$FixtureContextImpl>
    implements _$$FixtureContextImplCopyWith<$Res> {
  __$$FixtureContextImplCopyWithImpl(
    _$FixtureContextImpl _value,
    $Res Function(_$FixtureContextImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FixtureContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? homeNextMatch = null,
    Object? awayNextMatch = null,
    Object? targetMatchSyndrome = null,
  }) {
    return _then(
      _$FixtureContextImpl(
        homeNextMatch: null == homeNextMatch
            ? _value.homeNextMatch
            : homeNextMatch // ignore: cast_nullable_to_non_nullable
                  as String,
        awayNextMatch: null == awayNextMatch
            ? _value.awayNextMatch
            : awayNextMatch // ignore: cast_nullable_to_non_nullable
                  as String,
        targetMatchSyndrome: null == targetMatchSyndrome
            ? _value.targetMatchSyndrome
            : targetMatchSyndrome // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FixtureContextImpl implements _FixtureContext {
  const _$FixtureContextImpl({
    this.homeNextMatch = '',
    this.awayNextMatch = '',
    this.targetMatchSyndrome = '',
  });

  factory _$FixtureContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixtureContextImplFromJson(json);

  @override
  @JsonKey()
  final String homeNextMatch;
  @override
  @JsonKey()
  final String awayNextMatch;
  @override
  @JsonKey()
  final String targetMatchSyndrome;

  @override
  String toString() {
    return 'FixtureContext(homeNextMatch: $homeNextMatch, awayNextMatch: $awayNextMatch, targetMatchSyndrome: $targetMatchSyndrome)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixtureContextImpl &&
            (identical(other.homeNextMatch, homeNextMatch) ||
                other.homeNextMatch == homeNextMatch) &&
            (identical(other.awayNextMatch, awayNextMatch) ||
                other.awayNextMatch == awayNextMatch) &&
            (identical(other.targetMatchSyndrome, targetMatchSyndrome) ||
                other.targetMatchSyndrome == targetMatchSyndrome));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    homeNextMatch,
    awayNextMatch,
    targetMatchSyndrome,
  );

  /// Create a copy of FixtureContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FixtureContextImplCopyWith<_$FixtureContextImpl> get copyWith =>
      __$$FixtureContextImplCopyWithImpl<_$FixtureContextImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FixtureContextImplToJson(this);
  }
}

abstract class _FixtureContext implements FixtureContext {
  const factory _FixtureContext({
    final String homeNextMatch,
    final String awayNextMatch,
    final String targetMatchSyndrome,
  }) = _$FixtureContextImpl;

  factory _FixtureContext.fromJson(Map<String, dynamic> json) =
      _$FixtureContextImpl.fromJson;

  @override
  String get homeNextMatch;
  @override
  String get awayNextMatch;
  @override
  String get targetMatchSyndrome;

  /// Create a copy of FixtureContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixtureContextImplCopyWith<_$FixtureContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
