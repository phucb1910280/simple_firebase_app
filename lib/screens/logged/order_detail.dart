// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetail extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final String docId;

  const OrderDetail({
    Key? key,
    required this.documentSnapshot,
    required this.docId,
  }) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  String ttdh = '';
  late bool ttdhThayDoi;

  @override
  void initState() {
    super.initState();
    ttdh = widget.documentSnapshot['trangThaiDonHang'];
    widget.documentSnapshot['trangThaiDonHang'] == 'Đã tiếp nhận'
        ? ttdhThayDoi = false
        : ttdhThayDoi = true;
  }

  Widget customeText(String text,
      {double? size, bool? isBold, bool? isCyanColor}) {
    return Text(
      text,
      style: TextStyle(
        // ignore: prefer_if_null_operators
        fontSize: size == null ? 23 : size,
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        color: isCyanColor == true ? Colors.cyan[800] : Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết đơn hàng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Flex(direction: Axis.horizontal, children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      customeText('Mã đơn hàng:', isBold: false),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      customeText(widget.documentSnapshot['id'], isBold: true),
                    ],
                  ),
                  SizedBox(
                    width: 300,
                    height: 30,
                    child: Divider(color: Colors.black.withOpacity(.2)),
                  ),
                  Row(
                    children: [
                      customeText('Trạng thái:', isBold: false),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      customeText(ttdh, isBold: false, isCyanColor: true),
                    ],
                  ),
                  SizedBox(
                    width: 300,
                    height: 30,
                    child: Divider(color: Colors.black.withOpacity(.2)),
                  ),
                  Row(
                    children: [
                      customeText('Ngày đặt:', isBold: false),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      customeText(widget.documentSnapshot['ngayDat'],
                          isBold: false),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      customeText('Ngày giao dự kiến:', isBold: false),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      customeText(widget.documentSnapshot['ngayGiaoDuKien'],
                          isBold: false),
                    ],
                  ),
                  SizedBox(
                    width: 300,
                    height: 30,
                    child: Divider(color: Colors.black.withOpacity(.2)),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customeText('Người nhận:  ', isBold: false),
                      Flexible(
                        child: customeText(
                            '${widget.documentSnapshot['fullName']}\n${widget.documentSnapshot['phoneNumber']}\n${widget.documentSnapshot['address']}',
                            isBold: true),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 300,
                    height: 30,
                    child: Divider(color: Colors.black.withOpacity(.2)),
                  ),
                  Row(
                    children: [
                      customeText('Chi tiết đơn hàng',
                          size: 30, isCyanColor: true),
                      // Text(documentSnapshot['ngayGiaoDuKien']),
                    ],
                  ),
                  BookOrdered(
                      documentSnapshot: widget.documentSnapshot,
                      docId: widget.docId),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  SizedBox(
                    width: 300,
                    height: 30,
                    child: Divider(color: Colors.black.withOpacity(.2)),
                  ),
                  Row(
                    children: [
                      customeText('Phí vận chuyển:', isBold: false, size: 20),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      const Text(
                        '0₫',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      customeText('Tổng cộng:', isBold: false, size: 25),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      customeText(
                          NumberFormat.simpleCurrency(
                                  locale: 'vi-VN', decimalDigits: 0)
                              .format(widget.documentSnapshot['tongHoaDon']),
                          isBold: true,
                          isCyanColor: true,
                          size: 25),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      // backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      widget.documentSnapshot['trangThaiDonHang'] ==
                              'Đã tiếp nhận'
                          ? await FirebaseFirestore.instance
                              .collection('Orders')
                              .doc(widget.documentSnapshot.id)
                              .update({
                              'trangThaiDonHang': 'Đã hủy',
                            }).then((value) => {
                                    setState(() {
                                      ttdh = 'Đã hủy';
                                      ttdhThayDoi = true;
                                    })
                                  })
                          : null;
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: ttdhThayDoi ? Colors.grey : Colors.cyan[800]!,
                          width: 2,
                          style: BorderStyle.solid,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          Text(
                            'Hủy đơn',
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  ttdhThayDoi ? Colors.grey : Colors.cyan[800]!,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class BookOrdered extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  final String docId;

  const BookOrdered({
    Key? key,
    required this.documentSnapshot,
    required this.docId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .doc(docId)
            .collection('orderItems')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  snapshot.data!.docs.isEmpty ? 0 : snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                String docId = snapshot.data!.docs[index].id;
                return CustomeListTile(
                  docID: docId,
                  documentSnapshot: documentSnapshot,
                );
              },
            );
          } else {
            return const Center(child: Text('Đang tải'));
          }
        },
      ),
    );
  }
}

class CustomeListTile extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final String docID;
  const CustomeListTile({
    Key? key,
    required this.documentSnapshot,
    required this.docID,
  }) : super(key: key);

  int totalPrice() {
    int t = documentSnapshot['soLuong'] * documentSnapshot['giaBan'];
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        height: 150,
        child: Row(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.network(
                      documentSnapshot['biaSach'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            documentSnapshot['tenSach'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'x${documentSnapshot['soLuong']}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        NumberFormat.simpleCurrency(
                                locale: 'vi-VN', decimalDigits: 0)
                            .format(totalPrice()),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.cyan[800],
                          fontWeight: FontWeight.bold,
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
    );
  }
}
