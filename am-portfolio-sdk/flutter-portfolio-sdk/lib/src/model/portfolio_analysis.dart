//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:am_portfolio_client/src/model/time_interval.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'portfolio_analysis.g.dart';

/// PortfolioAnalysis
///
/// Properties:
/// * [portfolioId] 
/// * [lastUpdated] 
/// * [currentInterval] 
@BuiltValue()
abstract class PortfolioAnalysis implements Built<PortfolioAnalysis, PortfolioAnalysisBuilder> {
  @BuiltValueField(wireName: r'portfolioId')
  String? get portfolioId;

  @BuiltValueField(wireName: r'lastUpdated')
  DateTime? get lastUpdated;

  @BuiltValueField(wireName: r'currentInterval')
  TimeInterval? get currentInterval;
  // enum currentIntervalEnum {  1D,  1W,  1M,  1Y,  ALL,  };

  PortfolioAnalysis._();

  factory PortfolioAnalysis([void updates(PortfolioAnalysisBuilder b)]) = _$PortfolioAnalysis;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PortfolioAnalysisBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PortfolioAnalysis> get serializer => _$PortfolioAnalysisSerializer();
}

class _$PortfolioAnalysisSerializer implements PrimitiveSerializer<PortfolioAnalysis> {
  @override
  final Iterable<Type> types = const [PortfolioAnalysis, _$PortfolioAnalysis];

  @override
  final String wireName = r'PortfolioAnalysis';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PortfolioAnalysis object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.portfolioId != null) {
      yield r'portfolioId';
      yield serializers.serialize(
        object.portfolioId,
        specifiedType: const FullType(String),
      );
    }
    if (object.lastUpdated != null) {
      yield r'lastUpdated';
      yield serializers.serialize(
        object.lastUpdated,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.currentInterval != null) {
      yield r'currentInterval';
      yield serializers.serialize(
        object.currentInterval,
        specifiedType: const FullType(TimeInterval),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PortfolioAnalysis object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PortfolioAnalysisBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'portfolioId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.portfolioId = valueDes;
          break;
        case r'lastUpdated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.lastUpdated = valueDes;
          break;
        case r'currentInterval':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TimeInterval),
          ) as TimeInterval;
          result.currentInterval = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PortfolioAnalysis deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PortfolioAnalysisBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

