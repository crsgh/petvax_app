import 'package:flutter/material.dart';

// Enum for dialog types
enum PopupDialogType { defaultType, success, error, warning, info }

// Enum for dialog sizes
enum PopupDialogSize { small, medium, large, full }

class PopupDialog extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final String? title;
  final Widget child;
  final PopupDialogType type;
  final bool showCloseButton;
  final bool closeOnOverlayTap;
  final PopupDialogSize size;
  final List<Widget>? actions;
  final bool showDefaultButtons;
  final String? primaryButton;
  final String? secondaryButton;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  const PopupDialog({
    super.key,
    required this.isOpen,
    required this.onClose,
    this.title,
    required this.child,
    this.type = PopupDialogType.defaultType,
    this.showCloseButton = true,
    this.closeOnOverlayTap = true,
    this.size = PopupDialogSize.medium,
    this.actions,
    this.showDefaultButtons = true,
    this.primaryButton,
    this.secondaryButton,
    this.onPrimary,
    this.onSecondary,
  });

  @override
  State<PopupDialog> createState() => _PopupDialogState();
}

class _PopupDialogState extends State<PopupDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    if (widget.isOpen) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(PopupDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getTypeColor() {
    switch (widget.type) {
      case PopupDialogType.success:
        return Colors.green[600]!;
      case PopupDialogType.error:
        return Colors.red[600]!;
      case PopupDialogType.warning:
        return Colors.orange[600]!;
      case PopupDialogType.info:
        return Colors.blue[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Color _getTypeBackgroundColor() {
    switch (widget.type) {
      case PopupDialogType.success:
        return Colors.green[50]!;
      case PopupDialogType.error:
        return Colors.red[50]!;
      case PopupDialogType.warning:
        return Colors.orange[50]!;
      case PopupDialogType.info:
        return Colors.blue[50]!;
      default:
        return Colors.white;
    }
  }

  Color _getTypeBorderColor() {
    switch (widget.type) {
      case PopupDialogType.success:
        return Colors.green[200]!;
      case PopupDialogType.error:
        return Colors.red[200]!;
      case PopupDialogType.warning:
        return Colors.orange[200]!;
      case PopupDialogType.info:
        return Colors.blue[200]!;
      default:
        return Colors.grey[200]!;
    }
  }

  IconData? _getTypeIcon() {
    switch (widget.type) {
      case PopupDialogType.success:
        return Icons.check_circle;
      case PopupDialogType.error:
        return Icons.error;
      case PopupDialogType.warning:
        return Icons.warning;
      case PopupDialogType.info:
        return Icons.info;
      default:
        return null;
    }
  }

  double _getDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    switch (widget.size) {
      case PopupDialogSize.small:
        return screenWidth * 0.8;
      case PopupDialogSize.large:
        return screenWidth * 0.95;
      case PopupDialogSize.full:
        return screenWidth - 16;
      default:
        return screenWidth * 0.85;
    }
  }

  double? _getDialogHeight(BuildContext context) {
    if (widget.size == PopupDialogSize.full) {
      return MediaQuery.of(context).size.height - 32;
    }
    return null;
  }

  void _handleClose() {
    _animationController.reverse().then((_) {
      widget.onClose();
    });
  }

  Widget _buildDefaultButtons() {
    List<Widget> buttons = [];

    if (widget.secondaryButton != null ||
        (widget.secondaryButton == null && widget.showDefaultButtons)) {
      buttons.add(
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onSecondary ?? _handleClose,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey[400]!, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              widget.secondaryButton ?? 'Back',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      );

      if (widget.primaryButton != null ||
          (widget.primaryButton == null && widget.showDefaultButtons)) {
        buttons.add(const SizedBox(width: 12));
      }
    }

    if (widget.primaryButton != null ||
        (widget.primaryButton == null && widget.showDefaultButtons)) {
      buttons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: widget.onPrimary ?? _handleClose,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              widget.primaryButton ?? 'Okay',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    }

    return Row(children: buttons);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return const SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            color: Colors.black.withOpacity(0.5 * _opacityAnimation.value),
            child: GestureDetector(
              onTap: widget.closeOnOverlayTap ? _handleClose : null,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: GestureDetector(
                    onTap: () {}, // Prevent tap from propagating to overlay
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Container(
                          width: _getDialogWidth(context),
                          height: _getDialogHeight(context),
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getTypeBackgroundColor(),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getTypeBorderColor(),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize:
                                widget.size == PopupDialogSize.full
                                    ? MainAxisSize.max
                                    : MainAxisSize.min,
                            children: [
                              // Header
                              if (widget.title != null ||
                                  widget.showCloseButton)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[200]!,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      if (_getTypeIcon() != null) ...[
                                        Icon(
                                          _getTypeIcon(),
                                          color: _getTypeColor(),
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                      ],
                                      if (widget.title != null)
                                        Expanded(
                                          child: Text(
                                            widget.title!,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      if (widget.showCloseButton)
                                        IconButton(
                                          onPressed: _handleClose,
                                          icon: const Icon(Icons.close),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.grey[100],
                                            foregroundColor: Colors.grey[600],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                              // Content
                              Expanded(
                                flex:
                                    widget.size == PopupDialogSize.full ? 1 : 0,
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(16),
                                  child: widget.child,
                                ),
                              ),

                              // Actions
                              if (widget.actions != null ||
                                  widget.showDefaultButtons)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Colors.grey[200]!),
                                    ),
                                  ),
                                  child:
                                      widget.actions != null
                                          ? Row(
                                            children:
                                                widget.actions!
                                                    .expand(
                                                      (widget) => [
                                                        widget,
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                      ],
                                                    )
                                                    .take(
                                                      widget.actions!.length *
                                                              2 -
                                                          1,
                                                    )
                                                    .toList(),
                                          )
                                          : _buildDefaultButtons(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
