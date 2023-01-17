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
