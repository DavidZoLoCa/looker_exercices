SELECT
    (DATE(orders_order."delivery_date" )),
    SUM(orders_orderitem."data_weight_ordered_kg" ) 
    AS Total_Commandes,
    SUM( case when (orders_orderitem."status") = 'accepted' 
    then (orders_orderitem."data_weight_ordered_kg")else null end ) 
    AS Total_Commandes_Validées,
    SUM(orders_orderitem."data_weight_ordered_kg" ) - 
    SUM( case when (orders_orderitem."status") = 'accepted' 
    then (orders_orderitem."data_weight_ordered_kg")else null end ) 
    AS differences
FROM public.orders_orderitem 
LEFT JOIN public.orders_order 
ON (orders_order."id") = (orders_orderitem."order_id")
LEFT JOIN public.actors_buyercompany 
ON (orders_orderitem."buyer_company_id") = (actors_buyercompany."id")
WHERE (orders_order."delivery_date" ) >= (TIMESTAMP '2021-09-13') 
AND (actors_buyercompany."id" ) 
IN (17, 335, 336, 337, 338, 340, 371, 394, 466, 467, 468, 469, 470, 471, 472, 473, 474,
 476, 477, 479, 480, 481, 482, 483, 484, 485, 487, 488, 489, 491) 
AND ((orders_orderitem."ecosystem_id") != 1 )
GROUP BY
    1


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

On cherche a avoir :
- le nom des magasins 
- le poids confirmé sur la semaine 
- le poids commandé sur la semaine 
- un affichage par jour de livraison 
- la difference entre le commandé et le confirmé


Noms magasin :
SELECT name
FROM public.actors_buyercompany
GROUP BY 1
ORDER BY NAME;

Poids condirmé :
SELECT SUM( case when (orders_orderitem."status") = 'accepted' 
    then (orders_orderitem."data_weight_ordered_kg")else null end ) AS Total_Commandes_Validées
FROM orders_orderitem;

Poids commandé :
SELECT SUM(orders_orderitem."data_weight_ordered_kg" ) AS Total_Commandes
FROM orders_orderitem;

Affichage par jour de livraison
SELECT delivery_date
    AS date_de_livraison 
FROM orders_orderitem;

Difference :
WITH sub_query AS (SELECT SUM( case when (orders_orderitem."status") = 'accepted' 
    then (orders_orderitem."data_weight_ordered_kg")else null end ) AS Total_Commandes_Validées, 
    SUM(orders_orderitem."data_weight_ordered_kg" ) AS Total_Commandes
    FROM public.orders_orderitem)
  SELECT* , Total_Commandes - Total_Commandes_Validées AS Difference from sub_query;



