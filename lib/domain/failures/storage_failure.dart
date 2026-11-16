/// Why the progress could not be read or saved on the device.
///
/// A broken rule of the storage itself, such as the same chapter opened
/// twice, is a bug and is not one of these.
sealed class StorageFailure implements Exception {
  const StorageFailure();
}

/// The device has no free space. The user can free some and try again.
final class StorageFull extends StorageFailure {
  /// Creates the failure.
  const StorageFull();

  @override
  String toString() => 'StorageFull()';
}

/// The storage cannot be used: its file is damaged or cannot be opened.
/// The user can do nothing about it; the caller reports [cause].
final class StorageUnavailable extends StorageFailure {
  /// Creates the failure caused by [cause], the error of the storage.
  const StorageUnavailable(this.cause);

  /// The original error, for the crash report.
  final Object cause;

  @override
  String toString() => 'StorageUnavailable($cause)';
}
