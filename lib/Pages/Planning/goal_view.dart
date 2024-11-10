import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../backend/database_helper.dart';
import '../../backend/goals.dart';
import 'goals_add.dart';

class GoalViewPage extends StatefulWidget {
  final Goal goal;

  const GoalViewPage({super.key, required this.goal});

  @override
  _GoalViewPageState createState() => _GoalViewPageState();
}

class _GoalViewPageState extends State<GoalViewPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late double _savedAmount;

  @override
  void initState() {
    super.initState();
    _savedAmount = widget.goal.savedAmount;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: _savedAmount / widget.goal.targetAmount).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshPage(double newSavedAmount) {
    setState(() {
      _savedAmount = newSavedAmount;
      _animation = Tween<double>(begin: 0, end: _savedAmount / widget.goal.targetAmount).animate(_animationController)
        ..addListener(() {
          setState(() {});
        });
      _animationController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = widget.goal.deadlineDate.difference(DateTime.now()).inDays;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddGoalPage(goalToEdit: widget.goal),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(300, 300),
                          painter: CircularProgressPainter(
                            progress: _animation.value,
                            color: widget.goal.color,
                            strokeWidth: 15,
                          ),
                        );
                      },
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconTheme(
                          data: IconThemeData(
                            size: 48,
                            color: widget.goal.color,
                          ),
                          child: widget.goal.icon,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(_animation.value * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '\$${_savedAmount.toStringAsFixed(2)} / \$${widget.goal.targetAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Goal Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(),
                      DetailRow(
                        icon: Icons.calendar_today,
                        label: 'Deadline',
                        value: '${widget.goal.deadlineDate.year}-${widget.goal.deadlineDate.month.toString().padLeft(2, '0')}-${widget.goal.deadlineDate.day.toString().padLeft(2, '0')}',
                      ),
                      DetailRow(
                        icon: Icons.timer,
                        label: 'Days Left',
                        value: '$daysLeft days',
                      ),
                      DetailRow(
                        icon: Icons.attach_money,
                        label: 'Amount Needed',
                        value: '\$${(widget.goal.targetAmount - _savedAmount).toStringAsFixed(2)}',
                      ),
                      if (widget.goal.notes != null && widget.goal.notes!.isNotEmpty)
                        DetailRow(
                          icon: Icons.note,
                          label: 'Notes',
                          value: widget.goal.notes!,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddMoneyDialog(context);
                },
                icon: const Icon(Icons.add),
                label: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Add Money to Goal'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.goal.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMoneyDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Money to Goal'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '\$',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  final amount = double.tryParse(controller.text);
                  if (amount != null) {
                    final newSavedAmount = amount + widget.goal.savedAmount;
                    Provider.of<FinanceState>(context, listen: false)
                        .updateGoalSavedAmount(widget.goal.id!, newSavedAmount);
                    Navigator.pop(context);
                    _refreshPage(newSavedAmount);
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

// Custom Circular Progress Painter
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// Helper widget for detail rows
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}