// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multi_model_analysis_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MultiModelAnalysisModel _$MultiModelAnalysisModelFromJson(
  Map<String, dynamic> json,
) {
  return _MultiModelAnalysisModel.fromJson(json);
}

/// @nodoc
mixin _$MultiModelAnalysisModel {
  String get matchId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'verifying', 'analyzing', 'ai_processing', 'consensus', 'completed', 'failed'
  String? get statusMessage => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  VerificationResult? get verification => throw _privateConstructorUsedError;
  DeepAnalysisResult? get deepAnalysis => throw _privateConstructorUsedError;
  AIModelResult? get geminiResult => throw _privateConstructorUsedError;
  AIModelResult? get claudeResult => throw _privateConstructorUsedError;
  ConsensusResult? get consensusResult => throw _privateConstructorUsedError;

  /// Serializes this MultiModelAnalysisModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MultiModelAnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MultiModelAnalysisModelCopyWith<MultiModelAnalysisModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MultiModelAnalysisModelCopyWith<$Res> {
  factory $MultiModelAnalysisModelCopyWith(
    MultiModelAnalysisModel value,
    $Res Function(MultiModelAnalysisModel) then,
  ) = _$MultiModelAnalysisModelCopyWithImpl<$Res, MultiModelAnalysisModel>;
  @useResult
  $Res call({
    String matchId,
    String userId,
    String status,
    String? statusMessage,
    String? error,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    VerificationResult? verification,
    DeepAnalysisResult? deepAnalysis,
    AIModelResult? geminiResult,
    AIModelResult? claudeResult,
    ConsensusResult? consensusResult,
  });

  $VerificationResultCopyWith<$Res>? get verification;
  $DeepAnalysisResultCopyWith<$Res>? get deepAnalysis;
  $AIModelResultCopyWith<$Res>? get geminiResult;
  $AIModelResultCopyWith<$Res>? get claudeResult;
  $ConsensusResultCopyWith<$Res>? get consensusResult;
}

/// @nodoc
class _$MultiModelAnalysisModelCopyWithImpl<
  $Res,
  $Val extends MultiModelAnalysisModel
>
    implements $MultiModelAnalysisModelCopyWith<$Res> {
  _$MultiModelAnalysisModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MultiModelAnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? userId = null,
    Object? status = null,
    Object? statusMessage = freezed,
    Object? error = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? verification = freezed,
    Object? deepAnalysis = freezed,
    Object? geminiResult = freezed,
    Object? claudeResult = freezed,
    Object? consensusResult = freezed,
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
            statusMessage: freezed == statusMessage
                ? _value.statusMessage
                : statusMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            verification: freezed == verification
                ? _value.verification
                : verification // ignore: cast_nullable_to_non_nullable
                      as VerificationResult?,
            deepAnalysis: freezed == deepAnalysis
                ? _value.deepAnalysis
                : deepAnalysis // ignore: cast_nullable_to_non_nullable
                      as DeepAnalysisResult?,
            geminiResult: freezed == geminiResult
                ? _value.geminiResult
                : geminiResult // ignore: cast_nullable_to_non_nullable
                      as AIModelResult?,
            claudeResult: freezed == claudeResult
                ? _value.claudeResult
                : claudeResult // ignore: cast_nullable_to_non_nullable
                      as AIModelResult?,
            consensusResult: freezed == consensusResult
                ? _value.consensusResult
                : consensusResult // ignore: cast_nullable_to_non_nullable
                      as ConsensusResult?,
          )
          as $Val,
    );
  }

  /// Create a copy of MultiModelAnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerificationResultCopyWith<$Res>? get verification {
    if (_value.verification == null) {
      return null;
    }

    return $VerificationResultCopyWith<$Res>(_value.verification!, (value) {
      return _then(_value.copyWith(verification: value) as $Val);
    });
  }

  /// Create a copy of MultiModelAnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeepAnalysisResultCopyWith<$Res>? get deepAnalysis {
    if (_value.deepAnalysis == null) {
      return null;
    }

    return $DeepAnalysisResultCopyWith<$Res>(_value.deepAnalysis!, (value) {
      return _then(_value.copyWith(deepAnalysis: value) as $Val);
    });
  }

  /// Create a copy of MultiModelAnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIModelResultCopyWith<$Res>? get geminiResult {
    if (_value.geminiResult == null) {
      return null;
    }

    return $AIModelResultCopyWith<$Res>(_value.geminiResult!, (value) {
      return _then(_value.copyWith(geminiResult: value) as $Val);
    });
  }

  /// Create a copy of MultiModelAnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIModelResultCopyWith<$Res>? get claudeResult {
    if (_value.claudeResult == null) {
      return null;
    }

    return $AIModelResultCopyWith<$Res>(_value.claudeResult!, (value) {
      return _then(_value.copyWith(claudeResult: value) as $Val);
    });
  }

  /// Create a copy of MultiModelAnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConsensusResultCopyWith<$Res>? get consensusResult {
    if (_value.consensusResult == null) {
      return null;
    }

    return $ConsensusResultCopyWith<$Res>(_value.consensusResult!, (value) {
      return _then(_value.copyWith(consensusResult: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MultiModelAnalysisModelImplCopyWith<$Res>
    implements $MultiModelAnalysisModelCopyWith<$Res> {
  factory _$$MultiModelAnalysisModelImplCopyWith(
    _$MultiModelAnalysisModelImpl value,
    $Res Function(_$MultiModelAnalysisModelImpl) then,
  ) = __$$MultiModelAnalysisModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String matchId,
    String userId,
    String status,
    String? statusMessage,
    String? error,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    VerificationResult? verification,
    DeepAnalysisResult? deepAnalysis,
    AIModelResult? geminiResult,
    AIModelResult? claudeResult,
    ConsensusResult? consensusResult,
  });

  @override
  $VerificationResultCopyWith<$Res>? get verification;
  @override
  $DeepAnalysisResultCopyWith<$Res>? get deepAnalysis;
  @override
  $AIModelResultCopyWith<$Res>? get geminiResult;
  @override
  $AIModelResultCopyWith<$Res>? get claudeResult;
  @override
  $ConsensusResultCopyWith<$Res>? get consensusResult;
}

/// @nodoc
class __$$MultiModelAnalysisModelImplCopyWithImpl<$Res>
    extends
        _$MultiModelAnalysisModelCopyWithImpl<
          $Res,
          _$MultiModelAnalysisModelImpl
        >
    implements _$$MultiModelAnalysisModelImplCopyWith<$Res> {
  __$$MultiModelAnalysisModelImplCopyWithImpl(
    _$MultiModelAnalysisModelImpl _value,
    $Res Function(_$MultiModelAnalysisModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MultiModelAnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? userId = null,
    Object? status = null,
    Object? statusMessage = freezed,
    Object? error = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? verification = freezed,
    Object? deepAnalysis = freezed,
    Object? geminiResult = freezed,
    Object? claudeResult = freezed,
    Object? consensusResult = freezed,
  }) {
    return _then(
      _$MultiModelAnalysisModelImpl(
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
        statusMessage: freezed == statusMessage
            ? _value.statusMessage
            : statusMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        verification: freezed == verification
            ? _value.verification
            : verification // ignore: cast_nullable_to_non_nullable
                  as VerificationResult?,
        deepAnalysis: freezed == deepAnalysis
            ? _value.deepAnalysis
            : deepAnalysis // ignore: cast_nullable_to_non_nullable
                  as DeepAnalysisResult?,
        geminiResult: freezed == geminiResult
            ? _value.geminiResult
            : geminiResult // ignore: cast_nullable_to_non_nullable
                  as AIModelResult?,
        claudeResult: freezed == claudeResult
            ? _value.claudeResult
            : claudeResult // ignore: cast_nullable_to_non_nullable
                  as AIModelResult?,
        consensusResult: freezed == consensusResult
            ? _value.consensusResult
            : consensusResult // ignore: cast_nullable_to_non_nullable
                  as ConsensusResult?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MultiModelAnalysisModelImpl implements _MultiModelAnalysisModel {
  const _$MultiModelAnalysisModelImpl({
    required this.matchId,
    required this.userId,
    required this.status,
    this.statusMessage,
    this.error,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
    this.verification,
    this.deepAnalysis,
    this.geminiResult,
    this.claudeResult,
    this.consensusResult,
  });

  factory _$MultiModelAnalysisModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MultiModelAnalysisModelImplFromJson(json);

  @override
  final String matchId;
  @override
  final String userId;
  @override
  final String status;
  // 'pending', 'verifying', 'analyzing', 'ai_processing', 'consensus', 'completed', 'failed'
  @override
  final String? statusMessage;
  @override
  final String? error;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;
  @override
  final VerificationResult? verification;
  @override
  final DeepAnalysisResult? deepAnalysis;
  @override
  final AIModelResult? geminiResult;
  @override
  final AIModelResult? claudeResult;
  @override
  final ConsensusResult? consensusResult;

  @override
  String toString() {
    return 'MultiModelAnalysisModel(matchId: $matchId, userId: $userId, status: $status, statusMessage: $statusMessage, error: $error, createdAt: $createdAt, updatedAt: $updatedAt, verification: $verification, deepAnalysis: $deepAnalysis, geminiResult: $geminiResult, claudeResult: $claudeResult, consensusResult: $consensusResult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultiModelAnalysisModelImpl &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusMessage, statusMessage) ||
                other.statusMessage == statusMessage) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.verification, verification) ||
                other.verification == verification) &&
            (identical(other.deepAnalysis, deepAnalysis) ||
                other.deepAnalysis == deepAnalysis) &&
            (identical(other.geminiResult, geminiResult) ||
                other.geminiResult == geminiResult) &&
            (identical(other.claudeResult, claudeResult) ||
                other.claudeResult == claudeResult) &&
            (identical(other.consensusResult, consensusResult) ||
                other.consensusResult == consensusResult));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    matchId,
    userId,
    status,
    statusMessage,
    error,
    createdAt,
    updatedAt,
    verification,
    deepAnalysis,
    geminiResult,
    claudeResult,
    consensusResult,
  );

  /// Create a copy of MultiModelAnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultiModelAnalysisModelImplCopyWith<_$MultiModelAnalysisModelImpl>
  get copyWith =>
      __$$MultiModelAnalysisModelImplCopyWithImpl<
        _$MultiModelAnalysisModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MultiModelAnalysisModelImplToJson(this);
  }
}

abstract class _MultiModelAnalysisModel implements MultiModelAnalysisModel {
  const factory _MultiModelAnalysisModel({
    required final String matchId,
    required final String userId,
    required final String status,
    final String? statusMessage,
    final String? error,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
    final VerificationResult? verification,
    final DeepAnalysisResult? deepAnalysis,
    final AIModelResult? geminiResult,
    final AIModelResult? claudeResult,
    final ConsensusResult? consensusResult,
  }) = _$MultiModelAnalysisModelImpl;

  factory _MultiModelAnalysisModel.fromJson(Map<String, dynamic> json) =
      _$MultiModelAnalysisModelImpl.fromJson;

  @override
  String get matchId;
  @override
  String get userId;
  @override
  String get status; // 'pending', 'verifying', 'analyzing', 'ai_processing', 'consensus', 'completed', 'failed'
  @override
  String? get statusMessage;
  @override
  String? get error;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  VerificationResult? get verification;
  @override
  DeepAnalysisResult? get deepAnalysis;
  @override
  AIModelResult? get geminiResult;
  @override
  AIModelResult? get claudeResult;
  @override
  ConsensusResult? get consensusResult;

  /// Create a copy of MultiModelAnalysisModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultiModelAnalysisModelImplCopyWith<_$MultiModelAnalysisModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

VerificationResult _$VerificationResultFromJson(Map<String, dynamic> json) {
  return _VerificationResult.fromJson(json);
}

/// @nodoc
mixin _$VerificationResult {
  bool get verified => throw _privateConstructorUsedError;
  bool get dateValid => throw _privateConstructorUsedError;
  int get sourcesChecked => throw _privateConstructorUsedError;
  int get sourcesValid => throw _privateConstructorUsedError;
  int get dataCompleteness => throw _privateConstructorUsedError;
  List<String> get warnings => throw _privateConstructorUsedError;

  /// Serializes this VerificationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerificationResultCopyWith<VerificationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationResultCopyWith<$Res> {
  factory $VerificationResultCopyWith(
    VerificationResult value,
    $Res Function(VerificationResult) then,
  ) = _$VerificationResultCopyWithImpl<$Res, VerificationResult>;
  @useResult
  $Res call({
    bool verified,
    bool dateValid,
    int sourcesChecked,
    int sourcesValid,
    int dataCompleteness,
    List<String> warnings,
  });
}

/// @nodoc
class _$VerificationResultCopyWithImpl<$Res, $Val extends VerificationResult>
    implements $VerificationResultCopyWith<$Res> {
  _$VerificationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verified = null,
    Object? dateValid = null,
    Object? sourcesChecked = null,
    Object? sourcesValid = null,
    Object? dataCompleteness = null,
    Object? warnings = null,
  }) {
    return _then(
      _value.copyWith(
            verified: null == verified
                ? _value.verified
                : verified // ignore: cast_nullable_to_non_nullable
                      as bool,
            dateValid: null == dateValid
                ? _value.dateValid
                : dateValid // ignore: cast_nullable_to_non_nullable
                      as bool,
            sourcesChecked: null == sourcesChecked
                ? _value.sourcesChecked
                : sourcesChecked // ignore: cast_nullable_to_non_nullable
                      as int,
            sourcesValid: null == sourcesValid
                ? _value.sourcesValid
                : sourcesValid // ignore: cast_nullable_to_non_nullable
                      as int,
            dataCompleteness: null == dataCompleteness
                ? _value.dataCompleteness
                : dataCompleteness // ignore: cast_nullable_to_non_nullable
                      as int,
            warnings: null == warnings
                ? _value.warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VerificationResultImplCopyWith<$Res>
    implements $VerificationResultCopyWith<$Res> {
  factory _$$VerificationResultImplCopyWith(
    _$VerificationResultImpl value,
    $Res Function(_$VerificationResultImpl) then,
  ) = __$$VerificationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool verified,
    bool dateValid,
    int sourcesChecked,
    int sourcesValid,
    int dataCompleteness,
    List<String> warnings,
  });
}

/// @nodoc
class __$$VerificationResultImplCopyWithImpl<$Res>
    extends _$VerificationResultCopyWithImpl<$Res, _$VerificationResultImpl>
    implements _$$VerificationResultImplCopyWith<$Res> {
  __$$VerificationResultImplCopyWithImpl(
    _$VerificationResultImpl _value,
    $Res Function(_$VerificationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verified = null,
    Object? dateValid = null,
    Object? sourcesChecked = null,
    Object? sourcesValid = null,
    Object? dataCompleteness = null,
    Object? warnings = null,
  }) {
    return _then(
      _$VerificationResultImpl(
        verified: null == verified
            ? _value.verified
            : verified // ignore: cast_nullable_to_non_nullable
                  as bool,
        dateValid: null == dateValid
            ? _value.dateValid
            : dateValid // ignore: cast_nullable_to_non_nullable
                  as bool,
        sourcesChecked: null == sourcesChecked
            ? _value.sourcesChecked
            : sourcesChecked // ignore: cast_nullable_to_non_nullable
                  as int,
        sourcesValid: null == sourcesValid
            ? _value.sourcesValid
            : sourcesValid // ignore: cast_nullable_to_non_nullable
                  as int,
        dataCompleteness: null == dataCompleteness
            ? _value.dataCompleteness
            : dataCompleteness // ignore: cast_nullable_to_non_nullable
                  as int,
        warnings: null == warnings
            ? _value._warnings
            : warnings // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationResultImpl implements _VerificationResult {
  const _$VerificationResultImpl({
    required this.verified,
    required this.dateValid,
    required this.sourcesChecked,
    required this.sourcesValid,
    required this.dataCompleteness,
    required final List<String> warnings,
  }) : _warnings = warnings;

  factory _$VerificationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationResultImplFromJson(json);

  @override
  final bool verified;
  @override
  final bool dateValid;
  @override
  final int sourcesChecked;
  @override
  final int sourcesValid;
  @override
  final int dataCompleteness;
  final List<String> _warnings;
  @override
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  @override
  String toString() {
    return 'VerificationResult(verified: $verified, dateValid: $dateValid, sourcesChecked: $sourcesChecked, sourcesValid: $sourcesValid, dataCompleteness: $dataCompleteness, warnings: $warnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationResultImpl &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.dateValid, dateValid) ||
                other.dateValid == dateValid) &&
            (identical(other.sourcesChecked, sourcesChecked) ||
                other.sourcesChecked == sourcesChecked) &&
            (identical(other.sourcesValid, sourcesValid) ||
                other.sourcesValid == sourcesValid) &&
            (identical(other.dataCompleteness, dataCompleteness) ||
                other.dataCompleteness == dataCompleteness) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    verified,
    dateValid,
    sourcesChecked,
    sourcesValid,
    dataCompleteness,
    const DeepCollectionEquality().hash(_warnings),
  );

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationResultImplCopyWith<_$VerificationResultImpl> get copyWith =>
      __$$VerificationResultImplCopyWithImpl<_$VerificationResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationResultImplToJson(this);
  }
}

abstract class _VerificationResult implements VerificationResult {
  const factory _VerificationResult({
    required final bool verified,
    required final bool dateValid,
    required final int sourcesChecked,
    required final int sourcesValid,
    required final int dataCompleteness,
    required final List<String> warnings,
  }) = _$VerificationResultImpl;

  factory _VerificationResult.fromJson(Map<String, dynamic> json) =
      _$VerificationResultImpl.fromJson;

  @override
  bool get verified;
  @override
  bool get dateValid;
  @override
  int get sourcesChecked;
  @override
  int get sourcesValid;
  @override
  int get dataCompleteness;
  @override
  List<String> get warnings;

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerificationResultImplCopyWith<_$VerificationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeepAnalysisResult _$DeepAnalysisResultFromJson(Map<String, dynamic> json) {
  return _DeepAnalysisResult.fromJson(json);
}

/// @nodoc
mixin _$DeepAnalysisResult {
  Map<String, dynamic> get weather => throw _privateConstructorUsedError;
  Map<String, dynamic> get missingPlayers => throw _privateConstructorUsedError;
  Map<String, dynamic> get homeAwayForm => throw _privateConstructorUsedError;
  Map<String, dynamic> get h2h => throw _privateConstructorUsedError;
  Map<String, dynamic> get xg => throw _privateConstructorUsedError;
  Map<String, dynamic> get setPieces => throw _privateConstructorUsedError;
  Map<String, dynamic> get referee => throw _privateConstructorUsedError;
  Map<String, dynamic> get tactics => throw _privateConstructorUsedError;

  /// Serializes this DeepAnalysisResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeepAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeepAnalysisResultCopyWith<DeepAnalysisResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeepAnalysisResultCopyWith<$Res> {
  factory $DeepAnalysisResultCopyWith(
    DeepAnalysisResult value,
    $Res Function(DeepAnalysisResult) then,
  ) = _$DeepAnalysisResultCopyWithImpl<$Res, DeepAnalysisResult>;
  @useResult
  $Res call({
    Map<String, dynamic> weather,
    Map<String, dynamic> missingPlayers,
    Map<String, dynamic> homeAwayForm,
    Map<String, dynamic> h2h,
    Map<String, dynamic> xg,
    Map<String, dynamic> setPieces,
    Map<String, dynamic> referee,
    Map<String, dynamic> tactics,
  });
}

/// @nodoc
class _$DeepAnalysisResultCopyWithImpl<$Res, $Val extends DeepAnalysisResult>
    implements $DeepAnalysisResultCopyWith<$Res> {
  _$DeepAnalysisResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeepAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weather = null,
    Object? missingPlayers = null,
    Object? homeAwayForm = null,
    Object? h2h = null,
    Object? xg = null,
    Object? setPieces = null,
    Object? referee = null,
    Object? tactics = null,
  }) {
    return _then(
      _value.copyWith(
            weather: null == weather
                ? _value.weather
                : weather // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            missingPlayers: null == missingPlayers
                ? _value.missingPlayers
                : missingPlayers // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            homeAwayForm: null == homeAwayForm
                ? _value.homeAwayForm
                : homeAwayForm // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            h2h: null == h2h
                ? _value.h2h
                : h2h // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            xg: null == xg
                ? _value.xg
                : xg // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            setPieces: null == setPieces
                ? _value.setPieces
                : setPieces // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            referee: null == referee
                ? _value.referee
                : referee // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            tactics: null == tactics
                ? _value.tactics
                : tactics // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeepAnalysisResultImplCopyWith<$Res>
    implements $DeepAnalysisResultCopyWith<$Res> {
  factory _$$DeepAnalysisResultImplCopyWith(
    _$DeepAnalysisResultImpl value,
    $Res Function(_$DeepAnalysisResultImpl) then,
  ) = __$$DeepAnalysisResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<String, dynamic> weather,
    Map<String, dynamic> missingPlayers,
    Map<String, dynamic> homeAwayForm,
    Map<String, dynamic> h2h,
    Map<String, dynamic> xg,
    Map<String, dynamic> setPieces,
    Map<String, dynamic> referee,
    Map<String, dynamic> tactics,
  });
}

/// @nodoc
class __$$DeepAnalysisResultImplCopyWithImpl<$Res>
    extends _$DeepAnalysisResultCopyWithImpl<$Res, _$DeepAnalysisResultImpl>
    implements _$$DeepAnalysisResultImplCopyWith<$Res> {
  __$$DeepAnalysisResultImplCopyWithImpl(
    _$DeepAnalysisResultImpl _value,
    $Res Function(_$DeepAnalysisResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeepAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weather = null,
    Object? missingPlayers = null,
    Object? homeAwayForm = null,
    Object? h2h = null,
    Object? xg = null,
    Object? setPieces = null,
    Object? referee = null,
    Object? tactics = null,
  }) {
    return _then(
      _$DeepAnalysisResultImpl(
        weather: null == weather
            ? _value._weather
            : weather // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        missingPlayers: null == missingPlayers
            ? _value._missingPlayers
            : missingPlayers // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        homeAwayForm: null == homeAwayForm
            ? _value._homeAwayForm
            : homeAwayForm // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        h2h: null == h2h
            ? _value._h2h
            : h2h // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        xg: null == xg
            ? _value._xg
            : xg // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        setPieces: null == setPieces
            ? _value._setPieces
            : setPieces // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        referee: null == referee
            ? _value._referee
            : referee // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        tactics: null == tactics
            ? _value._tactics
            : tactics // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeepAnalysisResultImpl implements _DeepAnalysisResult {
  const _$DeepAnalysisResultImpl({
    required final Map<String, dynamic> weather,
    required final Map<String, dynamic> missingPlayers,
    required final Map<String, dynamic> homeAwayForm,
    required final Map<String, dynamic> h2h,
    required final Map<String, dynamic> xg,
    required final Map<String, dynamic> setPieces,
    required final Map<String, dynamic> referee,
    required final Map<String, dynamic> tactics,
  }) : _weather = weather,
       _missingPlayers = missingPlayers,
       _homeAwayForm = homeAwayForm,
       _h2h = h2h,
       _xg = xg,
       _setPieces = setPieces,
       _referee = referee,
       _tactics = tactics;

  factory _$DeepAnalysisResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeepAnalysisResultImplFromJson(json);

  final Map<String, dynamic> _weather;
  @override
  Map<String, dynamic> get weather {
    if (_weather is EqualUnmodifiableMapView) return _weather;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_weather);
  }

  final Map<String, dynamic> _missingPlayers;
  @override
  Map<String, dynamic> get missingPlayers {
    if (_missingPlayers is EqualUnmodifiableMapView) return _missingPlayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_missingPlayers);
  }

  final Map<String, dynamic> _homeAwayForm;
  @override
  Map<String, dynamic> get homeAwayForm {
    if (_homeAwayForm is EqualUnmodifiableMapView) return _homeAwayForm;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_homeAwayForm);
  }

  final Map<String, dynamic> _h2h;
  @override
  Map<String, dynamic> get h2h {
    if (_h2h is EqualUnmodifiableMapView) return _h2h;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_h2h);
  }

  final Map<String, dynamic> _xg;
  @override
  Map<String, dynamic> get xg {
    if (_xg is EqualUnmodifiableMapView) return _xg;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_xg);
  }

  final Map<String, dynamic> _setPieces;
  @override
  Map<String, dynamic> get setPieces {
    if (_setPieces is EqualUnmodifiableMapView) return _setPieces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_setPieces);
  }

  final Map<String, dynamic> _referee;
  @override
  Map<String, dynamic> get referee {
    if (_referee is EqualUnmodifiableMapView) return _referee;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_referee);
  }

  final Map<String, dynamic> _tactics;
  @override
  Map<String, dynamic> get tactics {
    if (_tactics is EqualUnmodifiableMapView) return _tactics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tactics);
  }

  @override
  String toString() {
    return 'DeepAnalysisResult(weather: $weather, missingPlayers: $missingPlayers, homeAwayForm: $homeAwayForm, h2h: $h2h, xg: $xg, setPieces: $setPieces, referee: $referee, tactics: $tactics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeepAnalysisResultImpl &&
            const DeepCollectionEquality().equals(other._weather, _weather) &&
            const DeepCollectionEquality().equals(
              other._missingPlayers,
              _missingPlayers,
            ) &&
            const DeepCollectionEquality().equals(
              other._homeAwayForm,
              _homeAwayForm,
            ) &&
            const DeepCollectionEquality().equals(other._h2h, _h2h) &&
            const DeepCollectionEquality().equals(other._xg, _xg) &&
            const DeepCollectionEquality().equals(
              other._setPieces,
              _setPieces,
            ) &&
            const DeepCollectionEquality().equals(other._referee, _referee) &&
            const DeepCollectionEquality().equals(other._tactics, _tactics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_weather),
    const DeepCollectionEquality().hash(_missingPlayers),
    const DeepCollectionEquality().hash(_homeAwayForm),
    const DeepCollectionEquality().hash(_h2h),
    const DeepCollectionEquality().hash(_xg),
    const DeepCollectionEquality().hash(_setPieces),
    const DeepCollectionEquality().hash(_referee),
    const DeepCollectionEquality().hash(_tactics),
  );

  /// Create a copy of DeepAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeepAnalysisResultImplCopyWith<_$DeepAnalysisResultImpl> get copyWith =>
      __$$DeepAnalysisResultImplCopyWithImpl<_$DeepAnalysisResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeepAnalysisResultImplToJson(this);
  }
}

abstract class _DeepAnalysisResult implements DeepAnalysisResult {
  const factory _DeepAnalysisResult({
    required final Map<String, dynamic> weather,
    required final Map<String, dynamic> missingPlayers,
    required final Map<String, dynamic> homeAwayForm,
    required final Map<String, dynamic> h2h,
    required final Map<String, dynamic> xg,
    required final Map<String, dynamic> setPieces,
    required final Map<String, dynamic> referee,
    required final Map<String, dynamic> tactics,
  }) = _$DeepAnalysisResultImpl;

  factory _DeepAnalysisResult.fromJson(Map<String, dynamic> json) =
      _$DeepAnalysisResultImpl.fromJson;

  @override
  Map<String, dynamic> get weather;
  @override
  Map<String, dynamic> get missingPlayers;
  @override
  Map<String, dynamic> get homeAwayForm;
  @override
  Map<String, dynamic> get h2h;
  @override
  Map<String, dynamic> get xg;
  @override
  Map<String, dynamic> get setPieces;
  @override
  Map<String, dynamic> get referee;
  @override
  Map<String, dynamic> get tactics;

  /// Create a copy of DeepAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeepAnalysisResultImplCopyWith<_$DeepAnalysisResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIModelResult _$AIModelResultFromJson(Map<String, dynamic> json) {
  return _AIModelResult.fromJson(json);
}

/// @nodoc
mixin _$AIModelResult {
  String get modelName => throw _privateConstructorUsedError;
  double get homeWinProbability => throw _privateConstructorUsedError;
  double get drawProbability => throw _privateConstructorUsedError;
  double get awayWinProbability => throw _privateConstructorUsedError;
  double get over25Probability => throw _privateConstructorUsedError;
  double get under25Probability => throw _privateConstructorUsedError;
  double get bttsProbability => throw _privateConstructorUsedError;
  String get predictedScore => throw _privateConstructorUsedError;
  List<String> get topPredictions => throw _privateConstructorUsedError;
  List<String> get keyFactors => throw _privateConstructorUsedError;
  String get gameNarrative => throw _privateConstructorUsedError;
  double get confidenceScore => throw _privateConstructorUsedError;

  /// Serializes this AIModelResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIModelResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIModelResultCopyWith<AIModelResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIModelResultCopyWith<$Res> {
  factory $AIModelResultCopyWith(
    AIModelResult value,
    $Res Function(AIModelResult) then,
  ) = _$AIModelResultCopyWithImpl<$Res, AIModelResult>;
  @useResult
  $Res call({
    String modelName,
    double homeWinProbability,
    double drawProbability,
    double awayWinProbability,
    double over25Probability,
    double under25Probability,
    double bttsProbability,
    String predictedScore,
    List<String> topPredictions,
    List<String> keyFactors,
    String gameNarrative,
    double confidenceScore,
  });
}

/// @nodoc
class _$AIModelResultCopyWithImpl<$Res, $Val extends AIModelResult>
    implements $AIModelResultCopyWith<$Res> {
  _$AIModelResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIModelResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modelName = null,
    Object? homeWinProbability = null,
    Object? drawProbability = null,
    Object? awayWinProbability = null,
    Object? over25Probability = null,
    Object? under25Probability = null,
    Object? bttsProbability = null,
    Object? predictedScore = null,
    Object? topPredictions = null,
    Object? keyFactors = null,
    Object? gameNarrative = null,
    Object? confidenceScore = null,
  }) {
    return _then(
      _value.copyWith(
            modelName: null == modelName
                ? _value.modelName
                : modelName // ignore: cast_nullable_to_non_nullable
                      as String,
            homeWinProbability: null == homeWinProbability
                ? _value.homeWinProbability
                : homeWinProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            drawProbability: null == drawProbability
                ? _value.drawProbability
                : drawProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            awayWinProbability: null == awayWinProbability
                ? _value.awayWinProbability
                : awayWinProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            over25Probability: null == over25Probability
                ? _value.over25Probability
                : over25Probability // ignore: cast_nullable_to_non_nullable
                      as double,
            under25Probability: null == under25Probability
                ? _value.under25Probability
                : under25Probability // ignore: cast_nullable_to_non_nullable
                      as double,
            bttsProbability: null == bttsProbability
                ? _value.bttsProbability
                : bttsProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            predictedScore: null == predictedScore
                ? _value.predictedScore
                : predictedScore // ignore: cast_nullable_to_non_nullable
                      as String,
            topPredictions: null == topPredictions
                ? _value.topPredictions
                : topPredictions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            keyFactors: null == keyFactors
                ? _value.keyFactors
                : keyFactors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            gameNarrative: null == gameNarrative
                ? _value.gameNarrative
                : gameNarrative // ignore: cast_nullable_to_non_nullable
                      as String,
            confidenceScore: null == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIModelResultImplCopyWith<$Res>
    implements $AIModelResultCopyWith<$Res> {
  factory _$$AIModelResultImplCopyWith(
    _$AIModelResultImpl value,
    $Res Function(_$AIModelResultImpl) then,
  ) = __$$AIModelResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String modelName,
    double homeWinProbability,
    double drawProbability,
    double awayWinProbability,
    double over25Probability,
    double under25Probability,
    double bttsProbability,
    String predictedScore,
    List<String> topPredictions,
    List<String> keyFactors,
    String gameNarrative,
    double confidenceScore,
  });
}

/// @nodoc
class __$$AIModelResultImplCopyWithImpl<$Res>
    extends _$AIModelResultCopyWithImpl<$Res, _$AIModelResultImpl>
    implements _$$AIModelResultImplCopyWith<$Res> {
  __$$AIModelResultImplCopyWithImpl(
    _$AIModelResultImpl _value,
    $Res Function(_$AIModelResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIModelResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modelName = null,
    Object? homeWinProbability = null,
    Object? drawProbability = null,
    Object? awayWinProbability = null,
    Object? over25Probability = null,
    Object? under25Probability = null,
    Object? bttsProbability = null,
    Object? predictedScore = null,
    Object? topPredictions = null,
    Object? keyFactors = null,
    Object? gameNarrative = null,
    Object? confidenceScore = null,
  }) {
    return _then(
      _$AIModelResultImpl(
        modelName: null == modelName
            ? _value.modelName
            : modelName // ignore: cast_nullable_to_non_nullable
                  as String,
        homeWinProbability: null == homeWinProbability
            ? _value.homeWinProbability
            : homeWinProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        drawProbability: null == drawProbability
            ? _value.drawProbability
            : drawProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        awayWinProbability: null == awayWinProbability
            ? _value.awayWinProbability
            : awayWinProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        over25Probability: null == over25Probability
            ? _value.over25Probability
            : over25Probability // ignore: cast_nullable_to_non_nullable
                  as double,
        under25Probability: null == under25Probability
            ? _value.under25Probability
            : under25Probability // ignore: cast_nullable_to_non_nullable
                  as double,
        bttsProbability: null == bttsProbability
            ? _value.bttsProbability
            : bttsProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        predictedScore: null == predictedScore
            ? _value.predictedScore
            : predictedScore // ignore: cast_nullable_to_non_nullable
                  as String,
        topPredictions: null == topPredictions
            ? _value._topPredictions
            : topPredictions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        keyFactors: null == keyFactors
            ? _value._keyFactors
            : keyFactors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        gameNarrative: null == gameNarrative
            ? _value.gameNarrative
            : gameNarrative // ignore: cast_nullable_to_non_nullable
                  as String,
        confidenceScore: null == confidenceScore
            ? _value.confidenceScore
            : confidenceScore // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIModelResultImpl implements _AIModelResult {
  const _$AIModelResultImpl({
    required this.modelName,
    required this.homeWinProbability,
    required this.drawProbability,
    required this.awayWinProbability,
    required this.over25Probability,
    required this.under25Probability,
    required this.bttsProbability,
    required this.predictedScore,
    required final List<String> topPredictions,
    required final List<String> keyFactors,
    required this.gameNarrative,
    required this.confidenceScore,
  }) : _topPredictions = topPredictions,
       _keyFactors = keyFactors;

  factory _$AIModelResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIModelResultImplFromJson(json);

  @override
  final String modelName;
  @override
  final double homeWinProbability;
  @override
  final double drawProbability;
  @override
  final double awayWinProbability;
  @override
  final double over25Probability;
  @override
  final double under25Probability;
  @override
  final double bttsProbability;
  @override
  final String predictedScore;
  final List<String> _topPredictions;
  @override
  List<String> get topPredictions {
    if (_topPredictions is EqualUnmodifiableListView) return _topPredictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topPredictions);
  }

  final List<String> _keyFactors;
  @override
  List<String> get keyFactors {
    if (_keyFactors is EqualUnmodifiableListView) return _keyFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keyFactors);
  }

  @override
  final String gameNarrative;
  @override
  final double confidenceScore;

  @override
  String toString() {
    return 'AIModelResult(modelName: $modelName, homeWinProbability: $homeWinProbability, drawProbability: $drawProbability, awayWinProbability: $awayWinProbability, over25Probability: $over25Probability, under25Probability: $under25Probability, bttsProbability: $bttsProbability, predictedScore: $predictedScore, topPredictions: $topPredictions, keyFactors: $keyFactors, gameNarrative: $gameNarrative, confidenceScore: $confidenceScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIModelResultImpl &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.homeWinProbability, homeWinProbability) ||
                other.homeWinProbability == homeWinProbability) &&
            (identical(other.drawProbability, drawProbability) ||
                other.drawProbability == drawProbability) &&
            (identical(other.awayWinProbability, awayWinProbability) ||
                other.awayWinProbability == awayWinProbability) &&
            (identical(other.over25Probability, over25Probability) ||
                other.over25Probability == over25Probability) &&
            (identical(other.under25Probability, under25Probability) ||
                other.under25Probability == under25Probability) &&
            (identical(other.bttsProbability, bttsProbability) ||
                other.bttsProbability == bttsProbability) &&
            (identical(other.predictedScore, predictedScore) ||
                other.predictedScore == predictedScore) &&
            const DeepCollectionEquality().equals(
              other._topPredictions,
              _topPredictions,
            ) &&
            const DeepCollectionEquality().equals(
              other._keyFactors,
              _keyFactors,
            ) &&
            (identical(other.gameNarrative, gameNarrative) ||
                other.gameNarrative == gameNarrative) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    modelName,
    homeWinProbability,
    drawProbability,
    awayWinProbability,
    over25Probability,
    under25Probability,
    bttsProbability,
    predictedScore,
    const DeepCollectionEquality().hash(_topPredictions),
    const DeepCollectionEquality().hash(_keyFactors),
    gameNarrative,
    confidenceScore,
  );

  /// Create a copy of AIModelResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIModelResultImplCopyWith<_$AIModelResultImpl> get copyWith =>
      __$$AIModelResultImplCopyWithImpl<_$AIModelResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIModelResultImplToJson(this);
  }
}

abstract class _AIModelResult implements AIModelResult {
  const factory _AIModelResult({
    required final String modelName,
    required final double homeWinProbability,
    required final double drawProbability,
    required final double awayWinProbability,
    required final double over25Probability,
    required final double under25Probability,
    required final double bttsProbability,
    required final String predictedScore,
    required final List<String> topPredictions,
    required final List<String> keyFactors,
    required final String gameNarrative,
    required final double confidenceScore,
  }) = _$AIModelResultImpl;

  factory _AIModelResult.fromJson(Map<String, dynamic> json) =
      _$AIModelResultImpl.fromJson;

  @override
  String get modelName;
  @override
  double get homeWinProbability;
  @override
  double get drawProbability;
  @override
  double get awayWinProbability;
  @override
  double get over25Probability;
  @override
  double get under25Probability;
  @override
  double get bttsProbability;
  @override
  String get predictedScore;
  @override
  List<String> get topPredictions;
  @override
  List<String> get keyFactors;
  @override
  String get gameNarrative;
  @override
  double get confidenceScore;

  /// Create a copy of AIModelResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIModelResultImplCopyWith<_$AIModelResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConsensusResult _$ConsensusResultFromJson(Map<String, dynamic> json) {
  return _ConsensusResult.fromJson(json);
}

/// @nodoc
mixin _$ConsensusResult {
  double get homeWinProbability => throw _privateConstructorUsedError;
  double get drawProbability => throw _privateConstructorUsedError;
  double get awayWinProbability => throw _privateConstructorUsedError;
  double get over25Probability => throw _privateConstructorUsedError;
  double get under25Probability => throw _privateConstructorUsedError;
  double get bttsProbability => throw _privateConstructorUsedError;
  String get predictedScore => throw _privateConstructorUsedError;
  List<String> get topPredictions => throw _privateConstructorUsedError;
  String get consensusReasoning => throw _privateConstructorUsedError;
  double get confidenceScore => throw _privateConstructorUsedError;
  bool get fallback => throw _privateConstructorUsedError;
  String? get modelName => throw _privateConstructorUsedError;

  /// Serializes this ConsensusResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConsensusResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsensusResultCopyWith<ConsensusResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsensusResultCopyWith<$Res> {
  factory $ConsensusResultCopyWith(
    ConsensusResult value,
    $Res Function(ConsensusResult) then,
  ) = _$ConsensusResultCopyWithImpl<$Res, ConsensusResult>;
  @useResult
  $Res call({
    double homeWinProbability,
    double drawProbability,
    double awayWinProbability,
    double over25Probability,
    double under25Probability,
    double bttsProbability,
    String predictedScore,
    List<String> topPredictions,
    String consensusReasoning,
    double confidenceScore,
    bool fallback,
    String? modelName,
  });
}

/// @nodoc
class _$ConsensusResultCopyWithImpl<$Res, $Val extends ConsensusResult>
    implements $ConsensusResultCopyWith<$Res> {
  _$ConsensusResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsensusResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? homeWinProbability = null,
    Object? drawProbability = null,
    Object? awayWinProbability = null,
    Object? over25Probability = null,
    Object? under25Probability = null,
    Object? bttsProbability = null,
    Object? predictedScore = null,
    Object? topPredictions = null,
    Object? consensusReasoning = null,
    Object? confidenceScore = null,
    Object? fallback = null,
    Object? modelName = freezed,
  }) {
    return _then(
      _value.copyWith(
            homeWinProbability: null == homeWinProbability
                ? _value.homeWinProbability
                : homeWinProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            drawProbability: null == drawProbability
                ? _value.drawProbability
                : drawProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            awayWinProbability: null == awayWinProbability
                ? _value.awayWinProbability
                : awayWinProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            over25Probability: null == over25Probability
                ? _value.over25Probability
                : over25Probability // ignore: cast_nullable_to_non_nullable
                      as double,
            under25Probability: null == under25Probability
                ? _value.under25Probability
                : under25Probability // ignore: cast_nullable_to_non_nullable
                      as double,
            bttsProbability: null == bttsProbability
                ? _value.bttsProbability
                : bttsProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            predictedScore: null == predictedScore
                ? _value.predictedScore
                : predictedScore // ignore: cast_nullable_to_non_nullable
                      as String,
            topPredictions: null == topPredictions
                ? _value.topPredictions
                : topPredictions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            consensusReasoning: null == consensusReasoning
                ? _value.consensusReasoning
                : consensusReasoning // ignore: cast_nullable_to_non_nullable
                      as String,
            confidenceScore: null == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                      as double,
            fallback: null == fallback
                ? _value.fallback
                : fallback // ignore: cast_nullable_to_non_nullable
                      as bool,
            modelName: freezed == modelName
                ? _value.modelName
                : modelName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConsensusResultImplCopyWith<$Res>
    implements $ConsensusResultCopyWith<$Res> {
  factory _$$ConsensusResultImplCopyWith(
    _$ConsensusResultImpl value,
    $Res Function(_$ConsensusResultImpl) then,
  ) = __$$ConsensusResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double homeWinProbability,
    double drawProbability,
    double awayWinProbability,
    double over25Probability,
    double under25Probability,
    double bttsProbability,
    String predictedScore,
    List<String> topPredictions,
    String consensusReasoning,
    double confidenceScore,
    bool fallback,
    String? modelName,
  });
}

/// @nodoc
class __$$ConsensusResultImplCopyWithImpl<$Res>
    extends _$ConsensusResultCopyWithImpl<$Res, _$ConsensusResultImpl>
    implements _$$ConsensusResultImplCopyWith<$Res> {
  __$$ConsensusResultImplCopyWithImpl(
    _$ConsensusResultImpl _value,
    $Res Function(_$ConsensusResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConsensusResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? homeWinProbability = null,
    Object? drawProbability = null,
    Object? awayWinProbability = null,
    Object? over25Probability = null,
    Object? under25Probability = null,
    Object? bttsProbability = null,
    Object? predictedScore = null,
    Object? topPredictions = null,
    Object? consensusReasoning = null,
    Object? confidenceScore = null,
    Object? fallback = null,
    Object? modelName = freezed,
  }) {
    return _then(
      _$ConsensusResultImpl(
        homeWinProbability: null == homeWinProbability
            ? _value.homeWinProbability
            : homeWinProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        drawProbability: null == drawProbability
            ? _value.drawProbability
            : drawProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        awayWinProbability: null == awayWinProbability
            ? _value.awayWinProbability
            : awayWinProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        over25Probability: null == over25Probability
            ? _value.over25Probability
            : over25Probability // ignore: cast_nullable_to_non_nullable
                  as double,
        under25Probability: null == under25Probability
            ? _value.under25Probability
            : under25Probability // ignore: cast_nullable_to_non_nullable
                  as double,
        bttsProbability: null == bttsProbability
            ? _value.bttsProbability
            : bttsProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        predictedScore: null == predictedScore
            ? _value.predictedScore
            : predictedScore // ignore: cast_nullable_to_non_nullable
                  as String,
        topPredictions: null == topPredictions
            ? _value._topPredictions
            : topPredictions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        consensusReasoning: null == consensusReasoning
            ? _value.consensusReasoning
            : consensusReasoning // ignore: cast_nullable_to_non_nullable
                  as String,
        confidenceScore: null == confidenceScore
            ? _value.confidenceScore
            : confidenceScore // ignore: cast_nullable_to_non_nullable
                  as double,
        fallback: null == fallback
            ? _value.fallback
            : fallback // ignore: cast_nullable_to_non_nullable
                  as bool,
        modelName: freezed == modelName
            ? _value.modelName
            : modelName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConsensusResultImpl implements _ConsensusResult {
  const _$ConsensusResultImpl({
    required this.homeWinProbability,
    required this.drawProbability,
    required this.awayWinProbability,
    required this.over25Probability,
    required this.under25Probability,
    required this.bttsProbability,
    required this.predictedScore,
    required final List<String> topPredictions,
    required this.consensusReasoning,
    required this.confidenceScore,
    this.fallback = false,
    this.modelName,
  }) : _topPredictions = topPredictions;

  factory _$ConsensusResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsensusResultImplFromJson(json);

  @override
  final double homeWinProbability;
  @override
  final double drawProbability;
  @override
  final double awayWinProbability;
  @override
  final double over25Probability;
  @override
  final double under25Probability;
  @override
  final double bttsProbability;
  @override
  final String predictedScore;
  final List<String> _topPredictions;
  @override
  List<String> get topPredictions {
    if (_topPredictions is EqualUnmodifiableListView) return _topPredictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topPredictions);
  }

  @override
  final String consensusReasoning;
  @override
  final double confidenceScore;
  @override
  @JsonKey()
  final bool fallback;
  @override
  final String? modelName;

  @override
  String toString() {
    return 'ConsensusResult(homeWinProbability: $homeWinProbability, drawProbability: $drawProbability, awayWinProbability: $awayWinProbability, over25Probability: $over25Probability, under25Probability: $under25Probability, bttsProbability: $bttsProbability, predictedScore: $predictedScore, topPredictions: $topPredictions, consensusReasoning: $consensusReasoning, confidenceScore: $confidenceScore, fallback: $fallback, modelName: $modelName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsensusResultImpl &&
            (identical(other.homeWinProbability, homeWinProbability) ||
                other.homeWinProbability == homeWinProbability) &&
            (identical(other.drawProbability, drawProbability) ||
                other.drawProbability == drawProbability) &&
            (identical(other.awayWinProbability, awayWinProbability) ||
                other.awayWinProbability == awayWinProbability) &&
            (identical(other.over25Probability, over25Probability) ||
                other.over25Probability == over25Probability) &&
            (identical(other.under25Probability, under25Probability) ||
                other.under25Probability == under25Probability) &&
            (identical(other.bttsProbability, bttsProbability) ||
                other.bttsProbability == bttsProbability) &&
            (identical(other.predictedScore, predictedScore) ||
                other.predictedScore == predictedScore) &&
            const DeepCollectionEquality().equals(
              other._topPredictions,
              _topPredictions,
            ) &&
            (identical(other.consensusReasoning, consensusReasoning) ||
                other.consensusReasoning == consensusReasoning) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.fallback, fallback) ||
                other.fallback == fallback) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    homeWinProbability,
    drawProbability,
    awayWinProbability,
    over25Probability,
    under25Probability,
    bttsProbability,
    predictedScore,
    const DeepCollectionEquality().hash(_topPredictions),
    consensusReasoning,
    confidenceScore,
    fallback,
    modelName,
  );

  /// Create a copy of ConsensusResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsensusResultImplCopyWith<_$ConsensusResultImpl> get copyWith =>
      __$$ConsensusResultImplCopyWithImpl<_$ConsensusResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsensusResultImplToJson(this);
  }
}

abstract class _ConsensusResult implements ConsensusResult {
  const factory _ConsensusResult({
    required final double homeWinProbability,
    required final double drawProbability,
    required final double awayWinProbability,
    required final double over25Probability,
    required final double under25Probability,
    required final double bttsProbability,
    required final String predictedScore,
    required final List<String> topPredictions,
    required final String consensusReasoning,
    required final double confidenceScore,
    final bool fallback,
    final String? modelName,
  }) = _$ConsensusResultImpl;

  factory _ConsensusResult.fromJson(Map<String, dynamic> json) =
      _$ConsensusResultImpl.fromJson;

  @override
  double get homeWinProbability;
  @override
  double get drawProbability;
  @override
  double get awayWinProbability;
  @override
  double get over25Probability;
  @override
  double get under25Probability;
  @override
  double get bttsProbability;
  @override
  String get predictedScore;
  @override
  List<String> get topPredictions;
  @override
  String get consensusReasoning;
  @override
  double get confidenceScore;
  @override
  bool get fallback;
  @override
  String? get modelName;

  /// Create a copy of ConsensusResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsensusResultImplCopyWith<_$ConsensusResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
