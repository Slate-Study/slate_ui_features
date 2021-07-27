part of slate_ui_features;

class SubmissionStudentFeature extends StatefulWidget {

  final WorkStudent workStudent;
  final ClassRoom classRoom;
  final Student student;

  SubmissionStudentFeature({Key key , @required this.classRoom , 
  @required this.student , @required this.workStudent}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubmissionStudentFeature();
  }
}

class _SubmissionStudentFeature extends State<SubmissionStudentFeature> {

  TextEditingController commentField = new TextEditingController();
  final commentFocusNode = FocusNode();
  PlatformFile file;
  FilePickerResult result;
  String fName = " ";
  double _progress = 0;

  @override
  void initState(){
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool isVisible){
        if (!isVisible)
          {
            commentFocusNode.unfocus();
          }
      });
  }

  void _openFileExplorer() async
  {
    result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'pdf'],
    );

    if(result != null)
    {
      file = result.files.first;
      setState(() {
        fName = file.name;
      });
    }
  }

  Widget submission (BuildContext context)
  {
    if(widget.workStudent.submission.isSubmitted)
      {
        return submittedWork(context , widget.workStudent);
      }
    else
      {
        if(widget.workStudent.work.isActive == true)
          {
            return submitWork(context , widget.workStudent);
          }
        else
          {
            return Text("Assignment submission window is closed" ,
                style: GoogleFonts.varelaRound(color: CupertinoColors.inactiveGray) );
          }
      }
  }

  Widget submittedWork(BuildContext context, WorkStudent workStudent)
  {
    return Container(
      width:W(90),
      margin: EdgeInsets.only(left: W(7), right: W(5) , bottom: H(2) , top: H(2)),

      child: Row( crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Submitted" , style: GoogleFonts.varela(),),
              Padding(padding: EdgeInsets.only(top: H(0.5) , bottom: H(1)),
                child: timeText(workStudent.submission.subTime),),
              Text("Comments : " + workStudent.submission.subComments ,style: GoogleFonts.varela(fontSize: W(2.7)) )
            ],)) ,
          Padding(padding: EdgeInsets.only(right: W(4)) ,

              child: Material(color: Colors.white,
                  child: IconButton(icon: Icon(CupertinoIcons.doc_text , color: CupertinoColors.systemBlue, size: W(8),),
                      onPressed: (){

                        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                          builder: (context) => submittedDoc(context, workStudent),
                        ));

                      })
              ))
        ],),
    );
  }

  Widget submittedDoc (BuildContext context , WorkStudent workStudent){

    List f = workStudent.submission.subFile.split(".");
    String ext = f[f.length - 1];

    if(ext == "pdf")
    {
      return submittedPDF(context, workStudent.submission.subFile);
    }
    else if (ext == "jpg" || ext == "jpeg" || ext == "png")
    {
      return submittedImage(context , workStudent.submission.subFile);
    }
    else
    {
      return CupertinoPageScaffold(child: Center(child: Text("Invalid File format") ));
    }
  }


  Widget submitWork(BuildContext context, WorkStudent workStudent) {
    return Column(children: [

      Padding(padding: EdgeInsets.only(left: W(4) , right: W(4) , bottom: H(0.5)),
        child: LinearProgressIndicator(backgroundColor: Colors.white,
          minHeight: H(1),
          value: _progress,),),

      ClipRRect(
        borderRadius: BorderRadius.circular(W(1)),
        child: Container(
            margin: EdgeInsets.only(left: W(4), right: W(4) , bottom: H(2) , top: H(2)),
            decoration: writeDecoration,
            child: Row(crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(padding: EdgeInsets.only(left: W(2),right: W(2)) ,
                  child: uploadFile(context),
                ),

                commentText(context),

                Padding(padding: EdgeInsets.only(left: W(4) , right: W(4)) ,
                    child: submitButton(context))

              ],)
        ),
      ),

      Padding(padding: EdgeInsets.only(left: W(5) , right: W(4) , bottom: H(1)) ,
          child: FittedBox(fit: BoxFit.fitWidth ,child: Container(height: H(2.5),
            child: Text(fName , style: TextStyle(fontSize: W(2)),),),)),

    ],);
  } 

  Widget uploadFile (BuildContext context) {

    return Material(child: IconButton(icon: Icon(CupertinoIcons.paperclip , color: Color(0xff1a233a),),
        iconSize: W(6.5),
        onPressed: () {
          _openFileExplorer();
        }),
      color: Colors.white,);
  }

  Widget commentText (BuildContext context){

    return Expanded(child: Padding(padding: EdgeInsets.only(top: H(2) , bottom: H(2)),
      child: Container(
        child: CupertinoTextField(
          focusNode: commentFocusNode,
          minLines: 1,
          maxLines: 4,
          decoration: BoxDecoration(border: Border.all(color: Color(0xff1a233a) , width: W(0.2)),
              borderRadius: BorderRadius.circular(W(1.5))),
          controller: commentField,
        ),
      ),));
  }

  Widget submitButton (BuildContext context)
  {
    return Container(
      width: W(20), height: H(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(W(3)) ,
      ),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>( CupertinoColors.activeBlue )),
        child: Text("Submit" , style: GoogleFonts.varela(color: Colors.black , fontSize: W(2.5) ),),
        onPressed: (){
          String _comment = commentField.text;
          _onSubmit(_comment);
        },
      ),
    );
  }

  void _onSubmit(String _comment) async {

    if (_comment != null)
    {
      if(result != null)
      {
        if(file.name != null && file.path != null )
        {
          List f1 = file.name.split(".");
          String f2 = f1[f1.length -1 ];
          String fN;
          DateTime dt = DateTime.now();
          fN = dt.day.toString()+dt.month.toString()+dt.hour.toString()+dt.minute.toString()+ widget.student.name + file.name;

          if(f2 == "pdf")
          {

            String docPath = "/" + widget.student.schoolID + "/" + widget.classRoom.classID +
                "/" + "assignments" + "/" + widget.workStudent.work.workId + "/" + fN;

            UploadTask ut = uploadWorkDoc(context,file, widget.workStudent, widget.classRoom, widget.student , fN);

            ut.snapshotEvents.listen((event) {
              setState(() {
                commentField.clear();
                fName = " ";
                _progress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
                if(_progress == 1)
                {
                  _progress = 0;
                }
              });
            });

            ut.whenComplete(() {
              widget.workStudent.submission.addSubmissionData(docPath, _comment);
              setWorkSubmission(widget.workStudent, widget.classRoom, widget.student);
            });

          }
          else if (f2 == "jpg" || f2 == "jpeg" || f2 == "png")
          {

            UploadTask ut =  uploadWorkDoc(context ,file, widget.workStudent, widget.classRoom, widget.student , fN);

            String docPath = "/" + widget.student.schoolID + "/" + widget.classRoom.classID +
                "/" + "assignments" + "/" + widget.workStudent.work.workId + "/" + fN;

            ut.snapshotEvents.listen((event) {
              setState(() {
                commentField.clear();
                fName = " ";
                _progress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
                if(_progress == 1)
                {
                  _progress = 0;
                }
              });
            });

            widget.workStudent.submission.addSubmissionData(docPath, _comment);
            setWorkSubmission(widget.workStudent, widget.classRoom, widget.student);
          }
          else
          {
            Flushbar(
              message: "Invalid file format",
              duration:  Duration(seconds: 1),
              icon: Icon(CupertinoIcons.doc),
            )..show(context);
          }
        }

        else
        {
          Flushbar(
            message: "File Not selected",
            duration:  Duration(seconds: 1),
            icon: Icon(CupertinoIcons.doc),
          )..show(context);
        }
      }
    }
    else
    {
      Flushbar(
        message: "Comments are empty",
        duration:  Duration(seconds: 1),
        icon: Icon(CupertinoIcons.t_bubble),
      )..show(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return submission(context);
  }
}
