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


/** This is an auto generated class representing the User type in your schema. */
class User extends amplify_core.Model {
  static const classType = const _UserModelType();
  final String? _email;
  final String? _firstName;
  final String? _lastName;
  final String? _address;
  final String? _phone;
  final UserLibrary? _userLibraryRef;
  final List<UserRating>? _ratingsReceived;
  final List<UserRating>? _ratings;
  final List<Listing>? _listings;
  final Wishlist? _wishlist;
  final Cart? _cart;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => modelIdentifier.serializeAsString();
  
  UserModelIdentifier get modelIdentifier {
    try {
      return UserModelIdentifier(
        email: _email!
      );
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get firstName {
    return _firstName;
  }
  
  String? get lastName {
    return _lastName;
  }
  
  String? get address {
    return _address;
  }
  
  String? get phone {
    return _phone;
  }
  
  UserLibrary? get userLibraryRef {
    return _userLibraryRef;
  }
  
  List<UserRating>? get ratingsReceived {
    return _ratingsReceived;
  }
  
  List<UserRating>? get ratings {
    return _ratings;
  }
  
  List<Listing>? get listings {
    return _listings;
  }
  
  Wishlist? get wishlist {
    return _wishlist;
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
  
  const User._internal({required email, firstName, lastName, address, phone, userLibraryRef, ratingsReceived, ratings, listings, wishlist, cart, createdAt, updatedAt}): _email = email, _firstName = firstName, _lastName = lastName, _address = address, _phone = phone, _userLibraryRef = userLibraryRef, _ratingsReceived = ratingsReceived, _ratings = ratings, _listings = listings, _wishlist = wishlist, _cart = cart, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory User({required String email, String? firstName, String? lastName, String? address, String? phone, UserLibrary? userLibraryRef, List<UserRating>? ratingsReceived, List<UserRating>? ratings, List<Listing>? listings, Wishlist? wishlist, Cart? cart}) {
    return User._internal(
      email: email,
      firstName: firstName,
      lastName: lastName,
      address: address,
      phone: phone,
      userLibraryRef: userLibraryRef,
      ratingsReceived: ratingsReceived != null ? List<UserRating>.unmodifiable(ratingsReceived) : ratingsReceived,
      ratings: ratings != null ? List<UserRating>.unmodifiable(ratings) : ratings,
      listings: listings != null ? List<Listing>.unmodifiable(listings) : listings,
      wishlist: wishlist,
      cart: cart);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      _email == other._email &&
      _firstName == other._firstName &&
      _lastName == other._lastName &&
      _address == other._address &&
      _phone == other._phone &&
      _userLibraryRef == other._userLibraryRef &&
      DeepCollectionEquality().equals(_ratingsReceived, other._ratingsReceived) &&
      DeepCollectionEquality().equals(_ratings, other._ratings) &&
      DeepCollectionEquality().equals(_listings, other._listings) &&
      _wishlist == other._wishlist &&
      _cart == other._cart;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("firstName=" + "$_firstName" + ", ");
    buffer.write("lastName=" + "$_lastName" + ", ");
    buffer.write("address=" + "$_address" + ", ");
    buffer.write("phone=" + "$_phone" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({String? firstName, String? lastName, String? address, String? phone, UserLibrary? userLibraryRef, List<UserRating>? ratingsReceived, List<UserRating>? ratings, List<Listing>? listings, Wishlist? wishlist, Cart? cart}) {
    return User._internal(
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      userLibraryRef: userLibraryRef ?? this.userLibraryRef,
      ratingsReceived: ratingsReceived ?? this.ratingsReceived,
      ratings: ratings ?? this.ratings,
      listings: listings ?? this.listings,
      wishlist: wishlist ?? this.wishlist,
      cart: cart ?? this.cart);
  }
  
  User copyWithModelFieldValues({
    ModelFieldValue<String?>? firstName,
    ModelFieldValue<String?>? lastName,
    ModelFieldValue<String?>? address,
    ModelFieldValue<String?>? phone,
    ModelFieldValue<UserLibrary?>? userLibraryRef,
    ModelFieldValue<List<UserRating>?>? ratingsReceived,
    ModelFieldValue<List<UserRating>?>? ratings,
    ModelFieldValue<List<Listing>?>? listings,
    ModelFieldValue<Wishlist?>? wishlist,
    ModelFieldValue<Cart?>? cart
  }) {
    return User._internal(
      email: email,
      firstName: firstName == null ? this.firstName : firstName.value,
      lastName: lastName == null ? this.lastName : lastName.value,
      address: address == null ? this.address : address.value,
      phone: phone == null ? this.phone : phone.value,
      userLibraryRef: userLibraryRef == null ? this.userLibraryRef : userLibraryRef.value,
      ratingsReceived: ratingsReceived == null ? this.ratingsReceived : ratingsReceived.value,
      ratings: ratings == null ? this.ratings : ratings.value,
      listings: listings == null ? this.listings : listings.value,
      wishlist: wishlist == null ? this.wishlist : wishlist.value,
      cart: cart == null ? this.cart : cart.value
    );
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : _email = json['email'],
      _firstName = json['firstName'],
      _lastName = json['lastName'],
      _address = json['address'],
      _phone = json['phone'],
      _userLibraryRef = json['userLibraryRef'] != null
        ? json['userLibraryRef']['serializedData'] != null
          ? UserLibrary.fromJson(new Map<String, dynamic>.from(json['userLibraryRef']['serializedData']))
          : UserLibrary.fromJson(new Map<String, dynamic>.from(json['userLibraryRef']))
        : null,
      _ratingsReceived = json['ratingsReceived']  is Map
        ? (json['ratingsReceived']['items'] is List
          ? (json['ratingsReceived']['items'] as List)
              .where((e) => e != null)
              .map((e) => UserRating.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['ratingsReceived'] is List
          ? (json['ratingsReceived'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => UserRating.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _ratings = json['ratings']  is Map
        ? (json['ratings']['items'] is List
          ? (json['ratings']['items'] as List)
              .where((e) => e != null)
              .map((e) => UserRating.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['ratings'] is List
          ? (json['ratings'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => UserRating.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
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
      _wishlist = json['wishlist'] != null
        ? json['wishlist']['serializedData'] != null
          ? Wishlist.fromJson(new Map<String, dynamic>.from(json['wishlist']['serializedData']))
          : Wishlist.fromJson(new Map<String, dynamic>.from(json['wishlist']))
        : null,
      _cart = json['cart'] != null
        ? json['cart']['serializedData'] != null
          ? Cart.fromJson(new Map<String, dynamic>.from(json['cart']['serializedData']))
          : Cart.fromJson(new Map<String, dynamic>.from(json['cart']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'email': _email, 'firstName': _firstName, 'lastName': _lastName, 'address': _address, 'phone': _phone, 'userLibraryRef': _userLibraryRef?.toJson(), 'ratingsReceived': _ratingsReceived?.map((UserRating? e) => e?.toJson()).toList(), 'ratings': _ratings?.map((UserRating? e) => e?.toJson()).toList(), 'listings': _listings?.map((Listing? e) => e?.toJson()).toList(), 'wishlist': _wishlist?.toJson(), 'cart': _cart?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'email': _email,
    'firstName': _firstName,
    'lastName': _lastName,
    'address': _address,
    'phone': _phone,
    'userLibraryRef': _userLibraryRef,
    'ratingsReceived': _ratingsReceived,
    'ratings': _ratings,
    'listings': _listings,
    'wishlist': _wishlist,
    'cart': _cart,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserModelIdentifier>();
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final FIRSTNAME = amplify_core.QueryField(fieldName: "firstName");
  static final LASTNAME = amplify_core.QueryField(fieldName: "lastName");
  static final ADDRESS = amplify_core.QueryField(fieldName: "address");
  static final PHONE = amplify_core.QueryField(fieldName: "phone");
  static final USERLIBRARYREF = amplify_core.QueryField(
    fieldName: "userLibraryRef",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserLibrary'));
  static final RATINGSRECEIVED = amplify_core.QueryField(
    fieldName: "ratingsReceived",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserRating'));
  static final RATINGS = amplify_core.QueryField(
    fieldName: "ratings",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserRating'));
  static final LISTINGS = amplify_core.QueryField(
    fieldName: "listings",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Listing'));
  static final WISHLIST = amplify_core.QueryField(
    fieldName: "wishlist",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Wishlist'));
  static final CART = amplify_core.QueryField(
    fieldName: "cart",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Cart'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
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
      amplify_core.ModelIndex(fields: const ["email"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.EMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.FIRSTNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.LASTNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.ADDRESS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PHONE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: User.USERLIBRARYREF,
      isRequired: false,
      ofModelName: 'UserLibrary',
      associatedKey: UserLibrary.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.RATINGSRECEIVED,
      isRequired: false,
      ofModelName: 'UserRating',
      associatedKey: UserRating.RATEDUSER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.RATINGS,
      isRequired: false,
      ofModelName: 'UserRating',
      associatedKey: UserRating.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.LISTINGS,
      isRequired: false,
      ofModelName: 'Listing',
      associatedKey: Listing.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: User.WISHLIST,
      isRequired: false,
      ofModelName: 'Wishlist',
      associatedKey: Wishlist.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: User.CART,
      isRequired: false,
      ofModelName: 'Cart',
      associatedKey: Cart.USER
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

class _UserModelType extends amplify_core.ModelType<User> {
  const _UserModelType();
  
  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'User';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [User] in your schema.
 */
class UserModelIdentifier implements amplify_core.ModelIdentifier<User> {
  final String email;

  /** Create an instance of UserModelIdentifier using [email] the primary key. */
  const UserModelIdentifier({
    required this.email});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'email': email
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'UserModelIdentifier(email: $email)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserModelIdentifier &&
      email == other.email;
  }
  
  @override
  int get hashCode =>
    email.hashCode;
}