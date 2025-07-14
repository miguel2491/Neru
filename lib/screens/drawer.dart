import 'package:flutter/material.dart';

Widget buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text("Usuario Ejemplo"),
          accountEmail: Text("usuario@email.com"),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text("Inicio"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text("Notificaciones"),
          onTap: () {},
        ),
      ],
    ),
  );
}