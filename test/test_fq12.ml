(** Check the routine generators do not raise any exception *)
module ValueGeneration = struct
  let zero () = ignore @@ Bls12_381.Fq12.zero ()

  let random () = ignore @@ Bls12_381.Fq12.random ()

  let one () = ignore @@ Bls12_381.Fq12.one ()

  let rec inverse_with_random_not_null () =
    let random = Bls12_381.Fq12.random () in
    if Bls12_381.Fq12.is_zero random then inverse_with_random_not_null ()
    else ignore @@ Bls12_381.Fq12.inverse random

  let inverse_with_one () =
    let one = Bls12_381.Fq12.one () in
    ignore @@ Bls12_381.Fq12.inverse one

  let negation_with_random () =
    let random = Bls12_381.Fq12.random () in
    ignore @@ Bls12_381.Fq12.negate random

  let negation_with_zero () =
    let zero = Bls12_381.Fq12.zero () in
    ignore @@ Bls12_381.Fq12.negate zero

  let negation_with_one () =
    let one = Bls12_381.Fq12.one () in
    ignore @@ Bls12_381.Fq12.negate one

  let square_with_one () =
    let one = Bls12_381.Fq12.one () in
    ignore @@ Bls12_381.Fq12.square one

  let square_with_random () =
    let g = Bls12_381.Fq12.random () in
    ignore @@ Bls12_381.Fq12.square g

  let double_with_zero () =
    let g = Bls12_381.Fq12.zero () in
    ignore @@ Bls12_381.Fq12.double g

  let double_with_one () =
    let one = Bls12_381.Fq12.one () in
    ignore @@ Bls12_381.Fq12.double one

  let double_with_random () =
    let g = Bls12_381.Fq12.random () in
    ignore @@ Bls12_381.Fq12.double g

  let double_is_same_than_multiply_by_same_element () =
    let g = Bls12_381.Fq12.random () in
    assert (Bls12_381.Fq12.eq (Bls12_381.Fq12.double g) (Bls12_381.Fq12.add g g))
end

module IsZero = struct
  let with_zero_value () =
    assert (Bls12_381.Fq12.is_zero (Bls12_381.Fq12.zero ()) = true)

  let with_random_value () =
    assert (Bls12_381.Fq12.is_zero (Bls12_381.Fq12.random ()) = false)
end

module Equality = struct
  let zero_two_different_objects () =
    assert (Bls12_381.Fq12.eq (Bls12_381.Fq12.zero ()) (Bls12_381.Fq12.zero ()))

  let zero_same_objects () =
    let zero = Bls12_381.Fq12.zero () in
    assert (Bls12_381.Fq12.eq zero zero)

  let one_two_different_objects () =
    assert (Bls12_381.Fq12.eq (Bls12_381.Fq12.one ()) (Bls12_381.Fq12.one ()))

  let one_same_objects () =
    let one = Bls12_381.Fq12.one () in
    assert (Bls12_381.Fq12.eq one one)

  let random_same_objects () =
    let random = Bls12_381.Fq12.random () in
    assert (Bls12_381.Fq12.eq random random)
end

module FieldProperties = struct
  let zero_nullifier_random () =
    (* 0 * g = 0 *)
    let zero = Bls12_381.Fq12.zero () in
    let random = Bls12_381.Fq12.random () in
    assert (Bls12_381.Fq12.is_zero (Bls12_381.Fq12.mul zero random))

  let zero_nullifier_zero () =
    (* Special case 0 * 0 = 0 *)
    let zero = Bls12_381.Fq12.zero () in
    assert (Bls12_381.Fq12.is_zero (Bls12_381.Fq12.mul zero zero))

  let zero_nullifier_one () =
    (* Special case 0 * 1 = 0 *)
    let zero = Bls12_381.Fq12.zero () in
    let one = Bls12_381.Fq12.one () in
    assert (Bls12_381.Fq12.is_zero (Bls12_381.Fq12.mul zero one))

  let inverse_of_one_is_one () =
    let one = Bls12_381.Fq12.one () in
    assert (Bls12_381.Fq12.eq (Bls12_381.Fq12.inverse one) one)

  let zero_has_no_inverse () =
    let zero = Bls12_381.Fq12.zero () in
    match Bls12_381.Fq12.inverse_opt zero with
    | Some _ -> assert false
    | None -> assert true

  let rec inverse_of_non_null_does_exist () =
    let random = Bls12_381.Fq12.random () in
    if Bls12_381.Fq12.is_zero random then inverse_of_non_null_does_exist ()
    else
      match Bls12_381.Fq12.inverse_opt random with
      | Some _ -> assert true
      | None -> assert false

  let rec inverse_of_inverse () =
    let random = Bls12_381.Fq12.random () in
    if Bls12_381.Fq12.is_zero random then inverse_of_inverse ()
    else
      assert (
        Bls12_381.Fq12.eq
          (Bls12_381.Fq12.inverse (Bls12_381.Fq12.inverse random))
          random )

  let opposite_of_opposite () =
    let random = Bls12_381.Fq12.random () in
    assert (
      Bls12_381.Fq12.eq
        (Bls12_381.Fq12.negate (Bls12_381.Fq12.negate random))
        random )

  let opposite_of_zero_is_zero () =
    let zero = Bls12_381.Fq12.zero () in
    assert (Bls12_381.Fq12.eq (Bls12_381.Fq12.negate zero) zero)

  let additive_associativity () =
    let g1 = Bls12_381.Fq12.random () in
    let g2 = Bls12_381.Fq12.random () in
    let g3 = Bls12_381.Fq12.random () in
    assert (
      Bls12_381.Fq12.eq
        (Bls12_381.Fq12.add (Bls12_381.Fq12.add g1 g2) g3)
        (Bls12_381.Fq12.add (Bls12_381.Fq12.add g2 g3) g1) )

  let distributivity () =
    let g1 = Bls12_381.Fq12.random () in
    let g2 = Bls12_381.Fq12.random () in
    let g3 = Bls12_381.Fq12.random () in
    assert (
      Bls12_381.Fq12.eq
        (Bls12_381.Fq12.mul (Bls12_381.Fq12.add g1 g2) g3)
        (Bls12_381.Fq12.add
           (Bls12_381.Fq12.mul g1 g3)
           (Bls12_381.Fq12.mul g2 g3)) )

  let multiplicative_associativity () =
    let g1 = Bls12_381.Fq12.random () in
    let g2 = Bls12_381.Fq12.random () in
    let g3 = Bls12_381.Fq12.random () in
    assert (
      Bls12_381.Fq12.eq
        (Bls12_381.Fq12.mul (Bls12_381.Fq12.mul g1 g2) g3)
        (Bls12_381.Fq12.mul (Bls12_381.Fq12.mul g2 g3) g1) )
end

let () =
  let open Alcotest in
  run
    "Fq12"
    [ ( "is_zero",
        [ test_case "with zero value" `Quick IsZero.with_zero_value;
          test_case "with random value" `Quick IsZero.with_random_value ] );
      ( "value generation",
        [ test_case "zero" `Quick ValueGeneration.zero;
          test_case "random" `Quick ValueGeneration.random;
          test_case
            "inverse_random_not_null"
            `Quick
            ValueGeneration.inverse_with_random_not_null;
          test_case "negate_with_one" `Quick ValueGeneration.negation_with_one;
          test_case "negate_with_zero" `Quick ValueGeneration.negation_with_zero;
          test_case "double_with_one" `Quick ValueGeneration.double_with_one;
          test_case "double_with_zero" `Quick ValueGeneration.double_with_zero;
          test_case
            "double_with_random"
            `Quick
            ValueGeneration.double_with_random;
          test_case "square_with_one" `Quick ValueGeneration.square_with_one;
          test_case
            "square_with_random"
            `Quick
            ValueGeneration.square_with_random;
          test_case
            "negate_with_random"
            `Quick
            ValueGeneration.negation_with_random;
          test_case
            "double_is_same_than_multiply_by_same_element"
            `Quick
            ValueGeneration.double_is_same_than_multiply_by_same_element;
          test_case "inverse_one" `Quick ValueGeneration.inverse_with_one ] );
      ( "equality",
        [ test_case
            "zero_two_different_objects"
            `Quick
            Equality.zero_two_different_objects;
          test_case "zero_same_objects" `Quick Equality.zero_same_objects;
          test_case
            "one_two_different_objects"
            `Quick
            Equality.one_two_different_objects;
          test_case "one_same_objects" `Quick Equality.one_same_objects;
          test_case "random_same_objects" `Quick Equality.random_same_objects ]
      );
      ( "Field properties",
        [ test_case
            "zero_nullifier_one"
            `Quick
            FieldProperties.zero_nullifier_one;
          test_case
            "zero_nullifier_zero"
            `Quick
            FieldProperties.zero_nullifier_zero;
          test_case
            "zero_nullifier_random"
            `Quick
            FieldProperties.zero_nullifier_random;
          test_case
            "inverse_of_non_null_does_exist"
            `Quick
            FieldProperties.inverse_of_non_null_does_exist;
          test_case
            "inverse_of_one_is_one"
            `Quick
            FieldProperties.inverse_of_one_is_one;
          test_case
            "zero_has_no_inverse"
            `Quick
            FieldProperties.zero_has_no_inverse;
          test_case
            "inverse_of_inverse"
            `Quick
            FieldProperties.inverse_of_inverse;
          test_case
            "opposite_of_opposite"
            `Quick
            FieldProperties.opposite_of_opposite;
          test_case
            "opposite_of_zero_is_zero"
            `Quick
            FieldProperties.opposite_of_zero_is_zero;
          test_case
            "additive_associativity"
            `Quick
            FieldProperties.additive_associativity;
          test_case "distributivity" `Quick FieldProperties.distributivity;
          test_case
            "multiplicative_associativity"
            `Quick
            FieldProperties.multiplicative_associativity ] ) ]
