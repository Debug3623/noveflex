class ApiUtils {
  // static const String BASE = "https://dats.digitecglobal.com/novel"; // Client Live BASE URL
  // static const String BASE = "https://apptocom.com/novelflex2";
  static const String BASE = "https://apptocom.com/novelflex2/api/v1";
  static const String URL_REGISTER_READER_API = '$BASE/reader/register';
  static const String URL_REGISTER_WRITER_API = '$BASE/writer/register';
  static const String URL_LOGIN_USER_API = '$BASE/user/login';
  static const String CHECK_STATUS_API = '$BASE/user/check_user_status';
  static const String USER_SOCIAL_REGISTER = '$BASE/user/google/register';
  static const String USER_SOCIAL_LOGIN = '$BASE/user/googlelogin';
  static const String ALL_HOME_CATEGORIES_API = '$BASE/home/category/books';
  static const String ALL_BOOKS_CATEGORIES_API = '$BASE/home/categoriesWiseBooksById';
  static const String SEARCH_CATEGORIES_API = '$BASE/categories/all';
  static const String SEARCH_AUTHOR_BY_CATEGORIES_ID_API = '$BASE/author/getByCategories';
  static const String GENERAL_CATEGORIES_NAME_API = '$BASE/categories/subcategory';
  static const String SEARCH_SUB_CATEGORIES_API = '$BASE/home/subcategory/books';
  static const String PROFILE_AUTHOR_API = '$BASE/author/profile';
  static const String EDIT_PROFILE_ = '$BASE/author/update/profile';
  static const String DELETE_ACCOUNT_PROFILE_API = '$BASE/author/delete/account';
  static const String BOOK_DETAIL_API = '$BASE/book/details';
  static const String LIKES_AND_DISLIKES_API = '$BASE/book/likesDislikes/add';
  static const String AUTHOR_PROFILE_VIEW = '$BASE/author/profile';
  static const String MAIN_CATEGORIES_DROPDOWN_API = '$BASE/categories/alls';
  static const String ADD_IMAGE_WITH_FILED_API = '$BASE/book/add';
  static const String PDF_UPLOAD_API = '$BASE/book/uploadFile';
  static const String DROPDOWN_SUB_CATEGORIES_API = '$BASE/categories/subcategories';
  static const String AUTHOR_BOOKS_DETAILS_API = '$BASE/author/bookDetails';
  static const String SAVE_BOOK_API = '$BASE/book/saved';
  static const String READER_PROFILE_API = '$BASE/book/getReaderProfile';
  static const String CHECK_PROFILE_STATUS_API = '$BASE/home/checkUserType';
  static const String UPLOAD_BACKGROUND_IMAGE_API = '$BASE/author/backgroundImage';
  static const String SAVED_BOOKS_API = '$BASE/book/all-saved';
  static const String LIKES_BOOKS_API = '$BASE/book/all-liked';
  static const String UPLOAD_BOOKS_HISTORY = '$BASE/author/books/all';
  static const String EDIT_BOOKS_API = '$BASE/book/getBooksById';
  static const String UPLOAD_BOOK_IMAGE = '$BASE/book/update/book-Image';
  static const String UPDATE_FIELDS_BOOK_API = '$BASE/book/book-update';
  static const String DELETE_PDF_API = '$BASE/book/deleteChapter';
  static const String DELETE_BOOK_API = '$BASE/book/deleteBook';
  static const String STRIPE_PAYMENT_API = '$BASE/user/subscription/payment';
  static const String USER_SUBSCRIPTION_API = '$BASE/user/subscription';

  static const String SEE_ALL_BOOKS_API = '$BASE/books/getCategoryBooks?categoryId=';
  static const String SEE_ALL_REVIEWS_API = '$BASE/books//reviews/all?bookId=';
  static const String UPLOAD_HISTORY_API = '$BASE/books/GetBooksOfUser';

  static const String DROP_DOWN_CATEGORIES_API = '$BASE/cate/all';

  static const String ADD_REVIEW_API = '$BASE/books/add/reviews';
  static const String FORGET_PASSWORD_API = '$BASE/auth/password/forgot';
  static const String UPDATE_PASSWORD_API = '$BASE/user/change_password';
  static const String PROFILE_STATUS_API = '$BASE/auth/user/type';
  static const String UPDATE_PROFILE_STATUS_API = '$BASE/auth/user/statusUpdate';
  static const String SUBSCRIBE_API = '$BASE/user/subscriptions';
  static const String AUTHOR_PROFILE_API = '$BASE/user/history';
  static const String SLIDER_API = '$BASE/home/slider';
  static const String RECENT_API = '$BASE/home/recently/book';
  static const String ALL_RECENT_API = '$BASE/home/recently/book/all';

}