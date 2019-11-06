import 'package:complete_login_setup/src/authentication/authentication_service.dart';
import 'package:complete_login_setup/src/authentication/models/user_model.dart';
import 'package:complete_login_setup/src/pages/home_page.dart';
import 'package:complete_login_setup/src/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null && user.isEmailVerified == true;
    final auth = Provider.of<AuthBase>(context, listen: false);

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: (!loggedIn)
          ? LoginPage.create(context)
          : StreamBuilder<UserModel>(
              stream: auth.onAuthStateChanged,
              builder: (context, snapshot) {
                print(snapshot.data);
                if (snapshot.connectionState == ConnectionState.active) {
                  return Provider<UserModel>.value(
                    // Pass the snapshot.data which is an instance of User class
                    value: snapshot.data,
                    child: HomePage(),
                  );
                } else {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit the App?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: Text('Yes'),
              ),
            ],
          ),
        )
        // This checks for null, null is returned if we click outside the box
        ??
        false;
  }
}
