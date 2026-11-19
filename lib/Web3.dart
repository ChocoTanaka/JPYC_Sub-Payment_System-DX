import 'dart:convert';
import 'dart:typed_data';
import 'package:web3dart/crypto.dart';

import "dart:js_interop";

@JS('writeContractJS')
external JSPromise<JSString> _writeContractJS(JSString contractAddress,JSString abiJson,JSString functionName,JSString args);

@JS('readContractJS')
external JSPromise<JSString> _readContractJS(JSString contractAddress,JSString abiJson,JSString functionName,JSString argsJson);


final String jpycAddress = "0xE7C3D8C9a439feDe00D2600032D5dB0Be71C3c29";

final String contract = "0xA14E673D100cfe159CFfA4bACd6fd1BfEcbAff88";

final JPYCDecimal = 18;

class EIP712Data{
  // 1. クラス内部で自分自身の唯一のインスタンスを作る
  static final EIP712Data _instance = EIP712Data._internal();

  // 2. コンストラクタが呼ばれたら、必ず上のインスタンスを返す
  factory EIP712Data() {
    return _instance;
  }

  // 3. 内部用コンストラクタ
  EIP712Data._internal();

  late String wei_read = "";
  late String Address_read = "";
  late String tag_read ="";

  late Invoice? inv = null;

  bool GotStatus(){
    if(this.wei_read !="" && this.tag_read !="" && this.Address_read !=""){
      return true;
    }
    return false;
  }
}

// 1. ERC-20 の approve 関数用 ABI
const erc20AbiMap = [
  {
    "inputs": [
      {"name": "spender", "type": "address"},
      {"name": "amount", "type": "uint256"}
    ],
    "name": "approve",
    "outputs": [
      {"name": "", "type": "bool"}
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];


const AbiMap_Create =
[
  {
    "type": "function",
    "name": "registerInvoice",
    "inputs": [
      {"name": "tag16", "type": "uint256"},
      {"name": "tokenAddress", "type": "address"},
      {"name": "amount", "type": "uint256"},
      {"name": "deadline", "type": "uint256"}
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
];
// jsonEncode で完全に文字列化してから渡す
final abiJson_create = jsonEncode(AbiMap_Create);

const AbiMap_Pay =
[
  {
    "type": "function",
    "name": "payInvoice",
    "inputs": [
      {"name": "payee", "type": "address"},
      {"name": "tag16", "type": "uint256"}
    ],
    "outputs": [],
    "stateMutability": "payable"
  },
];
// jsonEncode で完全に文字列化してから渡す
final abiJson_pay = jsonEncode(AbiMap_Pay);


const AbiMap_approve =
[
  {
    "constant": false,
    "inputs": [
      {"name": "spender", "type": "address"},
      {"name": "amount", "type": "uint256"}
    ],
    "name": "approve",
    "outputs": [{"name": "", "type": "bool"}],
    "type": "function"
  }
];
// jsonEncode で完全に文字列化してから渡す
final abiJson_approve = jsonEncode(AbiMap_approve);

final String abiJson_read = jsonEncode([
  {
    "type": "function",
    "name": "invoices",
    "stateMutability": "view",
    "inputs": [
      {"name": "", "type": "bytes32", "internalType": "bytes32"}
    ],
    "outputs": [
      {"name": "tag16", "type": "uint256", "internalType": "uint256"},
      {"name": "payee", "type": "address", "internalType": "address"},
      {"name": "tokenAddress", "type": "address", "internalType": "address"},
      {"name": "amount", "type": "uint256", "internalType": "uint256"},
      {"name": "deadline", "type": "uint256", "internalType": "uint256"},
      {"name": "status", "type": "uint8", "internalType": "enum InvoiceTx.InvoiceStatus"}
    ]
  }
]);

//インボイスの作成
Future<void>CreateInvoice({
  required String tag16,
  required BigInt amountWei,
  required BigInt DeadlineUnix
}) async{
// 文字列を 32 バイトの Uint8List (bytes32) にパディング

  BigInt tag16Int = BigInt.from(num.parse(tag16));

  // 例: [tag16Int.toString(), amountWei.toString(), deadlineUnix.toString()] などをJSON化
  final argsJson = jsonEncode([tag16Int.toString(),jpycAddress, amountWei.toString(), DeadlineUnix.toString()]);

  final txHash = await _writeContractJS(
      contract.toJS,
      abiJson_create.toJS,
      "registerInvoice".toJS,
      argsJson.toJS
  ).toDart;
  print(txHash);
}

//支払
Future<void>Pay({
  required String Address,
  required String tag16,
  required BigInt amountWei
}) async{

  // 5. 引数の配列をJSON化
  final String argsJson = jsonEncode([
    contract,
    amountWei.toString(),
  ]);

  // 送信先 (to) は JPYC のアドレス！
  final approveTxHash = await _writeContractJS(
      jpycAddress.toJS,
      abiJson_approve.toJS,
      "approve".toJS,
      argsJson.toJS
  ).toDart;

  print('Approve 送信完了! Hash: ${approveTxHash.toDart}');

  // ★重要: オンチェーンで Approve トランザクションが承認（Blockに採り込まれる）されるまで数秒待ちます
  print('Approve の承認待ち...');
  await Future.delayed(Duration(seconds: 20));


  final argsJson_pay = jsonEncode([Address, tag16.toString()]);


  final txHash = await _writeContractJS(
      contract.toJS,
      abiJson_pay.toJS,
      "payInvoice".toJS,
      argsJson_pay.toJS
  ).toDart;
  print(txHash);

}

//こっから索引

enum InvoiceStatus {
  unpaid("未払い", 0),
  Paid("支払済み", 1),
  Expired("期限切れ", 2),
  Undefined("未定義", 3);

  const InvoiceStatus(this.state,this.code);
  final String state;
  final int code;

  // int -> enum（見つからない場合はフォールバックや例外を指定）
  static InvoiceStatus fromCode(int code) {
    return InvoiceStatus.values.firstWhere(
          (e) => e.code == code,
      orElse: () => InvoiceStatus.Undefined,
    );
  }
}


class Invoice {
  final BigInt tag16;
  final String payee;
  final String tokenAddress;
  final BigInt amount;
  final BigInt deadline;
  final int status; // 0: Unpaid, 1: Paid, 2: Expired, 3: Undefined など

  Invoice({
    required this.tag16,
    required this.payee,
    required this.tokenAddress,
    required this.amount,
    required this.deadline,
    required this.status,
  });

  factory Invoice.fromContractResult(dynamic raw) {
    // viem/wagmi の返却が Map（名前付き）か List（タプル順）かの両方に対応
    if (raw is Map<String, dynamic>) {
      return Invoice(
        tag16: BigInt.parse(raw['tag16'].toString()),
        payee: raw['payee'].toString(),
        tokenAddress: raw['tokenAddress'].toString(),
        amount: BigInt.parse(raw['amount'].toString()),
        deadline: BigInt.parse(raw['deadline'].toString()),
        status: int.parse(raw['status'].toString()),
      );
    } else if (raw is List) {
      return Invoice(
        tag16: BigInt.parse(raw[0].toString()),
        payee: raw[1].toString(),
        tokenAddress: raw[2].toString(),
        amount: BigInt.parse(raw[3].toString()),
        deadline: BigInt.parse(raw[4].toString()),
        status: int.parse(raw[5].toString()),
      );
    }
    throw FormatException('Unexpected invoice format: $raw');
  }
}

class InvoiceLookup {
  final Map<String, Invoice> _invoices = {};

  String _makeKey(String payee, BigInt tag16) {
    final normalizedPayee = payee.trim().toLowerCase();
    return '$normalizedPayee#${tag16.toString()}';
  }

  /// 登録・取得した請求書を索引に追加・更新
  void put(Invoice invoice) {
    _invoices[_makeKey(invoice.payee, invoice.tag16)] = invoice;
  }

  /// 画面入力の tag16 と payee アドレスから照合
  Invoice? find(String payee, BigInt tag16) {
    return _invoices[_makeKey(payee, tag16)];
  }
}

Future<Invoice?> fetchInvoiceByKey({
  required String keyHex, // 0x... の bytes32
}) async {
  final argsJson = jsonEncode([keyHex]);

  final jsResult = await _readContractJS(
    contract.toJS,
    abiJson_read.toJS,
    "invoices".toJS,
    argsJson.toJS,
  ).toDart;

  final rawStr = jsResult?.toDart;
  if (rawStr == null || rawStr.isEmpty) return null;
  if (rawStr.startsWith('__ERROR__:')) {
    throw Exception(rawStr);
  }

  final decoded = jsonDecode(rawStr);
  final invoice = Invoice.fromContractResult(decoded);

  // 未登録（payee がゼロアドレス）の場合は null 扱い
  if (invoice.payee == '0x0000000000000000000000000000000000000000') {
    return null;
  }
  return invoice;
}

String buildInvoiceKeyHex(String payeeHex, BigInt tag16) {
  // 1. address (20バイト)
  final cleanAddr = payeeHex.trim().toLowerCase().replaceFirst('0x', '');
  if (cleanAddr.length != 40) {
    throw ArgumentError('Invalid address: $payeeHex');
  }
  final addrBytes = hexToBytes(cleanAddr); // 20 bytes

  // 2. uint256 (32バイト・ビッグエンディアン)
  final tagBytes = Uint8List(32);
  var v = tag16;
  if (v < BigInt.zero) {
    throw ArgumentError('tag16 must be non-negative');
  }
  for (int i = 31; i >= 0; i--) {
    tagBytes[i] = (v & BigInt.from(0xff)).toInt();
    v = v >> 8;
  }

  // 3. abi.encodePacked(payee, tag16) を連結して keccak256
  final packed = Uint8List(52)..setRange(0, 20, addrBytes)..setRange(20, 52, tagBytes);
  final digest = keccak256(packed); // 32 bytes

  return '0x${bytesToHex(digest, include0x: false)}';
}

//締め切りの次の日の00:00まで
BigInt SetDeadline(DateTime time){
  return BigInt.from((time.add(const Duration(days: 1)).millisecondsSinceEpoch ~/ 1000));
}

BigInt SetWei(int Amount){
  BigInt Wei = BigInt.from(Amount) * BigInt.from(10).pow(JPYCDecimal);

  return Wei;
}

BigInt GetAmount(BigInt Wei){
    BigInt Amount = Wei ~/ BigInt.from(10).pow(JPYCDecimal);

    return Amount;
}

String filltag(String tag) {
  List<String> tags = [tag.substring(4*0,4*1),tag.substring(4*1,4*2),tag.substring(4*2,4*3),tag.substring(4*3,4*4)];
  return '${tags[0]} - ${tags[1]} - ${tags[2]} - ${tags[3]}';
}


