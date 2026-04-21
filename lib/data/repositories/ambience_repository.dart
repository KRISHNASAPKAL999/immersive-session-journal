import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:immersive_session_journal/data/models/ambience.dart';

class AmbienceRepository {
  Future<List<Ambience>> fetchAllAmbiences() async {
    try {
      final jsonString = await rootBundle.loadString('assets/ambiences.json');
      final jsonData = jsonDecode(jsonString) as List;
      return jsonData
          .map((item) => Ambience.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load ambiences: $e');
    }
  }

  Future<Ambience?> getAmbienceById(String id) async {
    final ambiences = await fetchAllAmbiences();
    try {
      return ambiences.firstWhere((ambience) => ambience.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Ambience> filterByTag(List<Ambience> ambiences, String tag) {
    return ambiences.where((ambience) => ambience.tag == tag).toList();
  }

  List<Ambience> searchAmbiences(List<Ambience> ambiences, String query) {
    if (query.isEmpty) return ambiences;
    return ambiences
        .where(
          (ambience) =>
              ambience.title.toLowerCase().contains(query.toLowerCase()) ||
              ambience.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
