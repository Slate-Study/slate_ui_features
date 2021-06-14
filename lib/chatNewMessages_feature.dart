part of slate_ui_features;

class ChatNewMessages extends StatefulWidget{

  final ClassRoom classRoom;
  final String schoolID;
  final String userID;
  final String name;

  ChatNewMessages({Key key , @required this.classRoom , @required this.schoolID ,
   @required this.userID ,@required this.name }):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _ChatNewMessages();
  }
}

class _ChatNewMessages extends State<ChatNewMessages>{

  TextEditingController newMessage = new TextEditingController();
  final chatFocusNode = FocusNode();


  @override
  void initState(){
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool isVisible){
        if (!isVisible)
          {
            chatFocusNode.unfocus();
          }
      });
  }

  Widget chatNewMessage(BuildContext context , ClassRoom classRoom) {
    return Column(children: [

      ClipRRect(
            borderRadius: BorderRadius.circular(W(2)),
            child: Container(
              margin: EdgeInsets.only(left: W(0.5), right: W(0.5) , bottom: H(2.5) , top: H(2)),
              decoration: writeDecoration,
              child: newMessages(context , classRoom),
            )
        )

    ],);
  }

  Widget newMessages(BuildContext context , ClassRoom classRoom){

    return Row(children: [

      Padding(padding: EdgeInsets.only(left: W(5) , right: W(2) , top: H(2) , bottom: H(2) ),
        child: Container(
          width: W(70),
          decoration: BoxDecoration(border: Border.all(color: Color(0xd91a233a) , width: W(0.2)),
              borderRadius: BorderRadius.circular(W(1))),
          child: chatTextField(context , classRoom),
        ),
      ),

      Material(
        color: CupertinoColors.white,
        child: IconButton(
            padding: EdgeInsets.zero, color: CupertinoColors.activeBlue, iconSize: W(8), icon: Icon(Icons.send_rounded),
            onPressed: (){
              onSendPressed(context,classRoom);
            }
        ),
      )
    ],);
  }

  Widget chatTextField (BuildContext context , ClassRoom classRoom){
    return CupertinoTextField(
      focusNode: chatFocusNode,
      maxLines: null,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(W(4))),
      controller: newMessage,
      placeholder: "Message  # ${classRoom.className}",
    );
  }

  void onSendPressed(BuildContext context , ClassRoom classRoom) {
    String _newMessage = newMessage.text;
    if(_newMessage.isNotEmpty && _newMessage != "" && _newMessage != null)
    {
      sendMessage(context, _newMessage , classRoom);
      setState(() {
        newMessage.clear();
        _newMessage = "";
      });
    }
    else
    {
      Flushbar(
        message: "Empty message",
        duration:  Duration(seconds: 1),
        icon: Icon(CupertinoIcons.textbox),
      )..show(context);
    }
  }

  void sendMessage ( BuildContext context , String mText , ClassRoom classRoom){
    Message mNew = Message.newMessage(widget.userID, widget.name , mText , DateTime.now());
    publishMessage(mNew, classRoom, widget.schoolID);
  }

  @override
  Widget build(BuildContext context) {
    return chatNewMessage(context, widget.classRoom);
  }
}

