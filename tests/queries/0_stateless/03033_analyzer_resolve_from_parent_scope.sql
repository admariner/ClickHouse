CREATE TABLE vecs_Float32 (v Array(Float32)) ENGINE=Memory;
INSERT INTO vecs_Float32
SELECT v FROM (
    SELECT
        number AS n,
        [
                    rand(n*10), rand(n*10+1), rand(n*10+2), rand(n*10+3), rand(n*10+4), rand(n*10+5), rand(n*10+6), rand(n*10+7), rand(n*10+8), rand(n*10+9),
                    rand(n*10+10), rand(n*10+11), rand(n*10+12), rand(n*10+13), rand(n*10+14), rand(n*10+15), rand(n*10+16), rand(n*10+17), rand(n*10+18), rand(n*10+19),
                    rand(n*10+20), rand(n*10+21), rand(n*10+22), rand(n*10+23), rand(n*10+24), rand(n*10+25), rand(n*10+26), rand(n*10+27), rand(n*10+28), rand(n*10+29),
                    rand(n*10+30), rand(n*10+31), rand(n*10+32), rand(n*10+33), rand(n*10+34), rand(n*10+35), rand(n*10+36), rand(n*10+37), rand(n*10+38), rand(n*10+39),
                    rand(n*10+40), rand(n*10+41), rand(n*10+42), rand(n*10+43), rand(n*10+44), rand(n*10+45), rand(n*10+46), rand(n*10+47), rand(n*10+48), rand(n*10+49),
                    rand(n*10+50), rand(n*10+51), rand(n*10+52), rand(n*10+53), rand(n*10+54), rand(n*10+55), rand(n*10+56), rand(n*10+57), rand(n*10+58), rand(n*10+59),
                    rand(n*10+60), rand(n*10+61), rand(n*10+62), rand(n*10+63), rand(n*10+64), rand(n*10+65), rand(n*10+66), rand(n*10+67), rand(n*10+68), rand(n*10+69),
                    rand(n*10+70), rand(n*10+71), rand(n*10+72), rand(n*10+73), rand(n*10+74), rand(n*10+75), rand(n*10+76), rand(n*10+77), rand(n*10+78), rand(n*10+79),
                    rand(n*10+80), rand(n*10+81), rand(n*10+82), rand(n*10+83), rand(n*10+84), rand(n*10+85), rand(n*10+86), rand(n*10+87), rand(n*10+88), rand(n*10+89),
                    rand(n*10+90), rand(n*10+91), rand(n*10+92), rand(n*10+93), rand(n*10+94), rand(n*10+95), rand(n*10+96), rand(n*10+97), rand(n*10+98), rand(n*10+99),
                    rand(n*10+100), rand(n*10+101), rand(n*10+102), rand(n*10+103), rand(n*10+104), rand(n*10+105), rand(n*10+106), rand(n*10+107), rand(n*10+108), rand(n*10+109),
                    rand(n*10+110), rand(n*10+111), rand(n*10+112), rand(n*10+113), rand(n*10+114), rand(n*10+115), rand(n*10+116), rand(n*10+117), rand(n*10+118), rand(n*10+119),
                    rand(n*10+120), rand(n*10+121), rand(n*10+122), rand(n*10+123), rand(n*10+124), rand(n*10+125), rand(n*10+126), rand(n*10+127), rand(n*10+128), rand(n*10+129),
                    rand(n*10+130), rand(n*10+131), rand(n*10+132), rand(n*10+133), rand(n*10+134), rand(n*10+135), rand(n*10+136), rand(n*10+137), rand(n*10+138), rand(n*10+139),
                    rand(n*10+140), rand(n*10+141), rand(n*10+142), rand(n*10+143), rand(n*10+144), rand(n*10+145), rand(n*10+146), rand(n*10+147), rand(n*10+148), rand(n*10+149)
        ] AS v
        FROM system.numbers
        LIMIT 10
);

WITH (SELECT v FROM vecs_Float32 limit 1) AS a SELECT count(dp) FROM (SELECT dotProduct(a, v) AS dp FROM vecs_Float32);

WITH
  t as (SELECT number + a as x FROM numbers(5))
SELECT 0 as a, x FROM t
UNION ALL
SELECT 5 as a, x FROM t
ORDER BY a, x
FORMAT Null
SETTINGS enable_analyzer = 1;

WITH t AS
    (
        SELECT number + a AS x
        FROM numbers(5)
    )
SELECT *
FROM
(
    SELECT
        0 AS a,
        x
    FROM t
    UNION ALL
    SELECT
        5 AS a,
        x
    FROM t
)
ORDER BY
    a ASC,
    x ASC
SETTINGS enable_analyzer = 1;
