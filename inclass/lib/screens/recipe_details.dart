import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:inclass/screens/update_recipe.dart';

import '../repositories/recipe_repositories.dart';

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({super.key});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipe Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('receipe').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Hmm..., Looks like something went wrong!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    data['Title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    data['Description'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  //display ingredients in a list

                  // add delete button
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      //delete student
                      ReceipeRepository receipeRepository = ReceipeRepository();
                      receipeRepository.deleteReceipe(
                        document.id,
                      );
                    },
                  ),
                  //add edit button
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      //navigate to edit screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateRecipe(
                            document.id,
                            data,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
        //add back button
      ),
      //add back button
    );
  }
}
