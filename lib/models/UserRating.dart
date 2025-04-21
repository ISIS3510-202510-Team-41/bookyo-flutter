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


/** This is an auto generated class representing the UserRating type in your schema. */
class UserRating extends amplify_core.Model {
  static const classType = const _UserRatingModelType();
  final String id;
  final User? _user;
  final User? _ratedUser;
  final int? _rating;
  final String? _description;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserRatingModelIdentifier get modelIdentifier {
      return UserRatingModelIdentifier(
        id: id
      );
  }
  
  User? get user {
    return _user;
  }
  
  User? get ratedUser {
    return _ratedUser;
  }
  
  int get rating {
    try {
      return _rating!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get description {
    return _description;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const UserRating._internal({required this.id, user, ratedUser, required rating, description, createdAt, updatedAt}): _user = user, _ratedUser = ratedUser, _rating = rating, _description = description, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory UserRating({String? id, User? user, User? ratedUser, required int rating, String? description}) {
    return UserRating._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      user: user,
      ratedUser: ratedUser,
      rating: rating,
      description: description);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserRating &&
      id == other.id &&
      _user == other._user &&
      _ratedUser == other._ratedUser &&
      _rating == other._rating &&
      _description == other._description;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserRating {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user=" + (_user != null ? _user!.toString() : "null") + ", ");
    buffer.write("ratedUser=" + (_ratedUser != null ? _ratedUser!.toString() : "null") + ", ");
    buffer.write("rating=" + (_rating != null ? _rating!.toString() : "null") + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserRating copyWith({User? user, User? ratedUser, int? rating, String? description}) {
    return UserRating._internal(
      id: id,
      user: user ?? this.user,
      ratedUser: ratedUser ?? this.ratedUser,
      rating: rating ?? this.rating,
      description: description ?? this.description);
  }
  
  UserRating copyWithModelFieldValues({
    ModelFieldValue<User?>? user,
    ModelFieldValue<User?>? ratedUser,
    ModelFieldValue<int>? rating,
    ModelFieldValue<String?>? description
  }) {
    return UserRating._internal(
      id: id,
      user: user == null ? this.user : user.value,
      ratedUser: ratedUser == null ? this.ratedUser : ratedUser.value,
      rating: rating == null ? this.rating : rating.value,
      description: description == null ? this.description : description.value
    );
  }
  
  UserRating.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user = json['user'] != null
        ? json['user']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['user']))
        : null,
      _ratedUser = json['ratedUser'] != null
        ? json['ratedUser']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['ratedUser']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['ratedUser']))
        : null,
      _rating = (json['rating'] as num?)?.toInt(),
      _description = json['description'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user': _user?.toJson(), 'ratedUser': _ratedUser?.toJson(), 'rating': _rating, 'description': _description, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'user': _user,
    'ratedUser': _ratedUser,
    'rating': _rating,
    'description': _description,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserRatingModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserRatingModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USER = amplify_core.QueryField(
    fieldName: "user",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final RATEDUSER = amplify_core.QueryField(
    fieldName: "ratedUser",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final RATING = amplify_core.QueryField(fieldName: "rating");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserRating";
    modelSchemaDefinition.pluralName = "UserRatings";
    
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
      key: UserRating.USER,
      isRequired: false,
      targetNames: ['userId'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: UserRating.RATEDUSER,
      isRequired: false,
      targetNames: ['ratedId'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserRating.RATING,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserRating.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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

class _UserRatingModelType extends amplify_core.ModelType<UserRating> {
  const _UserRatingModelType();
  
  @override
  UserRating fromJson(Map<String, dynamic> jsonData) {
    return UserRating.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UserRating';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserRating] in your schema.
 */
class UserRatingModelIdentifier implements amplify_core.ModelIdentifier<UserRating> {
  final String id;

  /** Create an instance of UserRatingModelIdentifier using [id] the primary key. */
  const UserRatingModelIdentifier({
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
  String toString() => 'UserRatingModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserRatingModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}