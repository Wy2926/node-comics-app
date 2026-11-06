import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/source_catalog_config.dart';

class SourceInstallationPaused implements Exception {
  const SourceInstallationPaused();
}

class SourcePackage {
  final String repositoryId;
  final String slug;
  final String hash;
  final int size;
  final List<String> requestHosts;
  final List<String> requires;

  SourcePackage._(
    this.repositoryId,
    this.slug,
    this.hash,
    this.size,
    this.requestHosts,
    this.requires,
  );

  static SourcePackage? of(Source source) {
    if (source.packageInfoJson == null) return null;
    try {
      final m = jsonDecode(source.packageInfoJson!) as Map<String, dynamic>;
      final hosts = (m['requestHosts'] as List).cast<String>();
      final required = (m['requires'] as List).cast<String>();
      if (m['schema'] != 1 ||
          m['repositoryId'] != nodeLaneRepositoryId ||
          !RegExp(r'^[a-z][a-z0-9-]{1,39}$').hasMatch(m['slug'] as String) ||
          !RegExp(r'^[a-f0-9]{64}$').hasMatch(m['sha256'] as String) ||
          m['size'] is! int ||
          m['size'] <= 0 ||
          m['size'] > 1024 * 1024 ||
          hosts.isEmpty ||
          !hosts.contains(Uri.parse(source.baseUrl!).host) ||
          hosts.any(
            (h) =>
                !RegExp(r'^[a-z0-9]+([.-][a-z0-9]+)*\.[a-z]{2,}$').hasMatch(h),
          )) {
        throw const FormatException();
      }
      return SourcePackage._(
        m['repositoryId'],
        m['slug'],
        m['sha256'],
        m['size'],
        hosts,
        required,
      );
    } catch (_) {
      throw StateError('插件分发元数据无效，已保留已安装版本');
    }
  }

  bool get compatible => requires.every(nodeLaneHostCapabilities.contains);

  void checkRequest(Uri uri) {
    if (uri.scheme != 'https' ||
        uri.userInfo.isNotEmpty ||
        uri.port != 443 ||
        !requestHosts.contains(uri.host)) {
      throw StateError('插件请求超出已声明的网站范围');
    }
  }
}

bool canReplaceSource(Source existing, Source incoming, String indexUrl) {
  if (existing.repo?.jsonUrl == indexUrl) {
    final old = SourcePackage.of(existing), next = SourcePackage.of(incoming);
    return old == null ||
        (next?.repositoryId == old.repositoryId && next?.slug == old.slug);
  }
  // Only the explicitly configured official endpoint may migrate its identity.
  if (indexUrl != nodeLaneCatalogUrl) return false;
  final next = SourcePackage.of(incoming), old = SourcePackage.of(existing);
  if (next == null) return false;
  if (old != null) {
    return old.repositoryId == next.repositoryId && old.slug == next.slug;
  }
  return false;
}

void validatePackageLocation(Source source, String indexUrl) {
  final package = SourcePackage.of(source);
  if (indexUrl == nodeLaneCatalogUrl && package == null) {
    throw StateError('官方目录缺少插件校验信息');
  }
  if (package == null) return;
  final index = Uri.parse(indexUrl),
      artifact = Uri.parse(source.sourceCodeUrl!);
  if (artifact.origin != index.origin ||
      artifact.userInfo.isNotEmpty ||
      artifact.hasQuery ||
      artifact.hasFragment ||
      !(index.scheme == 'https' ||
          index.scheme == 'http' && _isLocalDevelopmentHost(index.host))) {
    throw StateError('插件文件必须来自同一仓库的可信地址');
  }
}

bool _isLocalDevelopmentHost(String host) {
  if (host == 'localhost') return true;
  final address = InternetAddress.tryParse(host);
  if (address == null) return false;
  if (address.isLoopback) return true;
  final bytes = address.rawAddress;
  return bytes.length == 4 &&
      (bytes[0] == 10 ||
          bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31 ||
          bytes[0] == 192 && bytes[1] == 168);
}

Future<Uint8List> downloadSourcePackage(
  http.Client client,
  Source source,
) async {
  final package = SourcePackage.of(source);
  if (package == null) {
    final response = await client.get(Uri.parse(source.sourceCodeUrl!));
    if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
      throw StateError('插件下载失败（HTTP ${response.statusCode}），已保留已安装版本');
    }
    return response.bodyBytes;
  }
  if (!package.compatible) throw StateError('请更新 App 后再安装此插件');
  final request = http.Request('GET', Uri.parse(source.sourceCodeUrl!))
    ..followRedirects = false;
  final response = await client
      .send(request)
      .timeout(const Duration(seconds: 25));
  if (response.statusCode != 200) {
    await response.stream.listen((_) {}).cancel();
    throw StateError('插件下载失败（HTTP ${response.statusCode}），已保留已安装版本');
  }
  final bytes = BytesBuilder(copy: false);
  await for (final chunk in response.stream.timeout(
    const Duration(seconds: 25),
  )) {
    if (bytes.length + chunk.length > package.size) {
      throw StateError('插件大小与目录不符，已保留已安装版本');
    }
    bytes.add(chunk);
  }
  final result = bytes.takeBytes();
  if (result.length != package.size ||
      sha256.convert(result).toString() != package.hash) {
    throw StateError('插件摘要与目录不符，已保留已安装版本');
  }
  return result;
}
