class Urls {
  static const _baseUrl = 'http://35.73.30.144:2008/api/v1';

  static const getProductsUrl = '$_baseUrl/ReadProduct';
  static String deleteProductsUrl(String id) => '$_baseUrl/DeleteProduct/$id';

  //for update
  static String updateProductUrl(String id) => '$_baseUrl/UpdateProduct/$id';
}
