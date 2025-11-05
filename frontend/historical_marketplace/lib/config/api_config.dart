class ApiConfig {
  // Базовый URL вашего Java-бэкенда
  // Для локальной разработки:
  static const String baseUrl = 'http://localhost:8080';
  
  // Для эмулятора Android (если запускаете приложение на эмуляторе):
  // static const String baseUrl = 'http://10.0.2.2:8080';
  
  // Для физического устройства (замените на IP вашего компьютера):
  // static const String baseUrl = 'http://192.168.1.100:8080';
  
  // API endpoints
  static const String products = '/api/products';
  static const String auth = '/api/auth';
  static const String orders = '/api/orders';
  static const String cart = '/api/cart';
  static const String reviews = '/api/reviews';
  
  // Полный URL для эндпоинта
  static String getProductsUrl() => '$baseUrl$products';
  static String getProductUrl(int id) => '$baseUrl$products/$id';
  static String searchProductsUrl() => '$baseUrl$products/search';
  static String getAuthUrl(String endpoint) => '$baseUrl$auth/$endpoint';
  static String getOrdersUrl() => '$baseUrl$orders';
  static String getCartUrl() => '$baseUrl$cart';
  static String getReviewsUrl(int productId) => '$baseUrl$reviews/product/$productId';
}


