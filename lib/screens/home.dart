import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crudapp/screens/employee.dart';
import 'package:firebase_crudapp/service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // EDIT
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController agecontroller = new TextEditingController();
  TextEditingController locationcontroller = new TextEditingController();

  Stream? EmployeeStream;

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
      stream: EmployeeStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Name: " + ds["Name"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    namecontroller.text = ds["Name"];
                                    emailcontroller.text = ds["Email"];
                                    agecontroller.text = ds["Age"];
                                    locationcontroller.text = ds["Location"];
                                    EditEmployeeDetail(ds["Id"]);
                                  },
                                  child: Icon(
                                    Icons.edit_rounded,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      print("Deleted");
                                      DatabaseMethods()
                                          .deleteEmployeeDetail(ds["Id"]);
                                    },
                                    child: Icon(Icons.delete_rounded,
                                        color: Colors.black)),
                              ],
                            ),
                            Text(
                              "Email: " + ds["Email"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            Text(
                              "Age: " + ds["Age"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            Text(
                              "Location: " + ds["Location"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // APPBAR
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Firebase",
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              " CRUD",
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            )
          ],
        ),
      ),

      // BODY
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(
          children: [Expanded(child: allEmployeeDetails())],
        ),
      ),

      // FLOATING ACTION BUTTON - +
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Employee()));
          },
          child: Icon(Icons.add)),
    );
  }

// EDIT
  Future EditEmployeeDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel_rounded)),
                        SizedBox(
                          width: 60.0,
                        ),
                        Text(
                          "Edit",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          " Detail",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        )
                      ],
                    ),

                    SizedBox(
                      height: 30.0,
                    ),
                    //NAME
                    Text(
                      "Name",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextField(
                        controller: namecontroller,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(border: InputBorder.none),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z ]*$'))
                        ],
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    //EMAIL
                    Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: emailcontroller,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(border: InputBorder.none),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[\w\.-]+@[a-zA-Z]+\.[a-zA-Z]{2,}$'))
                        ],
                        // keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    //AGE
                    Text(
                      "Age",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextField(
                        controller: agecontroller,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    //Location
                    Text(
                      "Location",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextField(
                        controller: locationcontroller,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () async {
                            // Validate age here
                            if (agecontroller.text.isNotEmpty &&
                                int.tryParse(agecontroller.text) != null &&
                                int.parse(agecontroller.text) >= 0 &&
                                int.parse(agecontroller.text) <= 100) {
                              Map<String, dynamic> updateInfo = {
                                "Name": namecontroller.text,
                                "Email": emailcontroller.text,
                                "Age": agecontroller.text,
                                "Id": id,
                                "Location": locationcontroller.text,
                              };
                              await DatabaseMethods()
                                  .updateEmployeeDetail(id, updateInfo)
                                  .then((value) => {Navigator.pop(context)});
                            } else {
                              // Show an error message if the age is out of range
                              Fluttertoast.showToast(
                                  msg: "Please enter an age between 0 and 100.",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Text(
                            "Update",
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ));
}
