#!/bin/bash

# Flutter Test Optimization Script
# ブランチとファイル変更に基づいてテスト戦略を決定

set -e

# カラー出力の設定
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログ関数
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 引数の解析
BRANCH_NAME=${1:-$(git rev-parse --abbrev-ref HEAD)}
BASE_BRANCH=${2:-"main"}
TEST_MODE=${3:-"auto"}

log_info "テスト最適化スクリプトを開始"
log_info "ブランチ: $BRANCH_NAME"
log_info "ベースブランチ: $BASE_BRANCH"

# 変更されたファイルを検出
get_changed_files() {
    if git rev-parse --verify HEAD^ >/dev/null 2>&1; then
        git diff --name-only HEAD^ HEAD
    else
        # 初回コミットの場合
        git ls-files | head -10  # サンプルとして最初の10ファイルを返す
    fi
}

# 変更されたディレクトリを分析
analyze_changes() {
    local changed_files=$(get_changed_files)
    
    # 各カテゴリの変更を確認
    models_changed=false
    providers_changed=false
    services_changed=false
    repositories_changed=false
    views_changed=false
    widgets_changed=false
    utils_changed=false
    config_changed=false
    
    echo "$changed_files" | while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            if [[ $file == lib/models/* ]]; then
                models_changed=true
            elif [[ $file == lib/providers/* ]]; then
                providers_changed=true
            elif [[ $file == lib/services/* ]]; then
                services_changed=true
            elif [[ $file == lib/repositories/* ]]; then
                repositories_changed=true
            elif [[ $file == lib/views/* ]]; then
                views_changed=true
            elif [[ $file == lib/widgets/* ]]; then
                widgets_changed=true
            elif [[ $file == lib/utils/* ]]; then
                utils_changed=true
            elif [[ $file == pubspec.yaml ]] || [[ $file == pubspec.lock ]]; then
                config_changed=true
            fi
        fi
    done
    
    log_info "変更検出結果:"
    if [[ $models_changed == true ]]; then log_info "  📊 モデル: 変更あり"; fi
    if [[ $providers_changed == true ]]; then log_info "  🔄 プロバイダー: 変更あり"; fi
    if [[ $services_changed == true ]]; then log_info "  ⚙️  サービス: 変更あり"; fi
    if [[ $repositories_changed == true ]]; then log_info "  🗄️  リポジトリ: 変更あり"; fi
    if [[ $views_changed == true ]]; then log_info "  👁️  ビュー: 変更あり"; fi
    if [[ $widgets_changed == true ]]; then log_info "  🧩 ウィジェット: 変更あり"; fi
    if [[ $utils_changed == true ]]; then log_info "  🔧 ユーティリティ: 変更あり"; fi
    if [[ $config_changed == true ]]; then log_info "  ⚙️  設定ファイル: 変更あり"; fi
}

# テスト戦略を決定
determine_test_strategy() {
    if [[ $TEST_MODE != "auto" ]]; then
        echo $TEST_MODE
        return
    fi
    
    case $BRANCH_NAME in
        main)
            echo "full"
            ;;
        development)
            echo "comprehensive"
            ;;
        feature/*)
            echo "targeted"
            ;;
        hotfix/*)
            echo "critical"
            ;;
        bug/*)
            echo "targeted"
            ;;
        *)
            echo "standard"
            ;;
    esac
}

# テストを実行
run_tests() {
    local strategy=$1
    
    case $strategy in
        "critical")
            log_info "クリティカルテストモードで実行"
            run_critical_tests
            ;;
        "targeted")
            log_info "ターゲットテストモードで実行"
            run_targeted_tests
            ;;
        "standard")
            log_info "標準テストモードで実行"
            run_standard_tests
            ;;
        "comprehensive")
            log_info "包括的テストモードで実行"
            run_comprehensive_tests
            ;;
        "full")
            log_info "フルテストモードで実行"
            run_full_tests
            ;;
        *)
            log_error "不明なテスト戦略: $strategy"
            exit 1
            ;;
    esac
}

# クリティカルテスト（最小限）
run_critical_tests() {
    log_info "🚨 クリティカルテストを実行中..."
    flutter test test/models/ test/utils/ --reporter=compact
    log_success "クリティカルテスト完了"
}

# ターゲットテスト（変更された部分のみ）
run_targeted_tests() {
    log_info "🎯 ターゲットテストを実行中..."
    
    local test_dirs=()
    
    [[ $models_changed == true ]] && test_dirs+=("test/models/")
    [[ $providers_changed == true ]] && test_dirs+=("test/providers/")
    [[ $services_changed == true ]] && test_dirs+=("test/services/")
    [[ $repositories_changed == true ]] && test_dirs+=("test/repositories/")
    [[ $views_changed == true ]] && test_dirs+=("test/views/")
    [[ $widgets_changed == true ]] && test_dirs+=("test/widgets/")
    [[ $utils_changed == true ]] && test_dirs+=("test/utils/")
    
    if [[ ${#test_dirs[@]} -eq 0 ]]; then
        log_warning "変更が検出されませんでした。クリティカルテストを実行します。"
        run_critical_tests
        return
    fi
    
    for dir in "${test_dirs[@]}"; do
        if [[ -d $dir ]]; then
            log_info "📂 $dir のテストを実行中..."
            flutter test "$dir" --reporter=expanded
        else
            log_warning "$dir が存在しません"
        fi
    done
    
    log_success "ターゲットテスト完了"
}

# 標準テスト
run_standard_tests() {
    log_info "📋 標準テストを実行中..."
    flutter test test/models/ test/services/ test/providers/ --reporter=expanded
    log_success "標準テスト完了"
}

# 包括的テスト
run_comprehensive_tests() {
    log_info "🔍 包括的テストを実行中..."
    flutter test --exclude-tags=widget --coverage --reporter=expanded
    
    if [[ -f coverage/lcov.info ]]; then
        log_info "📊 カバレッジレポート処理中..."
        # 自動生成ファイルを除外
        sed -i.bak '/\.g\.dart/d' coverage/lcov.info
        sed -i.bak '/\.freezed\.dart/d' coverage/lcov.info
        rm -f coverage/lcov.info.bak
        
        # カバレッジ統計を表示
        show_coverage_stats
    fi
    
    log_success "包括的テスト完了"
}

# フルテスト
run_full_tests() {
    log_info "🎯 フルテストスイートを実行中..."
    flutter test --coverage --reporter=expanded
    
    if [[ -f coverage/lcov.info ]]; then
        log_info "📊 カバレッジレポート処理中..."
        # 自動生成ファイルを除外
        sed -i.bak '/\.g\.dart/d' coverage/lcov.info
        sed -i.bak '/\.freezed\.dart/d' coverage/lcov.info
        rm -f coverage/lcov.info.bak
        
        # カバレッジ統計を表示
        show_coverage_stats
        
        # カバレッジ分析
        analyze_coverage
    fi
    
    log_success "フルテスト完了"
}

# カバレッジ統計を表示
show_coverage_stats() {
    if command -v python3 &> /dev/null; then
        python3 -c "
import re
import sys

try:
    with open('coverage/lcov.info', 'r') as f:
        content = f.read()
    
    # Extract coverage data
    pattern = r'SF:(.*?)\nLF:(\d+)\nLH:(\d+)'
    matches = re.findall(pattern, content, re.DOTALL)
    
    total_lines = sum(int(lf) for _, lf, _ in matches)
    total_hit = sum(int(lh) for _, _, lh in matches)
    
    if total_lines > 0:
        coverage_percent = (total_hit / total_lines) * 100
        print(f'📈 総合カバレッジ: {total_hit}/{total_lines} ({coverage_percent:.1f}%)')
        
        # カバレッジが低いファイルを表示
        low_coverage = []
        for file_path, lf, lh in matches:
            lf, lh = int(lf), int(lh)
            if lf > 0:
                file_coverage = (lh / lf) * 100
                if file_coverage < 80:
                    low_coverage.append((file_path, file_coverage, lf - lh))
        
        if low_coverage:
            print('⚠️  カバレッジが80%未満のファイル:')
            for file_path, coverage, uncovered in sorted(low_coverage, key=lambda x: x[1]):
                print(f'  {file_path}: {coverage:.1f}% ({uncovered} uncovered lines)')
    else:
        print('⚠️  カバレッジデータが見つかりませんでした')
        
except Exception as e:
    print(f'❌ カバレッジ分析エラー: {e}')
    sys.exit(1)
"
    else
        log_warning "Python3が利用できないため、カバレッジ統計をスキップします"
    fi
}

# カバレッジ分析（詳細）
analyze_coverage() {
    log_info "🔍 詳細カバレッジ分析を実行中..."
    
    if command -v python3 &> /dev/null; then
        python3 -c "
import re
import sys

try:
    with open('coverage/lcov.info', 'r') as f:
        content = f.read()
    
    # Extract uncovered lines
    current_file = ''
    uncovered_lines = {}
    
    for line in content.split('\n'):
        if line.startswith('SF:'):
            current_file = line[3:]
        elif line.startswith('DA:') and line.endswith(',0'):
            line_num = line.split(',')[0][3:]
            if current_file not in uncovered_lines:
                uncovered_lines[current_file] = []
            uncovered_lines[current_file].append(line_num)
    
    if uncovered_lines:
        print('📋 未カバーライン詳細:')
        for file_path, lines in uncovered_lines.items():
            if len(lines) <= 10:  # 10行以下の場合のみ表示
                print(f'  {file_path}: lines {", ".join(lines)}')
            else:
                print(f'  {file_path}: {len(lines)} uncovered lines')
                
except Exception as e:
    print(f'❌ 詳細分析エラー: {e}')
"
    fi
}

# メイン実行
main() {
    log_info "=== Flutter テスト最適化スクリプト ==="
    
    # 前提条件チェック
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter が見つかりません"
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        log_error "Git が見つかりません"
        exit 1
    fi
    
    # 依存関係の取得
    log_info "📦 依存関係を取得中..."
    flutter pub get
    
    # 変更を分析
    analyze_changes
    
    # テスト戦略を決定
    local strategy=$(determine_test_strategy)
    log_info "📋 選択されたテスト戦略: $strategy"
    
    # テストを実行
    run_tests "$strategy"
    
    log_success "=== テスト実行完了 ==="
}

# スクリプトが直接実行された場合のみmainを実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
