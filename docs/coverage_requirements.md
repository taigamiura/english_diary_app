# GitHub Branch Protection & Coverage Requirements

## 🛡️ ブランチ保護設定

GitHub上でmainとdevelopmentブランチへのマージ時に、カバレッジ95%以上を必須とする設定方法です。

## 📋 設定手順

### 1. GitHub リポジトリでブランチ保護ルールを作成

1. **リポジトリの Settings タブ**に移動
2. **Branches** セクションを選択
3. **Add rule** ボタンをクリック

### 2. main ブランチの保護設定

```
Branch name pattern: main

☑️ Restrict pushes that create files
☑️ Require a pull request before merging
  ☑️ Require approvals: 1
  ☑️ Dismiss stale PR approvals when new commits are pushed
  ☑️ Require review from code owners
  
☑️ Require status checks to pass before merging
  ☑️ Require branches to be up to date before merging
  
  Required status checks:
  - test-summary
  - full-tests
  - カバレッジ要件チェック (main向け)
  
☑️ Require conversation resolution before merging
☑️ Include administrators
```

### 3. development ブランチの保護設定

```
Branch name pattern: development

☑️ Require a pull request before merging
  ☑️ Require approvals: 1
  ☑️ Dismiss stale PR approvals when new commits are pushed
  
☑️ Require status checks to pass before merging
  ☑️ Require branches to be up to date before merging
  
  Required status checks:
  - test-summary
  - comprehensive-tests
  - カバレッジ要件チェック (main/development向け)
  
☑️ Include administrators
```

## 🎯 カバレッジ要件

### 必須カバレッジ率
- **main ブランチ**: 95%以上
- **development ブランチ**: 95%以上
- **feature ブランチ**: 制限なし（推奨: 90%以上）

### チェック対象
- **ライン カバレッジ**: 実行された行の割合
- **除外ファイル**: 
  - 自動生成ファイル (`.g.dart`, `.freezed.dart`)
  - テストファイル自体

## 🔧 実装されたチェック機能

### 1. 自動カバレッジ計算
```bash
# LCOVファイルから自動計算
total_lines=$(grep -c "^DA:" coverage/lcov.info)
covered_lines=$(grep "^DA:" coverage/lcov.info | grep -v ",0$" | wc -l)
coverage_percent=$(echo "scale=2; $covered_lines * 100 / $total_lines" | bc -l)
```

### 2. 条件付きチェック実行
```yaml
# main/development向けPRのみチェック
if: |
  (github.event_name == 'pull_request' && 
   (contains(github.event.pull_request.base.ref, 'main') || 
    contains(github.event.pull_request.base.ref, 'development')))
```

### 3. 詳細エラーメッセージ
```
❌ カバレッジが要求水準を下回りました
   現在: 89.5%
   要求: 95.0%以上
   差分: 5.5%不足

🔧 対処方法:
1. 不足しているテストを追加
2. 未テストのコードパスを特定
3. エッジケースのテストを追加
4. モックが適切に設定されているか確認
```

## 📊 カバレッジ分析機能

### 1. ファイル別カバレッジ表示
```
⚠️  改善が必要なファイル (90%未満):
lib/providers/auth_provider.dart          85.2% ( 8 lines uncovered)
lib/services/payment_service.dart         89.1% ( 3 lines uncovered)
```

### 2. 未カバー行の詳細
```
lib/providers/auth_provider.dart: lines 45, 67, 89, 123
lib/services/payment_service.dart: lines 12, 34, 78
```

### 3. 良好なファイルの表示
```
✅ 良好なカバレッジファイル (95%以上):
lib/models/diary_model.dart               100.0%
lib/utils/utils.dart                       98.5%
```

## 🚀 マージフロー

### 成功時のフロー
```
1. PR作成 → feature/xxx → development
2. 自動テスト実行 (Targeted Tests)
3. カバレッジチェック なし
4. ✅ マージ可能

1. PR作成 → development → main  
2. 自動テスト実行 (Full Tests)
3. カバレッジチェック (95%以上要求)
4. ✅ カバレッジ OK → マージ可能
   ❌ カバレッジ不足 → マージブロック
```

### カバレッジ不足時のフロー
```
1. PR作成 → development → main
2. フルテスト実行
3. カバレッジ: 89.5% (95%未満)
4. ❌ Status Check失敗
5. ⛔ マージがブロックされる
6. 🔧 テスト追加して再プッシュ
7. 📈 カバレッジ: 96.2%
8. ✅ Status Check成功
9. ✅ マージ可能
```

## 🔧 開発者向けローカルチェック

### カバレッジをローカルで確認
```bash
# カバレッジ付きテスト実行
flutter test --coverage

# カバレッジ率を確認
./scripts/optimize_tests.sh main main full

# 詳細レポート生成 (macOS/Linux)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### カバレッジ向上のコツ
```bash
# 1. 未カバー行を特定
grep ",0$" coverage/lcov.info

# 2. 特定ファイルのカバレッジを確認
flutter test test/providers/auth_provider_test.dart --coverage

# 3. モックの設定を確認
# - すべてのメソッドがモックされているか
# - 例外ケースもテストしているか
# - 異なる戻り値パターンをテストしているか
```

## ⚠️ 注意事項

### 1. カバレッジ100%は目標ではない
- **95%で実用的な品質を確保**
- **100%を目指すとテストが複雑化**
- **重要な機能を優先的にテスト**

### 2. 除外すべきファイル
```yaml
# 自動的に除外される
- *.g.dart         # 自動生成ファイル
- *.freezed.dart   # Freezed生成ファイル
- test/**/*        # テストファイル自体

# 手動で除外を検討
- main.dart        # エントリーポイント
- constants/**/*   # 定数ファイル
```

### 3. 緊急時の対応
```bash
# カバレッジチェックを一時的にスキップ
# (管理者権限が必要)
git commit -m "緊急修正" --allow-empty
git push origin main --force-with-lease
```

この設定により、コードの品質を自動で保護し、mainとdevelopmentブランチの安定性を確保できます。
