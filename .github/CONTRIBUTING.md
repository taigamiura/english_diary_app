# コントリビューションガイド

English Diary Appプロジェクトへのコントリビューションにご興味をお持ちいただき、ありがとうございます！

## 🚀 開発環境のセットアップ

### 必要な環境
- Flutter 3.24.5 以上
- Dart 3.5.0 以上
- Android Studio / VS Code
- iOS開発の場合：Xcode (macOS)

### セットアップ手順
1. リポジトリをクローン
   ```bash
   git clone https://github.com/yourusername/english-diary-app.git
   cd english-diary-app
   ```

2. 依存関係をインストール
   ```bash
   flutter pub get
   ```

3. 環境設定ファイルを作成
   ```bash
   cp .env.example .env
   # .envファイルを適切に編集してください
   ```

4. テストの実行
   ```bash
   flutter test
   ```

## 📝 開発フロー

### ブランチ戦略
- `main`: 本番環境用の安定版
- `develop`: 開発版
- `feature/*`: 新機能開発用
- `bugfix/*`: バグ修正用
- `hotfix/*`: 緊急修正用

### コミットメッセージの規約
以下の形式でコミットメッセージを作成してください：

```
type(scope): subject

body (optional)

footer (optional)
```

#### Type
- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメント更新
- `style`: コードフォーマット
- `refactor`: リファクタリング
- `test`: テスト追加・修正
- `chore`: その他の変更

#### 例
```
feat(diary): Add AI-powered grammar correction feature

- Integrate OpenAI API for grammar checking
- Add correction suggestions UI
- Update diary model to include corrections

Closes #123
```

## 🧪 テストガイドライン

### テストの種類
1. **ユニットテスト**: 各関数・メソッドの単体テスト
2. **ウィジェットテスト**: UIコンポーネントのテスト
3. **統合テスト**: アプリ全体の動作テスト

### テスト実行
```bash
# 全テスト実行
flutter test

# カバレッジ付きテスト実行
flutter test --coverage

# 特定のテストファイル実行
flutter test test/models/diary_model_test.dart
```

### テストカバレッジ
- 最低80%のカバレッジを維持してください
- 新機能にはテストを必須で追加してください

## 📋 Pull Requestガイドライン

### PR作成前のチェックリスト
- [ ] テストが全て通ることを確認
- [ ] コードカバレッジが80%以上
- [ ] Lintエラーがないことを確認
- [ ] 関連するドキュメントを更新
- [ ] PRテンプレートに従って記述

### PRのサイズ
- 変更は可能な限り小さく分割してください
- 1つのPRで1つの機能/修正に集中してください
- 大きな変更の場合は、事前にIssueで相談してください

## 🔍 コードレビュー

### レビュアーとして
- 建設的なフィードバックを提供してください
- コードの品質、パフォーマンス、セキュリティを確認してください
- 質問や提案は丁寧に行ってください

### 作成者として
- フィードバックに対して感謝の気持ちを持ってください
- 不明な点は遠慮なく質問してください
- 修正が必要な場合は迅速に対応してください

## 🏗️ アーキテクチャガイドライン

### 使用技術
- **状態管理**: Riverpod
- **データベース**: Supabase (PostgreSQL)
- **認証**: Supabase Auth
- **AI**: OpenAI API
- **決済**: Stripe

### フォルダ構成
```
lib/
├── constants/     # 定数
├── models/        # データモデル
├── providers/     # Riverpod プロバイダー
├── repositories/  # データアクセス層
├── services/      # 外部サービス連携
├── utils/         # ユーティリティ
├── views/         # 画面
└── widgets/       # 再利用可能なウィジェット
```

### コーディング規約
- Dart公式のスタイルガイドに従ってください
- `flutter analyze`でエラーがないことを確認してください
- 適切なコメントを記載してください（特に複雑なロジック）

## 🐛 バグ報告

バグを発見した場合は、以下の情報を含めてIssueを作成してください：
- 環境情報（OS、デバイス、アプリバージョン）
- 再現手順
- 期待される動作と実際の動作
- スクリーンショット（可能であれば）

## 💡 機能提案

新機能の提案は大歓迎です！以下の点を含めてIssueを作成してください：
- 機能の概要と目的
- 詳細な仕様
- UI/UXの提案
- 実装の優先度

## 📞 質問・サポート

- 技術的な質問：GitHub Issuesで`question`ラベルを付けて投稿
- セキュリティに関する問題：直接メールでご連絡ください
- その他：GitHub Discussionsをご利用ください

## 📄 ライセンス

このプロジェクトにコントリビューションすることで、あなたの貢献がMITライセンスの下でライセンスされることに同意したものとみなされます。

---

ご質問やご不明な点がございましたら、お気軽にお声がけください。皆様のコントリビューションを心よりお待ちしております！
