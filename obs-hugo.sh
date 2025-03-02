#!/bin/bash
set -e

CONTENT_DIR="content"

# content ディレクトリを作成（なければ）
mkdir -p "$CONTENT_DIR"

# すべての .md ファイルを処理
for file in obsidian_notes/*.md; do
    filename=$(basename -- "$file")
    output_file="$CONTENT_DIR/$filename"

    # `[[PageName]]` → `[PageName](/page-name/)` に変換
    sed -E 's/\[\[([^\]]+)\]\]/[\1](\/\L\1\/)/g' "$file" > "$output_file"

    # `![[image.png]]` → `![image.png](image.png)` に変換
    sed -i -E 's/!\[\[([^\]]+)\]\]/![\1](\1)/g' "$output_file"

    # フロントマターがない場合に追加
    if ! grep -q '^\+\+\+' "$output_file"; then
        title=$(basename "$filename" .md)
        date=$(date +"%Y-%m-%dT%H:%M:%S")
        sed -i "1i +++\ntitle = \"$title\"\ndate = \"$date\"\ntags = []\n+++\n" "$output_file"
    fi
done
