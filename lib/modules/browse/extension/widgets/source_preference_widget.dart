import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class SourcePreferenceWidget extends StatefulWidget {
  final List<SourcePreference> sourcePreference;
  final Source source;
  const SourcePreferenceWidget({
    super.key,
    required this.sourcePreference,
    required this.source,
  });

  @override
  State<SourcePreferenceWidget> createState() => _SourcePreferenceWidgetState();
}

class _SourcePreferenceWidgetState extends State<SourcePreferenceWidget> {
  @override
  Widget build(BuildContext context) {
    final mobile = isMobile && !isTv;
    return Column(
      children: [
        for (var index = 0; index < widget.sourcePreference.length; index++)
          Builder(
            builder: (context) {
              final preference = widget.sourcePreference[index];
              Widget? w;
              if (preference.editTextPreference != null) {
                final pref = preference.editTextPreference!;
                w = ListTile(
                  title: Text(pref.title!),
                  subtitle: Text(
                    pref.summary!,
                    style: TextStyle(
                      fontSize: mobile ? 13 : 11,
                      color: context.secondaryColor,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditTextDialogWidget(
                        text: pref.value ?? "",
                        onChanged: (value) {
                          setState(() {
                            pref.value = value;
                          });
                          setPreferenceSetting(preference, widget.source);
                        },
                        dialogTitle: pref.dialogTitle ?? "",
                        dialogMessage: pref.dialogMessage ?? "",
                      ),
                    );
                  },
                );
              } else if (preference.checkBoxPreference != null) {
                final pref = preference.checkBoxPreference!;
                w = CheckboxListTile(
                  title: Text(pref.title!),
                  subtitle: Text(
                    pref.summary!,
                    style: TextStyle(
                      fontSize: mobile ? 13 : 11,
                      color: context.secondaryColor,
                    ),
                  ),
                  value: pref.value,
                  onChanged: (value) {
                    setState(() {
                      pref.value = value;
                    });
                    setPreferenceSetting(preference, widget.source);
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                );
              } else if (preference.switchPreferenceCompat != null) {
                final pref = preference.switchPreferenceCompat!;
                w = (mobile ? SwitchListTile.adaptive : SwitchListTile.new)(
                  title: Text(pref.title!),
                  subtitle: Text(
                    pref.summary!,
                    style: TextStyle(
                      fontSize: mobile ? 13 : 11,
                      color: context.secondaryColor,
                    ),
                  ),
                  value: pref.value!,
                  onChanged: (value) {
                    setState(() {
                      pref.value = value;
                    });
                    setPreferenceSetting(preference, widget.source);
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                );
              } else if (preference.listPreference != null) {
                final pref = preference.listPreference!;
                w = ListTile(
                  title: Text(pref.title!),
                  subtitle: Text(
                    pref.entries![pref.valueIndex!],
                    style: TextStyle(
                      fontSize: mobile ? 13 : 11,
                      color: context.secondaryColor,
                    ),
                  ),
                  onTap: () async {
                    final res = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: pref.title!),
                              if (pref.summary?.isNotEmpty ?? false)
                                TextSpan(
                                  text: "\n\n${pref.summary!}",
                                  style: TextStyle(fontSize: 13),
                                ),
                            ],
                          ),
                        ),
                        content: SizedBox(
                          width: context.width(0.8),
                          child: RadioGroup(
                            groupValue: pref.valueIndex,
                            onChanged: (value) {
                              Navigator.pop(context, value);
                            },
                            child: SuperListView.builder(
                              shrinkWrap: true,
                              itemCount: pref.entries!.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: index,
                                  title: Text(pref.entries![index]),
                                );
                              },
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(context.l10n.cancel),
                          ),
                        ],
                      ),
                    );
                    if (res != null) {
                      setState(() {
                        pref.valueIndex = res;
                      });
                    }
                    setPreferenceSetting(preference, widget.source);
                  },
                );
              } else if (preference.multiSelectListPreference != null) {
                final pref = preference.multiSelectListPreference!;
                w = ListTile(
                  title: Text(pref.title!),
                  subtitle: Text(
                    pref.summary!,
                    style: TextStyle(
                      fontSize: mobile ? 13 : 11,
                      color: context.secondaryColor,
                    ),
                  ),
                  onTap: () {
                    List<String> indexList = [];
                    indexList.addAll(pref.values!);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text(pref.title!),
                              content: SizedBox(
                                width: context.width(0.8),
                                child: SuperListView.builder(
                                  shrinkWrap: true,
                                  itemCount: pref.entries!.length,
                                  itemBuilder: (context, index) {
                                    return ListTileChapterFilter(
                                      label: pref.entries![index],
                                      type:
                                          indexList.contains(
                                            pref.entryValues![index],
                                          )
                                          ? 1
                                          : 0,
                                      onTap: () {
                                        if (indexList.contains(
                                          pref.entryValues![index],
                                        )) {
                                          setState(() {
                                            indexList.remove(
                                              pref.entryValues![index],
                                            );
                                            pref.values = indexList;
                                          });
                                        } else {
                                          setState(() {
                                            indexList.add(
                                              pref.entryValues![index],
                                            );
                                            pref.values = indexList;
                                          });
                                        }
                                        setPreferenceSetting(
                                          preference,
                                          widget.source,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(context.l10n.cancel),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(context.l10n.ok),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              }
              return w ?? Container();
            },
          ),
      ],
    );
  }
}

class EditTextDialogWidget extends StatefulWidget {
  final String text;
  final String dialogTitle;
  final String dialogMessage;
  final Function(String) onChanged;
  const EditTextDialogWidget({
    super.key,
    required this.text,
    required this.onChanged,
    required this.dialogTitle,
    required this.dialogMessage,
  });

  @override
  State<EditTextDialogWidget> createState() => _EditTextDialogWidgetState();
}

class _EditTextDialogWidgetState extends State<EditTextDialogWidget> {
  late final _controller = TextEditingController(text: widget.text);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile && !isTv;
    return AlertDialog(
      scrollable: true,
      backgroundColor: mobile ? NodeLaneTokens.of(context).surface : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.dialogTitle),
          Text(widget.dialogMessage, style: const TextStyle(fontSize: 13)),
        ],
      ),
      content: TextField(
        controller: _controller,
        decoration: mobile
            ? InputDecoration(
                filled: true,
                fillColor: NodeLaneTokens.of(context).soft,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              )
            : InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: context.secondaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: context.primaryColor),
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            widget.onChanged(_controller.text);
            Navigator.pop(context);
          },
          child: Text(context.l10n.ok),
        ),
      ],
    );
  }
}
