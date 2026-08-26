import HoTTLean.Frontend.Commands

noncomputable section

namespace GeometryTopos
set_option linter.unusedVariables false
set_option maxHeartbeats 0

declare_theory geometry_topos

geometry_topos axiom GeomIdentity : {A : Type} → A → A → Type
geometry_topos axiom Id_refl : {A : Type} → (a : A) → GeomIdentity a a
geometry_topos axiom Id_symm : {A : Type} → {a b : A} → GeomIdentity a b → GeomIdentity b a
geometry_topos axiom Id_trans : {A : Type} → {a b c : A} → GeomIdentity a b → GeomIdentity b c → GeomIdentity a c
geometry_topos axiom Id_congr : {A B : Type} → (f : A → B) → {a b : A} → GeomIdentity a b → GeomIdentity (f a) (f b)

geometry_topos axiom geom_funext : {A B : Type} → {f g : A → B} →
  ((x : A) → GeomIdentity (f x) (g x)) → GeomIdentity f g

geometry_topos axiom Empty_obj : Type
geometry_topos axiom Empty_rec : {A : Type} → Empty_obj → A

geometry_topos axiom Unit_obj : Type
geometry_topos axiom unit_star : Unit_obj

geometry_topos axiom Coprod : Type → Type → Type
geometry_topos axiom Coprod.inl : {A B : Type} → A → Coprod A B
geometry_topos axiom Coprod.inr : {A B : Type} → B → Coprod A B
geometry_topos axiom Coprod.casesOn : {A B C : Type} → (A → C) → (B → C) → Coprod A B → C

geometry_topos def Prod_obj (A B : Type) : Type :=
  Sigma (fun (_ : A) => B)

geometry_topos def pair_obj {A B : Type} (a : A) (b : B) : Prod_obj A B :=
  ⟨a, b⟩

geometry_topos def fst_obj {A B : Type} (p : Prod_obj A B) : A :=
  p.1

geometry_topos def snd_obj {A B : Type} (p : Prod_obj A B) : B :=
  p.2

geometry_topos def IsSet (A : Type) : Type :=
  (x y : A) → (p q : GeomIdentity x y) → GeomIdentity p q

geometry_topos def pempty_is_set : IsSet Empty_obj :=
  fun (x y : Empty_obj) (p q : GeomIdentity x y) =>
    @Empty_rec (GeomIdentity p q) x

geometry_topos axiom prod_is_set : {A B : Type} → IsSet A → IsSet B → IsSet (Prod_obj A B)

geometry_topos #print GeomIdentity
geometry_topos #print IsSet
geometry_topos #print pempty_is_set
geometry_topos #print prod_is_set

geometry_topos axiom Category : Type → Type 1

geometry_topos axiom Cat_Hom : {P : Type} → Category P → P → P → Type
geometry_topos axiom Cat_hom_is_set : {P : Type} → (C : Category P) → (X Y : P) → IsSet (Cat_Hom C X Y)
geometry_topos axiom Cat_id : {P : Type} → (C : Category P) → (X : P) → Cat_Hom C X X
geometry_topos axiom Cat_comp : {P : Type} → (C : Category P) → {X Y Z : P} → Cat_Hom C X Y → Cat_Hom C Y Z → Cat_Hom C X Z
geometry_topos axiom Cat_id_comp : {P : Type} → (C : Category P) → {X Y : P} → (f : Cat_Hom C X Y) → GeomIdentity (Cat_comp C (Cat_id C X) f) f
geometry_topos axiom Cat_comp_id : {P : Type} → (C : Category P) → {X Y : P} → (f : Cat_Hom C X Y) → GeomIdentity (Cat_comp C f (Cat_id C Y)) f
geometry_topos axiom Cat_assoc : {P : Type} → (C : Category P) → {W X Y Z : P} → (f : Cat_Hom C W X) → (g : Cat_Hom C X Y) → (h : Cat_Hom C Y Z) → GeomIdentity (Cat_comp C (Cat_comp C f g) h) (Cat_comp C f (Cat_comp C g h))

geometry_topos axiom Presheaf : (P : Type) → Category P → Type 1

geometry_topos axiom Psh_obj : {P : Type} → {C : Category P} → Presheaf P C → P → Type
geometry_topos axiom Psh_is_set : {P : Type} → {C : Category P} → (F : Presheaf P C) → (X : P) → IsSet (Psh_obj F X)
geometry_topos axiom Psh_map : {P : Type} → {C : Category P} → (F : Presheaf P C) → {X Y : P} → Cat_Hom C X Y → Psh_obj F Y → Psh_obj F X
geometry_topos axiom Psh_map_id : {P : Type} → {C : Category P} → (F : Presheaf P C) → (X : P) → (x : Psh_obj F X) → GeomIdentity (Psh_map F (Cat_id C X) x) x
geometry_topos axiom Psh_map_comp : {P : Type} → {C : Category P} → (F : Presheaf P C) → {X Y Z : P} → (f : Cat_Hom C X Y) → (g : Cat_Hom C Y Z) → (x : Psh_obj F Z) → GeomIdentity (Psh_map F (Cat_comp C f g) x) (Psh_map F f (Psh_map F g x))

geometry_topos axiom NatTrans : {P : Type} → {C : Category P} → (A B : Presheaf P C) → Type

geometry_topos axiom NT_app : {P : Type} → {C : Category P} → {A B : Presheaf P C} → NatTrans A B → (X : P) → Psh_obj A X → Psh_obj B X
geometry_topos axiom NT_nat : {P : Type} → {C : Category P} → {A B : Presheaf P C} → (F : NatTrans A B) → {X Y : P} → (f : Cat_Hom C X Y) → (x : Psh_obj A Y) → GeomIdentity (Psh_map B f (NT_app F Y x)) (NT_app F X (Psh_map A f x))
geometry_topos axiom NT_ext : {P : Type} → {C : Category P} → {A B : Presheaf P C} → {f g : NatTrans A B} → ((X : P) → (x : Psh_obj A X) → GeomIdentity (NT_app f X x) (NT_app g X x)) → GeomIdentity f g

geometry_topos axiom NT_id : {P : Type} → {C : Category P} → (A : Presheaf P C) → NatTrans A A
geometry_topos axiom NT_id_app : {P : Type} → {C : Category P} → (A : Presheaf P C) → (X : P) → (x : Psh_obj A X) → GeomIdentity (NT_app (NT_id A) X x) x

geometry_topos axiom NT_comp : {P : Type} → {C : Category P} → {A B D : Presheaf P C} → NatTrans A B → NatTrans B D → NatTrans A D
geometry_topos axiom NT_comp_app : {P : Type} → {C : Category P} → {A B D : Presheaf P C} → (f : NatTrans A B) → (g : NatTrans B D) → (X : P) → (x : Psh_obj A X) → GeomIdentity (NT_app (NT_comp f g) X x) (NT_app g X (NT_app f X x))

geometry_topos axiom NT_id_comp : {P : Type} → {C : Category P} → {A B : Presheaf P C} → (f : NatTrans A B) → GeomIdentity (NT_comp (NT_id A) f) f
geometry_topos axiom NT_comp_id : {P : Type} → {C : Category P} → {A B : Presheaf P C} → (f : NatTrans A B) → GeomIdentity (NT_comp f (NT_id B)) f
geometry_topos axiom NT_assoc : {P : Type} → {C : Category P} → {A B D E : Presheaf P C} → (f : NatTrans A B) → (g : NatTrans B D) → (h : NatTrans D E) → GeomIdentity (NT_comp (NT_comp f g) h) (NT_comp f (NT_comp g h))

geometry_topos axiom PresheafIso : {P : Type} → {C : Category P} → (A B : Presheaf P C) → Type

geometry_topos axiom Iso_hom : {P : Type} → {C : Category P} → {A B : Presheaf P C} → PresheafIso A B → NatTrans A B
geometry_topos axiom Iso_inv : {P : Type} → {C : Category P} → {A B : Presheaf P C} → PresheafIso A B → NatTrans B A
geometry_topos axiom Iso_hom_inv_id : {P : Type} → {C : Category P} → {A B : Presheaf P C} → (I : PresheafIso A B) → GeomIdentity (NT_comp (Iso_hom I) (Iso_inv I)) (NT_id A)
geometry_topos axiom Iso_inv_hom_id : {P : Type} → {C : Category P} → {A B : Presheaf P C} → (I : PresheafIso A B) → GeomIdentity (NT_comp (Iso_inv I) (Iso_hom I)) (NT_id B)
geometry_topos axiom Iso_symm : {P : Type} → {C : Category P} → {A B : Presheaf P C} → PresheafIso A B → PresheafIso B A
geometry_topos axiom Iso_trans : {P : Type} → {C : Category P} → {A B D : Presheaf P C} → PresheafIso A B → PresheafIso B D → PresheafIso A D

geometry_topos axiom yObj : {P : Type} → (C : Category P) → P → Presheaf P C

geometry_topos axiom yObj_obj_fwd : {P : Type} → (C : Category P) → (P_obj Q : P) →
  Psh_obj (yObj C P_obj) Q → Cat_Hom C Q P_obj
geometry_topos axiom yObj_obj_rev : {P : Type} → (C : Category P) → (P_obj Q : P) →
  Cat_Hom C Q P_obj → Psh_obj (yObj C P_obj) Q

geometry_topos def IsMonomorphism {P : Type} {C : Category P} {A B : Presheaf P C} (f : NatTrans A B) : Type 1 :=
  {D : Presheaf P C} → (g h : NatTrans D A) → GeomIdentity (NT_comp g f) (NT_comp h f) → GeomIdentity g h

geometry_topos axiom pzero : {P : Type} → (C : Category P) → Presheaf P C

geometry_topos def IsInitial {P : Type} {C : Category P} (I : Presheaf P C) : Type 1 :=
  @Sigma.{1, 1} ((X : Presheaf P C) → NatTrans I X) (fun to =>
    (X : Presheaf P C) → (f : NatTrans I X) → GeomIdentity f (to X)
  )

geometry_topos def IsEpimorphism {P : Type} {C : Category P} {A B : Presheaf P C} (f : NatTrans A B) : Type 1 :=
  @Sigma.{1, 0} ({D : Presheaf P C} → (g h : NatTrans B D) → GeomIdentity (NT_comp f g) (NT_comp f h) → GeomIdentity g h) (fun _ =>
    (P_obj : P) → (b : Psh_obj B P_obj) → @Sigma.{0, 0} (Psh_obj A P_obj) (fun a =>
      GeomIdentity (NT_app f P_obj a) b
    )
  )

geometry_topos axiom yonedaElemToMorphism : {P : Type} → {C : Category P} → {P_obj : P} → {A : Presheaf P C} → (a : Psh_obj A P_obj) → NatTrans (yObj C P_obj) A

geometry_topos def IsRepresentable {P : Type} {C : Category P} (X : Presheaf P C) : Type :=
  @Sigma.{0, 0} P (fun P_obj => PresheafIso X (yObj C P_obj))

geometry_topos def IsAssembly {P : Type} {C : Category P} (X : Presheaf P C) : Type 1 :=
  @Sigma.{0, 1} P (fun P_obj =>
    @Sigma.{0, 1} P (fun Q_obj =>
      @Sigma.{0, 1} (NatTrans (yObj C P_obj) (yObj C Q_obj)) (fun f =>
        @Sigma.{0, 1} (NatTrans (yObj C P_obj) X) (fun e =>
          @Sigma.{0, 1} (NatTrans X (yObj C Q_obj)) (fun m =>
            @Sigma.{0, 1} (GeomIdentity f (NT_comp e m)) (fun _ =>
              @Sigma.{1, 1} (IsEpimorphism e) (fun _ =>
                IsMonomorphism m
              )
            )
          )
        )
      )
    )
  )

geometry_topos axiom presheafProd : {P : Type} → (C : Category P) → (A B : Presheaf P C) → Presheaf P C
geometry_topos axiom presheafLift : {P : Type} → (C : Category P) → (T A B : Presheaf P C) → NatTrans T A → NatTrans T B → NatTrans T (presheafProd C A B)

geometry_topos def IsInternalEquivalenceRelation {P : Type} {C : Category P} {A E : Presheaf P C} (q1 q2 : NatTrans E A) : Type 1 :=
  @Sigma.{1, 1} (IsMonomorphism (presheafLift C E A A q1 q2)) (fun _ =>
    @Sigma.{0, 1} ((r : NatTrans A E) → Prod_obj (GeomIdentity (NT_comp r q1) (NT_id A)) (GeomIdentity (NT_comp r q2) (NT_id A))) (fun _ =>
      @Sigma.{0, 1} ((s : NatTrans E E) → Prod_obj (GeomIdentity (NT_comp s q1) q2) (GeomIdentity (NT_comp s q2) q1)) (fun _ =>
        (T : Presheaf P C) → (x y z : NatTrans T A) → (e1 e2 : NatTrans T E) →
          Prod_obj (GeomIdentity (NT_comp e1 q1) x) (
          Prod_obj (GeomIdentity (NT_comp e1 q2) y) (
          Prod_obj (GeomIdentity (NT_comp e2 q1) y) (
          GeomIdentity (NT_comp e2 q2) z))) →
            @Sigma.{0, 0} (NatTrans T E) (fun e3 =>
              Prod_obj (GeomIdentity (NT_comp e3 q1) x) (GeomIdentity (NT_comp e3 q2) z)
            )
      )
    )
  )

geometry_topos def IsCoequalizer {P : Type} {C : Category P} {A B C_presheaf : Presheaf P C} (f g : NatTrans A B) (p : NatTrans B C_presheaf) : Type 1 :=
  @Sigma.{0, 1} (GeomIdentity (NT_comp f p) (NT_comp g p)) (fun _ =>
    (D : Presheaf P C) → (h : NatTrans B D) → GeomIdentity (NT_comp f h) (NT_comp g h) →
      @Sigma.{0, 0} (NatTrans C_presheaf D) (fun k =>
        Prod_obj (GeomIdentity (NT_comp p k) h) ((k' : NatTrans C_presheaf D) → GeomIdentity (NT_comp p k') h → GeomIdentity k' k)
      )
  )

geometry_topos def IsEffObject {P : Type} {C : Category P} (X : Presheaf P C) : Type 1 :=
  @Sigma.{1, 1} (Presheaf P C) (fun A =>
    @Sigma.{1, 1} (Presheaf P C) (fun E =>
      @Sigma.{0, 1} (NatTrans E A) (fun q1 =>
        @Sigma.{0, 1} (NatTrans E A) (fun q2 =>
          @Sigma.{0, 1} (NatTrans A X) (fun p =>
            @Sigma.{1, 1} (IsAssembly A) (fun _ =>
              @Sigma.{1, 1} (IsAssembly E) (fun _ =>
                @Sigma.{1, 1} (IsInternalEquivalenceRelation q1 q2) (fun _ =>
                  IsCoequalizer q1 q2 p
                )
              )
            )
          )
        )
      )
    )
  )

geometry_topos axiom rep_is_asm : {P : Type} → {C : Category P} → (X : Presheaf P C) → IsRepresentable X → IsAssembly X
geometry_topos axiom asm_is_eff : {P : Type} → {C : Category P} → (X : Presheaf P C) → IsAssembly X → IsEffObject X

geometry_topos axiom IsPullbackSquare : {P : Type} → {C : Category P} → {K Y X K' : Presheaf P C} → NatTrans K' K → NatTrans K' Y → NatTrans K X → NatTrans Y X → Type 1
geometry_topos axiom IsCompactObject : {P : Type} → {C : Category P} → Presheaf P C → Type 1

geometry_topos def IsCompactMorphism {P : Type} {C : Category P} {Y X : Presheaf P C} (f : NatTrans Y X) : Type 1 :=
  (K : Presheaf P C) → IsCompactObject K → (g : NatTrans K X) →
  (K' : Presheaf P C) → (fst : NatTrans K' K) → (snd : NatTrans K' Y) →
  IsPullbackSquare fst snd g f → IsCompactObject K'

geometry_topos axiom IsCoherentObject : {P : Type} → {C : Category P} → Presheaf P C → Type 1

geometry_topos axiom InternalGroupoid : {P : Type} → Category P → Type 1

geometry_topos axiom IG_G0 : {P : Type} → {C : Category P} → InternalGroupoid C → Presheaf P C
geometry_topos axiom IG_G1 : {P : Type} → {C : Category P} → InternalGroupoid C → Presheaf P C
geometry_topos axiom IG_dom : {P : Type} → {C : Category P} → (G : InternalGroupoid C) → NatTrans (IG_G1 G) (IG_G0 G)
geometry_topos axiom IG_cod : {P : Type} → {C : Category P} → (G : InternalGroupoid C) → NatTrans (IG_G1 G) (IG_G0 G)
geometry_topos axiom IG_id_map : {P : Type} → {C : Category P} → (G : InternalGroupoid C) → NatTrans (IG_G0 G) (IG_G1 G)

geometry_topos axiom GroupoidMorphism : {P : Type} → {C : Category P} → InternalGroupoid C → InternalGroupoid C → Type 1
geometry_topos axiom GM_f0 : {P : Type} → {C : Category P} → (G H : InternalGroupoid C) → GroupoidMorphism G H → NatTrans (IG_G0 G) (IG_G0 H)
geometry_topos axiom GM_f1 : {P : Type} → {C : Category P} → (G H : InternalGroupoid C) → GroupoidMorphism G H → NatTrans (IG_G1 G) (IG_G1 H)

geometry_topos axiom GroupoidProduct : {P : Type} → {C : Category P} → InternalGroupoid C → InternalGroupoid C → Type 1
geometry_topos axiom GP_prod : {P : Type} → {C : Category P} → {G H : InternalGroupoid C} → GroupoidProduct G H → InternalGroupoid C

geometry_topos def GroupoidDiagonal {P : Type} {C : Category P} (G : InternalGroupoid C) (GxG : GroupoidProduct G G) : Type 1 :=
  GroupoidMorphism G (GP_prod GxG)

geometry_topos axiom GD_diag : {P : Type} → {C : Category P} → {G : InternalGroupoid C} → {GxG : GroupoidProduct G G} → GroupoidDiagonal G GxG → GroupoidMorphism G (GP_prod GxG)

geometry_topos def GroupoidSecondDiagonal {P : Type} {C : Category P} (G : InternalGroupoid C) (GxG : GroupoidProduct G G) (Diag : GroupoidDiagonal G GxG) : Type :=
  NatTrans (IG_G0 G) (IG_G0 (GP_prod GxG))

geometry_topos axiom IsPseudoCompact : {P : Type} → {C : Category P} → InternalGroupoid C → Type 1
geometry_topos axiom IsCoherentGroupoid : {P : Type} → {C : Category P} → (G : InternalGroupoid C) → (GxG : GroupoidProduct G G) → (Diag : GroupoidDiagonal G GxG) → GroupoidSecondDiagonal G GxG Diag → Type 1
geometry_topos axiom IsWeakEquivalence : {P : Type} → {C : Category P} → {G H : InternalGroupoid C} → GroupoidMorphism G H → Type 1

geometry_topos def IsCofibration {P : Type} {C : Category P} {G H : InternalGroupoid C} (f : GroupoidMorphism G H) : Type 1 :=
  IsMonomorphism (GM_f0 G H f)

geometry_topos axiom IsFibrantGroupoid : {P : Type} → {C : Category P} → InternalGroupoid C → Type 1

geometry_topos def IsHomotopyMonomorphism {P : Type} {C : Category P} {G H : InternalGroupoid C} (f : GroupoidMorphism G H) : Type :=
  Unit_obj

geometry_topos axiom IsZeroType : {P : Type} → {C : Category P} → (G : InternalGroupoid C) → (GxG : GroupoidProduct G G) → GroupoidDiagonal G GxG → Type 1

geometry_topos axiom Theorem_CohZeroType_Eq_CohObject : {P : Type} → {C : Category P} → Type 1

geometry_topos axiom GeometryContext : (P : Type) → (C : Category P) → @Theorem_CohZeroType_Eq_CohObject P C → Type 1

geometry_topos axiom Ctx_Manifold : {P : Type} → {C : Category P} → {trunc : @Theorem_CohZeroType_Eq_CohObject P C} → GeometryContext P C trunc → Presheaf P C

geometry_topos axiom PathSpace_P_presheaf : {P : Type} → {C : Category P} → {X M : Presheaf P C} → Type
geometry_topos axiom PathSpace_eps0 : {P : Type} → {C : Category P} → {X M : Presheaf P C} → PathSpace_P_presheaf (X := X) (M := M) → NatTrans X M
geometry_topos axiom PathSpace_eps1 : {P : Type} → {C : Category P} → {X M : Presheaf P C} → PathSpace_P_presheaf (X := X) (M := M) → NatTrans X M

geometry_topos axiom Hurewicz_lift : {P : Type} → {C : Category P} → {trunc : @Theorem_CohZeroType_Eq_CohObject P C} →
  (ctx : GeometryContext P C trunc) → {X : Presheaf P C} →
  (start : NatTrans X (Ctx_Manifold ctx)) →
  (p : PathSpace_P_presheaf (X := X) (M := Ctx_Manifold ctx)) →
  NatTrans X (Ctx_Manifold ctx)

geometry_topos axiom Theorem_Geodesic_Equivalence_eps0 : {P : Type} → {C : Category P} → {trunc : @Theorem_CohZeroType_Eq_CohObject P C} →
  (ctx : GeometryContext P C trunc) → {X : Presheaf P C} →
  (start : NatTrans X (Ctx_Manifold ctx)) →
  (p : PathSpace_P_presheaf (X := X) (M := Ctx_Manifold ctx)) →
  GeomIdentity (@PathSpace_eps0 P C X (Ctx_Manifold ctx) p) start

geometry_topos axiom Theorem_Geodesic_Equivalence_eps1 : {P : Type} → {C : Category P} → {trunc : @Theorem_CohZeroType_Eq_CohObject P C} →
  (ctx : GeometryContext P C trunc) → {X : Presheaf P C} →
  (start : NatTrans X (Ctx_Manifold ctx)) →
  (p : PathSpace_P_presheaf (X := X) (M := Ctx_Manifold ctx)) →
  GeomIdentity (@PathSpace_eps1 P C X (Ctx_Manifold ctx) p) (@Hurewicz_lift P C trunc ctx X start p)

geometry_topos #print Hurewicz_lift
geometry_topos #print Theorem_Geodesic_Equivalence_eps0
geometry_topos #print Theorem_Geodesic_Equivalence_eps1

end GeometryTopos
