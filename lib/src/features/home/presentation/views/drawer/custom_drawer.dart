import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/src/features/home/presentation/views/drawer/add_table_view.dart';
import 'package:task/src/features/home/presentation/views/drawer/all_paid_biils.dart';
import 'package:task/src/features/home/presentation/views/drawer/resturant_system_view.dart';
import 'package:task/src/features/home/presentation/views/drawer/widgets/add_items_view.dart';
import 'package:task/src/features/home/presentation/views/drawer/widgets/list_tile_item.dart';
import 'package:task/src/features/auth/view_models/auth_view_model.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.7,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            const Text(
              "Profile",
              style: TextStyle(fontSize: 20),
            ),
            Consumer<AuthViewModel>(
              builder: (context, authViewModel, child) {
                final user = authViewModel.currentUser;

                if (user != null) {
                  return ListTileItem(
                    title: user.fullName!,
                    subTitle: user.email,
                    icon: "assets/images/user.svg",
                  );
                } else {
                  return const ListTileItem(
                    title: 'No User Data',
                    subTitle: '',
                    icon: "assets/images/user.svg",
                  );
                }
              },
            ),
            const Divider(),
            ListTileItem(
              title: 'Restaurant System',
              subTitle: 'Display tables in the restaurant',
              icon: "assets/images/category-2.svg",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ResturantSystemView()));
              },
            ),
            const SizedBox(height: 10),
            ListTileItem(
              title: 'Add table',
              subTitle: 'Add a table and chairs to the system.',
              icon: "assets/images/add.svg",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddTableView(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTileItem(
              title: 'Add items ',
              subTitle: 'To add types and varieties to the restaurant',
              icon: "assets/images/add.svg",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddItemsView(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTileItem(
              title: 'Paid bills',
              subTitle: 'View all paid invoices',
              icon: "assets/images/moneys.svg",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AllPaidBills(),
                  ),
                );
              },
            ),
            const Expanded(child: SizedBox()),
            Consumer<AuthViewModel>(
              builder: (context, authViewModel, child) {
                return ListTileItem(
                  title: 'Logout',
                  subTitle: 'To log out of the session',
                  icon: "assets/images/logout.svg",
                  onTap: () async {
                    await authViewModel.signOut(context);
                  },
                );
              },
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
