part of slate_ui_features;


class NewPostsFeature extends StatefulWidget {

  final ClassRoom classRoom;
  final Teacher teacher;
  NewPostsFeature({Key key , @required this.classRoom , @required this.teacher}):super(key : key);

  @override
  State<StatefulWidget> createState() {
    return _NewPostsFeature();
  }
}

class _NewPostsFeature extends State<NewPostsFeature> {

  PlatformFile file;
  FilePickerResult result;
  String fName = " ";
  num fType;
  TextEditingController newTextPost = TextEditingController();
  final postFocusNode = FocusNode();
  String _newTextPost;
  double _progress = 0;

  @override
  void initState(){
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool isVisible){
        if (!isVisible)
          {
            postFocusNode.unfocus();
          }
      });
  }

  Widget _newPostsFeature (BuildContext context , ClassRoom classRoom){
    return Column(children: [
      
      Padding(padding: EdgeInsets.only(top: H(3) , bottom: H(1.5) , left: W(4) , right: W(4)) ,
          child: addPost(context, classRoom)),

      Padding(padding: EdgeInsets.only(left: W(6),right: W(6) , bottom: H(0.2)),
          child: Container(height: H(4),
            child: FittedBox(fit: BoxFit.scaleDown,child: SizedBox(
            child: Text(fName),)
          ),)),

      Padding(padding: EdgeInsets.only(left: W(5) , right: W(5) , bottom: H(1)),
        child: LinearProgressIndicator(backgroundColor: Colors.grey[50],
          value: _progress,),)

    ],);
  }

  Widget addPost(BuildContext context , ClassRoom classRoom ){

    return ClipRRect(
      borderRadius: BorderRadius.circular(W(2)),

      child: Container(
          margin: EdgeInsets.only(left: W(1), right: W(1) , bottom: H(2) , top: H(2)),
          decoration: writeDecoration,

        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.center,children: [

          Row(crossAxisAlignment: CrossAxisAlignment.start,children: [

            Padding(padding: EdgeInsets.only(left: W(1) , right: W(1) , top: H(1)),
                child: Container(width: W(10) , height: H(10) ,child: Material(color: Colors.white ,child: IconButton(icon: Icon(CupertinoIcons.paperclip) , iconSize: W(6),
                    color: Color(0xd91a233a),
                    onPressed: ( ){
                      showDialog( context: context,
                          barrierDismissible: true,
                          builder: (context) => selectFileType(context, classRoom)
                      );
                    }),),
                )) ,

            Expanded(child: Padding( padding: EdgeInsets.only(top: H(3) , bottom: H(3)),
                child: Container(
                    child: CupertinoTextField(
                      controller: newTextPost , maxLines: null, 
                      placeholder: "write # ${classRoom.className}",
                      focusNode: postFocusNode,
                      decoration: BoxDecoration( border: Border.all(color: Color(0xd91a233a) , width: W(0.2)) ,
                          borderRadius: BorderRadius.circular(W(1))),
                    ) 
                  ))) ,

            Padding(padding: EdgeInsets.only(left: W(2) , top: H(3) , right: W(2.5)) ,
              child: Container(height: H(8.5) , width: W(20) ,child: ElevatedButton(child: Text("Write") ,
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>( CupertinoColors.activeBlue )),
                onPressed: (){
                  setState(() {
                    _newTextPost = newTextPost.text;
                    onCreate();
                    newTextPost.clear(); fName = ""; result = null;
                    FocusScope.of(context).unfocus();
                  });
                },),),)

          ],),

        ],)
      ));
  }

  Widget selectFileType (BuildContext context , ClassRoom classRoom){
    return AlertDialog(

      content: Padding(padding: EdgeInsets.only(top: H(4),bottom: H(4)) ,child: Row(children: [
        Padding(padding: EdgeInsets.only(left: W(1) , right: W(2.5)) ,
            child: Material(color: Colors.white ,child: IconButton(iconSize: W(14),
                icon: Icon(CupertinoIcons.photo ), onPressed: (){

                  _openFileExplorer('jpg');
                  Navigator.of(context, rootNavigator: true).pop('dialog');

                }),)) ,

        Padding(padding: EdgeInsets.only(left: W(2.5) , right: W(2.5)) ,
            child: Material(color: Colors.white ,child: IconButton(iconSize: W(14),
                icon: Icon(CupertinoIcons.videocam_circle_fill), onPressed: (){

                  _openFileExplorer('mp4');
                  Navigator.of(context, rootNavigator: true).pop('dialog');

                }),)) ,

        Padding(padding: EdgeInsets.only(left: W(2.5) , right: W(1)) ,
            child: Material(color: Colors.white ,child: IconButton(iconSize: W(14),
                icon: Icon(CupertinoIcons.arrow_up_doc), onPressed: (){

                  _openFileExplorer('pdf');
                  Navigator.of(context, rootNavigator: true).pop('dialog');

                }),)) ,

      ],),),);
  }

  void onCreate () async {

    String folder , docPath , fileName;
    List extensions;
    PlatformFile fileX;
    DateTime dt = DateTime.now();
    String _fName;
    bool uL = true;

    if(result != null)
    {
      fileX = result.files.first;
      fileName = fileX.name;
      extensions = fileName.split('.');
      _fName = dt.day.toString().padLeft(2,'0') + dt.month.toString().padLeft(2,'0') + dt.hour.toString().padLeft(2,'0')
          + dt.minute.toString().padLeft(2,'0') + fileName;

      if(extensions.last == "jpg" || extensions.last == "jpeg" || extensions.last == "png") {
        folder = "images";
        docPath = "/" + widget.teacher.schoolID + "/" + widget.classRoom.classID +
            "/" + "posts" + "/" + folder + "/" + _fName;
      }

      else if(extensions.last == "mp4") {
        folder = "videos";
        docPath = "/" + widget.teacher.schoolID + "/" + widget.classRoom.classID +
            "/" + "posts" + "/" + folder + "/" + _fName;
      }

      else if(extensions.last == "pdf") {
        folder = "docs";
        docPath = "/" + widget.teacher.schoolID + "/" + widget.classRoom.classID +
            "/" + "posts" + "/" + folder + "/" + _fName;
      }
      else{
        uL = false;
      }

      if(_newTextPost != "" && _newTextPost != null)
      {

        if(uL)
        {
          UploadTask ut =  postFileUpload(result.files.first, widget.classRoom, folder , _fName , widget.teacher);

          ut.snapshotEvents.listen((event) {
            setState(() {
              _progress = event.bytesTransferred.toDouble() /
                  event.totalBytes.toDouble();
              if(_progress == 1.0)
              {
                _progress = 0;
              }
            });
          });

          ut.whenComplete(() {
            PostFile newPostFile = PostFile.newPost(_newTextPost, docPath, widget.teacher);
            createFilePost(widget.classRoom, newPostFile, widget.teacher);
          });

        }
        else
        {
          Flushbar(
            message: "Invalid file format",
            duration:  Duration(seconds: 1),
            icon: Icon(CupertinoIcons.textbox),
          )..show(context);
        }

      }
      else
      {
        print("here X");
        Flushbar(
          message: "Post text is empty",
          duration:  Duration(seconds: 1),
          icon: Icon(CupertinoIcons.textbox),
        )..show(context);
      }

    }
    else
    {
      if(_newTextPost != "" && _newTextPost != null)
      {
        PostText newPostText = PostText.newPost(_newTextPost, widget.teacher);
        createTextPost(widget.classRoom, newPostText , widget.teacher);
      }
      else
      {
        print("here Y");
        Flushbar(
          message: "Post text is empty",
          duration:  Duration(seconds: 1),
          icon: Icon(CupertinoIcons.textbox),
        )..show(context);
      }
    }
  }

  void _openFileExplorer(String fT) async {

    result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [fT],
    );

    if(result != null)
    {
      file = result.files.first;
      setState(() {
        fName = file.name;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return _newPostsFeature(context, widget.classRoom);
  }
}