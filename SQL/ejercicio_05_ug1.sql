/*
Valida el contenido del grocery bundle creado después de enviar una estructura inválida. Permite verificar que no se haya agregado nada en el paquete.
*/

SELECT *
FROM grocery_bundle_products
WHERE groceryBundleId = {groceryBundleId};
