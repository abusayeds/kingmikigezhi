import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/utils/media_url_utils.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

/// Network image that works on mobile + web.
///
/// Production S3 bucket has no CORS. On Flutter web, byte-fetch image loaders
/// (`CachedNetworkImage` / default `Image.network`) fail. Prefer the HTML
/// `<img>` element strategy so images still display without CORS.
class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final BoxFit fit;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    required this.imageUrl,
    this.backgroundColor,
    required this.height,
    required this.width,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final url = MediaUrlUtils.resolve(imageUrl)?.trim() ?? '';
    if (url.isEmpty) {
      return _errorContainer();
    }

    if (kIsWeb) {
      return _webImage(url);
    }

    if (MediaUrlUtils.isSvg(url)) {
      return _svgImage(url);
    }

    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
          color: backgroundColor,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
            colorFilter: colorFilter,
          ),
        ),
        child: child,
      ),
      placeholder: (context, _) => Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.grey.withOpacity(0.3),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            color: Colors.grey.withOpacity(0.6),
            borderRadius: borderRadius,
            shape: boxShape,
          ),
        ),
      ),
      errorWidget: (context, _, __) => _errorContainer(),
    );
  }

  Widget _webImage(String url) {
    final radius = boxShape == BoxShape.circle
        ? BorderRadius.circular(height / 2)
        : (borderRadius ?? BorderRadius.zero);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
          color: backgroundColor,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              url,
              height: height,
              width: width,
              fit: fit,
              // Avoid CORS byte-fetch failures on web (S3 has no ACAO header).
              webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
              errorBuilder: (context, error, stackTrace) => _errorContainer(),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.6),
                  highlightColor: Colors.grey.withOpacity(0.3),
                  child: Container(color: Colors.grey.withOpacity(0.6)),
                );
              },
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }

  Widget _svgImage(String url) {
    final radius = boxShape == BoxShape.circle
        ? BorderRadius.circular(height / 2)
        : (borderRadius ?? BorderRadius.zero);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        height: height,
        width: width,
        color: backgroundColor,
        alignment: Alignment.center,
        child: SvgPicture.network(
          url,
          height: height,
          width: width,
          fit: fit,
          placeholderBuilder: (_) => Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.6),
            highlightColor: Colors.grey.withOpacity(0.3),
            child: Container(color: Colors.grey.withOpacity(0.6)),
          ),
        ),
      ),
    );
  }

  Widget _errorContainer() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius,
        shape: boxShape,
        image: DecorationImage(
          image: AssetImage(AppImages.logo),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
