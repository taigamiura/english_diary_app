#!/bin/bash

# KIWI Test Runner
# This script runs all tests for the KIWI

echo "🧪 KIWI - Test Suite Runner"
echo "========================================"

# Function to print colored output
print_status() {
    case $1 in
        "SUCCESS") echo -e "\033[32m✅ $2\033[0m" ;;
        "ERROR") echo -e "\033[31m❌ $2\033[0m" ;;
        "INFO") echo -e "\033[34mℹ️  $2\033[0m" ;;
        "WARNING") echo -e "\033[33m⚠️  $2\033[0m" ;;
    esac
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_status "ERROR" "Flutter not found. Please install Flutter first."
    exit 1
fi

print_status "INFO" "Flutter version:"
flutter --version

# Clean and get dependencies
print_status "INFO" "Cleaning and getting dependencies..."
flutter clean
flutter pub get

# Run code generation if needed
if [ -f "pubspec.yaml" ] && grep -q "build_runner" pubspec.yaml; then
    print_status "INFO" "Running code generation..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
fi

echo ""
print_status "INFO" "Running test suites..."
echo ""

# Function to run specific test group
run_test_group() {
    local group_name="$1"
    local test_path="$2"
    
    echo "📁 Testing: $group_name"
    echo "-----------------------------------"
    
    if [ -d "$test_path" ] && [ "$(ls -A $test_path 2>/dev/null)" ]; then
        if flutter test "$test_path" --reporter=expanded; then
            print_status "SUCCESS" "$group_name tests passed"
        else
            print_status "ERROR" "$group_name tests failed"
            return 1
        fi
    else
        print_status "WARNING" "No tests found in $test_path"
    fi
    echo ""
}

# Track overall test result
overall_result=0

# Run test groups
run_test_group "Models" "test/models/" || overall_result=1
run_test_group "Utilities" "test/utils/" || overall_result=1
run_test_group "Providers" "test/providers/" || overall_result=1
run_test_group "Widgets" "test/widgets/" || overall_result=1

# Run all tests together for integration
echo "🔄 Running complete test suite..."
echo "-----------------------------------"
if flutter test --reporter=expanded; then
    print_status "SUCCESS" "All tests completed successfully"
else
    print_status "ERROR" "Some tests failed"
    overall_result=1
fi

# Generate test coverage if available
echo ""
print_status "INFO" "Generating test coverage report..."
if flutter test --coverage; then
    if command -v genhtml &> /dev/null; then
        genhtml coverage/lcov.info -o coverage/html
        print_status "SUCCESS" "Coverage report generated at coverage/html/index.html"
    else
        print_status "WARNING" "genhtml not found. Install lcov to generate HTML coverage report."
    fi
else
    print_status "WARNING" "Coverage generation failed or not available"
fi

# Final result
echo ""
echo "========================================"
if [ $overall_result -eq 0 ]; then
    print_status "SUCCESS" "🎉 All tests passed successfully!"
    echo ""
    print_status "INFO" "Test Summary:"
    echo "  • Models: ✅"
    echo "  • Utilities: ✅"
    echo "  • Providers: ✅"
    echo "  • Widgets: ✅"
else
    print_status "ERROR" "❌ Some tests failed. Please check the output above."
    exit 1
fi

echo ""
print_status "INFO" "Test execution completed."
