#!/bin/bash

# English Diary App - 開発環境セットアップスクリプト
# このスクリプトは新しい開発者が簡単に開発環境を構築できるようにします

set -e  # エラーが発生したら即座に終了

# カラー出力の設定
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログ関数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# バナー表示
echo -e "${BLUE}"
echo "=================================================="
echo "  English Diary App - 開発環境セットアップ"
echo "=================================================="
echo -e "${NC}"

# OS検出
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
else
    log_error "サポートされていないOS: $OSTYPE"
    exit 1
fi

log_info "検出されたOS: $OS"

# Flutter のインストール確認
check_flutter() {
    log_info "Flutter のインストール状況を確認中..."
    
    if command -v flutter &> /dev/null; then
        FLUTTER_VERSION=$(flutter --version | head -n 1 | awk '{print $2}')
        log_success "Flutter $FLUTTER_VERSION がインストールされています"
        
        # 推奨バージョンチェック
        REQUIRED_VERSION="3.24.0"
        if [[ $(printf '%s\n' "$REQUIRED_VERSION" "$FLUTTER_VERSION" | sort -V | head -n1) == "$REQUIRED_VERSION" ]]; then
            log_success "Flutter バージョンは要件を満たしています"
        else
            log_warning "Flutter バージョンが古い可能性があります（推奨: 3.24.5以上）"
        fi
    else
        log_error "Flutter がインストールされていません"
        echo ""
        echo "Flutter のインストール方法:"
        echo "1. https://docs.flutter.dev/get-started/install にアクセス"
        echo "2. お使いのOSに対応した手順に従ってインストール"
        echo "3. flutter doctor コマンドでセットアップを確認"
        exit 1
    fi
}

# 必要なツールのインストール確認
check_tools() {
    log_info "必要なツールの確認中..."
    
    # Git
    if command -v git &> /dev/null; then
        log_success "Git がインストールされています"
    else
        log_error "Git がインストールされていません"
        exit 1
    fi
    
    # VS Code または Android Studio の確認
    if command -v code &> /dev/null; then
        log_success "VS Code が見つかりました"
    elif [[ "$OS" == "macOS" ]] && [[ -d "/Applications/Android Studio.app" ]]; then
        log_success "Android Studio が見つかりました"
    else
        log_warning "推奨エディタ (VS Code または Android Studio) が見つかりません"
        echo "VS Code: https://code.visualstudio.com/"
        echo "Android Studio: https://developer.android.com/studio"
    fi
}

# プロジェクトの依存関係インストール
install_dependencies() {
    log_info "プロジェクトの依存関係をインストール中..."
    
    # pubspec.yaml の存在確認
    if [[ ! -f "pubspec.yaml" ]]; then
        log_error "pubspec.yaml が見つかりません。プロジェクトルートで実行してください。"
        exit 1
    fi
    
    # Flutter パッケージのインストール
    flutter pub get
    if [[ $? -eq 0 ]]; then
        log_success "Flutter パッケージのインストール完了"
    else
        log_error "Flutter パッケージのインストールに失敗しました"
        exit 1
    fi
}

# 環境設定ファイルのセットアップ
setup_env_files() {
    log_info "環境設定ファイルのセットアップ中..."
    
    # .env.example の確認
    if [[ -f ".env.example" ]]; then
        if [[ ! -f ".env" ]]; then
            cp .env.example .env
            log_success ".env ファイルを作成しました"
            log_warning "注意: .env ファイルに適切な値を設定してください"
            echo ""
            echo "設定が必要な項目:"
            echo "- SUPABASE_URL"
            echo "- SUPABASE_ANON_KEY"
            echo "- OPENAI_API_KEY"
            echo "- STRIPE_PUBLISHABLE_KEY"
        else
            log_info ".env ファイルは既に存在します"
        fi
    else
        log_warning ".env.example ファイルが見つかりません"
        
        # 基本的な .env ファイルを作成
        cat > .env << 'EOF'
# Supabase設定
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# OpenAI設定
OPENAI_API_KEY=your_openai_api_key

# Stripe設定
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key

# 開発環境設定
DEBUG_MODE=true
EOF
        log_success "基本的な .env ファイルを作成しました"
        log_warning "注意: .env ファイルに適切な値を設定してください"
    fi
}

# Flutter Doctor の実行
run_flutter_doctor() {
    log_info "Flutter Doctor を実行中..."
    echo ""
    flutter doctor -v
    echo ""
}

# VS Code拡張機能の推奨インストール
setup_vscode_extensions() {
    if command -v code &> /dev/null; then
        log_info "VS Code拡張機能のインストールを推奨します..."
        echo ""
        echo "以下のコマンドを実行して推奨拡張機能をインストールしてください:"
        echo ""
        echo "code --install-extension Dart-Code.dart-code"
        echo "code --install-extension Dart-Code.flutter"
        echo "code --install-extension ms-vscode.vscode-json"
        echo "code --install-extension bradlc.vscode-tailwindcss"
        echo "code --install-extension usernamehw.errorlens"
        echo "code --install-extension esbenp.prettier-vscode"
        echo ""
        
        read -p "今すぐインストールしますか？ (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "VS Code拡張機能をインストール中..."
            code --install-extension Dart-Code.dart-code
            code --install-extension Dart-Code.flutter
            code --install-extension ms-vscode.vscode-json
            code --install-extension bradlc.vscode-tailwindcss
            code --install-extension usernamehw.errorlens
            code --install-extension esbenp.prettier-vscode
            log_success "VS Code拡張機能のインストール完了"
        fi
    fi
}

# テストの実行
run_tests() {
    log_info "テストを実行してセットアップを確認中..."
    
    flutter test
    if [[ $? -eq 0 ]]; then
        log_success "すべてのテストが通過しました"
    else
        log_warning "一部のテストが失敗しました。設定を確認してください。"
    fi
}

# Git フックのセットアップ
setup_git_hooks() {
    log_info "Git フックのセットアップ中..."
    
    # pre-commit フックの作成
    mkdir -p .git/hooks
    
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "Running pre-commit checks..."

# Dart コード解析
echo "Running flutter analyze..."
flutter analyze
if [[ $? -ne 0 ]]; then
    echo "❌ Flutter analyze failed. Please fix the issues before committing."
    exit 1
fi

# コードフォーマット確認
echo "Checking code formatting..."
flutter format --dry-run --set-exit-if-changed lib/ test/
if [[ $? -ne 0 ]]; then
    echo "❌ Code is not properly formatted. Run 'flutter format .' to fix."
    exit 1
fi

# テスト実行
echo "Running tests..."
flutter test
if [[ $? -ne 0 ]]; then
    echo "❌ Tests failed. Please fix the failing tests before committing."
    exit 1
fi

echo "✅ All pre-commit checks passed!"
EOF
    
    chmod +x .git/hooks/pre-commit
    log_success "Git pre-commit フックを設定しました"
}

# メイン実行
main() {
    check_flutter
    check_tools
    install_dependencies
    setup_env_files
    setup_git_hooks
    run_flutter_doctor
    setup_vscode_extensions
    run_tests
    
    echo ""
    echo -e "${GREEN}=================================================="
    echo "  🎉 開発環境のセットアップが完了しました！"
    echo "=================================================="
    echo -e "${NC}"
    echo ""
    echo "次のステップ:"
    echo "1. .env ファイルに適切な API キーを設定"
    echo "2. flutter run でアプリを起動"
    echo "3. CONTRIBUTING.md を読んで開発フローを確認"
    echo "4. GitHub Issues で good first issue を探してみる"
    echo ""
    echo "質問がある場合は GitHub Issues で質問してください！"
    echo "Happy coding! 🚀"
}

# スクリプト実行
main
