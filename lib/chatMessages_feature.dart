part of slate_ui_features;

class ChatMessages_UI extends StatefulWidget {

  final ClassRoom classRoom;
  final String userID;
  final String schoolID;
  ChatMessages_UI({Key key, @required this.classRoom , @required this.userID , @required this.schoolID}):super(key : key);

  @override
  State<StatefulWidget> createState() {
    return _ChatMessages_UI();
  }
}

class _ChatMessages_UI extends State<ChatMessages_UI>{

  Widget chatMessages (BuildContext context , ClassRoom classRoom){
    return Expanded(child: ListView(
          padding: EdgeInsets.only(bottom: H(3) , top: H(5)),
          reverse: true,
          children: [
            chatStream(context, classRoom)
          ],
        ));
  }

  Widget chatStream(BuildContext context , ClassRoom classRoom)
  {
    return StreamBuilder(
      stream: messageStream(context, classRoom, widget.schoolID),
      builder: (context , snapshot){
        if (!snapshot.hasData || snapshot.data == null)
        {
          return CupertinoActivityIndicator();
        }
        if(snapshot.data.docs.length == 0)
        {
          return Center(
              child: Text("Send your first message" ,
                style: GoogleFonts.varelaRound(color: CupertinoColors.inactiveGray),));
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          physics: phy, scrollDirection: ax, shrinkWrap: swrap,
          itemBuilder: (BuildContext context, index) {

            Message m1 = Message(snapshot.data.docs[index] , widget.userID);
            return chatMessageBubble(context, m1);

            },);
      },);
  }

  @override
  Widget build(BuildContext context) {
    return chatMessages(context, widget.classRoom); 
  }
}