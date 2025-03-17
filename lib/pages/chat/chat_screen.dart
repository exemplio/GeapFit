// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geap_fit/pages/chat/api.dart';
import 'package:geap_fit/pages/chat/core/storage.dart';
import 'package:geap_fit/pages/chat/core/variables.dart';
import 'package:geap_fit/pages/chat/models/people.dart';
import 'package:geap_fit/pages/library/library_bloc.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:geap_fit/widgets/people_item.dart';
import 'package:go_router/go_router.dart';
import 'package:geap_fit/di/injection.dart';
import 'package:geap_fit/pages/agenda/models/store_model.dart';
import 'package:geap_fit/styles/theme_provider.dart';
import 'package:geap_fit/utils/error_message.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';
import '../../styles/bg.dart';
import '../../styles/text.dart';
import 'chat_bloc.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';

class ChatScreen extends StatefulWidget {
  ChatBloc bloc;
  ChatScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _colorProvider = getIt<ThemeProvider>().colorProvider();
  ChatBloc _bloc() => widget.bloc;
  final Cache _cache = Cache();

  @override
  void initState() {
    super.initState();
    setState(() {
      messages = [
        [...defaultMessages],
        [...defaultMessages],
        [...defaultMessages],
        [...defaultMessages],
        [...defaultMessages],
        [...defaultMessages],
      ];
    });
    getUser();
    getRandomPeople();
  }

  getUser() async {
    Storage storage = Storage();

    var user = await storage.loadUser();

    if (user == null) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil("/welcome", (route) => false);
    }
  }

  Widget _loadingCenter() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
          SizedBox(height: 10),
          Text("Cargando"),
        ],
      ),
    );
  }

  Widget _buttonPayment() {
    return Expanded(
      child: TextButton.icon(
        icon: const Icon(Icons.payment, color: ColorUtil.white),
        style: TextButton.styleFrom(
          backgroundColor: _colorProvider.primary(),
          padding: const EdgeInsets.all(20),
        ),
        onPressed: () => _bloc().goNext(path: StaticNames.agenda.name),
        label: const Text(
          "COMPRA",
          style: TitleTextStyle(color: ColorUtil.white),
        ),
      ),
    );
  }

  Widget _buttonGet() {
    return Expanded(
      child: TextButton.icon(
        icon: const Icon(Icons.phone_android_sharp, color: ColorUtil.white),
        style: TextButton.styleFrom(
          backgroundColor: _colorProvider.primaryLight(),
          padding: const EdgeInsets.all(20),
        ),
        onPressed: () => _bloc().goNext(path: StaticNames.withdraw.name),
        label: const Text(
          "RETIRO",
          style: TitleTextStyle(color: ColorUtil.white),
        ),
      ),
    );
  }

  void dialog(String errorMessage) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(title: Text(errorMessage));
    },
  );

  forceUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "GEAP FIT",
          style: TitleTextStyle(fontSize: 24, color: ColorUtil.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            // tooltip: 'Increase volume by 10',
            onPressed: () => closeSession(),
          ),
        ],
      ),
      //backgroundColor: _colorProvider.primaryLight(),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: _bloc(),
        listener: (context, state) {
          if (state is ChatGoNextState) {
            if (state.product != null) {
              context.goNamed(state.next, extra: state.product);
            } else {
              if (state.listTypes != null) {
                context.goNamed(state.next, extra: state.listTypes);
              }
              // context.goNamed(state.next);
            }
          }
        },
        builder: (context, state) {
          if (state is ChatLoadedState) {
            var inventory = state.inventory?.results?[0];
            var consigned = state.consigned;

            if (inventory != null) {
              // return _inventory(inventory, consigned);
            }
          }
          if (state is ChatLoadingState) {
            // _bloc().mInventory();
            // return _loadingCenter();
          }
          return Scaffold(
            body: SafeArea(
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 241, 241, 241),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 25,
                        bottom: 5,
                        right: 20,
                        left: 20,
                      ),
                      child: SizedBox(),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 20,
                          left: 20,
                          bottom: 5,
                        ),
                        child: ListView.builder(
                          itemCount: peopleList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PeopleItem(
                              people: peopleList[index],
                              index: index,
                              func: forceUpdate,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          ;
        },
      ),
    );
  }

  // API'dan gelen kisi bilgilerini alip state'imize yerlestiriyoruz.
  getRandomPeople() async {
    API api = API();

    var users = await api.getUsersService();
    List usersData = users["data"];

    setState(() {
      peopleList.clear();
    });
    usersData.forEachIndexed((index, element) {
      setState(() {
        peopleList.add(
          People(
            name: "${element["first_name"]} ${element["last_name"]}",
            avatarUrl: element["avatar"],
            lastMessage: messages[index][messages[index].length - 1].message,
            dateTime: messages[index][messages[index].length - 1].time,
            unreadCount: 1,
          ),
        );
      });
    });
  }

  Widget bottomBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () async {
              Uri url = Uri.parse(
                "https://github.com/siracyakut/bytebuilders-chat-app/",
              );
              await launchUrl(url);
            },
            child: const Icon(
              Icons.language,
              size: 30,
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          ),
          InkWell(
            onTap: () async {
              Uri url = Uri.parse("sms:+905538543421?body=Hello+ByteBuilders!");
              await launchUrl(url);
            },
            child: const Icon(
              Icons.forum,
              size: 30,
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          ),
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(112, 62, 254, 1),
              borderRadius: BorderRadius.circular(32.5),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(112, 62, 254, 1).withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: const Icon(Icons.add, size: 45, color: Colors.white),
          ),
          InkWell(
            onTap: () async {
              Uri url = Uri.parse("tel:+905538543421");
              await launchUrl(url);
            },
            child: const Icon(
              Icons.call,
              size: 30,
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, "/profile"),
            child: const Icon(
              Icons.person,
              size: 30,
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          ),
        ],
      ),
    );
  }

  void closeSession() {
    _cache.emptyCacheData();
    context.go(StaticNames.loginName.path);
  }

  @override
  void dispose() {
    _bloc().close();
    super.dispose();
  }
}
