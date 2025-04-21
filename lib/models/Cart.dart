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


/** This is an auto generated class representing the Cart type in your schema. */
class Cart extends amplify_core.Model {
  static const classType = const _CartModelType();
  final String id;
  final User? _user;
  final List<Listing>? _listings;
  final CartState? _state;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  CartModelIdentifier get modelIdentifier {
      return CartModelIdentifier(
        id: id
      );
  }
  
  User? get user {
    return _user;
  }
  
  List<Listing>? get listings {
    return _listings;
  }
  
  CartState? get state {
    return _state;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Cart._internal({required this.id, user, listings, state, createdAt, updatedAt}): _user = user, _listings = listings, _state = state, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Cart({String? id, User? user, List<Listing>? listings, CartState? state}) {
    return Cart._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      user: user,
      listings: listings != null ? List<Listing>.unmodifiable(listings) : listings,
      state: state);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Cart &&
      id == other.id &&
      _user == other._user &&
      DeepCollectionEquality().equals(_listings, other._listings) &&
      _state == other._state;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Cart {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user=" + (_user != null ? _user!.toString() : "null") + ", ");
    buffer.write("state=" + (_state != null ? amplify_core.enumToString(_state)! : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Cart copyWith({User? user, List<Listing>? listings, CartState? state}) {
    return Cart._internal(
      id: id,
      user: user ?? this.user,
      listings: listings ?? this.listings,
      state: state ?? this.state);
  }
  
  Cart copyWithModelFieldValues({
    ModelFieldValue<User?>? user,
    ModelFieldValue<List<Listing>?>? listings,
    ModelFieldValue<CartState?>? state
  }) {
    return Cart._internal(
      id: id,
      user: user == null ? this.user : user.value,
      listings: listings == null ? this.listings : listings.value,
      state: state == null ? this.state : state.value
    );
  }
  
  Cart.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user = json['user'] != null
        ? json['user']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['user']))
        : null,
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
      _state = amplify_core.enumFromString<CartState>(json['state'], CartState.values),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user': _user?.toJson(), 'listings': _listings?.map((Listing? e) => e?.toJson()).toList(), 'state': amplify_core.enumToString(_state), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'user': _user,
    'listings': _listings,
    'state': _state,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<CartModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<CartModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USER = amplify_core.QueryField(
    fieldName: "user",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final LISTINGS = amplify_core.QueryField(
    fieldName: "listings",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Listing'));
  static final STATE = amplify_core.QueryField(fieldName: "state");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Cart";
    modelSchemaDefinition.pluralName = "Carts";
    
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
      key: Cart.USER,
      isRequired: false,
      targetNames: ['userId'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Cart.LISTINGS,
      isRequired: false,
      ofModelName: 'Listing',
      associatedKey: Listing.CART
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Cart.STATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
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

class _CartModelType extends amplify_core.ModelType<Cart> {
  const _CartModelType();
  
  @override
  Cart fromJson(Map<String, dynamic> jsonData) {
    return Cart.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Cart';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Cart] in your schema.
 */
class CartModelIdentifier implements amplify_core.ModelIdentifier<Cart> {
  final String id;

  /** Create an instance of CartModelIdentifier using [id] the primary key. */
  const CartModelIdentifier({
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
  String toString() => 'CartModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is CartModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}