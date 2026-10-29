import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// iOS can move an app's data container during an update/reinstall. Recover
/// only the same relative file in the current container, without rewriting
/// archive records or searching for a matching filename elsewhere.
Future<String> resolveRelocatedIosArchivePath(
  String archivePath, {
  String? documentsPath,
}) async {
  if (!p.isAbsolute(archivePath) || await File(archivePath).exists()) {
    return archivePath;
  }
  final documents =
      documentsPath ?? (await getApplicationDocumentsDirectory()).path;
  final currentRoot = p.dirname(documents);
  final applicationDirectory = p.dirname(currentRoot);
  final original = p.normalize(archivePath);
  if (!p.isWithin(applicationDirectory, original)) return archivePath;
  final parts = p.split(p.relative(original, from: applicationDirectory));
  if (parts.length < 3 ||
      !RegExp(r'^[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}$')
          .hasMatch(parts.first) ||
      !const {'Documents', 'Library', 'tmp'}.contains(parts[1])) {
    return archivePath;
  }
  final candidate = p.joinAll([currentRoot, ...parts.skip(1)]);
  return p.isWithin(currentRoot, candidate) && await File(candidate).exists()
      ? candidate
      : archivePath;
}
