import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:todo/model/todo_list_model.dart';
import 'package:todo/model/task_model.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:todo/component/todo_badge.dart';
import 'package:todo/component/icon_picker.dart';
import 'package:todo/utils/color_utils.dart';

class AddCardScreen extends StatefulWidget {
  AddCardScreen();

  @override
  State<StatefulWidget> createState() {
    return _AddCardScreenState();
  }
}

class _AddCardScreenState extends State<AddCardScreen> {
  String newTask;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color taskColor;
  IconData taskIcon;

  @override
  void initState() {
    super.initState();
    setState(() {
      newTask = '';
      taskColor = ColorUtils.defaultColors[0];
      taskIcon = Icons.work;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
      builder: (BuildContext context, Widget child, TodoListModel model) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              '新建分类',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black26),
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
          body: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '分类将帮助您对相关任务进行分组!',
                  style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
                Container(
                  height: 16.0,
                ),
                TextField(
                  onChanged: (text) {
                    setState(() => newTask = text);
                  },
                  cursorColor: taskColor,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '分类名称...',
                      hintStyle: TextStyle(
                        color: Colors.black26,
                      )),
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 36.0),
                ),
                Container(
                  height: 26.0,
                ),
                Row(
                  children: [
                    ColorPickerBuilder(
                        color: taskColor,
                        onColorChanged: (newColor) =>
                            setState(() => taskColor = newColor)),
                    Container(
                      width: 22.0,
                    ),
                    IconPickerBuilder(
                        iconData: taskIcon,
                        highlightColor: taskColor,
                        action: (newIcon) =>
                            setState(() => taskIcon = newIcon)),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Builder(
            builder: (BuildContext context) {
              return FloatingActionButton.extended(
                heroTag: 'fab_new_card',
                icon: Icon(Icons.save),
                backgroundColor: taskColor,
                label: Text('创建分类'),
                onPressed: () {
                  if (newTask.isEmpty) {
                    final snackBar = SnackBar(
                      content: Text('似乎您正在尝试添加一个不允许在此领域中添加的隐形任务.'),
                      backgroundColor: taskColor,
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                   
                  } else {
                    model.addTask(Task(
                      newTask,
                      codePoint: taskIcon.codePoint,
                      color: taskColor.value
                    ));
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}

class ColorPickerBuilder extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;

  ColorPickerBuilder({@required this.color, @required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 32.0,
        width: 32.0,
        child: Material(
          color: color,
          child: InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('选择一个颜色'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        availableColors: ColorUtils.defaultColors,
                        pickerColor: color,
                        onColorChanged: onColorChanged,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class IconPickerBuilder extends StatelessWidget {
  final IconData iconData;
  final ValueChanged<IconData> action;
  final Color highlightColor;

  IconPickerBuilder({
    @required this.iconData,
    @required this.action,
    Color highlightColor,
  }) : this.highlightColor = highlightColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50.0),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('选择一个图标'),
              content: SingleChildScrollView(
                child: IconPicker(
                  currentIconData: iconData,
                  onIconChanged: action,
                  highlightColor: highlightColor,
                ),
              ),
            );
          },
        );
      },
      child: TodoBadge(
        id: 'id',
        codePoint: iconData.codePoint,
        color: Colors.blueGrey,
        size: 24,
      ),
    );
  }
}

// Reason for wraping fab with builder (to get scafold context)
// https://stackoverflow.com/a/52123080/4934757
