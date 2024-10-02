import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_plus/models/user_model.dart';
import 'package:notes_plus/views/home/bloc/home_bloc.dart';
import '../settings/settings_view.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const String routeName = '/';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddContactDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: Center(
          child: SvgPicture.asset(
            'assets/logo.svg',
            height: 120, // Increase logo height
            width: 120,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: "settings-tag",
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, SettingsView.routeName);
                    },
                    child: const Icon(Icons.manage_accounts_rounded),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 16,
            child: InkWell(
              onTap: () {
                _showPopupMenu(context);
              },
              child: Icon(
                Icons.menu,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  @override
  void initState() {
    context.read<HomeBloc>().add(
          GetUserEvent(context: context),
        );
    super.initState();
  }

  Widget _buildBody() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSearchField(state),
            _buildNotes(state),
          ],
        );
      },
    );
  }

  Widget _buildSearchField(HomeState homeState) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/logo.svg',
                height: 80,
                width: 120,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  context.read<HomeBloc>().add(
                        SearchUserEvent(
                            key: value.toLowerCase().trim(), context: context),
                      );
                },
                decoration: const InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Check for search results
            if (homeState is HomeLoadedState && homeState.users.isEmpty)
              const Center(
                child: Text(
                  "No results found.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 200.0, // Set the height you want for the expanded state
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text('Your Title'),
        background: Center(
          child: SvgPicture.asset(
            'assets/logo.svg',
            height: 120, // Increase logo height
            width: 120,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: "settings-tag",
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SettingsView.routeName);
                  },
                  child: const Icon(Icons.manage_accounts_rounded),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 16,
          child: InkWell(
            onTap: () {
              _showPopupMenu(context);
            },
            child: Icon(
              Icons.menu,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _showPopupMenu(BuildContext context) async {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          overlay.localToGlobal(
              Offset(overlay.size.width, 0)), // Position it to the right
          overlay.localToGlobal(Offset(overlay.size.width, 0)),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem(
          value: 'Search',
          child: ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
          ),
        ),
        const PopupMenuItem(
          value: 'Website',
          child: ListTile(
            leading: Icon(Icons.language),
            title: Text('Website'),
          ),
        ),
        const PopupMenuItem(
          value: 'LinkedIn',
          child: ListTile(
            leading: Icon(Icons.business),
            title: Text('LinkedIn'),
          ),
        ),
        const PopupMenuItem(
          value: 'Contact',
          child: ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('Contact'),
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        // Handle the selected value
        switch (value) {
          case 'Search':
            // Navigate to search page
            break;
          case 'Website':
            // Open website
            urlLauncher('https://www.girmantech.com');

            break;
          case 'LinkedIn':
            // Open LinkedIn
            urlLauncher('https://www.linkedin.com/company/girmantech/');

            break;
          case 'Contact':
            urlLauncher('mailto:contact@girmantech.com');
            break;
        }
      }
    });
  }

  Future<void> urlLauncher(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _buildNotes(HomeState homeState) {
    if (homeState is HomeLoadingState) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: CupertinoActivityIndicator(),
      );
    }
    if (homeState is HomeErrorState) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Opacity(
          opacity: 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_rounded,
                size: 40,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                homeState.errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (homeState is HomeLoadedState) {
      List<UserModel> users = searchController.value.text == ""
          ? homeState.users
          : homeState.filteredUsers;

      // Check if the user list is empty
      if (users.isEmpty) {
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Opacity(
            opacity: 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_outlined,
                  size: 40,
                ),
                SizedBox(height: 8),
                Text(
                  "No results found.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // If users are not empty, display them in a list of cards
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final user = users[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              child: Container(
                // Remove fixed height
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 20, // Larger font size for name
                        fontWeight: FontWeight.bold, // Bold font
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(user.city),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(user.contactNumber),
                      ],
                    ),
                    const SizedBox(height: 8), // Add space to prevent overflow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Available on phone',
                          style: TextStyle(color: Colors.grey),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showUserDetails(
                                context, user); // Pass the user object
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black, // Text color
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)), // Square corners
                            ),
                          ),
                          child: const Text('Fetch Details'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: users.length,
        ),
      );
    }
    return const SizedBox();
  }
}

void _showUserDetails(BuildContext context, UserModel user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          width: double.maxFinite, // Make the dialog width flexible
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use minimum size for dialog
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fetch Details',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Here are the details of following employee.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(user.city),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(user.contactNumber),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

void _showAddContactDialog(BuildContext context) {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: contactNumberController,
              decoration: InputDecoration(labelText: 'Contact Number'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Dismiss the dialog
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Validate input
              if (firstNameController.text.isEmpty ||
                  lastNameController.text.isEmpty ||
                  cityController.text.isEmpty ||
                  contactNumberController.text.isEmpty) {
                // Show a message if any field is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all fields.'),
                  ),
                );
              } else {
                // Create a new user model and add it using Bloc
                final newUser = UserModel(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  city: cityController.text,
                  contactNumber: contactNumberController.text,
                );

                context.read<HomeBloc>().add(AddUserEvent(
                      user: newUser,
                      context: context,
                    ));
                Navigator.of(context).pop(); // Dismiss the dialog after adding
              }
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
