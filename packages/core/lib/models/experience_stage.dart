enum ExperienceStage { before, during, after }

class ExperienceStep {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final bool isActive;
  final String? icon;

  const ExperienceStep({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.isActive = false,
    this.icon,
  });

  factory ExperienceStep.fromJson(Map<String, dynamic> json) => ExperienceStep(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    isCompleted: json['is_completed'] as bool? ?? false,
    isActive: json['is_active'] as bool? ?? false,
    icon: json['icon'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'is_completed': isCompleted,
    'is_active': isActive,
    'icon': icon,
  };
}

class CustomerExperience {
  final String id;
  final String appointmentId;
  final ExperienceStage stage;
  final List<ExperienceStep> steps;
  final int? emotionScore;
  final int? satisfactionScore;
  final DateTime createdAt;

  const CustomerExperience({
    required this.id,
    required this.appointmentId,
    required this.stage,
    this.steps = const [],
    this.emotionScore,
    this.satisfactionScore,
    required this.createdAt,
  });

  factory CustomerExperience.fromJson(Map<String, dynamic> json) => CustomerExperience(
    id: json['id'] as String,
    appointmentId: json['appointment_id'] as String,
    stage: ExperienceStage.values.firstWhere((e) => e.name == json['stage']),
    steps: (json['steps'] as List<dynamic>?)
        ?.map((s) => ExperienceStep.fromJson(s as Map<String, dynamic>))
        .toList() ?? [],
    emotionScore: json['emotion_score'] as int?,
    satisfactionScore: json['satisfaction_score'] as int?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'appointment_id': appointmentId,
    'stage': stage.name,
    'steps': steps.map((s) => s.toJson()).toList(),
    'emotion_score': emotionScore,
    'satisfaction_score': satisfactionScore,
    'created_at': createdAt.toIso8601String(),
  };
}
