SELECT COUNT(*) FROM transactions AS t WHERE LENGTH(t.data) > 80;

SELECT t.block_index, datetime(t.block_time, 'unixepoch'), t.tx_hash, LENGTH(t.data), 
CASE WHEN i.tx_index IS NOT NULL THEN "issuance" ELSE 
    CASE WHEN rps.tx_index IS NOT NULL THEN "rps" ELSE
        CASE WHEN rpsr.tx_index IS NOT NULL THEN "rpsresolve" ELSE
            CASE WHEN b.tx_index IS NOT NULL THEN "broadcast" ELSE "unknown" END
        END
    END
END
FROM transactions AS t
LEFT JOIN issuances AS i ON i.tx_index = t.tx_index
LEFT JOIN broadcasts AS b ON b.tx_index = t.tx_index
LEFT JOIN rps AS rps ON rps.tx_index = t.tx_index
LEFT JOIN rpsresolves AS rpsr ON rpsr.tx_index = t.tx_index
WHERE LENGTH(t.data) > 80
ORDER BY t.block_index DESC;

SELECT CASE WHEN i.tx_index IS NOT NULL THEN "issuance" ELSE 
    CASE WHEN rps.tx_index IS NOT NULL THEN "rps" ELSE
        CASE WHEN rpsr.tx_index IS NOT NULL THEN "rpsresolve" ELSE
            CASE WHEN b.tx_index IS NOT NULL THEN "broadcast" ELSE "unknown" END
        END
    END
END, COUNT(*)
FROM transactions AS t
LEFT JOIN issuances AS i ON i.tx_index = t.tx_index
LEFT JOIN broadcasts AS b ON b.tx_index = t.tx_index
LEFT JOIN rps AS rps ON rps.tx_index = t.tx_index
LEFT JOIN rpsresolves AS rpsr ON rpsr.tx_index = t.tx_index
WHERE LENGTH(t.data) > 80
GROUP BY CASE WHEN i.tx_index IS NOT NULL THEN "issuance" ELSE 
    CASE WHEN rps.tx_index IS NOT NULL THEN "rps" ELSE
        CASE WHEN rpsr.tx_index IS NOT NULL THEN "rpsresolve" ELSE
            CASE WHEN b.tx_index IS NOT NULL THEN "broadcast" ELSE "unknown" END
        END
    END
END;

SELECT CASE WHEN i.tx_index IS NOT NULL THEN "issuance" ELSE 
    CASE WHEN b.tx_index IS NOT NULL THEN "broadcast" ELSE 
        CASE WHEN o.tx_index IS NOT NULL THEN "orders" ELSE 
            CASE WHEN s.tx_index IS NOT NULL THEN "send" ELSE "unknown" END
        END
    END
END, COUNT(*)
FROM transactions AS t
LEFT JOIN issuances AS i ON i.tx_index = t.tx_index
LEFT JOIN broadcasts AS b ON b.tx_index = t.tx_index
LEFT JOIN sends AS s ON s.tx_index = t.tx_index
LEFT JOIN orders AS o ON o.tx_index = t.tx_index
GROUP BY CASE WHEN i.tx_index IS NOT NULL THEN "issuance" ELSE 
    CASE WHEN b.tx_index IS NOT NULL THEN "broadcast" ELSE 
        CASE WHEN o.tx_index IS NOT NULL THEN "orders" ELSE 
            CASE WHEN s.tx_index IS NOT NULL THEN "send" ELSE "unknown" END
        END
    END
END;
