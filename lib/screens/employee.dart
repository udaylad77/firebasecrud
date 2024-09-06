import 'package:firebase_crudapp/service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController agecontroller = new TextEditingController();
  TextEditingController locationcontroller = new TextEditingController();

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
                "Employee",
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                " Form",
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )
            ],
          ),
        ),

        // BODY
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //NAME
                Text(
                  "Name",
                  style: TextStyle(
                      fontSize: 24.0,
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
                      FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]*$'))
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
                      fontSize: 24.0,
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
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(
                    //       RegExp(r'^[\w\.-]+@[a-zA-Z]+\.[a-zA-Z]{2,}$'))
                    // ],
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),

                //AGE
                Text(
                  "Age",
                  style: TextStyle(
                      fontSize: 24.0,
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
                      fontSize: 24.0,
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.location_pin),
                        onPressed: () {},
                      ),
                    ),
                    keyboardType: TextInputType.streetAddress,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        String Id = randomAlphaNumeric(10);
                        Map<String, dynamic> employeeInfoMap = {
                          "Name": namecontroller.text,
                          "Email": emailcontroller.text,
                          "Age": agecontroller.text,
                          "Id": Id,
                          "Location": locationcontroller.text,
                        };

                        if (int.tryParse(agecontroller.text) != null &&
                            int.parse(agecontroller.text) >= 0 &&
                            int.parse(agecontroller.text) <= 100) {
                          await DatabaseMethods()
                              .addEmployeeDetails(employeeInfoMap, Id)
                              .then((value) {
                            print("Done");
                            Fluttertoast.showToast(
                                msg: "Data saved successfully.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            Navigator.pop(context);
                          });
                        } else {
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ));
  }
}
