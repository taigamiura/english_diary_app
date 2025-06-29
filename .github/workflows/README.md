# GitHub Actions Workflows

## 📋 自動PR作成ワークフロー

### 概要
`create-pr-on-push.yml` は、`feature/*` または `bug/*` ブランチへのプッシュを検知して、自動的に `development` ブランチへのプルリクエストを作成するワークフローです。

### 動作タイミング
- `feature/*` ブランチへのプッシュ時
- `bug/*` ブランチへのプッシュ時

### 主な機能
- ✅ 自動PR作成
- 🔍 既存PRの重複チェック
- 📝 コミット履歴の自動取得と表示
- 🛡️ エラーハンドリング
- 🤖 美しいPRテンプレート

### 注意事項
- `development` ブランチが存在しない場合、自動的に作成されます
- 既存のPRがある場合、新しいPRは作成されません
- 権限: `contents: write`, `pull-requests: write` が必要

### テスト方法
1. `feature/test-workflow` ブランチを作成
2. ファイルを変更してコミット・プッシュ
3. ワークフローが動作することを確認
4. 自動的にPRが作成されることを確認

### トラブルシューティング
- **権限エラー**: リポジトリの設定で Actions の権限を確認
- **ブランチ保護**: `development` ブランチの設定を確認
- **トークン**: `GITHUB_TOKEN` の権限スコープを確認
