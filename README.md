# English Diary App

英語日記アプリ（Flutter/Riverpod/Repositoryパターン）

---

## 概要

英語日記を記録・分析できるFlutter製アプリです。

---

## 技術スタック
- Flutter 3.x
- Riverpod (状態管理)
- freezed (モデル/イミュータブル)
- Supabase (BaaS/認証/DB)
- Sentry (エラー監視)
- mockito, flutter_test (テスト)
- shared_preferences (ローカルストレージ)
- intl (日付/ロケール)

---

## ディレクトリ構成

```
lib/
  constants/         # 定数
  models/            # freezedモデル
  repositories/      # Repository層
  services/          # Service層
  providers/         # Riverpod Provider
  views/             # UI層（ページ/ウィジェット）
  utils/             # ロガー等ユーティリティ
  main.dart          # エントリポイント
```

---

## セットアップ手順

1. **依存パッケージのインストール**
   ```sh
   flutter pub get
   ```
2. **環境変数ファイルの作成**
   - `.env.example` をコピーして `.env` を作成：
     ```sh
     cp .env.example .env
     ```
   - `.env` ファイルに実際の設定値を記載：
     ```env
     SUPABASE_URL=your_actual_supabase_url
     SUPABASE_ANON_KEY=your_actual_anon_key
     SENTRY_DSN=your_actual_sentry_dsn
     GOOGLE_IOS_CLIENT_ID=your_ios_client_id
     GOOGLE_WEB_CLIENT_ID=your_web_client_id
     DEV_USER_EMAIL=your_dev_email
     DEV_USER_PASSWORD=your_dev_password
     ```
   - ⚠️ **注意**: `.env` ファイルは `.gitignore` に含まれており、リポジトリにはコミットされません
3. **iOS/Androidビルド準備**
   - iOS: `cd ios && pod install`
   - Android: `flutter pub get` のみでOK
4. **pre-commitフック推奨**
   - `.git/hooks/pre-commit` に以下を追加：
     ```sh
     #!/bin/sh
     flutter analyze || exit 1
     flutter pub outdated || exit 1
     ```
   - 実行権限付与: `chmod +x .git/hooks/pre-commit`
5. **依存性脆弱性チェック**
   - SnykやVSCode拡張（Snyk Vulnerability Scanner）推奨
6. **テスト実行**
   ```sh
   flutter test
   ```

---

## アーキテクチャ詳細

- **Model**: freezedで型安全・イミュータブル
- **Repository**: API/DB/Mock切替・テスト容易
- **Service**: Supabase等外部連携
- **Provider**: StateNotifier<State>で状態・ローディング・エラー一元管理
- **Global Provider**: グローバルなローディング・エラー状態
- **依存注入**: Provider経由でRepository/Serviceを注入
- **テスト**: mockitoで依存注入・Riverpod override

### アーキテクチャ図
```
[UI]
  ↓
[Provider (StateNotifier<State>)]
  ↓
[Service] ←→ [Repository] ←→ [API/Supabase]
  ↑
[Global Provider (Loading/Error)]
```

---

## ルーティング・UI/UX
- `main.dart`でMaterialAppの`routes`に明示的に全ページを登録
- pushReplacementNamed等で安全な画面遷移
- ローディング時はCircularProgressIndicator表示
- エラー時はErrorPageで例外内容を明示
- ダッシュボード/日記一覧はグローバルな月状態で同期
- 日記リストは新しい順（createdAt降順）で表示
- カード高さはSizedBoxで統一

---

## セキュリティ・運用
- .env等の秘匿情報はgit管理外
- Supabase/Sentry等のAPIキーは環境変数経由で注入
- 依存性は定期的に`flutter pub outdated`/Snyk等で監査
- pre-commitで静的解析・依存性チェックを自動化
- Sentryで本番エラーを監視
- テストはshared_preferences, Supabaseのmock初期化で安定化

---

## 開発・運用ベストプラクティス
- Provider/Repository/Serviceは必ずconcrete classで実装
- ProviderはautoDispose推奨
- 例外は独自ExceptionでラップしUI層でcatch
- null安全・イミュータブル徹底
- テスト容易な依存注入設計
- ルーティングはMaterialAppのroutesで一元管理
- ログはdebug時はprint, 本番はSentry送信
- CI/CD導入推奨（GitHub Actions等）

---

## 参考リンク
- [Flutter公式](https://docs.flutter.dev/)
- [Riverpod公式](https://riverpod.dev/)
- [Supabase公式](https://supabase.com/docs)
- [Sentry公式](https://docs.sentry.io/platforms/flutter/)

---

## ライセンス
MIT
