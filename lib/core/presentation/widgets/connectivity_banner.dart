import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/connectivity_provider.dart';

/// Banner that shows connectivity status at the top of the screen
class ConnectivityBanner extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectivityBanner({super.key, required this.child});

  @override
  ConsumerState<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends ConsumerState<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  bool _wasOffline = false;
  bool _showReconnectedBanner = false;

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineProvider);

    // Detect reconnection - use post-frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_wasOffline && isOnline && !_showReconnectedBanner) {
        setState(() {
          _showReconnectedBanner = true;
        });
        // Hide reconnection banner after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showReconnectedBanner = false;
            });
          }
        });
      }

      // Update wasOffline state after checking
      if (_wasOffline != !isOnline) {
        setState(() {
          _wasOffline = !isOnline;
        });
      }
    });

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        // Main content
        Expanded(child: widget.child),

        // Offline banner
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: !isOnline ? 40 + bottomPadding : 0,
          child: ClipRect(
            child: !isOnline
                ? Container(
                    color: Colors.red.shade700,
                    width: double.infinity,
                    height: double
                        .infinity, // <--- FIX 1: Explicit height required here
                    child: Directionality(
                      // <--- FIX 2: Needed if widget is above MaterialApp
                      textDirection: TextDirection.ltr,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.wifi_off,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'No internet connection',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration
                                        .none, // Removes yellow underlines
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: bottomPadding),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),

        // Reconnected banner
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _showReconnectedBanner && isOnline ? 40 + bottomPadding : 0,
          child: ClipRect(
            child: _showReconnectedBanner && isOnline
                ? Container(
                    color: Colors.green.shade600,
                    width: double.infinity,
                    height: double
                        .infinity, // <--- FIX 1: Explicit height required here
                    child: Directionality(
                      // <--- FIX 2: Needed if widget is above MaterialApp
                      textDirection: TextDirection.ltr,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.wifi, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Back online',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: bottomPadding),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
