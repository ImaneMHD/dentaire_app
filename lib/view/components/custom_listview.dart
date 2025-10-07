import 'package:dentaire/view/components/list_item.dart';
import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  final List<ListItem> items;
  final Function onTapFct;

  const CustomListView(
      {super.key, required this.items, required this.onTapFct});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xffD9D9D9),
              child: Icon(items[index].icon, color: Color(0xff033244)),
            ),
            title: Text(
              items[index].title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            subtitle: Text(
              items[index].subtitle,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            trailing: items[index].trailingIcon != null
                ? IconTheme(
                    data: const IconThemeData(color: Color(0xFF1A6175)),
                    child: items[index].trailingIcon!,
                  )
                : null,

            onTap: onTapFct(), // Appel de la fonction de rappel
          ),
        );
      },
    );
  }
}
