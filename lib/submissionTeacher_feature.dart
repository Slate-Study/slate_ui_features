part of slate_ui_features;

class SubmissionTeacherFeature extends StatefulWidget{

  final ClassRoom classRoom;
  final Teacher teacher;
  final WorkTeacher workTeacher;

  SubmissionTeacherFeature({Key key , @required this.classRoom , 
  @required this.teacher , @required this.workTeacher}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubmissionTeacherFeature();
  }
}

class _SubmissionTeacherFeature extends State<SubmissionTeacherFeature> {

  Widget submissionTeacherFeature (BuildContext context , WorkTeacher workTeacher) {

    return Expanded(child: ListView(padding: EdgeInsets.zero, children: [

            Padding(padding: EdgeInsets.only(left: W(6) , right: W(4) , top: H(5)) ,
                child: submittedStudents(context, workTeacher) ),

            Padding(padding: EdgeInsets.only(left: W(6) , right: W(4) , top: H(2)) ,
                child: notSubmittedStudents(context, workTeacher) ),

          ],)
        );
  }

  Widget submittedStudents (BuildContext context , WorkTeacher workTeacher){

    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(padding: EdgeInsets.only(bottom: H(2)) ,
            child: Text("Submitted : " , style: GoogleFonts.varela(fontWeight: FontWeight.bold),)),

        Row(children: [

          Padding(padding: EdgeInsets.only(right: W(5)) ,
              child: Container(width: W(18),height: H(8),
                child: Text("Roll No." , style: TextStyle(fontSize: W(2.7)),),) ),

          Expanded(child: Container(height: H(8),
            child: Text("Name" , style: TextStyle(fontSize: W(2.7)) ),) ),

          Padding(padding: EdgeInsets.only(left: W(2),right: W(6)) ,
              child: Container(width: W(18),height: H(8),
                child: Text("Submission" , style: TextStyle(fontSize: W(2.7))),) )

        ],),

        submittedStudentsBuilder(context, workTeacher)

      ],);
  }

  Widget submittedStudentsBuilder (BuildContext context , WorkTeacher w){

    return ListView.builder(

      itemCount: w.studentsSub.length,
      physics: phy, padding: ei, scrollDirection: ax, shrinkWrap: swrap,

      itemBuilder: (BuildContext context ,int index) {
        String sID = w.studentsSub.keys.elementAt(index);
        StudentSubmission studentS = w.studentsSub[sID];

        if(studentS.isSubmitted == true)
        {
          return FutureBuilder(
            future: getStudentData(sID, widget.teacher),
            builder: (context , AsyncSnapshot<List> _stData) {
              if(_stData.data != null)
              {
                List stData = _stData.data;
                return Row(crossAxisAlignment: CrossAxisAlignment.center ,children: [

                  Padding(padding: EdgeInsets.only(right: W(5)) ,
                      child: Container(width: W(18),height: H(8),alignment: Alignment.centerLeft,
                        child: Text(stData[0] , style: TextStyle(fontSize: W(3.2)),),) ),

                  Expanded(child: Container(height: H(8), alignment: Alignment.centerLeft,
                    child: Text(stData[1] , style: TextStyle(fontSize: W(3.2)) ),) ),

                  Padding(padding: EdgeInsets.only(left: W(2)) ,
                      child: Material(color: Colors.white,
                          child: IconButton(icon: Icon(Icons.chat_bubble),
                            color: CupertinoColors.systemBlue,
                            iconSize:W(5.5),
                            onPressed: (){

                              showDialog( context: context,
                              barrierDismissible: true,
                              builder: (context) => showComments(context , studentS.subComments)
                            );

                            },),
                        )),

                  Padding(padding: EdgeInsets.only(right: W(4) , bottom: H(0.7)) ,
                      child: Material(color: Colors.white,
                          child: IconButton(icon: Icon(CupertinoIcons.doc_text_fill),
                            color: CupertinoColors.systemBlue,
                            iconSize: W(6),
                            onPressed: (){

                              Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                                  builder: (context) => submittedDoc(context, studentS )));

                            },),
                        ) )
                ],);
              }
              else
              {
                return CupertinoActivityIndicator();
              }
            });
        }
        else
        {
          return Container(width: 0 , height: 0,);
        }
      });
  }

  Widget submittedDoc (BuildContext context , StudentSubmission std){

    List f = std.subFile.split(".");
    String ext = f[f.length - 1];

    if(ext == "pdf")
    {
      return submittedPDF(context, std.subFile);
    }
    else if (ext == "jpg" || ext == "jpeg" || ext == "png")
    {
      return submittedImage(context, std.subFile);
    }
    else
    {
      return CupertinoPageScaffold(child: Center(child: Text("Invalid File format") ));
    }
  }

  Widget notSubmittedStudents (BuildContext context , WorkTeacher workTeacher){

    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(padding: EdgeInsets.only(bottom: H(2)) ,
            child: Text("Yet to Submit : " , style: GoogleFonts.varela(fontWeight: FontWeight.bold),)),

        Row(children: [

          Padding(padding: EdgeInsets.only(right: W(5)) ,
              child: Container(width: W(18),height: H(8),
                child: Text("Roll No." , style: TextStyle(fontSize: W(2.7)),),) ),

          Expanded(child: Container(height: H(8),
            child: Text("Name" , style: TextStyle(fontSize: W(2.7)) ),) ),

        ],),

        notSubmittedStudentsBuilder(context, workTeacher)
      ],);
  }

  Widget showComments (BuildContext context , String comments){
    return AlertDialog(
      title: Text("Comments" , style: GoogleFonts.varela(),),
      content: Text(comments , style: GoogleFonts.varela(),),
    );
  }

  Widget notSubmittedStudentsBuilder (BuildContext context , WorkTeacher w){

    return ListView.builder(

      itemCount: w.studentsSub.length,
      physics: phy, padding: ei, scrollDirection: ax, shrinkWrap: swrap,

      itemBuilder: (BuildContext context ,int index) {
        String sID = w.studentsSub.keys.elementAt(index);
        StudentSubmission studentS =w.studentsSub[sID];

        if(studentS.isSubmitted == false)
        {
          return FutureBuilder(
            future: getStudentData(sID, widget.teacher),
            builder: (context , AsyncSnapshot<List> _stData) {
              if(_stData.data != null)
              {
                List stData = _stData.data;
                return Row(crossAxisAlignment: CrossAxisAlignment.start ,children: [

                  Padding(padding: EdgeInsets.only(right: W(5)) ,
                      child: Container(width: W(18),height: H(8),alignment: Alignment.centerLeft,
                        child: Text(stData[0] , style: TextStyle(fontSize: W(3.2)),),) ),

                  Expanded(child: Container(height: H(8), alignment: Alignment.centerLeft,
                    child: Text(stData[1] , style: TextStyle(fontSize: W(3.2)) ),) ),

                ],);
              }
              else
              {
                return CupertinoActivityIndicator();
              }
            },);
        }
        else
        {
          return Container(width: 0 , height: 0,);
        }
      },);
  }



  @override
  Widget build(BuildContext context) {
    return submissionTeacherFeature(context, widget.workTeacher);
  }
}