import 'package:http/http.dart' as http;

class ReactLibraryCache {
  static Map<String, String> _cachedLibraries = {};
  static bool _isInitialized = false;
  static bool _isLoading = false;

  // Libraries to preload
  static final Map<String, String> _libraryUrls = {
    'react':
        'https://cdnjs.cloudflare.com/ajax/libs/react/18.2.0/umd/react.production.min.js',
    'reactDom':
        'https://cdnjs.cloudflare.com/ajax/libs/react-dom/18.2.0/umd/react-dom.production.min.js',
    'babel':
        'https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/7.23.5/babel.min.js',
    'tailwind':
        'https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css',
  };

  // Initialize and preload all libraries
  static Future<void> initialize() async {
    if (_isInitialized || _isLoading) return;

    _isLoading = true;

    try {
      // Create http client for better connection reuse
      final client = http.Client();

      // Load all libraries in parallel
      final futures = _libraryUrls.entries.map((entry) async {
        try {
          final response = await client.get(Uri.parse(entry.value));
          if (response.statusCode == 200) {
            _cachedLibraries[entry.key] = response.body;
            print('Cached ${entry.key} library: ${entry.value}');
          } else {
            print(
                'Failed to cache ${entry.key}: Status ${response.statusCode}');
          }
        } catch (e) {
          print('Error caching ${entry.key}: $e');
        }
      }).toList();

      // Wait for all libraries to be fetched
      await Future.wait(futures);
      client.close();

      _isInitialized = true;
      print(
          'React library cache initialized with ${_cachedLibraries.length} libraries');
    } catch (e) {
      print('Error initializing library cache: $e');
    } finally {
      _isLoading = false;
    }
  }

  // Get HTML with inline libraries instead of CDN references
  static String getHtmlWithInlineLibraries(String baseHtml) {
    if (!_isInitialized) {
      print('Warning: Library cache not initialized, using CDN references');
      return baseHtml;
    }

    String result = baseHtml;

    // Replace each library reference with the cached content
    _cachedLibraries.forEach((key, content) {
      // For JavaScript libraries
      if (key != 'tailwind') {
        final scriptTag = '<script src="${_libraryUrls[key]}"></script>';
        final inlineScript = '<script>\n$content\n</script>';
        result = result.replaceAll(scriptTag, inlineScript);
      }
      // For CSS libraries
      else {
        final linkTag = '<link href="${_libraryUrls[key]}" rel="stylesheet">';
        final inlineStyle = '<style>\n$content\n</style>';
        result = result.replaceAll(linkTag, inlineStyle);
      }
    });

    return result;
  }

  // Check if a specific library is cached
  static bool isLibraryCached(String libraryKey) {
    return _cachedLibraries.containsKey(libraryKey) &&
        _cachedLibraries[libraryKey]!.isNotEmpty;
  }

  // Get loading status
  static bool get isLoading => _isLoading;
  static bool get isInitialized => _isInitialized;
}
