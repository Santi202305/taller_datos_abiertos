import 'package:flutter/material.dart';

class ListItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final VoidCallback onTap;

  const ListItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.leading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading:
            leading ??
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.article,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: onTap,
      ),
    );
  }
}
