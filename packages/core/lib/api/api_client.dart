class ApiClient {
  final String baseUrl;
  final Map<String, String>? defaultHeaders;

  const ApiClient({
    required this.baseUrl,
    this.defaultHeaders,
  });

  // Placeholder — will be connected to Supabase client
  // after Supabase package is added to dependencies
}
