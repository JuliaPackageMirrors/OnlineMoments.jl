# Online calculation of higher-order moments for Julia

[OnlineMoments.jl] is a Julia package that iteratively calculates the
[higher-order moments] of a sequence of real numbers.

[OnlineMoments.jl]: https://colberg.org/OnlineMoments.jl
[higher-order moments]: https://people.xiph.org/~tterribe/notes/homs.html

## Installation

Within Julia, the package may be installed with

```julia
Pkg.add("OnlineMoments")
```

After installation, the test suite may be run with

```julia
Pkg.test("OnlineMoments")
```

## Usage

The package provides immutable types for the iterative calculation of
the moments of a sequence: `Mean` for the first moment, `Variance` for
the first and second moments, and `Moments` for the first four moments.
Results are extracted using the functions `nobs()`, `mean()`, `var()`,
`std()`, `sem()`, `skewness()`, and `kurtosis()`.

Calculate first four moments of a sequence:

```julia
import OnlineMoments: Moments
import StatsBase: nobs, skewness, kurtosis

x = rand(1000000)
m = zero(Moments)
for i = 1:length(x)
  m += x[i]
end
println(nobs(m))        # length(x)
println(mean(m))        # 1/2
println(var(m))         # 1/12
println(skewness(m))    # 0
println(kurtosis(m))    # -6/5
```

Calculate first four moments of multiple sequences:

```julia
import OnlineMoments: Moments
import StatsBase: nobs, skewness, kurtosis

x = rand(1000000, 5)
m = zeros(Moments, size(x, 2))
for j = 1:size(x, 2)
  for i = 1:size(x, 1)
    m[j] += x[i, j]
  end
end
println(map(nobs, m))
println(map(mean, m))
println(map(var, m))
println(map(skewness, m))
println(map(kurtosis, m))
```

Calculate mean, variance, standard deviation, and standard error of the mean:

```julia
import OnlineMoments: Variance
import StatsBase: nobs, sem

x = rand(1000000)
m = zero(Variance)
for i = 1:length(x)
  m += x[i]
end
println(nobs(m))
println(mean(m))
println(var(m))
println(std(m))
println(sem(m))
```
