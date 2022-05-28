-- POSTGRESQL SCRIPTS TO CREATE INTERMEDIATE VIEWS

-- Define active_products: active products as those with at least 1 rating in 2017
-- Gives a subset of the product table 
CREATE VIEW active_products AS(
    SELECT DISTINCT p.item_id, p.title, p.brand, p.main_cat, p.price
	 FROM product p, ratings r
	 WHERE p.item_id = r.item_id
	 	and EXTRACT(YEAR from r.date) = 2017
        and p.main_cat NOT LIKE '%img src%')

-- Define active_product_total_ratings: intermediate view to add up total ratings for active products
CREATE VIEW active_product_total_ratings AS(
    SELECT ap.item_id, ap.title, ap.brand, ap.main_cat, ap.price, COUNT(*) as total_ratings
    FROM active_products ap, ratings r
	WHERE ap.item_id = r.item_id
    GROUP BY ap.item_id, ap.title, ap.brand, ap.main_cat, ap.price)

-- Define analysis_table: combined dataset of chosen 'bad' and 'good' brands
-- Include positive / negative / neutral sentiment
-- Include tag for brand
-- Bad Brands: mpow|yks|aukey|ravpower|taotronics|sunvalley|choetech|kaloxi|homasy|homtech|vtin|tomtop|hootoo|seneo|victsing|omorc
----- Bad Brands no transactions: kaloxi, homasy, homtech (taken out)

CREATE VIEW analysis_table AS(
    SELECT r.item_id, r.user_id, r.rating, r.date, aptr.title, aptr.brand,
        CASE 
        WHEN r.rating IN (4, 5) THEN 'positive'
        WHEN r.rating = 3 THEN 'neutral'
        WHEN r.rating IN (1, 2) THEN 'negative'
        END as sentiment,
        CASE
        WHEN LOWER(aptr.brand) SIMILAR TO '%(mpow|yks|aukey|ravpower|taotronics|sunvalley|choetech|homasy|vtin|tomtop|hootoo|seneo|victsing|vogek|letscom|amzdeal|omorc)%' THEN 1 ELSE 0 END AS banned
    FROM ratings r, active_product_total_ratings aptr
    WHERE r.item_id = aptr.item_id 
    AND LOWER(aptr.brand) SIMILAR TO '%(mpow|yks|aukey|ravpower|taotronics|sunvalley|choetech|homasy|vtin|tomtop|hootoo|seneo|victsing|vogek|letscom|amzdeal|omorc|anker|belkin|mophie|zendure|native union|comsoon|ugreen|startech|poweradd|skullcandy|jvc|doss|iflash|qualgear|cablejive|mopar|optimal shop|coolead|vidpro|mfj|kinesis|caldigit|ezopower|nextec|lenovo|jabees|loctek|dxg|impecca|tera grand|1more|lenspen|ablegrid|tzumi|reshow|vakoo|optoma|benewy|gechic|bubm|tyt|avantree|zacro|yetor|suptek|jexon|jooan|cablegeeker|orico|enermax|vackoey|ancwear|weme|seagate|crucial|cisco|tenvis|powerextra|yamaha audio|elsse|kingston|tranesca|syncwire|gmyle|chuwi|mohoo|gw security inc|golf buddy|high sierra|cerwin-vega|ipazzport|evercool|hyperx|koolertron|ritz camera|tensun|lowpricenice|neutab|deego|litefuze|fitueyes|naxa electronics|power acoustik|vivo|macally|audioquest|elobeth|supersonic|sto-fen|mount factory|rcaw9|omnimount|eweton|phiaton|digitnow|syba|nuvur|sirui|nekteck|fospower|braven|solomark|totalmount|cryorig|engenius|steklo|juyoon|tokina|dtech|loverpi|khomo|keen eye|rnd)%' 
    AND LOWER(brand) NOT LIKE '%ipad%'
    AND (brand NOT IN ('IPCamPower', 'Tanker', 'Afranker', 'Afranker Cases', 'Afrankerr', 'Turandoss', 'CiDoss', 'Enrock JVC Scosche', 'STARTECH.COM', 'pioneer-JVC')) --redundant, edited data pull directly 
)