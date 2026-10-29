/*
Valida la cantidad de productos únicos asociados al grocery bundle creado. Se utiliza para comprobar que el número de productos asociados al bundle corresponda con la cantidad esperada, sin contar los productos repetidos.
*/

SELECT
    COUNT(DISTINCT productId) AS All_Products
FROM grocery_bundle_products
WHERE groceryBundleId = {groceryBundleId};
