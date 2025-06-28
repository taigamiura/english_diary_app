#!/bin/bash

# Flutterカバレッジレポート生成スクリプト

echo "Generating Flutter coverage HTML report..."

# カバレッジディレクトリが存在しない場合は作成
mkdir -p coverage

# LCOVファイルが存在するかチェック
if [ ! -f "coverage/lcov.info" ]; then
    echo "Error: coverage/lcov.info not found. Run 'flutter test --coverage' first."
    exit 1
fi

# HTMLレポートを生成
echo "Generating HTML report from coverage/lcov.info..."
genhtml coverage/lcov.info -o coverage/html

# レポートのサマリーを表示
echo ""
echo "Coverage Report Generated!"
echo "Open coverage/html/index.html in your browser to view the report."
echo ""

# カバレッジサマリーを表示
if command -v lcov >/dev/null 2>&1; then
    echo "Coverage Summary:"
    lcov --summary coverage/lcov.info
fi