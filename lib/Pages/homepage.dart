import 'package:finance_apk/Pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Components/recent_records_card.dart';
import '../backend/database_helper.dart';
import '../backend/accounts.dart';
import 'add_account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    // Load initial data
    Future.microtask(() =>
        Provider.of<FinanceState>(context, listen: false).loadData());
  }

  @override
  Widget build(BuildContext context) {
    double topIconSize = 27;
    double homePagePadding = 8;
    double slidingAccountsPadding = homePagePadding + 10;
    double slidingAccountsSpacing = 7;

    Widget slidingAccountsCard(Account account) {
      return Card(
        elevation: 3,
        child: Stack(
          children: [
            Container(
              height: 90,
              width: ((MediaQuery.of(context).size.width - 2 * slidingAccountsPadding) / 2) - 18,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    account.color.withOpacity(0.7),
                    account.color,
                    account.color.withOpacity(1.0),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        account.accountType.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        account.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        account.balance.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        account.currency,
                        style: const TextStyle(
                          color: Color.fromARGB(150, 255, 255, 255),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget slidingAccountsCon(cards) {
      return Row(
        children: [
          Column(
            children: [
              cards[0],
              SizedBox(height: slidingAccountsSpacing),
              cards[2],
            ],
          ),
          SizedBox(width: slidingAccountsSpacing),
          Column(
            children: [
              cards[1],
              SizedBox(height: slidingAccountsSpacing),
              cards[3],
            ],
          ),
        ],
      );
    }

    buildSlidingAccountsCon(accounts) {
      List<Widget> containers = [];
      var blankCard = Card(
        elevation: 3,
        child: SizedBox(
          height: 90,
          width: ((MediaQuery.of(context).size.width - 2 * slidingAccountsPadding) / 2) - 18,
        ),
      );
      Widget addAccountCard = Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5), // Border color
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddAccountPage()),
            );
            setState(() {
              // Refresh the state
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final state = Provider.of<FinanceState>(context, listen: false);
                state.loadData();
              });
            });
          },
          child: SizedBox(
            height: 90,
            width: ((MediaQuery.of(context).size.width - 2 * slidingAccountsPadding) / 2) - 18,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2), // Translucent background
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Add Account",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      int j = 0;
      bool ac = true;

      for (var p = 0; p <= accounts.length / 4; p++) {
        List<Widget> cards = [];
        for (var i = 0; i < 4; i++) {
          if (j < accounts.length) {
            cards.add(slidingAccountsCard(accounts[j]));
            j++;
          } else {if (ac){
            ac = false;
            cards.add(addAccountCard);
          }else{
            cards.add(blankCard);
          }}
        }
        containers.add(slidingAccountsCon(cards));
      }
      return containers;
    }

    return Consumer<FinanceState>(
      builder: (context, financeState, child) {
        List<Account> accounts = financeState.accounts;
        List<Widget> slidingContainers = buildSlidingAccountsCon(accounts);

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 45),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications),
                        iconSize: topIconSize,
                      ),
                      IconButton(
                        onPressed: onSettingsPressed,
                        icon: const Icon(Icons.settings),
                        iconSize: topIconSize,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu_sharp),
                        iconSize: topIconSize,
                      ),
                    ],
                  ),
                ],
              ), // Top Icons
              const SizedBox(height: 10),
              Stack(
                children: [
                  Row(
                    children: [
                      SizedBox(width: homePagePadding + 15),
                      SizedBox(
                        width: 280,
                        height: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 25),
                            const Text(
                              "TOTAL BALANCE",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const Row(
                              children: [
                                Text(
                                  "₹",
                                  style: TextStyle(
                                    fontSize: 36,
                                  ),
                                ),
                                Text(
                                  "13,370.98",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 36,
                                  ),
                                ),
                              ],
                            ), // Total Balance
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                FilledButton.tonal(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    minimumSize: WidgetStateProperty.all(const Size(85, 35)),
                                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                                      const EdgeInsets.symmetric(horizontal: 5),
                                    ),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.monetization_on,
                                        size: 15,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        "₹36.44",
                                        style: TextStyle(
                                          fontSize: 11.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Row(
                                    children: [
                                      Text(
                                        "Cashback saved",
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 2),
                                        child: Text(
                                          " >",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ), // Cashback saved
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.translate(
                        offset: const Offset(85, 0),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Card(
                              color: Colors.blue,
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: SizedBox(
                                  width: 165, // Set the width of the card
                                  height: 110, // Set the height of the card
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // Ensures image follows the card's rounded corners
                                    child: Image.asset(
                                      'asset/images/cards/card2.JPEG', // Replace with your image URL
                                      fit: BoxFit.cover, // Ensures the image covers the entire card without distortion
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 3,
                              child: SizedBox(
                                width: 195, // Set the width of the card
                                height: 130, // Set the height of the card
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10), // Ensures image follows the card's rounded corners
                                  child: Image.asset(
                                    'asset/images/cards/card1.JPEG', // Replace with your image URL
                                    fit: BoxFit.cover, // Ensures the image covers the entire card without distortion
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ), // Total Balance
              const SizedBox(height: 25),
              SizedBox(
                height: 208, // Adjust height as needed
                child: PageView(
                  controller: _pageController,
                  children: slidingContainers,
                ),
              ), // Sliding Accounts
              const SizedBox(height: 10),
              SmoothPageIndicator(
                controller: _pageController,
                count: slidingContainers.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).primaryColor,
                  dotColor: Colors.grey,
                ),
              ), // Dot Indicator
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const RecentRecordsCard(),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 3,
                      child: SizedBox(
                        height: 220,
                        width: MediaQuery.of(context).size.width - (homePagePadding + 35),
                        child: const Center(child: Text("DEMO CARD 2")),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 3,
                      child: SizedBox(
                        height: 220,
                        width: MediaQuery.of(context).size.width - (homePagePadding + 35),
                        child: const Center(child: Text("DEMO CARD 3")),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 3,
                      child: SizedBox(
                        height: 220,
                        width: MediaQuery.of(context).size.width - (homePagePadding + 35),
                        child: const Center(child: Text("DEMO CARD 4")),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onSettingsPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }
}