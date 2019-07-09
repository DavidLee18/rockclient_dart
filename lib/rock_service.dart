import 'dart:convert';
import 'dart:async';

import 'package:angular/core.dart';
import 'package:http/http.dart';

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
  static String _uid = null;
  get uid => _uid;
  set uid(String val) { _uid = val; }
  final Client _http;

  RockService(this._http);
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
  Future<String> signUp(
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
      try {
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
        return res.body;
      } catch (e) {
        throw e;
      }
  }
  Future<String> registerRetreat(String lectureHope, String originalGbs, String retreatGbs, String position) async {
    try{
      if(uid == null) throw ArgumentError("uid is not defined");
      final res = await _http.post(_retreat + '/register', headers: _headers, 
      body: jsonEncode({
        "memberUid": _uid,
        "lectureHope": lectureHope,
        "originalGbs": originalGbs,
        "retreatGbs": retreatGbs,
        "position": position,
      }));
    return res.body;
    }
    catch(e) { throw e; }
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