import 'package:super_sliver_list/super_sliver_list.dart';

/// Precalculate short lists without eagerly measuring large result sets.
class SmallListPrecalculationPolicy extends ExtentPrecalculationPolicy {
  @override
  bool shouldPrecalculateExtents(ExtentPrecalculationContext context) =>
      context.numberOfItems < 100;
}
