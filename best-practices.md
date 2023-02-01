# Goスタイルベストプラクティス

https://google.github.io/styleguide/go/best-practices

注意: このドキュメントは、Googleでの[Goスタイル](https://google.github.io/styleguide/go/index)の概要を説明する一連のドキュメントの一部です。このドキュメントは規範的なものでも標準的なものではなく、[コアスタイルガイド](guide.md)に従属するものです。詳しくは、[概要](README.md#概要)をご覧ください。

## 概要

このファイルは、**Goスタイルガイドの最適な適用方法に関するガイダンス**を文書化したものです。このガイダンスは、頻繁に発生する一般的な状況を対象としていますが、すべての状況で適用されるとは限りません。可能な限り、複数の代替アプローチを、いつ、どのような場合に適用するかを決定するための考慮事項とともに説明しています。

スタイルガイドの全ドキュメントを見るには、[概要](README.md#概要)をご覧ください。

## 命名

### 関数とメソッド名

#### 繰り返しを避ける

関数やメソッドの名前を決めるときは、その名前が読まれるときのコンテキストを考慮してください。呼び出し元での過剰な[繰り返し](decisions.md#繰り返し)を避けるため、以下の推奨事項を考慮してください。

- 以下の項目は、一般的に関数名やメソッド名から省略することができます。
  - 入力と出力の型（衝突がない場合）
  - メソッドのレシーバの型
  - 入力または出力がポインタであるかどうか

- 関数については、[パッケージ名を繰り返し](decisions.md#パッケージ名とエクスポートされたシンボル名)ません。

```go
// Bad:
package yamlconfig

func ParseYAMLConfig(input string) (*Config, error)
```

```go
// Good:
package yamlconfig

func Parse(input string) (*Config, error)
```

- メソッドの場合、メソッドのレシーバの名前を繰り返しません。

```go
// Bad:
func (c *Config) WriteConfigTo(w io.Writer) (int64, error)
```

```go
// Good:
func (c *Config) WriteTo(w io.Writer) (int64, error)
```

- パラメータとして渡される変数名を繰り返しません。

```go
// Bad:
func OverrideFirstWithSecond(dest, source *Config) error
```

```go
// Good:
func Override(dest, source *Config) error
```

- 戻り値の名前と型を繰り返しません。

```go
// Bad:
func TransformYAMLToJSON(input *Config) *jsonconfig.Config
```

```go
// Good:
func Transform(input *Config) *jsonconfig.Config
```

類似した名前の関数の曖昧さをなくすために必要な場合は、余分な情報を含めてもかまいません。

```go
// Good:
func (c *Config) WriteTextTo(w io.Writer) (int64, error)
func (c *Config) WriteBinaryTo(w io.Writer) (int64, error)
```

#### 命名規則

関数やメソッドの名前を決める際には、他にもいくつかの共通した慣例があります。

- 何かを返す関数には、名詞のような名前を付けます。

```go
// Good:
func (c *Config) JobName(key string) (value string, ok bool)
```

このことから、関数名やメソッド名には[接頭辞`Get`を付けるべきではありません](decisions.md#ゲッター)。

```go
// Bad:
func (c *Config) GetJobName(key string) (value string, ok bool)
```

- 何かをする関数には動詞のような名前をつけます。

```go
// Good:
func (c *Config) WriteDetail(w io.Writer) (int64, error)
```

- 型が異なるだけで同一の関数には、名前の最後に型の名前を付けます。

```go
// Good:
func ParseInt(input string) (int, error)
func ParseInt64(input string) (int64, error)
func AppendInt(buf []byte, value int) []byte
func AppendInt64(buf []byte, value int64) []byte
```

明確な「主」バージョンがある場合、そのバージョンの名前から型を省略できます。

```go
// Good:
func (c *Config) Marshal() ([]byte, error)
func (c *Config) MarshalText() (string, error)
```

### テストダブルパッケージと型

テストヘルパー、特にテストダブルを提供するパッケージや型の[命名](guide.md#命名)に適用できる規則がいくつかあります。[テストダブル](https://abseil.io/resources/swe-book/html/ch13.html#basic_concepts)は、スタブ、フェイク、モック、スパイのいずれかです。

これらの例では、ほとんどスタブを使っています。もしあなたのコードがフェイクや他の種類のテストダブルを使用している場合は、 それに応じて名前を更新してください。

このようなプロダクションコードを提供する、焦点を絞ったパッケージがあるとします。

```go
package creditcard

import (
    "errors"

    "path/to/money"
)

// ErrDeclined indicates that the issuer declines the charge.
var ErrDeclined = errors.New("creditcard: declined")

// Card contains information about a credit card, such as its issuer,
// expiration, and limit.
type Card struct {
    // 省略
}

// Service allows you to perform operations with credit cards against external
// payment processor vendors like charge, authorize, reimburse, and subscribe.
type Service struct {
    // 省略
}

func (s *Service) Charge(c *Card, amount money.Money) error { /* 省略 */ }
```

#### テストヘルパーパッケージの作成

たとえば、あるパッケージを作成し、その中に別のパッケージのテストダブルを含めるとします。この例では、`package creditcard`（上記）を使用します。

ひとつの方法として、テスト用に本番用のパッケージをベースにした新しいGoパッケージを導入することができます。安全な方法は、元のパッケージ名に`test`という単語を追加することです（「creditcard」 + 「test」）。

```go
// Good:
package creditcardtest
```

特に明示しない限り、以下のセクションの例はすべて`package creditcardtest`です。

#### シンプルなケース

`Service`のテストダブルのセットを追加したいします。`Card`は事実上、プロトコルバッファメッセージと同様のダムデータ型なので、 テストで特別な処理をする必要はなく、ダブルは必要ありません。もし、1つの型（`Service`など）のみをテストするのであれば、ダブルの名前を簡潔にすることができます。

```go
// Good:
import (
    "path/to/creditcard"
    "path/to/money"
)

// Stub stubs creditcard.Service and provides no behavior of its own.
type Stub struct{}

func (Stub) Charge(*creditcard.Card, money.Money) error { return nil }
```

これは、`StubService`や`StubCreditCardService`のような貧弱な命名法よりもはるかに望ましい選択です。なぜなら、ベースパッケージ名とそのドメインタイプは、`creditcardtest.Stub`が何であるかを暗示しているからです。

最後に、もしパッケージがBazelでビルドされている場合、そのパッケージの新しい`go_library`ルールが`testonly`としてマークされていることを確認してください。

```go
# Good:
go_library(
    name = "creditcardtest",
    srcs = ["creditcardtest.go"],
    deps = [
        ":creditcard",
        ":money",
    ],
    testonly = True,
)
```

上記の考え方は慣用的なものであり、他の技術者にも相応に理解されるでしょう。

つぎの記事もご覧ください。

- [Go Tip #42: テスト用スタブの作成](https://google.github.io/styleguide/go/index.html#gotip)

#### テストダブルの複数の挙動

一種類のスタブでは不十分な場合（たとえば、常に失敗するスタブも必要な場合）、エミュレートする動作に応じてスタブに名前を付けることを推奨します。ここでは、`Stub`を`AlwaysCharges`に変更し、`AlwaysDeclinesPという新しいスタブを導入しています。

```go
// Good:
// AlwaysCharges stubs creditcard.Service and simulates success.
type AlwaysCharges struct{}

func (AlwaysCharges) Charge(*creditcard.Card, money.Money) error { return nil }

// AlwaysDeclines stubs creditcard.Service and simulates declined charges.
type AlwaysDeclines struct{}

func (AlwaysDeclines) Charge(*creditcard.Card, money.Money) error {
    return creditcard.ErrDeclined
}
```

#### 複数の型の複数のダブル

しかし、ここで`Service`と`StoredValue`のように、`package creditcard`には、ダブルを作成する価値のある複数の型が含まれているとします。

```go
package creditcard

type Service struct {
    // 省略
}

type Card struct {
    // 省略
}

// StoredValueは顧客のクレジット残高を管理します。これは、返品された商品をクレジット発行会社で処理せず、
// 顧客のローカルアカウントに入金する場合に適用されます。
// そのため、別サービスとして実装しています。
type StoredValue struct {
    // 省略
}

func (s *StoredValue) Credit(c *Card, amount money.Money) error { /* 省略 */ }
```

この場合、より明示的なテストダブルの命名が賢明です。

```go
// Good:
type StubService struct{}

func (StubService) Charge(*creditcard.Card, money.Money) error { return nil }

type StubStoredValue struct{}

func (StubStoredValue) Credit(*creditcard.Card, money.Money) error { return nil }
```

#### テストにおけるローカル変数

テストの変数がダブルを参照する場合は、コンテキストから他のプロダクションタイプとダブルを明確に区別できるような名前を選択します。テストしたいプロダクションコードを考えてみましょう。

```go
package payment

import (
    "path/to/creditcard"
    "path/to/money"
)

type CreditCard interface {
    Charge(*creditcard.Card, money.Money) error
}

type Processor struct {
    CC CreditCard
}

var ErrBadInstrument = errors.New("payment: instrument is invalid or expired")

func (p *Processor) Process(c *creditcard.Card, amount money.Money) error {
    if c.Expired() {
        return ErrBadInstrument
    }
    return p.CC.Charge(c, amount)
}
```

テストでは、`CreditCard`の「スパイ」と呼ばれるテストダブルがプロダクション型と並列に配置されているので、名前にプレフィックスを付けることで分かりやすさが向上する可能性があります。

```go
// Good:
package payment

import "path/to/creditcardtest"

func TestProcessor(t *testing.T) {
    var spyCC creditcardtest.Spy

    proc := &Processor{CC: spyCC}

    // 宣言省略: cardとamount
    if err := proc.Process(card, amount); err != nil {
        t.Errorf("proc.Process(card, amount) = %v, want %v", got, want)
    }

    charges := []creditcardtest.Charge{
        {Card: card, Amount: amount},
    }

    if got, want := spyCC.Charges, charges; !cmp.Equal(got, want) {
        t.Errorf("spyCC.Charges = %v, want %v", got, want)
    }
}
```

これは、名前にプレフィックスが付いていない場合よりも明確です。

```go
// Bad:
package payment

import "path/to/creditcardtest"

func TestProcessor(t *testing.T) {
    var cc creditcardtest.Spy

    proc := &Processor{CC: cc}

    // 宣言省略: cardとamount
    if err := proc.Process(card, amount); err != nil {
        t.Errorf("proc.Process(card, amount) = %v, want %v", got, want)
    }

    charges := []creditcardtest.Charge{
        {Card: card, Amount: amount},
    }

    if got, want := cc.Charges, charges; !cmp.Equal(got, want) {
        t.Errorf("cc.Charges = %v, want %v", got, want)
    }
}
```

### シャドーイング

注意: この説明では、*ストンピング*と*シャドーイング*という2つの非公式な用語を使っています。これらはGo言語仕様の公式な概念ではありません。

多くのプログラミング言語と同様に、Goにはミュータブル変数があります。

```go
// Good:
func abs(i int) int {
    if i < 0 {
        i *= -1
    }
    return i
}
```

[短い変数宣言](https://go.dev/ref/spec#Short_variable_declarations)を`:=`演算子で使用する場合、場合によっては新しい変数が作成されないことがあります。これをストンプと呼びます。元の値が不要になったときに行うときは問題ありません。

```go
// Good:
// innerHandlerはリクエストハンドラのヘルパーで、
// それ自身が他のバックエンドにリクエストを発行します。
func (s *Server) innerHandler(ctx context.Context, req *pb.MyRequest) *pb.MyResponse {
    // リクエスト処理のこの部分の期限を無条件で制限します。
    ctx, cancel := context.WithTimeout(ctx, 3*time.Second)
    defer cancel()
    ctxlog.Info(ctx, "Capped deadline in inner request")

    // ここでのコードは、もう元のコンテキストにアクセスすることはできません。
    // これは、最初にこれを書いたときに、コードが大きくなっても
    // 呼び出し元が提供した（おそらくバインドされていない）元のコンテキストを
    // 正当に使うべき操作がないことを予期している場合、良いスタイルです。

    // ...
}
```

しかし、新しいスコープで短い変数宣言を使用すると、新しい変数が導入されることになるので注意が必要です。これを元の変数のシャドーイングと呼びます。ブロックの終わりから先のコードは元の変数を参照します。以下は、条件付きで期限を短くするバグのような例です。

```go
// Bad:
func (s *Server) innerHandler(ctx context.Context, req *pb.MyRequest) *pb.MyResponse {
    // 条件付きで期限の上限を設定することを試みます。
    if *shortenDeadlines {
        ctx, cancel := context.WithTimeout(ctx, 3*time.Second)
        defer cancel()
        ctxlog.Info(ctx, "Capped deadline in inner request")
    }

    // バグ: ここでも「ctx」は呼び出し元が提供したコンテキストを意味します。
    // 上記のバグがあるコードがコンパイルされたのは、
    // if文の中でctxとcancelの両方が使われていたためです。

    // ...
}
```

正しいバージョンのコードはこうかもしれません。

```go
// Good:
func (s *Server) innerHandler(ctx context.Context, req *pb.MyRequest) *pb.MyResponse {
    if *shortenDeadlines {
        var cancel func()
        // 単純な代入である「=」を使い、「:=」を使わないことに注意します。
        ctx, cancel = context.WithTimeout(ctx, 3*time.Second)
        defer cancel()
        ctxlog.Info(ctx, "Capped deadline in inner request")
    }
    // ...
}
```

ストンプと呼んだ場合、新しい変数がないため、代入される型は元の変数と一致しなければなりません。シャドーイングでは、全く新しい実体が導入されるので、異なる型を持つことができます。意図的なシャドーイングは便利な方法ですが、[明確さ](guide.md#明確さ)が向上するのであれば、いつでも新しい名前を使用することができます。

標準パッケージと同じ名前の変数を使用することは、非常に小さなスコープを除いて、良いアイデアではありません。逆に、パッケージの名前を決める際には、[インポートの名前変更](decisions.md#インポート名変更)が必要になるような名前や、クライアント側で他の良い変数名のシャドーイングを引き起こすような名前は避けてください。

```go
// Bad:
func LongFunction() {
    url := "https://example.com/"
    // おっと、これで以下のコードでnet/urlが使えなくなりましたね。
}
```

### Utilパッケージ

Goのパッケージは、インポートパスとは別に、`package`宣言で名前が指定されます。パッケージ名は、パスよりも読みやすさのために重要です。

Go のパッケージ名は、[そのパッケージが提供するもの](decisions.md#パッケージ名)に関連したものであるべきです。パッケージの名前を`util`、`helper`、`common`やそれに類するものにするだけでは、たいてい間違った選択です（名前の*一部*として使用することはできます）。また、あまりに広範に使用すると、無用な[インポートの衝突](decisions.md#インポート名変更)を引き起こしかねません。

その代わりに、呼び出し元がどのようなものになるかを考えてください。

```go
// Good:
db := spannertest.NewDatabaseFromFile(...)

_, err := f.Seek(0, io.SeekStart)

b := elliptic.Marshal(curve, x, y)
```

importsリスト（`cloud.google.com/go/spanner/spanertest`、`io`、`crypto/elliptic`）を知らなくても、それぞれが何をするのか大体わかると思います。あまり焦点を絞らない名前にすると、これらは次のようになります。


```go
// Bad:
db := test.NewDatabaseFromFile(...)

_, err := f.Seek(0, common.SeekStart)

b := helper.Marshal(curve, x, y)
```

## パッケージサイズ

Go パッケージの大きさはどれくらいにすべきか、関連する型を同じパッケージに入れるべきか、別のパッケージに分けるべきかを自問しているなら、[パッケージ名に関するGoブログのポスト](https://go.dev/blog/package-names)から始めるとよいでしょう。記事のタイトルに反して、この記事は命名についてのみ書かれているわけではありません。この記事には役に立つヒントが含まれており、いくつかの有用な記事や講演を引用しています。

以下は、その他の検討事項や注意事項です。

ユーザーはパッケージの[godoc](https://pkg.go.dev/)を1つのページで見ることができ、パッケージが提供する型によってエクスポートされるメソッドはその型によってグループ化されます。Godocはまた、コンストラクタをそれらが返す型とともにグループ化します。*クライアントコード*が、異なる型の2つの値を相互に作用させる必要がありそうな場合、それらを同じパッケージで持つことは、ユーザーにとって便利かもしれません。

パッケージ内のコードは、パッケージ内のエクスポートされていない識別子にアクセスすることができます。関連する型がいくつかあり、その実装が密結合している場合、それらを同じパッケージに入れることで、公開APIをこれらの詳細で汚染することなく、結合を実現することができます。

とはいえ、プロジェクト全体を一つのパッケージに入れてしまうと、パッケージが大きくなりすぎてしまいます。コンセプトがはっきりしているものは、それ専用の小さなパッケージにしておくと使い勝手がよくなります。クライアントが知っているパッケージの短い名前と、エクスポートされた型名が一緒になって、意味のある識別子（例: `bytes.Buffer`、`ring.New`）が作られます。この[ブログの記事](https://go.dev/blog/package-names)には、さらに多くの例が掲載されています。

Goスタイルはファイルサイズに関して柔軟性があります。なぜなら、メンテナは呼び出し元に影響を与えることなく、パッケージ内のコードをあるファイルから別のファイルに移動することができるからです。しかし、一般的なガイドラインとして、1つのファイルに何千行もあったり、小さなファイルがたくさんあったりするのは、通常良いことではありません。他の言語にあるような「一つの型には一ファイル」の規約はありません。経験則から言うと、ファイルは、メンテナがどのファイルに何かが入っているか分かる程度に集中しているべきで、ファイルは、いったんそこにあれば簡単に見つけられる程度に小さくあるべきでしょう。標準ライブラリは、しばしば大きなパッケージをいくつかのソースファイルに分割し、関連するコードをファイルごとにグループ化しています。[`bytes`パッケージ](https://go.dev/src/bytes/)のソースが良い例です。長いパッケージのドキュメントを持つパッケージは、[パッケージのドキュメント](decisions.md#パッケージコメント)とパッケージの宣言、そしてそれ以外を含む`doc.go`という1つのファイルを専用にすることができますが、これは必須ではありません。

Google のコードベースやBazelを使用したプロジェクトでは、Go コードのディレクトリレイアウトはオープンソースのGoプロジェクトとは異なります。複数の`go_library`ターゲットを一つのディレクトリに置くことができます。将来的にプロジェクトをオープンソース化することを想定している場合、各パッケージに独自のディレクトリを持たせるのがよいでしょう。

つぎの記事もご覧ください。

- [テストダブルパッケージ](#テストダブルパッケージと型)

## インポート

### プロトとスタブ

プロトライブラリのインポートは、その言語横断的な性質により、標準のGoインポートとは異なる扱いを受けます。名前を変更したプロトインポートの規約は、そのパッケージを生成したルールに基づきます。

- `pb`サフィックスは一般に`go_proto_library`のルールに使用されます。
- `grpc`サフィックスは一般に`go_grpc_library`のルールに使用されます。
一般に、短い 1 文字または 2 文字のプレフィックスが使用されます。

```go
// Good:
import (
    fspb "path/to/package/foo_service_go_proto"
    fsgrpc "path/to/package/foo_service_go_grpc"
)
```

パッケージが使用するプロトが 1 つだけである場合、あるいはパッケージがそのプロトと密接に結びついている場合は、プレフィックスを省略することができます。

```go
import (
    pb "path/to/package/foo_service_go_proto"
    grpc "path/to/package/foo_service_go_grpc"
)
```

プロトのシンボルが一般的であったり、あまり自己記述的でない場合、あるいはパッケージ名を頭文字で短くすることが不明確な場合、短い単語をプレフィックスとして使用すれば十分です。

```go
// Good:
import (
    mapspb "path/to/package/maps_go_proto"
)
```

この場合、当該コードがまだ地図と明確に関連していない場合は、`mapspb.Address`の方が`mpb.Address`よりも明確かもしれません。

### インポートの順序

インポートは通常、以下の2つ（またはそれ以上）のブロックに、順番にグループ化されます。

- 標準ライブラリのインポート（例: `"fmt"`）
- インポート（例: `"/path/to/somelib"`）
- （オプション）Protobufのインポート （例: `fpb "path/to/foo_go_proto"`）
- （オプション）副作用のインポート（例: `_ "path/to/package"`）

ファイルに上記のオプションのカテゴリの1つのグループがない場合、関連するインポートはプロジェクトのインポートグループに含まれます。

明確で理解しやすいインポートグループであれば、どのようなグループ分けでも一般的に問題ありません。たとえば、チームはgRPCインポートをprotobufインポートとは別にグループ化することを選択することができます。

**注意**: 2つの必須グループ（標準ライブラリ用のグループとその他のすべてのインポート用のグループ）だけを維持するコードでは、`goimports`ツールはこのガイダンスと一致する出力を生成します。

しかし、`goimports`は必須グループ以外のグループについては何も知らないので、オプションのグループはツールによって無効にされやすい です。オプションのグループを使用する場合、グループ分けを確実に準拠させるために、著者とレビュアーの両方に注意が必要です。

どちらの方法でもかまいませんが、インポートセクションを一貫性のない、部分的にグループ化された状態で放置しないでください。

## エラーハンドリング

Goでは、[エラーは値](https://go.dev/blog/errors-are-values)です。エラーはコードによって生成され、コードによって利用されます。エラーには以下のようなものがあります。

- 人間に表示するための診断情報に変換される
- メンテナによる使用される
- エンドユーザに解釈される

エラーメッセージは、ログメッセージ、エラーダンプ、レンダリングされたUIなど、さまざまな場面で表示されます。

エラーを処理する（生成または利用する）コードは、意図的にそうする必要があります。エラーの返り値を無視したり、やみくもに伝播させたりしたくなることがあります。しかし、呼び出し元の関数が、エラーを最も効果的に処理できる場所にあるかどうかは、常に考慮する価値があります。これは大きな話題であり、断定的なアドバイスをするのは困難です。あなたの判断で、しかし、以下の考慮事項を心に留めておいてください。

- エラー値を作成する際に、何らかの[構造](#エラー構造)を与えるかどうかを決定してください。
- エラーを処理する際には、自分では知っているが呼び出し元や呼び出し先では 知らないような[情報を追加](#エラーの追加情報)することを検討してください。
- [エラーログ](#エラーログ)に関するガイダンスも参照してください。

通常、エラーを無視することは適切ではありませんが、関連する操作のオーケストレーションでは、最初のエラーだけが有用であることが多いので妥当な例外となります。[`errgroup`](https://pkg.go.dev/golang.org/x/sync/errgroup)パッケージは、グループとして失敗したりキャンセルされたりする可能性のある操作のグループに対して、便利な抽象化を提供します。

つぎの記事もご覧ください。

- [Effective Goのエラーセクション](https://go.dev/doc/effective_go#errors)
- [Goブログのエラーに関する記事](https://go.dev/blog/go1.13-errors)
- [`errors`パッケージ](https://pkg.go.dev/errors)
- [`upspin.io/errors`](https://commandcenter.blogspot.com/2017/12/error-handling-in-upspin.html)
- [GoTip #89: 正規のステータスコードをエラーとして使用する場合](https://google.github.io/styleguide/go/index.html#gotip)
- [GoTip #48: エラーのセンチネル値](https://google.github.io/styleguide/go/index.html#gotip)
- [GoTip #13: チェックのためのエラーの設計](https://google.github.io/styleguide/go/index.html#gotip)

### エラー構造

呼び出し元がエラーを調べる必要がある場合（たとえば、異なるエラー状態を区別するためなど）、 呼び出し元が文字列のマッチングを行うのではなく、 プログラムでそれを行えるようにエラー値の構造を指定します。このアドバイスは、プロダクションコードだけでなく、 さまざまなエラー条件を扱うテストにも当てはまります。

最も単純な構造のエラーは、パラメータ化されていないグローバルな値です。

```go
type Animal string

var (
    // ErrDuplicateは動物がすでに目撃されている場合に発生します。
    ErrDuplicate = errors.New("duplicate")

    // ErrMarsupialは私たちがオーストラリア以外の有袋類にアレルギーがあるために発生します。
    // すみません。
    ErrMarsupial = errors.New("marsupials are not supported")
)

func pet(animal Animal) error {
    switch {
    case seen[animal]:
        return ErrDuplicate
    case marsupial(animal):
        return ErrMarsupial
    }
    seen[animal] = true
    // ...
    return nil
}
```

呼び出し側は、この関数から返されるエラー値を既知のエラー値の1つと比較するだけでよいのです。

```go
// Good:
func handlePet(...) {
    switch err := process(an); err {
    case ErrDuplicate:
        return fmt.Errorf("feed %q: %v", an, err)
    case ErrMarsupial:
        // 代わりに仲間での復旧を試みます
        alternate = an.BackupAnimal()
        return handlePet(..., alternate, ...)
    }
}
```

上記はセンチネル値を使っており、誤差は期待値と（`==`の意味で）等しくなければなりません。これは多くの場合、完全に適切です。もし`process`がラップされたエラーを返す場合（後述）、[`errors.Is`](https://pkg.go.dev/errors#Is)を使うことができます。

```go
// Good:
func handlePet(...) {
    switch err := process(an); {
    case errors.Is(err, ErrDuplicate):
        return fmt.Errorf("feed %q: %v", an, err)
    case errors.Is(err, ErrMarsupial):
        // ...
    }
}
```

エラーを文字列形式で区別しようとしないでください。（詳しくは[Go Tip #13: チェックのためのエラーの設計](https://google.github.io/styleguide/go/index.html#gotip)をご参照ください。）

```go
// Bad:
func handlePet(...) {
    err := process(an)
    if regexp.MatchString(`duplicate`, err.Error()) {...}
    if regexp.MatchString(`marsupial`, err.Error()) {...}
}
```

呼び出し側がプログラム的に必要とする追加の情報がエラーの中にある場合、それは理想的には構造的に提示されるべきです。たとえば、[`os.PathError`](https://pkg.go.dev/os#PathError)型は、呼び出し側が簡単にアクセスできる構造体フィールドに失敗した操作のパス名を配置するようにドキュメント化されています。

たとえば、エラーコードと詳細文字列を含むプロジェクト構造体など、他のエラー構造体を適切に使用することができます。[`status`](https://pkg.go.dev/google.golang.org/grpc/status)パッケージは一般的なカプセル化手法です。この手法を選択した場合（強制ではありません）、[正規コード](https://pkg.go.dev/google.golang.org/grpc/codes)を使用します。ステータスコードを使用するのが正しい選択かどうかを知るには、 [Go Tip #89: 正規のステータスコードをエラーとしていつ使うべきか](https://google.github.io/styleguide/go/index.html#gotip)をご参照ください。

### エラーの追加情報

エラーを返す関数は、そのエラー値を有用なものにするよう努めなければなりません。多くの場合、その関数はコールチェーンの途中にあり、単にその関数が呼び出した他の関数（おそらく他のパッケージのもの）からエラーを伝搬しているだけです。しかし、プログラマは、重複する情報や無関係な情報を追加することなく、エラーの中に十分な情報があることを確認する必要があります。不安な場合は、開発中にエラー条件をトリガーしてみましょう。これは、エラーの観測者（人間またはコード）が最終的に何を得るかを評価する良い方法です。

慣習や良いドキュメントが助けになります。たとえば、標準パッケージの`os`は、エラーにパス情報が含まれることを明記しています（パス情報が利用可能な場合）。これは便利なスタイルです。なぜなら、エラーを返す呼び出し側は、失敗した関数をすでに提供していたという情報で注釈をつける必要がないからです。

```go
// Good:
if err := os.Open("settings.txt"); err != nil {
    return err
}

// Output:
//
// open settings.txt: no such file or directory
```

エラーの意味について何か役に立つことがあれば、もちろんそれを追加することができます。ただ、コールチェーンのどのレベルがその意味を理解するのに一番適しているかを考えてみてください。

```go
// Good:
if err := os.Open("settings.txt"); err != nil {
    // このエラーの意味を私たちに伝えています。現在の関数は、
    // 失敗する可能性のある複数のファイル操作を実行するかもしれないので、
    // これらの注釈は、何がうまくいかなかったのかを呼び出し側への曖昧さを
    // なくすのに役立つことに注意してください。
    return fmt.Errorf("launch codes unavailable: %v", err)
}

// Output:
//
// launch codes unavailable: open settings.txt: no such file or directory
```

ここで冗長な情報と対比させます。

```go
// Bad:
if err := os.Open("settings.txt"); err != nil {
    return fmt.Errorf("could not open settings.txt: %w", err)
}

// Output:
//
// could not open settings.txt: open settings.txt: no such file or directory
```

伝播されたエラーに情報を追加する場合、エラーをラップするか、新しいエラーを表示することができます。`fmt.Errorf`の`%w`バーブでエラーをラップすると、呼び出し元が元のエラーのデータにアクセスできるようになります。これは非常に便利な場合もありますが、呼び出し側にとって誤解を招いたり、興味を持たなかったりする場合もあります。詳しくは、[エラーのラップに関するブログ記事](https://blog.golang.org/go1.13-errors)をご覧ください。また、エラーのラップはパッケージの API サーフェイスを拡張するため、 パッケージの実装を変更したときに破損する可能性があります。

公開するエラーの基礎となる部分をドキュメント化し、それを検証するテストがない限り、`%w`の使用は避けたほうがよいでしょう。呼び出し側が`errors.Unwrap`や`errors.Is`などを呼び出すことを想定していないのであれば、わざわざ `%w`を使う必要はないでしょう。

同じ考え方が[`*status.Status`](https://pkg.go.dev/google.golang.org/grpc/status)のような[構造化されたエラー](https://google.github.io/styleguide/go/best-practices#error-structure)にも当てはまります（[正規のコード](https://pkg.go.dev/google.golang.org/grpc/codes)を参照）。たとえば、サーバーがバックエンドに不正なリクエストを送信して `InvalidArgument`コードを受け取った場合、 このコードはクライアントに伝わらないようにする必要があります。代わりに、`Internal`という正規のコードをクライアントに返します。

しかし、エラーに注釈を付けると、自動ログシステムがエラーのステータスペイロードを保持するのに役立ちます。たとえば、内部関数ではエラーに注釈を付けることが適切です。

```go
// Good:
func (s *Server) internalFunction(ctx context.Context) error {
    // ...
    if err != nil {
        return fmt.Errorf("couldn't find remote file: %w", err)
    }
}
```

システム境界に直接あるコード（典型的にはRPC、IPC、ストレージなど）は、標準的なエラー空間を使用してエラーを報告する必要があります。ドメイン固有のエラーを処理し、それを標準的に表現するのは、ここでのコードの責任で す。たとえば、

```go
// Bad:
func (*FortuneTeller) SuggestFortune(context.Context, *pb.SuggestionRequest) (*pb.SuggestionResponse, error) {
    // ...
    if err != nil {
        return nil, fmt.Errorf("couldn't find remote file: %w", err)
    }
}
```

```go
// Good:
import (
    "google.golang.org/grpc/codes"
    "google.golang.org/grpc/status"
)
func (*FortuneTeller) SuggestFortune(context.Context, *pb.SuggestionRequest) (*pb.SuggestionResponse, error) {
    // ...
    if err != nil {
        // あるいは、呼び出し側がアンラップすることを意図したエラーを意図的にラップする場合は、
        // fmt.Errorfと%wバーブを使用します。
        return nil, status.Errorf(codes.Internal, "couldn't find fortune database", status.ErrInternal)
    }
}
```

### エラー中の%wの位置

エラー文字列の末尾に`%w`を置くことを推奨します。

エラーは[`%w`バーブ](https://blog.golang.org/go1.13-errors)でラップするか、`Unwrap() error`を実装した[構造化エラー](https://google.github.io/styleguide/go/index.html#gotip)（例: [`fs.PathError`](https://pkg.go.dev/io/fs#PathError)）の中に入れることができます。

ラップされたエラーはエラーチェーンを形成します。ラップの各レイヤーは、エラーチェーンの先頭に新しいエントリを追加します。エラーチェーンは、`Unwrap() error`メソッドでたどることができます。たとえば

```go
err1 := fmt.Errorf("err1")
err2 := fmt.Errorf("err2: %w", err1)
err3 := fmt.Errorf("err3: %w", err2)
```

つぎのようなエラーチェーンを形成します。

```
flowchart LR
  err3 == err3 wraps err2 ==> err2;
  err2 == err2 wraps err1 ==> err1;
```

`%w`バーブがどこに置かれるかにかかわらず、返されるエラーは常にエラー連鎖の先頭を表し、`%w`は次の子で す。同様に、`Unwrap() error`は、常に新しいものから最も古いものへと エラーチェーンをたどります。

しかし、`%w`バーブの位置は、エラーチェーンの出力が新しいものから古いもの、古いものから新しいもの、またはそのどちらでもないものに影響します。

```go
// Good:
err1 := fmt.Errorf("err1")
err2 := fmt.Errorf("err2: %w", err1)
err3 := fmt.Errorf("err3: %w", err2)
fmt.Println(err3) // err3: err2: err1
// err3は、新しいものから古いものへと表示されるエラーチェーンです。
```

```go
// Bad:
err1 := fmt.Errorf("err1")
err2 := fmt.Errorf("%w: err2", err1)
err3 := fmt.Errorf("%w: err3", err2)
fmt.Println(err3) // err1: err2: err3
// err3は、最新から最古へのエラーチェーンで、最も古いものから最も新しいものへと表示されます。
```

```go
// Bad:
err1 := fmt.Errorf("err1")
err2 := fmt.Errorf("err2-1 %w err2-2", err1)
err3 := fmt.Errorf("err3-1 %w err3-2", err2)
fmt.Println(err3) // err3-1 err2-1 err1 err2-2 err3-2
// err3 は最新から最古へのエラーチェーンで、表示は最新から最古でも最古から最新でもありません。
```

したがって、エラーテキストがエラーチェーンの構造を反映するように、`%w`バーブを最後に置き、`[...]: %w`という形式にすることが望ましいです。

### エラーログ

関数では、エラーを呼び出し元に伝えず、外部のシステムに伝える必要がある場合があります。この場合、ログを記録することは自明な選択です。しかし、何をどのようにエラーログに記録するのかを意識してください。

- [良いテスト失敗メッセージ](decisions.md#有用なテストの失敗)のように、ログメッセージは何が悪かったのかを明確に表現し、問題を診断するための関連情報を含めることでメンテナをサポートする必要があります。
- 重複は避けましょう。エラーを返した場合は、通常は自分では記録せず、呼び出し元で処理させたほうがよいでしょう。呼び出し側はエラーをログに記録するか、あるいは[`rate.Sometimes`](https://pkg.go.dev/golang.org/x/time/rate#Sometimes)を使ってログを制限するかを選ぶことができます。他の選択肢としては、回復を試みるか、あるいは[プログラムを停止](#プログラムチェックとパニック)することもできます。いずれにせよ、呼び出し側に制御を与えることは、ログスパムを回避するのに 役立ちます。
しかし、この方法の欠点は、ロギングが呼び出し側の行番号を使用して書き込まれることで す。
- [PII](https://en.wikipedia.org/wiki/Personal_data)に注意してください。多くのログシンクは、エンドユーザーの機密情報の送信先として適切ではありません。
- `log.Error`は控えめに利用してください。ERRORレベルのロギングは、フラッシュを引き起こし、より低いロギングレベルより高価です。これは、あなたのコードに深刻なパフォーマンスの影響を与える可能性があります。エラーと警告のレベルを決定するとき、エラーレベルのメッセージは、警告よりも「より深刻」ではなく、対処可能であるべきというベストプラクティスを考慮してください。

Google内部では、ログファイルに書き込んで誰かが気づいてくれることを期待するよりも、より効果的な警告を発するように設定できるモニタリングシステムがあります。これは標準ライブラリ[パッケージの`expvar`](https://pkg.go.dev/expvar)と似ていますが、同じではありません。

#### カスタム冗長レベル

冗長ロギング（[`log.V`](https://pkg.go.dev/github.com/golang/glog#V)）を上手に活用しましょう。冗長ロギングは、開発やトレースに便利です。冗長レベルに関する慣習を確立することは有用です。たとえば

- `V(1)`で少量の余分な情報を書き込む
- `V(2)`でより多くの情報をトレースする
- `V(3)`で大きな内部状態をダンプする

冗長ロギングのコストを最小にするために、`log.V`がオフになっているときでも、誤って高価な関数を呼び出さないようにする必要があります。log.Vには2つのAPIがあります。便利な方のAPIは、このような予期せぬコストがかかるリスクを伴います。迷ったら、少し冗長なほうを使いましょう。

```go
// Good:
for _, sql := range queries {
  log.V(1).Infof("Handling %v", sql)
  if log.V(2) {
    log.Infof("Handling %v", sql.Explain())
  }
  sql.Run(...)
}
```

```go
// Bad:
// sql.Explainはこのログが出力されない場合でも呼び出されます。
log.V(2).Infof("Handling %v", sql.Explain())
```

### プログラム初期化

プログラムの初期化エラー（不正なフラグや設定など）は`main`に伝搬されるべきで、 `main`はエラーを修正する方法を説明するエラーと共に`log.Exit`を呼び出すべきです。このような場合、`log.Fatal`は一般的に使用すべきではありません。なぜなら、チェックを示すスタックトレースは、人間が生成した実行可能なメッセージほど有用ではないと思われるからです。

### プログラムチェックとパニック

[パニックに対する決定](decisions.md#panicさせるな)で述べたように、標準的なエラー処理はエラーの返り値を中心に構成されるべきで す。ライブラリは、特に一過性のエラーの場合、プログラムを中断するよりも呼び出し元にエラーを返すことを優先すべきです。

不変量に対して整合性チェックを行い、違反した場合はプログラムを終了させることが必要な場合があります。一般に、これは不変量チェックの失敗により内部状態が回復不能になった場合のみ行われます。Googleのコードベースでこれを行う最も確実な方法は、`log.Fatal`を呼び出すことです。このような場合に`panic`を使用すると、 遅延された関数がデッドロックしたり、内部や外部の状態をさらに破損させたりする可能性があるため、 信頼性が低くなります。

同様に、クラッシュを回避するためにパニックを回復させる誘惑に負けないでください。パニックから離れれば離れるほど、ロックや他のリソースを保持している可能性のあるプログラムの状態について分からなくなります。そして、プログラムは他の予期しないエラーモードを開発し、問題の診断をさらに困難にする可能性があります。予期しないパニックをコードで処理しようとするのではなく、監視ツールを使って予期しない障害を表面化させ、関連するバグを高い優先度で修正するようにしましょう。

**注意**: 標準の[`net/http`サーバー](https://pkg.go.dev/net/http#Server)はこのアドバイスに反して、リクエストハンドラからパニックを回復しています。経験豊富なGoエンジニアの間では、これは歴史的な誤りであるというのがコンセンサスです。他の言語のアプリケーションサーバーからサーバーログをサンプリングすると、処理されずに残っている大きなスタックトレースを見つけるのが一般的です。あなたのサーバーでは、この落とし穴を避けてください。

### パニックさせるタイミング

標準ライブラリは、APIの誤用に対してパニックを起こします。たとえば、[`reflect`](https://pkg.go.dev/reflect) は、値が誤って解釈されたことを示唆するような方法でアクセスされた場合、多くの場合にパニックを発生させます。これは、境界外のスライス要素にアクセスするようなコア言語のバグに関するパニックと類似しています。コードレビューとテストにより、このようなバグを発見することができます。標準ライブラリはGoogleコードベースが使用する平準化されたログパッケージにアクセスできないため、これらのパニックはライブラリに依存しない不変性チェックとして機能します。

パニックが有用であるもう一つのケースは、一般的ではありませんが、コールチェーンに常に対応するrecoverを持つパッケージの内部実装の詳細として使用されることです。パーサーや、深くネストされ密に結合された内部関数群では、この設計が役に立ちます。この設計の重要な特徴は、これらのパニックがパッケージの境界を越えてエスケープされることを決して許さず、パッケージのAPIの一部を形成しないことです。これは通常、伝播するパニックをパブリックAPI表面で返されるエラーに変換するトップレベルの遅延recoverで達成されます。

パニックは、コンパイラが到達不可能なコードを特定できない場合にも使われます。たとえば、log.Fatalのような戻り値のない関数を使用する場合などです。

```go
// Good:
func answer(i int) string {
    switch i {
    case 42:
        return "yup"
    case 54:
        return "base 13, huh"
    default:
        log.Fatalf("Sorry, %d is not the answer.", i)
        panic("unreachable")
    }
}
```

[フラグが解析される前にログ関数を呼び出さないでください。](https://pkg.go.dev/github.com/golang/glog#pkg-overview)`init`関数内で強制終了しなければならない場合、ログの呼び出しの代わりにパニックを起こしてもかまいません。

## ドキュメンテーション

### 規約

このセクションは、決定事項のドキュメントの[コメント](decisions.md#コメント)セクションを補足するものです。

使い慣れたスタイルで文書化されたGoコードは、誤った文書や全く文書化されていないものよりも読みやすく、誤用される可能性も低くなります。実行可能な[例](decisions.md#例)はGodocとCode Searchに表示され、あなたのコードの使い方を説明する優れた方法です。

#### パラメータと設定

すべてのパラメータがドキュメントに列挙されている必要はありません。これは次のような場合に当てはまります。

- 関数やメソッドのパラメータ
- 構造体フィールド
- オプションのAPI

エラーが起こりやすい、あるいは明らかでないフィールドやパラメータは、なぜそれが注目すべきかを述べてドキュメント化しましょう。

以下の例では、ハイライトされたコメントは、読者にとってほとんど有益な情報を提供しません。

```go
// Bad:
// Sprintfは書式指定子に従って書式を設定し、その結果を文字列で返します。

// formatはフォーマット、dataは補間データです。
func Sprintf(format string, data ...interface{}) string
```

何をどの程度の深さでドキュメント化するかを選択する際には、想定される読者を考慮に入れてください。メンテナンス担当者、チームの新人、外部のユーザー、そして6ヶ月後の自分自身でさえ、最初にドキュメントを書こうとしたときに考えていたこととは少し違った情報を評価するかもしれません。

こちらもご覧ください。

- [GoTip #41: 関数呼び出しのパラメータを特定する](https://google.github.io/styleguide/go/index.html#gotip)
- [GoTip #51: 設定のためのパターン](https://google.github.io/styleguide/go/index.html#gotip)

#### コンテキスト

context 引数をキャンセルすると、それが提供される関数に割り込むことが暗示されます。もしその関数がエラーを返すことができれば、慣習的に`ctx.Err()`となります。

この事実は改めて説明する必要ありません。

```go
// Bad:
// Runはワーカーの実行ループを実行します。
//
// このメソッドはコンテキストがキャンセルされるまで仕事を処理し、
// それに応じてエラーを返します。
func (Worker) Run(ctx context.Context) error
```

暗示されているため、以下のようにするのがよいでしょう。

```go
// Good:
// Runはワーカーの実行ループを実行します。
func (Worker) Run(ctx context.Context) error
```

コンテキストの動作が異なる場合や明らかでない場合は、明示的にドキュメント化する必要があります。

- コンテキストがキャンセルされたときに、ctx.Err() 以外のエラーを返す場合

```go
// Good:
// Runはワーカーの実行ループを実行します。
//
// コンテキストがキャンセルされた場合、Runはnilエラーを返します。
func (Worker) Run(ctx context.Context) error
```

- その機能が他の機構により中断されたり、ライフタイムに影響を及ぼす可能性がある場合

```go
// Good:
// Run executes the worker's run loop.
//
// Runプロセスはコンテキストがキャンセルされるか、Stopが呼ばれるまで動作します。
// コンテキストのキャンセルは内部で非同期に処理されるため、すべての作業が停止する前にrunが返ることがあります。
// Stopメソッドは同期で、runループのすべての操作が終了するまで待機します。
// Stopを使用するとシャットダウンすることができます。
func (Worker) Run(ctx context.Context) error

func (Worker) Stop()
```

- この関数が、コンテキストのライフタイム、系統、または付属の値について特別な期待を持っている場合。

```go
// Good:
// NewReceiver は、指定されたキューに送信されたメッセージの受信を開始します。
// このコンテキストにはデッドラインがあってはなりません。
func NewReceiver(ctx context.Context) *Receiver

// Principal は電話をかけた当事者の名前を返します。
// コンテキストには、security.NewContext から値を付与する必要があります。
func Principal(ctx context.Context) (name string, ok bool)
```

  **警告** 呼び出す側にそのような要求（コンテキストに期限がないなど）をするようなAPIを設計することは避けてください。上記は、避けられない場合にどのようにドキュメント化するかの一例に過ぎず、このパターンを推奨するものではありません。

#### 並行処理

Goのユーザーは、概念的に読み取り専用の操作は並行使用に対して安全であり、余分な同期を必要としないと考えています。

このGodocでは、並行処理に関する余分な記述は安全に削除することができます。

```go
// Lenは、バッファの未読部分のバイト数を返します。
// b.Len() == len(b.Bytes()).
//
// 複数のゴルーチンから同時に呼び出されても問題ありません。
func (*Buffer) Len() int
```

しかし、変更操作は、並行使用に対して安全であることが仮定されていないため、ユーザは同期を考慮する必要があります。

同様に、並行処理に関する余分な記述は、ここでは安全に削除することができます。

```go
// Growはバッファの容量を大きくします。
//
// 複数のゴルーチンから同時に呼び出されるのは安全ではありません。
func (*Buffer) Grow(n int)
```

以下の場合は、ドキュメントの作成が強く推奨されます。

- 操作が読み取り専用なのか、変更可能なのかが不明な場合

```go
// Good:
package lrucache

// Lookupはキャッシュからキーに関連するデータを返します。
//
// この操作は並行使用には安全ではありません。
func (*Cache) Lookup(key string) (data []byte, ok bool)
```

なぜでしょうか？キーを検索するときにキャッシュにヒットすると、内部でLRUキャッシュが更新されます。これがどのように実装されているかは、すべての読者にとって明らかではないかもしれません。

- APIが同期を提供する場合

```go
// Good:
package fortune_go_proto

// NewFortuneTellerClientは、FortuneTellerサービス用の*rpc.Clientを返します。
// これは複数のゴルーチンによる並行使用に対して安全で す。
func NewFortuneTellerClient(cc *rpc.ClientConn) *FortuneTellerClient
```

なぜでしょうか？Stubbyは同期を提供します。

**注意**: APIが型であり、APIが全体として同期を提供する場合、慣習的に型定義のみがセマンティクスをドキュメント化します。

- APIがユーザが実装した型のインターフェースを利用し、インターフェースの利用者が特定の並行処理を要求している場合

```go
// Good:
package health

// Watcherはあるエンティティ（通常はバックエンドサービス）の健全性を報告します。
//
// Watcherメソッドは、複数のゴルーチンが同時に使用しても安全です。
type Watcher interface {
    // Watchは、Watcherの状態が変化したとき渡されたチャネルでtrueを送信します。
    Watch(changed chan<- bool) (unwatch func())

    // Health は監視しているエンティティが健全であれば nil を返し、そうでない場合は健全でない理由を説明する非 nil エラーを返します。
    Health() error
}
```

なぜでしょうか？APIが複数のゴルーチンに使われても安全かどうかは、その契約の一部です。

#### クリーンアップ

APIが持つ明示的なクリーンアップ要件をドキュメント化してください。そうしないと、呼び出し元がAPIを正しく使えず、リソースリークやその他のバグにつながる可能性があるからです。

呼び出し側に任されたクリーンアップを呼び出します。

```go
// Good:
// NewTickerは、各ティック後にチャンネルの現在時刻を送信するチャンネルを含む新しいTickerを返します。
//
// 終了後にTickerの関連リソースを解放するためにStopを呼び出してください。
func NewTicker(d Duration) *Ticker

func (*Ticker) Stop()
```

リソースのクリーンアップ方法が不明確な可能性がある場合、その方法を説明してください。

```go
// Good:
// Getは指定されたURLへのGETを発行します。
//
// errがnilのとき、respは常にnilでないresp.Bodyを持ちます。
// 呼び出し側はresp.Bodyからの読み込みが終了したらresp.Bodyを閉じる必要があります。
//
//    resp, err := http.Get("http://example.com/")
//    if err != nil {
//        // handle error
//    }
//    defer resp.Body.Close()
//    body, err := io.ReadAll(resp.Body)
func (c *Client) Get(url string) (resp *Response, err error)
```

### プレビュー

Goは[ドキュメントサーバー](https://pkg.go.dev/golang.org/x/pkgsite/cmd/pkgsite)を備えています。コードレビューの前と途中の両方で、あなたのコードが生成するドキュメントをプレビューすることが推奨されます。これは、[godocのフォーマット](#godocのフォーマット)が正しくレンダリングされることを検証するのに役立ちます。

### Godocのフォーマット

[Godoc](https://pkg.go.dev/)は、[ドキュメントをフォーマットする](https://go.dev/doc/comment)ための特別なシンタックスをいくつか提供しています。

- 段落の区切りには、空白行が必要です。

```go
// Good:
// LoadConfigは指定されたファイルから設定を読み込みます。
//
// 設定ファイルのフォーマットの詳細については、何らかの/リンクを参照してください。
```

- テストファイルには、godocの対応するドキュメントに添付されて表示される[実行可能な例](decisions.md#例)を含めることができます。

```go
// Good:
func ExampleConfig_WriteTo() {
  cfg := &Config{
    Name: "example",
  }
  if err := cfg.WriteTo(os.Stdout); err != nil {
    log.Exitf("Failed to write config: %s", err)
  }
  // Output:
  // {
  //   "name": "example"
  // }
}
```

- 行を追加の2スペースでインデントすると、そのままの形式で表示されます。

```go
// Good:
// Updateはアトミックトランザクションで関数を実行します。
//
// これは通常、匿名TransactionFuncで使用されます。
//
//   if err := db.Update(func(state *State) { state.Foo = bar }); err != nil {
//     //...
//   }
```

しかし、コードをコメントに入れるより、実行可能な例に入れた方が適切な場合が多いことに注意してください。

この逐語的な書式設定は、リストや表などのgodocにネイティブでない書式設定に活用することができます。

```go
// Good:
// LoadConfigは、指定されたファイルから設定を読み込みます。
//
// LoadConfigは以下のキーを特殊な方法で扱います。
//   "import"を指定すると、この設定は指定されたファイルから継承されます。
//   "env"があれば、システム環境が入力されます。
```

大文字で始まり、括弧とカンマ以外の句読点を含まず、その後に別の段落が続く1行は、ヘッダとしてフォーマットされます。

```go
// Good:
// The following line is formatted as a heading.
//
// Using headings
//
// Headings come with autogenerated anchor tags for easy linking.
```

### シグナルのブースト

あるコード行が一般的なもののように見えて、実はそうでないことがあります。その最たる例が`err == nil`のチェックです（`err != nil`の方がはるかに一般的なため）。次の2つの条件チェックは、見分けがつきにくいです。

```go
// Good:
if err := doSomething(); err != nil {
    // ...
}
```

```go
// Bad:
if err := doSomething(); err == nil {
    // ...
}
```

その代わり、コメントをつけることで条件のシグナルを「ブースト」することができます。

```go
// Good:
if err := doSomething(); err == nil { // if NO error
    // ...
}
```

コメントでは、条件の違いに注意を促しています。

## 変数宣言

### 初期化

一貫性を保つために、新しい変数をゼロ以外の値で初期化する場合は、`var`よりも`:=`を優先してください。

```go
// Good:
i := 42
```

```go
// Bad:
var i = 42
```

### 非ポインタのゼロ値

以下の宣言では、[ゼロ値](https://golang.org/ref/spec#The_zero_value)を使用しています。

```go
// Good:
var (
    coords Point
    magic  [4]byte
    primes []int
)
```

ゼロ値を使って値を宣言するのは、後で使えるように空の値を伝えるときです。明示的な初期化で複合リテラルを使用すると、煩雑になる可能性があります。

```go
// Bad:
var (
    coords = Point{X: 0, Y: 0}
    magic  = [4]byte{0, 0, 0, 0}
    primes = []int(nil)
)
```

ゼロ値宣言の一般的な適用例としては、アンマーシャルの際に変数を出力先として使用する場合があります。

```go
// Good:
var coords Point
if err := json.Unmarshal(data, &coords); err != nil {
```

構造体の中にロックや[コピーしてはいけない](decisions.md#コピー)フィールドが必要な場合、それを値型にしてゼロ値初期化の利点を活用することができます。ただし、この場合、含む型は値ではなくポインタを介して渡さなければなりません。この型に対するメソッドはポインタのレシーバを受け取らなければなりません。

```go
// Good:
type Counter struct {
    // このフィールドは、"*sync.Mutex "である必要はありません。
    // しかし、ユーザーはCounterではなく、*Counterオブジェクトを渡さなければなりません。
    mu   sync.Mutex
    data map[string]int64
}

// コピー防止のため、ポインタのレシーバであることに注意してください。
func (c *Counter) IncrementBy(name string, n int64)
```

複合体（構造体や配列など）のローカル変数にコピー不可能なフィールドがあっても、値型を使用してもかまいません。しかし、複合体が関数から返される場合、あるいは複合体へのアクセスが最終的にアドレスを必要とする場合、その変数を最初からポインタ型として宣言しておくことを優先してください。同様に、protobufもポインタ型として宣言すべきです。

```go
// Good:
func NewCounter(name string) *Counter {
    c := new(Counter) // "&Counter{}" でもかまいません。
    registerCounter(name, c)
    return c
}

var myMsg = new(pb.Bar) // もしくは "&pb.Bar{}".
```

これは、`*pb.Something`は[`proto.Message`](https://pkg.go.dev/google.golang.org/protobuf/proto#Message)を満たすのに対し、`pb.Something`は満たさないからです。

```go
// Bad:
func NewCounter(name string) *Counter {
    var c Counter
    registerCounter(name, &c)
    return &c
}

var myMsg = pb.Bar{}
```

**重要**: マップ型は、変更する前に明示的に初期化する必要があります。しかし、ゼロ値のマップからの読み込みは全く問題ありません。

マップ型とスライス型については、コードが特にパフォーマンスに敏感で、サイズが事前に分かっている場合、[サイズヒント](#サイズヒント)のセクションを参照してください。

### 複合リテラル

以下は、複合リテラル宣言です。

```go
// Good:
var (
    coords   = Point{X: x, Y: y}
    magic    = [4]byte{'I', 'W', 'A', 'D'}
    primes   = []int{2, 3, 5, 7, 11}
    captains = map[string]string{"Kirk": "James Tiberius", "Picard": "Jean-Luc"}
)
```

初期要素やメンバがわかっている場合は、複合リテラルを使用して値を宣言する必要があります。

一方、複合リテラルを使って空やメンバのない値を宣言すると、[ゼロ値初期化](#非ポインタのゼロ値)と比べて視覚的に煩わしくなることがあります。

ゼロ値へのポインタが必要な場合、空の複合リテラルと`new`という2つの選択肢があります。どちらも問題ありませんが、`new`キーワードは、ゼロ以外の値が必要な場合、複合リテラルが機能しないことを読み手に思い起こさせる役割を果たします。

```go
// Good:
var (
  buf = new(bytes.Buffer) // 空でないBufferはコンストラクタで初期化さ れます。
  msg = new(pb.Message) // 空ではないprotoメッセージは、ビルダーで初期化されるかフィールドを一つずつ設定することで初期化されます。
)
```
