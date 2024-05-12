import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lottie/lottie.dart';

import '../gemini_widget/chat_input_box.dart';

class SectionStreamChat extends StatefulWidget {
  final String image;
  const SectionStreamChat({
    super.key,
    required this.image,
  });

  @override
  State<SectionStreamChat> createState() => _SectionStreamChatState();
}

class _SectionStreamChatState extends State<SectionStreamChat> {
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);
  final List<Content> chats = [];
  @override
  void dispose() {
    chats.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: chats.isNotEmpty
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: ListView.builder(
                      itemBuilder: chatItem,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: chats.length,
                      reverse: false,
                    ),
                  ),
                )
              : const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Search something!'), Icon(Icons.search)],
                  ),
                ),
        ),
        if (loading) Lottie.asset("images/lottie_ai.json"),
        ChatInputBox(
          controller: controller,
          onSend: () {
            if (controller.text.isNotEmpty) {
              final searchedText = controller.text;
              chats.add(
                  Content(role: "user", parts: [Parts(text: searchedText)]));
              controller.clear();
              loading = true;

              gemini.streamChat(chats).listen((value) {
                loading = false;
                setState(() {
                  if (chats.isNotEmpty &&
                      chats.last.role == value.content?.role) {
                    chats.last.parts!.last.text =
                        '${chats.last.parts!.last.text}${value.output}';
                  } else {
                    chats.add(Content(
                        role: 'model', parts: [Parts(text: value.output)]));
                  }
                });
              });
            }
          },
        ),
      ],
    );
  }

  Widget chatItem(BuildContext context, int index) {
    final Content content = chats[index];

    return Card(
      elevation: 2,
      color: content.role == 'model'
          ? const Color.fromARGB(255, 247, 241, 241)
          : Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                content.role == 'model'
                    ? CachedNetworkImage(
                        imageUrl:
                            "https://generation-ai.eu/wp-content/uploads/elementor/thumbs/GenerationAI_Website-design_TOOLKIT-proz03fhwxacjlrl5rl61p8yp285t5s1mt13mt12jq.png",
                        width: 25.0,
                        placeholder: (context, url) => Lottie.asset(
                          "images/lottie_loading2.json",
                          height: 20.0,
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person_2_outlined,
                          color: Colors.blue,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: widget.image,
                          width: 25.0,
                          placeholder: (context, url) => Lottie.asset(
                            "images/lottie_loading2.json",
                            height: 20.0,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person_2_outlined,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                const SizedBox(width: 10.0),
                Text(
                  content.role ?? 'role',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          content.role == 'model' ? Colors.blue : Colors.white),
                ),
              ],
            ),
            Markdown(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                data:
                    content.parts?.lastOrNull?.text ?? 'cannot generate data!'),
          ],
        ),
      ),
    );
  }
}
