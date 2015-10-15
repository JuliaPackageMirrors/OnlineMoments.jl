VERSION >= v"0.4.0-dev+6521" && __precompile__()

module OnlineMoments

import StatsBase

#-----------------------------------------------------------------------------

immutable Mean
  N::Float64
  M::Float64
end

Base.zero(::Type{Mean}) = Mean(0.0, 0.0)

Base.mean(a::Mean) = a.M

StatsBase.nobs(a::Mean) = convert(Int64, a.N)

function Base.(:+)(a::Mean, x::Real)
  N = a.N + 1.0
  Δ = x - a.M
  δ = Δ / N
  M = a.M + δ
  Mean(N, M)
end

function Base.(:+)(a::Mean, b::Mean)
  N = a.N + b.N
  Δ = b.M - a.M
  δ = Δ / N
  M = a.M + b.N*δ
  Mean(N, M)
end

#-----------------------------------------------------------------------------

immutable Variance
  N::Float64
  M::Float64
  V::Float64
end

Base.zero(::Type{Variance}) = Variance(0.0, 0.0, 0.0)

Base.mean(a::Variance) = a.M

Base.var(a::Variance) = a.V / (a.N - 1.0)

Base.std(a::Variance) = sqrt(var(a))

StatsBase.sem(a::Variance) = sqrt(a.V / ((a.N - 1.0) * a.N))

StatsBase.nobs(a::Variance) = convert(Int64, a.N)

function Base.(:+)(a::Variance, x::Real)
  N = a.N + 1.0
  Δ = x - a.M
  δ = Δ / N
  ξ = Δ * (N - 1.0)
  M = a.M + δ
  V = a.V + δ*ξ
  Variance(N, M, V)
end

function Base.(:+)(a::Variance, b::Variance)
  N = a.N + b.N
  Δ = b.M - a.M
  δ = Δ / N
  ξ = Δ * a.N * b.N
  M = a.M + b.N*δ
  V = a.V + b.V + δ*ξ
  Variance(N, M, V)
end

#-----------------------------------------------------------------------------

immutable Moments
  N::Float64
  M::Float64
  V::Float64
  S::Float64
  K::Float64
end

Base.zero(::Type{Moments}) = Moments(0.0, 0.0, 0.0, 0.0, 0.0)

Base.mean(a::Moments) = a.M

Base.var(a::Moments) = a.V / (a.N - 1.0)

Base.std(a::Moments) = sqrt(var(a))

StatsBase.sem(a::Moments) = sqrt(a.V / ((a.N - 1.0) * a.N))

StatsBase.skewness(a::Moments) = sqrt(a.N) * a.S / a.V^1.5

StatsBase.kurtosis(a::Moments) = a.N * a.K / (a.V * a.V) - 3.0

StatsBase.nobs(a::Moments) = convert(Int64, a.N)

function Base.(:+)(a::Moments, x::Real)
  N = a.N + 1.0
  Δ = x - a.M
  δ = Δ / N
  δ² = δ * δ
  δ³ = δ² * δ
  ξ = Δ * (N - 1.0)
  M = a.M + δ
  V = a.V + δ*ξ
  S = a.S + δ²*ξ*(N - 2.0) - 3.0*δ*a.V
  K = a.K + δ³*ξ*(N*N - 3.0*N + 3.0) + 6.0*δ²*a.V - 4.0*δ*a.S
  Moments(N, M, V, S, K)
end

function Base.(:+)(a::Moments, b::Moments)
  N = a.N + b.N
  Δ = b.M - a.M
  δ = Δ / N
  δ² = δ * δ
  δ³ = δ² * δ
  ξ = Δ * a.N * b.N
  M = a.M + b.N*δ
  V = a.V + b.V + δ*ξ
  S = a.S + b.S + δ²*ξ*(a.N - b.N) + 3.0*δ*(a.N*b.V - b.N*a.V)
  K = a.K + b.K + δ³*ξ*(a.N*a.N - a.N*b.N + b.N*b.N) + 6.0*δ²*(a.N*a.N*b.V + b.N*b.N*a.V) + 4.0*δ*(a.N*b.S - b.N*a.S)
  Moments(N, M, V, S, K)
end

#-----------------------------------------------------------------------------

end
