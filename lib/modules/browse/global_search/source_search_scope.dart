import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/language.dart';

class SourceSearchScope {
  const SourceSearchScope(this.ids, this.pinnedOnly);
  final Set<int> ids;
  final bool pinnedOnly;
}

/// A local search draft. No source records are changed by selection or cancel.
class SourceSearchScopePage extends StatefulWidget {
  const SourceSearchScopePage({
    super.key,
    required this.sources,
    required this.current,
    required this.media,
  });
  final List<Source> sources;
  final SourceSearchScope current;
  final String media;
  @override
  State<SourceSearchScopePage> createState() => _SourceSearchScopePageState();
}

class _SourceSearchScopePageState extends State<SourceSearchScopePage> {
  final search = TextEditingController();
  late final selected = {...widget.current.ids};
  late bool pinnedOnly = widget.current.pinnedOnly;
  bool leaving = false;
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final matches = widget.sources
        .where(
          (s) => (s.name ?? '').toLowerCase().contains(
            search.text.trim().toLowerCase(),
          ),
        )
        .toList();
    return MobileBrowsePage(
      title: '搜索范围',
      body: ListView(
        padding: NodeLaneTokens.pagePadding,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text('${widget.media} · 跨来源搜索', style: t.readerSecondary),
          const SizedBox(height: 20),
          SourceGroup(
            children: [
              SourceRow(
                title: '仅搜索常用来源',
                icon: icons.pin,
                subtitle: '开启后，只搜索已勾选的常用来源',
                trailing: Switch.adaptive(
                  value: pinnedOnly,
                  onChanged: (v) => setState(() => pinnedOnly = v),
                ),
              ),
            ],
          ),
          NodeLaneCatalogHeading(
            '参与搜索的来源',
            action: '全选',
            onAction: () => setState(() {
              selected.addAll(matches.map((s) => s.id).whereType<int>());
            }),
          ),
          NodeLaneSearchField(
            controller: search,
            hint: '搜索已安装来源',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < matches.length; i++)
            NodeLaneCatalogRow(
              title: matches[i].name ?? '',
              leading: NodeLaneWebsiteIcon(url: matches[i].iconUrl),
              subtitle: [
                completeLanguageName(matches[i].lang ?? ''),
                if (matches[i].isPinned == true) '常用',
              ].join(' · '),
              first: i == 0,
              last: i == matches.length - 1,
              trailing: SizedBox(
                width: 24,
                child: selected.contains(matches[i].id)
                    ? Icon(icons.check, color: t.accent)
                    : null,
              ),
              onTap: () => setState(() {
                final id = matches[i].id;
                if (id != null && !selected.remove(id)) selected.add(id);
              }),
            ),
          if (matches.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('没有匹配的来源', style: t.readerSecondary),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text('仅影响搜索范围，不卸载来源。', style: t.readerSecondary),
          ),
        ],
      ),
      bottomAction: FilledButton(
        onPressed: () {
          if (leaving) return;
          leaving = true;
          Navigator.pop(context, SourceSearchScope({...selected}, pinnedOnly));
        },
        child: const Text('保存'),
      ),
    );
  }
}
