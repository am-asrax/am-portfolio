//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'time_interval.g.dart';

class TimeInterval extends EnumClass {

  @BuiltValueEnumConst(wireName: r'1D')
  static const TimeInterval n1d = _$n1d;
  @BuiltValueEnumConst(wireName: r'1W')
  static const TimeInterval n1w = _$n1w;
  @BuiltValueEnumConst(wireName: r'1M')
  static const TimeInterval n1m = _$n1m;
  @BuiltValueEnumConst(wireName: r'1Y')
  static const TimeInterval n1y = _$n1y;
  @BuiltValueEnumConst(wireName: r'ALL')
  static const TimeInterval ALL = _$ALL;

  static Serializer<TimeInterval> get serializer => _$timeIntervalSerializer;

  const TimeInterval._(String name): super(name);

  static BuiltSet<TimeInterval> get values => _$values;
  static TimeInterval valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class TimeIntervalMixin = Object with _$TimeIntervalMixin;

