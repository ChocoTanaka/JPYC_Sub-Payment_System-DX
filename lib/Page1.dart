import 'reown.dart';
import 'package:flutter/material.dart';
import 'Web3.dart';



class Page1 extends StatefulWidget {
  const Page1({super.key});



  @override
  State<Page1> createState() => _MPSsState_Read();
}

class _MPSsState_Read extends State<Page1> {

  String tag16toreadtag(String tag16) {
    List<String> readtag = [];
    for(int i = 0; i<4; i++){
      readtag.add(tag16.substring(4*i , 4*i+4));
    }

    return "${readtag[0]}　-　${readtag[1]}　-　${readtag[2]}　-　${readtag[3]}";
  }


  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                "JPYC Sub-Payment System v2 Payment",
                style: const TextStyle(fontSize: 36),
            ),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    "管理番号：",
                  style: const TextStyle(fontSize: 28),
                ),
                Text(
                  EIP712Data().inv !=null ? tag16toreadtag(EIP712Data().inv!.tag16.toString()) : "NO DATA",
                  style: const TextStyle(fontSize: 28),
                ),
            ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "支払先：",
                  style: const TextStyle(fontSize: 28),
                ),
                Text(
                  EIP712Data().inv !=null ? EIP712Data().inv!.payee : "NO DATA",
                  style: const TextStyle(fontSize: 28),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "金額：",
                  style: const TextStyle(fontSize: 28),
                ),
                Text(
                  EIP712Data().inv !=null ? "${GetAmount(EIP712Data().inv!.amount)}　JPYC" : "NO DATA",
                  style: const TextStyle(fontSize: 28),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "状態：",
                  style: const TextStyle(fontSize: 28),
                ),
                Text(
                  EIP712Data().inv !=null ? InvoiceStatus.fromCode(EIP712Data().inv!.status).state : "NO DATA",
                  style: const TextStyle(fontSize: 28),
                ),
              ],
            ),
            SizedBox(height: 100),
            Container(
              width: 200,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    backgroundColor: (Appkit().userAddress !="" && EIP712Data().GotStatus()) ? Colors.blue[200] : Colors.grey,
                  ),
                  onPressed: () async{
                    if(Appkit().userAddress !="" && EIP712Data().GotStatus()){
                      print("こっから実験する");
                      await Pay(Address: EIP712Data().Address_read, tag16: EIP712Data().tag_read, amountWei: SetWei(int.tryParse(EIP712Data().wei_read)!));
                    }
                  },
                  child: Text(
                    '支払う',
                    style: const TextStyle(fontSize: 28),
                  )
              ),
            )

            ],
        )
    );
  }
}

