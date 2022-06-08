import 'package:cloud_firestore/cloud_firestore.dart'

class DatabaseService {
//used to intereact with database

final String uid;
//takes the sign up uid and assigns to uid
DatabaseService({this.uid});

//collection reference

//Test database for users consisting of (currently) no. of transactions
final CollectionReference userCollection = Firestore.instance.collection('transactions');

Future updateUserData(String transactions, String username) async {
  return await userCollection.document(uid).setData({
    'transactions' : transactions,
    'username' : username,
    });
  }

}