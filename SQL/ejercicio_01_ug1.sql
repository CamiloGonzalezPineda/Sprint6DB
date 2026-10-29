/*
Valida que el producto 3 esté correctamente asociado al grocery bundle y
permite comprobar los datos del producto, la relación, el paquete y la cantidad.
*/

SELECT
    pm.name AS Name_Product,
    pm.id AS Id_Product,
    pm.price AS Price_Product,
    pm.weight AS Weight_Product,
    pm.units AS Units_product,
    gbp.quantity AS Quantity_Product,
    gbp.groceryBundleId AS Id_Package,
    gbm.name AS name_Package
FROM product_model pm
JOIN grocery_bundle_products gbp
    ON gbp.productId = pm.id
JOIN grocery_bundle_model gbm
    ON gbm.id = gbp.groceryBundleId
WHERE
    pm.id = 3
    AND gbp.groceryBundleId = {groceryBundleId};

