import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    users = await authProvider.fetchUsers();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.purple,
      body: Stack(
        children: [
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
                        "Users (⌐■֊■)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.147,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.8,
              widthFactor: 1.0,
              child: Card(
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                color: Colors.white,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : AnimatedList(
                  initialItemCount: users.length,
                  itemBuilder: (context, index, animation) {
                    return _buildUserCard(users[index], animation);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(dynamic user, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 3, bottom: 3),
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFFD4AF37),
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user['avatar']),
                radius: 30,
              ),
            ),
            title: Text(
              '${user['first_name']} ${user['last_name']}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(
              user['email'] ?? '',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
