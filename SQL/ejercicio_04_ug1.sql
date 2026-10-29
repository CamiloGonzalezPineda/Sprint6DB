/*
Valida que el producto 3 no haya quedado asociado al grocery bundle inexistente
con ID 20.
*/

SELECT *
FROM grocery_bundle_products
WHERE productId = 3
  AND groceryBundleId = 20;
