#!/bin/bash
set -e

echo "=========================================="
echo "ZMK Development Environment Setup"
echo "=========================================="

ZMK_WORKSPACE="/workspaces/zmk"
ZMK_CONFIG="/workspaces/zmk-config"

# Check if workspace is already initialized
if [ ! -f "$ZMK_WORKSPACE/.west/config" ]; then
    echo ""
    echo "📦 Initializing ZMK workspace..."
    cd "$ZMK_WORKSPACE"
    
    # Initialize west with ZMK
    west init -m https://github.com/zmkfirmware/zmk.git .
    
    echo ""
    echo "📥 Updating west modules (this may take a few minutes)..."
    west update
    
    echo ""
    echo "🔧 Installing Zephyr Python dependencies..."
    pip3 install --user -r zephyr/scripts/requirements-base.txt
    pip3 install --user -r zephyr/scripts/requirements-extras.txt
    
    echo ""
    echo "✅ ZMK workspace initialized successfully!"
else
    echo "✅ ZMK workspace already initialized"
    cd "$ZMK_WORKSPACE"
    
    echo "📥 Updating west modules..."
    west update
fi

# Export Zephyr base for builds
echo ""
echo "🔧 Setting up environment..."
cat >> ~/.bashrc << 'EOF'

# ZMK Environment
export ZEPHYR_BASE=/workspaces/zmk/zephyr
export ZMK_CONFIG=/workspaces/zmk-config/config

# ZMK Build Aliases
alias zmk-left='cd /workspaces/zmk && west build -d build/left -b eyelash_nano -S studio-rpc-usb-uart -- -DSHIELD=offsetkey_left -DZMK_CONFIG=/workspaces/zmk-config/config -DCONFIG_ZMK_STUDIO=y -DCONFIG_ZMK_STUDIO_LOCKING=n'
alias zmk-right='cd /workspaces/zmk && west build -d build/right -b eyelash_nano -- -DSHIELD=offsetkey_right -DZMK_CONFIG=/workspaces/zmk-config/config'
alias zmk-reset='cd /workspaces/zmk && west build -d build/reset -b eyelash_nano -- -DSHIELD=settings_reset -DZMK_CONFIG=/workspaces/zmk-config/config'
alias zmk-clean='rm -rf /workspaces/zmk/build'
EOF

echo ""
echo "=========================================="
echo "✨ Setup Complete!"
echo "=========================================="
echo ""
echo "Build commands (open a new terminal or run 'source ~/.bashrc'):"
echo ""
echo "  zmk-left   - Build left side with ZMK Studio"
echo "  zmk-right  - Build right side"
echo "  zmk-reset  - Build settings reset firmware"
echo "  zmk-clean  - Clean all builds"
echo ""
echo "Firmware files will be in:"
echo "  /workspaces/zmk/build/left/zephyr/zmk.uf2"
echo "  /workspaces/zmk/build/right/zephyr/zmk.uf2"
echo ""
echo "These files are also accessible on your Mac at:"
echo "  ~/projects/zmk/zmk-workspace/build/left/zephyr/zmk.uf2"
echo "  ~/projects/zmk/zmk-workspace/build/right/zephyr/zmk.uf2"
echo ""

