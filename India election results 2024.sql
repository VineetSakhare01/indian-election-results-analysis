USE indian_election_results;

CREATE TABLE IF NOT EXISTS statewise_results(	
			Constituency VARCHAR(50),
            Const_no int,
            Parliament_constituency VARCHAR(50),
            Leading_Candidate VARCHAR(100),
            Trailing_candidate VARCHAR(50),
            Margin INT,
            Status VARCHAR(50),
            State_id VARCHAR(50),
            State VARCHAR(50)
            );
			
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/statewise_results.csv"
INTO TABLE statewise_results
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * 
FROM statewise_results;

-- 1. Total Seats 

SELECT COUNT("Parliament Constituency") AS Total_Seats
FROM constituencywise_results;

-- 2. What is the total number of seats available for elections in each state

SELECT COUNT(DISTINCT `Parliament Constituency`) AS Total_Seats, states.State AS State
FROM constituencywise_results
JOIN statewise_results ON constituencywise_results.`Parliament Constituency` = statewise_results.Parliament_constituency
JOIN states ON statewise_results.State_id = states.`State ID`
GROUP BY states.State;

-- 3. Total Seats won by NDA Alliance

SELECT 
    SUM(CASE WHEN Party IN ('Bharatiya Janata Party - BJP' , 'Telugu Desam - TDP',
                'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS',
                'AJSU Party - AJSUP',
                'Apna Dal (Soneylal) - ADAL',
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS',
                'Janasena Party - JnP',
                'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV',
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD',
                'Sikkim Krantikari Morcha - SKM')
        THEN Won
        ELSE 0
    END) AS NDA_Total_Seats_Won
FROM partywise_results;


-- 4. Seats Won by NDA Alliance Parties

SELECT Party as Party_Name, Won as Seats_Won FROM partywise_results
WHERE Party IN (
        'Bharatiya Janata Party - BJP', 
        'Telugu Desam - TDP', 
		'Janata Dal  (United) - JD(U)',
        'Shiv Sena - SHS', 
        'AJSU Party - AJSUP', 
        'Apna Dal (Soneylal) - ADAL', 
        'Asom Gana Parishad - AGP',
        'Hindustani Awam Morcha (Secular) - HAMS', 
        'Janasena Party - JnP', 
		'Janata Dal  (Secular) - JD(S)',
        'Lok Janshakti Party(Ram Vilas) - LJPRV', 
        'Nationalist Congress Party - NCP',
        'Rashtriya Lok Dal - RLD', 
        'Sikkim Krantikari Morcha - SKM')
ORDER BY Seats_Won DESC;


-- 5. Total Seats Won by I.N.D.I.A, Alliance

SELECT SUM(CASE WHEN Party IN (
                'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
            ) THEN Won
            ELSE 0 
        END) AS INDIA_Total_Seats_Won
FROM partywise_results;

-- 6. Seats Won by I.N.D.I.A. Alliance Parties

SELECT Party as Party_Name, Won as Seats_Won
FROM partywise_results
WHERE Party IN ('Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK')
ORDER BY Seats_Won DESC;

-- 7. Add new column field in table partywise_results to get the Party Allianz as NDA, INDIA and OTHER

ALTER TABLE partywise_results
ADD party_alliance VARCHAR(50);

UPDATE partywise_results
SET party_alliance = 'I.N.D.I.A'
WHERE party IN ('Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',	
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK'
);

SET SQL_SAFE_UPDATES = 0;


UPDATE  partywise_results
SET party_alliance = 'NDA'
WHERE party IN (
    'Bharatiya Janata Party - BJP',
    'Telugu Desam - TDP',
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS',
    'AJSU Party - AJSUP',
    'Apna Dal (Soneylal) - ADAL',
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP',
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV',
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD',
    'Sikkim Krantikari Morcha - SKM'
);


UPDATE partywise_results
SET party_alliance = 'OTHER'
WHERE party_alliance IS NULL;


-- 8. Which party alliance (NDA, I.N.D.I.A, or OTHER) won the most seats across all states ?

SELECT pr.party_alliance , COUNT( "Parliament Constituency") AS Seats_won
FROM partywise_results pr
JOIN constituencywise_results cr ON pr.`Party ID` = cr.`Party ID`
GROUP BY pr.party_alliance
ORDER BY Seats_won DESC;

-- 9. Winning candidate's name, their party name, total votes, and the margin of victory for a specific state and constituency?

SELECT cr.`Winning Candidate`, p.Party, p.party_alliance ,cr.`Total Votes`, cr.Margin, cr.`Constituency Name`, s.State
FROM constituencywise_results cr
JOIN partywise_results p ON cr.`Party ID` = p.`Party ID`
JOIN statewise_results sr ON cr.`Parliament Constituency` = sr.Parliament_constituency
JOIN states s ON sr.State_id = s.`State ID`
WHERE s.State = 'Maharashtra' AND cr.`Constituency Name` = 'NASHIK'
LIMIT 1;


-- 10. What is the distribution of EVM votes versus postal votes for candidates in a specific constituency?

SELECT cd.Candidate , cd.Party , cr.`Constituency Name` , cd.`EVM Votes` , cd.`Postal Votes`, cd.`Total Votes`
FROM constituencywise_details cd
JOIN constituencywise_results cr ON cd.`Constituency ID` = cr.`Constituency ID`
WHERE cr.`Constituency Name` = 'KALYAN'
ORDER BY cd.`Total Votes` DESC;

-- 11. Which parties won the most seats in a State, and how many seats did each party win?

SELECT p.Party , p.party_alliance , s.State , COUNT(DISTINCT cr.`Constituency ID`)  AS Seats_won
FROM partywise_results p
JOIN constituencywise_results cr ON p.`Party ID` = cr.`Party ID`
JOIN statewise_results sr ON cr.`Parliament Constituency` = sr.Parliament_constituency
JOIN states s ON sr.State_id = s.`State ID`
WHERE s.State = 'Maharashtra'
GROUP BY p.Party , p.Won , p.party_alliance , s.State
ORDER BY Seats_won DESC;

-- 12. What is the total number of seats won by each party alliance (NDA, I.N.D.I.A, and OTHER) in each state for the India Elections 2024 ?

USE indian_election_results;

SELECT s.State,
		COUNT(DISTINCT CASE WHEN p.party_alliance = 'NDA' THEN cr.`Parliament Constituency` END) AS NDA_Seats_Won,
        COUNT(DISTINCT CASE WHEN p.party_alliance = 'I.N.D.I.A' THEN cr.`Parliament Constituency` END) AS INDIA_Seats_Won,
		COUNT(DISTINCT CASE WHEN p.party_alliance = 'OTHER' THEN cr.`Parliament Constituency` END) AS OTHER_Seats_Won
FROM constituencywise_results cr
JOIN partywise_results p ON cr.`Party ID` = p.`Party ID`
JOIN statewise_results sr ON cr.`Parliament Constituency` = sr.Parliament_constituency
JOIN states s ON sr.State_id = s.`State ID`
GROUP BY s.State;

-- 13. Which candidate received the highest number of EVM votes in each constituency (Top 10)?

SELECT cd.Candidate, cd.`EVM Votes` AS EVM_Votes , cr.`Constituency Name`
FROM constituencywise_details cd
JOIN constituencywise_results cr ON cd.`Constituency ID` =  cr.`Constituency ID`
WHERE cd.`EVM Votes` = ( SELECT MAX(cd1.`EVM Votes`) 
						 FROM constituencywise_details cd1
						 WHERE cd1.`Constituency ID` = cd.`Constituency ID`)
ORDER BY EVM_Votes DESC
LIMIT 10;

-- 14. Which candidate won and which candidate was the runner-up in each constituency of State for the 2024 elections?

WITH RankedCandidates AS (
    SELECT 
        cd.`Constituency ID`,
        cd.Candidate,
        cd.Party,
        cd.`EVM Votes`,
        cd.`Postal Votes`,
        cd.`EVM Votes` + cd.`Postal Votes` AS Total_Votes,
        ROW_NUMBER() OVER (PARTITION BY cd.`Constituency ID` ORDER BY cd.`EVM Votes` + cd.`Postal Votes` DESC) AS VoteRank
    FROM constituencywise_details cd
    JOIN constituencywise_results cr ON cd.`Constituency ID` = cr.`Constituency ID`
	JOIN statewise_results sr ON cr.`Parliament Constituency` = sr.Parliament_constituency
	JOIN states s ON sr.State_id = s.`State ID`
    WHERE s.State = 'Maharashtra'
)

SELECT 
    cr.`Constituency Name`,
    MAX(CASE WHEN rc.VoteRank = 1 THEN rc.Candidate END) AS Winning_Candidate,
    MAX(CASE WHEN rc.VoteRank = 2 THEN rc.Candidate END) AS Runnerup_Candidate
FROM RankedCandidates rc
JOIN constituencywise_results cr ON rc.`Constituency ID` = cr.`Constituency ID`
GROUP BY cr.`Constituency Name`
ORDER BY cr.`Constituency Name`;


-- 15. For the state of Maharashtra, what are the total number of seats, total number of candidates,       
-- total number of parties, total votes (including EVM and postal), and the breakdown of EVM and postal votes?


SELECT COUNT(DISTINCT cr.`Constituency ID`) AS Total_Seats,
	   COUNT(DISTINCT cd.Candidate) AS Total_Candidates,
	   COUNT(DISTINCT p.Party) AS Total_Parties,
       SUM(cd.`EVM Votes` + cd.`Postal Votes`) AS Total_Votes,
       SUM(cd.`EVM Votes`) AS Total_EVM_Votes,
       SUM(cd.`Postal Votes`) AS Total_Postal_Votes
FROM constituencywise_results cr
JOIN constituencywise_details cd ON cr.`Constituency ID` = cd.`Constituency ID`
JOIN statewise_results sr ON cr.`Parliament Constituency` = sr.Parliament_constituency
JOIN states s ON sr.State_id = s.`State ID`
JOIN partywise_results p ON cr.`Party ID` = p.`Party ID`
WHERE s.State = 'Maharashtra';






























