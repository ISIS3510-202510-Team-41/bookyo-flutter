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

import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'Author.dart';
import 'Book.dart';
import 'BookCategory.dart';
import 'BookLibrary.dart';
import 'BookRating.dart';
import 'BookWishlist.dart';
import 'Cart.dart';
import 'Category.dart';
import 'Listing.dart';
import 'Notification.dart';
import 'User.dart';
import 'UserLibrary.dart';
import 'UserRating.dart';
import 'Wishlist.dart';

export 'Author.dart';
export 'Book.dart';
export 'BookCategory.dart';
export 'BookLibrary.dart';
export 'BookRating.dart';
export 'BookWishlist.dart';
export 'Cart.dart';
export 'CartState.dart';
export 'Category.dart';
export 'Listing.dart';
export 'ListingStatus.dart';
export 'Notification.dart';
export 'NotificationType.dart';
export 'User.dart';
export 'UserLibrary.dart';
export 'UserRating.dart';
export 'Wishlist.dart';

class ModelProvider implements amplify_core.ModelProviderInterface {
  @override
  String version = "d19d24e0750c6c1b33d25086e725ed73";
  @override
  List<amplify_core.ModelSchema> modelSchemas = [Author.schema, Book.schema, BookCategory.schema, BookLibrary.schema, BookRating.schema, BookWishlist.schema, Cart.schema, Category.schema, Listing.schema, Notification.schema, User.schema, UserLibrary.schema, UserRating.schema, Wishlist.schema];
  @override
  List<amplify_core.ModelSchema> customTypeSchemas = [];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  amplify_core.ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "Author":
        return Author.classType;
      case "Book":
        return Book.classType;
      case "BookCategory":
        return BookCategory.classType;
      case "BookLibrary":
        return BookLibrary.classType;
      case "BookRating":
        return BookRating.classType;
      case "BookWishlist":
        return BookWishlist.classType;
      case "Cart":
        return Cart.classType;
      case "Category":
        return Category.classType;
      case "Listing":
        return Listing.classType;
      case "Notification":
        return Notification.classType;
      case "User":
        return User.classType;
      case "UserLibrary":
        return UserLibrary.classType;
      case "UserRating":
        return UserRating.classType;
      case "Wishlist":
        return Wishlist.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }
}


class ModelFieldValue<T> {
  const ModelFieldValue.value(this.value);

  final T value;
}
