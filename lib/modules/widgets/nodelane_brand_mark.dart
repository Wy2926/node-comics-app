import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';

/// App and default account artwork share sizing, but can be replaced separately.
class NodeLaneBrandMark extends StatelessWidget {
  const NodeLaneBrandMark({super.key, this.size = NodeLaneTokens.brandMarkSize})
    : _account = false;
  const NodeLaneBrandMark.account({
    super.key,
    this.size = NodeLaneTokens.avatarSize,
  }) : _account = true;

  final double size;
  final bool _account;

  @override
  Widget build(BuildContext context) => Image.asset(
    _account ? NodeLaneBrand.accountMark : NodeLaneBrand.appMark,
    width: size,
    height: size,
    fit: BoxFit.contain,
    cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).ceil(),
    excludeFromSemantics: true,
  );
}
