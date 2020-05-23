# saline
Saturating arithmetic for Crystal

## Usage

The `Saturating` generic type lets you impose saturating arithmetic on any
`Number` type. This means that in any case when the wrapped type would overflow
or underflow, it instead clamps to the relevant boundary (the type's `MAX` in
case of overflow or `MIN` in case of underflow).

The code snippet below demonstrates this concept with an Int32:

```crystal
n = Saturating(Int32).new(Int32::MAX - 2)
n += 20 # => 2147483647 (Int32::MAX)

m = Saturating(Int32).new(Int32::MIN + 3)
m -= 30 # => -2147483648 (Int32::MIN)
```

## Development

This shard currently uses an initial pure-Crystal approach. While I want to
keep that approach around, saturating arithmetic is implemented already in
LLVM, which undergirds Crystal. I'd like to have create bindings to
[these functions](https://llvm.org/docs/LangRef.html#saturation-arithmetic-intrinsics)
eventually, with the ability to use each implementation as desired.

## Contributing

1. Fork it (<https://github.com/kinxer/saline/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Benjamin Wade](https://github.com/kinxer) - creator and maintainer