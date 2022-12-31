// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import '../services/pizzas_services.dart';
import 'order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool _isError = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }

  initAsync() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await PizzaServices.getPizzas();
      await PizzaServices.getOrders(userId: '1');
    } catch (e) {
      log(e.toString());
      setState(() {
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Shop', style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Badge(
              badgeContent: Text(
                PizzaServices.orders.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                  onPressed: () {
                    if (PizzaServices.orders.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrderScreen()));
                    }
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  )),
            ),
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow, Colors.orange],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (_isError)
                const Center(
                  child: Text('Something went wrong'),
                ),
              if (!_isLoading && !_isError)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Latest Pizzas',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset("assets/header_image.jpg"),
                      GridView.builder(
                          itemCount: PizzaServices.pizzas.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            content: Column(
                                          children: [
                                            Expanded(
                                              child: InteractiveViewer(
                                                child: Image.network(
                                                    PizzaServices
                                                        .pizzas[index].image!),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              PizzaServices.pizzas[index].name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              PizzaServices
                                                  .pizzas[index].description!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ],
                                        ));
                                      });
                                },
                                child: Card(
                                  surfaceTintColor: Colors.yellow,
                                  elevation: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                          Colors.yellow,
                                          Colors.orange
                                        ],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight)),
                                    child: Column(
                                      children: [
                                        Image.network(
                                          PizzaServices.pizzas[index].image!,
                                          height: 100,
                                          width: 100,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          PizzaServices.pizzas[index].name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                PizzaServices
                                                    .pizzas[index].description!,
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        color: Colors.grey[800],
                                                        fontSize: 12),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // currency usd
                                            Flexible(
                                                child: ListTile(
                                              leading: const Icon(
                                                Icons.attach_money,
                                              ),
                                              horizontalTitleGap: 0,
                                              title: Text(
                                                PizzaServices
                                                    .pizzas[index].price
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                            )),
                                            const Spacer(),
                                            Flexible(
                                                child: ListTile(
                                              leading: const Icon(
                                                  Icons.shopping_cart),
                                              horizontalTitleGap: 0,
                                              onTap: () async {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                        (_) async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              void Function(
                                                                      void
                                                                          Function())
                                                                  setState) {
                                                            final formKey =
                                                                GlobalKey<
                                                                    FormState>();
                                                            final addressController =
                                                                TextEditingController();
                                                            final phoneController =
                                                                TextEditingController();

                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Add to Cart'),
                                                              content: Form(
                                                                key: formKey,
                                                                child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Flexible(
                                                                              child: TextFormField(
                                                                                controller: addressController,
                                                                                decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.black))),
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return 'Please enter address';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Flexible(
                                                                                child: TextFormField(
                                                                              controller: phoneController,
                                                                              decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.black))),
                                                                              validator: (value) {
                                                                                if (value!.isEmpty || value.length != 10) {
                                                                                  return 'Please enter phone number';
                                                                                }
                                                                                return null;
                                                                              },
                                                                            ))
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ]),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        'Cancel')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      if (formKey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        try {
                                                                          setState(
                                                                              () {
                                                                            _isLoading =
                                                                                true;
                                                                          });

                                                                          await PizzaServices
                                                                              .placeOrder(order: {
                                                                            'address':
                                                                                addressController.text.toString(),
                                                                            'phone_number':
                                                                                phoneController.text.toString(),
                                                                            'pizza_id':
                                                                                PizzaServices.pizzas[index].id.toString(),
                                                                            'user_id':
                                                                                "1" //by default
                                                                          });
                                                                          await PizzaServices.getOrders(
                                                                              userId: "1");

                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(const SnackBar(content: Text("Order Placed")));
                                                                          Navigator.pop(
                                                                              context,
                                                                              true);
                                                                        } catch (e) {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(const SnackBar(content: Text("Failed to add to cart")));
                                                                          log(e
                                                                              .toString());
                                                                        } finally {
                                                                          setState(
                                                                              () {
                                                                            _isLoading =
                                                                                false;
                                                                          });
                                                                        }
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        'Add'))
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      });
                                                  setState(() {});
                                                });
                                              },
                                              title: const Text("Add to Cart",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 1 : 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 320,
                          ))
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
