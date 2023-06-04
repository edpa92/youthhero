import 'package:flutter/material.dart';
import 'package:youthhero/job_offer_add.dart';
import 'package:youthhero/company_profile.dart';
import 'package:youthhero/login.dart';
import 'package:youthhero/newsfeed.dart';
import 'package:youthhero/seeker_profile.dart';
import 'package:youthhero/utils/uti_class.dart';
import 'package:youthhero/webinarfeed.dart';

//void main() => runApp(const MyHomePage());

class MyhomePage extends StatefulWidget {
  const MyhomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

bool reload = false;

class _MyHomePageState extends State<MyhomePage> {
  List<Widget> mydrower(BuildContext context) {
    final String? disName =
        UtilClass.prefs?.getString(UtilClass.displayNameKey);
    final String? disMail = UtilClass.prefs?.getString(UtilClass.unameKey);

    final List<Widget> menuItems = [
      UserAccountsDrawerHeader(
        accountName: Text(disName ?? "",
            style: const TextStyle(
                color: Color.fromARGB(255, 240, 83, 83),
                fontWeight: FontWeight.bold,
                fontSize: 25,
                backgroundColor:
                    Color.fromRGBO(67, 67, 67, 1) // Change the text color here
                )),
        accountEmail: Text(disMail ?? "",
            style: const TextStyle(
                color: Color.fromARGB(255, 132, 233, 107),
                fontWeight: FontWeight.bold,
                fontSize: 15,
                backgroundColor: Color.fromARGB(255, 67, 67,
                    67) // Change the text color here // Change the text color here
                )),
        currentAccountPicture: CircleAvatar(
          backgroundImage: (UtilClass.prefs!
                  .getString(UtilClass.profilePicKey)
                  .toString()
                  .isNotEmpty
              ? UtilClass.getProfilePic()
              : const AssetImage('assets/images/rocket.png')),
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cover.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      ListTile(
        title: const Text(
          'Home',
          style: TextStyle(
              color: Color.fromARGB(255, 251, 243, 242),
              fontWeight: FontWeight.bold // Change the text color here
              ),
        ),
        leading: const Icon(Icons.home),
        onTap: () {},
      ),
      ListTile(
        title: const Text('Free Webinars ',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 238, 238),
                fontWeight: FontWeight.bold,
                fontSize: 12 // Change the text color here
                )),
        leading: const Icon(Icons.video_call),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WebinarViewPage(
                url: 'https://www.youtube.com/results?search_query=webinar',
              ),
            ),
          );
        },
      ),
      ListTile(
        title: const Text('News Feeds',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 238, 238),
                fontWeight: FontWeight.bold,
                fontSize: 12 // Change the text color here
                )),
        leading: const Icon(Icons.newspaper),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewsViewPage(
                url: 'https://mindanews.com',
              ),
            ),
          );
        },
      ),
      ListTile(
        title: const Text('Profile',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 238, 238),
                fontWeight: FontWeight.bold,
                fontSize: 12 // Change the text color here
                )),
        leading: const Icon(Icons.person),
        onTap: () {
          if ((UtilClass.prefs?.getBool(UtilClass.isSeekerKey) ?? false)) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SeekerProfilePage()),
            );
          }
        },
      ),
      Expanded(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromARGB(
                            255, 0, 0, 0), // Change the line color here
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: const Text('Logout',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 238, 238),
                            fontWeight: FontWeight.bold,
                            fontSize: 12 // Change the text color here
                            )),
                    leading: const Icon(Icons.logout),
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('LOGGING OUT'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (UtilClass.prefs != null) {
                                UtilClass.prefs!.clear();

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false,
                                );
                              }
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    ),
                  )))),
    ];

    return menuItems;
  }

  List<Widget> mydrowerCompany(BuildContext context) {
    final String? disName =
        UtilClass.prefs?.getString(UtilClass.displayNameKey);
    final String? compDesc = UtilClass.prefs?.getString(UtilClass.compDescKey);

    final List<Widget> menuItems = [
      UserAccountsDrawerHeader(
        accountName: Text(disName ?? "",
            style: const TextStyle(
                color: Color.fromARGB(255, 240, 83, 83),
                fontWeight: FontWeight.bold,
                fontSize: 25,
                backgroundColor:
                    Color.fromRGBO(67, 67, 67, 1) // Change the text color here
                )),
        accountEmail: Text(compDesc ?? "",
            style: const TextStyle(
                color: Color.fromARGB(255, 132, 233, 107),
                fontWeight: FontWeight.bold,
                fontSize: 15,
                backgroundColor: Color.fromARGB(255, 67, 67,
                    67) // Change the text color here // Change the text color here
                )),
        currentAccountPicture: CircleAvatar(
          backgroundImage: (UtilClass.prefs!
                  .getString(UtilClass.companyLogoKey)
                  .toString()
                  .isNotEmpty
              ? UtilClass.getCompanyLogo()
              : const AssetImage('assets/images/rocket.png')),
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cover.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      ListTile(
        title: const Text(
          'Home',
          style: TextStyle(
              color: Color.fromARGB(255, 251, 243, 242),
              fontWeight: FontWeight.bold // Change the text color here
              ),
        ),
        leading: const Icon(Icons.home),
        onTap: () {},
      ),
      ListTile(
        title: const Text('Company Profile',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 238, 238),
                fontWeight: FontWeight.bold,
                fontSize: 12 // Change the text color here
                )),
        leading: const Icon(Icons.person),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CompanyProfilePage()),
          ).then((value) {
            // Update parent page with data from child
            setState(() {});
          });
          ;
        },
      ),
      Expanded(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromARGB(
                            255, 0, 0, 0), // Change the line color here
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: const Text('Logout',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 238, 238),
                            fontWeight: FontWeight.bold,
                            fontSize: 12 // Change the text color here
                            )),
                    leading: const Icon(Icons.logout),
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('LOGGING OUT'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (UtilClass.prefs != null) {
                                UtilClass.prefs!.clear();

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false,
                                );
                              }
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    ),
                  )))),
    ];

    return menuItems;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        drawer: Drawer(
            child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 67, 135, 204), // Change the color here
          ),
          child: ListView(
              children: UtilClass.prefs?.getBool(UtilClass.isSeekerKey) ?? false
                  ? mydrower(context)
                  : mydrowerCompany(context)),
        )),
        appBar: AppBar(title: const Text('Home')),
        body: const MyScaffoldBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const JobOfferAddPage()));
          },
          child: const Icon(Icons.add),
        ),
      ),
      color: Colors.blue,
    );
  }
}

class MyScaffoldBody extends StatelessWidget {
  const MyScaffoldBody({super.key});

  @override
  Widget build(BuildContext context) {
    return JobOffersPage(
      jobOffers: [
        JobOffer(
            jobTitle: 'Software Engineer',
            company: 'ABC Company',
            location: 'City, State',
            description:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            logo: "",
            hourrate: "50"),
        JobOffer(
            jobTitle: 'Data Analyst',
            company: 'XYZ Corporation',
            location: 'City, State',
            description:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            logo: "",
            hourrate: "50"),
        // Add more job offers
      ],
    );
  }
}

class JobOffersPage extends StatelessWidget {
  final List<JobOffer> jobOffers;

  JobOffersPage({required this.jobOffers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Offers'),
      ),
      body: ListView.builder(
        itemCount: jobOffers.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: (jobOffers[index].logo.isNotEmpty
                  ? UtilClass.base64ToImage(jobOffers[index].logo)
                  : const AssetImage('assets/images/rocket.png')),
            ),
            title: Text(jobOffers[index].jobTitle),
            subtitle: Text(jobOffers[index].company),
            onTap: () {
              // Handle the job offer selection
              // e.g., navigate to the job offer details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobOfferPage(
                    jobOffer: jobOffers[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class JobOfferPage extends StatelessWidget {
  final JobOffer jobOffer;

  JobOfferPage({required this.jobOffer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Offer'),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobOffer.jobTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              jobOffer.company,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Location: ${jobOffer.location}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              jobOffer.description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobOffer {
  final String jobTitle;
  final String company;
  final String location;
  final String description;
  final String logo;
  final String hourrate;

  JobOffer(
      {required this.jobTitle,
      required this.company,
      required this.location,
      required this.description,
      required this.logo,
      required this.hourrate});
}
