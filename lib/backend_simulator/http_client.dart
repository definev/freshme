class APIEndpoints {
  /// [POST] /api/v1/donation/items/
  ///
  /// [header]
  /// - [Authorization]: Bearer <token>
  /// - [Content-Type]: application/json
  ///
  /// [body] - The body of the request.
  /// - list of donations [items]
  ///   - [name] - The name of the item.
  ///   - [boundingBox] - The bounding box of the item.
  ///     - [top] - The top of the bounding box.
  ///     - [left] - The left of the bounding box.
  ///     - [right] - The right of the bounding box.
  ///     - [bottom] - The bottom of the bounding box.
  /// - [image] - The image of the donation.
  ///
  static const postDonationItems = '/api/donation/items';

  /// [GET] /api/v1/donation/items/${uid}
  ///
  /// [header]
  ///  - [Authorization]: Bearer <token>
  /// - [Content-Type]: application/json
  static String getDonationItems(String uid) => '/api/donation/items/$uid';

  /// [GET] /api/v1/donation/campaigns/
  ///
  /// [header]
  /// - [Content-Type]: application/json
  ///
  /// [query]
  /// - [page] - The page of the results.
  /// - [limit] - The number of results per page.
  static getDonationCampaigns(
    int page,
    int count, [
    String? categoryId,
  ]) =>
      '/api/donation/campaigns?page=$page&count=$count${categoryId != null ? '&categoryId=$categoryId' : ''}';

  /// [GET] /api/v1/donation/campaigns/
  ///
  /// [header]
  /// - [Content-Type]: application/json
  static const getDonationCategories = '/api/donation/categories';
}
