import 'package:flutter/material.dart';
import 'package:app/models/resource.dart';

enum NodeType { root, language, focus, skill, resource }

class ConstellationNode {
  final String id;
  final String label;
  final NodeType type;
  final Resource? resource;

  Offset position = Offset.zero;
  final List<ConstellationNode> children = [];

  ConstellationNode({
    required this.id,
    required this.label,
    required this.type,
    this.resource,
  });
}

class ConstellationLink {
  final ConstellationNode source;
  final ConstellationNode target;

  ConstellationLink(this.source, this.target);
}
