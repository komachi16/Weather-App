#!/bin/bash

color_red () {
  local ESC=$(printf '\033')
  printf "$ESC[31m$1$ESC[m\n"
}

color_green () {
  local ESC=$(printf '\033')
  printf "$ESC[32m$1$ESC[m\n"
}

# プロジェクトのルートディレクトリからスクリプトが実行されることを想定
# 'hooks' フォルダが存在するか確認
if [ -d "./hooks" ]; then
    # '.git/hooks' ディレクトリが存在するか確認し、存在しなければ作成
    if [ ! -d "./.git/hooks" ]; then
        mkdir -p ./.git/hooks || {
            echo $(color_red "⛔️ Error: Failed to create .git/hooks directory.")
            exit 1
        }
        echo $(color_green "🟢 Success: Created .git/hooks directory.")
    fi

    # 'hooks' フォルダの内容を '.git/hooks' にコピー
    for hook in ./hooks/*; do
        # 各フックファイルをコピー
        if [ ! -f ./.git/hooks/$(basename "$hook") ]; then
            cp "$hook" ./.git/hooks/ || {
                echo $(color_red "⛔️ Error: Failed to copy hook: $hook")
                exit 1
            }
            # コピーしたスクリプトに実行権限を与える
            chmod +x ./.git/hooks/$(basename "$hook") || {
                echo $(color_red "⛔️ Error: Failed to set executable permissions for $(basename "$hook").")
                exit 1
            }
            echo $(color_green "🟢 Success: Created hook $(basename "$hook") in .git/hooks.")
        else
            cp "$hook" ./.git/hooks/ || {
                echo $(color_red "⛔️ Error: Failed to copy hook: $hook")
                exit 1
            }
            chmod +x ./.git/hooks/$(basename "$hook") || {
                echo $(color_red "⛔️ Error: Failed to set executable permissions for $(basename "$hook").")
                exit 1
            }
            echo $(color_green "🔄 Updated hook $(basename "$hook") in .git/hooks.")
        fi
    done
else
    echo $(color_red "⛔️ Error: 'hooks' directory does not exist.")
fi
