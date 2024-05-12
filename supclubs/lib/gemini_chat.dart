import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:supclubs/widgets/sections/chat_stream.dart';

import 'widgets/sections/stream.dart';

class SectionItem {
  final int index;
  final String title;
  final Icon myicon;
  final Widget widget;

  SectionItem(this.index, this.title, this.widget, this.myicon);
}

class ChatGemini extends StatefulWidget {
  final String image;
  const ChatGemini({super.key, required this.image});

  @override
  State<ChatGemini> createState() => _ChatGeminiState();
}

class _ChatGeminiState extends State<ChatGemini> {
  int _selectedItem = 0;
  late List<SectionItem> _sections;

  @override
  void initState() {
    super.initState();
    _initializeSections();
  }

  void _initializeSections() {
    _sections = [
      SectionItem(0, 'Stream text',  const SectionTextStreamInput(),
          const Icon(Icons.text_fields_sharp)),
      SectionItem(1, 'Stream chat',  SectionStreamChat(image: widget.image),
          const Icon(Icons.chat_outlined)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Sup\'Clubs Bot'),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        actions: [
          PopupMenuButton<int>(
            initialValue: _selectedItem,
            onSelected: (value) => setState(() => _selectedItem = value),
            itemBuilder: (context) => _sections.map((e) {
              return PopupMenuItem<int>(
                  value: e.index,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      e.myicon,
                      Text(e.title),
                    ],
                  ));
            }).toList(),
            child: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedItem,
        children: _sections.map((e) => e.widget).toList(),
      ),
    );
  }
}
