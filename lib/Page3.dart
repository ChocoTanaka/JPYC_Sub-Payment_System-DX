import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'reown.dart';
import 'Web3.dart';



class Page3 extends StatefulWidget {
  const Page3({super.key});


  @override
  State<Page3> createState() => _MPSsState_Check();
}

class _MPSsState_Check extends State<Page3> {
  bool isShow = false;
  final ScrollController _scrollController_R = ScrollController();

  Map<BigInt,Invoice> invoiceList = {};

  late String tag1_s = "",tag2_s = "",tag3_s = "",tag4_s ="";
  final TextEditingController tag1 = TextEditingController();
  final TextEditingController tag2 = TextEditingController();
  final TextEditingController tag3 = TextEditingController();
  final TextEditingController tag4 = TextEditingController();


  Widget Left_View() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("索引",
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Flexible(
                child: Row(
                  children: <Widget>[
                    Text(
                      "tag:",
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: tag1,
                          onChanged: (text)=> setState(() {
                            tag1_s =tag1.text;
                          }),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'),)
                          ]
                      ),
                    ),
                    Text(
                      "-",
                      style: const TextStyle(fontSize: 28),
                    ),
                    Expanded(
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: tag2,
                          onChanged: (text)=> setState(() {
                            tag2_s =tag2.text;
                          }),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'),)
                          ]
                      ),
                    ),
                    Text(
                      "-",
                      style: const TextStyle(fontSize: 28),
                    ),
                    Expanded(
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: tag3,
                          onChanged: (text)=> setState(() {
                            tag3_s =tag3.text;
                          }),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'),)
                          ]
                      ),
                    ),
                    Text(
                      "-",
                      style: const TextStyle(fontSize: 28),
                    ),
                    Expanded(
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: tag4,
                          onChanged: (text)=> setState(() {
                            tag4_s =tag4.text;
                          }),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'),)
                          ]
                      ),
                    ),
                  ],
                )
            )
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              backgroundColor:  Appkit().userAddress !="" && (tag1_s + tag2_s + tag3_s + tag4_s).length == 16 ? Colors.blue[200] : Colors.grey,
            ),
            onPressed:() async{
              if(Appkit().userAddress !="" && (tag1_s + tag2_s + tag3_s + tag4_s).length == 16){
                BigInt tag = BigInt.from(num.tryParse(tag1_s + tag2_s + tag3_s + tag4_s)!);
                final cleanAddr = Appkit().userAddress.trim().toLowerCase().replaceFirst('0x', '');
                Invoice? inv = await fetchInvoiceByKey(keyHex: buildInvoiceKeyHex(cleanAddr, tag));
                if(inv != null){
                  invoiceList[tag] = inv;
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("それは登録されていません。")),
                  );
                }
                setState(() {

                });
              }

            },
            child: Text(
              "追加",
              style: const TextStyle(fontSize: 28),
            )
        )
      ],
    );
  }

  Widget Right_View() {
    return Scrollbar(
        controller: _scrollController_R,
        child: SingleChildScrollView(
          controller: _scrollController_R,
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: invoiceList.length,
            itemBuilder: (context, i) {
              var inv_entry = invoiceList.entries.toList();
              return Table(
                  children: [
                    TableRow(
                        children: [
                          indexContainer(inv_entry[i].key.toString(), inv_entry[i].value)
                        ]
                    )
                  ]
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 16), // ここで間隔を指定
          ),
        )
    );
  }

  Widget indexContainer(String num, Invoice inv){
    return Container(
      width: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "tag: $num",
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "送金者: ${inv.payee}",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () {
                  // クリップボードにテキストをコピー
                  Clipboard.setData(ClipboardData(text: inv.payee));
                  // スナックバーを表示
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('テキストがクリップボードにコピーされました')),
                  );
                },
                icon: const Icon(Icons.copy, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "支払額: ${GetAmount(inv.amount)} JPYC",
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Text(
            "Status: ${InvoiceStatus.fromCode(inv.status).state}",
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController_R.dispose();
    invoiceList.clear();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    invoiceList.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child:Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Left_View()
          ),
          Expanded(
              flex: 3,
              child:Right_View()
          ),
        ],
      ),
    );
  }
}