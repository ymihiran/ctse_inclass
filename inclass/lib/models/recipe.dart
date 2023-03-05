class Recipe {
  String Title;
  String Description;
  List<String> Ingredients;

  Recipe(this.Title, this.Description, this.Ingredients);

  Map<String, dynamic> toMap() {
    return {
      'Title': Title,
      'Description': Description,
      'Ingredients': Ingredients
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> data) {
    return Recipe(data['Title'], data['Description'], data['Ingredients']);
  }
}
