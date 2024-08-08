// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatSession _$ChatSessionFromJson(Map<String, dynamic> json) {
  return _ChatSession.fromJson(json);
}

/// @nodoc
mixin _$ChatSession {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  List<ChatMessage> get messages => throw _privateConstructorUsedError;
  @HiveField(2)
  DateTime? get updateTimestamp => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime? get createTimestamp => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get title => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatSessionCopyWith<ChatSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatSessionCopyWith<$Res> {
  factory $ChatSessionCopyWith(
          ChatSession value, $Res Function(ChatSession) then) =
      _$ChatSessionCopyWithImpl<$Res, ChatSession>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) List<ChatMessage> messages,
      @HiveField(2) DateTime? updateTimestamp,
      @HiveField(3) DateTime? createTimestamp,
      @HiveField(4) String? title});
}

/// @nodoc
class _$ChatSessionCopyWithImpl<$Res, $Val extends ChatSession>
    implements $ChatSessionCopyWith<$Res> {
  _$ChatSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? messages = null,
    Object? updateTimestamp = freezed,
    Object? createTimestamp = freezed,
    Object? title = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      updateTimestamp: freezed == updateTimestamp
          ? _value.updateTimestamp
          : updateTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createTimestamp: freezed == createTimestamp
          ? _value.createTimestamp
          : createTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatSessionImplCopyWith<$Res>
    implements $ChatSessionCopyWith<$Res> {
  factory _$$ChatSessionImplCopyWith(
          _$ChatSessionImpl value, $Res Function(_$ChatSessionImpl) then) =
      __$$ChatSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) List<ChatMessage> messages,
      @HiveField(2) DateTime? updateTimestamp,
      @HiveField(3) DateTime? createTimestamp,
      @HiveField(4) String? title});
}

/// @nodoc
class __$$ChatSessionImplCopyWithImpl<$Res>
    extends _$ChatSessionCopyWithImpl<$Res, _$ChatSessionImpl>
    implements _$$ChatSessionImplCopyWith<$Res> {
  __$$ChatSessionImplCopyWithImpl(
      _$ChatSessionImpl _value, $Res Function(_$ChatSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? messages = null,
    Object? updateTimestamp = freezed,
    Object? createTimestamp = freezed,
    Object? title = freezed,
  }) {
    return _then(_$ChatSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      updateTimestamp: freezed == updateTimestamp
          ? _value.updateTimestamp
          : updateTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createTimestamp: freezed == createTimestamp
          ? _value.createTimestamp
          : createTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 1, adapterName: 'ChatSessionAdapter')
class _$ChatSessionImpl implements _ChatSession {
  const _$ChatSessionImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required final List<ChatMessage> messages,
      @HiveField(2) this.updateTimestamp,
      @HiveField(3) this.createTimestamp,
      @HiveField(4) this.title})
      : _messages = messages;

  factory _$ChatSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatSessionImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  final List<ChatMessage> _messages;
  @override
  @HiveField(1)
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @HiveField(2)
  final DateTime? updateTimestamp;
  @override
  @HiveField(3)
  final DateTime? createTimestamp;
  @override
  @HiveField(4)
  final String? title;

  @override
  String toString() {
    return 'ChatSession(id: $id, messages: $messages, updateTimestamp: $updateTimestamp, createTimestamp: $createTimestamp, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.updateTimestamp, updateTimestamp) ||
                other.updateTimestamp == updateTimestamp) &&
            (identical(other.createTimestamp, createTimestamp) ||
                other.createTimestamp == createTimestamp) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_messages),
      updateTimestamp,
      createTimestamp,
      title);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatSessionImplCopyWith<_$ChatSessionImpl> get copyWith =>
      __$$ChatSessionImplCopyWithImpl<_$ChatSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatSessionImplToJson(
      this,
    );
  }
}

abstract class _ChatSession implements ChatSession {
  const factory _ChatSession(
      {@HiveField(0) required final String id,
      @HiveField(1) required final List<ChatMessage> messages,
      @HiveField(2) final DateTime? updateTimestamp,
      @HiveField(3) final DateTime? createTimestamp,
      @HiveField(4) final String? title}) = _$ChatSessionImpl;

  factory _ChatSession.fromJson(Map<String, dynamic> json) =
      _$ChatSessionImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  List<ChatMessage> get messages;
  @override
  @HiveField(2)
  DateTime? get updateTimestamp;
  @override
  @HiveField(3)
  DateTime? get createTimestamp;
  @override
  @HiveField(4)
  String? get title;
  @override
  @JsonKey(ignore: true)
  _$$ChatSessionImplCopyWith<_$ChatSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
