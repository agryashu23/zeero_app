
import 'dart:async';

import 'package:flutter/material.dart';

class FormModel extends ChangeNotifier {
  List actions =[];
  List supply1 = [];
  List supply2 = [];
  List supplyAll = [];
  double s=0.0;
  List search = [];
  int i=0;
  List IDs = [];
  List revenue = [];
  List expenses = [];
  List userI=[];
  List leads=[];
  List leadSearch=[];
  List leadsUserI=[];
  List showLeads=[];
  List business=[];




  void cardDialog(title,status){
    actions.add({"title":title,"status":status});
    notifyListeners();
  }
  void addLeads(value){
    leads.add(value);
    notifyListeners();
  }
  void addID(value){
    IDs.add(value);
    notifyListeners();
  }
  void addUserID(value){
    userI.add(value);
    notifyListeners();
  }
  void leadsUserID(value){
    leadsUserI.add(value);
    notifyListeners();
  }

  void addRevenue(value){
    revenue.add(value);
    notifyListeners();
  }
  void addExpense(value){
    expenses.add(value);
    notifyListeners();
  }

  void addSupply1(choice,property,type,state,city,locality,located,date,amenities,society){
    supply1.add({"choice":choice,"property":property,"type":type,"state":state,"city":city
      ,"locality":locality,"located":located,"date":date,"amenities":amenities,"society":society});
    notifyListeners();
  }
  void addSupply2(images,layout,washroom,balcony,furnish,carpet,floor,rent,security){
    supply2.add({"images":images,"layout":layout,"washroom":washroom,"balcony":balcony,"furnish":furnish
      ,"carpet":carpet,"floor":floor,"rent":rent,"security":security});
    notifyListeners();
  }
  void addAllSupply(){
    supply1.clear();
    supply2.clear();
    notifyListeners();
  }
  void addSearch(location,layout,rent,furnish,area,floor){
    search.add({
      "location":location,
      "layout":layout,"rent":rent,"furnish":furnish,"area":area,"floor":floor});
    notifyListeners();
  }
  void addLeadSearch(location,layout,rent,furnish,area,floor){
    leadSearch.add({
      "location":location,
      "layout":layout,"rent":rent,"furnish":furnish,"area":area,"floor":floor});
    notifyListeners();
  }
void showLeadSearch(location,layout,rent,furnish,area,floor){
    showLeads.add({
      "location":location,
      "layout":layout,"rent":rent,"furnish":furnish,"area":area,"floor":floor});
    notifyListeners();
  }
  void addBusiness(reven,collect,officeRent,salary,share,electricity,officeExp){
    business.add({
      "reven":reven,
      "collect":collect,"officeRent":officeRent,"salary":salary,"share":share, "electricity":electricity,"officeExp":officeExp});
    notifyListeners();
  }


}
