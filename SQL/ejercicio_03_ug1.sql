/*
Valida si el producto con ID 200 quedó asociado al grocery bundle creado.
Se utiliza para comprobar que un producto inexistente no haya sido agregado
ni asociado al grocery bundle.
*/

SELECT *
FROM grocery_bundle_products
WHERE productId = 200
  AND groceryBundleId = {groceryBundleId};
