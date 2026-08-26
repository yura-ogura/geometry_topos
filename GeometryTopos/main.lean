import HoTTLean.Frontend.Commands
import HoTTLean.Model.Natural.NaturalModel
import HoTTLean.Model.Natural.UHom
import HoTTLean.Model.Natural.Interpretation
import GeometryTopos.Frontend
import GeometryTopos.Model
import GeometryTopos.Interpretation

set_option linter.unusedVariables false
set_option maxHeartbeats 0

noncomputable section

open CategoryTheory
open SynthLean
open NaturalModel
open NaturalModel.Universe
open GeometryTopos

universe u v

variable {P_cat : Type u} [CategoryTheory.Category.{v, u} P_cat] [SmallCategory P_cat] [ChosenTerminal P_cat]

#check Hurewicz_lift
#check Theorem_Geodesic_Equivalence_eps0
#check Theorem_Geodesic_Equivalence_eps1

theorem geometric_absolute_soundness
    (seq : UHomSeq P_cat)
    [UHomSeq.PiSeq seq]
    [UHomSeq.SigSeq seq]
    [UHomSeq.IdSeq seq]
    (hlmax : SynthLean.univMax ≤ seq.length)
    {Γ : Ctx Lean.Name} {t A : Expr Lean.Name} {l : Nat}
    (sΓ : seq.CObj)
    (h_ctx_sem : sΓ ∈ (geometry_topos_interpretation seq).ofCtx Γ)
    (h_typing : geometry_topos_axioms ∣ Γ ⊢[l] t : A) :
    ∃ (t_sem : yoneda.obj sΓ.1 ⟶ (seq.objs l (h_typing.lt_slen hlmax)).Tm)
      (A_sem : yoneda.obj sΓ.1 ⟶ (seq.objs l (h_typing.lt_slen hlmax)).Ty),
      t_sem ≫ (seq.objs l (h_typing.lt_slen hlmax)).tp = A_sem := by
  haveI : Fact ((geometry_topos_interpretation seq).Wf hlmax geometry_topos_axioms) :=
    ⟨geometry_topos_interpretation_wf seq hlmax⟩
  have sound_tm := (Interpretation.ofType_ofTerm_sound (s := seq) (I := geometry_topos_interpretation seq) (slen := hlmax)).2.2.2.1 h_typing
  rcases sound_tm with ⟨sΓ', hΓ_mem, llen, sA, hA_mem, st, ht_mem, st_tp⟩
  have h_eq : sΓ' = sΓ := Part.mem_unique hΓ_mem h_ctx_sem
  subst h_eq
  exact ⟨st, sA, st_tp⟩

end
