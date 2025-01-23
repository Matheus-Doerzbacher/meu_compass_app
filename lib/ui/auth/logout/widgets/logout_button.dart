import 'package:flutter/material.dart';
import 'package:meu_compass_app/ui/auth/logout/view_models/logout_viewmodel.dart';
import 'package:meu_compass_app/ui/core/localization/applocalization.dart';
import 'package:meu_compass_app/ui/core/themes/colors.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({
    super.key,
    required this.viewModel,
  });

  final LogoutViewModel viewModel;

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.logout.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LogoutButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.logout.removeListener(_onResult);
    widget.viewModel.logout.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.logout.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey1),
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        child: InkResponse(
          borderRadius: BorderRadius.circular(8),
          onTap: () => widget.viewModel.logout.execute(),
          child: Center(
            child: Icon(
              size: 24,
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  void _onResult() {
    // Não precisamos navegar para `/login` no logout,
    // isso é feito automaticamente pelo GoRouter.

    if (widget.viewModel.logout.error) {
      widget.viewModel.logout.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).errorWhileLogout),
          action: SnackBarAction(
            label: AppLocalization.of(context).tryAgain,
            onPressed: widget.viewModel.logout.execute,
          ),
        ),
      );
    }
  }
}
