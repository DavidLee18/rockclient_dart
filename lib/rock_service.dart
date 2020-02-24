import 'dart:convert';
import 'dart:async';

import 'package:angular/core.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:http/http.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:tuple/tuple.dart';

extension on int {
  String get norm => this > 0 && this < 10 ? '0$this' : '$this';
}

@Injectable()
class RockService {
  static const _headers = {
    'Authorization': 'Basic YWRtaW46ZGh3bHJybGVoISEh',
    'Content-Type': 'application/json',
    };
  static const _headerRegister = {
    'Authorization': 'Basic YWRtaW46ZGh3bHJybGVoISEh',
    'Content-Type': 'application/x-www-form-urlencoded',
    };
  static const _retreatpath = "http://cba.sungrak.or.kr:9000/retreat";
  static const _leaders = "http://cba.sungrak.or.kr:9000/leaders";
  static const _members = "http://cba.sungrak.or.kr:9000/members";
  static const _mongsanpo = 'http://cba.sungrak.or.kr:9000/mongsanpo/members';
  static const _fcm = 'https://fcm.googleapis.com/fcm/send';
  static const _headerFCM = {
    'Authorization': 'key=AAAA-PRsYvs:APA91bFiNlDHb8bBp5N4CJJuhtNSiV4Ej1KIh3tkIRsUbfrmHcCPvJvphxAWwg2oLohhgll1Ui0owWyRSP3nrkSDSrnr6M3ktjo75p2YFeqSl24naWo5ILf0yXVbWu08EvbqX0w8SoGSFFml6SmwIOh12ZmAgP1bMg',
    'Content-Type': 'application/json',
    };
  String get uid => firebase.auth().currentUser?.uid;
  final Client _http;
  var _retreat = '2020_CBA_WINTER';
  String get retreat => _retreat;
  Map _messages, _noties;

  RockService(this._http) {
    if(firebase.apps.length == 0){
      firebase.initializeApp(
        apiKey: "AIzaSyBkhrchnoMwgz67nJGi3qETa6EgG1xXjM0",
        authDomain: "cba-retreat.firebaseapp.com",
        databaseURL: "https://cba-retreat.firebaseio.com",
        projectId: "cba-retreat",
        storageBucket: "cba-retreat.appspot.com",
        messagingSenderId: "1069252633339"
      );
    }
    //firebase.database().ref("Retreat/CBA").onValue.listen((v) => _retreat = v.snapshot.val());
  }
  Tuple2<int, String> resOrError(Response r) => Tuple2(r.statusCode, r.statusCode != 200 && r.headers['content-type']?.contains('application/json') == true ? jsonDecode(r.body)['data'] : '');
  Tuple2<int, Map> mapOrError(Response r) => Tuple2(r.statusCode, r.headers['content-type']?.contains('application/json') == true ? jsonDecode(r.body) : '');
  Tuple2<int, dynamic> listOrError(Response r) => Tuple2(r.statusCode, r.headers['content-type']?.contains('application/json') == true ? jsonDecode(r.body) : null);

  Future<bool> get IsLeader async => !(await isGrade());

  Future<bool> isName(String name) async {
    Map info;
    final res = await MyInfo;
    if (res.item1 == 200) {
      info = res.item2;
    } else throw Exception('${res.item1} 에러: ${res.item2['data']}');
    return info['name'] == name;
  }

  Future<bool> isGrade({String grade='MEMBER'}) async {
    Map info;
    final res = await MyInfo;
    if (res.item1 == 200) {
      info = res.item2;
    } else throw Exception('${res.item1} 에러: ${res.item2['data']}');
    return info['grade'] == grade;
  }

  Future<bool> get IsWorthy async => await isName('나진환') || await isName('김다인');

  Future<bool> get IsDev async => await isName('나진환') || await isName('김다인') || await isName('유상건') || await isName('김진석') || await isName('이재현');

  StreamSubscription<firebase.User> reactToAuth(void Function(firebase.User) onData, {Function onError}) => firebase.auth().onAuthStateChanged.listen(onData, onError: onError);

  Stream<firebase.User> get onAuthStateChanged => firebase.auth().onAuthStateChanged;

  Future<Tuple2<int, Map>> get Leaders async {
    final response = await _http.get(_leaders, headers: _headers);
    return mapOrError(response);
  }
  Future<Tuple2<int, String>> setLeader(int id, {String grade='LEADER'}) async {
    final res = await _http.post('$_leaders/register', headers: _headerRegister, body: 'id=$id&grade=$grade');
    return resOrError(res);
  }
  Future<Tuple2<int, dynamic>> members(String name) async {
    final res = await _http.get(_members + "/search?name=$name", headers: _headers);
    return listOrError(res);
  }
  Future<Tuple2<int, String>> signUp(
    String email, 
    String password,
    String name,
    String mobile,
    String birth,
    String sex,
    String campus,
    String address,
    String school,
    String major,
    String grade,
    String guide) async {
      final res = await _http.post(_members + "/join",
      headers: _headers,
      body: jsonEncode({
        "email": email,
        "password": password,
        "name": name,
        "mobile": mobile,
        "birthDate": birth,
        "sex": sex,
        "campus": campus,
        "address": address,
        "school": school,
        "major": major,
        "grade": grade,
        "guide": guide,
        })
      );
      return resOrError(res);
  }
  Future<Tuple2<int, String>> registerMongsanpo(String name, String mobile, String belongTo, String carTypeAndNumber) async {
    final res = await _http.post(_mongsanpo, headers: _headers,
    body: jsonEncode({
      'name': name,
      'mobile': mobile,
      'belongTo': belongTo,
      'carNumber': carTypeAndNumber,
    }));
    return resOrError(res);
  }
  Future<Tuple2<int, String>> registerRetreat(String lectureHope, String originalGbs, String retreatGbs, String position) async {
    ArgumentError.checkNotNull(uid, 'uid');
    final res = await _http.post(_retreatpath + '/register', headers: _headers, 
    body: jsonEncode({
      "memberUid": uid,
      "lectureHope": lectureHope,
      "originalGbs": originalGbs,
      "retreatGbs": retreatGbs,
      "position": position,
    }));
    return resOrError(res);
  }
  Future<Tuple2<int, String>> editRetreat(String retreatGbs, String position) async {
    ArgumentError.checkNotNull(uid, 'uid');
    final res = await _http.post(_retreatpath +'/edit', headers: _headers,
    body: jsonEncode({
      "memberUid": uid,
      "retreatGbs": retreatGbs,
      "position": position,
    }));
    return resOrError(res);
  }
  Future<Tuple2<int, Map>> get MyInfo async {
    ArgumentError.checkNotNull(uid, 'uid');
    final res = await _http.get('http://cba.sungrak.or.kr:9000/getMyInfo/$uid', headers: _headers);
    return mapOrError(res);
  }
  Future<bool> get RetreatRegistered async {
    final _info = await MyInfo;
      return _info.item1 == 200
      && isRegistered(_info.item2);
  }
  bool isRegistered(Map info) => info['retreat_id'] != null
      && info['position'] != null
      && info['retreatGbs'] != null
      && info['originalGbs'] != null;
  Future<bool> signIn(String email, String password) async {
    try{
      if(uid != null) await signOut();
      await firebase.auth().signInWithEmailAndPassword(email, password);
      return true;
    } catch(e) {
      throw e;
    }
  }
  void signOut() async {
    if(uid == null) return;
    await firebase.auth().signOut();
  }
  Future<Tuple2<int, String>> unsetLeader(int id) async {
    final res = await _http.delete(_leaders + "/$id", headers: _headers);
    return resOrError(res);
  }
  Future<Tuple2<int, String>> editCampuses(int id, Map campuses) async {
    final res = await _http.put(_leaders + "/$id/edit", 
    headers: _headers, body: jsonEncode(campuses));
    return resOrError(res);
  }
  Future<dynamic> resetPass(String email) async => await firebase.auth().sendPasswordResetEmail(email);
  StreamSubscription<firebase.QueryEvent> reactToMessages(void Function(firebase.QueryEvent) onData, {Function onError}) {
    var messagesRef = firebase.database().ref("$retreat/message");
    return messagesRef.onValue.listen(onData, onError: onError);
  }

  StreamSubscription<firebase.QueryEvent> reactToNoties(void Function(firebase.QueryEvent) onData, {Function onError}) {
    var notiesRef = firebase.database().ref("$retreat/noti");
    return notiesRef.onValue.listen(onData, onError: onError);
  }
  void notify(String message, {String title='CBA 본부', bool isNoti=false}) async {
    final res = await _http.post(_fcm, headers: _headerFCM,
    body: jsonEncode({
      "to": 'topics/' + (isNoti ? "cba_admin" : retreat),
      "notification": {
        "body": message,
        "title": title,
      }
    }));
  }
  void saveMessage(String message, {String author='CBA 본부', bool isNoti=false}) async {
    var ref = firebase.database().ref('$retreat/${isNoti ? "noti" : "message"}').push();
    ref.child('uid').set(this.uid ?? '');
    ref.child('author').set(author);
    ref.child('isStaff').set('공지');
    ref.child('message').set(message);
    var now = DateTime.now();
    ref.child('time').set('${now.month.norm}-${now.day.norm} ${now.hour.norm}:${now.minute.norm}');
  }
  void deleteMessage(String key, {bool isNoti=false}) async {
    var ref = firebase.database().ref('$retreat/${isNoti ? "noti" : "message"}').child(key);
    ref.remove();
  }
  void alert(String message) => getWindow().alert(message);
}