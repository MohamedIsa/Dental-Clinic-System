import 'package:flutter/material.dart';

class Users {
  String id;
  String name;
  String email;
  String role;
  String phone;
  String cpr;
  String gender;
  String dob;
  Color? color;
  Users(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.phone,
      required this.cpr,
      required this.dob,
      required this.gender,
      this.color});

  factory Users.fromFirestore(Map<String, dynamic> data, String id) {
    return Users(
      id: id,
      name: data['name'],
      email: data['email'],
      role: data['role'],
      phone: data['phone'],
      cpr: data['cpr'],
      gender: data['gender'],
      dob: data['dob'],
      color: data['color'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'cpr': cpr,
      'gender': gender,
      'dob': dob,
      'color': color,
    };
  }
}
