/*
Consulta para validar que el producto no quedara agregado ni asociado al paquete creado.
*/

SELECT *
FROM grocery_bundle_products
WHERE productId = 3
  AND groceryBundleId = {groceryBundleId};
