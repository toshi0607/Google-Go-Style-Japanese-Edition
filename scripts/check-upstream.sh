#!/usr/bin/env bash
# 上流ドキュメントの更新検知。upstream.json の各 target について、
# 上流の最新コミットが baseline_sha と異なれば issue を作成する。
# DRY_RUN=1 のときは issue を作成せず内容だけ表示する。
set -euo pipefail

count=$(jq '.targets | length' upstream.json)
for i in $(seq 0 $((count - 1))); do
  name=$(jq -r ".targets[$i].name" upstream.json)
  repo=$(jq -r ".targets[$i].upstream_repo" upstream.json)
  path=$(jq -r ".targets[$i].upstream_path" upstream.json)
  baseline=$(jq -r ".targets[$i].baseline_sha" upstream.json)
  translation=$(jq -r ".targets[$i].translation" upstream.json)

  latest=$(gh api "repos/$repo/commits?path=$path&per_page=1" --jq '.[0].sha')
  if [ -z "$latest" ] || [ "$latest" = "null" ]; then
    echo "::warning::$repo/$path の最新コミットを取得できませんでした"
    continue
  fi

  if [ "$latest" = "$baseline" ]; then
    echo "$name: 追従済み($baseline)"
    continue
  fi

  title="上流更新の追従: $name"
  existing=$(gh issue list --state open --json title --jq "[.[] | select(.title == \"$title\")] | length")
  if [ "$existing" != "0" ]; then
    echo "$name: 同タイトルの open issue が既にあるためスキップ"
    continue
  fi

  compare="https://github.com/$repo/compare/$baseline...$latest"
  body="上流 \`$repo\` の \`$path\` に、翻訳(\`$translation\`)へ未反映のコミットがあります。

- 差分: $compare
- 追従済み SHA: \`$baseline\`
- 上流最新 SHA: \`$latest\`

翻訳を更新したら、\`upstream.json\` の \`baseline_sha\` を \`$latest\` に更新し、この issue を閉じてください。
セクション単位の部分的な追従でも歓迎です。

*この issue は check-upstream ワークフローが自動作成しました。*"

  if [ "${DRY_RUN:-}" = "1" ]; then
    echo "DRY-RUN: issue 作成対象 -> $title($compare)"
    continue
  fi

  gh issue create --title "$title" --body "$body"
  echo "$name: issue を作成しました"
done
