import 'package:flutter/material.dart';

import '../services/pizzas_services.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = false;
  bool _hasError = false;
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
      await PizzaServices.getOrders(userId: '1');
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order Screen',
              style: TextStyle(fontSize: 20, color: Colors.white)),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (_isLoading) const CircularProgressIndicator(),
              if (_hasError) const Text('Something went wrong'),
              if (!_isLoading && !_hasError)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: PizzaServices.orders.length,
                  itemBuilder: (context, index) {
                    var order = PizzaServices.orders[index];
                    var pizzaId = order.pizzaId;
                    var pizza = PizzaServices.pizzas
                        .firstWhere((element) => element.id == pizzaId);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        surfaceTintColor: Colors.yellow,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                pizza.image!,
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pizza.name!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Description: ${pizza.description}',
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      'Place Address: \$${order.address}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Phone number: ${order.phoneNumber}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Status: ${order.status}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Total: ${pizza.price} USD',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ));
  }
}
