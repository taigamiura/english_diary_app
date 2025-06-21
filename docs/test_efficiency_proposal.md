# Flutter テスト効率化の提案

## 🎯 効率化戦略

### 1. **ブランチベースのテスト戦略**

| ブランチパターン | テスト戦略 | 実行時間 | カバレッジ | 説明 |
|----------------|-----------|----------|-----------|------|
| `main` | Full | ~15分 | 必須 | 本番リリース前の完全テスト |
| `development` | Comprehensive | ~12分 | 推奨 | UI以外の全機能テスト |
| `feature/*` | Targeted | ~5分 | 変更部分のみ | 変更されたファイルに関連するテストのみ |
| `hotfix/*` | Critical | ~2分 | なし | 最重要テストのみ |
| `bug/*` | Targeted | ~5分 | 変更部分のみ | バグ修正に関連するテストのみ |
| その他 | Standard | ~8分 | 基本 | コアロジックのテスト |

### 2. **実装されたツール**

#### 🔧 最適化スクリプト (`scripts/optimize_tests.sh`)
```bash
# 自動でブランチを検出してテスト戦略を決定
./scripts/optimize_tests.sh

# 手動でテスト戦略を指定
./scripts/optimize_tests.sh feature/auth main targeted

# 特定のブランチでテスト
./scripts/optimize_tests.sh development main comprehensive
```

#### 📊 GitHubワークフロー (`flutter_test_optimized.yml`)
- 変更ファイル検出による条件付き実行
- ブランチ別の並列テスト実行
- 早期失敗によるリソース節約
- 詳細なテスト結果レポート

### 3. **テストカテゴリ分類**

#### 🚨 Critical Tests (2分)
```bash
# 最重要なテストのみ
flutter test test/models/ test/utils/ --reporter=compact
```
- **対象**: モデル、基本ユーティリティ
- **実行**: 全ブランチで必須
- **目的**: 基本機能の破綻チェック

#### 🎯 Targeted Tests (5分)
```bash
# 変更されたファイルに関連するテストのみ
if [ -d "test/models/" ] && [[ $models_changed == true ]]; then
  flutter test test/models/
fi
```
- **対象**: 変更されたディレクトリのテスト
- **実行**: feature/, bug/ ブランチ
- **目的**: 変更による影響範囲の確認

#### 📋 Standard Tests (8分)
```bash
# コアロジックのテスト
flutter test test/models/ test/services/ test/providers/ --reporter=expanded
```
- **対象**: モデル、サービス、プロバイダー
- **実行**: 通常のブランチ
- **目的**: 主要機能の動作確認

#### 🔍 Comprehensive Tests (12分)
```bash
# UI以外の全テスト + カバレッジ
flutter test --exclude-tags=widget --coverage --reporter=expanded
```
- **対象**: ウィジェット以外の全テスト
- **実行**: development ブランチ
- **目的**: 統合前の包括的チェック

#### 🎯 Full Tests (15分)
```bash
# 全テスト + カバレッジ + 詳細レポート
flutter test --coverage --reporter=expanded
```
- **対象**: 全テスト
- **実行**: main ブランチ
- **目的**: リリース前の完全検証

### 4. **実装済み最適化**

#### ✅ 変更検出機能
```bash
# Git差分による変更ファイル検出
get_changed_files() {
    if git rev-parse --verify HEAD^ >/dev/null 2>&1; then
        git diff --name-only HEAD^ HEAD
    else
        git ls-files | head -10
    fi
}
```

#### ✅ 条件付きテスト実行
```bash
# 変更があった場合のみテスト実行
if [[ $models_changed == true ]]; then
    flutter test test/models/
fi
```

#### ✅ カバレッジ分析
```bash
# カバレッジ統計の自動表示
show_coverage_stats() {
    # Python3でLCOVファイルを解析
    # 低カバレッジファイルの特定
    # 未カバー行の詳細表示
}
```

### 5. **使用方法**

#### 🚀 開発者向け
```bash
# 現在のブランチに応じた最適なテストを実行
./scripts/optimize_tests.sh

# フルテストを強制実行
./scripts/optimize_tests.sh $(git rev-parse --abbrev-ref HEAD) main full

# クリティカルテストのみ実行
./scripts/optimize_tests.sh $(git rev-parse --abbrev-ref HEAD) main critical
```

#### 🔧 CI/CD向け
```yaml
# .github/workflows/flutter_test_optimized.yml を使用
# 自動で以下を実行:
# 1. 変更ファイル検出
# 2. ブランチに応じたテスト戦略決定
# 3. 並列テスト実行
# 4. 結果レポート生成
```

### 6. **期待される効果**

#### ⏱️ 実行時間短縮
- **feature ブランチ**: 15分 → 5分 (67%短縮)
- **bug ブランチ**: 15分 → 5分 (67%短縮)
- **hotfix ブランチ**: 15分 → 2分 (87%短縮)

#### 💰 リソース節約
- **CI分数削減**: 月間で大幅なコスト削減
- **開発者待機時間短縮**: 生産性向上
- **早期フィードバック**: 問題の早期発見

#### 🎯 品質維持
- **main ブランチ**: 100%テスト実行
- **critical テスト**: 常時実行で基本品質保証
- **段階的チェック**: ブランチごとの適切な品質ゲート

### 7. **さらなる最適化案**

#### 🔄 並列実行
```yaml
strategy:
  matrix:
    test-category: [models, providers, services, repositories]
```

#### 📊 キャッシュ活用
```yaml
- name: キャッシュ復元
  uses: actions/cache@v3
  with:
    path: |
      ~/.pub-cache
      build/
    key: flutter-${{ hashFiles('pubspec.lock') }}
```

#### 🎯 差分テスト
```bash
# 変更されたファイルに関連するテストファイルのみ実行
find_related_tests() {
    local changed_file=$1
    case $changed_file in
        lib/models/*) echo "test/models/" ;;
        lib/services/*) echo "test/services/" ;;
        lib/providers/*) echo "test/providers/" ;;
    esac
}
```

### 8. **導入手順**

1. **スクリプト配置**: `scripts/optimize_tests.sh` を実行可能にする
2. **ワークフロー更新**: `.github/workflows/flutter_test_optimized.yml` を有効化
3. **設定調整**: `dart_test.yaml` でタイムアウト等を調整
4. **チーム周知**: ドキュメント共有と使用方法説明

この効率化により、開発速度の向上と品質維持を両立できます。
