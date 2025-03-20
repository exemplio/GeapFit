// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geap_fit/pages/chat/api.dart';
import 'package:geap_fit/pages/chat/core/storage.dart';
import 'package:geap_fit/pages/chat/core/variables.dart';
import 'package:geap_fit/pages/chat/models/people.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:geap_fit/widgets/message_item.dart';
import 'package:go_router/go_router.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';
import 'package:intl/intl.dart';
import '../../styles/bg.dart';
import '../../styles/text.dart';
import 'message_bloc.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';

class MessageScreen extends StatefulWidget {
  MessageBloc bloc;
  MessageScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  MessageBloc _bloc() => widget.bloc;
  final Cache _cache = Cache();

  var messageController = TextEditingController();

  getUser() async {
    Storage storage = Storage();

    var user = await storage.loadUser();

    if (user == null) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil("/welcome", (route) => false);
    }
  }

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

  void dialog(String errorMessage) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(title: Text(errorMessage));
    },
  );

  forceUpdate() {
    setState(() {});
  }

  sendMessage(_, index, func) {
    dynamic currentTime = DateFormat(
      'hh:mm a',
    ).format(DateTime.now().add(const Duration(hours: 3)));

    setState(() {
      messages[index].add(
        MessageItem(
          message: messageController.text,
          time: currentTime,
          isMe: false,
        ),
      );

      peopleList[index].lastMessage = messageController.text;
      peopleList[index].unreadCount = -1;
      peopleList[index].dateTime = currentTime;
    });
    func();
    messageController.clear();
  }

  Widget _showErrorMessage({
    String errorMessage = "NO HAY MENSAJE DISPONIBLE",
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Image(
            image: AssetImage("assets/icons/warning.png"),
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(height: 10),
        Text(errorMessage),
      ],
    );
  }

  Widget _showErrorMessageService({String errorMessage = "Test screen"}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [const SizedBox(height: 10), Center(child: Text(errorMessage))],
    );
  }

  @override
  Widget build(BuildContext context) {
    final People people = People(
      name: "TEST",
      avatarUrl: "TEST",
      lastMessage: "TEST",
      dateTime: "TEST",
      unreadCount: 1,
    );
    final int index = 1;
    final Function func = forceUpdate;
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
      body: BlocConsumer<MessageBloc, MessageState>(
        bloc: _bloc(),
        listener: (context, state) {
          if (state is MessageLoadedProductState) {
            void _refrescar() async {
              setState(() {
                // refreshState = true;
              });
              await _bloc().getUsers();
              setState(() {
                // refreshState = false;
              });
            }

            _refrescar();
          }
        },
        builder: (context, state) {
          if (state is MessageInitialState ||
              state is MessageLoadingProductState) {
            _bloc().init();
            return _loadingCenter();
          }
          if (state is MessageErrorProductState) {
            return _showErrorMessageService();
          }
          if (state is MessageLoadingProductState) {
            return _loadingCenter();
          }
          if (state is MessageLoadedProductState) {
            var message = state.message ?? [];
            if (message.isEmpty) {
              return _showErrorMessage();
            }
            return SafeArea(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 241, 241, 241),
                ),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 140),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Column(children: [...messages[index]]),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 241, 241),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 25,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    onSubmitted:
                                        (value) =>
                                            sendMessage(value, index, func),
                                    controller: messageController,
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Type here...',
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                                const Gap(15),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.mood,
                                      size: 25,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    const Gap(17),
                                    Icon(
                                      Icons.photo_camera,
                                      size: 25,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Text("Error");
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
