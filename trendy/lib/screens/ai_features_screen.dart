import 'package:flutter/material.dart';
import 'package:trendy/services/api_service.dart';

class AIFeaturesScreen extends StatefulWidget {
  @override
  _AIFeaturesScreenState createState() => _AIFeaturesScreenState();
}

class _AIFeaturesScreenState extends State<AIFeaturesScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _postController = TextEditingController();

  String _translationResult = '';
  String _moodResult = '';
  String _editResult = '';
  List<String> _editSuggestions = [];
  List<Map<String, dynamic>> _moodFeed = [];

  String _selectedLanguage = 'es';
  String _selectedMood = 'happy';

  bool _isLoading = false;

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'it', 'name': 'Italian'},
    {'code': 'pt', 'name': 'Portuguese'},
    {'code': 'ru', 'name': 'Russian'},
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'ko', 'name': 'Korean'},
    {'code': 'zh', 'name': 'Chinese'},
  ];

  final List<String> _moods = [
    'happy',
    'sad',
    'excited',
    'chill',
    'hype',
    'neutral',
  ];

  @override
  void initState() {
    super.initState();
    _loadSupportedLanguages();
    _loadSupportedMoods();
  }

  Future<void> _loadSupportedLanguages() async {
    try {
      // In a real implementation, you would call the API
      // For now, we'll use the predefined list
      setState(() {
        // Already initialized
      });
    } catch (e) {
      print('Error loading languages: $e');
    }
  }

  Future<void> _loadSupportedMoods() async {
    try {
      // In a real implementation, you would call the API
      // For now, we'll use the predefined list
      setState(() {
        // Already initialized
      });
    } catch (e) {
      print('Error loading moods: $e');
    }
  }

  Future<void> _translateText() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _translationResult = '';
    });

    try {
      final result = await ApiService.translateText(
        text: _textController.text,
        targetLanguage: _selectedLanguage,
      );

      setState(() {
        _translationResult = result['translated_text'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _translationResult = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _analyzeMood() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _moodResult = '';
    });

    try {
      final result = await ApiService.analyzeMood(_textController.text);

      setState(() {
        _moodResult =
            '${result['detected_mood']} (confidence: ${result['confidence']})';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _moodResult = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _smartEdit() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _editResult = '';
      _editSuggestions = [];
    });

    try {
      final result = await ApiService.autoEditText(_textController.text);

      setState(() {
        _editResult = result['edited_text'];
        _editSuggestions = List<String>.from(
          result['suggestions'].map((s) => s['suggestion'] as String),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _editResult = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _getMoodFeed() async {
    setState(() {
      _isLoading = true;
      _moodFeed = [];
    });

    try {
      final result = await ApiService.getMoodBasedFeed(
        preferredMood: _selectedMood,
        limit: 10,
      );

      setState(() {
        _moodFeed = List<Map<String, dynamic>>.from(result['posts']);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _moodFeed = [
          {
            'content': 'Error loading mood-based feed: $e',
            'user': {'username': 'System'},
          },
        ];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Features'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text input section
            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Enter text for AI processing',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Translation section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text Translation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Target Language:'),
                        SizedBox(width: 8),
                        DropdownButton<String>(
                          value: _selectedLanguage,
                          items: _languages.map((lang) {
                            return DropdownMenuItem(
                              value: lang['code'],
                              child: Text(lang['name']!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLanguage = value!;
                            });
                          },
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: _translateText,
                          child: Text('Translate'),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (_isLoading && _translationResult.isEmpty)
                      CircularProgressIndicator()
                    else if (_translationResult.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(_translationResult),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Mood analysis section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mood Analysis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _analyzeMood,
                      child: Text('Analyze Mood'),
                    ),
                    SizedBox(height: 8),
                    if (_isLoading && _moodResult.isEmpty)
                      CircularProgressIndicator()
                    else if (_moodResult.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(_moodResult),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Smart editing section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Editing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _smartEdit,
                      child: Text('Auto-Edit Text'),
                    ),
                    SizedBox(height: 8),
                    if (_isLoading && _editResult.isEmpty)
                      CircularProgressIndicator()
                    else if (_editResult.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edited Text:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(_editResult),
                          ),
                          SizedBox(height: 8),
                          if (_editSuggestions.isNotEmpty) ...[
                            Text(
                              'Editing Suggestions:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ..._editSuggestions
                                .map(
                                  (suggestion) => Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text('• $suggestion'),
                                  ),
                                )
                                .toList(),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Mood-based feed section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mood-Based Feed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Preferred Mood:'),
                        SizedBox(width: 8),
                        DropdownButton<String>(
                          value: _selectedMood,
                          items: _moods.map((mood) {
                            return DropdownMenuItem(
                              value: mood,
                              child: Text(mood.capitalize()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMood = value!;
                            });
                          },
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: _getMoodFeed,
                          child: Text('Get Feed'),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (_isLoading && _moodFeed.isEmpty)
                      CircularProgressIndicator()
                    else if (_moodFeed.isNotEmpty)
                      Column(
                        children: _moodFeed.map((post) {
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post['content'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'by ${post['user']['username']} • Mood: ${post['mood']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize first letter of string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
