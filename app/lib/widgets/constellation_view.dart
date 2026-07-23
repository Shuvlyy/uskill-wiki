import 'package:app/core/utils.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:app/models/resource.dart';
import 'package:app/models/constellation_node.dart';
import 'package:app/core/theme.dart';
import 'package:app/widgets/resource_card.dart';

class ConstellationView extends StatefulWidget {
  final List<Resource> resources;

  const ConstellationView({super.key, required this.resources});

  @override
  State<ConstellationView> createState() => _ConstellationViewState();
}

class _ConstellationViewState extends State<ConstellationView> {
  final List<ConstellationNode> _nodes = [];
  final List<ConstellationLink> _links = [];
  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;

  ConstellationNode? _selectedNode;
  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _buildGraph();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerRootNode();
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _centerRootNode() {
    if (!mounted) return;
    final renderObject = context.findRenderObject() as RenderBox?;
    if (renderObject == null) return;
    
    final viewportWidth = renderObject.size.width;
    final viewportHeight = renderObject.size.height;

    final offsetX = -_minX + 500;
    final offsetY = -_minY + 400;

    final targetX = viewportWidth / 2 - offsetX;
    final targetY = viewportHeight / 2 - offsetY;

    _transformationController.value = Matrix4.identity()
      ..translate(targetX, targetY);
  }

  @override
  void didUpdateWidget(covariant ConstellationView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resources != widget.resources) {
      _buildGraph();
    }
  }

  void _buildGraph() {
    _nodes.clear();
    _links.clear();
    _selectedNode = null;

    if (widget.resources.isEmpty) return;

    final root = ConstellationNode(
      id: 'root',
      label: context.l10n.uSkillWiki,
      type: NodeType.root,
    );
    _nodes.add(root);

    final Map<String, ConstellationNode> languageNodes = {};
    final Map<String, ConstellationNode> focusNodes = {};
    final Map<String, ConstellationNode> skillNodes = {};

    for (final resource in widget.resources) {
      // language
      final langKey = resource.language;
      if (!languageNodes.containsKey(langKey)) {
        final node = ConstellationNode(
          id: 'lang_$langKey',
          label: langKey.languageLabel(context),
          type: NodeType.language,
        );
        languageNodes[langKey] = node;
        _nodes.add(node);
        _links.add(ConstellationLink(root, node));
        root.children.add(node);
      }
      final langNode = languageNodes[langKey]!;

      // focus
      final focusKey = '${langKey}_${resource.focus.name}';
      if (!focusNodes.containsKey(focusKey)) {
        final node = ConstellationNode(
          id: 'focus_$focusKey',
          label: resource.focus.label(context),
          type: NodeType.focus,
        );
        focusNodes[focusKey] = node;
        _nodes.add(node);
        _links.add(ConstellationLink(langNode, node));
        langNode.children.add(node);
      }
      final focusNode = focusNodes[focusKey]!;

      // language skill
      ConstellationNode parentForResource = focusNode;
      if (resource.languageSkill != null) {
        final skillKey = '${focusKey}_${resource.languageSkill!.name}';
        if (!skillNodes.containsKey(skillKey)) {
          final node = ConstellationNode(
            id: 'skill_$skillKey',
            label: resource.languageSkill!.label(context),
            type: NodeType.skill,
          );
          skillNodes[skillKey] = node;
          _nodes.add(node);
          _links.add(ConstellationLink(focusNode, node));
          focusNode.children.add(node);
        }
        parentForResource = skillNodes[skillKey]!;
      }

      // resource
      final resNode = ConstellationNode(
        id: 'res_${resource.id ?? resource.hashCode}',
        label: resource.title,
        type: NodeType.resource,
        resource: resource,
      );
      _nodes.add(resNode);
      _links.add(ConstellationLink(parentForResource, resNode));
      parentForResource.children.add(resNode);
    }

    _calculateRadialLayout(root);

    // bounds calculation
    _minX = _maxX = _minY = _maxY = 0;
    for (final node in _nodes) {
      if (node.position.dx < _minX) _minX = node.position.dx;
      if (node.position.dx > _maxX) _maxX = node.position.dx;
      if (node.position.dy < _minY) _minY = node.position.dy;
      if (node.position.dy > _maxY) _maxY = node.position.dy;
    }
  }

  void _calculateRadialLayout(ConstellationNode root) {
    root.position = const Offset(0, 0);

    Map<ConstellationNode, int> nodeWeights = {};

    int calculateWeight(ConstellationNode node) {
      if (node.children.isEmpty) {
        nodeWeights[node] = 1;
        return 1;
      }
      int weight = 0;
      for (final child in node.children) {
        weight += calculateWeight(child);
      }
      nodeWeights[node] = weight;
      return weight;
    }

    calculateWeight(root);

    void layoutChildren(ConstellationNode node, double startAngle, double endAngle, double radius) {
      if (node.children.isEmpty) {
        return;
      }

      final int totalWeight = nodeWeights[node] ?? 1;
      double currentAngle = startAngle;

      for (int i = 0; i < node.children.length; i++) {
        final child = node.children[i];
        final int childWeight = nodeWeights[child] ?? 1;

        final double sliceAngle = (endAngle - startAngle) * (childWeight / totalWeight);

        final childCenterAngle = currentAngle + sliceAngle / 2;
        
        final dx = radius * math.cos(childCenterAngle);
        final dy = radius * math.sin(childCenterAngle);
        child.position = Offset(dx, dy);

        double nextRadius = radius + 250;
        if (child.type == NodeType.skill) {
          nextRadius = radius + 400;
        }

        double padding = sliceAngle * 0.05;

        layoutChildren(child, currentAngle + padding, currentAngle + sliceAngle - padding, nextRadius);

        currentAngle += sliceAngle;
      }
    }

    layoutChildren(root, 0, 2 * math.pi, 250);
  }

  @override
  Widget build(BuildContext context) {
    if (_nodes.isEmpty) {
      return Center(
        child: Text(context.l10n.noResourcesAvailable)
      );
    }

    final offsetX = -_minX + 500;
    final offsetY = -_minY + 400;
    final graphWidth = (_maxX - _minX).abs() + 1000;
    final graphHeight = (_maxY - _minY).abs() + 800;

    return SizedBox(
      width: double.infinity,
      child: InteractiveViewer(
        transformationController: _transformationController,
        constrained: false,
        boundaryMargin: EdgeInsets.all(graphWidth),
        minScale: 0.1,
        maxScale: 2.0,
        child: RepaintBoundary(
          child: SizedBox(
            width: graphWidth,
            height: graphHeight,
            child: GestureDetector(
              behavior: .translucent,
              onTap: () {
                if (_selectedNode != null) {
                  setState(() => _selectedNode = null);
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // links
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ConstellationLinksPainter(
                        links: _links,
                        offsetX: offsetX,
                        offsetY: offsetY,
                      ),
                    ),
                  ),

                  // nodes
                  ..._nodes.map((node) {
                    return Transform.translate(
                      offset: Offset(
                        node.position.dx + offsetX - 60,
                        node.position.dy + offsetY - 60,
                      ),
                      child: SizedBox(
                        width: 120, // max bounds for label + node
                        child: _ConstellationNodeWidget(
                          node: node,
                          onTap: () {
                            if (node.type == NodeType.resource && node.resource != null) {
                              setState(() {
                                _selectedNode = _selectedNode == node ? null : node;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  }),

                  // selected resource card
                  if (_selectedNode != null && _selectedNode!.resource != null) ... {
                    Transform.translate(
                      offset: Offset(
                        _selectedNode!.position.dx + offsetX + 40,
                        _selectedNode!.position.dy + offsetY - 150,
                      ),
                      child: SizedBox(
                        width: 470,
                        child: GestureDetector(
                          onTap: () {},
                          behavior: .opaque,
                          child: Stack(
                            clipBehavior: .none,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ResourceCard(
                                  resource: _selectedNode!.resource!
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Material(
                                  elevation: 4,
                                  shape: const CircleBorder(),
                                  color: Colors.white,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () => setState(() => _selectedNode = null),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                        color: AppTheme.blackColor
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  }
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConstellationNodeWidget extends StatefulWidget {
  final ConstellationNode node;
  final VoidCallback onTap;

  const _ConstellationNodeWidget({
    required this.node,
    required this.onTap,
  });

  @override
  State<_ConstellationNodeWidget> createState() => _ConstellationNodeWidgetState();
}

class _ConstellationNodeWidgetState extends State<_ConstellationNodeWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color nodeColor;
    double size;
    IconData? icon;

    switch (widget.node.type) {
      case NodeType.root:
        nodeColor = AppTheme.primaryColor;
        size = 80;
        icon = Icons.hub;
        break;
      case NodeType.language:
        nodeColor = AppTheme.secondaryRedColor;
        size = 60;
        icon = Icons.language;
        break;
      case NodeType.focus:
        nodeColor = AppTheme.blackColor;
        size = 50;
        icon = Icons.track_changes;
        break;
      case NodeType.skill:
        nodeColor = Colors.teal;
        size = 40;
        icon = Icons.psychology;
        break;
      case NodeType.resource:
        nodeColor = AppTheme.primaryColor.withOpacity(0.8);
        size = 30;
        icon = Icons.description;
        break;
    }

    final isClickable = widget.node.type == NodeType.resource;

    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _isHovered ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: nodeColor,
                    shape: .circle,
                    // todo: see if its good or not
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: nodeColor.withOpacity(0.4),
                    //     blurRadius: _isHovered ? 15 : 10,
                    //     spreadRadius: _isHovered ? 4 : 2,
                    //   )
                    // ],
                  ),
                  child: Icon(icon, color: Colors.white, size: size * 0.5),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.fieldOutlineColor),
                  ),
                  child: Text(
                    widget.node.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: .w600,
                      color: AppTheme.blackColor,
                    ),
                    textAlign: .center,
                    maxLines: 2,
                    overflow: .ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _ConstellationLinksPainter extends CustomPainter {
  final List<ConstellationLink> links;
  final double offsetX;
  final double offsetY;

  _ConstellationLinksPainter({
    required this.links,
    required this.offsetX,
    required this.offsetY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.fieldOutlineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final link in links) {
      final p1 = Offset(link.source.position.dx + offsetX, link.source.position.dy + offsetY);
      final p2 = Offset(link.target.position.dx + offsetX, link.target.position.dy + offsetY);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationLinksPainter oldDelegate) => true;
}
