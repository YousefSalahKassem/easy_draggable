import 'package:easy_draggable/src/helpers/extensions.dart';
import 'package:flutter/material.dart';

import 'helpers/widget_life_cycle.dart';

class EasyDraggableWidget extends StatefulWidget {
  const EasyDraggableWidget({
    super.key,
    required this.floatingBuilder,
    this.padding = EdgeInsets.zero,
    double? top,
    double? left,
    this.bottom,
    this.right,
    this.speed,
    this.isDraggable = true,
    this.hasBounce = false,
    this.autoAlign = false,
  })  : assert((bottom == null && top == null) ||
            (bottom == null && top != null) ||
            (bottom != null && top == null)),
        assert((left == null && right == null) ||
            (left == null && right != null) ||
            (left != null && right == null)),
        _top = bottom == null ? top ?? 0 : null,
        _left = right == null ? left ?? 0 : null;

  final EdgeInsetsGeometry padding;
  final LayoutWidgetBuilder floatingBuilder;
  final double? _top;
  final double? _left;
  final double? bottom;
  final double? right;
  final double? speed;
  final bool isDraggable;
  final bool hasBounce;
  final bool autoAlign;

  @override
  State<EasyDraggableWidget> createState() => _EasyDraggableWidgetState();
}

class _EasyDraggableWidgetState extends State<EasyDraggableWidget>
    with SingleTickerProviderStateMixin {
  final containerKey2 = GlobalKey();

  /// distance from top and left initial value
  double? top, left;

  /// is the widget tabbed bool value
  bool isTabbed = false;

  /// bool value if it is dragging
  bool isDragging = false;

  /// is the floating widget is draggable of not.
  bool isDragEnable = true;

  /// is the floating widget colliding with the close widget.
  bool isColliding = true;

  bool hasCollision(
    GlobalKey<State<StatefulWidget>> key1,
    GlobalKey<State<StatefulWidget>> key2,
  ) {
    final box1 = key1.currentContext?.findRenderObject() as RenderBox?;
    final box2 = key2.currentContext?.findRenderObject() as RenderBox?;
    if (box1 != null && box2 != null) {
      final position1 = box1.localToGlobal(Offset.zero);
      final position2 = box2.localToGlobal(Offset.zero);
      return position1.dx < position2.dx + box2.size.width &&
          position1.dx + box1.size.width > position2.dx &&
          position1.dy < position2.dy + box2.size.height &&
          position1.dy + box1.size.height > position2.dy;
    }
    return false;
  }

  Size? get floatingHeadSize {
    final box2 = containerKey2.currentContext?.findRenderObject();
    if (box2 is RenderBox && box2.hasSize) {
      return box2.size;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    /// total screen width & height
    final containerKey1 = GlobalKey();
    final screen = MediaQuery.of(context).size;

    /// distance from top and left from user
    /// top = widget.dy?? MediaQuery.of(context).size.height / 2;
    /// left = widget.dx?? MediaQuery.of(context).size.width / 2;
    return GestureDetector(
      /// if the user touched out side of the widget the tabbed will be false
      onTap: () {
        setState(() {
          isTabbed = false;
        });
      },

      /// if the user touched out side of the widget the tabbed will be false
      onLongPress: () {
        setState(() {
          isTabbed = false;
        });
      },

      /// if the user touch of even gesture detector detect any drag gesture out side of the widget the dragging will be false
      onPanStart: (value) {
        setState(() {
          isTabbed = false;
        });
      },

      /// setting the top and left globally
      child: LimitedBox(
        maxHeight: screen.height,
        maxWidth: screen.width,
        child: Padding(
          padding: widget.padding,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.biggest;
              final height = size.height;
              final width = size.width;

              double getTop() {
                return this.top ??
                    widget._top ??
                    widget.bottom.let((bottom) {
                      return height - bottom - (floatingHeadSize?.height ?? 0);
                    }) ??
                    -1;
              }

              double getLeft() {
                return this.left ??
                    widget._left ??
                    widget.right.let((right) {
                      return width - right - (floatingHeadSize?.width ?? 0);
                    }) ??
                    -1;
              }

              final top = getTop();
              final left = getLeft();
              final floatingSize = floatingHeadSize;
              final floatingWidgetHeight = floatingSize?.height ?? 0;
              final floatingWidgetWidth = floatingSize?.width ?? 0;

              return WidgetLifecycleListener(
                onInit: () {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    safeSetState(() {
                      this.top = getTop();
                      this.left = getLeft();
                    });
                  });
                },
                child: SizedBox.fromSize(
                  size: size,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        top: top == -1 ? null : top,
                        left: left == -1 ? null : left,
                        duration:
                            Duration(milliseconds: isDragging ? 100 : 700),

                        /// setting animation time and animation type
                        /// the widget will bounce when it will touch the main screen border.
                        /// other wise it has just a simple ease animation.
                        curve: widget.hasBounce &&
                                (top >= (height - floatingWidgetHeight) ||
                                    left >= (width - floatingWidgetWidth) ||
                                    top <= floatingWidgetHeight ||
                                    left <= 1)
                            ? Curves.bounceOut
                            : Curves.ease,
                        child: GestureDetector(
                          /// tabbing on widget makes the isTabbed true.
                          /// it is because the widget will move only when we are touch it and drag to to somewhere else in the screen
                          onTap: () {
                            setState(() {
                              isTabbed = true;
                            });
                          },

                          /// also in the case of long press
                          onLongPress: () {
                            setState(() {
                              isTabbed = true;
                            });
                          },

                          /// also in the case when a user start to drag the widget
                          onPanStart: (value) {
                            setState(() {
                              isTabbed = true;
                              isDragging = true;
                            });
                          },

                          /// updating top and left variable
                          onPanUpdate: (value) {
                            setState(() {
                              if (isTabbed && isDragEnable) {
                                isColliding = hasCollision(
                                  containerKey1,
                                  containerKey2,
                                );
                                final position = value.globalPosition;
                                this.top = _getDy(
                                  position.dy - floatingWidgetHeight,
                                  height,
                                  floatingWidgetHeight,
                                );
                                this.left = _getDx(
                                  position.dx - floatingWidgetHeight,
                                  width,
                                  floatingWidgetWidth,
                                );
                              }
                            });
                          },

                          /// give a sliding animation
                          onPanEnd: (value) {
                            final velocity = value.velocity.pixelsPerSecond;
                            setState(() {
                              if (isTabbed && isDragEnable) {
                                isDragging = false;
                                this.left = _getDx(
                                  left + velocity.dx / (widget.speed ?? 50.0),
                                  width,
                                  floatingWidgetWidth,
                                );
                                this.top = _getDy(
                                  top + velocity.dy / (widget.speed ?? 50.0),
                                  height,
                                  floatingWidgetHeight,
                                );
                              }
                            });

                            /// activates only if auto align is set to true
                            /// the widget will automagically align to left or right of the screen now
                            /// after the user release the widget
                            ///  if the widget is on the left screen side then
                            ///  left = width - widget.floatingWidgetWidth;
                            ///  if the widget on the right side then
                            ///  left = 0
                            if (widget.autoAlign) {
                              if (left >= width / 2) {
                                setState(() {
                                  this.left = width - floatingWidgetWidth;
                                });
                              } else {
                                setState(() {
                                  this.left = 0;
                                });
                              }
                            }
                          },

                          /// the floating widget with size
                          child: SizedBox.fromSize(
                            key: containerKey2,
                            size: floatingSize,
                            child: widget.floatingBuilder(context, constraints),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(EasyDraggableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    isDragEnable = widget.isDraggable;
  }

  /// get the y axis value or top value with screen size
  double _getDy(double dy, double totalHeight, double floatingWidgetHeight) {
    /// checking if top is higher or less than total screen height (except
    /// appbar), if so, then top will be the lowest of highest point of the screen.
    /// top variable will be no more than the screen total height
    double currentTop;
    if (dy >= (totalHeight - floatingWidgetHeight)) {
      currentTop = totalHeight - floatingWidgetHeight;
    } else {
      if (dy <= 0) {
        currentTop = 0;
      } else {
        currentTop = dy;
      }
    }

    return currentTop;
  }

  /// get the x axis value or left value with screen size
  double _getDx(double dx, double totalWidth, double floatingWidgetWidth) {
    /// checking if left is higher or less than total screen width ,
    /// if so, then left will be the lowest width (0.o) of highest point of width of the screen
    /// widget will not go out side of the screen.
    double currentLeft;
    if (dx >= (totalWidth - floatingWidgetWidth)) {
      currentLeft = totalWidth - floatingWidgetWidth;
    } else {
      if (dx <= 0) {
        currentLeft = 0;
      } else {
        currentLeft = dx;
      }
    }

    return currentLeft;
  }
}
