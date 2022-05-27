import 'package:flutter/material.dart';

class TreeViewThrPage extends StatefulWidget {
  const TreeViewThrPage({Key? key}) : super(key: key);

  @override
  State<TreeViewThrPage> createState() => _TreeViewThrPageState();
}

class _TreeViewThrPageState extends State<TreeViewThrPage> {
  bool showTree = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showTree = !showTree;
        setState(() {});
      },
      child: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff797979),
                  width: 0,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 500,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: const [
                                  Text(
                                    '标的进场',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    'CU2112-SH',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text(
                                    '失败 / 已占 / 已用 / 可用期货数量',
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xff797979)),
                                  ),
                                  Text(
                                    '40 / 30 / 75 吨',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.0,
                          width: 500,
                          child: Container(
                            color: const Color(0x80797979),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: const [
                                  Text(
                                    '常用追单',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    'CU2201-SH',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text(
                                    '10 / 100 / 50 / 290 吨',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                '已占 / 已用 / 可用期货数量',
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xff797979)),
                              ),
                              Text(
                                '231 / 155 / 622 吨',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                '当前 / 预期套保比例',
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xff797979)),
                              ),
                              Text(
                                '77.7% / 77.5% ',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            showTree = !showTree;
                            setState(() {});
                          },
                          child: showTree
                              ? const Icon(Icons.keyboard_arrow_down)
                              : const Icon(Icons.keyboard_arrow_right),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (showTree == true)
              Container(
                margin: const EdgeInsets.all(10),
                height: 190,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff797979),
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '点价价格/最新成交',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff797979),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              '74,670',
                                              style:
                                              TextStyle(color: Colors.blue),
                                            ),
                                            Text('/74,670'),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20,
                                              color: Colors.green,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          '成交数量/点价数量',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff797979),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.amber,
                                              child: const Text(
                                                '100',
                                              ),
                                            ),
                                            Container(
                                              color: Colors.amberAccent,
                                              child: const Text(
                                                '/100',
                                              ),
                                            ),
                                            const Text('吨'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Container(
                                color: const Color(0xff797979),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: const [
                                        Text(
                                          '标进',
                                          style: TextStyle(
                                              color: Colors.green, fontSize: 15),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'CU2112-SH',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.greenAccent,
                                              child: const Text(
                                                '78',
                                              ),
                                            ),
                                            Container(
                                              color: Colors.greenAccent,
                                              child: const Text(
                                                '/155',
                                              ),
                                            ),
                                            const Text('吨'),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Text(
                                              '成交均价',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xff797979),
                                              ),
                                            ),
                                            Text(
                                              '74,670',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Container(
                                color: const Color(0xff797979),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: const [
                                            Text(
                                              '常追换',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'CU2201-SH',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  color: const Color(0xffE1F5EF),
                                                  child: const Text(
                                                    '40',
                                                  ),
                                                ),
                                                Container(
                                                  color: const Color(0xffE1F5EF),
                                                  child: const Text(
                                                    '/155',
                                                  ),
                                                ),
                                                const Text('吨'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: const [
                                          Text(
                                            '追单失败数量',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff797979)),
                                          ),
                                          Text(
                                            '10吨',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.red),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Text(
                                            '成交均价',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xff797979),
                                            ),
                                          ),
                                          Text(
                                            '74,670',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff797979),
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '点价价格/最新成交',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff797979),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              '74,670',
                                              style:
                                              TextStyle(color: Colors.blue),
                                            ),
                                            Text('/74,670'),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20,
                                              color: Colors.green,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          '成交数量/点价数量',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff797979),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.amber,
                                              child: const Text(
                                                '100',
                                              ),
                                            ),
                                            Container(
                                              color: Colors.amberAccent,
                                              child: const Text(
                                                '/100',
                                              ),
                                            ),
                                            const Text('吨'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Container(
                                color: const Color(0xff797979),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: const [
                                        Text(
                                          '标进',
                                          style: TextStyle(
                                              color: Colors.green, fontSize: 15),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'CU2112-SH',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.greenAccent,
                                              child: const Text(
                                                '78',
                                              ),
                                            ),
                                            Container(
                                              color: Colors.greenAccent,
                                              child: const Text(
                                                '/155',
                                              ),
                                            ),
                                            const Text('吨'),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Text(
                                              '成交均价',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xff797979),
                                              ),
                                            ),
                                            Text(
                                              '74,670',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Container(
                                color: const Color(0xff797979),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: const [
                                            Text(
                                              '常追换',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'CU2201-SH',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  color: const Color(0xffE1F5EF),
                                                  child: const Text(
                                                    '40',
                                                  ),
                                                ),
                                                Container(
                                                  color: const Color(0xffE1F5EF),
                                                  child: const Text(
                                                    '/155',
                                                  ),
                                                ),
                                                const Text('吨'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff797979),
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '点价价格/最新成交',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff797979),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              '74,670',
                                              style:
                                              TextStyle(color: Colors.blue),
                                            ),
                                            Text('/74,670'),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20,
                                              color: Colors.green,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          '成交数量/点价数量',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff797979),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.amber,
                                              child: const Text(
                                                '100',
                                              ),
                                            ),
                                            Container(
                                              color: Colors.amberAccent,
                                              child: const Text(
                                                '/100',
                                              ),
                                            ),
                                            const Text('吨'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Container(
                                color: const Color(0xff797979),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: const [
                                        Text(
                                          '标进',
                                          style: TextStyle(
                                              color: Colors.green, fontSize: 15),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'CU2112-SH',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.greenAccent,
                                              child: const Text(
                                                '78',
                                              ),
                                            ),
                                            Container(
                                              color: Colors.greenAccent,
                                              child: const Text(
                                                '/155',
                                              ),
                                            ),
                                            const Text('吨'),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Text(
                                              '成交均价',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xff797979),
                                              ),
                                            ),
                                            Text(
                                              '74,670',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Container(
                                color: const Color(0xff797979),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: const [
                                            Text(
                                              '常追换',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'CU2201-SH',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  color: const Color(0xffE1F5EF),
                                                  child: const Text(
                                                    '40',
                                                  ),
                                                ),
                                                Container(
                                                  color: const Color(0xffE1F5EF),
                                                  child: const Text(
                                                    '/155',
                                                  ),
                                                ),
                                                const Text('吨'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
