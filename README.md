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

function moments(N::Integer)
  m = zero(Moments)
  for i = 1:N
    m += rand()
  end
  m
end

m = moments(1000000)
println(nobs(m))        # 1000000
println(mean(m))        # 1/2
println(var(m))         # 1/12
println(skewness(m))    # 0
println(kurtosis(m))    # -6/5
```

Calculate mean, variance, standard deviation, and standard error of the mean:

```julia
import OnlineMoments: Variance
import StatsBase: nobs, sem

function moments(N::Integer)
  m = zero(Variance)
  for i = 1:N
    m += rand()
  end
  m
end

m = moments(1000000)
println(nobs(m))
println(mean(m))
println(var(m))
println(std(m))
println(sem(m))
```

Calculate first four moments of multiple sequences:

```julia
import OnlineMoments: Moments
import StatsBase: nobs, skewness, kurtosis

function moments(N::Integer, M::Integer)
  m = zeros(Moments, M)
  for j = 1:M
    for i = 1:N
      m[j] += rand()
    end
  end
  m
end

m = moments(1000000, 5)
println(map(nobs, m))
println(map(mean, m))
println(map(var, m))
println(map(skewness, m))
println(map(kurtosis, m))
```

Calculate first four moments of a parallel sequence using `julia -p <n>`:

```julia
import OnlineMoments
import StatsBase: nobs, skewness, kurtosis

@everywhere import OnlineMoments: Moments

@everywhere function moments(N::Integer)
  m = zero(Moments)
  for i = 1:N
    m += rand()
  end
  m
end

m = @parallel (+) for i = 1:100
  moments(1000000)
end
println(nobs(m))
println(mean(m))
println(var(m))
println(skewness(m))
println(kurtosis(m))
```
