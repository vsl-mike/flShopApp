import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';

class OrdersView extends StatefulWidget {
  final int index;
  OrdersView(this.index);
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  bool isDropDown = false;
  @override
  Widget build(BuildContext context) {
    Orders orders = Provider.of<Orders>(context, listen: false);
    return Card(
      elevation: 7,
      child: Column(
        children: <Widget>[
          Container(
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        DateFormat.Hm()
                            .add_yMMMMd()
                            .format(orders.items[widget.index].dateTime),
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        '\$' +
                            orders.items[widget.index].totalPrice
                                .toStringAsFixed(2),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      isDropDown = !isDropDown;
                    });
                  }),
            ),
          ), Column(
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black12,
                      ),
                      height: !isDropDown ? 0 : orders.items[widget.index].orderList.length <= 3
                          ? orders.items[widget.index].orderList.length
                                  .toDouble() *
                              75
                          : 250,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: orders.items[widget.index].orderList.length,
                        itemBuilder: (ctx, listIndex) {
                          return ListTile(
                            leading: Text(
                              '# ' + (listIndex + 1).toString(),
                            ),
                            title: Text(
                              orders.items[widget.index].orderList[listIndex]
                                  .title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '\$ ' +
                                  orders.items[widget.index]
                                      .orderList[listIndex].price
                                      .toString() +
                                  '   x' +
                                  orders.items[widget.index]
                                      .orderList[listIndex].quantity
                                      .toString(),
                            ),
                            trailing: Text(
                              '= ' +
                                  (orders.items[widget.index]
                                              .orderList[listIndex].quantity *
                                          orders.items[widget.index]
                                              .orderList[listIndex].price)
                                      .toString() +
                                  '\$',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
