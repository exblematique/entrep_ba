/**
 * This page contains interaction with the database for actions
 * ActionDB is a unique action
 * ActionsDB contains all actions available in the database
 */
import 'package:ba_locale/model/database/company.dart';
import 'package:ba_locale/controller/script.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActionDB{
  CompanyDB company;
  final String uid, name, description, qrcode, address;
  final Image image;
  final DateTime startDate, endDate;
  final int nbPoints;

  ActionDB({
    @required this.uid,
    @required this.address,
    @required this.name,
    @required this.description,
    @required this.nbPoints,
    this.image,
    this.startDate,
    this.endDate,
    this.qrcode,
  });

  Future<bool> delete() async => ActionsDB.deleteItem(this);

  void addCompany(CompanyDB companyDB) {
    company = companyDB;
  }
}

//Abstract class with all pieces of information on reduction
abstract class ActionsDB{
  //This variable equal true when all data are downloaded
  static bool ready = false;
  static bool err =  false;
  static List<ActionDB> availableList = new List<ActionDB>();

  //Check if data are downloaded
  //If not, try to download and return true if successful
  static Future<bool> waitToReady() async {
    if (!ready)
      await downloadData();
    return ready && !err;
  }

  static bool isReady(){
    return ready;
  }

  //Find element by UID
  static ActionDB getElementbyUID (String uid){
    for (ActionDB action in availableList){
      if (action.uid == uid)
        return action;
    }
    return null;
  }

  static Future<void> downloadData() async{
    //Reset all states
    ready = false;
    err = false;

    //Downloading data
    //If success, update reductions list
    await Firestore.instance
      .collection("actions")
      .getDocuments()
      .then((QuerySnapshot snapshot){
        availableList.clear();
        for (DocumentSnapshot action in snapshot.documents) {
          availableList.add(new ActionDB(
            uid: action.documentID,
            name: action.data['name'],
            description: action.data['description'],
            nbPoints: action.data['nbPoints'],
            startDate: action.data['startDate'],
            endDate: action.data['endDate'],
            qrcode: action.data['qrcode'],
            address: action.data['place'] == null ? "" : action.data['place'],
            image: strToImage(action.data['image']),
          ));
        }
        ready = true;
    })
    .catchError((_){err = true;});
  }

  static Future<bool> deleteItem(ActionDB action) async {
    bool error = false;
    await Firestore.instance
      .collection("actions")
      .document(action.uid)
      .delete()
//TODO remove reference
//    .then((_) async {
//        await Firestore.instance
//          .collection("companies")
//          .document(action.company.uid)
//          .updateData({})
//        availableList.remove(action);
//
//      })
      .catchError((_) => error = true);
    return !error;
  }
}
