using Base.Test
using StatsBase
import OnlineMoments: Mean, Variance, Moments

const N = 10000
const n = 100

for r = 1:1000
  x = rand(N)
  m = let
    m = zeros(Mean, n)
    for j = 1:n
      for i = j:n:N
        m[j] += x[i]
      end
    end
    sum(m)
  end
  @test nobs(m) == length(x)
  @test_approx_eq_eps mean(m) mean(x) 1e-14
end

for r = 1:1000
  x = rand(N)
  m = let
    m = zeros(Variance, n)
    for j = 1:n
      for i = j:n:N
        m[j] += x[i]
      end
    end
    sum(m)
  end
  @test nobs(m) == length(x)
  @test_approx_eq_eps mean(m) mean(x) 1e-14
  @test_approx_eq_eps var(m) var(x) 1e-14
  @test_approx_eq_eps std(m) std(x) 1e-14
  @test_approx_eq_eps sem(m) sem(x) 1e-14
end

for r = 1:1000
  x = rand(N)
  m = let
    m = zeros(Moments, n)
    for j = 1:n
      for i = j:n:N
        m[j] += x[i]
      end
    end
    sum(m)
  end
  @test nobs(m) == length(x)
  @test_approx_eq_eps mean(m) mean(x) 1e-14
  @test_approx_eq_eps var(m) var(x) 1e-14
  @test_approx_eq_eps std(m) std(x) 1e-14
  @test_approx_eq_eps sem(m) sem(x) 1e-14
  @test_approx_eq_eps skewness(m) skewness(x) 1e-13
  @test_approx_eq_eps kurtosis(m) kurtosis(x) 1e-13
end
