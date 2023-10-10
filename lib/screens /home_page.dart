import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum PopupItem { allBookmarks, searchEngine }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InAppWebViewController? Webcontroller;
  PullToRefreshController? refreshController;
  String searchItem = "";
  String weburl =
      "https://www.google.com/search?q=&rlz=1C1ONGR_enIN1015IN1015&oq=&gs_lcrp=EgZjaHJvbWUqBggAEEUYOzIGCAAQRRg7MgYIARAjGCcyDQgCEAAYgwEYsQMYgAQyDQgDEAAYgwEYsQMYgAQyDQgEEAAYgwEYsQMYgAQyDQgFEC4YgwEYsQMYigUyDQgGEAAYgwEYsQMYgAQyDQgHEAAYgwEYsQMYgAQyDQgIEAAYgwEYsQMYgAQyDQgJEAAYgwEYsQMYgATSAQw1NzcxOTMzajBqMTWoAgCwAgA&sourceid=chrome&ie=UTF-8";

  PopupItem? selectedItem;
  List<String> bookmarkes = [];
  String? _selectedUrl;

  String get url => weburl;

  String? get selectedUrl => _selectedUrl;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement
    super.initState();
    refreshController = PullToRefreshController(
      onRefresh: () {},
    );
  }

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please connect to the internet and try again.'),
          actions: [
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else if (connectivityResult == ConnectivityResult.mobile) {
      // internet connection available
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // internet connection available
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
    }
  }

  loadUrl(String url) {
    weburl = url;
    if (Webcontroller != null) {
      Webcontroller?.loadUrl(
        urlRequest: URLRequest(
          url: Uri.parse(url),
        ),
      );
    }
  }

  _showModel() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: ListView.builder(
            itemCount: bookmarkes.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    width: 250,
                    child: Text(
                      bookmarkes[index],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        bookmarkes.remove(bookmarkes[index]);
                      });
                      setState(() {});
                    },
                    icon: const Icon(Icons.bookmark_remove),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text("Search Engine"),
          ),
          actions: [
            RadioListTile(
              title: const Text("Google"),
              value: "https://www.google.com/",
              groupValue: selectedUrl,
              onChanged: (value) {
                _selectedUrl = value;
                loadUrl(selectedUrl!);
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text("Yahoo"),
              value: "https://in.search.yahoo.com/?fr2=inr",
              groupValue: selectedUrl,
              onChanged: (value) {
                _selectedUrl = value;
                loadUrl(selectedUrl!);
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text("Bing"),
              value: "https://www.bing.com/",
              groupValue: selectedUrl,
              onChanged: (value) {
                _selectedUrl = value;
                loadUrl(selectedUrl!);
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text("Duck Duck Go"),
              value: "https://duckduckgo.com/",
              groupValue: selectedUrl,
              onChanged: (value) {
                _selectedUrl = value;
                loadUrl(selectedUrl!);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web App"),
        centerTitle: true,
        actions: [
          PopupMenuButton<PopupItem>(
            initialValue: selectedItem,
            onSelected: (value) {
              if (value == PopupItem.allBookmarks) {
                _showModel();
              } else if (value == PopupItem.searchEngine) {
                _showDialog(context);
              }
            },
            offset: const Offset(0, 50),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<PopupItem>>[
                PopupMenuItem<PopupItem>(
                  value: PopupItem.allBookmarks,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.book),
                      Text("All Bookmarks"),
                    ],
                  ),
                ),
                PopupMenuItem<PopupItem>(
                  value: PopupItem.searchEngine,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.screen_search_desktop_outlined),
                      Text("Search Engine"),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                if (Webcontroller != null) {
                  await Webcontroller?.reload();
                }
              },
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(weburl),
                ),
                onWebViewCreated: (controller) {
                  Webcontroller = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    weburl = url as String;
                  });
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    weburl = url as String;
                  });
                },
              ),
            ),
          ),
          TextField(
            controller: textEditingController,
            onChanged: (value) {
              textEditingController.text = value.toString();
            },
            onSubmitted: (value) {
              setState(() {
                searchItem = value.toString();
                loadUrl(
                    "https://www.google.com/search?q=$value&rlz=1C1ONGR_enIN1015IN1015&oq=$value&gs_lcrp=EgZjaHJvbWUqDQgAEAAY4wIYsQMYgAQyDQgAEAAY4wIYsQMYgAQyCggBEC4YsQMYgAQyCggCEAAYsQMYgAQyGQgDEC4YgwEYrwEYxwEYsQMYgAQYmAUYmgUyBwgEEAAYgAQyDQgFEC4YgwEYsQMYgAQyEAgGEC4YgwEY1AIYsQMYigUyEAgHEC4YgwEY1AIYsQMYigUyDQgIEAAYgwEYsQMYigUyDQgJEC4YrwEYxwEYgATSAQ0xMTczMTI2MGowajE1qAIAsAIA&sourceid=chrome&ie=UTF-8");
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Select or type web address",
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                if (Webcontroller != null) {
                  Webcontroller?.loadUrl(
                    urlRequest: URLRequest(
                      url: Uri.parse(weburl),
                    ),
                  );
                }
                setState(() {});
              },
              icon: Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                var currentUrl = url;
                bookmarkes.add(currentUrl);
                setState(() {});
              },
              icon: Icon(Icons.bookmark_add_outlined),
            ),
            IconButton(
              onPressed: () {
                if (Webcontroller != null) {
                  Webcontroller?.goBack();
                }
                setState(() {});
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined),
            ),
            IconButton(
              onPressed: () {
                if (Webcontroller != null) {
                  Webcontroller?.reload();
                }
              },
              icon: Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () {
                if (Webcontroller != null) {
                  Webcontroller?.goForward();
                }
                setState(() {});
              },
              icon: Icon(Icons.arrow_forward_ios),
            )
          ],
        ),
      ),
    );
  }
}
