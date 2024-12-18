-- возврат списка клиентов с суммарной стоимостью заказов

SELECT 
    c.FirstName, 
    c.LastName, 
    SUM(o.TotalAmount) AS TotalSpent
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID
ORDER BY 
    TotalSpent DESC;


-- Средняя суммарная стоимость заказов

WITH CustomerTotal AS (
    SELECT 
        CustomerID, 
        SUM(TotalAmount) AS TotalSpent
    FROM 
        Orders
    GROUP BY 
        CustomerID
),
AverageSpent AS (
    SELECT AVG(TotalSpent) AS AvgSpent FROM CustomerTotal
)
SELECT 
    c.FirstName, 
    c.LastName, 
    ct.TotalSpent, 
    avg.AvgSpent
FROM 
    Customers c
JOIN 
    CustomerTotal ct ON c.CustomerID = ct.CustomerID
CROSS JOIN 
    AverageSpent avg 
WHERE 
    ct.TotalSpent > avg.AvgSpent
ORDER BY 
    ct.TotalSpent DESC;

-- Запрос для клиентов с наибольшей суммарной стоимостью

WITH RankedCustomers AS (
    SELECT 
        c.FirstName, 
        c.LastName, 
        SUM(o.TotalAmount) AS TotalSpent
    FROM 
        Customers c
    JOIN 
        Orders o ON c.CustomerID = o.CustomerID
    GROUP BY 
        c.CustomerID
    ORDER BY 
        TotalSpent DESC
)
SELECT * FROM RankedCustomers 
LIMIT 1;

-- Список заказов клиента с наибольшей суммарной стоимостью

WITH MaxSpentCustomer AS (
    SELECT 
        c.CustomerID
    FROM 
        Customers c
    JOIN 
        Orders o ON c.CustomerID = o.CustomerID
    GROUP BY 
        c.CustomerID
    ORDER BY 
        SUM(o.TotalAmount) DESC
    LIMIT 1
)
SELECT 
    o.OrderID, 
    o.TotalAmount 
FROM 
    Orders o
JOIN 
    MaxSpentCustomer m ON o.CustomerID = m.CustomerID
ORDER BY 
    o.TotalAmount ASC;