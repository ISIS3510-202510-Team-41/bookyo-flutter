import 'package:amplify_core/amplify_core.dart';

class Wishlist {
  final String id;
  final String userId;
  final List<BookWishlist>? books;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  static var schema;

  Wishlist({
    required this.id,
    required this.userId,
    this.books,
    this.createdAt,
    this.updatedAt,
  });
}

class BookWishlist {
  final String id;
  final String? bookId;
  final String wishlistId;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  static var schema;

  BookWishlist({
    required this.id,
    this.bookId,
    required this.wishlistId,
    this.createdAt,
    this.updatedAt,
  });
}

class Book {
  final String id;
  final String title;
  final String isbn;
  final String? thumbnail;
  final String authorId;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  static var schema;

  Book({
    required this.id,
    required this.title,
    required this.isbn,
    this.thumbnail,
    required this.authorId,
    this.createdAt,
    this.updatedAt,
  });
}

class Author {
  final String id;
  final String name;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  static var schema;

  Author({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });
}

class Listing {
  final String id;
  final String bookId;
  final String userId;
  final double price;
  final String? status;
  final List<String>? photos;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  static var schema;

  Listing({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.price,
    this.status,
    this.photos,
    this.createdAt,
    this.updatedAt,
  });
}

class User {
  final String email;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? phone;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  static var schema;

  User({
    required this.email,
    this.firstName,
    this.lastName,
    this.address,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });
}

class Cart {
  final String id;
  final String userId;
  final List<Listing>? listings;
  final String? state;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  static var schema;

  Cart({
    required this.id,
    required this.userId,
    this.listings,
    this.state,
    this.createdAt,
    this.updatedAt,
  });
}

class Notification {
  final String id;
  final String userId;
  final String message;
  final bool read;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  static var schema;

  Notification({
    required this.id,
    required this.userId,
    required this.message,
    required this.read,
    this.createdAt,
    this.updatedAt,
  });
}

class CategoryName {
  final String id;
  final String name;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  CategoryName({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  static var schema;
}

class BookCategory {
  final String id;
  final String? categoryId;
  final String bookId;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  static var schema;

  BookCategory({
    required this.id,
    this.categoryId,
    required this.bookId,
    this.createdAt,
    this.updatedAt,
  });
}

class BookRating {
  final String id;
  final String bookId;
  final int rating;
  final String? description;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  static var schema;

  BookRating({
    required this.id,
    required this.bookId,
    required this.rating,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
}

class UserRating {
  final String id;
  final String userId;
  final String ratedId;
  final int rating;
  final String? description;
  final TemporalDateTime? createdAt;
  final TemporalDateTime? updatedAt;

  static var schema;

  UserRating({
    required this.id,
    required this.userId,
    required this.ratedId,
    required this.rating,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
}
