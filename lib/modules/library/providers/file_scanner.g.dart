// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_scanner.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalFoldersState)
final localFoldersStateProvider = LocalFoldersStateProvider._();

final class LocalFoldersStateProvider
    extends $NotifierProvider<LocalFoldersState, List<LocalFolder>> {
  LocalFoldersStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localFoldersStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localFoldersStateHash();

  @$internal
  @override
  LocalFoldersState create() => LocalFoldersState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LocalFolder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LocalFolder>>(value),
    );
  }
}

String _$localFoldersStateHash() => r'5b96eab0eccfc3bac0d60a2f40de19eb9fdd8665';

abstract class _$LocalFoldersState extends $Notifier<List<LocalFolder>> {
  List<LocalFolder> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<LocalFolder>, List<LocalFolder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<LocalFolder>, List<LocalFolder>>,
              List<LocalFolder>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Scans the app's `local` folder and configured folders for library entries.

@ProviderFor(scanLocalLibrary)
final scanLocalLibraryProvider = ScanLocalLibraryProvider._();

/// Scans the app's `local` folder and configured folders for library entries.

final class ScanLocalLibraryProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Scans the app's `local` folder and configured folders for library entries.
  ScanLocalLibraryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanLocalLibraryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanLocalLibraryHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return scanLocalLibrary(ref);
  }
}

String _$scanLocalLibraryHash() => r'8461d8213bdd030b601a9665dd1a4d752ecd6243';
