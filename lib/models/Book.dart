/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Book type in your schema. */
class Book extends amplify_core.Model {
  static const classType = const _BookModelType();
  final String id;
  final String? _title;
  final String? _isbn;
  final String? _thumbnail;
  final Author? _author;
  final List<BookCategory>? _categories;
  final List<BookRating>? _ratings;
  final List<Listing>? _listings;
  final List<BookWishlist>? _wishlists;
  final List<BookLibrary>? _libraries;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  BookModelIdentifier get modelIdentifier {
      return BookModelIdentifier(
        id: id
      );
  }
  
  String get title {
    try {
      return _title!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get isbn {
    try {
      return _isbn!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get thumbnail {
    return _thumbnail;
  }
  
  Author? get author {
    return _author;
  }
  
  List<BookCategory>? get categories {
    return _categories;
  }
  
  List<BookRating>? get ratings {
    return _ratings;
  }
  
  List<Listing>? get listings {
    return _listings;
  }
  
  List<BookWishlist>? get wishlists {
    return _wishlists;
  }
  
  List<BookLibrary>? get libraries {
    return _libraries;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Book._internal({required this.id, required title, required isbn, thumbnail, author, categories, ratings, listings, wishlists, libraries, createdAt, updatedAt}): _title = title, _isbn = isbn, _thumbnail = thumbnail, _author = author, _categories = categories, _ratings = ratings, _listings = listings, _wishlists = wishlists, _libraries = libraries, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Book({String? id, required String title, required String isbn, String? thumbnail, Author? author, List<BookCategory>? categories, List<BookRating>? ratings, List<Listing>? listings, List<BookWishlist>? wishlists, List<BookLibrary>? libraries}) {
    return Book._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      title: title,
      isbn: isbn,
      thumbnail: thumbnail,
      author: author,
      categories: categories != null ? List<BookCategory>.unmodifiable(categories) : categories,
      ratings: ratings != null ? List<BookRating>.unmodifiable(ratings) : ratings,
      listings: listings != null ? List<Listing>.unmodifiable(listings) : listings,
      wishlists: wishlists != null ? List<BookWishlist>.unmodifiable(wishlists) : wishlists,
      libraries: libraries != null ? List<BookLibrary>.unmodifiable(libraries) : libraries);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Book &&
      id == other.id &&
      _title == other._title &&
      _isbn == other._isbn &&
      _thumbnail == other._thumbnail &&
      _author == other._author &&
      DeepCollectionEquality().equals(_categories, other._categories) &&
      DeepCollectionEquality().equals(_ratings, other._ratings) &&
      DeepCollectionEquality().equals(_listings, other._listings) &&
      DeepCollectionEquality().equals(_wishlists, other._wishlists) &&
      DeepCollectionEquality().equals(_libraries, other._libraries);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Book {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("isbn=" + "$_isbn" + ", ");
    buffer.write("thumbnail=" + "$_thumbnail" + ", ");
    buffer.write("author=" + (_author != null ? _author!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Book copyWith({String? title, String? isbn, String? thumbnail, Author? author, List<BookCategory>? categories, List<BookRating>? ratings, List<Listing>? listings, List<BookWishlist>? wishlists, List<BookLibrary>? libraries}) {
    return Book._internal(
      id: id,
      title: title ?? this.title,
      isbn: isbn ?? this.isbn,
      thumbnail: thumbnail ?? this.thumbnail,
      author: author ?? this.author,
      categories: categories ?? this.categories,
      ratings: ratings ?? this.ratings,
      listings: listings ?? this.listings,
      wishlists: wishlists ?? this.wishlists,
      libraries: libraries ?? this.libraries);
  }
  
  Book copyWithModelFieldValues({
    ModelFieldValue<String>? title,
    ModelFieldValue<String>? isbn,
    ModelFieldValue<String?>? thumbnail,
    ModelFieldValue<Author?>? author,
    ModelFieldValue<List<BookCategory>?>? categories,
    ModelFieldValue<List<BookRating>?>? ratings,
    ModelFieldValue<List<Listing>?>? listings,
    ModelFieldValue<List<BookWishlist>?>? wishlists,
    ModelFieldValue<List<BookLibrary>?>? libraries
  }) {
    return Book._internal(
      id: id,
      title: title == null ? this.title : title.value,
      isbn: isbn == null ? this.isbn : isbn.value,
      thumbnail: thumbnail == null ? this.thumbnail : thumbnail.value,
      author: author == null ? this.author : author.value,
      categories: categories == null ? this.categories : categories.value,
      ratings: ratings == null ? this.ratings : ratings.value,
      listings: listings == null ? this.listings : listings.value,
      wishlists: wishlists == null ? this.wishlists : wishlists.value,
      libraries: libraries == null ? this.libraries : libraries.value
    );
  }
  
  Book.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _isbn = json['isbn'],
      _thumbnail = json['thumbnail'],
      _author = json['author'] != null
        ? json['author']['serializedData'] != null
          ? Author.fromJson(new Map<String, dynamic>.from(json['author']['serializedData']))
          : Author.fromJson(new Map<String, dynamic>.from(json['author']))
        : null,
      _categories = json['categories']  is Map
        ? (json['categories']['items'] is List
          ? (json['categories']['items'] as List)
              .where((e) => e != null)
              .map((e) => BookCategory.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['categories'] is List
          ? (json['categories'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => BookCategory.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _ratings = json['ratings']  is Map
        ? (json['ratings']['items'] is List
          ? (json['ratings']['items'] as List)
              .where((e) => e != null)
              .map((e) => BookRating.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['ratings'] is List
          ? (json['ratings'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => BookRating.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _listings = json['listings']  is Map
        ? (json['listings']['items'] is List
          ? (json['listings']['items'] as List)
              .where((e) => e != null)
              .map((e) => Listing.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['listings'] is List
          ? (json['listings'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Listing.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _wishlists = json['wishlists']  is Map
        ? (json['wishlists']['items'] is List
          ? (json['wishlists']['items'] as List)
              .where((e) => e != null)
              .map((e) => BookWishlist.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['wishlists'] is List
          ? (json['wishlists'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => BookWishlist.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _libraries = json['libraries']  is Map
        ? (json['libraries']['items'] is List
          ? (json['libraries']['items'] as List)
              .where((e) => e != null)
              .map((e) => BookLibrary.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['libraries'] is List
          ? (json['libraries'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => BookLibrary.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'isbn': _isbn, 'thumbnail': _thumbnail, 'author': _author?.toJson(), 'categories': _categories?.map((BookCategory? e) => e?.toJson()).toList(), 'ratings': _ratings?.map((BookRating? e) => e?.toJson()).toList(), 'listings': _listings?.map((Listing? e) => e?.toJson()).toList(), 'wishlists': _wishlists?.map((BookWishlist? e) => e?.toJson()).toList(), 'libraries': _libraries?.map((BookLibrary? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'title': _title,
    'isbn': _isbn,
    'thumbnail': _thumbnail,
    'author': _author,
    'categories': _categories,
    'ratings': _ratings,
    'listings': _listings,
    'wishlists': _wishlists,
    'libraries': _libraries,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<BookModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<BookModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final ISBN = amplify_core.QueryField(fieldName: "isbn");
  static final THUMBNAIL = amplify_core.QueryField(fieldName: "thumbnail");
  static final AUTHOR = amplify_core.QueryField(
    fieldName: "author",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Author'));
  static final CATEGORIES = amplify_core.QueryField(
    fieldName: "categories",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'BookCategory'));
  static final RATINGS = amplify_core.QueryField(
    fieldName: "ratings",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'BookRating'));
  static final LISTINGS = amplify_core.QueryField(
    fieldName: "listings",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Listing'));
  static final WISHLISTS = amplify_core.QueryField(
    fieldName: "wishlists",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'BookWishlist'));
  static final LIBRARIES = amplify_core.QueryField(
    fieldName: "libraries",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'BookLibrary'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Book";
    modelSchemaDefinition.pluralName = "Books";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        operations: const [
          amplify_core.ModelOperation.READ
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["id"], name: null),
      amplify_core.ModelIndex(fields: const ["isbn"], name: "booksByIsbn")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Book.TITLE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Book.ISBN,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Book.THUMBNAIL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Book.AUTHOR,
      isRequired: false,
      targetNames: ['authorId'],
      ofModelName: 'Author'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Book.CATEGORIES,
      isRequired: false,
      ofModelName: 'BookCategory',
      associatedKey: BookCategory.BOOK
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Book.RATINGS,
      isRequired: false,
      ofModelName: 'BookRating',
      associatedKey: BookRating.BOOK
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Book.LISTINGS,
      isRequired: false,
      ofModelName: 'Listing',
      associatedKey: Listing.BOOK
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Book.WISHLISTS,
      isRequired: false,
      ofModelName: 'BookWishlist',
      associatedKey: BookWishlist.BOOK
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Book.LIBRARIES,
      isRequired: false,
      ofModelName: 'BookLibrary',
      associatedKey: BookLibrary.BOOK
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _BookModelType extends amplify_core.ModelType<Book> {
  const _BookModelType();
  
  @override
  Book fromJson(Map<String, dynamic> jsonData) {
    return Book.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Book';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Book] in your schema.
 */
class BookModelIdentifier implements amplify_core.ModelIdentifier<Book> {
  final String id;

  /** Create an instance of BookModelIdentifier using [id] the primary key. */
  const BookModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'BookModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is BookModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}