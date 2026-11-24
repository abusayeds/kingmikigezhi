import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/utils/media_url_utils.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

/// Drop-in replacement for [Image.network] that works on Flutter web
/// even when the CDN/S3 bucket has no CORS headers.
class AppRemoteImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;

  const AppRemoteImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorWidget,
  });

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.6),
      highlightColor: Colors.grey.withOpacity(0.3),
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.withOpacity(0.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolved = MediaUrlUtils.resolve(url);
    if (resolved == null || resolved.isEmpty) {
      return errorWidget ?? _fallback();
    }

    if (!kIsWeb && MediaUrlUtils.isSvg(resolved)) {
      return SvgPicture.network(
        resolved,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: (_) => _shimmer(),
      );
    }

    return Image.network(
      resolved,
      width: width,
      height: height,
      fit: fit,
      webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
      errorBuilder: (context, error, stackTrace) => errorWidget ?? _fallback(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _shimmer();
      },
    );
  }

  Widget _fallback() {
    return Image.asset(
      AppImages.logo,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
