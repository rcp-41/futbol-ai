import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Takım logosu — CachedNetworkImage + fallback
class TeamLogo extends StatelessWidget {
  final String logoUrl;
  final String teamName;
  final double size;

  const TeamLogo({
    required this.logoUrl,
    required this.teamName,
    this.size = 48,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (logoUrl.isEmpty) {
      return _buildFallback(theme);
    }

    return CachedNetworkImage(
      imageUrl: logoUrl,
      width: size,
      height: size,
      placeholder: (context, url) => _buildFallback(theme),
      errorWidget: (context, url, error) => _buildFallback(theme),
    );
  }

  Widget _buildFallback(ThemeData theme) {
    final initials = teamName.isNotEmpty
        ? teamName
            .split(' ')
            .take(2)
            .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
            .join()
        : '??';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
