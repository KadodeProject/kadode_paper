generate_dir=$1
public_dir=$2
# スクリーンショットの取得
chromium-browser --headless  --disable-gpu --overwrite --screenshot="$generate_dir/screenshot_raw.png" --window-size=960,540 https://portal.kado.day/paper
#png->jpneg変換(ImageMagicでconvert)
convert $generate_dir/screenshot_raw.png $generate_dir/screenshot_jpg.jpg
# M5Paperが描画できる形式への変換(jpgのベースライン形式でないと表示不可なのでプログレッシブ→ベースラインの変換を行う) 保存先を公開ディレクトリに移動(cpの手間省ける)
jpegtran $generate_dir/screenshot_jpg.jpg > $public_dir/screenshot.jpg
