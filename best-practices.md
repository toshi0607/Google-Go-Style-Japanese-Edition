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
