import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

class WAlertOverlay extends StatelessWidget {
  const WAlertOverlay({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Align(
          alignment: .bottomCenter,
          child: Builder(
            builder: (context) {
              final alert = context.watch<AlertCubit>().state;

              return AnimatedSwitcher(
                duration: 200.milliseconds,
                switchInCurve: Curves.easeInOutExpo,
                switchOutCurve: Curves.easeInOutExpo,

                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1.0, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                child: switch (alert) {
                  _ when alert != null => _Alert(alert: alert),
                  _ => const SizedBox.shrink(
                    key: ValueKey('empty'),
                  ),
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Alert extends StatelessWidget {
  const _Alert({
    required this.alert,
  });

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    final icon = switch (alert.type) {
      AlertType.info => FIcons.info,
      AlertType.warning => FIcons.triangleAlert,
      AlertType.error => FIcons.bug,
    };

    final content = alert.content;

    return SafeArea(
      key: ValueKey(alert.concurrencyStamp),
      child: GestureDetector(
        onTap: () => context.read<AlertCubit>().read(alert),
        child: Padding(
          padding: const EdgeInsets.all(8.0).add(const .only(bottom: 24)),
          child: FAlert(
            icon: Icon(icon),
            title: Text(alert.title),
            subtitle: content != null ? Text(content) : null,
          ),
        ),
      ),
    );
  }
}
