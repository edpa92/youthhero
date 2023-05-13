import 'package:flutter/material.dart';
import 'package:youthhero/recruitersignup.dart';
import 'package:youthhero/signup.dart';

class UserChoose extends StatelessWidget {
  const UserChoose({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('WHICH ARE YOU?'),
        centerTitle: true,
      ),


      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        icon: Image.asset('images/seeker.jpg'),
                        tooltip: 'Seeker',
                        iconSize: 150,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegistrationForm()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        icon: Image.asset('images/employer.png'),
                        tooltip: 'Recruiter',
                        highlightColor: Colors.blue,
                        iconSize: 160,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RecruiterRegForm()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
        ),
      ),
    );
  }
}
