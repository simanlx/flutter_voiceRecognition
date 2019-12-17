// tutorial from: https://github.com/tensor-programming/flutter_speech_to_text



import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart'; // import speech recognition package
import 'package:animated_text_kit/animated_text_kit.dart'; //import animated text for title

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoiceHome(title: 'Speech Recognition tutorial'),
      debugShowCheckedModeBanner: false,
    );
  }
}


//home widget
class VoiceHome extends StatefulWidget {
  VoiceHome({Key key, this.title}) : super(key: key);
  final String title;
  

  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState(){
    super.initState();
  }

// speech recognition logic
  void initSpeechRecognizer(){
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState( () => _isAvailable = result),);

    _speechRecognition.setRecognitionStartedHandler(
      () => setState (() => _isListening = true),
    );
    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState (() => resultText = speech),
    );
    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );
    _speechRecognition.activate().then(
      (result) => setState(() => _isAvailable = result),
    );

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //   appBar: AppBar(
    //   title: Text(widget.title),
    //    backgroundColor: Colors.transparent,
    // ),
      body: Container(
        // Add box decoration
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.indigo[800],
            Colors.indigo[700],
            Colors.indigo[600],
            Colors.indigo[500],
          ],
        ),
      ),
        child: 
        
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            // added a fading title
            FadeAnimatedTextKit(
              onTap: () {
                print("Tap Event");
                      },
                    text: [
                      "Voice Recognition",
                      "Voice Record",
                      "Voice to text"
                    ],
                    textStyle: TextStyle(
                        fontSize: 32.0, 
                        fontWeight: FontWeight.w100,color: Colors.white
                    ),
                  ),
            
            //row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
             
              children: <Widget>[
                //button
                FloatingActionButton(
                  child: Icon(Icons.cancel),
                  mini: true,
                  onPressed: (){
                    if (_isListening)
                      _speechRecognition.cancel().then(
                            (result) => setState(() {
                                  _isListening = result;
                                  resultText = "";
                                }),
                          );
                          debugPrint('cancelled..');
                  },
                ),
                // button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                  child: Icon(Icons.mic),

                    onPressed: (){
                      print("recording..");
                       if (_isAvailable && !_isListening)
                      _speechRecognition
                          .listen(locale: "en_US")
                          .then((result) => print('$result'));
                          
                    },
                  ),
                ),
                // button
                FloatingActionButton(
                child: Icon(Icons.stop),
                  mini: true,
                  onPressed: (){
                    if (_isListening)
                      _speechRecognition.stop().then(
                            (result) => setState(() => _isListening = result),
                          );
                          debugPrint('stopped..');
                  },
                ),
              ],
              
            ),

            //text container
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Text(
                resultText,
                style: TextStyle(fontSize: 24.0,color: Colors.white),
              ),
            )
          ],
        ),
      ),

    );
  }
}
