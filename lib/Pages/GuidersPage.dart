import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder/API/api.dart';
import 'package:pathfinder/Entity/User.dart';
import 'package:pathfinder/Pages/GuidersDetailPage.dart';

class GuidersPage extends StatefulWidget {
  const GuidersPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GuidersPageState();
}

class GuidersPageState extends State<GuidersPage> {
  late Future<List<User>> futureGuider;
  Api api = const Api();

  @override
  void initState() {
    super.initState();
    futureGuider = api.fetchGuider();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Guiders',
              style: GoogleFonts.ubuntu(
                  color: Colors.amber[800],
                  fontSize: 25,
                  decoration: TextDecoration.none),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(2.0),
            child: FutureBuilder<List<dynamic>>(
              future: futureGuider,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Icon(Icons.error)));
                }
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        tileColor: Colors.black12,
                        title: Text(
                          '${snapshot.data![index].name}',
                          style: GoogleFonts.ubuntu(
                              color: Colors.amber[800],
                              fontSize: 18,
                              decoration: TextDecoration.none),
                        ),
                        subtitle: Text(
                          'From ${snapshot.data![index].city['name']}',
                          style: GoogleFonts.ubuntu(
                              color: Colors.amber[800],
                              fontSize: 12,
                              decoration: TextDecoration.none),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.amber[800],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GuidersDetailPage(
                                      snapshot.data![index])));
                        },
                      );
                    });

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ],
    );
  }
}
