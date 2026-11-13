# JPYC Sub-Payment System DX v2(Web版)

ブロックチェーン上に**支払書類を作成し、かつそれを証憑と連動させることができる**アプリです。

請求書の明細・但し書き・税区分などの**追加書類に強い**請求書特化型ツールとして作っています。



## 主な特徴

- 支払用紙を紙とブロックチェーンの両方で作成することで、証憑を持った送金を可能に
- 締切のある取引や、「誰がこの取引の相手だったのか」分かる送金を可能に
- 紙とデジタルの連動で、あとでの突合もスムーズに可能

---

## 使い方（接続）
1. Web版を開く
2. コネクトボタンを押す

<img src="https://raw.githubusercontent.com/ChocoTanaka/Metamask_EIP-681_Pay_Web/subpay-v2/assets/images/screenshot_intro2.png" alt="〇を押してね" title="〇を押してね">

3. 所定のウォレットを選択する（スマホなら所定のアプリに移動します）

<img src="https://raw.githubusercontent.com/ChocoTanaka/Metamask_EIP-681_Pay_Web/subpay-v2/assets/images/screenshot_connect2.png" alt="自由選択" title="自由選択">

4. ボタンが青くなったら完了。青くなってないなら、もう一回押して接続を確認しよう。

##  使い方（書き出し）

1. 確認用に16桁のタグ、宛名、金額、締め切り、　振込先の名前（つまり自分の名前）を書き、SETを押す。

<img src="https://raw.githubusercontent.com/ChocoTanaka/Metamask_EIP-681_Pay_Web/subpay-v2/assets/images/screenshot_write.png" alt="作成後" title="作成後">

2. 　確認後、「PDFを発行する」を押す。


<img src="https://raw.githubusercontent.com/ChocoTanaka/Metamask_EIP-681_Pay_Web/subpay-v2/assets/images/testpdf5.jpg" alt="支払用紙" title="支払用紙">

3. このPDFを保存する。

4. 　「請求書トランザクションを発行する」を押す。

5.　トランザクションを実行する。

## 使い方（読み取り）

1. 請求書のリンクを読み取り
2. 金額・明細を確認して、「支払う」を押す。
3. 支払金額をウォレットで確認し
   <img src="https://raw.githubusercontent.com/ChocoTanaka/Metamask_EIP-681_Pay_Web/subpay-v2/assets/images/screenshot_read2.png" alt="支払画面" title="支払画面">
4. 時間が経ったら承認画面が出るので承認する。


詳細な説明・スクリーンショットは[SubPayment解説2.pdf](https://github.com/ChocoTanaka/Metamask_EIP-681_Pay_Web/blob/subpay-v2/SubPaymentv2%E8%A7%A3%E8%AA%AC.pdf)を参照してください。

## 索引
こちらから、payeeが自分のアドレスのものを索引してください。

[リンク](https://polygonscan.com/address/0xA14E673D100cfe159CFfA4bACd6fd1BfEcbAff88#events)

もしくは、polygonscanから自分のアドレスを検索お願いいたします。

[リンク](https://polygonscan.com/)

---
## 注意
- Polygonネットワーク限定（ガス代はPOLなどで別途必要）
- JPYCの実用決済ツールとして、振込に近い形で使えるよう設計しています

---

## プライバシーポリシー
- このwebページはユーザーから情報を収集することはありません。
- 作成した書類の正誤に関しては、技術的な問題であることが判明したときのみ対応いたします。

---
**フィードバック・要望大歓迎です！**  
IssueやX（@SENKI_MMSub）までお願いします。
