set -o errexit

# システムパッケージの更新と ImageMagick のインストール
apt-get update -y
apt-get install -y imagemagick libmagickwand-dev

# Gem のインストール（開発およびテストグループを除外）
bundle install --without development test

# アセットのプリコンパイル
bundle exec rails assets:precompile

# 古いアセットのクリーンアップ
bundle exec rails assets:clean
