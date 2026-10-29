import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:mangayomi/utils/platform_utils.dart';

import 'mobile_player_action_dialog.dart';
import 'mobile_player_advanced_screen.dart';

class PlayerAdvancedScreen extends ConsumerStatefulWidget {
  const PlayerAdvancedScreen({super.key});

  @override
  ConsumerState<PlayerAdvancedScreen> createState() =>
      _PlayerAdvancedScreenState();
}

class _PlayerAdvancedScreenState extends ConsumerState<PlayerAdvancedScreen> {
  @override
  Widget build(BuildContext context) {
    final useMpvConfig = ref.watch(useMpvConfigStateProvider);

    if (isMobile && !isTv) {
      return MobilePlayerAdvancedScreen(
        enabled: useMpvConfig,
        onEnabledChanged: (value) async {
          final result = value ? await _checkMpvConfig(context) : true;
          if (result != true || !mounted) return result;
          ref.read(useMpvConfigStateProvider.notifier).set(value);
          return true;
        },
        onRestore: () => _checkMpvConfig(context, redownload: true),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.advanced)),
      body: SingleChildScrollView(
        padding: tvPageInsets,
        child: Column(
          children: [
            SwitchListTile(
              value: useMpvConfig,
              title: Text(context.l10n.enable_mpv),
              subtitle: Text(
                context.l10n.mpv_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
              onChanged: (value) async {
                if (value && (await _checkMpvConfig(context)) != true) {
                  return;
                }
                ref.read(useMpvConfigStateProvider.notifier).set(value);
              },
            ),
            ListTile(
              onTap: () {
                _checkMpvConfig(context, redownload: true);
              },
              title: Text(context.l10n.mpv_redownload),
              subtitle: Text(
                context.l10n.mpv_redownload_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _checkMpvConfig(
    BuildContext context, {
    bool redownload = false,
  }) async {
    final provider = StorageProvider();
    if (!(await provider.requestPermission()) || !context.mounted) {
      return false;
    }
    final dir = await provider.getMpvDirectory();
    if (dir == null || !context.mounted) return false;
    final mpvFile = File('${dir.path}/mpv.conf');
    final inputFile = File('${dir.path}/input.conf');
    final filesMissing =
        !(await mpvFile.exists()) && !(await inputFile.exists());
    if ((redownload || filesMissing) && context.mounted) {
      if (isMobile && !isTv) {
        return showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => MobilePlayerActionDialog(
            title: context.l10n.mpv_restore_bundled,
            message: context.l10n.mpv_restore_confirm,
            confirmLabel: context.l10n.dialog_confirm,
            onConfirm: () => _installMpvConfig(dir),
          ),
        );
      }
      final res = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(context.l10n.mpv_download),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.l10n.cancel),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () async {
                      await _installMpvConfig(dir);
                      if (context.mounted) {
                        Navigator.pop(context, "ok");
                      }
                    },
                    child: Text(context.l10n.download),
                  ),
                ],
              ),
            ],
          );
        },
      );
      return res != null && res == "ok";
    }
    return context.mounted;
  }

  Future<void> _installMpvConfig(Directory dir) async {
    final bytes = await rootBundle.load('assets/mangayomi_mpv.zip');
    final archive = ZipDecoder().decodeBytes(bytes.buffer.asUint8List());
    final shadersDir = path.join(dir.path, 'shaders');
    await Directory(shadersDir).create(recursive: true);
    final scriptsDir = path.join(dir.path, 'scripts');
    await Directory(scriptsDir).create(recursive: true);
    for (final file in archive.files) {
      if (file.name == 'mpv.conf' || file.name == 'input.conf') {
        await File(path.join(dir.path, file.name)).writeAsBytes(file.content);
      } else if (file.name.startsWith('shaders/') &&
          file.name.endsWith('.glsl')) {
        await File(path.join(shadersDir, file.name.split('/').last))
            .writeAsBytes(file.content);
      } else if (file.name.startsWith('scripts/') &&
          (file.name.endsWith('.js') || file.name.endsWith('.lua'))) {
        await File(path.join(scriptsDir, file.name.split('/').last))
            .writeAsBytes(file.content);
      }
    }
  }
}
