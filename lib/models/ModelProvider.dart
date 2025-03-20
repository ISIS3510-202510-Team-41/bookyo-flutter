import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'models.dart'; // Importa todos los modelos desde un solo archivo

class ModelProvider implements ModelProviderInterface {
  @override
  String version = "1.3";
  
  @override
  List<ModelSchema> modelSchemas = [
    Wishlist.schema,
    BookWishlist.schema,
    Book.schema,
    BookCategory.schema,
    Author.schema,
    User.schema,
    UserRating.schema,
    Notification.schema,
    BookRating.schema,
    Listing.schema,
    Cart.schema,
    CategoryName.schema,
  ];
  
  @override
  List<ModelSchema> customTypeSchemas = [];
  
  static final ModelProvider _instance = ModelProvider();
  static ModelProvider get instance => _instance;
  
  @override
  ModelType<Model> getModelTypeByModelName(String modelName) {
    // TODO: implement getModelTypeByModelName
    throw UnimplementedError();
  }
}
// }