-- 分数相同时名次相同，名次连续排列。
你十分精通sql，请你详细地向我解释这段代码，谢谢
SELECT
    t1.Score as Score,
    (
        SELECT
            -- 统计有多少个不同的分数，理解为求出一共有多少个名次
            COUNT(DISTINCT t2.Score)
        FROM Scores t2
        WHERE t2.Score >= t1.Score
    ) AS `Rank`
FROM Scores t1
ORDER BY t1.Score DESC