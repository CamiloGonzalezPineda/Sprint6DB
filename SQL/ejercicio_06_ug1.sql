/*
Valida que el grocery bundle tenga la cantidad esperada de productos únicos. Se utiliza para comprobar que se hayan asociado correctamente los productos al grocery bundle, sin contar IDs de los productos repetidos.
*/

SELECT
    COUNT(DISTINCT productId) AS All_Products
FROM grocery_bundle_products
WHERE groceryBundleId = {groceryBundleId};
