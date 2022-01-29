import 'package:flutter/material.dart';
import 'package:notesapp/Pages/home_page.dart';
import 'package:notesapp/Pages/whatsnew/whatsnew.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: 240.0,
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/Images/NotesApp.png',
                    height: 55.0,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _SideMenuIconTab(
              iconData: Icons.home,
              title: 'Home',
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            _SideMenuIconTab(
              iconData: Icons.calendar_today_rounded,
              title: 'Calendar',
              onTap: () {},
            ),
            _SideMenuIconTab(
              iconData: Icons.local_post_office_outlined,
              title: 'Files Vauld',
              onTap: () {},
            ),
            _SideMenuIconTab(
              iconData: Icons.group_add,
              title: 'Group Project',
              onTap: () {},
            ),
            _SideMenuIconTab(
              iconData: Icons.error_outline,
              color: Colors.green,
              title: 'What\'s New',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WhatsNew()));
              },
            ),
            const SizedBox(height: 12.0),
          ],
        )
        // Text('HEEL'),

        //     child: Column(
        //       children: [
        //         _SideMenuIconTab(
        //           iconData: Icons.home,
        //           title: 'Home',
        //           onTap: () {},
        //         ),
        //         _SideMenuIconTab(
        //           iconData: Icons.search,
        //           title: 'Search',
        //           onTap: () {},
        //         ),
        //         _SideMenuIconTab(
        //           iconData: Icons.audiotrack,
        //           title: 'Radio',
        //           onTap: () {},
        //         ),
        //         const SizedBox(height: 12.0),
        //         _LibraryPlaylists(),
        //       ],
        //     ),
        );
  }
}

class _SideMenuIconTab extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  const _SideMenuIconTab(
      {Key? key,
      required this.iconData,
      required this.title,
      required this.onTap,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        color: color == null ? Colors.white : color,
        // color: Theme.of(context).iconTheme.color,
        size: 28.0,
      ),
      title: Text(
        title,
        // style: Theme.of(context).textTheme.bodyText1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}

// class _LibraryPlaylists extends StatefulWidget {
//   @override
//   __LibraryPlaylistsState createState() => __LibraryPlaylistsState();
// }

// class __LibraryPlaylistsState extends State<_LibraryPlaylists> {
//   ScrollController? _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//   }

//   @override
//   void dispose() {
//     _scrollController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Scrollbar(
//         isAlwaysShown: true,
//         controller: _scrollController,
//         child: ListView(
//           controller: _scrollController,
//           padding: const EdgeInsets.symmetric(vertical: 12.0),
//           physics: const ClampingScrollPhysics(),
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 8.0,
//                     horizontal: 16.0,
//                   ),
//                   child: Text(
//                     'YOUR LIBRARY',
//                     // style: Theme.of(context).textTheme.headline4,
//                     // overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 ...yourLibrary
//                     .map((e) => ListTile(
//                           dense: true,
//                           title: Text(
//                             e,
//                             // style: Theme.of(context).textTheme.bodyText2,
//                             // overflow: TextOverflow.ellipsis,
//                           ),
//                           onTap: () {},
//                         ))
//                     .toList(),
//               ],
//             ),
//             const SizedBox(height: 24.0),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 8.0,
//                     horizontal: 16.0,
//                   ),
//                   child: Text(
//                     'PLAYLISTS',
//                     // style: Theme.of(context).textTheme.headline4,
//                     // overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 ...playlists
//                     .map((e) => ListTile(
//                           dense: true,
//                           title: Text(
//                             e,
//                             // style: Theme.of(context).textTheme.bodyText2,
//                             // overflow: TextOverflow.ellipsis,
//                           ),
//                           onTap: () {},
//                         ))
//                     .toList(),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// const yourLibrary = [
//   'Made For You',
//   'Recently Played',
//   'Liked Songs',
//   'Albums',
//   'Artists',
//   'Podcasts',
// ];

// const playlists = [
//   'Today\'s Top Hits',
//   'Discover Weekly',
//   'Release Radar',
//   'Chill',
//   'Background',
//   'lofi hip hop music - beats to relax/study to',
//   'Vibes Right Now',
//   'Time Capsule',
//   'On Repeat',
//   'Summer Rewind',
//   'Dank Doggo Tunes',
//   'Sleepy Doge',
// ];
