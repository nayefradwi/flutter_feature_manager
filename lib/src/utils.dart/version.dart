import 'package:flutter_feature_manager/src/utils.dart/logger.dart';

String compareVersions({
  required String version1,
  required String version2,
}) {
  try {
    final version1Parts = version1.split('.').map(int.parse).toList();
    final version2Parts = version2.split('.').map(int.parse).toList();
    if (version1Parts.first > version2Parts.first) {
      return version1;
    }
    if (version1Parts[1] > version2Parts[1] &&
        version1Parts.first == version2Parts.first) {
      return version1;
    }
    if (version1Parts.last > version2Parts.last &&
        version1Parts[1] == version2Parts[1] &&
        version1Parts.first == version2Parts.first) {
      return version1;
    }
    return version2;
  } catch (_) {
    logger.warning('Invalid version number');
    return version2;
  }
}
