// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skill_tree_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SkillTreeState {

 Map<Upgrade, SkillNode> get nodes; Upgrade? get selectedNodeId; int get unspentPoints; int get totalPoints; int get blueSquarePoints; int get totalBlueSquarePoints; int get yellowStarPoints; int get totalYellowStarPoints; int get pinkHourglassPoints; int get totalPinkHourglassPoints; int get greenCrownPoints; int get totalGreenCrownPoints;
/// Create a copy of SkillTreeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkillTreeStateCopyWith<SkillTreeState> get copyWith => _$SkillTreeStateCopyWithImpl<SkillTreeState>(this as SkillTreeState, _$identity);

  /// Serializes this SkillTreeState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkillTreeState&&const DeepCollectionEquality().equals(other.nodes, nodes)&&(identical(other.selectedNodeId, selectedNodeId) || other.selectedNodeId == selectedNodeId)&&(identical(other.unspentPoints, unspentPoints) || other.unspentPoints == unspentPoints)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.blueSquarePoints, blueSquarePoints) || other.blueSquarePoints == blueSquarePoints)&&(identical(other.totalBlueSquarePoints, totalBlueSquarePoints) || other.totalBlueSquarePoints == totalBlueSquarePoints)&&(identical(other.yellowStarPoints, yellowStarPoints) || other.yellowStarPoints == yellowStarPoints)&&(identical(other.totalYellowStarPoints, totalYellowStarPoints) || other.totalYellowStarPoints == totalYellowStarPoints)&&(identical(other.pinkHourglassPoints, pinkHourglassPoints) || other.pinkHourglassPoints == pinkHourglassPoints)&&(identical(other.totalPinkHourglassPoints, totalPinkHourglassPoints) || other.totalPinkHourglassPoints == totalPinkHourglassPoints)&&(identical(other.greenCrownPoints, greenCrownPoints) || other.greenCrownPoints == greenCrownPoints)&&(identical(other.totalGreenCrownPoints, totalGreenCrownPoints) || other.totalGreenCrownPoints == totalGreenCrownPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(nodes),selectedNodeId,unspentPoints,totalPoints,blueSquarePoints,totalBlueSquarePoints,yellowStarPoints,totalYellowStarPoints,pinkHourglassPoints,totalPinkHourglassPoints,greenCrownPoints,totalGreenCrownPoints);

@override
String toString() {
  return 'SkillTreeState(nodes: $nodes, selectedNodeId: $selectedNodeId, unspentPoints: $unspentPoints, totalPoints: $totalPoints, blueSquarePoints: $blueSquarePoints, totalBlueSquarePoints: $totalBlueSquarePoints, yellowStarPoints: $yellowStarPoints, totalYellowStarPoints: $totalYellowStarPoints, pinkHourglassPoints: $pinkHourglassPoints, totalPinkHourglassPoints: $totalPinkHourglassPoints, greenCrownPoints: $greenCrownPoints, totalGreenCrownPoints: $totalGreenCrownPoints)';
}


}

/// @nodoc
abstract mixin class $SkillTreeStateCopyWith<$Res>  {
  factory $SkillTreeStateCopyWith(SkillTreeState value, $Res Function(SkillTreeState) _then) = _$SkillTreeStateCopyWithImpl;
@useResult
$Res call({
 Map<Upgrade, SkillNode> nodes, Upgrade? selectedNodeId, int unspentPoints, int totalPoints, int blueSquarePoints, int totalBlueSquarePoints, int yellowStarPoints, int totalYellowStarPoints, int pinkHourglassPoints, int totalPinkHourglassPoints, int greenCrownPoints, int totalGreenCrownPoints
});




}
/// @nodoc
class _$SkillTreeStateCopyWithImpl<$Res>
    implements $SkillTreeStateCopyWith<$Res> {
  _$SkillTreeStateCopyWithImpl(this._self, this._then);

  final SkillTreeState _self;
  final $Res Function(SkillTreeState) _then;

/// Create a copy of SkillTreeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nodes = null,Object? selectedNodeId = freezed,Object? unspentPoints = null,Object? totalPoints = null,Object? blueSquarePoints = null,Object? totalBlueSquarePoints = null,Object? yellowStarPoints = null,Object? totalYellowStarPoints = null,Object? pinkHourglassPoints = null,Object? totalPinkHourglassPoints = null,Object? greenCrownPoints = null,Object? totalGreenCrownPoints = null,}) {
  return _then(_self.copyWith(
nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as Map<Upgrade, SkillNode>,selectedNodeId: freezed == selectedNodeId ? _self.selectedNodeId : selectedNodeId // ignore: cast_nullable_to_non_nullable
as Upgrade?,unspentPoints: null == unspentPoints ? _self.unspentPoints : unspentPoints // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,blueSquarePoints: null == blueSquarePoints ? _self.blueSquarePoints : blueSquarePoints // ignore: cast_nullable_to_non_nullable
as int,totalBlueSquarePoints: null == totalBlueSquarePoints ? _self.totalBlueSquarePoints : totalBlueSquarePoints // ignore: cast_nullable_to_non_nullable
as int,yellowStarPoints: null == yellowStarPoints ? _self.yellowStarPoints : yellowStarPoints // ignore: cast_nullable_to_non_nullable
as int,totalYellowStarPoints: null == totalYellowStarPoints ? _self.totalYellowStarPoints : totalYellowStarPoints // ignore: cast_nullable_to_non_nullable
as int,pinkHourglassPoints: null == pinkHourglassPoints ? _self.pinkHourglassPoints : pinkHourglassPoints // ignore: cast_nullable_to_non_nullable
as int,totalPinkHourglassPoints: null == totalPinkHourglassPoints ? _self.totalPinkHourglassPoints : totalPinkHourglassPoints // ignore: cast_nullable_to_non_nullable
as int,greenCrownPoints: null == greenCrownPoints ? _self.greenCrownPoints : greenCrownPoints // ignore: cast_nullable_to_non_nullable
as int,totalGreenCrownPoints: null == totalGreenCrownPoints ? _self.totalGreenCrownPoints : totalGreenCrownPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SkillTreeState].
extension SkillTreeStatePatterns on SkillTreeState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkillTreeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkillTreeState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkillTreeState value)  $default,){
final _that = this;
switch (_that) {
case _SkillTreeState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkillTreeState value)?  $default,){
final _that = this;
switch (_that) {
case _SkillTreeState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<Upgrade, SkillNode> nodes,  Upgrade? selectedNodeId,  int unspentPoints,  int totalPoints,  int blueSquarePoints,  int totalBlueSquarePoints,  int yellowStarPoints,  int totalYellowStarPoints,  int pinkHourglassPoints,  int totalPinkHourglassPoints,  int greenCrownPoints,  int totalGreenCrownPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkillTreeState() when $default != null:
return $default(_that.nodes,_that.selectedNodeId,_that.unspentPoints,_that.totalPoints,_that.blueSquarePoints,_that.totalBlueSquarePoints,_that.yellowStarPoints,_that.totalYellowStarPoints,_that.pinkHourglassPoints,_that.totalPinkHourglassPoints,_that.greenCrownPoints,_that.totalGreenCrownPoints);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<Upgrade, SkillNode> nodes,  Upgrade? selectedNodeId,  int unspentPoints,  int totalPoints,  int blueSquarePoints,  int totalBlueSquarePoints,  int yellowStarPoints,  int totalYellowStarPoints,  int pinkHourglassPoints,  int totalPinkHourglassPoints,  int greenCrownPoints,  int totalGreenCrownPoints)  $default,) {final _that = this;
switch (_that) {
case _SkillTreeState():
return $default(_that.nodes,_that.selectedNodeId,_that.unspentPoints,_that.totalPoints,_that.blueSquarePoints,_that.totalBlueSquarePoints,_that.yellowStarPoints,_that.totalYellowStarPoints,_that.pinkHourglassPoints,_that.totalPinkHourglassPoints,_that.greenCrownPoints,_that.totalGreenCrownPoints);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<Upgrade, SkillNode> nodes,  Upgrade? selectedNodeId,  int unspentPoints,  int totalPoints,  int blueSquarePoints,  int totalBlueSquarePoints,  int yellowStarPoints,  int totalYellowStarPoints,  int pinkHourglassPoints,  int totalPinkHourglassPoints,  int greenCrownPoints,  int totalGreenCrownPoints)?  $default,) {final _that = this;
switch (_that) {
case _SkillTreeState() when $default != null:
return $default(_that.nodes,_that.selectedNodeId,_that.unspentPoints,_that.totalPoints,_that.blueSquarePoints,_that.totalBlueSquarePoints,_that.yellowStarPoints,_that.totalYellowStarPoints,_that.pinkHourglassPoints,_that.totalPinkHourglassPoints,_that.greenCrownPoints,_that.totalGreenCrownPoints);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkillTreeState implements SkillTreeState {
  const _SkillTreeState({final  Map<Upgrade, SkillNode> nodes = const {}, this.selectedNodeId, this.unspentPoints = 100, this.totalPoints = 100000, this.blueSquarePoints = 100, this.totalBlueSquarePoints = 100000, this.yellowStarPoints = 0, this.totalYellowStarPoints = 19, this.pinkHourglassPoints = 0, this.totalPinkHourglassPoints = 36, this.greenCrownPoints = 0, this.totalGreenCrownPoints = 36}): _nodes = nodes;
  factory _SkillTreeState.fromJson(Map<String, dynamic> json) => _$SkillTreeStateFromJson(json);

 final  Map<Upgrade, SkillNode> _nodes;
@override@JsonKey() Map<Upgrade, SkillNode> get nodes {
  if (_nodes is EqualUnmodifiableMapView) return _nodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_nodes);
}

@override final  Upgrade? selectedNodeId;
@override@JsonKey() final  int unspentPoints;
@override@JsonKey() final  int totalPoints;
@override@JsonKey() final  int blueSquarePoints;
@override@JsonKey() final  int totalBlueSquarePoints;
@override@JsonKey() final  int yellowStarPoints;
@override@JsonKey() final  int totalYellowStarPoints;
@override@JsonKey() final  int pinkHourglassPoints;
@override@JsonKey() final  int totalPinkHourglassPoints;
@override@JsonKey() final  int greenCrownPoints;
@override@JsonKey() final  int totalGreenCrownPoints;

/// Create a copy of SkillTreeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkillTreeStateCopyWith<_SkillTreeState> get copyWith => __$SkillTreeStateCopyWithImpl<_SkillTreeState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkillTreeStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkillTreeState&&const DeepCollectionEquality().equals(other._nodes, _nodes)&&(identical(other.selectedNodeId, selectedNodeId) || other.selectedNodeId == selectedNodeId)&&(identical(other.unspentPoints, unspentPoints) || other.unspentPoints == unspentPoints)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.blueSquarePoints, blueSquarePoints) || other.blueSquarePoints == blueSquarePoints)&&(identical(other.totalBlueSquarePoints, totalBlueSquarePoints) || other.totalBlueSquarePoints == totalBlueSquarePoints)&&(identical(other.yellowStarPoints, yellowStarPoints) || other.yellowStarPoints == yellowStarPoints)&&(identical(other.totalYellowStarPoints, totalYellowStarPoints) || other.totalYellowStarPoints == totalYellowStarPoints)&&(identical(other.pinkHourglassPoints, pinkHourglassPoints) || other.pinkHourglassPoints == pinkHourglassPoints)&&(identical(other.totalPinkHourglassPoints, totalPinkHourglassPoints) || other.totalPinkHourglassPoints == totalPinkHourglassPoints)&&(identical(other.greenCrownPoints, greenCrownPoints) || other.greenCrownPoints == greenCrownPoints)&&(identical(other.totalGreenCrownPoints, totalGreenCrownPoints) || other.totalGreenCrownPoints == totalGreenCrownPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_nodes),selectedNodeId,unspentPoints,totalPoints,blueSquarePoints,totalBlueSquarePoints,yellowStarPoints,totalYellowStarPoints,pinkHourglassPoints,totalPinkHourglassPoints,greenCrownPoints,totalGreenCrownPoints);

@override
String toString() {
  return 'SkillTreeState(nodes: $nodes, selectedNodeId: $selectedNodeId, unspentPoints: $unspentPoints, totalPoints: $totalPoints, blueSquarePoints: $blueSquarePoints, totalBlueSquarePoints: $totalBlueSquarePoints, yellowStarPoints: $yellowStarPoints, totalYellowStarPoints: $totalYellowStarPoints, pinkHourglassPoints: $pinkHourglassPoints, totalPinkHourglassPoints: $totalPinkHourglassPoints, greenCrownPoints: $greenCrownPoints, totalGreenCrownPoints: $totalGreenCrownPoints)';
}


}

/// @nodoc
abstract mixin class _$SkillTreeStateCopyWith<$Res> implements $SkillTreeStateCopyWith<$Res> {
  factory _$SkillTreeStateCopyWith(_SkillTreeState value, $Res Function(_SkillTreeState) _then) = __$SkillTreeStateCopyWithImpl;
@override @useResult
$Res call({
 Map<Upgrade, SkillNode> nodes, Upgrade? selectedNodeId, int unspentPoints, int totalPoints, int blueSquarePoints, int totalBlueSquarePoints, int yellowStarPoints, int totalYellowStarPoints, int pinkHourglassPoints, int totalPinkHourglassPoints, int greenCrownPoints, int totalGreenCrownPoints
});




}
/// @nodoc
class __$SkillTreeStateCopyWithImpl<$Res>
    implements _$SkillTreeStateCopyWith<$Res> {
  __$SkillTreeStateCopyWithImpl(this._self, this._then);

  final _SkillTreeState _self;
  final $Res Function(_SkillTreeState) _then;

/// Create a copy of SkillTreeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nodes = null,Object? selectedNodeId = freezed,Object? unspentPoints = null,Object? totalPoints = null,Object? blueSquarePoints = null,Object? totalBlueSquarePoints = null,Object? yellowStarPoints = null,Object? totalYellowStarPoints = null,Object? pinkHourglassPoints = null,Object? totalPinkHourglassPoints = null,Object? greenCrownPoints = null,Object? totalGreenCrownPoints = null,}) {
  return _then(_SkillTreeState(
nodes: null == nodes ? _self._nodes : nodes // ignore: cast_nullable_to_non_nullable
as Map<Upgrade, SkillNode>,selectedNodeId: freezed == selectedNodeId ? _self.selectedNodeId : selectedNodeId // ignore: cast_nullable_to_non_nullable
as Upgrade?,unspentPoints: null == unspentPoints ? _self.unspentPoints : unspentPoints // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,blueSquarePoints: null == blueSquarePoints ? _self.blueSquarePoints : blueSquarePoints // ignore: cast_nullable_to_non_nullable
as int,totalBlueSquarePoints: null == totalBlueSquarePoints ? _self.totalBlueSquarePoints : totalBlueSquarePoints // ignore: cast_nullable_to_non_nullable
as int,yellowStarPoints: null == yellowStarPoints ? _self.yellowStarPoints : yellowStarPoints // ignore: cast_nullable_to_non_nullable
as int,totalYellowStarPoints: null == totalYellowStarPoints ? _self.totalYellowStarPoints : totalYellowStarPoints // ignore: cast_nullable_to_non_nullable
as int,pinkHourglassPoints: null == pinkHourglassPoints ? _self.pinkHourglassPoints : pinkHourglassPoints // ignore: cast_nullable_to_non_nullable
as int,totalPinkHourglassPoints: null == totalPinkHourglassPoints ? _self.totalPinkHourglassPoints : totalPinkHourglassPoints // ignore: cast_nullable_to_non_nullable
as int,greenCrownPoints: null == greenCrownPoints ? _self.greenCrownPoints : greenCrownPoints // ignore: cast_nullable_to_non_nullable
as int,totalGreenCrownPoints: null == totalGreenCrownPoints ? _self.totalGreenCrownPoints : totalGreenCrownPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
