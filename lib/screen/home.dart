import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NEWS APP'),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final name = user['title'];
            final imageUrl = user['urlToImage'];
            final publish = user['publishedAt'];
            // final urlsearch = user['url'];
            return ListTile(
              onTap: () {
                _launchUrl(
                  Uri.parse(user['url'] ?? ""),
                );
              },
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(imageUrl ??
                      "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png")),
              title: Text(
                name ?? "",
              ),
              subtitle: Text(
                publish ?? "",
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
        child: const Text("press to see news"),
      ),
    );
  }

  void fetchUsers() async {
    print('fetchUsers called');
    const url =
        'https://newsapi.org/v2/everything?q=bitcoin&apiKey=2d05f2d89b42425398e081155152f935';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['articles'];
    });
    print('fetchusers completed');
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
