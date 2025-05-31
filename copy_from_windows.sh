#!/bin/bash

# スクリプトがエラーで停止するように設定
set -e

# --- 設定項目 ---
# Windows側のZotero storageディレクトリのパス (WSLから見たパス)
ZOTERO_STORAGE_PATH="/mnt/c/Users/haruk/Zotero/storage"

# Ubuntu側のコピー先親ディレクトリのパス
UBUNTU_DEST_PARENT_DIR="/home/hawk/desktop/lab/papers/src"

# --- スクリプト本体 ---

echo "Zotero PDF同期スクリプトを開始します。"
echo "Windows Zoteroストレージ: $ZOTERO_STORAGE_PATH"
echo "Ubuntu コピー先         : $UBUNTU_DEST_PARENT_DIR"
echo "---"

# コピー先の親ディレクトリが存在しない場合は作成
mkdir -p "$UBUNTU_DEST_PARENT_DIR"

# Zotero storageディレクトリ内の全ての.pdfファイルを検索
find "$ZOTERO_STORAGE_PATH" -type f -iname "*.pdf" | while IFS= read -r pdf_full_path; do
  original_pdf_filename=$(basename "$pdf_full_path")
  echo "処理中のファイル: $original_pdf_filename"

  cleaned_title_with_ext=$(echo "$original_pdf_filename" | sed -E 's/.* - [0-9]{4} - //')

  if [ "$cleaned_title_with_ext" == "$original_pdf_filename" ]; then
    echo "  WARN: '${original_pdf_filename}' から著者・年情報を除去できませんでした。元のファイル名をタイトルとして使用します。"
  else
    echo "  抽出されたタイトル (拡張子付き): $cleaned_title_with_ext"
  fi

  foldername_base="${cleaned_title_with_ext%.pdf}"
  foldername_final="${foldername_base// /_}"

  destination_folder_path="$UBUNTU_DEST_PARENT_DIR/$foldername_final"
  
  # コピー先での最終的なファイルパス
  target_pdf_final_path="$destination_folder_path/$cleaned_title_with_ext"

  echo "  対象フォルダパス: $destination_folder_path"
  echo "  対象ファイル名 (コピー後): $cleaned_title_with_ext"

  # コピー先に既にファイルが存在するか確認
  if [ -f "$target_pdf_final_path" ]; then
    echo "  スキップ: '$target_pdf_final_path' は既に存在します。"
  else
    # フォルダを作成 (-p オプションで親ディレクトリも必要なら作成し、存在していてもエラーにしない)
    # この時点で destination_folder_path が実際に作成されるのは、ファイルがコピーされる場合のみ
    echo "  フォルダ作成/確認: '$destination_folder_path'"
    mkdir -p "$destination_folder_path"

    # PDFファイルを新しいフォルダにコピー
    echo "  コピー実行: '$original_pdf_filename' を '$target_pdf_final_path' へ"
    cp "$pdf_full_path" "$target_pdf_final_path"
    echo "  コピー完了。"
  fi
  echo "---"
done

echo "スクリプトの処理が完了しました。"