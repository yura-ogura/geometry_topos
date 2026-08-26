import Lake
open Lake DSL

package «geometry_topos» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩,
    ⟨`relaxedAutoImplicit, false⟩
  ]

@[default_target]
lean_lib GeometryTopos where

require HoTTLean from git
  "https://github.com/sinhp/HoTTLean.git" 
