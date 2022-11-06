# スクリーンショット生成サーバー

しくみ

表示画面の生成は[かどでポータル](https://portal.kado.day)に移譲。(管理しやすさのため)

M5Paper 側で画面を描画する手間が厄介であるため、ここでかどでポータル内の M5Paper 表示用ページを定期的にスクリーンショットとして保存し、それを M5Paper で読み出す仕組み。  
力技だが現状最適解であると考えられる(かどでペーパー側から POST リクエストを送ることはないため)

# 環境構築

- 自宅サーバー
- CloudRun などのサーバーレス環境
- かどで日記 VPS サーバー

が挙げられるが、ブラウザを headless で起動しスクリーンショットを取るのは非常に CPU リソースを消費するため、CPU リソースを持て余している自宅サーバーを用いる。

## 自宅サーバでの環境構築

事前に必要なもの

```
sudo apt install fonts-ipafont fonts-ipaexfont chromium-browser imagemagick libjpeg-progs
```

日本語フォント + スクリーンショット用ブラウザ(chromium) + スクショが png のみなのでこれを jpng に変換するツール(imagemagick) + 画像をベースライン形式の jpg に変換するツール(jpegtran)

## 環境

### ホームディレクトリ(chromium が保存できる位置が必要な種)

- kadode_paper を clone
- コマンド実行
- png から jpeg へ変換

これをシェルスクリプトで実行する

### 公開ディレクトリ(これ全体を nginx で公開範囲にするので git clone とかは NG)

- jpeg(プログレッシブ)から jpeg(ベースライン)へ変換

```
└── public
    ├── img
    │   └── screenshot.jpg
    └── index.html
```

シェルスクリプトで実行し、このディレクトリ内に格納する

### cron 設定

第 1 引数にスクリプトの実行位置(厳密には画像を保存・加工するパスの位置)
第 2 引数に最終的な保存位置(厳密には公開ディレクトリの位置)

```
*/30 * * * * path_to_script/takeScreenshot.sh path_to_script path_to_public
```
