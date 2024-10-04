import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(String email, String password) async {
    FocusScope.of(context).unfocus();


    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await authProvider.login(email, password);

    if (authProvider.message.contains("Successful")) {
      Navigator.pushReplacementNamed(context, '/user_list');
    } else {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                color: Colors.deepPurple,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login:) ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Start using our app after you’re\nsuccessfully logged in :)",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),


            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.7,
                widthFactor: 1.0,
                child: Card(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.03,
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildTextField('Email', emailController),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                          _buildTextField('Password', passwordController, obscureText: true),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                          authProvider.isLoading // Use AuthProvider loading state
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              minimumSize: Size(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height * 0.06,
                              ),
                            ),
                            onPressed: () {
                              login(emailController.text, passwordController.text);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          if (authProvider.message.isNotEmpty)
                            authProvider.message.contains('not found')
                                ? RichText(
                              text: TextSpan(
                                text: 'User not found. ',
                                style: TextStyle(color: Colors.red),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Signup',
                                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(context, '/signup');
                                      },
                                  ),
                                ],
                              ),
                            )
                                : Text(
                              authProvider.message,
                              style: TextStyle(
                                color: authProvider.message.contains("Successful") ? Colors.green : Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
