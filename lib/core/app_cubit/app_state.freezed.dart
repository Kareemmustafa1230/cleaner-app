// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(bool isDark) themeChangeMode,
    required TResult Function(Locale locale) languageChange,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(bool isDark)? themeChangeMode,
    TResult? Function(Locale locale)? languageChange,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(bool isDark)? themeChangeMode,
    TResult Function(Locale locale)? languageChange,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(ThemeChangeModeState<T> value) themeChangeMode,
    required TResult Function(LanguageChangeState<T> value) languageChange,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(ThemeChangeModeState<T> value)? themeChangeMode,
    TResult? Function(LanguageChangeState<T> value)? languageChange,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(ThemeChangeModeState<T> value)? themeChangeMode,
    TResult Function(LanguageChangeState<T> value)? languageChange,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateCopyWith<T, $Res> {
  factory $AppStateCopyWith(
          AppState<T> value, $Res Function(AppState<T>) then) =
      _$AppStateCopyWithImpl<T, $Res, AppState<T>>;
}

/// @nodoc
class _$AppStateCopyWithImpl<T, $Res, $Val extends AppState<T>>
    implements $AppStateCopyWith<T, $Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<T, $Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl<T> value, $Res Function(_$InitialImpl<T>) then) =
      __$$InitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<T, $Res>
    extends _$AppStateCopyWithImpl<T, $Res, _$InitialImpl<T>>
    implements _$$InitialImplCopyWith<T, $Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl<T> _value, $Res Function(_$InitialImpl<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialImpl<T> implements _Initial<T> {
  const _$InitialImpl();

  @override
  String toString() {
    return 'AppState<$T>.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(bool isDark) themeChangeMode,
    required TResult Function(Locale locale) languageChange,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(bool isDark)? themeChangeMode,
    TResult? Function(Locale locale)? languageChange,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(bool isDark)? themeChangeMode,
    TResult Function(Locale locale)? languageChange,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(ThemeChangeModeState<T> value) themeChangeMode,
    required TResult Function(LanguageChangeState<T> value) languageChange,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(ThemeChangeModeState<T> value)? themeChangeMode,
    TResult? Function(LanguageChangeState<T> value)? languageChange,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(ThemeChangeModeState<T> value)? themeChangeMode,
    TResult Function(LanguageChangeState<T> value)? languageChange,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial<T> implements AppState<T> {
  const factory _Initial() = _$InitialImpl<T>;
}

/// @nodoc
abstract class _$$ThemeChangeModeStateImplCopyWith<T, $Res> {
  factory _$$ThemeChangeModeStateImplCopyWith(
          _$ThemeChangeModeStateImpl<T> value,
          $Res Function(_$ThemeChangeModeStateImpl<T>) then) =
      __$$ThemeChangeModeStateImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({bool isDark});
}

/// @nodoc
class __$$ThemeChangeModeStateImplCopyWithImpl<T, $Res>
    extends _$AppStateCopyWithImpl<T, $Res, _$ThemeChangeModeStateImpl<T>>
    implements _$$ThemeChangeModeStateImplCopyWith<T, $Res> {
  __$$ThemeChangeModeStateImplCopyWithImpl(_$ThemeChangeModeStateImpl<T> _value,
      $Res Function(_$ThemeChangeModeStateImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDark = null,
  }) {
    return _then(_$ThemeChangeModeStateImpl<T>(
      isDark: null == isDark
          ? _value.isDark
          : isDark // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ThemeChangeModeStateImpl<T> implements ThemeChangeModeState<T> {
  const _$ThemeChangeModeStateImpl({required this.isDark});

  @override
  final bool isDark;

  @override
  String toString() {
    return 'AppState<$T>.themeChangeMode(isDark: $isDark)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeChangeModeStateImpl<T> &&
            (identical(other.isDark, isDark) || other.isDark == isDark));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isDark);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeChangeModeStateImplCopyWith<T, _$ThemeChangeModeStateImpl<T>>
      get copyWith => __$$ThemeChangeModeStateImplCopyWithImpl<T,
          _$ThemeChangeModeStateImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(bool isDark) themeChangeMode,
    required TResult Function(Locale locale) languageChange,
  }) {
    return themeChangeMode(isDark);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(bool isDark)? themeChangeMode,
    TResult? Function(Locale locale)? languageChange,
  }) {
    return themeChangeMode?.call(isDark);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(bool isDark)? themeChangeMode,
    TResult Function(Locale locale)? languageChange,
    required TResult orElse(),
  }) {
    if (themeChangeMode != null) {
      return themeChangeMode(isDark);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(ThemeChangeModeState<T> value) themeChangeMode,
    required TResult Function(LanguageChangeState<T> value) languageChange,
  }) {
    return themeChangeMode(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(ThemeChangeModeState<T> value)? themeChangeMode,
    TResult? Function(LanguageChangeState<T> value)? languageChange,
  }) {
    return themeChangeMode?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(ThemeChangeModeState<T> value)? themeChangeMode,
    TResult Function(LanguageChangeState<T> value)? languageChange,
    required TResult orElse(),
  }) {
    if (themeChangeMode != null) {
      return themeChangeMode(this);
    }
    return orElse();
  }
}

abstract class ThemeChangeModeState<T> implements AppState<T> {
  const factory ThemeChangeModeState({required final bool isDark}) =
      _$ThemeChangeModeStateImpl<T>;

  bool get isDark;
  @JsonKey(ignore: true)
  _$$ThemeChangeModeStateImplCopyWith<T, _$ThemeChangeModeStateImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LanguageChangeStateImplCopyWith<T, $Res> {
  factory _$$LanguageChangeStateImplCopyWith(_$LanguageChangeStateImpl<T> value,
          $Res Function(_$LanguageChangeStateImpl<T>) then) =
      __$$LanguageChangeStateImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({Locale locale});
}

/// @nodoc
class __$$LanguageChangeStateImplCopyWithImpl<T, $Res>
    extends _$AppStateCopyWithImpl<T, $Res, _$LanguageChangeStateImpl<T>>
    implements _$$LanguageChangeStateImplCopyWith<T, $Res> {
  __$$LanguageChangeStateImplCopyWithImpl(_$LanguageChangeStateImpl<T> _value,
      $Res Function(_$LanguageChangeStateImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locale = null,
  }) {
    return _then(_$LanguageChangeStateImpl<T>(
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as Locale,
    ));
  }
}

/// @nodoc

class _$LanguageChangeStateImpl<T> implements LanguageChangeState<T> {
  const _$LanguageChangeStateImpl({required this.locale});

  @override
  final Locale locale;

  @override
  String toString() {
    return 'AppState<$T>.languageChange(locale: $locale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageChangeStateImpl<T> &&
            (identical(other.locale, locale) || other.locale == locale));
  }

  @override
  int get hashCode => Object.hash(runtimeType, locale);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageChangeStateImplCopyWith<T, _$LanguageChangeStateImpl<T>>
      get copyWith => __$$LanguageChangeStateImplCopyWithImpl<T,
          _$LanguageChangeStateImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(bool isDark) themeChangeMode,
    required TResult Function(Locale locale) languageChange,
  }) {
    return languageChange(locale);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(bool isDark)? themeChangeMode,
    TResult? Function(Locale locale)? languageChange,
  }) {
    return languageChange?.call(locale);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(bool isDark)? themeChangeMode,
    TResult Function(Locale locale)? languageChange,
    required TResult orElse(),
  }) {
    if (languageChange != null) {
      return languageChange(locale);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(ThemeChangeModeState<T> value) themeChangeMode,
    required TResult Function(LanguageChangeState<T> value) languageChange,
  }) {
    return languageChange(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(ThemeChangeModeState<T> value)? themeChangeMode,
    TResult? Function(LanguageChangeState<T> value)? languageChange,
  }) {
    return languageChange?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(ThemeChangeModeState<T> value)? themeChangeMode,
    TResult Function(LanguageChangeState<T> value)? languageChange,
    required TResult orElse(),
  }) {
    if (languageChange != null) {
      return languageChange(this);
    }
    return orElse();
  }
}

abstract class LanguageChangeState<T> implements AppState<T> {
  const factory LanguageChangeState({required final Locale locale}) =
      _$LanguageChangeStateImpl<T>;

  Locale get locale;
  @JsonKey(ignore: true)
  _$$LanguageChangeStateImplCopyWith<T, _$LanguageChangeStateImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
