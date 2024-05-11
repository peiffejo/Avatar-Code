import 'dart:ui';

import 'package:client/components/bottom_navigation_bar.dart';
import 'package:client/feature_template/widgets//layout_template.dart';
import 'package:client/feature_template/widgets/draggable_widgets/MatrixControllerDraggable.dart';
import 'package:client/feature_template/widgets/draggable_widgets/dummy_draggable.dart';
import 'package:client/feature_template/widgets/draggable_widgets/videostream_draggable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../components/custom_appbar.dart';
import '../../feature_personal_settings/service/ros_ip.service.dart';
import '../widgets/draggable_widgets/avatar_controller_draggable.dart';
import '../widgets/draggable_widgets/button_customizer_draggable.dart';
import '../widgets/draggable_widgets/record_audio_draggable.dart';
import '../widgets/draggable_widgets/example_draggable.dart';
import '../widgets/draggable_widgets/ros_audiostream_draggable.dart';
import '../widgets/draggable_widgets/ros_message_draggable.dart';
import '../widgets/draggable_widgets/ros_videostream_draggable.dart';
import '../widgets/draggable_widgets/scenarios_draggable.dart';
import '../widgets/draggable_widgets/vehicle_position_draggable.dart';
import '../widgets/draggable_widgets/vehicle_sound_draggable.dart';

class NewTemplatePage extends StatefulWidget {
  final String? currentPage;
  const NewTemplatePage({Key? key, this.currentPage,}) : super(key: key);

  @override
  State<NewTemplatePage> createState() => _NewTemplatePageState();
}

class _NewTemplatePageState extends State<NewTemplatePage> {
  //Navigation bottom-bar
  late final int _selectedIndex = int.parse(widget.currentPage!);

  //Default Values must be changed by user input
  List<String> layoutList = <String>[
    'Layout One',
    'Layout Two',
    'Layout Three',
    'Layout Four'
  ];
  String nameOfTemplate = 'Unbenannt';

  late LayoutTemplate layoutWidget = LayoutTemplate();
  late List<Widget> layoutTemplate = layoutWidget.getLayout();

  RosIp rosIp = RosIp();


  //variables for Name-Change-Overlay
  OverlayEntry? overlayEntry;
  final TextEditingController _textEditingController = TextEditingController();

  //Listener to determined position of Draggable
  Widget _createListener(Widget child) {
    return Listener(
      child: child,
      onPointerMove: (PointerMoveEvent event) {
        //When no Dragging is happening: return
        if (!_isDragging) {return;}
        //topY position from the Draggable when dragged
        RenderBox render =
            _tileViewKey.currentContext?.findRenderObject() as RenderBox;
        Offset position = render.localToGlobal(Offset.zero);
        double topY = position.dy;
        double bottomY = topY + render.size.height;

        //detectedRange from Top
        const detectedRange = kIsWeb == true ? 500 : 400;
        const moveDistance = 3;

        if (event.position.dy < topY + detectedRange && topY < 150) {
          //scroll up as long as self-layout-builder is completely in screen
          var to = _scroller.offset - moveDistance;
          to = (to < 0) ? 0 : to;
          _scroller.jumpTo(to);
        }
        if (event.position.dy > bottomY - detectedRange && topY > 0) {
          _scroller.jumpTo(_scroller.offset + moveDistance);
        }
      },
    );
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  //Values for Function: Scrolling when Draggable is dragged
  final _tileViewKey = GlobalKey();
  final ScrollController _scroller = ScrollController();
  bool _isDragging = false;

  late String layoutText = layoutList.first;
  var layoutNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: MorganaAppbar(
        color: Theme.of(context).colorScheme.background,
        title: "New Template",
        pageNumber: _selectedIndex,
        oneStack: true,
      ),
      body: SingleChildScrollView(
        controller: _scroller,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //const ScreenTitle(text: "Template"),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("ROS-IP: ${rosIp.ipVariable}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 20, vertical: 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: IconButton(
                                iconSize: 30,
                                icon: const Icon(
                                  FontAwesomeIcons.pencil,
                                ),
                                onPressed: () {
                                  nameChangeOverlay(name: nameOfTemplate);
                                },
                              ),
                            ),
                            // Textfield so Name can be changed
                            Expanded(
                              child: GestureDetector(
                                onDoubleTap: () {
                                  nameChangeOverlay(name: nameOfTemplate);
                                },
                                child: Text(nameOfTemplate,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              iconSize: 30,
                              icon: const Icon(
                                FontAwesomeIcons.folderClosed,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              iconSize: 30,
                              icon: const Icon(
                                FontAwesomeIcons.floppyDisk,
                              ),
                              onPressed: () {},
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                              child: IconButton(
                                iconSize: 30,
                                icon: const Icon(
                                  FontAwesomeIcons.circleChevronDown,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 250,
                        height: 40,
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20, vertical: 0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton<String>(
                          value: layoutText,
                          // Hide the default underline
                          underline: Container(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(1)),
                          isExpanded: true,
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              var num = 0;
                              layoutText = value!;
                              for (var element in layoutList) {
                                if (layoutText == element) {
                                  layoutNumber = num;
                                } else {
                                  num++;
                                }
                              }
                            });
                          },
                          items: layoutList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),

                          selectedItemBuilder: (BuildContext context) => layoutList
                              .map((e) => Center(
                                      child: Text(
                                    e,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )))
                              .toList(),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Row(
                                      children: [
                                        Icon(Icons.info),
                                        SizedBox(width: 5),
                                        Text('Information for deleting tiles'),
                                      ],
                                    ),
                                    content: const Text(
                                        "To delete the entire layout press the trash icon \n\n For deleting a specific tile, long-press on tile and a trash icon will be displayed.",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              250, 168, 168, 168),
                                        )),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          Container(
                            width: 45,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              iconSize: 22,
                              icon: const Icon(
                                FontAwesomeIcons.trash,
                              ),
                              onPressed: () {
                                setState(() {
                                  layoutTemplate = LayoutTemplate().getLayout();
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                key: _tileViewKey,
                height: kIsWeb == true
                    ? 1100
                    : MediaQuery.of(context).size.width * 1.2,
                width: kIsWeb == true ? 900 : MediaQuery.of(context).size.width,
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        //Layout-builder for different LayoutTemplates
                        //contains the dragtargets for the draggable
                        child: layoutTemplate[layoutNumber],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  height: 220,
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 0, vertical: 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Scrollbar(
                          thickness: 10,
                          controller: ScrollController(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              height: 200,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(VideostreamDraggable(
                                      dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(VehicleSoundDraggable(
                                      dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(RosMessageDraggable(dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(RosVideostreamDraggable(dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(RosAudiostreamDraggable(dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(ScenariosDraggable(dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(VehiclePositionDraggable(
                                      dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(ButtonDraggable(dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(ExampleDraggable(dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(DownloadAudioDraggable(dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(AvatarControllerDraggable(dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(DummyDraggable(dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _createListener(MatrixControllerDraggable(dragging: (dragging) {
                                    _isDragging = dragging;
                                  })),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
      ),
    );
  }

  void nameChangeOverlay({
    required name,
  }) {
    _textEditingController.text = nameOfTemplate;

    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Positioned(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Center(
            child: GestureDetector(
              onTap: () {
                removeNameChangeOverlay();
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _textEditingController,
                              onChanged: (value) {
                                nameOfTemplate =
                                    value; // Update the entered text
                              },
                              decoration: const InputDecoration(
                                labelText: 'Change Name',
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                removeNameChangeOverlay();
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
    Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
  }

  void removeNameChangeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
    setState(() {});
  }

}
