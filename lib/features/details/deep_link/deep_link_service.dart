import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../screens/product_details_loader_screen.dart';

class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  bool _isReady = false;
  int? _pendingProductId;

  void init() {
    _subscription ??= _appLinks.uriLinkStream.listen(_onLink);
  }

  void _onLink(Uri uri) {
    final id = _parseProductId(uri);
    if (id == null) return;

    if (_isReady) {
      _openProduct(id);
    } else {
      _pendingProductId = id;
    }
  }

  // ecommerce://product/2  ->  2
  int? _parseProductId(Uri uri) {
    if (uri.scheme != 'ecommerce' || uri.host != 'product') return null;
    if (uri.pathSegments.isEmpty) return null;
    return int.tryParse(uri.pathSegments.first);
  }

  void _openProduct(int id) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ProductDetailsLoaderScreen(productId: id),
      ),
    );
  }

  void setReady(bool ready) {
    _isReady = ready;
    final id = _pendingProductId;
    if (ready && id != null) {
      _pendingProductId = null;
      _openProduct(id);
    }
  }
}