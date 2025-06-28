# Pre-commit Configuration
# Git pre-commit hookの設定と使用方法

## 🎯 概要
このプロジェクトでは、コミット時に自動で以下を実行します：
1. **Dart/Flutter Analyze** - コードの静的解析
2. **Code Formatting** - 自動フォーマット適用
3. **Related Tests** - 変更ファイルに関連するテストのみ実行

## 🔧 実行内容

### 1. 静的解析 (flutter analyze)
```bash
flutter analyze
```
- エラーがある場合はコミットを中断
- 警告も含めて全てチェック

### 2. コードフォーマット (dart format)
```bash
dart format --set-exit-if-changed <file>
```
- フォーマットされていないファイルを自動修正
- 修正後のファイルを自動でステージ

### 3. 関連テスト実行
変更されたファイルに応じて、関連するテストのみを実行：

| 変更ファイル | 実行テスト | 実行時間 |
|-------------|-----------|----------|
| `lib/models/*` | `test/models/` | ~3秒 |
| `lib/providers/*` | `test/providers/` | ~5秒 |
| `lib/services/*` | `test/services/` | ~4秒 |
| `lib/repositories/*` | `test/repositories/` | ~2秒 |
| `lib/utils/*` | `test/utils/` | ~2秒 |
| `lib/views/*` | `test/views/` | ~8秒 |
| `lib/widgets/*` | `test/widgets/` | ~3秒 |
| `main.dart`, `pubspec.yaml` | 重要テスト (`models/`, `utils/`) | ~5秒 |
| その他 | 基本テスト (`models/`, `utils/`) | ~5秒 |

## 📋 使用例

### 通常のコミット
```bash
# ファイルを変更
echo "// コメント追加" >> lib/models/user_model.dart

# ステージング
git add lib/models/user_model.dart

# コミット（自動でanalyze + test実行）
git commit -m "ユーザーモデルにコメント追加"
```

実行される内容：
```
ℹ️  === Pre-commit Hook: Analyze & Test ===
ℹ️  📂 プロジェクトディレクトリ: /path/to/project
ℹ️  📋 ステージされたDartファイル:
ℹ️    - lib/models/user_model.dart
ℹ️  🔍 Dart/Flutter analyze を実行中...
✅ Analyze 完了: 問題は見つかりませんでした
ℹ️  🎨 コードフォーマットをチェック中...
✅ コードフォーマット OK
ℹ️  🎯 関連テストを特定中...
ℹ️    📊 モデルテストを実行対象に追加
ℹ️  🧪 テストを実行中...
ℹ️  🎯 関連テストを実行中...
ℹ️    📂 test/models/ を実行中...
✅   ✅ test/models/ 完了
ℹ️  ⏱️  実行時間: 8秒
✅ === Pre-commit チェック完了 ===
✅ 🎉 コミット可能です！
```

### フォーマット修正が必要な場合
```bash
# フォーマットされていないファイルをコミット
git add lib/services/badly_formatted_service.dart
git commit -m "サービス修正"
```

実行結果：
```
⚠️  フォーマットされていないファイルが見つかりました
ℹ️  自動でフォーマットを適用中...
✅ フォーマット完了。変更をステージしました。
```

### エラーがある場合
```bash
git commit -m "バグのあるコード"
```

実行結果：
```
❌ Analyze でエラーが検出されました
❌ 修正してから再度コミットしてください
```

## ⚙️ カスタマイズ

### テストタイムアウト調整
```bash
# .git/hooks/pre-commit の該当行を編集
flutter test "$test_dir" --reporter=compact --timeout=30s  # 30秒に変更
```

### 実行するテストの変更
```bash
# 基本テストを変更（83行目付近）
flutter test test/models/ test/utils/ test/services/  # servicesを追加
```

### pre-commitを一時的にスキップ
```bash
# 緊急時のみ使用
git commit --no-verify -m "緊急修正（テストスキップ）"
```

## 🚨 トラブルシューティング

### 1. Flutterが見つからない
```
❌ Flutter が見つかりません。Flutterをインストールしてください。
```
**解決方法**: FlutterのPATHを確認するか、以下を実行：
```bash
which flutter
export PATH="$PATH:[flutter-installation-path]/bin"
```

### 2. テストが失敗する
```
❌ test/models/ で失敗
```
**解決方法**: 該当テストを個別実行して修正：
```bash
flutter test test/models/ --reporter=expanded
```

### 3. 権限エラー
```
permission denied: .git/hooks/pre-commit
```
**解決方法**: 実行権限を付与：
```bash
chmod +x .git/hooks/pre-commit
```

## 📊 パフォーマンス

### 実行時間の目安
- **モデルのみ変更**: 5-8秒
- **プロバイダー変更**: 8-12秒  
- **ウィジェット変更**: 10-15秒
- **重要ファイル変更**: 8-10秒

### 最適化のコツ
1. **関連ファイルのみ変更**: 不要なファイルをステージしない
2. **小さなコミット**: 大きな変更は分割してコミット
3. **テスト修正**: 失敗するテストは事前に修正

## 🔧 無効化方法

### 一時的な無効化
```bash
# 1回だけスキップ
git commit --no-verify -m "コミットメッセージ"
```

### 完全な無効化
```bash
# pre-commitフックを削除または名前変更
mv .git/hooks/pre-commit .git/hooks/pre-commit.backup
```

### 再有効化
```bash
# バックアップから復元
mv .git/hooks/pre-commit.backup .git/hooks/pre-commit
```

このpre-commitフックにより、コードの品質を自動的に維持できます。
