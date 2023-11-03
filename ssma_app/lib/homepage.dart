import 'package:flutter/material.dart';
import 'pb.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? _hasBanner;
  String? bannerUrl;
  String? pfpUrl;
  String? username;

  String? _getPFP() {
    try {
      final userAuth = pb.authStore.model;
      final firstFilename = userAuth.getListValue<String>('avatar')[0];
      final avatar = pb.files.getUrl(userAuth, firstFilename, thumb: '100x250');
      return avatar.toString();
    } catch (error) {
      debugPrint('Error: $error');
      return null;
    }
  }

  String? _getBanner() {
    try {
      final userAuth = pb.authStore.model;
      final firstFilename = userAuth.getListValue<String>('banner')[0];
      final banner = pb.files.getUrl(userAuth, firstFilename);
      debugPrint(
          firstFilename.toString() != '' ? 'Banner found' : 'No banner found');
      if (firstFilename.toString() != '') {
        _hasBanner = true;
        return banner.toString();
      } else {
        _hasBanner = false;
        return null;
      }
    } catch (error) {
      debugPrint('Error: $error');
      return null;
    }
  }

  String? _getUsername() {
    try {
      final userAuth = pb.authStore.model;
      final username = userAuth.getListValue<String>('name')[0];
      return username.toString();
    } catch (error) {
      debugPrint('Error: $error');
      return null;
    }
  }

  @override
  void initState() {
    pfpUrl = _getPFP();
    username = _getUsername();
    bannerUrl = _getBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GerneralMenu(
              hasBanner: _hasBanner,
              bannerUrl: bannerUrl,
              pfpUrl: pfpUrl,
              username: username),
          ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('Home'),
              onTap: () {}
            )
        ],
      )),
      appBar: AppBar(),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}

class GerneralMenu extends StatelessWidget {
  const GerneralMenu({
    super.key,
    required bool? hasBanner,
    required this.bannerUrl,
    required this.pfpUrl,
    required this.username,
  }) : _hasBanner = hasBanner;

  final bool? _hasBanner;
  final String? bannerUrl;
  final String? pfpUrl;
  final String? username;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        image: _hasBanner == true
            ? DecorationImage(
                image: NetworkImage(bannerUrl!),
                scale: 1,
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
              right: 10,
              child: IconButton(
                  iconSize: 25,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black.withOpacity(0.1)),
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    // todo: implement
                  },
                  icon: const Icon(Icons.more_horiz))),
          Positioned(
              top: 12.0,
              left: 12.0,
              child: CircleAvatar(foregroundImage: NetworkImage(pfpUrl!))),
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text(
              username!,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
