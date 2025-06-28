# Changelog

All notable changes to KIWI (English Diary App) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-06-28

### ✨ Added
- 🥝 **KIWI English Diary App** - 初回リリース
- 📱 **Beautiful UI Design**
  - 白背景のKIWIロゴアイコンとスプラッシュスクリーン
  - iOSとAndroid用に最適化された異なるアイコン
  - マテリアルデザインベースのモダンなUI
- ✍️ **Diary Management System**
  - 英語日記の作成・編集・削除機能
  - リッチテキスト入力サポート
  - 直感的な操作インターフェース
- 🔐 **Secure Authentication**
  - Supabaseを使用した安全な認証システム
  - Googleサインイン統合
  - セキュアストレージによる認証情報の保護
- 📅 **Monthly Navigation**
  - 月別の日記表示とナビゲーション
  - カレンダー形式での日記一覧
  - スムーズな月間切り替え
- 🎨 **App Theming**
  - KIWIブランドカラーの統一されたデザイン
  - ライト・ダークモード対応
  - プラットフォーム固有のデザイン要素

### 🛠️ Technical Features
- **Flutter 3.24.3+** - 最新のFlutterフレームワーク
- **Dart 3.7.2+** - モダンなDart言語機能
- **Supabase Backend** - PostgreSQLによるリアルタイムデータ管理
- **Riverpod State Management** - 効率的で型安全な状態管理
- **Sentry Integration** - エラー監視とクラッシュレポート
- **Secure Storage** - 機密データの暗号化保存
- **Internationalization** - 多言語対応基盤

### 🧪 Quality Assurance
- **Comprehensive Testing** - 470+のテストによる品質保証
- **Static Analysis** - Flutter Lintsによるコード品質管理
- **Mock Testing** - Mockitoを使用したユニットテスト
- **Widget Testing** - Flutter Test Frameworkによるウィジェットテスト
- **Integration Testing** - エンドツーエンドテストの実装

### 🚀 DevOps & CI/CD
- **GitHub Actions** - 自動PR作成とCI/CD
- **Automated Testing** - プッシュ時の自動テスト実行
- **Code Coverage** - テストカバレッジレポート
- **Branch Protection** - 品質ゲートによるコード品質保証

### 📱 Platform Support
- **iOS**: iOS 12.0以降対応
  - App Store リリース準備完了
  - 最適化されたiOSネイティブ体験
- **Android**: API level 21 (Android 5.0)以降対応
  - Google Play Store リリース準備完了
  - Adaptive アイコンサポート

### 🔒 Security & Privacy
- **Environment Variables** - APIキーの安全な管理
- **JWT Authentication** - セキュアな認証トークン
- **Data Encryption** - 通信時・保存時の暗号化
- **Privacy by Design** - ユーザープライバシーの保護

### 📦 Dependencies
- **Core Dependencies**
  - `flutter_dotenv: ^5.2.1` - 環境変数管理
  - `supabase_flutter: ^2.9.1` - バックエンド統合
  - `google_sign_in: ^6.3.0` - Google認証
  - `sentry_flutter: ^9.0.0` - エラー監視
  - `flutter_riverpod: ^2.6.1` - 状態管理
  - `flutter_secure_storage: ^9.2.4` - セキュアストレージ
  - `table_calendar: ^3.2.0` - カレンダーUI
  - `intl: ^0.20.2` - 国際化サポート

- **Development Dependencies**
  - `flutter_lints: ^6.0.0` - コード品質
  - `mockito: ^5.4.4` - モックテスト
  - `build_runner: ^2.5.3` - コード生成
  - `flutter_launcher_icons: ^0.13.1` - アイコン生成
  - `flutter_native_splash: ^2.4.1` - スプラッシュスクリーン

### 🎯 Performance
- **Optimized Assets** - 圧縮された画像アセット
- **Lazy Loading** - 必要時のみデータロード
- **Efficient State Management** - Riverpodによる最適化
- **Memory Management** - 適切なリソース管理

---

## Development Setup

### Prerequisites
- Flutter 3.24.3 or later
- Dart 3.7.2 or later
- iOS 12.0+ / Android API 21+
- Supabase account and project setup

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/[username]/english-diary-app.git
cd english_diary_app

# 2. Install dependencies
flutter pub get

# 3. Setup environment
cp .env.example .env
# Edit .env with your Supabase credentials

# 4. Generate assets
flutter packages pub run flutter_launcher_icons:main
flutter packages pub run flutter_native_splash:create

# 5. Run the app
flutter run
```

### Environment Variables

```bash
# .env file configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SENTRY_DSN=your-sentry-dsn (optional)
APP_VERSION=1.0.0
APP_ENV=production
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Widget tests
flutter test test/views/

# Unit tests
flutter test test/models/ test/providers/
```

### Building for Release

#### Android
```bash
# APK for testing
flutter build apk --release

# App Bundle for Google Play Store
flutter build appbundle --release
```

#### iOS
```bash
# iOS build for device testing
flutter build ios --release

# iOS Archive for App Store
flutter build ipa --release
```

---

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing cross-platform framework
- Supabase for providing excellent backend-as-a-service
- The open source community for invaluable packages and tools
- All contributors who helped make this release possible

---

<div align="center">
  <strong>Made with ❤️ using Flutter</strong><br>
  🥝 KIWI - English Diary App
</div>
