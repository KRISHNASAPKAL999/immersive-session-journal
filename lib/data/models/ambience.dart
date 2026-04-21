class Ambience {
  final String id;
  final String title;
  final String tag; // Focus, Calm, Sleep, Reset
  final int duration; // in seconds
  final String description;
  final String imageUrl;
  final List<String> features; // e.g., [Breeze, Warm Light, Mist, Binaural]
  final String audioUrl;

  Ambience({
    required this.id,
    required this.title,
    required this.tag,
    required this.duration,
    required this.description,
    required this.imageUrl,
    required this.features,
    required this.audioUrl,
  });

  factory Ambience.fromJson(Map<String, dynamic> json) {
    return Ambience(
      id: json['id'] as String,
      title: json['title'] as String,
      tag: json['tag'] as String,
      duration: json['duration'] as int,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      features: List<String>.from(json['features'] as List),
      audioUrl: json['audioUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tag': tag,
    'duration': duration,
    'description': description,
    'imageUrl': imageUrl,
    'features': features,
    'audioUrl': audioUrl,
  };

  Ambience copyWith({
    String? id,
    String? title,
    String? tag,
    int? duration,
    String? description,
    String? imageUrl,
    List<String>? features,
    String? audioUrl,
  }) {
    return Ambience(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      features: features ?? this.features,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }
}
