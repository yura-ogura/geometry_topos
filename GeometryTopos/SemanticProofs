import Mathlib.Tactic.Ring
import GeometryTopos.Model

set_option linter.unusedVariables false

noncomputable section
open GeometryTopos

namespace SemanticProofs

@[simp] lemma zmod_modAdd_eq (a b : Nat) :
  (modAdd a b : ZMod q) = (a : ZMod q) + (b : ZMod q) := by
  unfold modAdd
  rw [ZMod.natCast_mod]
  push_cast
  rfl

@[simp] lemma zmod_modMul_eq (a b : Nat) :
  (modMul a b : ZMod q) = (a : ZMod q) * (b : ZMod q) := by
  unfold modMul
  rw [ZMod.natCast_mod]
  push_cast
  rfl

@[simp] lemma zmod_modSub_eq (a b : Nat) :
  (modSub a b : ZMod q) = (a : ZMod q) - (b : ZMod q) := by
  unfold modSub
  simp only [zmod_modAdd_eq, zmod_modMul_eq]
  have h : (minus_one : ZMod q) = -1 := minus_one_eq
  rw [h]
  ring

axiom zmod_inv_two_eq : (inv_two : ZMod q) = 2⁻¹
axiom zmod_sqrt_exp_eq : (sqrt_exp : ZMod q) = 4⁻¹

theorem semantic_path_eps0_impl {dom cod : Manifold4D} {N param_n : Nat}
  (p : ConcretePath dom cod N param_n) :
  p.m_seq.get ⟨0, by rw [p.h_len.1]; omega⟩ = dom := by
  exact ConcretePath.get_zero p

theorem semantic_path_eps1_impl {dom cod : Manifold4D} {N param_n : Nat}
  (p : ConcretePath dom cod N param_n) :
  p.m_seq.get ⟨N, by rw [p.h_len.1]; omega⟩ = cod := by
  exact ConcretePath.get_last p

theorem semantic_geodesic_connection_impl {X Y Z : Manifold4D} {N1 N2 param_n : Nat}
  (p1 : ConcretePath X Y N1 param_n) (p2 : ConcretePath Y Z N2 param_n)
  (h_smooth : SmoothConnection p1 p2) (h1 : N1 > 0) (h2 : N2 > 0) :
  let p_con := concatPath p1 p2
  let idx_prev : Fin p_con.m_seq.length := ⟨N1 - 1, by rw [p_con.h_len.1]; omega⟩
  let idx_curr : Fin p_con.m_seq.length := ⟨N1,      by rw [p_con.h_len.1]; omega⟩
  let idx_next : Fin p_con.m_seq.length := ⟨N1 + 1,  by rw [p_con.h_len.1]; omega⟩
  let m_prev := p_con.m_seq.get idx_prev
  let m_curr := p_con.m_seq.get idx_curr
  let m_next := p_con.m_seq.get idx_next
  (m_next.x : ZMod q) + minus_two * m_curr.x + m_prev.x = 0 := by
  exact geodesic_residual_at_connection p1 p2 h_smooth h1 h2

end SemanticProofs
