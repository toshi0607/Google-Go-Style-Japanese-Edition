- [Google-Go-Style-Japanese-Edition](#google-go-style-japanese-edition)
  - [概要](#概要)
  - [ドキュメント](#ドキュメント)
  - [定義](#定義)
  - [その他の参考資料](#その他の参考資料)

# Google-Go-Style-Japanese-Edition

Googleの[Go Style](https://google.github.io/styleguide/go/)の日本語版です。

## 概要

Goスタイルガイドとそれに付随する文書は、読みやすく慣用的なGoを書くための現在の最善の方法を体系化したものです。スタイルガイドの遵守は絶対的なものではなく、これらの文書がすべてを網羅しているわけではありません。私たちの意図は、読みやすいGoを書くための推測を最小限にし、Goの初心者がよくあるミスを避けられるようにすることです。また、スタイルガイドは、GoogleでGoのコードをレビューする人が与えるスタイルの手引きを統一する役割も果たします。


| ドキュメント | リンク | 主な対象者 | 規範的 | 標準的 |
| :---: | :---: | :---: | :---: | :---: |
| スタイルガイド | [https://google.github.io/styleguide/go/guide](https://google.github.io/styleguide/go/guide) | 全員 | Yes | Yes |
| スタイル決定事項 | [https://google.github.io/styleguide/go/decisions](https://google.github.io/styleguide/go/decisions) | 可読性メンター | Yes | No |
| ベストプラクティス | [https://google.github.io/styleguide/go/best-practices](https://google.github.io/styleguide/go/best-practices) | 興味のある方 | No | No |

## ドキュメント

1. [スタイルガイド](https://google.github.io/styleguide/go/guide)は、Google でのGoのスタイルの基礎を概説しています。この文書は決定的なものであり、スタイル決定事項とベストプラクティスの推奨事項の基礎として使用されます。
2. [スタイル決定事項](https://google.github.io/styleguide/go/decisions)は、特定のスタイル ポイントに関する決定事項を要約し、必要に応じて決定の理由を説明する、より冗長な文書です。

これらの決定事項は、新しいデータ、新しい言語機能、新しいライブラリ、新しいパターンに基づいて変更されることがありますが、Googleの個々のGoプログラマがこのドキュメント即してプログラムを常に更新することは期待されていません。

3. [ベストプラクティス](https://google.github.io/styleguide/go/best-practices)は、一般的な問題を解決し、読みやすく、コードのメンテナンスの必要性に強い、時間をかけて進化してきたパターンのいくつかを文書化したものです。

これらのベストプラクティスは正規のものではありませんが、GoogleのGoプログラマーは、コードベースの統一と一貫性を保つために、可能な限りこれらを使用するよう推奨されています。

これらの文書は、以下を意図しています。

- 代替スタイルを評価するための一連の原則に合意する
- Goのスタイルに関する定型的な事柄をドキュメント化する
- Goイディオムの標準的な例を文書化して提供する
- 様々なスタイルの決定事項の長所と短所を文書化する
- Goの可読性レビューにおける驚きを最小限に抑える
- 可読性メンターが一貫した用語とガイダンスを使用できるようにする

これらの文書は、以下を意図していません。

- 可読性レビューで与えられるコメントの完全なリストであること
- 誰もが常に覚え、従うことが期待されるルールをすべて列挙すること
- 言語の特徴やスタイルの使用において、適切な判断に代わるものであること
- スタイルの違いをなくすための大規模な変更を正当化すること

Goプログラマーによって、またあるチームのコードベースによって、常に違いがあります。しかし、私たちのコードベースができるだけ一貫していることが、GoogleとAlphabetの最大の利益となります（一貫性については[ガイド](https://google.github.io/styleguide/go/guide#consistency)をご覧ください）。そのためにあなたが適切と思うように、自由にスタイルを改善してください。しかし、スタイルガイドの違反を見つけるたびに細かく指摘する必要はありません。特に、これらの文書は時間の経過とともに変化する可能性がありますが、それは既存のコードベースを余計に混乱させる理由にはなりません。新しいコードは最新のベストプラクティスを用いて書き、そのうちに近くの問題に対処すれば十分なのです。

スタイルの問題は本質的に個人的なものであり、常にトレードオフが存在することを認識することが重要です。これらの文書のガイダンスの多くは主観的なものですが、`gofmt`と同じように、これらのドキュメントが提供する統一性には大きな価値があります。Googleのプログラマは、たとえ同意できない場合でもスタイルガイドに従うことが推奨されます。

## 定義

スタイルドキュメント全体で使用される以下の単語を次のように定義しています。

- 規範的： 定型的で永続的なルールを確立します。

これらのドキュメントの中で「規範的」という言葉は、すべてのコード（古いものも新しいものも）が従うべき標準とみなされるもので、時間の経過とともに大きく変わることがないと予想されるものを表現するために使われています。標準的なドキュメントに含まれる原則は、コードの記述者やレビュアーが同様に理解できるものでなければならないため、標準的なドキュメントに含まれるものはすべて高い水準を満たすものでなければなりません。そのため、規範的なドキュメントは一般に規範的でないドキュメントよりも短く、スタイルの要素も少なくなっています。

https://google.github.io/styleguide/go#canonical

- 標準的: 一貫性を持たせることを意図しています。

これらのドキュメントでは、提案、用語、正当性の一貫性を保つために、Goコードレビュアーが使用するスタイルの合意された要素であるものを「標準的」と表現しています。これらの要素は時間の経過とともに変更される可能性があり、これらのドキュメントにはそのような変更が反映されるため、レビュアーは一貫性を保ち、最新の状態を維持することができます。Goコードの記述者は標準となるドキュメントに精通している必要はありませんが、このドキュメントは可読性レビューでレビュアーが参照することがよくあります。

https://google.github.io/styleguide/go#normative

- 慣用的: 一般的で身近なものです。

これらのドキュメントでは、「慣用的」という言葉は、Goのコードによく見られるもので、認識しやすい馴染みのあるパターンになったものを指すのに使われています。一般に、慣用的なパターンは、文脈上同じ目的を果たすのであれば、慣用的でないパターンよりも優先されるべきです。

https://google.github.io/styleguide/go#idiomatic

## その他の参考資料

このガイドでは、読者が[Effective Go](https://go.dev/doc/effective_go)に精通していることを前提としています。

以下は、Goのスタイルについて独学したい人や、レビューでリンク可能なコンテキストをさらに提供したいレビュアーのための追加リソースです。Goの可読性プロセスの参加者がこれらのリソースに精通していることは期待されていませんが、可読性のレビューでコンテキストとして使用される可能性があります。

外部参考資料

- [Go Language Specification](https://go.dev/ref/spec)
- [Go FAQ (日本語版)](https://github.com/toshi0607/Go-FAQ-Japanese-Edition)
- [Go Memory Model](https://go.dev/ref/mem)
- [Go Data Structures](https://research.swtch.com/godata)
- [Go Interfaces](https://research.swtch.com/interfaces)
- [Go Proverbs](https://go-proverbs.github.io/)
- Go tips - ご期待ください

Testing-on-the-Toiletの関連記事
- [TotT: Identifier Naming](https://testing.googleblog.com/2017/10/code-health-identifiernamingpostforworl.html)
- [TotT: Testing State vs. Testing Interactions](https://testing.googleblog.com/2013/03/testing-on-toilet-testing-state-vs.html)
- [TotT: Effective Testing](https://testing.googleblog.com/2014/05/testing-on-toilet-effective-testing.html)
- [TotT: Risk-driven Testing](https://testing.googleblog.com/2014/05/testing-on-toilet-risk-driven-testing.html)
- [TotT: Change-detector Tests Considered Harmful](https://testing.googleblog.com/2015/01/testing-on-toilet-change-detector-tests.html)

その他の外部著作物
- [Go and Dogma](https://research.swtch.com/dogma)
- [Less is exponentially more](https://commandcenter.blogspot.com/2012/06/less-is-exponentially-more.html)
- [Esmerelda’s Imagination](https://commandcenter.blogspot.com/2011/12/esmereldas-imagination.html)
- [Regular expressions for parsing](https://commandcenter.blogspot.com/2011/08/regular-expressions-in-lexing-and.html)
- [Gofmt’s style is no one’s favorite, yet Gofmt is everyone’s favorite (YouTube)](https://www.youtube.com/watch?v=PAAkCSZUG1c&t=8m43s)
