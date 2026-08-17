// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skill_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SkillNode {

 Upgrade get id;@JsonKey(fromJson: _vector2FromJson, toJson: _vector2ToJson) Vector2 get position; NodeState get state; ActivationLevel get activationLevel; List<Upgrade> get connectedNodeIds; int get currentLevel;
/// Create a copy of SkillNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkillNodeCopyWith<SkillNode> get copyWith => _$SkillNodeCopyWithImpl<SkillNode>(this as SkillNode, _$identity);

  /// Serializes this SkillNode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkillNode&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.state, state) || other.state == state)&&(identical(other.activationLevel, activationLevel) || other.activationLevel == activationLevel)&&const DeepCollectionEquality().equals(other.connectedNodeIds, connectedNodeIds)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,position,state,activationLevel,const DeepCollectionEquality().hash(connectedNodeIds),currentLevel);

@override
String toString() {
  return 'SkillNode(id: $id, position: $position, state: $state, activationLevel: $activationLevel, connectedNodeIds: $connectedNodeIds, currentLevel: $currentLevel)';
}


}

/// @nodoc
abstract mixin class $SkillNodeCopyWith<$Res>  {
  factory $SkillNodeCopyWith(SkillNode value, $Res Function(SkillNode) _then) = _$SkillNodeCopyWithImpl;
@useResult
$Res call({
 Upgrade id,@JsonKey(fromJson: _vector2FromJson, toJson: _vector2ToJson) Vector2 position, NodeState state, ActivationLevel activationLevel, List<Upgrade> connectedNodeIds, int currentLevel
});




}
/// @nodoc
class _$SkillNodeCopyWithImpl<$Res>
    implements $SkillNodeCopyWith<$Res> {
  _$SkillNodeCopyWithImpl(this._self, this._then);

  final SkillNode _self;
  final $Res Function(SkillNode) _then;

/// Create a copy of SkillNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? position = null,Object? state = null,Object? activationLevel = null,Object? connectedNodeIds = null,Object? currentLevel = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Upgrade,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Vector2,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as NodeState,activationLevel: null == activationLevel ? _self.activationLevel : activationLevel // ignore: cast_nullable_to_non_nullable
as ActivationLevel,connectedNodeIds: null == connectedNodeIds ? _self.connectedNodeIds : connectedNodeIds // ignore: cast_nullable_to_non_nullable
as List<Upgrade>,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SkillNode].
extension SkillNodePatterns on SkillNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkillNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkillNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkillNode value)  $default,){
final _that = this;
switch (_that) {
case _SkillNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkillNode value)?  $default,){
final _that = this;
switch (_that) {
case _SkillNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Upgrade id, @JsonKey(fromJson: _vector2FromJson, toJson: _vector2ToJson)  Vector2 position,  NodeState state,  ActivationLevel activationLevel,  List<Upgrade> connectedNodeIds,  int currentLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkillNode() when $default != null:
return $default(_that.id,_that.position,_that.state,_that.activationLevel,_that.connectedNodeIds,_that.currentLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Upgrade id, @JsonKey(fromJson: _vector2FromJson, toJson: _vector2ToJson)  Vector2 position,  NodeState state,  ActivationLevel activationLevel,  List<Upgrade> connectedNodeIds,  int currentLevel)  $default,) {final _that = this;
switch (_that) {
case _SkillNode():
return $default(_that.id,_that.position,_that.state,_that.activationLevel,_that.connectedNodeIds,_that.currentLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Upgrade id, @JsonKey(fromJson: _vector2FromJson, toJson: _vector2ToJson)  Vector2 position,  NodeState state,  ActivationLevel activationLevel,  List<Upgrade> connectedNodeIds,  int currentLevel)?  $default,) {final _that = this;
switch (_that) {
case _SkillNode() when $default != null:
return $default(_that.id,_that.position,_that.state,_that.activationLevel,_that.connectedNodeIds,_that.currentLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkillNode extends SkillNode {
  const _SkillNode({required this.id, @JsonKey(fromJson: _vector2FromJson, toJson: _vector2ToJson) required this.position, this.state = NodeState.disabled, this.activationLevel = ActivationLevel.hidden, final  List<Upgrade> connectedNodeIds = const [], this.currentLevel = 0}): _connectedNodeIds = connectedNodeIds,super._();
  factory _SkillNode.fromJson(Map<String, dynamic> json) => _$SkillNodeFromJson(json);

@override final  Upgrade id;
@override@JsonKey(fromJson: _vector2FromJson, toJson: _vector2ToJson) final  Vector2 position;
@override@JsonKey() final  NodeState state;
@override@JsonKey() final  ActivationLevel activationLevel;
 final  List<Upgrade> _connectedNodeIds;
@override@JsonKey() List<Upgrade> get connectedNodeIds {
  if (_connectedNodeIds is EqualUnmodifiableListView) return _connectedNodeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connectedNodeIds);
}

@override@JsonKey() final  int currentLevel;

/// Create a copy of SkillNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkillNodeCopyWith<_SkillNode> get copyWith => __$SkillNodeCopyWithImpl<_SkillNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkillNodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkillNode&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.state, state) || other.state == state)&&(identical(other.activationLevel, activationLevel) || other.activationLevel == activationLevel)&&const DeepCollectionEquality().equals(other._connectedNodeIds, _connectedNodeIds)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,position,state,activationLevel,const DeepCollectionEquality().hash(_connectedNodeIds),currentLevel);

@override
String toString() {
  return 'SkillNode(id: $id, position: $position, state: $state, activationLevel: $activationLevel, connectedNodeIds: $connectedNodeIds, currentLevel: $currentLevel)';
}


}

/// @nodoc
abstract mixin class _$SkillNodeCopyWith<$Res> implements $SkillNodeCopyWith<$Res> {
  factory _$SkillNodeCopyWith(_SkillNode value, $Res Function(_SkillNode) _then) = __$SkillNodeCopyWithImpl;
@override @useResult
$Res call({
 Upgrade id,@JsonKey(fromJson: _vector2FromJson, toJson: _vector2ToJson) Vector2 position, NodeState state, ActivationLevel activationLevel, List<Upgrade> connectedNodeIds, int currentLevel
});




}
/// @nodoc
class __$SkillNodeCopyWithImpl<$Res>
    implements _$SkillNodeCopyWith<$Res> {
  __$SkillNodeCopyWithImpl(this._self, this._then);

  final _SkillNode _self;
  final $Res Function(_SkillNode) _then;

/// Create a copy of SkillNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? position = null,Object? state = null,Object? activationLevel = null,Object? connectedNodeIds = null,Object? currentLevel = null,}) {
  return _then(_SkillNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Upgrade,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Vector2,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as NodeState,activationLevel: null == activationLevel ? _self.activationLevel : activationLevel // ignore: cast_nullable_to_non_nullable
as ActivationLevel,connectedNodeIds: null == connectedNodeIds ? _self._connectedNodeIds : connectedNodeIds // ignore: cast_nullable_to_non_nullable
as List<Upgrade>,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
