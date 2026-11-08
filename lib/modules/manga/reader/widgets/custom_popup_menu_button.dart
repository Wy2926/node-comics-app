import 'package:flutter/material.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class CustomPopupMenuButton<T> extends StatelessWidget {
  final String label;
  final String title;
  final ValueChanged<T> onSelected;
  final T value;
  final List<T> list;
  final String Function(T) itemText;
  const CustomPopupMenuButton({
    super.key,
    required this.label,
    required this.title,
    required this.onSelected,
    required this.value,
    required this.list,
    required this.itemText,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile && !isTv) {
      final colors = NodeLaneTokens.of(context);
      return PopupMenuButton<T>(
        tooltip: label,
        onSelected: onSelected,
        itemBuilder: (_) => [
          for (final item in list)
            CheckedPopupMenuItem<T>(
              value: item,
              checked: item == value,
              child: Text(itemText(item)),
            ),
        ],
        child: ListTile(
          title: Text(label, style: TextStyle(fontSize: 15, color: colors.ink)),
          subtitle: Text(
            title,
            style: TextStyle(fontSize: 13, color: colors.muted),
          ),
          trailing: const Icon(Icons.unfold_more_rounded),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: PopupMenuButton(
        popUpAnimationStyle: popupAnimationStyle,
        tooltip: "",
        offset: Offset.fromDirection(1),
        color: Colors.black,
        onSelected: onSelected,
        itemBuilder: (context) => [
          for (var d in list)
            PopupMenuItem(
              value: d,
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    color: d == value ? Colors.white : Colors.transparent,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    itemText(d),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color!
                        .withValues(alpha: 0.9),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Row(
                children: [
                  Text(title),
                  const SizedBox(width: 20),
                  const Icon(Icons.keyboard_arrow_down_outlined),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
