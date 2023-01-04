- [Goスタイル決定事項](#goスタイル決定事項)
  - [概要](#概要)
  - [命名](#命名)
    - [アンダースコア](#アンダースコア)
    - [パッケージ名](#パッケージ名)
    - [レシーバ名](#レシーバ名)
    - [定数名](#定数名)
    - [頭字語](#頭字語)
    - [ゲッター](#ゲッター)
    - [変数名](#変数名)
      - [一文字の変数名](#一文字の変数名)
    - [繰り返し](#繰り返し)
      - [パッケージ名とエクスポートされたシンボル名](#パッケージ名とエクスポートされたシンボル名)
      - [変数名と型](#変数名と型)
      - [外部コンテキストとローカル名](#外部コンテキストとローカル名)
  - [コメント](#コメント)
    - [コメント行の長さ](#コメント行の長さ)
    - [ドキュメントコメント](#ドキュメントコメント)
    - [コメント文](#コメント文)
    - [例](#例)
    - [名前付き結果パラメータ](#名前付き結果パラメータ)
    - [パッケージコメント](#パッケージコメント)
  - [インポート](#インポート)
    - [インポート名変更](#インポート名変更)
    - [インポートグループ分け](#インポートグループ分け)
    - [「ブランク」のインポート（`import _`）](#ブランクのインポートimport-_)
    - [「ドット」のインポート（`import .`）](#ドットのインポートimport-)
  - [エラー](#エラー)
    - [エラーを返す](#エラーを返す)
    - [エラー文字列](#エラー文字列)
    - [エラー処理](#エラー処理)
    - [インバンドエラー](#インバンドエラー)
    - [エラーフローのインデント](#エラーフローのインデント)
  - [言語](#言語)
    - [リテラルフォーマット](#リテラルフォーマット)
      - [フィールド名](#フィールド名)
      - [中括弧のマッチング](#中括弧のマッチング)
      - [抱き合わせ中括弧](#抱き合わせ中括弧)
      - [型名の繰り返し](#型名の繰り返し)
      - [ゼロ値フィールド](#ゼロ値フィールド)
      - [簡潔さ](#簡潔さ)
      - [明示](#明示)
    - [Nilスライス](#nilスライス)
    - [インデントの乱れ](#インデントの乱れ)
    - [関数のフォーマット](#関数のフォーマット)
    - [条件とループ](#条件とループ)
    - [コピー](#コピー)
    - [panicさせるな](#panicさせるな)
    - [Must関数](#must関数)
    - [ゴルーチンの寿命](#ゴルーチンの寿命)
    - [インターフェース](#インターフェース)
    - [ジェネリクス](#ジェネリクス)
    - [値渡し](#値渡し)
    - [レシーバの型](#レシーバの型)
    - [`switch`と`break`](#switchとbreak)
    - [同期関数](#同期関数)
    - [型エイリアス](#型エイリアス)
    - [%qの使用](#qの使用)
    - [anyの使用](#anyの使用)
  - [共通ライブラリ](#共通ライブラリ)
    - [フラグ](#フラグ)
    - [ロギング](#ロギング)
    - [コンテキスト](#コンテキスト)
      - [カスタムコンテキスト](#カスタムコンテキスト)
    - [crypto/rand](#cryptorand)
  - [有用なテスト失敗](#有用なテスト失敗)
    - [アサーションライブラリ](#アサーションライブラリ)
    - [関数の識別](#関数の識別)
    - [入力の識別](#入力の識別)
    - [期待する値の前に実際の値](#期待する値の前に実際の値)
    - [構造全体の比較](#構造全体の比較)

# Goスタイル決定事項

https://google.github.io/styleguide/go/decisions

注意: このドキュメントは、Googleでの[Goスタイル](https://google.github.io/styleguide/go/index)の概要を説明する一連のドキュメントの一部です。このドキュメントは規範的なものですが、標準的なものではなく、コアスタイル ガイドに従属するものです。詳しくは、概要をご覧ください。

## 概要

このドキュメントには、Goの可読性メンターが行うアドバイスに対する標準的なガイダンス、説明、例を統一して提供することを目的としたスタイル決定事項が含まれています。

このドキュメントは完全なものではなく、時間の経過とともに拡張されていきます。コアスタイルガイドがここで提供するアドバイスと矛盾する場合はスタイルガイドが優先され、それに応じてこのドキュメントが更新される必要があります。

Go スタイル ドキュメントの完全なセットについては、[概要](./README.md#概要)を参照してください。

以下のセクションは、スタイルの決定事項からガイドの別の部分に移動しました。

- ミックスキャップ: [ガイド#ミックスキャップ](./guide.md#ミックスキャップ)を参照
- フォーマット: [ガイド#フォーマット](./guide.md#フォーマット)を参照
- 行の長さ: [ガイド#行の長さ](./guide.md#行の長さ)を参照

## 命名

命名の全般的なガイダンスについては、[コアスタイルガイド](./guide.md#命名)の命名のセクションを参照してください。次のセクションでは、命名の特定の領域についてさらに詳しく説明しています。

### アンダースコア

Goの名前は一般的にアンダースコアを含めてはいけません。この原則には3つの例外があります。

1. 生成されたコードによってのみインポートされるパッケージ名には、アンダースコアを含めることができます。複数単語のパッケージ名の選び方について、詳しくは[パッケージ名](#パッケージ名)をご覧ください。
2. `test.go`ファイル内の`Test`、`Benchmark`、`Example`関数名にはアンダースコアを含めることができます。
3. オペレーティングシステムや`cgo`と相互運用する低レベルのライブラリは、`syscall`で行われているように識別子を再利用することができます。これは、ほとんどのコードベースでは非常にまれなことだと思われます。

### パッケージ名

Goのパッケージ名は短く、小文字のみを使用する必要があります。複数の単語からなるパッケージ名は、すべて小文字で切れ目がないようにしなければなりません。たとえば、[tabwriter](https://pkg.go.dev/text/tabwriter)というパッケージは`tabWriter`、`TabWriter`、`tab_writer`という名前ではいけません。

よく使われるローカル変数名と[重複](#TBD)しそうなパッケージ名は選ばないようにしてください。たとえば、`count`は一般的に使用される変数名なので、`count`よりも`usercount`の方がよいパッケージ名です。

Goのパッケージ名にはアンダースコアは使わないでください。アンダースコアを含むパッケージをインポートする必要がある場合（通常は生成されたコードやサードパーティのコードから）、インポート時にGoコードで使用するのに適した名前に変更する必要があります。

例外として、生成されたコードによってのみインポートされるパッケージ名にはアンダースコアを含めることができます。具体的な例としては、以下のようなものがあります。

- 統合テストなど、外部のテストパッケージに`_test`サフィックスを使用する
- [パッケージレベルのドキュメントのサンプル](https://go.dev/blog/examples)に`_test`サフィックスを使用する

`util`、`utility`、`common`、`helper`などの情報量の少ないパッケージ名は避けてください。[いわゆる「ユーティリティパッケージ」](#TBD)については、こちらをご覧ください。

インポートされたパッケージの名前が変更された場合 (例: `import foopb "path/to/foo_go_proto"`) 、パッケージのローカル名は上記のルールに従わなければなりません。特定のインポートが複数のファイル、特に同じパッケージや近くのパッケージで改名された場合、一貫性を保つために可能な限り同じローカル名を使用する必要があります。

こちらも参照してください: [パッケージ名に関するGoブログ記事](https://go.dev/blog/package-names)

### レシーバ名

[レシーバ](https://golang.org/ref/spec#Method_declarations)変数名は、以下の通りでなければなりません。

- 短い（通常1文字か2文字の長さ）
- 型自体の略称
- その型に対するすべてのレシーバで一貫

| 長い名前 | より良い名前 |
| :---: | :---: |
| `func (tray Tray)` | `func (t Tray)` |
| `func (info *ResearchInfo)` | `func (ri *ResearchInfo)` |
| `func (this *ReportWriter)` | `func (w *ReportWriter)` |
| `func (self *Scanner)` | `func (s *Scanner)` |

### 定数名

定数名は、Goの他の名前と同様に[ミックスキャップ](./guide.md#ミックスキャップ)を使用しなければなりません。（エクスポートされた定数は大文字で始まり、エクスポートされていない定数は小文字で始まります。）これは、他の言語での慣習を破っている場合でも適用されます。定数名はその値の派生物であってはならず、代わりにその値が示すものを説明しなければなりません。

```go
// Good:
const MaxPacketSize = 512

const (
    ExecuteBit = 1 << iota
    WriteBit
    ReadBit
)
```

ミックスキャップでない定数名や、`k`のプレフィックスを持つ定数は使用しないでください。

```go
// Bad:
const MAX_PACKET_SIZE = 512
const kMaxBufferSize = 1024
const KMaxUsersPergroup = 500
```

定数には、値ではなく役割に基づいて名前を付けます。もし定数がその値とは別に役割を持たないのであれば、定数として定義する必要はありません。

```go
// Bad:
const Twelve = 12

const (
    UserNameColumn = "username"
    GroupColumn    = "group"
)
```

### 頭字語

頭文字や頭字語である名前の単語（例えば、`URL`と`NATO`）は、同じ大文字を使用する必要があります。`URL`は`URL`または`url`（`urlPony`や`URLPony`のように）と表記し、決して`Url`と表記してはいけません。これは、`ID`が「識別子」の略称である場合にも適用され、`appId`の代わりに`appID`と書きます。

- 複数の頭文字を含む名前（例：`XML`と`API`を含む`XMLAPI`）では、ある頭文字内の各文字は同じケースを持つべきですが、名前内の各頭文字は同じケースである必要はありません。
- 小文字の頭文字を含む名前（例：`DDoS`、`iOS`、`gRPC`）では、エクスポートのために最初の文字を変更する必要がない限り、頭文字は通常の散文と同じように表記すべきです。この場合、頭文字全体を同じ大文字にする必要があります（例：`ddos`、`IOS`、`GRPC`)。

| 頭文字 | スコープ | 正 | 誤 |
| :---: | :---: | :---: | :---: |
| XML API | 公開 | `XMLAPI` | `XmlApi`、`XMLApi`、`XmlAPI`、`XMLapi` |
| XML API | 非公開 | `xmlAPI` | `xmlapi`、`xmlApi`|
| iOS | 公開 | `IOS` | `Ios`、`IoS`|
| iOS | 非公開 | `iOS` | `ios`|
| gRPC | 公開 | `GRPC` | `Grpc`|
| gRPC | 非公開 | `gRPC` | `grpc`|
| DDoS | 公開 | `DDoS` | `DDOS`、`Ddos` |
| DDoS | 非公開 | `ddos` | `dDoS`、`dDOS` |

### ゲッター

関数名やメソッド名には、基本概念で「`get`」（例: `HTTP GET`）という単語が使用 されていない限り、 `Get`や`get`というプレフィックスを使用すべきではありません。例えば、 `GetCounts`よりも`Counts`を使用するように、名前を直接名詞で開始することを推奨します。

関数が複雑な計算の実行やリモートコールを伴う場合は、`Get`の代わりに`Compute`や`Fetch`などの別の単語を使用して、関数呼び出しに時間がかかり、ブロックや失敗する可能性があることを読者に明確に伝えることができます。

### 変数名

一般的な経験則では、名前の長さはそのスコープの大きさに比例し、そのスコープ内で使用される回数に反比例するはずです。ファイルスコープで作成された変数は複数の単語を必要とするかもしれませんが、単一の内部ブロックにスコープされた変数は、コードを明確に保ち、余計な情報を避けるために、1単語または1〜2文字で済むかもしれません。

以下は大まかな目安です。これらの数値のガイドラインは、厳密な規則ではありません。文脈、明確さ、簡潔さに基づいて判断してください。

- 小さなスコープとは、1～2個の小さな操作が行われるもので、1～7行です。
- 中程度のスコープとは、8～15行程度の小さな操作を数回、または大きな操作を1回行うものです。
- 大きなスコープとは、1つまたはいくつかの大きな操作が行われるもので、たとえば15～25行のものです。
- 非常に大きなスコープとは、1ページ以上にわたるもの（たとえば25行以上）です。

小さなスコープでは、完全に明確な名前（たとえば、カウンタ用の`c`）でも、大きなスコープでは不十分な場合があり、コード内で読者にその目的を思い出させるために明確化する必要があります。変数の数が多い場合や、似たような値や概念を表す変数がある場合は、スコープが示すよりも長い変数名が必要になることがあります。

また、概念の具体性によって、変数名を簡潔にすることができます。たとえば、使用するデータベースが1つだけだと仮定すると、`db`のような短い変数名は通常非常に小さなスコープに予約されるかもしれませんが、スコープが非常に大きくても、完全に明確なままであるかもしれません。この場合、`database`という単語はスコープの大きさによっては許容されるかもしれませんが、`db`は非常に一般的な単語の短縮形であり、別の解釈はほとんどないため必須ではありません。

ローカル変数の名前は、その値がどこで作られたかよりも、その変数が何を含んでいて現在の文脈でどのように使われているかを反映したものでなければなりません。たとえば、最適なローカル変数の名前が構造体やプロトコルバッファのフィールド名と同じでないことはよくあります。

一般的には

- `count`や`options`のような一語の名前は良い出発点です。
- `userCount`と`projectCount`のように、似たような名前の曖昧さをなくすために単語を追加することができます。
- 入力の手間を省くために単純に文字を削除しないでください。たとえば、`Sandbox`は`Sbx`よりも優先され、特にエクスポートされた名前ではそうです。
- ほとんどの変数名では型や型に似た単語を省きます。
  - 数値の場合、`userCount`は`numUsers`や`usersInt`よりもよい名前です。
  -スライスの場合、`users`は`userSlice`よりも良い名前です。
  - たとえば、入力が`ageString`で保存され、解析された値が`age`であるような場合、型に似た修飾子を入れてもかまいません。
- 周囲の文脈から明らかな単語は省略します。たとえば、`UserCount`メソッドの実装では、`userCount`というローカル変数はおそらく冗長です。

#### 一文字の変数名

一文字の変数名は繰り返しを最小限にするのに便利なツールですが、コードを不必要に不透明にすることもあります。完全な単語が明らかで、一文字の変数の代わりにその単語を使用することが繰り返しになる場合のみに使用を制限してください。

一般的には

- [メソッドレシーバ変数](#レシーバ名)には、1文字か2文字の名前を付けるのが望ましいです。
- 一般的な型のために親しい変数名を使用することは、しばしば役に立ちます。
  - `r`は`io.Reader`や`*http.Request`です。
  - `w`は`io.Writer`や`http.ResponseWriter`です。
- 整数型のループ変数では、特にインデックス（`i`など）や座標（`x`や`y`など）には一文字の識別子を使うことができます。
- スコープが短い場合は、`_, n := range nodes { ... }`のように省略形もループ識別子として使用できます。

### 繰り返し

Goのソースコードの一部では、不必要な繰り返しを避ける必要があります。よくあるのが名前の繰り返しで、不要な単語が含まれていたり、文脈や型が繰り返されることがよくあります。コード自体も、同じまたは似たようなコードセグメントが近接して何度も現れると、不必要に繰り返されることがあります。

反復的な命名には、次のようなさまざまな形態があります。

#### パッケージ名とエクスポートされたシンボル名

エクスポートされたシンボルに名前を付ける場合、パッケージの名前は常にパッケージの外から見えるので、両者の間の冗長な情報は減らすか排除する必要があります。パッケージが1つの型だけをエクスポートし、それがパッケージ自身の名前になる場合、コンストラクタの正規名が必要であれば`New`になります。

| 反復的な名前 | 良い名前 |
| :---: | :---: |
| `widget.NewWidget` | `widget.New` |
| `widget.NewWidgetWithName` | `widget.NewWithName` |
| `db.LoadFromDatabase` | `db.Load` |
| `goatteleportutil.CountGoatsTeleported` | `gtutil.CountGoatsTeleported`か `goatteleport.Count` |
| `myteampb.MyTeamMethodRequest` | `mtpb.MyTeamMethodRequest`か `myteampb.MethodRequest` |

#### 変数名と型

コンパイラは常に変数の型を把握しており、またほとんどの場合、変数の使われ方によって読者にもその型がわかるようになっています。変数の型を明確にする必要があるのは、その値が同じスコープに2回現れる場合だけです。

| 反復的な名前 | 良い名前 |
| :---: | :---: |
| `var numUsers int` | `var users int` |
| `var nameString string` | `var name string` |
| `var primaryProject *Project` | `var primary *Project` |

値が複数の形式で現れる場合は、`raw`や`parsed`といった補足的な単語や、基本的な表現で明らかにすることができます。

```go
// Good:
limitStr := r.FormValue("limit")
limit, err := strconv.Atoi(limitStr)
```

```go
// Good:
limitRaw := r.FormValue("limit")
limit, err := strconv.Atoi(limitRaw)
```

#### 外部コンテキストとローカル名

名前に周囲のコンテキストの情報を含めると、多くの場合、利点のない余計なノイズが発生します。パッケージ名、メソッド名、型名、関数名、インポートパス、そしてファイル名さえも、その中のすべての名前を自動的に修飾するコンテキストを提供することができます。

```go
// Bad:
// In package "ads/targeting/revenue/reporting"
type AdsTargetingRevenueReport struct{}

func (p *Project) ProjectName() string
```

```go
// Good:
// In package "ads/targeting/revenue/reporting"
type Report struct{}

func (p *Project) Name() string
```

```go
// Bad:
// In package "sqldb"
type DBConnection struct{}
```

```go
// Good:
// In package "sqldb"
type Connection struct{}
```

```go
// Bad:
// In package "ads/targeting"
func Process(in *pb.FooProto) *Report {
    adsTargetingID := in.GetAdsTargetingID()
}
```

```go
// Good:
// In package "ads/targeting"
func Process(in *pb.FooProto) *Report {
    id := in.GetAdsTargetingID()
}
```

繰り返しは一般的に、単独で評価するのではなく、シンボルの使用者のコンテキストで評価されるべきです。たとえば、次のコードにはたくさんの名前があり、ある状況下では問題なくても、コンテキスト上では冗長になっています。

```go
// Bad:
func (db *DB) UserCount() (userCount int, err error) {
    var userCountInt64 int64
    if dbLoadError := db.LoadFromDatabase("count(distinct users)", &userCountInt64); dbLoadError != nil {
        return 0, fmt.Errorf("failed to load user count: %s", dbLoadError)
    }
    userCount = int(userCountInt64)
    return userCount, nil
}
```

その代わり、コンテキストや 使い方から明らかな名称については、情報を省略することができる場合が多いです。

```go
// Good:
func (db *DB) UserCount() (int, error) {
    var count int64
    if err := db.Load("count(distinct users)", &count); err != nil {
        return 0, fmt.Errorf("failed to load user count: %s", err)
    }
    return int(count), nil
}
```

## コメント

コメントに関する規約（何をコメントするか、どのようなスタイルを使うか、実行可能な例をどのように提供するか、など）は、公開APIのドキュメントを読む経験を支援することを目的としています。詳しくは[Effective Go](http://golang.org/doc/effective_go.html#commentary)をご覧ください。

ベストプラクティスドキュメントの[ドキュメント規約](#TBD)のセクションで、このことについてさらに議論しています。

**ベストプラクティス**: 開発中やコードレビュー中に[doc preview](#TBD)を使って、ドキュメントや実行可能な例が有用かどうか、期待通りの形で表示されているかどうかを確認します。

*ヒント*：Godocはほとんど特別な書式を使いません。リストとコードスニペットは通常、行の折り返しを避けるためにインデントされるべきです。インデントとは別に、装飾は一般的に避けるべきです。

### コメント行の長さ

狭い画面でもソースからコメントが読めるようにしてください。

コメントが長くなりすぎた場合は、複数の一行コメントにまとめることをお勧めします。可能な限り、80カラム幅の端末で読めるコメントを目指します。ただし、これは厳密な制限ではなく、Goのコメントには決まった行の長さの制限はありません。たとえば標準ライブラリは、句読点に基づいてコメントを分割することがよくあり、その場合個々の行が60～70文字の近くになることがあります。

既存のコードには、コメントが80字を超えるものがたくさんあります。このガイドラインは、可読性レビューの一環としてそのようなコードを変更する正当な理由として使用されるべきではありませんが（[一貫性](guide.md#一貫性)を参照）、チームは他のリファクタリングの一環として、このガイドラインに従うように臨機応変にコメントを更新することが推奨されます。このガイドラインの主な目標は、すべてのGoの可読性メンターが、提言がなされる場合に同じ提言をすることを確実にすることです。

解説の詳細については、[ドキュメントに関するGoブログの記事](https://blog.golang.org/godoc-documenting-go-code)をご覧ください。

```go
# Good:
// これはコメントの段落です。
// Godocでは個々の行の長さは関係ありません。
// しかし、折り返しを選択することで、狭い画面でも読みやすくなっています。
//
// 長いURLはあまり気にしないでください。
// https://supercalifragilisticexpialidocious.example.com:8080/Animalia/Chordata/Mammalia/Rodentia/Geomyoidea/Geomyidae/
//
// 同様に、その他の情報でも不自然になっているものがあれば
// 妨げになるのではなく、むしろ役に立つのであれば
// 適宜長い改行を入れてください。
```

小さな画面で何度も折り返されるようなコメントは、読者の体験を悪くするので避けてください。

```go
# Bad:
// これはコメントの段落です。Godocでは個々の行の長さは関係ありません。
// しかし、折り返しを選択することで、
// 狭い画面でも読みやすくなっています。
//
// 長いURLはあまり気にしないでください。
// https://supercalifragilisticexpialidocious.example.com:8080/Animalia/Chordata/Mammalia/Rodentia/Geomyoidea/Geomyidae/
```

### ドキュメントコメント

すべてのトップレベルのエクスポートされた名前にはドキュメントコメントが必要です。また、明らかに動作や意味が不明なエクスポートされていない型や関数の宣言にもコメントが必要です。これらのコメントは、説明されるオブジェクトの名前で始まる[完全な文](#コメント文)でなければなりません。より自然に読めるように、名前の前に冠詞（"a", "an", "the"）をつけてもかまいません。

```go
// Good:
// A Request represents a request to run a command.
type Request struct { ...

// Encode writes the JSON encoding of req to w.
func Encode(w io.Writer, req *Request) { ...
```

ドキュメントコメントはGodocに表示され、IDEによって表示されるため、そのパッケージを使用する人のために書かれるべきです。

ドキュメントコメントは、以下のシンボル、または、構造体の中に現れる場合はフィールドのグループに適用されます。

```go
// Good:
// Options configure the group management service.
type Options struct {
    // General setup:
    Name  string
    Group *FooGroup

    // Dependencies:
    DB *sql.DB

    // Customization:
    LargeGroupThreshold int // optional; default: 10
    MinimumMembers      int // optional; default: 2
}
```

**ベストプラクティス**: エクスポートされていないコードに対するドキュメントコメントがある場合、エクスポートした場合と同じ習慣に従ってください（つまり、エクスポートされていない名前でコメントを開始する）。これにより、コメントとコードの両方において、エクスポートされていない名前を新しくエクスポートされた名前に置き換えるだけで、後で簡単にエクスポートすることができます。

### コメント文

完全な文章であるコメントは、標準的な英語の文章と同様に、大文字と小文字を区別してください。(例外として、識別子の名前が明確であれば、文頭に大文字でない名前をつけてもかまいません。このようなケースは、おそらく段落の最初にのみ行うのが最善でしょう)。

文の断片であるコメントには、句読点や大文字の使用に関する要件はありません。

ドキュメントのコメントは常に完全な文であるべきで、そのように常に大文字と句読点を使用すべきです。単純な行末コメント（特に構造体フィールドの場合）は、フィールド名を主語とする単純な語句でかまいません。

```go
// Good:
// A Server handles serving quotes from the collected works of Shakespeare.
type Server struct {
    // BaseDir points to the base directory under which Shakespeare's works are stored.
    //
    // The directory structure is expected to be the following:
    //   {BaseDir}/manifest.json
    //   {BaseDir}/{name}/{name}-part{number}.txt
    BaseDir string

    WelcomeMessage  string // displayed when user logs in
    ProtocolVersion string // checked against incoming requests
    PageLength      int    // lines per page when printing (optional; default: 20)
}
```

### 例

パッケージは、その使用目的を明確にドキュメント化する必要があります。[実行可能な例](http://blog.golang.org/examples)を提供するようにしましょう。サンプルはGodocで表示されます。実行可能な例はテストファイルに属し、プロダクションのソースファイルには属しません。この例（[Godoc](https://pkg.go.dev/time#example-Duration)、[ソースコード](https://cs.opensource.google/go/go/+/HEAD:src/time/example_test.go)）をご覧ください。

実行可能なサンプルを提供することが不可能な場合、サンプルコードをコードコメント内で提供することができます。コメント中の他のコードやコマンドラインのスニペットと同様に、標準的なフォーマット規則に従う必要があります。

### 名前付き結果パラメータ

パラメータに名前をつけるときは、Godocで関数のシグネチャがどのように表示されるかを考慮してください。関数自体の名前と結果のパラメータの型は、しばしば十分に明確です。

```go
// Good:
func (n *Node) Parent1() *Node
func (n *Node) Parent2() (*Node, error)
```

関数が同じ型の2つ以上のパラメータを返す場合、名前を追加すると便利です。

```go
// Good:
func (n *Node) Children() (left, right *Node, err error)
```

呼び出し側が特定の結果パラメータに対してアクションを起こさなければならない場合、その名前を付けることでアクションの内容を示唆することができます。

```go
// Good:
// WithTimeout returns a context that will be canceled no later than d duration
// from now.
//
// The caller must arrange for the returned cancel function to be called when
// the context is no longer needed to prevent a resource leak.
func WithTimeout(parent Context, d time.Duration) (ctx Context, cancel func())
```

上のコードでは、キャンセルは呼び出し側が取らなければならない特定のアクションです。しかし、結果パラメータに`(Context, func())`とだけ書かれていたのでは、「キャンセル関数」が何を意味するのかが不明です。

名前付きの結果パラメータは、その名前が[不必要な繰り返し](#変数名と型)を生む場合は使用しないでください。

```go
// Bad:
func (n *Node) Parent1() (node *Node)
func (n *Node) Parent2() (node *Node, err error)
```

関数内部で変数を宣言するのを避けるために、結果パラメータに名前をつけないようにしましょう。この方法は、実装を簡潔にする代わりに API を不必要に冗長にしてしまいます。

[素のまま返すこと](https://tour.golang.org/basics/7)が許されるのは、小規模な関数の場合だけです。中規模な関数になったら、戻り値を明示するようにしましょう。同様に、素の返り値を使えるようになるからといって、結果パラメータに名前をつけないようにしましょう。関数の数行を節約することよりも、常に[明確さ](guide.md#明確さ)が重要なのです。

遅延クロージャの中で値を変更しなければならない場合、結果パラメータに名前を付けることは常に許容されます。

> ヒント: 関数のシグネチャでは、名前よりも型のほうがわかりやすいことがよくあります。[GoTip #38: 名前付き型としての関数](https://google.github.io/styleguide/go/index.html#gotip)でこれを実演しています。
> 上記の`WithTimeout`では、実際のコードは結果パラメータのリストで生の`func()`の代わりに`CancelFunc`を使っており、ドキュメントを書くのにほとんど労力を必要としません。

### パッケージコメント

パッケージのコメントは、パッケージ句のすぐ上に表示され、コメントとパッケージ名の間に空白行がないようにしなければなりません。

例:

```go
// Good:
// Package math provides basic constants and mathematical functions.
//
// This package does not guarantee bit-identical results across architectures.
package math
```

パッケージコメントは、1つのパッケージにつき1つでなければなりません。パッケージが複数のファイルで構成されている場合、そのうちの厳密に1つのファイルがパッケージコメントを持つべきです。

`main`パッケージのコメントは少し形式が異なり、BUILDファイル内の`go_binary`ルールの名前がパッケージ名の代わりとなります。

```go
// Good:
// The seed_generator command is a utility that generates a Finch seed file
// from a set of JSON study configs.
package main
```

バイナリ名が BUILD ファイルに書かれている通りであれば、他のスタイルのコメントでもかまいません。バイナリ名が最初の単語である場合、コマンドライン呼び出しのスペルと厳密に一致しなくても、大文字にすることが必要です。

```go
// Good:
// Binary seed_generator ...
// Command seed_generator ...
// Program seed_generator ...
// The seed_generator command ...
// The seed_generator program ...
// Seed_generator ...
```

ヒント:

- コマンドラインの起動例やAPIの使い方は、有用なドキュメントになります。Godoc フォーマットのために、コードを含むコメント行をインデントしてください。
- 明らかな主ファイルがない場合、またはパッケージのコメントが非常に長い場合、ドキュメントコメントをコメントとパッケージ節だけを含む`doc.go`という名前のファイルに入れることができます。
- 複数の一行コメントの代わりに、複数行コメントを使用することができます。これは主に、コマンドラインのサンプル（バイナリ用）やテンプレートの例など、ソースファイルからコピー＆ペーストすると便利な部分がドキュメントに含まれている場合に便利です。

```go
// Good:
/*
The seed_generator command is a utility that generates a Finch seed file
from a set of JSON study configs.

    seed_generator *.json | base64 > finch-seed.base64
*/
package template
```

- メンテナ向けのコメントで、ファイル全体に適用されるものは、通常`import`宣言の後に置かれます。これらはGodocでは表示されず、パッケージコメントに関する上記の規則には従いません。

## インポート

### インポート名変更

インポートは、他のインポートとの名前の衝突を避けるためにのみ名前を変更すべきです。(これの帰結として、[良いパッケージ名](#パッケージ名)は名前の変更を必要としないはずです。) 名前が衝突した場合、最もローカルな、あるいはプロジェクト固有のインポートの名前を変更することが望まれます。パッケージのローカル名（エイリアス）は、アンダースコアと大文字の使用禁止を含む、[パッケージ名の命名に関するガイダンス](#パッケージ名)に従わなければなりません。

生成されたプロトコルバッファーパッケージは、名前を変更してアンダースコアを削除し、エイリアスのサフィックスを`pb`にしなければなりません。詳しくは、[protoとstubのベストプラクティス](#TBD)を参照してください。

```go
// Good:
import (
    fspb "path/to/package/foo_service_go_proto"
)
```

有用な識別情報のないパッケージ名（たとえば`package v1`）を持つインポートは、以前のパスコンポーネントを含むように名前を変更すべきです。名前変更は、同じパッケージをインポートする他のローカルファイルと一貫性がなければならず、バージョン番号を含むことができます。

**注意**: パッケージ名を変更して[良いパッケージ名](#パッケージ名)に準拠させることが望ましいですが、ベンダリングされたディレクトリにあるパッケージでは実現不可能なことがよくあります。

```go
// Good:
import (
    core "github.com/kubernetes/api/core/v1"
    meta "github.com/kubernetes/apimachinery/pkg/apis/meta/v1beta1"
)
```

もし、使用したい共通のローカル変数名（例: `url`、`ssh`）と名前が衝突するパッケージをインポートする必要があり、パッケージ名を変更したい場合、望ましい方法は`pkg`サフィックス（例: `urlpkg`）を使用することです。ローカル変数でパッケージをシャドーイングすることも可能です。 この名前の変更は、そのような変数がスコープ内にあるときにパッケージを使用する必要がある場合にのみ必要であることに注意してください。

### インポートグループ分け

インポートは、2つのグループに分けて整理する必要があります。

- 標準ライブラリパッケージ
- その他（プロジェクトやベンダー）のパッケージ

```go
// Good:
package main

import (
    "fmt"
    "hash/adler32"
    "os"

    "github.com/dsnet/compress/flate"
    "golang.org/x/text/encoding"
    "google.golang.org/protobuf/proto"
    foopb "myproj/foo/proto/proto"
    _ "myproj/rpc/protocols/dial"
    _ "myproj/security/auth/authhooks"
)
```

プロジェクトパッケージを複数のグループに分割することも可能です。たとえば、名前を変更したインポート、副作用のためだけのインポート、その他の特別なインポートグループを別のグループにしたい場合などです。

```go
// Good:
package main

import (
    "fmt"
    "hash/adler32"
    "os"


    "github.com/dsnet/compress/flate"
    "golang.org/x/text/encoding"
    "google.golang.org/protobuf/proto"

    foopb "myproj/foo/proto/proto"

    _ "myproj/rpc/protocols/dial"
    _ "myproj/security/auth/authhooks"
)
```

**注意**: 選択的なグループの維持、つまり標準ライブラリとGoogleインポートの必須分離のために必要な以上の分割は、[goimports](https://google.github.io/styleguide/go/golang.org/x/tools/cmd/goimports)ツールではサポートされていません。追加のインポートサブグループは、適合した状態で維持するために、記述者とレビュアーの両方の側で注意が必要です。

AppEngineアプリでもあるGoogleプログラムは、AppEngineインポート用の別グループを持つべきです。

Gofmtは、各グループをインポートパスでソートするように配慮しています。しかし、インポートを自動的にグループに分けてくれるわけではありません。人気のある[goimports](https://google.github.io/styleguide/go/golang.org/x/tools/cmd/goimports)ツールは、Gofmtとインポート管理を組み合わせ、上記の決定に基づいてインポートをグループに分離します。[goimports](https://google.github.io/styleguide/go/golang.org/x/tools/cmd/goimports)にインポートの配置を完全に管理させることも可能ですが、ファイルが改訂された場合、そのインポートリストは内部的に一貫性を保たなければなりません。

### 「ブランク」のインポート（`import _`）

副作用のためにのみインポートされるパッケージ）`import _ "package"`という構文を使用）は、 `main`パッケージ、あるいはそれを必要とするテストにおいてのみインポートすることができます。

そのようなパッケージの例として、以下のようなものがあります。

- [time/tzdata](https://pkg.go.dev/time/tzdata)
- 画像処理コードにおける[image/jpeg](https://pkg.go.dev/time/tzdata)

たとえライブラリが間接的に依存していたとしても、ライブラリパッケージのブランクインポートは避けてください。副作用のインポートを`main`パッケージに拘束することで、依存関係を制御し、競合や無駄なビルドコストなしに別のインポートに依存するテストを書くことができるようになります。

このルールの唯一の例外は、以下のとおりです。

**ヒント**: プロダクション環境において、間接的に副作用のあるインポートに依存するライブラリパッケージを作成する場合、意図する使用方法をドキュメント化してください。

### 「ドット」のインポート（`import .`）

`import .`は、他のパッケージからエクスポートされた識別子を無条件に現在のパッケージに持ち込むことを可能にする言語機能です。詳しくは[言語仕様](https://go.dev/ref/spec#Import_declarations)をご覧ください。

Googleのコードベースではこの機能を使わ**ない**でください。

```go
// Bad:
package foo_test

import (
    "bar/testutil" // "foo"もインポート
    . "foo"
)

var myThing = Bar() // Barはfooパッケージで定義されている; 修飾不要
```

```go
// Good:
package foo_test

import (
    "bar/testutil" // "foo"もインポート
    "foo"
)

var myThing = foo.Bar()
```

## エラー

### エラーを返す

関数が失敗する可能性があることを知らせるには、`error`を使用します。慣習上、`error`は最後の結果パラメータです。

```go
// Good:
func Good() error { /* ... */ }
```

`nil`エラーを返すことは、他の方法では失敗する可能性のある操作に成功したことを知らせる慣用的な方法です。関数がエラーを返した場合、呼び出し側は明示的にドキュメント化されていない限り、エラー以外のすべての戻り値を未指定として扱わなければなりません。一般に、非エラーの返り値はそのゼロ値ですが、これを前提とすることはできません。

```go
// Good:
func GoodLookup() (*Result, error) {
    // ...
    if err != nil {
        return nil, err
    }
    return res, nil
}
```

エラーを返すエクスポートされた関数は、`error`型を使用してエラーを返す必要があります。具体的なエラータイプは微妙なバグの影響を受けやすく、具体的な`nil`ポインタはインターフェースにラップされてしまい、`nil`でない値になってしまうことがあります（[このトピックに関するGo FAQの項目](https://golang.org/doc/faq#nil_error)を参照してください）。

```go
// Bad:
func Bad() *os.PathError { /*...*/ }
```

**ヒント**: `context.Context`引数を取る関数は、通常`error`を返すようにしてください。そうすれば、関数の実行中にコンテキストがキャンセルされたかどうかを呼び出し元が判断できます。

### エラー文字列

エラー文字列は（エクスポート名、固有名詞、頭字語で始まる場合を除き）大文字始まりにすべきではなく、句読点で終わらせてはいけません。これは、エラー文字列は通常、ユーザーに表示される前に他のコンテキストで表示されるからです。

```go
// Bad:
err := fmt.Errorf("Something bad happened.")
```

```go
// Good:
err := fmt.Errorf("something bad happened")
```

一方、完全に表示されるメッセージ（ロギング、テスト失敗、APIレスポンス、その他のUI）のスタイルは場合によりますが、通常大文字始まりで表記されるべきです。

```go
// Good:
log.Infof("Operation aborted: %v", err)
log.Errorf("Operation aborted: %v", err)
t.Errorf("Op(%q) failed unexpectedly; err=%v", args, err)
```

### エラー処理

エラーに遭遇したコードは、それをどのように処理するかを意図的に選択する必要があります。通常、`_`変数を使用してエラーを破棄することは適切ではありません。関数がエラーを返した場合は、次のいずれかを行ってください。

- エラーを直ちに処理して対処する。
- エラーを呼び出し元に返す。

例外的な状況では、[log.Fatal](https://pkg.go.dev/github.com/golang/glog#Fatal)を呼び出すか、（絶対に必要であれば）`panic`させます。

**注意**: `log.Fatal`は、標準ライブラリのログではありません。[#logging]を参照してください。

エラーを無視または破棄することが適切な稀な状況（例たとば、絶対に失敗しないと文書化されている [(*bytes.Buffer).Write](https://pkg.go.dev/bytes#Buffer.Write)の呼び出し）では、付帯するコメントでそれが安全である理由を説明する必要があります。

```go
// Good:
var b *bytes.Buffer

n, _ := b.Write(p) // 絶対nilでないエラーを返さない
```

エラー処理の詳細な議論と例については、[Effective Go](http://golang.org/doc/effective_go.html#errors)と[ベストプラクティス](#TBD)を参照してください。

### インバンドエラー

C言語や類似の言語では、関数がエラーや結果の欠落を知らせるために、-1、null、空文字列などの値を返すことがよくあります。これはインバンドエラー処理として知られています。

```go
// Bad:
// Lookup returns the value for key or -1 if there is no mapping for key.
func Lookup(key string) int
```

インバンドエラー値のチェックを怠ると、バグが発生したり、間違った関数にエラーを帰属させたりする可能性があります。

```go
// Bad:
// 次の行は、入力値に対して Parse が失敗したというエラーを返しますが、
// 失敗の原因は missingKey に対するマッピングが存在しないことでした。
return Parse(Lookup(missingKey))
```

Goの複数戻り値のサポートはより良い解決策を提供します（[複数戻り値に関するEffective Goのセクション](http://golang.org/doc/effective_go.html#multiple-returns)を参照してください）。クライアントにインバンドエラー値をチェックさせる代わりに、関数は他の戻り値が有効であるかどうかを示すために追加の値を返すべきです。この戻り値は、エラーであっても、説明が不要な場合はブール値であってもよく、最終的な戻り値であるべきです。

```go
// Good:
// Lookup returns the value for key or ok=false if there is no mapping for key.
func Lookup(key string) (value string, ok bool)
```

`Lookup(key)`は2つの出力を持つので、コンパイルエラーを起こすことで呼び出し側が誤って`Parse(Lookup(key))`と記述するのを防ぐAPIになっています。

このようにエラーを返すことで、より強固で明示的なエラー処理を行うことができます。

```go
// Good:
value, ok := Lookup(key)
if !ok {
    return fmt.Errorf("no value for %q", key)
}
return Parse(value)
```

`strings`パッケージのような標準ライブラリ関数には、インバンドエラー値を返すものがあります。これは文字列操作のコードを非常に単純化しますが、その代償としてプログラマはより多くの注意を払わなければなりません。一般的に、Google のコードベースにおけるGoのコードは、 エラーに対して追加の値を返すべきです。

### エラーフローのインデント

エラーを処理してから残りのコードを進めてください。これにより、読者は正常なパスを素早く見つけることができ、コードの読みやすさが向上します。これと同じ論理が、条件をテストして終了条件（`return`、`panic`、`log.Fatal`など）で終わるすべてのブロックに当てはまります。

終了条件が満たされない場合に実行されるコードは`if`ブロックの後に表示されるべきで`else`節の中でインデントされるべきではありません。

```go
// Good:
if err != nil {
    // エラーハンドリング
    return // もしくは処理を続行するなど
}
// 通常コード
```

```go
// Bad:
if err != nil {
    // エラーハンドリング
} else {
    // インデントのせいで異常系に見える通常コード
}
```

**ヒント**: 数行以上のコードで変数を使用する場合、一般的に `if` + 初期化 スタイルを使用する価値はありません。このような場合は、宣言を外に出し、標準的な`if`文を使用した方が良い場合がほとんどです。

```go
// Good:
x, err := f()
if err != nil {
  // エラーハンドリング
  return
}
// xを複数行に渡って使用する多くのコード
```

```go
// Bad:
if x, err := f(); err != nil {
  // エラーハンドリング
  return
} else {
  // xを複数行に渡って使用する多くのコード
}
```

詳しくは、[Go Tip #1: Line of Sight](https://google.github.io/styleguide/go/index.html#gotip)と[TotT: Reduce Code Complexity by Reducing Nesting](https://testing.googleblog.com/2017/06/code-health-reduce-nesting-reduce.html)を参照してください。

## 言語

### リテラルフォーマット

Goには非常に強力な[複合リテラル構文](https://golang.org/ref/spec#Composite_literals)があり、深くネストした複雑な値を1つの式で表現することができます。可能な限り、フィールドごとに値を構築するのではなく、このリテラル構文を使用する必要があります。リテラルの`gofmt`フォーマットは一般的に非常に優れていますが、これらのリテラルを読みやすく維持するための追加ルールがいくつかあります。

#### フィールド名

構造体リテラルは通常、現在のパッケージの外で定義された型の**フィールド名**を指定する必要があります。

- 他のパッケージの型のフィールド名も含めてください。

```go
// Good:
good := otherpkg.Type{A: 42}
```

構造体におけるフィールドの位置とフィールドのフルセット（どちらもフィールド名が省略された場合に正しく取得する必要があります）は、通常構造体の公開APIの一部とは見なされません。不要な結合を避けるために、フィールド名を指定する必要があります。

```go
// Bad:
// https://pkg.go.dev/encoding/csv#Reader
r := csv.Reader{',', '#', 4, false, false, false, false}
```

構成と順序が安定していることがドキュメント化されている小さな単純な構造体内では、フィールド名を省略することができます。

```go
// Good:
okay := image.Point{42, 54}
also := image.Point{X: 42, Y: 54}
```

- パッケージローカル型では、フィールド名は任意です。

```go
// Good:
okay := Type{42}
also := internalType{4, 2}
```

フィールド名は、コードが明確になるのであればやはり使用すべきですし、そうすることが非常に一般的です。たとえば、多数のフィールドを持つ構造体は、ほとんどの場合フィールド名を書いて初期化されるべきです。

```go
// Good:
okay := StructWithLotsOfFields{
  field1: 1,
  field2: "two",
  field3: 3.14,
  field4: true,
}
```

#### 中括弧のマッチング

中括弧のペアの閉じ側は、常に開始側の中括弧と同じインデント数の行に表示される必要があります。1行のリテラルには必ずこの特性があります。リテラルが複数行にまたがる場合、この性質を維持することで、リテラルの中括弧のマッチングを、関数や`if`文などの一般的なGo構文の中括弧のマッチングと同じにすることができます。

この分野で最もよくある間違いは、複数行の構造体リテラルの値と同じ行に終了中括弧を置くことです。このような場合、行末にカンマを置き、次の行に終了中括弧を記述する必要があります。

```go
// Good:
good := []*Type{{Key: "value"}}
```

```go
// Good:
good := []*Type{
    {Key: "multi"},
    {Key: "line"},
}
```

```go
// Bad:
bad := []*Type{
    {Key: "multi"},
    {Key: "line"}}
```

```go
// Bad:
bad := []*Type{
    {
        Key: "value"},
}
```

#### 抱き合わせ中括弧

スライスや配列のリテラルで中括弧の間の空白を削除する（別名「抱き合わせ」）ことは、以下の両方が真である場合にのみ許可されます。

- [インデントが一致する](https://google.github.io/styleguide/go/decisions#literal-matching-braces)
- 内部の値もリテラルまたはprotoビルダーである（つまり、変数や他の式ではない）

```go
// Good:
good := []*Type{
    { // 抱き合わせされていない
        Field: "value",
    },
    {
        Field: "value",
    },
}
```

```go
// Good:
good := []*Type{{ // 正しく抱き合わせされている
    Field: "value",
}, {
    Field: "value",
}}
```

```go
// Good:
good := []*Type{
    first, // 抱き合わせできない
    {Field: "second"},
}
```

```go
// Good:
okay := []*pb.Type{pb.Type_builder{
    Field: "first", // protoビルダーは垂直方向のスペースを節約するために抱き合わせされている
}.Build(), pb.Type_builder{
    Field: "second",
}.Build()}
```

```go
// Bad:
bad := []*Type{
    first,
    {
        Field: "second",
    }}
```

#### 型名の繰り返し

繰り返される型名は、スライスやマップのリテラルから省略することができます。これは、煩雑さを軽減するのに有効です。型名を明示的に繰り返す妥当な場面は、プロジェクトでは一般的でない複雑な型を扱うとき、繰り返される型名が離れた行にあり、読者にコンテキストを思い起こさせることができるときです。

```go
// Good:
good := []*Type{
    {A: 42},
    {A: 43},
}
```

```go
// Bad:
repetitive := []*Type{
    &Type{A: 42},
    &Type{A: 43},
}
```

```go
// Bad:
repetitive := []*Type{
    &Type{A: 42},
    &Type{A: 43},
}
```

```go
// Good:
good := map[Type1]*Type2{
    {A: 1}: {B: 2},
    {A: 3}: {B: 4},
}
```

```go
// Bad:
repetitive := map[Type1]*Type2{
    Type1{A: 1}: &Type2{B: 2},
    Type1{A: 3}: &Type2{B: 4},
}
```

**ヒント**: 構造体リテラルで繰り返される型名を削除したい場合は、`gofmt -s`を実行します。

#### ゼロ値フィールド

ゼロ値フィールドは、構造体リテラルの明確性が損なわれない場合には、省略することができます。

優れた設計のAPIでは、可読性を高めるためにゼロ値構造を採用することがよくあります。たとえば、次の構造体から3つのゼロ値フィールドを省略すると、指定されている唯一のオプションに注目が集まります。

```go
// Bad:
import (
  "github.com/golang/leveldb"
  "github.com/golang/leveldb/db"
)

ldb := leveldb.Open("/my/table", &db.Options{
    BlockSize: 1<<16,
    ErrorIfDBExists: true,

    // これらのフィールドはすべてゼロ値です。
    BlockRestartInterval: 0,
    Comparer: nil,
    Compression: nil,
    FileSystem: nil,
    FilterPolicy: nil,
    MaxOpenFiles: 0,
    WriteBufferSize: 0,
    VerifyChecksums: false,
})
```

```go
// Good:
import (
  "github.com/golang/leveldb"
  "github.com/golang/leveldb/db"
)

ldb := leveldb.Open("/my/table", &db.Options{
    BlockSize: 1<<16,
    ErrorIfDBExists: true,
})
```

テーブル駆動テスト内の構造体は、特にテスト構造体が単純でない場合、[明示的なフィールド名](#TBD)から恩恵を受けることがよくあります。これにより、テストケースに関連しないフィールドについては、ゼロ値フィールドを完全に省略することができます。たとえば、成功したテストケースでは、エラーに関連するフィールドや失敗に関連するフィールドを省略する必要があります。ゼロまたは`nil`の入力に対するテストのように、テストケースを理解するためにゼロ値が必要な場合は、 フィールド名を指定する必要があります。

#### 簡潔さ

```go
tests := []struct {
    input      string
    wantPieces []string
    wantErr    error
}{
    {
        input:      "1.2.3.4",
        wantPieces: []string{"1", "2", "3", "4"},
    },
    {
        input:   "hostname",
        wantErr: ErrBadHostname,
    },
}
```

#### 明示

```go
tests := []struct {
    input    string
    wantIPv4 bool
    wantIPv6 bool
    wantErr  bool
}{
    {
        input:    "1.2.3.4",
        wantIPv4: true,
        wantIPv6: false,
    },
    {
        input:    "1:2::3:4",
        wantIPv4: false,
        wantIPv6: true,
    },
    {
        input:    "hostname",
        wantIPv4: false,
        wantIPv6: false,
        wantErr:  true,
    },
}
```

### Nilスライス

ほとんどの場合、`nil`と空のスライスの間に機能的な違いはありません。`len`や`cap`のような組み込み関数は、`nil`スライスで期待通りに動作します。

```go
// Good:
import "fmt"

var s []int         // nil

fmt.Println(s)      // []
fmt.Println(len(s)) // 0
fmt.Println(cap(s)) // 0
for range s {...}   // no-op

s = append(s, 42)
fmt.Println(s)      // [42]
```

空のスライスをローカル変数として宣言する場合（特に戻り値の元になり得る場合）、呼び出し側によるバグのリスクを減らすために`nil`の初期化を優先してください。

```go
// Good:
var t []string
```

```go
// Bad:
t := []string{}
```

`nil`と空のスライスを区別することをクライアントに強いるようなAPIを作ってはいけません。

```go
// Good:
// Ping pings its targets.
// Returns hosts that successfully responded.
func Ping(hosts []string) ([]string, error) { ... }
```

```go
// Bad:
// Ping pings its targets and returns a list of hosts
// that successfully responded. Can be empty if the input was empty.
// nil signifies that a system error occurred.
func Ping(hosts []string) []string { ... }
```

インターフェースを設計するとき、`nil`のスライスと`nil`でない長さ0のスライスを区別することは、微妙なプログラミングエラーにつながる可能性があるので避けてください。これは通常、`== nil`ではなく`len`を使用して空かどうかをチェックすることで達成されます。

この実装では、`nil`と長さ0のスライスの両方を「空」として受け入れます。

```go
// Good:
// describeInts describes s with the given prefix, unless s is empty.
func describeInts(prefix string, s []int) {
    if len(s) == 0 {
        return
    }
    fmt.Println(prefix, s)
}
```

APIの一部としてnilスライスと長さ0のスライスの区別に依存しないでください

```go
// Bad:
func maybeInts() []int { /* ... */ }

// describeInts describes s with the given prefix; pass nil to skip completely.
func describeInts(prefix string, s []int) {
  // この関数の動作は、maybeInts()が「空」の場合に
  // 何を返すか（nil または []int{} ）によって意図せず変化します。
  if s == nil {
    return
  }
  fmt.Println(prefix, s)
}

describeInts("Here are some ints:", maybeInts())
```

詳しくは[インバンドエラー](#インバンドエラー)をご覧ください。

### インデントの乱れ

インデントされたコードブロックと残りの行を揃えることになる場合は、改行を導入しないようにします。やむを得ない場合は、ブロック内のコードと折り返し行を区切るスペースを空けてください。

```go
// Bad:
if longCondition1 && longCondition2 &&
    // Condition 3と4は、if内のコードと同じインデントです。
    longCondition3 && longCondition4 {
    log.Info("all conditions met")
}
```

具体的なガイドラインや事例については、以下のセクションを参照してください。

- [関数のフォーマット](#関数のフォーマット)
- [条件とループ](#条件とループ)
- [リテラルのフォーマット](#リテラルのフォーマット)

### 関数のフォーマット

関数やメソッドの宣言のシグネチャは、[インデントの乱れ](#インデントの乱れ)を避けるために1行にまとめるべきです。

関数の引数リストは、Go ソースファイルの中で最も長い行になることがあります。しかし、それらはインデントの変更より前にあるため、それ以降の行を関数本体の一部のように見せて混乱させない方法で改行するのは困難です。

```go
// Bad:
func (r *SomeType) SomeLongFunctionName(foo1, foo2, foo3 string,
    foo4, foo5, foo6 int) {
    foo7 := bar(foo1)
    // ...
}
```

多くの引数を持つ関数の呼び出し部分を短縮するためのいくつかのオプションについては、[ベストプラクティス](#TBD)を参照してください。

```go
// Good:
good := foo.Call(long, CallOptions{
    Names:   list,
    Of:      of,
    The:     parameters,
    Func:    all,
    Args:    on,
    Now:     separate,
    Visible: lines,
})
```

```go
// Bad:
bad := foo.Call(
    long,
    list,
    of,
    parameters,
    all,
    on,
    separate,
    lines,
)
```

ローカル変数を括り出すことで、行を短くすることができる場合が多いです。

```go
// Good:
local := helper(some, parameters, here)
good := foo.Call(list, of, parameters, local)
```

同様に、関数とメソッドの呼び出しも、行の長さだけに基づいて分離してはいけません。

```go
// Good:
good := foo.Call(long, list, of, parameters, all, on, one, line)
```

```go
// Bad:
bad := foo.Call(long, list, of, parameters,
    with, arbitrary, line, breaks)
```

特定の関数のパラメータにコメントをつけないでください。代わりに、オプション構造体を使用するか、関数のドキュメントに詳細を追加してください。

```go
// Good:
good := server.New(ctx, server.Options{Port: 42})
```

```go
// Bad:
bad := server.New(
    ctx,
    42, // Port
)
```

呼び出し元が長すぎる場合は、リファクタリングを検討してください。

```go
// Good:
// 可変長引数は括り出せる場合がある
replacements := []string{
    "from", "to", // 関連する値を互いに隣接してフォーマットすることができる
    "source", "dest",
    "original", "new",
}

// NewReplacer の入力として、代替構造体を使用する。
replacer := strings.NewReplacer(replacements...)
```

APIを変更できない場合、またはローカル呼び出しが異常な場合（呼び出しが長すぎるかどうかは別として）、呼び出しの理解を助けるのであれば、改行を追加することは常に許容されます。

```go
// Good:
canvas.RenderCube(cube,
    x0, y0, z0,
    x0, y0, z1,
    x0, y1, z0,
    x0, y1, z1,
    x1, y0, z0,
    x1, y0, z1,
    x1, y1, z0,
    x1, y1, z1,
)
```

上の例の行は、特定の列の境界で折り返されているのではなく、座標の三点セットに基づ いてグループ化されていることに注意してください。

上の例の行は、特定の列の境界で折り返されているのではなく、座標の三点セットに基づ いてグループ化されていることに注意してください。

関数内の長い文字列リテラルは、行の長さのために改行されるべきではありません。そのような文字列を含む関数では、文字列の書式の後に改行を追加し、引数は次行以降に渡すようにすればよいのです。改行位置の決定は、純粋に行の長さではなく、入力の意味的なグループ分けに基づいて行うのが最もよい方法です。

```go
// Good:
log.Warningf("Database key (%q, %d, %q) incompatible in transaction started by (%q, %d, %q)",
    currentCustomer, currentOffset, currentKey,
    txCustomer, txOffset, txKey)
```

```go
// Bad:
log.Warningf("Database key (%q, %d, %q) incompatible in"+
    " transaction started by (%q, %d, %q)",
    currentCustomer, currentOffset, currentKey, txCustomer,
    txOffset, txKey)
```

### 条件とループ

if文は改行してはいけません。複数行のif文は[インデントを乱す](#インデントの乱れ)可能性があります。

```go
// Bad:
// 2番目のif文はifブロック内のコードと揃っているため、
// インデントを混乱させる原因となっています。
if db.CurrentStatusIs(db.InTransaction) &&
    db.ValuesEqual(db.TransactionKey(), row.Key()) {
    return db.Errorf(db.TransactionError, "query failed: row (%v): key does not match transaction key", row)
}
```

短絡動作が必要ない場合は、ブール演算を直接抽出できます。

```go
// Good:
inTransaction := db.CurrentStatusIs(db.InTransaction)
keysMatch := db.ValuesEqual(db.TransactionKey(), row.Key())
if inTransaction && keysMatch {
    return db.Error(db.TransactionError, "query failed: row (%v): key does not match transaction key", row)
}
```

また、特にすでに繰り返されている条件の場合、他に抽出できる部分がある可能性があります。

```go
// Good:
uid := user.GetUniqueUserID()
if db.UserIsAdmin(uid) || db.UserHasPermission(uid, perms.ViewServerConfig) || db.UserHasPermission(uid, perms.CreateGroup) {
    // ...
}
```

```go
// Bad:
if db.UserIsAdmin(user.GetUniqueUserID()) || db.UserHasPermission(user.GetUniqueUserID(), perms.ViewServerConfig) || db.UserHasPermission(user.GetUniqueUserID(), perms.CreateGroup) {
    // ...
}
```

クロージャや複数行の構造体リテラルを含む`if`文は、[インデントの乱れ](#インデントの乱れ)を避けるため、[中括弧を一致](#中括弧のマッチング)させる必要があります。

```go
// Good:
if err := db.RunInTransaction(func(tx *db.TX) error {
    return tx.Execute(userUpdate, x, y, z)
}); err != nil {
    return fmt.Errorf("user update failed: %s", err)
}
```

```go
// Good:
if _, err := client.Update(ctx, &upb.UserUpdateRequest{
    ID:   userID,
    User: user,
}); err != nil {
    return fmt.Errorf("user update failed: %s", err)
}
```

同様に、for文に無理やり改行を挿入するのもやめてください。もしリファクタリングする良い方法がなければ、いつでも行を単に長くしておくことができます。

```go
// Good:
for i, max := 0, collection.Size(); i < max && !collection.HasPendingWriters(); i++ {
    // ...
}
```

しかし、よくあります。

```go
// Good:
for i, max := 0, collection.Size(); i < max; i++ {
    if collection.HasPendingWriters() {
        break
    }
    // ...
}
```

`switch`文と`case`文も1行にまとめてください。

```go
// Good:
switch good := db.TransactionStatus(); good {
case db.TransactionStarting, db.TransactionActive, db.TransactionWaiting:
    // ...
case db.TransactionCommitted, db.NoTransaction:
    // ...
default:
    // ...
}
```

```go
// Bad:
switch bad := db.TransactionStatus(); bad {
case db.TransactionStarting,
    db.TransactionActive,
    db.TransactionWaiting:
    // ...
case db.TransactionCommitted,
    db.NoTransaction:
    // ...
default:
    // ...
}
```

変数と定数を比較する条件文では、等号演算子の左側に変数値を配置します。

```go
// Good:
if result == "foo" {
  // ...
}
```

定数が先に来るようなわかりにくい表現（「[ヨーダ記法](https://ja.wikipedia.org/wiki/%E3%83%A8%E3%83%BC%E3%83%80%E8%A8%98%E6%B3%95)」）は避けます。

```go
// Bad:
if "foo" == result {
  // ...
}
```

### コピー

予期せぬエイリアシングや同様のバグを避けるため、他のパッケージから構造体をコピーする際には注意が必要です。たとえば、`sync.Mutex`のような同期オブジェクトはコピーしてはいけません。

`bytes.Buffer`型は`[]byte`スライスと、小さな文字列のための最適化として、スライスが参照する小さなバイト配列を含んでいます。`Buffer`をコピーすると、コピーのスライスが元の配列のエイリアスになることがあり、その後のメソッド呼び出しが予期せぬ影響を与えることがあります。

一般に、`T`型の値のメソッドがポインタ型である`*T`と関連付けられている場合は、コピーしないでください。

```go
// Bad:
b1 := bytes.Buffer{}
b2 := b1
```

値のレシーバを取るメソッドを呼び出すと、コピーを隠蔽することができます。APIを作成する際、構造体にコピーされては困るフィールドがある場合は、一般的にポインタ型を取り、返すべきです。

これらは許容範囲内です。

```go
// Good:
type Record struct {
  buf bytes.Buffer
  // 他のフィールドは省略
}

func New() *Record {...}

func (r *Record) Process(...) {...}

func Consumer(r *Record) {...}
```

しかし、これらはたいてい間違っています。

```go
// Bad:
type Record struct {
  buf bytes.Buffer
  // 他のフィールドは省略
}


func (r Record) Process(...) {...} // r.bufのコピーをつくります

func Consumer(r Record) {...} // r.bufのコピーをつくります
```

このガイダンスは、`sync.Mutex`をコピーする場合にも適用されます。

### panicさせるな

通常のエラー処理に`panic`を使用しないでください。代わりに、エラーと複数の戻り値を使用してください。エラーについては、効果的なEffective Goのセクションを参照してください。

通常のエラー処理にpanicを使用しないでください。代わりに、エラーと複数の戻り値を使用してください。エラーについては、効果的な[Effective Goのセクション](http://golang.org/doc/effective_go.html#errors)を参照してください。

`package main`と初期化コード内で、プログラムを終了させるべきエラー（たとえば、無効な設定）には[log.Exit](https://pkg.go.dev/github.com/golang/glog#Exit)を考慮してください。これらのケースの多くでは、スタックトレースが読者の助けにならないからです。[log.Exit](https://pkg.go.dev/github.com/golang/glog#Exit)は[os.Exit](https://pkg.go.dev/os#Exit)を呼び出し、遅延された関数は実行されないことに注意してください。

「不可能」な状態を示すエラー、つまり、コードレビューやテスト中に常に発見されるべきバグについては、関数は合理的にエラーを返すか、`log.Fatal`を呼び出すことができます。

注意：`log.Fatal`は、標準ライブラリのログではありません。[logging](#TBD)を参照してください。

### Must関数

失敗時にプログラムを停止させるセットアップヘルパー関数は、`MustXYZ`（または`mustXYZ`）という命名規則に従っています。一般に、これらの関数はプログラム起動の初期にのみ呼ばれるべきで、ユーザー入力のように通常のGoエラー処理が優先されるような場合には呼ばないでください。

これは[パッケージ初期化時](https://golang.org/ref/spec#Package_initialization)にパッケージレベルの変数を初期化するために呼ばれる関数によく出てきます（例：[template.Must](https://golang.org/pkg/text/template/#Must)や[regexp.MustCompile](https://golang.org/pkg/regexp/#MustCompile)）。

```go
// Good:
func MustParse(version string) *Version {
    v, err := Parse(version)
    if err != nil {
        log.Fatalf("MustParse(%q) = _, %v", version, err)
    }
    return v
}

// パッケージレベルの「定数」。もし、 `Parse` を使用したいのであれば、 
// `init` で値を設定する必要があったでしょう。
var DefaultVersion = MustParse("1.2.3")
```

注意：`log.Fatal`は、標準ライブラリのログではありません。[logging](#TBD)を参照してください。

現在のテストを停止させるだけのテストヘルパー（`t.Fatal`を使用します）でも、同じ規約を使用することができます。このようなヘルパーは、たとえば[テーブル駆動型テスト](https://google.github.io/styleguide/go/decisions#table-driven-tests)の構造体のフィールドにテスト値を作成する際に便利です。というのもエラーを返す関数は構造体フィールドに直接代入できないためです。

```go
// Good:
func mustMarshalAny(t *testing.T, m proto.Message) *anypb.Any {
  t.Helper()
  any, err := anypb.New(m)
  if err != nil {
    t.Fatalf("MustMarshalAny(t, m) = %v; want %v", err, nil)
  }
  return any
}

func TestCreateObject(t *testing.T) {
  tests := []struct{
    desc string
    data *anypb.Any
  }{
    {
      desc: "my test case",
      // テーブルドリブンテストケース内で直接値を作成します。
      data: mustMarshalAny(t, mypb.Object{}),
    },
    // ...
  }
  // ...
}
```

これら両方のケースにおいて、このパターンの価値は、ヘルパーが「値」のコンテキストで呼び出されることができることです。これらのヘルパーは、エラーを確実に捕捉するのが難しい場所や、エラーを[チェックすべき](#エラー処理)コンテキスト（たとえば多くのリクエストハンドラなど）では呼ばれるべきではありません。定数入力の場合は、`Must`の引数が整形されていることを簡単に確認することができます。また、非定数入力の場合は、[エラーが適切に処理されたり伝搬されたりすること](#TBD)を確認することができます。

`Must`関数がテスト内で使用される場合、一般的には[テストヘルパーとして位置づけ](#TBD)、エラー時に`t.Fatal`をコールするようにします（[テストヘルパーのエラー処理](#TBD)についての考察はこちら）。

[通常のエラー処理](#TBD)が可能な場合は、使用しないでください（多少のリファクタリングも含む）。

```go
// Bad:
func Version(o *servicepb.Object) (*version.Version, error) {
    // Must関数を使用せず、エラーを返してください。
    v := version.MustParse(o.GetVersionString())
    return dealiasVersion(v)
}
```

### ゴルーチンの寿命

ゴルーチンを生成するときは、いつ終了するか、終了するかどうかを明確にします。

ゴルーチンは、チャネルの送受信をブロックすることでリークする可能性があります。ガベージコレクタは、ブロックされたチャネルが到達不能になっても、ゴルーチンを終了させません。

ゴルーチンがリークしない場合でも、不要になったゴルーチンをそのままにしておくと、微妙な問題や診断しにくい問題が発生することがあります。閉じたチャネルで送信するとパニックします。

```go
// Bad:
ch := make(chan int)
ch <- 42
close(ch)
ch <- 13 // panic
```

使用中の入力を「結果が不要になった後」に変更すると、データ競合が発生する可能性があります。ゴルーチンを任意に長い時間放置すると、予測できないメモリ使用量になることがあります。

並行処理するコードは、ゴルーチンの寿命が明らかであるように書かれるべきです。一般的には、同期に関連するコードを関数のスコープ内に制限しておき、ロジックを[同期関数](#TBD)に分解しておくことを意味します。それでも並行処理が明白でない場合、ゴルーチンがいつ、なぜ終了するかをドキュメント化することが重要です。

コンテキストの使用に関するベストプラクティスに従ったコードは、しばしばこれを明確にするのに役立ちます。従来は`context.Context`で管理していました。

```go
// Good:
func (w *Worker) Run(ctx context.Context) error {
    // ...
    for item := range w.q {
        // プロセスは少なくともコンテキストがキャンセルされたときに戻ります。
        go process(ctx, item)
    }
    // ...
}
```

上記の他にも、`chan struct{}`のような生のシグナルチャンネルを使うものや、同期変数、条件変数などの変種があります。重要なのは、ゴルーチンの終了が後続のメンテナにとって明らかであることです。

これに対して、次のコードは、生成されたゴルーチンがいつ終了するかについて不注意です。

```go
// Bad:
func (w *Worker) Run() {
    // ...
    for item := range w.q {
        // プロセスは終了時に、もしあれば、状態遷移やGoプログラム自体の終了を
        // きれいに処理できない可能性があります。
        go process(item)
    }
    // ...
}
```

このコードは問題なく見えるかもしれませんが、いくつかの根本的な問題があります。

- このコードは、実稼働環境ではおそらく未定義の動作をし、オペレーティングシステムがリソースを解放しても、プログラムがきれいに終了しない可能性があります。
- コードのライフサイクルが不明確なため、意味のあるテストが困難です。
- 上記のように、コードがリソースをリークする可能性があります。

こちらもご覧ください。

- [ゴルーチンがどのように停止するかを知らずに起動してはいけない](https://dave.cheney.net/2016/12/22/never-start-a-goroutine-without-knowing-how-it-will-stop)
- 古典的な並行処理パターンの再考: [スライド](https://drive.google.com/file/d/1nPdvhB0PutEJzdCq5ms6UI58dp50fcAN/view)、[ビデオ](https://www.youtube.com/watch?v=5zXAHh5tJqQ)
- [Goプログラムの終了時期](https://changelog.com/gotime/165)

### インターフェース

Goのインターフェースは一般的に、インターフェース型の値を*利用する*パッケージに属し、インターフェース型を*実装する*パッケージには属しません。実装するパッケージは具象型（通常はポインタか構造体）を返すべきです。そうすれば、大規模なリファクタリングを必要とせずに、新しいメソッドを実装に追加することができます。詳しくは[GoTip #49: インターフェースを受け入れ、具象型を返す](https://google.github.io/styleguide/go/index.html#gotip)を参照ください。

あるインターフェースを利用するAPIから、そのインターフェースの[テストダブル](https://abseil.io/resources/swe-book/html/ch13.html#techniques_for_using_test_doubles)実装をエクスポートしてはいけません。そのかわり、[本物の実装](https://google.github.io/styleguide/go/best-practices#use-real-transports)の[公開API](https://abseil.io/resources/swe-book/html/ch12.html#test_via_public_apis)を使ってテストできるようなAPIを設計しましょう。詳しくは [GoTip #42: テスト用のスタブを作成する](https://google.github.io/styleguide/go/index.html#gotip)を参照してください。本当の実装を使うのが難しい場合でも、本当の型のすべてのメソッドを完全にカバーするインターフェイスを導入する必要はないかもしれません。[GoTip #78: 最小限の有効なインターフェース](https://google.github.io/styleguide/go/index.html#gotip)で示されているように、利用者は必要なメソッドのみを含むインターフェイスを作成することができます。

Stubby RPCクライアントを使用するパッケージをテストするには、本物のクライアント接続を使用します。本物のサーバがテストに使えない場合、Googleの内部ではrpctestパッケージを使ってローカルの[テストダブル](https://abseil.io/resources/swe-book/html/ch13.html#techniques_for_using_test_doubles)に本物のクライアント接続を取得するようにしています（近日公開予定）。

使用する前にインターフェースを定義しないでください ([TotT: Code Health: Eliminate YAGNI Smells](https://testing.googleblog.com/2017/08/code-health-eliminate-yagni-smells.html)を参照)。現実的な使用例がないと、どんなメソッドを含むべきかはおろか、インターフェースが必要かどうかさえも判断できません。

パッケージのユーザがパラメータに異なる型を渡す必要がないのであれば、インターフェース型のパラメータを使わないでください。

パッケージのユーザが必要としないインターフェースはエクスポートしないでください。

**TODO**: インターフェイスについてのより詳細なドキュメントを書き、ここにリンクする。

```go
// Good:
package consumer // consumer.go

type Thinger interface { Thing() bool }

func Foo(t Thinger) string { ... }
```

```go
// Good:
package consumer // consumer_test.go

type fakeThinger struct{ ... }
func (t fakeThinger) Thing() bool { ... }
...
if Foo(fakeThinger{...}) == "x" { ... }
```

```go
// Bad:
package producer

type Thinger interface { Thing() bool }

type defaultThinger struct{ ... }
func (t defaultThinger) Thing() bool { ... }

func NewThinger() Thinger { return defaultThinger{ ... } }
```

```go
// Good:
package producer

type Thinger struct{ ... }
func (t Thinger) Thing() bool { ... }

func NewThinger() Thinger { return Thinger{ ... } }
```

### ジェネリクス

ジェネリクス（正式には「型パラメータ」）は、ビジネス上の要件を満たす場合に許可されます。多くのアプリケーションでは、既存の言語機能（スライス、マップ、インターフェースなど）を使用した従来のアプローチが複雑さを増すことなく同様に機能するので、早まった使用には注意が必要です。[最小限のメカニズム](guide.md#最小限のメカニズム)に関する議論を参照してください。

ジェネリクスを使用するエクスポートされたAPIを導入する場合、それが適切にドキュメント化されていることを保証してください。動機となる実行可能な[例](#例)を含めることが強く推奨されます。

メンバー要素の型を気にしないアルゴリズムやデータ構造を実装するからといって、ジェネリクスを使わないでください。もし、実際にインスタンス化される型が1つだけなら、ジェネリクスを全く使わずに、その型に対してコードを動作させることから始めてください。後でポリモーフィズムを追加するのは、不要だと分かった抽象化を削除するのに比べれば簡単でしょう。

ジェネリクスを使ってDSL（domain-specific language）を作らないこと。特に、読者に大きな負担を強いるようなエラー処理の枠組みは導入してはいけません。確立されたエラー処理の慣行を優先させてください。テストでは、特にアサーションライブラリやフレームワークの導入に注意し、有用性の低いテストの失敗を招かないようにします。

一般的には、

- [コードを書け、型を設計するな。](https://www.youtube.com/watch?v=Pa_e9EeCdy8&t=1250s)Robert GriesemerとIan Lance TaylorによるGopherConの講演から。
- もし有用な統一インターフェースを共有するいくつかの型があるならば、そのインターフェースを使って解決策をモデル化することを検討しましょう。ジェネリクスは必要ないかもしれません。
- そうでなければ、`any`型や過剰な[型スイッチ](https://tour.golang.org/methods/16)に頼るのではなく、ジェネリクスを検討してください。

こちらもご覧ください。

- [Goでジェネリクスを使用する](https://www.youtube.com/watch?v=nr8EpUO9jhw)、Ian Lance Taylor による講演
- Goのウェブページにある[ジェネリクスのチュートリアル](https://go.dev/doc/tutorial/generics)

### 値渡し

数バイトを節約するために、関数の引数にポインタを渡さないようにしてください。関数が引数`x`を終始` *x`としてのみ読み取る場合、その引数はポインタであってはなりません。よくある例としては、文字列へのポインタ（`*string`）やインターフェース値へのポインタ（`*io.Reader`）を渡すことが挙げられます。どちらの場合も、値自体は固定サイズであり、直接渡すことができます。

このアドバイスは、大きな構造体や、サイズが大きくなる可能性のある小さな構造体には当てはまりません。特に、プロトコルバッファのメッセージは、一般に値ではなくポインタで処理されるべきです。ポインタ型は `proto.Message`インターフェース（`proto.Marshal, protocmp.Transform`など） を満たしており、プロトコルバッファのメッセージはかなり大きくなることがあり、時間の経過とともに大きくなることがよくあります。

### レシーバの型

メソッドのレシーバは、通常の関数パラメータと同じように、値またはポインタのどちらかで渡すことができます。どちらを選択するかは、そのメソッドがどのメソッドセットの一部であるべきかに基づいて決定されるべきです。

スピードやシンプルさよりも正しさが優先されます。ポインタの値を使わなければならない場合もあります。それ以外の場合は、大きな型や将来的なコードの拡張を考慮してポインターを使用し、単純な古いデータには値を使用します。

以下のリストで、それぞれのケースについて詳しく説明します。

- レシーバがスライスで、メソッドがスライスの再スライスや再割り当てを行わない場合、ポインタではなく値を使用します。

```go
// Good:
type Buffer []byte

func (b Buffer) Len() int { return len(b) }
```

- メソッドがレシーバを更新する必要がある場合、レシーバはポインタである必要があります。

```go
// Good:
type Counter int

func (c *Counter) Inc() { *c++ }

// See https://pkg.go.dev/container/heap.
type Queue []Item

func (q *Queue) Push(x Item) { *q = append([]Item{x}, *q...) }
```

- レシーバが安全にコピーできないフィールドを含む構造体である場合、ポインタレシーバを使用します。一般的な例としては、`sync.Mutex`やその他の同期型があります。

```go
// Good:
type Counter struct {
    mu    sync.Mutex
    total int
}

func (c *Counter) Inc() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.total++
}
```

**ヒント**: コピーしても安全か安全でないかについての情報は、その型の[Godoc](https://pkg.go.dev/time#example-Duration)を確認してください。

- レシーバが「大きな」構造体や配列である場合、ポインタレシーバの方が効率的な場合があります。構造体を渡すことは、そのフィールドまたは要素をすべてメソッドの引数として渡すことと同じです。値で渡すには大きすぎると思われる場合は、ポインタを選択するのがよいでしょう。
- レシーバを変更する他の関数を呼び出したり、同時に実行したりするメソッドで、それらの変更がメソッドから見えないようにする場合は値を使用し、そうでない場合はポインタを使用します。
- レシーバが構造体や配列で、その要素のいずれかを更新する可能性のあるものへのポインタである場合、読者に更新の意図を明確にするために、ポインタレシーバが望ましいです。

```go
// Good:
type Counter struct {
    m *Metric
}

func (c *Counter) Inc() {
    c.m.Add(1)
}
```

- レシーバが整数や文字列などの[組み込み型](https://pkg.go.dev/builtin)であり、変更の必要がない場合は値を使用します。
  
```go
// Good:
type User string

func (u User) String() { return string(u) }
```

- レシーバがマップ、関数、チャンネルの場合は、ポインタではなく、値を使用します。

```go
// Good:
// See https://pkg.go.dev/net/http#Header.
type Header map[string][]string

func (h Header) Add(key, value string) { /* omitted */ }
```

- レシーバが「小さな」配列や構造体で、更新可能性があるフィールドやポインタがない値型である場合、通常、値レシーバが正しい選択となります。

```go
// Good:
// See https://pkg.go.dev/time#Time.
type Time struct { /* omitted */ }

func (t Time) Add(d Duration) Time { /* omitted */ }
```

- 迷ったらポインターレシーバーを使ってください。

一般的なガイドラインとして、ある型のメソッドをすべてポインタメソッドまたはすべて値メソッドにすることが望ましいです。

**注意**: 関数に値を渡すかポインタを渡すかでパフォーマンスに影響が出るかどうかについては、誤った情報が多いです。コンパイラは、スタック上の値のコピーと同様に、スタック上の値へのポインタを渡すことを選択できますが、これらの考慮事項は、ほとんどの状況でコードの可読性と正しさに勝るものではありません。性能が問題になる場合、一方のアプローチが他方より優れていると判断する前に、現実的なベンチマークで両方のアプローチのプロファイリングを行うことが重要です。

### `switch`と`break`

`switch`句の末尾にターゲットラベルのない`break`文を使用しないでください。冗長です。CやJavaとは異なり、Goの`switch`句は自動的にブレークします。Cスタイルの動作を実現するには、`fallthrough`文が必要です。空の節の目的をはっきりさせたい場合は、`break`ではなくコメントを使用してください。

```go
// Good:
switch x {
case "A", "B":
    buf.WriteString(x)
case "C":
    // スイッチ文の外側で処理される
default:
    return fmt.Errorf("unknown value: %q", x)
}
```

```go
// Bad:
switch x {
case "A", "B":
    buf.WriteString(x)
    break // このbreakは冗長です
case "C":
    break // このbreakは冗長です
default:
    return fmt.Errorf("unknown value: %q", x)
}
```

**注意**: `switch`節が`for`ループ内にある場合、`switch`内で`break`を使用しても、囲んでいる`for`ループは終了しません。

```go
for {
  switch x {
  case "A":
     break // ループではなく、スイッチを終了させる
  }
}
```

囲んでいるループから抜け出すには、`for`文でラベルを使います。

```go
loop:
  for {
    switch x {
    case "A":
       break loop // exits the loop
    }
  }
```

### 同期関数

同期関数は結果を直接返し、コールバックやチャンネル操作を終了させてから返します。非同期関数よりも同期関数を優先してください。

同期関数は、ゴルーチンを呼び出しの中でローカライズします。これにより、ゴルーチンの寿命を推定し、リークやデータ競合を回避することができます。また、同期関数は、呼び出し側がポーリングや同期を必要とせずに入力を渡し、出力をチェックできるため、テストが容易です。

必要であれば、呼び出し元は別のゴルーチンで関数を呼び出すことで並行処理を追加することができます。しかし、呼び出し側で不要な同時実行を取り除くことは非常に困難です（不可能な場合もあります）。

こちらもご参照ください。

- Bryan Mills氏による講演「古典的な並行処理パターンの再考」: [スライド](https://drive.google.com/file/d/1nPdvhB0PutEJzdCq5ms6UI58dp50fcAN/view)、[ビデオ](https://www.youtube.com/watch?v=5zXAHh5tJqQ)

### 型エイリアス

新しい型を定義するには、*型定義*`type T1 T2`を使用します。新しい型を定義せずに既存の型を参照するには、[型エイリアス](http://golang.org/ref/spec#Type_declarations)`type T1 = T2`を使用します。型エイリアスはまれなもので、主な用途は、パッケージを新しいソースコードの場所に移行するのを助けることです。必要でない場合は、型エイリアスを使用しないでください。

### %qの使用

Goのフォーマット関数（`fmt.Printf`など）には、ダブルクォーテーションで囲まれた文字列を表示する`%q`バーブがあります。

```go
// Good:
fmt.Printf("value %q looks like English text", someText)
```

`%s`を使って手動で同等のことをするよりも、`%q`を使うことを優先してください。

```go
// Bad:
fmt.Printf("value \"%s\" looks like English text", someText)
// 文字列を手動でシングルクオートで折り返すことも避けてください。
fmt.Printf("value '%s' looks like English text", someText)
```

人間向けの出力で、入力値が空であったり制御文字を含む可能性がある場合は、`%q`を使用することをお勧めします。沈黙の空文字列に気づくのは非常に困難ですが、`""`は明らかに空文字列として目立ちます。

### anyの使用

Go 1.18 では、`interface{}`の[エイリアス](https://go.googlesource.com/proposal/+/master/design/18130-type-alias.md)として`any`型が導入されました。エイリアスなので、`any`は多くの状況で`interface{}`と同等ですが、他の状況では明示的な変換によって簡単に置き換えることができます。新しいコードでは`any`を使うことを優先してください。

## 共通ライブラリ

### フラグ

GoogleのコードベースにおけるGoプログラムは、[標準の`flag`パッケージ](https://golang.org/pkg/flag/)の内部バージョン を使用しています。これは似たようなインターフェイスですが、Googleの内部システムとの相互運用性が高いです。Goバイナリのフラグ名は、アンダースコアで単語を区切るのが好ましいですが、 フラグの値を保持する変数は標準の Go名スタイル（[ミックスキャップ](guide.md#ミックスキャップ）に従わなければなりません。具体的には、フラグ名はスネークケースで、変数名はキャメルケースで同等の名前にします。

```go
// Good:
var (
    pollInterval = flag.Duration("poll_interval", time.Minute, "Interval to use for polling.")
)
```

```go
// Bad:
var (
    poll_interval = flag.Int("pollIntervalSeconds", 60, "Interval to use for polling in seconds.")
)
```

フラグは、`package main`またはそれに相当するパッケージでのみ定義する必要があります。

汎用パッケージはコマンドラインインターフェイスではなく、GoのAPIを使って設定する必要があります。つまり、明示的な関数引数や構造体フィールドの割り当て、あるいは、あまり頻繁ではありませんが、厳密な精査のもとでエクスポートされたグローバル変数が望ましいのです。このルールを破る必要がある極めて稀なケースとして、フラグの名前に設定するパッケージを明示する必要があります。

フラグがグローバル変数である場合、importsのセクションにしたがって、独自の`var`グループに配置してください。

サブコマンドを含む[複雑なCLI](#TBD)を作成するためのベストプラクティスに関する追加的な議論があります。

こちらもご覧ください。

- [Tip of the Week #45: 特にライブラリコードではフラグを避けること](https://abseil.io/tips/45)
- [Go Tip #10: 設定用構造体とフラグ](https://google.github.io/styleguide/go/index.html#gotip)
- [Go Tip #80: 依存性注入の原則](https://google.github.io/styleguide/go/index.html#gotip)

### ロギング

GoogleのコードベースのGoプログラムは、[標準の`log`パッケージ](https://pkg.go.dev/log)の変種を使用しています。類似していますがより強力なインターフェイスで、Googleの内部システムともうまく連動しています。このライブラリのオープンソース版は[package glog](https://pkg.go.dev/github.com/golang/glog)として提供されており、 オープンソースのGoogleプロジェクトではそちらを使用することができますが、 このガイドでは全体を通して`log`と表記します。

**注意**: プログラムが異常終了した場合、このライブラリは`log.Fatal` を使ってスタックトレース付きで異常終了させ、`log.Exit`を使ってスタックトレースなしで停止させます。標準ライブラリのような`log.Panic`関数はありません。

**ヒント**: `log.Info(v)`は`log.Infof("%v", v)`と同等で、他のロギングレベルも同様です。フォーマットする必要がないときは、非フォーマットバージョンを優先してください。

こちらもご覧ください。

- [エラーロギング](#TBD)と[カスタム冗長レベル](#TBD)のロギングに関するベストプラクティス
- ログパッケージを使用して[プログラムを停止する](#TBD)タイミングと方法

### コンテキスト

`context.Context`型の値は、セキュリティ認証情報、トレース情報、デッドライン、キャンセルシグナルなどを APIやプロセスの境界を越えて伝達します。Googleのコードベースでは、スレッドローカルのストレージを使用するC++やJavaとは異なり、GoプログラムではRPCや HTTPリクエストの受信から送信までの関数呼び出しチェーン全体で明示的にコンテキストが渡されます。

関数やメソッドに渡されるとき、`context.Context`は常に最初のパラメータになります。

```go
func F(ctx context.Context /* 他の引数 */) {}
```

例外は、

- HTTP ハンドラでは、コンテキストは[`req.Context()`](https://pkg.go.dev/net/http#Request.Context) から取得されます。
- ストリーミング RPC メソッドでは、コンテキストはストリームから取得されます。
gRPC ストリーミングを使用するコードは、`grpc.ServerStream`を実装した生成されたサーバ型の`Context()`メソッドからコンテキストにアクセスします。[gRPC Generated Codeのドキュメント](https://grpc.io/docs/languages/go/generated-code/)を参照してください。
- エントリポイント関数（そのような関数の例については下記を参照）では、[`context.Background()`](https://pkg.go.dev/context/#Background)を使用します。
  - バイナリターゲット: `main`
  - 汎用コードやライブラリ: `init`
  - テスト: `TestXXX`、`BenchmarkXXX`、`FuzzXXX`

**注意**: コールチェーンの途中のコードで、`context.Background()`を使って独自のベースコンテキストを作成する必要があるのは、非常に稀なケースです。間違ったコンテキストでない限り、常に呼び出し元からコンテキストを取得するようにしましょう。

サーバライブラリ（Stubby や gRPC、Google の Go 用サーバフレームワークの HTTP など）では、リクエストごとに新しいコンテキストオブジェクトを構築しているのを目にすることがあります。これらのコンテキストは受信したリクエストの情報ですぐに埋め尽くされ、リクエストハンドラに渡されたときには、コンテキストに付加された値がクライアントの呼び出し元からネットワーク境界を越えて伝搬されています。さらに、これらのコンテキストの寿命は、リクエストの寿命と同じです。

サーバフレームワークを実装しているのでなければ、ライブラリのコードで`context.Background()`を使ってコンテキストを作成するべきではありません。その代わり、既存のコンテキストがある場合は、後述するコンテキストデタッチメントを使用することを優先してください。エントリポイント関数以外で`context.Background()`が必要だと思う場合は、実装をコミットする前に Google Go スタイルメーリングリストで議論してください。

関数では`context.Context`が最初に来るという慣習は、テストヘルパーにも適用されます。

```go
// Good:
func readTestFile(ctx context.Context, t *testing.T, path string) string {}
```

構造体型にコンテキストメンバを追加しないでください。そのかわりに、その型のメソッドにコンテキストパラメータを追加します。例外は、標準ライブラリやサードパーティライブラリにある インターフェースとシグネチャが一致する必要があるメソッドです。このようなケースは非常に稀なので、実装や可読性のレビューの前にGoogle Goスタイルメーリングリストで議論する必要があります。

Googleのコードベースの中で、親コンテキストがキャンセルされた後に実行できるバックグラウンド操作を生成しなければならないコードは、デタッチメントのために内部パッケージを使用することができます。オープンソースの代替案については、[issue #40221](https://github.com/golang/go/issues/40221)を参照してください。

コンテキストは不変なので、同じデッドライン、キャンセルシグナル、クレデンシャル、親トレースなどを共有する複数の呼び出しに同じコンテキストを渡しても問題ありません。

こちらもご覧ください。

- [コンテキストと構造体](https://go.dev/blog/context-and-structs)

#### カスタムコンテキスト

カスタムのコンテキスト型を作成したり、関数のシグネチャでコンテキスト以外のインターフェースを使用しないでください。このルールに例外はありません。

もしすべてのチームがカスタムコンテキストを持っていたらと想像してください。パッケージPからパッケージQへの関数呼び出しは、パッケージPとQのすべてのペアについて、`PContext`を`QContext`に変換する方法を決定しなければならないでしょう。これは人間にとって非現実的で、エラーを起こしやすく、コンテキストパラメータを追加する自動リファクタリングをほぼ不可能にします。

アプリケーションのデータを渡す場合は、パラメータやレシーバ、グローバル、あるいはContextの値（本当にそこに属するものであれば）に入れるようにしましょう。独自の Context 型を作成することは、Goプログラムをプロダクション環境で正しく動作させるというGoチームの能力を損なうため、認められません。

### crypto/rand

キーを生成するために、たとえ使い捨てのものであっても`math/rand`パッケージを使わないでください。シードされない場合、ジェネレータは完全に予測可能です。`time.Nanoseconds()`でシードされた場合、ほんの数ビットのエントロピーが存在します。テキストが必要な場合は、16進数かbase64で出力してください。

```go
// Good:
import (
    "crypto/rand"
    // "encoding/base64"
    // "encoding/hex"
    "fmt"

    // ...
)

func Key() string {
    buf := make([]byte, 16)
    if _, err := rand.Read(buf); err != nil {
        log.Fatalf("Out of randomness, should never happen: %v", err)
    }
    return fmt.Sprintf("%x", buf)
    // or hex.EncodeToString(buf)
    // or base64.StdEncoding.EncodeToString(buf)
}
```

**注意**: `log.Fatalf`は標準ライブラリのログではありません。[ロギング](#ロギング)を参照してください。

## 有用なテスト失敗

テストの失敗を、テストのソースを読まなくても診断できるようにすべきです。テストが失敗した際には、以下のような有用なメッセージが表示されるようにしましょう。

- 何が原因で失敗したのか
- どの入力がエラーになったのか
- 実際の結果
- 期待された結果

この目標を達成するための具体的な規約を以下に示します。

### アサーションライブラリ

テスト用のヘルパーとして「アサーションライブラリ」を作らないでください。

アサーションライブラリは、失敗メッセージの検証や生成をテスト内にまとめようとするライブラリです（ただし、他のテストヘルパーにも同じ落とし穴があります）。テストヘルパーとアサーションライブラリの区別については、 [ベストプラクティス](#TBD)を参照してください。

```go
// Bad:
var obj BlogPost

assert.IsNotNil(t, "obj", obj)
assert.StringEq(t, "obj.Type", obj.Type, "blogPost")
assert.IntEq(t, "obj.Comments", obj.Comments, 2)
assert.StringNotEq(t, "obj.Body", obj.Body, "")
```

アサーションライブラリは、テストを早期に停止させるか （`assert`が`t.Fatalf`を呼び出したり`panic`を起こしたりした場合）、テストが正しく行われたかについての関連情報を省略しがちです。

```go
// Bad:
package assert

func IsNotNil(t *testing.T, name string, val interface{}) {
    if val == nil {
        t.Fatalf("data %s = nil, want not nil", name)
    }
}

func StringEq(t *testing.T, name, got, want string) {
    if got != want {
        t.Fatalf("data %s = %q, want %q", name, got, want)
    }
}
```

複雑なアサーション関数は、有用な失敗メッセージやテスト関数内に存在するコンテキストを提供しないことがよくあります。アサーション関数やライブラリが多すぎるため、開発者体験が断片的になってしまいます。どのアサーションライブラリを使うべきか、どのような出力形式を出すべきかなどにおいてです。特に、ライブラリのメンテナや大規模な変更の作成者は、下流で発生しうる不具合を修正する責任があります。テスト用にドメイン固有の言語を作成する代わりに、Goそのものを使いましょう。

アサーションライブラリは、しばしば比較や等値チェックを省きます。代わりに`cmp`や`fmt`のような標準的なライブラリを使用することを優先してください。

```go
// Good:
var got BlogPost

want := BlogPost{
    Comments: 2,
    Body:     "Hello, world!",
}

if !cmp.Equal(got, want) {
    t.Errorf("blog post = %v, want = %v", got, want)
}
```

よりドメインに特化した比較ヘルパーでは、`*testing.T`を渡してそのエラー報告メソッドを呼び出すのではなく、テストの失敗メッセージで使用できる値やエラーを返すようにしましょう。

```go
// Good:
func postLength(p BlogPost) int { return len(p.Body) }

func TestBlogPost_VeritableRant(t *testing.T) {
    post := BlogPost{Body: "I am Gunnery Sergeant Hartman, your senior drill instructor."}

    if got, want := postLength(post), 60; got != want {
        t.Errorf("length of post = %v, want %v", got, want)
    }
}
```

**ベストプラクティス**: `postLength`が自明でない場合、それを使用するテストとは別に、直接それをテストすることは理にかなっています。

こちらもご覧ください。

- [等価比較と差分](#TBD)
- [差分のプリント](#TBD)
- テストヘルパーとアサーションヘルパーの区別については[ベストプラクティス](#TBD)を参照ください

### 関数の識別

ほとんどのテストでは、失敗メッセージには失敗した関数の名前が含まれているはずです。具体的には、失敗のメッセージは単に`got %v, want %v`ではなく、`YourFunc(%v) = %v, want %v`とすべきです。

### 入力の識別

ほとんどのテストでは、失敗メッセージに関数の入力が含まれているはずです。入力の関連する性質が明らかでない場合（たとえば入力が大きかったり、不明瞭だったりするとき）、テストケースにはテスト対象の説明をつけて、エラーメッセージの一部としてその説明を表示するようにします。

### 期待する値の前に実際の値

テスト出力には、期待された値を表示する前に、関数が実際に返した値を含める必要があります。テスト出力を表示するための標準的な書式は`YourFunc(%v) = %v, want %v`です。「actual」と「expected」と書くところは、それぞれ「got」と「want」という言葉を優先してください。

差分については、方向性はあまり明確ではありません。そのため、失敗を解釈するのに役立つキーを含めることが重要です。[差分のプリント](#TBD)のセクションを参照してください。失敗メッセージでどの差分の順番を使うにしても、失敗メッセージの一部として明示的に示すべきです。既存のコードは順番について一貫性がないからです。

### 構造全体の比較

関数が構造体（またはスライス、配列、マップなど複数のフィールドを持つデータ型）を返す場合、構造体のフィールドごとの比較を手作業で行うテスト コードを書くのは避けてください。その代わり、関数が返すと予想されるデータを作成し、[深い比較](#TBD)を使って直接比較します。

**注意**: データに無関係なフィールドが含まれていて、テストの意図が不明になっている場合は、この限りではありません。

構造体を近似的な（または同等の意味での）等価性で比較する必要がある場合や、等価性で比較できないフィールドが含まれている場合（フィールドの1つが`io.Reader`の場合など）、[`cmpopts.IgnoreInterfaces`](https://pkg.go.dev/github.com/google/go-cmp/cmp/cmpopts#IgnoreInterfaces)などの[`cmpopts`](https://pkg.go.dev/github.com/google/go-cmp/cmp/cmpopts)オプションで、[`cmp.Diff`](https://pkg.go.dev/github.com/google/go-cmp/cmp/cmp#Diff)または[`cmp.Equal`](https://pkg.go.dev/github.com/google/go-cmp/cmp#Equal)比較を調整すれば要件を満たす場合があります（[例](https://play.golang.org/p/vrCUNVfxsvF)）。

関数が複数の戻り値を返す場合、それらを構造体でラップしてから比較する必要はありません。返り値を個別に比較し、それを表示するだけです。

```go
// Good:
val, multi, tail, err := strconv.UnquoteChar(`\"Fran & Freddie's Diner\"`, '"')
if err != nil {
  t.Fatalf(...)
}
if val != `"` {
  t.Errorf(...)
}
if multi {
  t.Errorf(...)
}
if tail != `Fran & Freddie's Diner"` {
  t.Errorf(...)
}
```
