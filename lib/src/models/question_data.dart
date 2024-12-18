class QuestionData {
  final String questionId;
  final String title;
  final String writer;
  final String category;
  final String questionType;
  final String description;
  final List<String> languages;
  final Map<String, String> codeSnippets;
  final String? hint;
  final String? answer;
  final List<String>? answerList;
  final String tier;
  final List<String> solvers;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuestionData({
    required this.questionId,
    required this.title,
    required this.writer,
    required this.category,
    required this.questionType,
    required this.description,
    required this.languages,
    required this.codeSnippets,
    required this.hint,
    required this.answer,
    required this.answerList,
    required this.tier,
    required this.solvers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      questionId: json['questionId'] ?? '',
      title: json['title'] ?? 'Untitled',
      writer: json['writer'] ?? 'Unknown',
      category: json['category'] ?? 'General',
      questionType: json['questionType'] ?? 'Unknown',
      description: json['description'] ?? '',
      languages: List<String>.from(json['languages'] ?? []), // 명시적 변환
      codeSnippets: Map<String, String>.from(json['codeSnippets'] ?? {}),
      hint: json['hint'],
      answer: json['answer'],
      answerList: json['answerList'] != null
          ? List<String>.from(json['answerList'] ?? [])
          : null, // null 처리 및 명시적 변환
      tier: json['tier'] ?? 'Bronze',
      solvers: List<String>.from(json['solvers'] ?? []),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'title': title,
      'writer': writer,
      'category': category,
      'questionType': questionType,
      'description': description,
      'languages': languages,
      'codeSnippets': codeSnippets,
      'hint': hint,
      'answer': answer,
      'answerList': answerList,
      'tier': tier,
      'solvers': solvers,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  QuestionData copyWith({
    String? questionId,
    String? title,
    String? writer,
    String? category,
    String? questionType,
    String? description,
    List<String>? languages,
    Map<String, String>? codeSnippets,
    String? hint,
    String? answer,
    List<String>? answerList,
    String? tier,
    List<String>? solvers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuestionData(
      questionId: questionId ?? this.questionId,
      title: title ?? this.title,
      writer: writer ?? this.writer,
      category: category ?? this.category,
      questionType: questionType ?? this.questionType,
      description: description ?? this.description,
      languages: languages ?? this.languages,
      codeSnippets: codeSnippets ?? this.codeSnippets,
      hint: hint ?? this.hint,
      answer: answer ?? this.answer,
      answerList: answerList ?? this.answerList,
      tier: tier ?? this.tier,
      solvers: solvers ?? this.solvers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
