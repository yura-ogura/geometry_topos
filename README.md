# geometry_topos

A Formal Verification Framework for Semantic Equivalence between Higher Topos Paths and Discrete Geodesics via SynthLean / HoTTLean

[![Build Status](https://github.com/yura-ogura/geometry_topos/actions/workflows/build.yml/badge.svg)](https://github.com/yura-ogura/geometry_topos/actions)
[![Lean 4 CI](https://img.shields.io/badge/Lean4-v4.25.0--rc2-blue)](https://github.com/leanprover/lean4)
[![License](https://img.shields.io/badge/License-Apache_2.0-green.svg)](LICENSE)

---

## Overview

`geometry_topos` is a formally verified proof-of-concept (PoC) framework in Lean 4, designed to establish the semantic equivalence between abstract geometric paths in the **Effective 2-Topos ($\mathcal{Eff}_2$)** and concrete, zero-residual geodesic equations on discrete manifolds ($\mathcal{Eff}_1$).

By utilizing **Homotopy Type Theory (HoTT)**, **Natural Model Semantics**, and structural definitions of higher toposes, this repository provides a rigorous bridge showing that abstract path lifts in $\mathcal{Eff}_2$ collapse semantically into computable algebraic constraints over $\mathbb{Z}_q$.

### Key Features & Current Capabilities

- **Topos-Theoretic Semantic Bridge:** Connects deeply embedded $\mathcal{Eff}_2$ syntax (`SynthLean`) with concrete $\mathbb{Z}_q$ manifold models via heavily optimized axiomatic interfaces (to prevent AST explosion). The absolute soundness theorem is mechanically checked by the Lean 4 kernel.
- **Structural Formalization of $\mathcal{Eff}_2$:** Provides foundational definitions for fibrant 0-types and coherent groupoids, formalizing the theorem that coherent 0-types in $\mathcal{Eff}_2$ descend to coherent objects in the effective 1-topos ($\mathcal{Eff}_1$).
- **Verified Path Types & Hurewicz Lifts:** Implements Awodey–Hua Path Types. Abstract paths are formalized using interval objects and Hurewicz fibrations, proving that geometric path lifting preserves boundary conditions.
- **Discrete Geodesic Computation Engine:** Implements modular arithmetic over $q = 2147483647$, 7D manifold potential fields ($\Psi_7$), discrete metric tensors, and validates that smooth concatenation of discrete paths satisfies the geodesic equation ($\text{geodesicResidual} = 0$).

---

## Repository Structure

- `CITATION.cff`
- `GeometryTopos.lean` : Main library export file
- `GeometryTopos/`
  - `Frontend.lean` : EDSL syntax declarations, abstract $\mathcal{Eff}_2$ axioms, and Awodey-Hua path type interfaces
  - `Model.lean` : The concrete $\mathcal{Eff}_1$ engine defining $\mathbb{Z}_q$ manifolds, $\Psi_7$ potentials, and `ConcretePath` structural constraints
  - `SemanticProofs.lean` : $\mathbb{Z}_q$ algebraic reduction lemmas and semantic wrappers showing smooth discrete paths yield zero acceleration
  - `Interpretation.lean` : Absolute soundness mapping linking abstract `Hurewicz_lift` syntax to concrete zero-residual geodesic equations
　- `main.lean` : End-to-end verification entry point evaluating syntactic geometric judgments to presheaf morphisms

### Module Breakdown

- **`GeometryTopos/Frontend.lean`:** Declares the formal signature of the `geometry_topos` theory. Defines categories, presheaves, internal groupoids, geometric contexts, and abstract path spaces (`PathSpace_P_presheaf`) along with their Hurewicz fibration lifts.
- **`GeometryTopos/Model.lean`:** Implements the concrete mathematical model over $\mathbb{Z}_q$. Contains definitions for `Manifold4D`, the $\Psi_7$ potential field, discrete derivatives, `ConcretePath`, and the strict proof of `geodesic_residual_at_connection`.
- **`GeometryTopos/SemanticProofs.lean`:** Provides algebraic simplification lemmas (`zmod_modAdd_eq`, `zmod_modMul_eq`, etc.) that lift `Nat` operations to $\mathbb{Z}_q$. Wraps model proofs into semantic endpoints (`semantic_path_eps0_impl`, `semantic_geodesic_connection_impl`) for interpretation.
- **`GeometryTopos/Interpretation.lean`:** Bridges the abstract natural model universe with concrete proofs. Defines the natural model interpretation (`geometry_topos_interpretation`), checks its well-formedness (`geometry_topos_interpretation_wf`), and verifies the `geometric_absolute_soundness` and `geometric_absolute_eq_soundness` theorems.
- **`main.lean`:** The top-level verification driver ensuring that any typing judgment $\Gamma \vdash_l t : A$ in `geometry_topos` is semantically realized as a valid morphism in the natural model presheaf category.

---

## Formal Verification Highlights

### 1. Semantic Equivalence of Abstract Paths and Discrete Geodesics
The framework strictly proves that lifting an abstract path via a Hurewicz fibration in $\mathcal{Eff}_2$ corresponds exactly to solving a discrete finite-difference equation on a manifold in $\mathcal{Eff}_1$. Specifically, smoothly concatenating paths evaluates to a zero-residual acceleration constraint:

$$\text{geodesicResidual}(m_{\text{prev}}, m_{\text{curr}}, m_{\text{next}}, r_{\text{prev}}, r_{\text{curr}}, r_{\text{next}}, E_{\text{curr}}, n, k) \equiv 0 \pmod q$$

### 2. Absolute Geometric Soundness
Under the defined axiomatic signature, every syntactic typing derivation $\Gamma \vdash_l t : A$ representing a geometric relation translates directly into a commutative diagram of morphisms in the presheaf semantics:

$$\text{interpTm}(\text{deriv}) \gg (M_l).\text{tp} = \text{interpTy}(\text{deriv.wf}\_\text{tp})$$

Furthermore, syntactic equality judgments $\Gamma \vdash_l t \equiv u : A$ translate to strict equality of interpretations:

$$\text{interpTm}(\text{deriv.wf}\_\text{left}) = \text{interpTm}(\text{deriv.wf}\_\text{right})$$

---

## Limitations & Future Work

As a Proof of Concept (PoC) for mapping higher-dimensional topos theory to computational models, this framework currently abstracts certain complex categorical formations (e.g., deeply nested $\Sigma$-types and presheaf limits) into `axiom` declarations to ensure computational feasibility in Lean 4 (avoiding AST explosion and heartbeat limits).

Future milestones include:
1. Replacing intermediate `axiom` interfaces with fully constructed presheaf limits and colimits where computationally viable.
2. Expanding the discrete manifold models to support arbitrary dimensional Riemannian manifolds and non-linear metric connections.
3. Formalizing full univalent universes within the coherent groupoid semantics of $\mathcal{Eff}_2$.

---

## Prerequisites and Building

### Prerequisites

- **Lean 4** (`v4.25.0-rc2`)
- **elan** (Lean version manager)

### Build Instructions

1. Clone the repository to your local environment.
2. Run `lake build` in your terminal.

The dependencies (including `HoTTLean`) will be automatically fetched and compiled during the build process.

---

## References & Citation

If you reference or use this work, please cite the following publications:

### 1. Toward the effective 2-topos (Journal Article)
* **Authors:** Steve Awodey, Jacopo Emmenegger
* **Journal:** *Mathematical Structures in Computer Science*, Vol. 35, e32 (2025)
* **DOI:** [10.1017/S0960129525100352](https://doi.org/10.1017/S0960129525100352)

### 2. A Certifying Proof Assistant for Synthetic Mathematics in Lean
* **Authors:** Wojciech Nawrocki, Joseph Hua, Mario Carneiro, Yiming Xu, Spencer Woolfson, Shuge Rong, Sina Hazratpour, Steve Awodey
* **Conference:** *Proceedings of the 15th ACM SIGPLAN International Conference on Certified Programs and Proofs (CPP '26)*, pp. 88–103 (2026)
* **DOI:** [10.1145/3779031.3779087](https://doi.org/10.1145/3779031.3779087)

### 3. Path Types in Algebraic Type Theory
* **Authors:** Steve Awodey, Joseph Hua
* **Preprint:** arXiv:2601.06567 (2026)

```bibtex
@article{awodey2025toward,
  author    = {Steve Awodey and Jacopo Emmenegger},
  title     = {Toward the effective 2-topos},
  journal   = {Mathematical Structures in Computer Science},
  volume    = {35},
  pages     = {e32},
  year      = {2025},
  publisher = {Cambridge University Press},
  doi       = {10.1017/S0960129525100352}
}

@inproceedings{nawrocki2026certifying,
  author    = {Wojciech Nawrocki and Joseph Hua and Mario Carneiro and Yiming Xu and Spencer Woolfson and Shuge Rong and Sina Hazratpour and Steve Awodey},
  title     = {A Certifying Proof Assistant for Synthetic Mathematics in Lean},
  booktitle = {Proceedings of the 15th ACM SIGPLAN International Conference on Certified Programs and Proofs (CPP '26)},
  pages     = {88--103},
  year      = {2026},
  publisher = {ACM},
  doi       = {10.1145/3779031.3779087}
}

@article{awodey2026path,
  author    = {Steve Awodey and Joseph Hua},
  title     = {Path Types in Algebraic Type Theory},
  journal   = {arXiv preprint arXiv:2601.06567},
  year      = {2026}
}
```
---

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.
