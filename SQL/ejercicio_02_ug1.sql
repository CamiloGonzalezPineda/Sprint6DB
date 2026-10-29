/*
Valida la cantidad de productos asociados al grocery bundle.
Se utiliza para comprobar que ningún producto haya sido asociado
al bundle después de intentar agregar una cantidad de
productos que supera el límite permitido.
*/

SELECT
    COUNT(DISTINCT productId) AS All_Products
FROM grocery_bundle_products
WHERE groceryBundleId = {groceryBundleId};
