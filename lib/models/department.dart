import 'package:flutter/material.dart';

class Department {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const Department({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

const List<Department> predefinedDepartments = [
  Department(
    id: 'finance',
    name: 'Finance',
    icon: Icons.cake,
    color: Colors.green,
  ),
  Department(
    id: 'law',
    name: 'Law',
    icon: Icons.toys,
    color: Colors.blue,
  ),
  Department(
    id: 'it',
    name: 'IT',
    icon: Icons.sports_basketball,
    color: Colors.teal,
  ),
  Department(
    id: 'medical',
    name: 'Medical',
    icon: Icons.flight,
    color: Colors.red,
  ),
];

