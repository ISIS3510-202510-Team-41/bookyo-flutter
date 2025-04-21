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


/** This is an auto generated class representing the BookLibrary type in your schema. */
class BookLibrary extends amplify_core.Model {
  static const classType = const _BookLibraryModelType();
  final String id;
  final Book? _book;
  final UserLibrary? _userLibraryRef;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  BookLibraryModelIdentifier get modelIdentifier {
      return BookLibraryModelIdentifier(
        id: id
      );
  }
  
  Book? get book {
    return _book;
  }
  
  UserLibrary? get userLibraryRef {
    return _userLibraryRef;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const BookLibrary._internal({required this.id, book, userLibraryRef, createdAt, updatedAt}): _book = book, _userLibraryRef = userLibraryRef, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory BookLibrary({String? id, Book? book, UserLibrary? userLibraryRef}) {
    return BookLibrary._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      book: book,
      userLibraryRef: userLibraryRef);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookLibrary &&
      id == other.id &&
      _book == other._book &&
      _userLibraryRef == other._userLibraryRef;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("BookLibrary {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("book=" + (_book != null ? _book!.toString() : "null") + ", ");
    buffer.write("userLibraryRef=" + (_userLibraryRef != null ? _userLibraryRef!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  BookLibrary copyWith({Book? book, UserLibrary? userLibraryRef}) {
    return BookLibrary._internal(
      id: id,
      book: book ?? this.book,
      userLibraryRef: userLibraryRef ?? this.userLibraryRef);
  }
  
  BookLibrary copyWithModelFieldValues({
    ModelFieldValue<Book?>? book,
    ModelFieldValue<UserLibrary?>? userLibraryRef
  }) {
    return BookLibrary._internal(
      id: id,
      book: book == null ? this.book : book.value,
      userLibraryRef: userLibraryRef == null ? this.userLibraryRef : userLibraryRef.value
    );
  }
  
  BookLibrary.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _book = json['book'] != null
        ? json['book']['serializedData'] != null
          ? Book.fromJson(new Map<String, dynamic>.from(json['book']['serializedData']))
          : Book.fromJson(new Map<String, dynamic>.from(json['book']))
        : null,
      _userLibraryRef = json['userLibraryRef'] != null
        ? json['userLibraryRef']['serializedData'] != null
          ? UserLibrary.fromJson(new Map<String, dynamic>.from(json['userLibraryRef']['serializedData']))
          : UserLibrary.fromJson(new Map<String, dynamic>.from(json['userLibraryRef']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'book': _book?.toJson(), 'userLibraryRef': _userLibraryRef?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'book': _book,
    'userLibraryRef': _userLibraryRef,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<BookLibraryModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<BookLibraryModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final BOOK = amplify_core.QueryField(
    fieldName: "book",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Book'));
  static final USERLIBRARYREF = amplify_core.QueryField(
    fieldName: "userLibraryRef",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserLibrary'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "BookLibrary";
    modelSchemaDefinition.pluralName = "BookLibraries";
    
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: BookLibrary.BOOK,
      isRequired: false,
      targetNames: ['bookId'],
      ofModelName: 'Book'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: BookLibrary.USERLIBRARYREF,
      isRequired: false,
      targetNames: ['libraryId'],
      ofModelName: 'UserLibrary'
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

class _BookLibraryModelType extends amplify_core.ModelType<BookLibrary> {
  const _BookLibraryModelType();
  
  @override
  BookLibrary fromJson(Map<String, dynamic> jsonData) {
    return BookLibrary.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'BookLibrary';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [BookLibrary] in your schema.
 */
class BookLibraryModelIdentifier implements amplify_core.ModelIdentifier<BookLibrary> {
  final String id;

  /** Create an instance of BookLibraryModelIdentifier using [id] the primary key. */
  const BookLibraryModelIdentifier({
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
  String toString() => 'BookLibraryModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is BookLibraryModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}