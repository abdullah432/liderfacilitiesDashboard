import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String _name;
  String _email;
  int _phonenumber;
  String _imageUrl;
  var _uid;
  bool _isTasker;
  GeoPoint _geoPoint;
  String _reg;
  String _social_security;
  String _social_security_number;
  String _address;
  bool _admin;
  List<String> _favourite;
  List<String> _booking;
  List<String> _request;
  DocumentReference reference;

  //singleton logic
  static final User user = User._internal();
  User._internal();
  factory User() {
    return user;
  }

  //assert mean these fields are manditory, other can be null
  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['email'] != null),
        // assert(map['phonenumber'] != null),
        assert(map['istasker'] != null),
        _name = map['name'],
        _email = map['email'],
        _phonenumber = map['phonenumber'],
        _imageUrl = map['imageurl'],
        _isTasker = map['istasker'],
        _social_security = map['social_security'],
        _social_security_number = map['social_security_number'],
        _reg = map['reg'],
        _admin = map['admin'],
        _address = map['address'],
        _geoPoint = map['geopoint'],
        _favourite = List.from(map['favourite']),
        _booking = List.from(map['booking']),
        _request = List.from(map['requests']);

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  get name {
    return _name;
  }

  get email {
    return _email;
  }

  get phoneNumber {
    return _phonenumber;
  }

  get imageUrl {
    return _imageUrl;
  }

  get uid {
    return _uid;
  }

  get isTasker {
    return _isTasker;
  }

  get socialsecurity {
    return _social_security;
  }

  get socialsecuritynumber {
    return _social_security_number;
  }

  get reg {
    return _reg;
  }

  get isAdmin {
    return _admin;
  }

  get address {
    return _address;
  }

  get favoriteList {
    return _favourite;
  }

  get bookingList {
    return _booking;
  }

  get requestList {
    return _request;
  }

  get geopoint {
    return _geoPoint;
  }

  void setname(String value) {
    this._name = value;
  }

  void setEmail(String value) {
    this._email = value;
  }

  void setPhoneNum(int value) {
    this._phonenumber = value;
  }

  void setImageUrl(String value) {
    this._imageUrl = value;
  }

  void setUID(var value) {
    this._uid = value;
  }

  void setUserState(bool value) {
    this._isTasker = value;
  }

  void setSocialSecurity(String value) {
    _social_security = value;
  }

  void setSocialSecurityNumber(String value) {
    _social_security_number = value;
  }

  void setReg(String value) {
    _reg = value;
  }

  void setAddress(String value) {
    _address = value;
  }

  void setGeoPoint(GeoPoint value) {
    _geoPoint = value;
  }

  void setFavouriteList(favourite){
    _favourite = favourite;
  }

  void setBookingList(booking){
    _booking = booking;
  }

  void setRequestList(request){
    _request = request;
  }

  void clearUserData() {
    _name = '';
    _email = '';
    _phonenumber = 0;
    _imageUrl = '';
    _uid = '';
  }
}
