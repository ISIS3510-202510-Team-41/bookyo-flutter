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


/** This is an auto generated class representing the Listing type in your schema. */
class Listing extends amplify_core.Model {
  static const classType = const _ListingModelType();
  final String id;
  final Book? _book;
  final User? _user;
  final double? _price;
  final ListingStatus? _status;
  final List<String>? _photos;
  final Cart? _cart;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ListingModelIdentifier get modelIdentifier {
      return ListingModelIdentifier(
        id: id
      );
  }
  
  Book? get book {
    return _book;
  }
  
  User? get user {
    return _user;
  }
  
  double get price {
    try {
      return _price!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  ListingStatus? get status {
    return _status;
  }
  
  List<String> get photos {
    try {
      return _photos!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  Cart? get cart {
    return _cart;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Listing._internal({required this.id, book, user, required price, status, required photos, cart, createdAt, updatedAt}): _book = book, _user = user, _price = price, _status = status, _photos = photos, _cart = cart, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Listing({String? id, Book? book, User? user, required double price, ListingStatus? status, required List<String> photos, Cart? cart}) {
    return Listing._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      book: book,
      user: user,
      price: price,
      status: status,
      photos: photos != null ? List<String>.unmodifiable(photos) : photos,
      cart: cart);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Listing &&
      id == other.id &&
      _book == other._book &&
      _user == other._user &&
      _price == other._price &&
      _status == other._status &&
      DeepCollectionEquality().equals(_photos, other._photos) &&
      _cart == other._cart;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Listing {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("book=" + (_book != null ? _book!.toString() : "null") + ", ");
    buffer.write("user=" + (_user != null ? _user!.toString() : "null") + ", ");
    buffer.write("price=" + (_price != null ? _price!.toString() : "null") + ", ");
    buffer.write("status=" + (_status != null ? amplify_core.enumToString(_status)! : "null") + ", ");
    buffer.write("photos=" + (_photos != null ? _photos!.toString() : "null") + ", ");
    buffer.write("cart=" + (_cart != null ? _cart!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Listing copyWith({Book? book, User? user, double? price, ListingStatus? status, List<String>? photos, Cart? cart}) {
    return Listing._internal(
      id: id,
      book: book ?? this.book,
      user: user ?? this.user,
      price: price ?? this.price,
      status: status ?? this.status,
      photos: photos ?? this.photos,
      cart: cart ?? this.cart);
  }
  
  Listing copyWithModelFieldValues({
    ModelFieldValue<Book?>? book,
    ModelFieldValue<User?>? user,
    ModelFieldValue<double>? price,
    ModelFieldValue<ListingStatus?>? status,
    ModelFieldValue<List<String>?>? photos,
    ModelFieldValue<Cart?>? cart
  }) {
    return Listing._internal(
      id: id,
      book: book == null ? this.book : book.value,
      user: user == null ? this.user : user.value,
      price: price == null ? this.price : price.value,
      status: status == null ? this.status : status.value,
      photos: photos == null ? this.photos : photos.value,
      cart: cart == null ? this.cart : cart.value
    );
  }
  
  Listing.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _book = json['book'] != null
        ? json['book']['serializedData'] != null
          ? Book.fromJson(new Map<String, dynamic>.from(json['book']['serializedData']))
          : Book.fromJson(new Map<String, dynamic>.from(json['book']))
        : null,
      _user = json['user'] != null
        ? json['user']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['user']))
        : null,
      _price = (json['price'] as num?)?.toDouble(),
      _status = amplify_core.enumFromString<ListingStatus>(json['status'], ListingStatus.values),
      _photos = json['photos']?.cast<String>(),
      _cart = json['cart'] != null
        ? json['cart']['serializedData'] != null
          ? Cart.fromJson(new Map<String, dynamic>.from(json['cart']['serializedData']))
          : Cart.fromJson(new Map<String, dynamic>.from(json['cart']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'book': _book?.toJson(), 'user': _user?.toJson(), 'price': _price, 'status': amplify_core.enumToString(_status), 'photos': _photos, 'cart': _cart?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'book': _book,
    'user': _user,
    'price': _price,
    'status': _status,
    'photos': _photos,
    'cart': _cart,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ListingModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ListingModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final BOOK = amplify_core.QueryField(
    fieldName: "book",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Book'));
  static final USER = amplify_core.QueryField(
    fieldName: "user",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final PRICE = amplify_core.QueryField(fieldName: "price");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final PHOTOS = amplify_core.QueryField(fieldName: "photos");
  static final CART = amplify_core.QueryField(
    fieldName: "cart",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Cart'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Listing";
    modelSchemaDefinition.pluralName = "Listings";
    
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
      amplify_core.ModelIndex(fields: const ["id"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Listing.BOOK,
      isRequired: false,
      targetNames: ['bookId'],
      ofModelName: 'Book'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Listing.USER,
      isRequired: false,
      targetNames: ['userId'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Listing.PRICE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Listing.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Listing.PHOTOS,
      isRequired: true,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Listing.CART,
      isRequired: false,
      targetNames: ['cartId'],
      ofModelName: 'Cart'
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

class _ListingModelType extends amplify_core.ModelType<Listing> {
  const _ListingModelType();
  
  @override
  Listing fromJson(Map<String, dynamic> jsonData) {
    return Listing.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Listing';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Listing] in your schema.
 */
class ListingModelIdentifier implements amplify_core.ModelIdentifier<Listing> {
  final String id;

  /** Create an instance of ListingModelIdentifier using [id] the primary key. */
  const ListingModelIdentifier({
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
  String toString() => 'ListingModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ListingModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}