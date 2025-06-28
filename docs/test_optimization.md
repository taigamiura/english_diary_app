# Flutter Test Configuration
# テストの分類とタグ付けのためのドキュメント

## テストカテゴリ

### 🚨 Critical Tests (クリティカルテスト)
最も重要で、どのブランチでも必ず実行すべきテスト
- **対象**: モデル、基本ユーティリティ
- **実行時間**: ~2分
- **トリガー**: 全ブランチ
- **タグ**: `@Tags(['critical'])`

### 🎯 Targeted Tests (ターゲットテスト)  
変更された部分に関連するテストのみ実行
- **対象**: 変更されたディレクトリに対応するテスト
- **実行時間**: ~5分
- **トリガー**: feature/*, bug/* ブランチ
- **タグ**: `@Tags(['unit'])`

### 📋 Standard Tests (標準テスト)
コアロジックをカバーする標準的なテストセット
- **対象**: モデル、サービス、プロバイダー
- **実行時間**: ~8分  
- **トリガー**: その他のブランチ
- **タグ**: `@Tags(['unit', 'service'])`

### 🔍 Comprehensive Tests (包括的テスト)
UI以外の全機能をカバーするテスト
- **対象**: ウィジェット以外の全テスト
- **実行時間**: ~12分
- **トリガー**: development ブランチ
- **タグ**: `@Tags(['unit', 'service', 'integration'])`

### 🎯 Full Tests (フルテスト)
全てのテストを実行（UI含む）
- **対象**: 全テスト
- **実行時間**: ~15分
- **トリガー**: main ブランチ
- **タグ**: 全タグ

## テストタグの使用例

```dart
// モデルテスト（クリティカル）
@Tags(['critical', 'unit', 'model'])
void main() {
  group('User Model Tests', () {
    // テストコード
  });
}

// サービステスト（標準）
@Tags(['unit', 'service'])
void main() {
  group('User Service Tests', () {
    // テストコード
  });
}

// ウィジェットテスト（フルのみ）
@Tags(['widget', 'ui'])
void main() {
  group('User Widget Tests', () {
    // テストコード
  });
}

// 統合テスト（包括的・フル）
@Tags(['integration'])
void main() {
  group('User Integration Tests', () {
    // テストコード
  });
}
```

## テスト実行コマンド

```bash
# クリティカルテストのみ
flutter test --tags critical

# UIテストを除外
flutter test --exclude-tags widget

# 特定のタグで実行
flutter test --tags "unit && service"

# 特定のタグを除外
flutter test --exclude-tags "widget || integration"
```

## ブランチ戦略とテスト対応

| ブランチ | テスト戦略 | 実行時間 | カバレッジ |
|---------|-----------|----------|-----------|
| main | Full | ~15分 | 必須 |
| development | Comprehensive | ~12分 | 推奨 |
| feature/* | Targeted | ~5分 | 変更部分のみ |
| hotfix/* | Critical | ~2分 | なし |
| bug/* | Targeted | ~5分 | 変更部分のみ |

## 最適化のポイント

### 1. **並列実行**
- 独立したテストカテゴリを並列で実行
- GitHub Actions のマトリックス機能を活用

### 2. **キャッシュ活用**
- Flutter SDK とパッケージのキャッシュ
- ビルド成果物のキャッシュ

### 3. **条件付き実行**
- ファイル変更検出による条件付きテスト実行
- ブランチ名による戦略切り替え

### 4. **早期失敗**
- クリティカルテストが失敗したら即座に終了
- 依存関係のあるジョブの適切な制御

### 5. **リソース最適化**
- 軽量なランナーの使用
- 不要なステップのスキップ

## 設定例

### dart_test.yaml
```yaml
tags:
  critical: 
    - test/models/**
    - test/utils/**
  unit:
    - test/models/**
    - test/services/**
    - test/providers/**
  widget:
    - test/widgets/**
    - test/views/**
  integration:
    - test/integration/**

platforms:
  - vm
  - chrome

timeout: 30s
```
