import 'package:flutter/material.dart';
import '../utils/money_formatter.dart';

class MoneyDisplay extends StatelessWidget {
  final dynamic amount;
  final double? maxWidth;
  final TextStyle? style;
  final bool showCompact;
  final bool showDecimal;

  const MoneyDisplay({
    Key? key,
    required this.amount,
    this.maxWidth,
    this.style,
    this.showCompact = false,
    this.showDecimal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedAmount;

    if (showCompact) {
      formattedAmount = MoneyFormatter.formatCompact(amount);
    } else if (showDecimal) {
      formattedAmount = MoneyFormatter.formatVNDWithDecimal(amount);
    } else {
      formattedAmount = MoneyFormatter.formatVND(amount);
    }

    return Container(
      constraints:
          maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      child: Text(
        formattedAmount,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style:
            style ??
            TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
      ),
    );
  }
}

class MoneyDisplayBold extends StatelessWidget {
  final dynamic amount;
  final double? maxWidth;
  final Color? color;

  const MoneyDisplayBold({
    Key? key,
    required this.amount,
    this.maxWidth,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      child: Text(
        MoneyFormatter.formatVND(amount),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color ?? Color(0xFF4CAF50),
        ),
      ),
    );
  }
}

class MoneyDisplayCard extends StatelessWidget {
  final dynamic amount;
  final String label;
  final IconData icon;
  final Color color;

  const MoneyDisplayCard({
    Key? key,
    required this.amount,
    required this.label,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        MoneyFormatter.formatVND(amount),
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
