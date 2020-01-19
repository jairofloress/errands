import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech_recognition/speech_recognition.dart';

class Message{

  String type;
  List<String> data;
  String time;

  Message({this.type,this.data,this.time});
}

class MessageData{
  static List<Message> messages = [];

  static int lastSentMessage = 0;
  static int lastCheckMessage = 0;

  static void addMessage(String data){
    messages.add(Message(data: [data], type: 'Sent', time: DateFormat('hh:mm a').format(DateTime.now())));
    lastSentMessage = messages.length;
  }

}

const APP_ID = "142bcfe1aee54d29b7d06ece782b9ec7";

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// Creates a call page with given channel name.
  const CallPage({Key key, this.channelName}) : super(key: key);

  @override
  _CallPageState createState() {
    return new _CallPageState();
  }
}

class _CallPageState extends State<CallPage> {

  static final _users = List<int>();
  final _infoStrings = <String>[];
  bool muted = false;

  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  final _remoteUsers = List<int>();

  String resultText = "";
  String displayedText = "";


  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();


    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    MessageData.messages = [
      Message(
        data: ['I speak in english'],
        type: 'Receieved',
        time: '16:03'
      ),
      Message(
        data: ['I speak in Spanish'],
        type: 'Sent',
        time:  '16:05'
      ),
    ];

    initSpeechRecognizer();

    _initAgoraRtcEngine();
    _addAgoraEventHandlers();

    AgoraRtcEngine.startPreview();
    AgoraRtcEngine.joinChannel(null, '18710527017', null, 0);
  }


  void initSpeechRecognizer() {
    _speechRecognition = new SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
          (bool result) => setState(() {
        _isAvailable = result;
        print('avaibility checked');
      }),
    );

    _speechRecognition.setRecognitionStartedHandler(
          () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
          (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
          () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() {
        _isAvailable = result;
        print('activation');
      }),
    );
  }

  void startListening() {
    if (_isAvailable && !_isListening) {
      _speechRecognition.listen(locale: "en_US").then((result) {
        resultText =  result.toString();
//        fetchPost(resultText);
      });
    }
  }

  void stopListening() {
    if (_isListening) {
      _speechRecognition.cancel().then((result) {
        _isListening = result;
        resultText = "";
        displayedText = "";
      });
    }
  }

  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create('142bcfe1aee54d29b7d06ece782b9ec7');

    AgoraRtcEngine.enableVideo();
    AgoraRtcEngine.enableAudio();
    // AgoraRtcEngine.setParameters('{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}');
    AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);

    VideoEncoderConfiguration config = VideoEncoderConfiguration();
    config.orientationMode = VideoOutputOrientationMode.FixedPortrait;
    AgoraRtcEngine.setVideoEncoderConfiguration(config);
  }


  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _remoteUsers.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        String info = 'userJoined: ' + uid.toString();
        _infoStrings.add(info);
        _remoteUsers.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        String info = 'userOffline: ' + uid.toString();
        _infoStrings.add(info);
        _remoteUsers.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      setState(() {
        String info = 'firstRemoteVideo: ' +
            uid.toString() +
            ' ' +
            width.toString() +
            'x' +
            height.toString();
        _infoStrings.add(info);
      });
    };
  }


//  /// Helper function to get list of native views
//  List<Widget> _getRenderViews() {
//    List<Widget> list = [AgoraRenderWidget(0, local: true, preview: true)];
//    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
//    return list;
//  }
//
//  /// Video view wrapper
//  Widget _videoView(view) {
//    return Expanded(child: Container(child: view));
//  }
//
//  /// Video view row wrapper
//  Widget _expandedVideoRow(List<Widget> views) {
//    List<Widget> wrappedViews =
//    views.map((Widget view) => _videoView(view)).toList();
//    return Container(
//        child: Row(
//          children: wrappedViews,
//        ));
//  }
//
//  /// Video layout wrapper
//  Widget _viewRows() {
//    List<Widget> views = _getRenderViews();
//    switch (views.length) {
//      case 1:
//        return Container(
//            child: Column(
//              children: <Widget>[_videoView(views[0])],
//            ));
//      case 2:
//        return Container(
//            child: Stack(
//              children: <Widget>[
//                _expandedVideoRow([views[1]]),
//                Positioned(
//                    left: 10.0,
//                    top: 10.0,
//                    child: Container(
//                        height: 150.0,
//                        width: 100.0,
//                        child: _expandedVideoRow([views[0]])))
//              ],
//            ));
//      default:
//    }
//    return Container();
//  }

//  List<Widget> _getRenderViews() {
//    return _sessions.map((session) => session.view).toList();
//  }

  Widget _viewRows() {
    return Row(
      children: <Widget>[
        _renderWidget.toList().length == 1 ? Expanded(child: Container(child: _renderWidget.toList()[0],),) : SizedBox(),
        _renderWidget.toList().length == 2 ? Expanded(child: Container(child: _renderWidget.toList()[1],),) : SizedBox(),
//        for (final widget in _renderWidget)
//          Expanded(
//            child: Container(
//              child: widget,
//            ),
//          )
      ],
    );
  }

  Iterable<Widget> get _renderWidget sync* {
    yield AgoraRenderWidget(0, local: true, preview: false);

    for (final uid in _remoteUsers) {
      yield AgoraRenderWidget(uid);
    }
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onToggleMute(),
            child: new Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: new Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: () => _onSwitchCamera(),
            child: new Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: ListView.builder(
                  reverse: true,
                  itemCount: _infoStrings.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_infoStrings.length == 0) {
                      return null;
                    }
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.yellowAccent,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(_infoStrings[index],
                                      style:
                                          TextStyle(color: Colors.blueGrey))))
                        ]));
                  })),
        ));
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 15.0, top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 40.0,
              width: 100.0,
              margin: EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: IconButton(
                iconSize: 25.0,
                color: Colors.white,
                icon: Icon(Icons.check, color: Colors.green,),
              ),
            ),
            Container(
              height: 40.0,
              width: 100.0,
              margin: EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: IconButton(
                iconSize: 25.0,
                color: Colors.white,
                icon: Icon(Icons.mic, color: Colors.blue,),
              ),
            ),
            Container(
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () {
                  AgoraRtcEngine.stopAllEffects();
                },
                iconSize: 25.0,
                color: Colors.white,
                icon: Icon(Icons.close, color: Colors.red,),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              ListView.builder(
                padding: EdgeInsets.only(bottom: 80.0),
                reverse: true,
                itemCount: MessageData.messages.length,
                itemBuilder: (_, int index){
                  var type = MessageData.messages[index].type;

                  if(type == 'Sent'){
                    return SentMessage(
                      messageText: MessageData.messages[index].data[0],
                      messageTime: MessageData.messages[index].time,
                    );
                  } else {
                    return ReceivedMessage(
                      messageTime: MessageData.messages[index].time,
                      messageText: MessageData.messages[index].data[0],
                    );
                  }
                },
              ),
            ],
          )
        )
    );
  }
}

class SentMessage extends StatelessWidget {

  final String messageText;
  final String messageTime;

  SentMessage({this.messageText,this.messageTime});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(right: 10.0, top: 10.0, left: 12.0),
        decoration: BoxDecoration(
            color: Colors.blue.shade200,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 6.0,
              offset: Offset(0.0,3.0),
            )]
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 20.0,top: 10.0, bottom: 30.0),
              child: Wrap(
                children: <Widget>[
                  Text(messageText, style: TextStyle(color: Color(0xff3A3131), fontSize: 16.0), maxLines: 12, overflow: TextOverflow.ellipsis,)
                ],
              ),
            ),
            Positioned(
              child: Text(messageTime, style: TextStyle(color: Colors.white, fontSize: 12.0),),
              right: 12.0,
              bottom: 7.0,
            ),
          ],
        ),
      ),
    );
  }
}

class ReceivedMessage extends StatelessWidget {

  final String messageText;
  final String messageTime;

  ReceivedMessage({this.messageText,this.messageTime});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: 10.0, top: 10.0, right: MediaQuery.of(context).size.width * 0.4),
        decoration: BoxDecoration(
            color: Colors.orange.shade200,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 6.0,
              offset: Offset(0.0,3.0),
            )]
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 20.0,top: 10.0, bottom: 30.0),
              child: Wrap(
                children: <Widget>[
                  Text(messageText, style: TextStyle(color: Color(0xff3A3131), fontSize: 16.0), maxLines: 12, overflow: TextOverflow.ellipsis,)
                ],
              ),
            ),
            Positioned(
              child: Text(messageTime, style: TextStyle(color: Colors.white, fontSize: 12.0),),
              right: 12.0,
              bottom: 7.0,
            ),
          ],
        ),
      ),
    );
  }
}

