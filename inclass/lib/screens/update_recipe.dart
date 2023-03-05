import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/recipe.dart';
import '../repositories/recipe_repositories.dart';

class UpdateRecipe extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> recipeData;

  const UpdateRecipe(this.documentId, this.recipeData, {super.key});

  @override
  State<UpdateRecipe> createState() => _UpdateRecipeState();
}

class _UpdateRecipeState extends State<UpdateRecipe> {
  final formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late List<String> _ingredients;

  void initState() {
    super.initState();
    _title = widget.recipeData['Title'];
    _description = widget.recipeData['Description'];
    _ingredients = widget.recipeData['Ingredients'].cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Recipe'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
                initialValue: _title,
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
                initialValue: _description,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              SizedBox(height: 8.0),
              Container(
                height: 200.0, // set a fixed height for the ListView
                child: ListView.builder(
                  itemCount: _ingredients.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == _ingredients.length) {
                      return GestureDetector(
                        onTap: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String? ingredient;
                              return AlertDialog(
                                title: Text('Add Ingredient'),
                                content: TextField(
                                  autofocus: true,
                                  onChanged: (value) {
                                    ingredient = value;
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context, null);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Add'),
                                    onPressed: () {
                                      Navigator.pop(context, ingredient);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          if (result != null) {
                            setState(() {
                              _ingredients.add(result);
                            });
                          }
                        },
                        child: Text(
                          'Add Ingredient',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      );
                    } else {
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          setState(() {
                            _ingredients.removeAt(index);
                          });
                        },
                        child: ListTile(
                          title: Text(_ingredients[index]),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      Recipe recipe = Recipe(
                        _title,
                        _description,
                        _ingredients,
                      );
                      ReceipeRepository receipeRepository = ReceipeRepository();
                      receipeRepository.updateRecipe(widget.documentId, recipe);

                      //show success message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Success'),
                            content: Text('Recipe update successfully.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      //show error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please enter a valid details.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Edit Recipe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
