#!/bin/bash
set -e  # エラー時に終了

# ファイル名（拡張子なし）
MAINFILE="main"

echo "✅ Step 1: Pythonスクリプトを実行中..."
python3 convert.py

echo "✅ Step 2: LuaLaTeX 第1回目コンパイル中..."
lualatex "$MAINFILE.tex"

echo "✅ Step 3: biber 実行中..."
biber "$MAINFILE"

echo "✅ Step 4: LuaLaTeX 第2回目コンパイル中..."
lualatex "$MAINFILE.tex"

echo "✅ Step 5: LuaLaTeX 第3回目コンパイル中..."
lualatex "$MAINFILE.tex"

echo "🎉 ビルド完了: $MAINFILE.pdf が生成されました。"
