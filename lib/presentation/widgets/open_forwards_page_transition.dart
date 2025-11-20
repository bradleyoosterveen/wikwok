import 'package:flutter/material.dart';

/// Taken from flutter/lib/src/material/page_transitions_theme.dart and
/// modified to be a forwards transition.
class WOpenForwardsPageTransitionsBuilder extends PageTransitionsBuilder {
  const WOpenForwardsPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      _OpenForwardsPageTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
}

class _OpenForwardsPageTransition extends StatefulWidget {
  const _OpenForwardsPageTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  static final Tween<Offset> _primaryTranslationTween = Tween<Offset>(
    begin: const Offset(.05, .0),
    end: Offset.zero,
  );

  static final Tween<Offset> _secondaryTranslationTween = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-.125, .0),
  );

  static const Curve _transitionCurve = Cubic(.2, .0, .0, 1.0);

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  @override
  State<_OpenForwardsPageTransition> createState() =>
      _OpenForwardsPageTransitionState();
}

class _OpenForwardsPageTransitionState
    extends State<_OpenForwardsPageTransition> {
  late CurvedAnimation _primaryAnimation;
  late CurvedAnimation _secondaryTranslationCurvedAnimation;

  @override
  void initState() {
    super.initState();
    _setAnimations();
  }

  @override
  void didUpdateWidget(covariant _OpenForwardsPageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation ||
        oldWidget.secondaryAnimation != widget.secondaryAnimation) {
      _disposeAnimations();
      _setAnimations();
    }
  }

  void _setAnimations() {
    _primaryAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: _OpenForwardsPageTransition._transitionCurve,
      reverseCurve: _OpenForwardsPageTransition._transitionCurve.flipped,
    );
    _secondaryTranslationCurvedAnimation = CurvedAnimation(
      parent: widget.secondaryAnimation,
      curve: _OpenForwardsPageTransition._transitionCurve,
      reverseCurve: _OpenForwardsPageTransition._transitionCurve.flipped,
    );
  }

  void _disposeAnimations() {
    _primaryAnimation.dispose();
    _secondaryTranslationCurvedAnimation.dispose();
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size size = constraints.biggest;

          final Animation<double> clipAnimation = Tween<double>(
            begin: .0,
            end: size.width,
          ).animate(_primaryAnimation);

          final Animation<Offset> primaryTranslationAnimation =
              _OpenForwardsPageTransition._primaryTranslationTween
                  .animate(_primaryAnimation);

          final Animation<Offset> secondaryTranslationAnimation =
              _OpenForwardsPageTransition._secondaryTranslationTween
                  .animate(_secondaryTranslationCurvedAnimation);

          return AnimatedBuilder(
            animation: widget.animation,
            builder: (BuildContext context, Widget? child) => Align(
              alignment: Alignment.centerRight,
              child: ClipRect(
                child: SizedBox(
                  width: clipAnimation.value,
                  child: OverflowBox(
                    alignment: Alignment.centerRight,
                    maxWidth: size.width,
                    child: child,
                  ),
                ),
              ),
            ),
            child: AnimatedBuilder(
              animation: widget.secondaryAnimation,
              child: FractionalTranslation(
                translation: primaryTranslationAnimation.value,
                child: widget.child,
              ),
              builder: (BuildContext context, Widget? child) =>
                  FractionalTranslation(
                translation: secondaryTranslationAnimation.value,
                child: child,
              ),
            ),
          );
        },
      );
}
