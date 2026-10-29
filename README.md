# API & Database Testing | Urban Grocers

Proyecto de **QA Engineering** enfocado en la validación de la persistencia de datos en la base de datos de **Urban Grocers** a partir de las operaciones realizadas mediante la API.

El objetivo principal fue verificar que las respuestas de la API fueran consistentes con el estado real de la base de datos, utilizando **SQL, relaciones entre tablas, consultas de validación y análisis de resultados**.

---

## Documentación del proyecto

**Casos de prueba y resultados:**  
[Ver archivo Excel](https://docs.google.com/spreadsheets/d/1y1EAxKcr-H80Bli7dLdzvIX_2-gLsCul/edit?usp=sharing&ouid=106691349693826056792&rtpof=true&sd=true)


## Objetivo del proyecto

Validar que las operaciones realizadas sobre los productos de los grocery bundles se reflejen correctamente en la base de datos y que las solicitudes inválidas no provoquen cambios incorrectos.

El proyecto permitió trabajar con el flujo:

**API Request → API Response → Database → SQL Validation → Expected vs Actual → Pass/Fail**

---

## Tecnologías y herramientas

- **SQL**
- **SQLite**
- **Postman**
- **Swagger**
- **Git / GitHub**
- **Visual Studio Code**
- **Urban Grocers API**

### Conceptos de SQL utilizados

- `SELECT`
- `WHERE`
- `COUNT()`
- `COUNT(DISTINCT ...)`
- `SUM()`
- `JOIN`
- `INNER JOIN`
- `LEFT JOIN`
- `GROUP BY`
- `ORDER BY`
- `IS NULL`
- `CAST`
- Alias
- Claves primarias y foráneas
- Relaciones entre tablas
- Validación de integridad de datos

---

## Alcance de las pruebas

El proyecto se enfocó principalmente en la funcionalidad de **agregar productos a un grocery bundle**.

Se validaron escenarios positivos, negativos y de límites:

| Caso | Escenario | Resultado |
|---|---|---|
| UG-1-TC-01 | Agregar producto válido | Detectada inconsistencia API/BD |
| UG-1-TC-02 | Intentar agregar 31 productos | Correcto |
| UG-1-TC-03 | Agregar `productId` inexistente | Bug detectado |
| UG-1-TC-04 | Agregar producto a bundle inexistente | Correcto |
| UG-1-TC-05 | Enviar `productsList` con estructura inválida | Bug detectado |
| UG-1-TC-06 | Agregar exactamente 30 productos | Detectada inconsistencia API/BD |
| UG-1-TC-07 | Enviar `quantity = 0` | Bug detectado |
| UG-1-TC-08 | Omitir `quantity` | Bug detectado |
| UG-1-TC-09 | Agregar 29 productos | Detectada inconsistencia API/BD |

---

## Validación de base de datos

Uno de los objetivos principales fue comprobar que las operaciones realizadas mediante la API produjeran el estado esperado en la base de datos.

Las tablas principales utilizadas fueron:

### `grocery_bundle_model`

Contiene información relacionada con los grocery bundles, incluyendo:

- `id`
- `name`
- `productsList`
- `productsCount`
- `groceryCollectionId`
- `userId`

### `grocery_bundle_products`

Tabla utilizada para representar la relación entre los productos y los grocery bundles.

Permite validar información como:

- `groceryBundleId`
- `productId`
- `quantity`

Esta tabla fue especialmente importante para comprobar si un producto realmente quedó asociado a un bundle.

### `product_model`

Contiene la información de los productos, como:

- `id`
- `name`
- `price`
- `weight`
- `units`
- `categoryId`

---

## Relaciones utilizadas

Durante el proyecto se analizaron las relaciones entre las tablas para determinar cómo verificar los cambios realizados mediante la API.

Ejemplo:

```text
product_model
      │
      │ productId
      ▼
grocery_bundle_products
      │
      │ groceryBundleId
      ▼
grocery_bundle_model
```

La tabla `grocery_bundle_products` funciona como tabla intermedia entre productos y grocery bundles.

---

## Validación de productos únicos

Para validar el número de productos únicos asociados a un bundle se utilizó:

```sql
SELECT
    COUNT(DISTINCT productId) AS All_Products
FROM grocery_bundle_products
WHERE groceryBundleId = {groceryBundleId};
```

El uso de `COUNT(DISTINCT productId)` permite contar productos únicos sin duplicar un producto cuando existen diferentes cantidades asociadas.

Esta consulta fue utilizada especialmente para validar los límites de:

- 29 productos
- 30 productos
- 31 productos

---

## Ejemplo de validación con JOIN

Para comprobar la información del producto, su asociación con el bundle y la cantidad registrada:

```sql
SELECT
    pm.name AS Name_Product,
    pm.id AS Id_Product,
    pm.price AS Price_Product,
    pm.weight AS Weight_Product,
    pm.units AS Units_Product,
    gbp.quantity AS Quantity_Product,
    gbp.groceryBundleId AS Id_Package,
    gbm.name AS Name_Package
FROM product_model pm
JOIN grocery_bundle_products gbp
    ON gbp.productId = pm.id
JOIN grocery_bundle_model gbm
    ON gbm.id = gbp.groceryBundleId
WHERE
    pm.id = 3
    AND gbp.groceryBundleId = {groceryBundleId};
```

Esta consulta permite comprobar:

- Datos del producto.
- Asociación entre producto y bundle.
- Cantidad (`quantity`).
- ID del bundle.
- Nombre del bundle.

---

## Metodología de validación

Para cada caso de prueba se siguió un proceso similar:

1. Crear o utilizar un grocery bundle según las condiciones del caso.
2. Ejecutar la solicitud correspondiente mediante la API.
3. Registrar el código de respuesta y el resultado obtenido.
4. Obtener una copia actualizada de la base de datos.
5. Ejecutar la consulta SQL correspondiente.
6. Comparar el estado real de la base de datos con el estado esperado.
7. Determinar el resultado del caso de prueba.
8. Registrar un bug cuando se encontró un comportamiento incorrecto.

---

## Defectos encontrados

Durante las pruebas se identificaron inconsistencias entre el comportamiento esperado y el comportamiento real de la API.

Entre los problemas encontrados:

### 1. `productId` inexistente

La API aceptó un `productId` inexistente y respondió:

```text
200 OK
```

cuando se esperaba:

```text
400 Bad Request
```

La validación de la base de datos permitió comprobar que el producto inexistente no debía quedar asociado.

---

### 2. `productsList` con estructura inválida

Al enviar una estructura inválida para `productsList`, la API produjo un error:

```text
500 Internal Server Error
```

con un error relacionado con:

```text
productsList.map is not a function
```

El comportamiento esperado era una respuesta controlada de tipo:

```text
400 Bad Request
```

---

### 3. `quantity = 0`

La API aceptó una solicitud con:

```text
quantity = 0
```

y respondió:

```text
200 OK
```

aunque la cantidad debía ser considerada inválida.

La validación de la base de datos permitió comprobar que el producto no quedó asociado al bundle.

---

### 4. `quantity` omitido

Al omitir el parámetro `quantity`, la API produjo:

```text
500 Internal Server Error
```

con un error relacionado con:

```text
invalid input syntax for type integer: "NaN"
```

El comportamiento esperado era una respuesta controlada de tipo:

```text
400 Bad Request
```



> La estructura puede adaptarse a los archivos finales incluidos en el proyecto.

---

## Aprendizajes

Este proyecto permitió reforzar conocimientos de:

- Validación de APIs.
- Validación de persistencia en bases de datos.
- SQL aplicado a testing.
- Relaciones entre tablas.
- Claves primarias y foráneas.
- `JOIN` entre múltiples tablas.
- Consultas de agregación.
- Validación de límites.
- Identificación de inconsistencias entre API y BD.
- Diseño de consultas orientadas a casos de prueba.
- Análisis y documentación de defectos.
- Uso de evidencia para respaldar resultados de QA.

---

## Rol

**QA Engineer — Database & API Testing**

Proyecto realizado como parte de la formación en **QA Engineering de TripleTen**.

---

