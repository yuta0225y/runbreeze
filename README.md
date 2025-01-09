# runbreeze
## ■ サービス概要

「RunBreeze」は、ランニングやマラソン大会に参加するランナーが、学びやベストプラクティスを投稿・共有できるプラットフォームです。ユーザーは自身の経験や知識を投稿し、他のランナーと情報を交換しながら、より良いランニングライフを目指せます。カテゴリーやタグ機能により、誰でも気軽に投稿でき、必要な情報を簡単に探せるように設計されています。また、AIコーチによるランニングアドバイス機能により、ランニングに関する悩みや不安を相談することができます。

## ■ このサービスへの思い・作りたい理由

私自身、多くのランナーと同じく怪我に悩んでいます。ランニングを長く楽しみ、速く走るための方法を日々模索していますが、信頼できる情報を見つけることが難しいのが現状です。InstagramやX、YouTube、ブログ等を活用していますが、情報が分散していたり、信憑性の低いアフィリエイト目的の投稿に惑わされることもあります。

そこで、信頼できる情報を一つのプラットフォームで共有できる場所があれば、という考えに至りました。このサービスでは、ランナー同士が良質で信頼できる情報を共有し合い、怪我を予防しながらランニングの上達に役立つ知識を学べる場を提供します。信頼できる情報を基に、ランナーが楽しく、継続してランニングを続けられるようにサポートします。

## ■ ユーザー層について

- **初心者ランナー**: ジョギングやマラソンを始めたばかりの方が抱える課題や疑問に対して、経験豊富なランナーのアドバイスや実践的な対策を提供し、ランニングを続けやすくするサポートを行います。
- **経験者ランナー**: ランニング経験豊富な方は、知識や経験を他のランナーと共有し、コミュニティ全体の知識を充実させることに貢献できます。
- **大会参加者**: マラソンやジョギング大会の準備や対策に関する情報を共有する機能を提供し、参加者がベストなパフォーマンスを発揮できるよう支援します。

## ■ サービスの利用イメージ

- **投稿一覧画面**:
    - 他のランナーの投稿を一覧で表示し、タイトルやカテゴリー、タグで検索できます。
    - 気になる投稿をブックマークして後でアクセスできます。
- **投稿詳細画面**:
    - 投稿の詳細を確認し、「いいね」「コメント」「ブックマーク」などのアクションが可能です。
- **投稿機能**:
    - タイトル、カテゴリー、タグを設定し、画像や参考URLを添付して投稿できます。
- **マイページ機能**:
    - プロフィール編集や投稿履歴の確認、投稿の編集・削除ができます。
    - ブックマークや下書き管理も可能です。

## ■ ユーザーの獲得について

- 友人やランナー仲間への紹介
- XやInstagramなどのSNSでシェア

## ■ サービスの差別化ポイント・推しポイント

- **信頼性の高い情報共有プラットフォーム**:
    - ランナー自身の経験を基にした信頼できる情報を共有し、アフィリエイト目的の信頼性の低い情報との差別化を図ります。
- **初心者から大会参加者まで幅広くサポート**:
    - ランニング初心者から大会参加者まで、それぞれのニーズに合わせた情報を提供します。
- **AIによるランニングアドバイス機能で悩みや不安をサポートします**:
    - AIコーチによるランニングアドバイス機能により、安心してランニングを継続できるよう支えます。
- **ブックマーク機能で情報管理が容易に**:
    - 気になる投稿を後から見返せるようにし、ランナーが必要な情報にすぐアクセスできるようにします。
- **コミュニティでのサポートと情報交換**:
    - コメントやシェアを通じてランナー同士が情報を交換し合い、相互にサポートし合える環境を提供します。

## ■ 機能候補

### **MVPリリース時に実装する機能**

1. **ユーザー認証機能**（Deviseを使用）
    - メール認証とGoogle認証を使った安全なログインとサインアップ機能。
2. **投稿機能**（タイトル、カテゴリー、タグ、画像、参考URLの投稿）
    - ベストプラクティスや知識を投稿でき、画像やURLの添付も可能です。
3. **検索機能**（タイトル、タグ、カテゴリー、アカウント名で検索）
    - 複数条件で検索でき、投稿を簡単に見つけられます。
4. **マイページ機能**
    - プロフィール編集、投稿管理、ブックマーク、下書き保存が可能です。

### **本リリースで実装する機能**

1. **AIコーチによるランニングアドバイス機能**（OpenAI API使用）
    - AIコーチにランニングに関する悩みや不安を相談することができます。
    - プロフィールに対してパーソナライズされた回答ができるよう実装予定です。
2. **規約やお問い合わせページ**:
    - 利用規約、プライバシーポリシー、問い合わせフォームを提供します。
3. **モバイルフレンドリーな設計**
    - スマートフォンで使いやすいようレスポンシブル対応に整え、UIUXを改善する。


## ■ 機能の実装方針予定

- **バックエンド**: Ruby on Rails
- **フロントエンド**: Daisy UI, Tailwind CSS, Javascript
- **API**: OpenAI API, Google Identity Services API
- **データベース**: PostgreSQL
- **コンテナ**: Docker
- **デプロイ先**: Render
- **その他**:
    - devise（認証）
    - S3 (画像アップロードのためのストレージ)
    - CarrierWave (画像アップロード用Gem)
    - RMagick (画像処理用)
    - ransack（検索）
    - kaminari（ページネーション）
    - Rspec（テスト）等

## ■ 画面遷移図（当初作成したもの）
https://www.figma.com/design/DzoAn9Omlx50S9XRIt02uF/RunBreeze-(AI%E6%A0%A1%E6%AD%A3%EF%BC%89?node-id=0-1&t=taU6fewwxzLGpUAV-1

## ■ ER図
https://dbdiagram.io/d/6719c06b97a66db9a313d3b9
