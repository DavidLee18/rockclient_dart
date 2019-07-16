import 'dart:convert';
import 'dart:async';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:tuple/tuple.dart';

import 'grade.dart';

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
  static const _retreat = "http://cba.sungrak.or.kr:9000/retreat";
  static const _leaders = "http://cba.sungrak.or.kr:9000/leaders";
  static const _members = "http://cba.sungrak.or.kr:9000/members";
  get uid => firebase.auth().currentUser?.uid;
  final Client _http;

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
  }
  Tuple2<int, String> resOrError(Response r) => Tuple2(r.statusCode, r.headers['content-type'].contains('application/json') ? jsonDecode(r.body)['data'] : "");
  Future<Map> get Leaders async {
    try {
      final response = await _http.get(_leaders, headers: _headers);
      final leaders = json.decode(response.body) as Map;
      return leaders;
    } catch (e) {
      throw e;
    }
  }
  Future<dynamic> register(int id, String grade) async {
    final res = await _http.post(_leaders + "/register", 
    headers: _headerRegister, body: "id=$id&grade=$grade");
    return res.body;
  }
  Future<Map> members(String name) async {
    try {
      final res = await _http.get(_members + "/search?name=$name", headers: _headers);
      final members = json.decode(res.body) as Map;
      return members;
    } catch (e) {
      throw e;
    }
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
  Future<Tuple2<int, String>> registerRetreat(String lectureHope, String originalGbs, String retreatGbs, String position) async {
    ArgumentError.checkNotNull(uid, 'uid');
    final res = await _http.post(_retreat + '/register', headers: _headers, 
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
    final res = await _http.post(_retreat +'/edit', headers: _headers,
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
    final info = json.decode(res.body) as Map;
    return Tuple2(res.statusCode, info);
  }
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
  Future<String> delete(int id) async {
    try {
      final res = await _http.delete(_leaders + "/$id", headers: _headers);
      return res.body;
    } catch (e) {
      throw e;
    }
  }
  Future<String> edit(int id, Map campuses) async {
    try {
      final res = await _http.put(_leaders + "/$id/edit", 
      headers: _headers, body: jsonEncode(campuses));
      return res.body;
    } catch (e) {
      throw e;
    }
  }
}