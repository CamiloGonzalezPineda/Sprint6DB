/*
Valida si el producto con ID 3 se encuentra asociado al grocery bundle creado.
*/

SELECT *
FROM grocery_bundle_products
WHERE productId = 3
  AND groceryBundleId = {groceryBundleId};
