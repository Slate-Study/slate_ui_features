part of slate_ui_features;

class NewWorkFeature extends StatefulWidget{

  final ClassRoom classRoom;
  final Teacher teacher;

  NewWorkFeature({Key key , @required this.classRoom , @required this.teacher}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewWorkFeature();
  }
}

class _NewWorkFeature extends State<NewWorkFeature>{

  final titleFocusNode = FocusNode();
  final contentFocusNode = FocusNode();

  @override
  void initState(){
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool isVisible){
        if (!isVisible)
          {
            titleFocusNode.unfocus();
            contentFocusNode.unfocus();
          }
      });
  }

  Widget newWork (BuildContext context , ClassRoom classRoom){

    return FloatingActionButton.extended(
        onPressed: () {
          showDialog( context: context,
              barrierDismissible: true,
              builder: (context) => newWorkCreation(context , classRoom)
          );
        },
        label: Text('Create', style: GoogleFonts.varelaRound(),),
        icon: Icon(CupertinoIcons.plus_app),
        backgroundColor: Color(0xe61a233a)
    );
  }

  Widget newWorkCreation (BuildContext context , ClassRoom cr) {

    TextEditingController title = TextEditingController();
    TextEditingController content = TextEditingController();

    String _title; String _content;

    return AlertDialog(

      title: Text("Assign New Work" , style: GoogleFonts.varela(),),

      content: Container(width: W(72) , child: Column(mainAxisSize: MainAxisSize.min ,children: [

        Padding(padding: EdgeInsets.only(top: H(3) , bottom: H(3)) , child: Container(height: H(8),
            child: CupertinoTextField( controller: title, focusNode: titleFocusNode,
            placeholder: "Task title" ))),

        Container( child: CupertinoTextField(
          controller: content, focusNode: contentFocusNode,
          placeholder: "Task description" , maxLines: null,
        )),

      ])),

      actions: [
        Padding(padding: EdgeInsets.only(top: H(3) , bottom: H(3)) , child: Container(height: H(8), width: W(22),
            child: ElevatedButton(child: Text("Create" , style: GoogleFonts.varela(color: Colors.black),) ,
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>( CupertinoColors.activeBlue )),
              onPressed: () async {

                _title = title.text; _content = content.text;

                if(_title != "" && _content != "")
                {
                  WorkTeacher nWork = WorkTeacher.createWork(_title, _content, cr.students);
                  createWork(nWork, cr, widget.teacher);

                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }
                else
                {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }
              },)),)
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return newWork(context, widget.classRoom);
  }
}