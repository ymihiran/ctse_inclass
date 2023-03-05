import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:inclass/repositories/recipe_repositories.dart';
import 'package:inclass/screens/recipe_details.dart';

import '../models/recipe.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late List<String> _ingredients;

  void initState() {
    super.initState();
    _title = '';
    _description = '';
    _ingredients = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
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
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
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
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    //add receipe
                    ReceipeRepository receipeRepository = ReceipeRepository();
                    Recipe receipe = Recipe(_title, _description, _ingredients);
                    receipeRepository.addReceipe(receipe);

                    //navigate to home
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RecipeDetails()),
                    );
                  }
                },
                child: Text('Add Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
