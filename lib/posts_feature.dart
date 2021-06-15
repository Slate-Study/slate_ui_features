part of slate_ui_features;

class PostsFeature extends StatefulWidget{

  final ClassRoom classRoom;
  final String schoolID;

  PostsFeature({Key key, @required this.classRoom , @required this.schoolID }):super(key : key);

  @override
  State<StatefulWidget> createState() {
    return _PostsFeature();
  }
}

class _PostsFeature extends State<PostsFeature>{

  Widget getPosts(BuildContext context , ClassRoom classRoom) {

    return StreamBuilder(
      stream: postsStream(context, classRoom, widget.schoolID),

      builder: (context , snapshot){

        if (!snapshot.hasData || snapshot.data == null)
        {
          return CupertinoActivityIndicator();
        }

        if(snapshot.data.docs.length == 0)
        {
          return Center(
              child: Text("No posts yet" ,
                style: GoogleFonts.varelaRound(color: CupertinoColors.inactiveGray),));
        }

        return ListView.builder(

          itemCount: snapshot.data.docs.length,
          physics: phy, padding: ei, scrollDirection: ax, shrinkWrap: swrap,
          itemBuilder: (BuildContext context, index) {

            return postType(context, snapshot.data.docs[index]);

          },
        );
      },
    );
  }

  Widget postType (BuildContext context , DocumentSnapshot doc) {

    int x;
    Map _data = doc.data();
    if(_data["postFile"] != null)
    {
      List f = _data["postFile"].split(".");
      String ext = f[f.length - 1];

      if (ext == "jpg" || ext == "jpeg" || ext == "png")
      {
        x = 2;
      }
      else if (ext == "mp4")
      {
        x = 3;
      }
      else if(ext == "pdf")
      {
        x = 4;
      }
    }
    else
    {
      x = 1;
    }

    switch (x)
    {
      case 1 :
        PostText p1 = PostText(doc);
        return textPost(context, p1);

      case 2:
        PostFile p2 = PostFile(doc);
        return imagePost(context, p2);

      case 3:
        PostFile p3 = PostFile(doc);
        return videoPost(context, p3);

      case 4:
        PostFile p4 = PostFile(doc);
        return pdfPost(context, p4);

      default:
        PostText pX = PostText(doc);
        return textPost(context, pX);
    }
  }

  @override
  Widget build(BuildContext context) {
    return getPosts(context, widget.classRoom);
  }
}