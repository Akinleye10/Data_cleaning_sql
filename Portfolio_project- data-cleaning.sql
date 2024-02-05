SELECT *
FROM Portfolio_Project.. NASHVILLE_HOUSING


--STANDARDIZING DATE FORMAT

SELECT SaleDate, CONVERT(date, SaleDate)
FROM Portfolio_Project.. NASHVILLE_HOUSING

UPDATE Portfolio_Project.. NASHVILLE_HOUSING
SET SaleDate =  CONVERT(date, SaleDate)



SELECT SaleDate
FROM Portfolio_Project.. NASHVILLE_HOUSING

ALTER TABLE NASHVILLE_HOUSING
ADD salesDateConverted Date

UPDATE Portfolio_Project.. NASHVILLE_HOUSING
SET salesDateConverted =  CONVERT(date, SaleDate)


SELECT salesDateConverted
FROM Portfolio_Project.. NASHVILLE_HOUSING

--Populate property address data

SELECT *
FROM Portfolio_Project.. NASHVILLE_HOUSING
-- PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolio_Project.. NASHVILLE_HOUSING a
join Portfolio_Project.. NASHVILLE_HOUSING b
on a. ParcelID = b. ParcelID
and a. [UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolio_Project.. NASHVILLE_HOUSING a
join Portfolio_Project.. NASHVILLE_HOUSING b
on a. ParcelID = b. ParcelID
and a. [UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--breaking out the address into individual colunms(address, city, state)

select PropertyAddress
from Portfolio_Project..NASHVILLE_HOUSING

--using a substring to break the propertyaddress down into colunms(address, city, state)
select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as address, 
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

from Portfolio_Project..NASHVILLE_HOUSING

ALTER TABLE NASHVILLE_HOUSING
ADD PropertySPlitAddress nvarchar(225)


ALTER TABLE NASHVILLE_HOUSING
ADD PropertySPlitCity nvarchar(225)

update NASHVILLE_HOUSING
set PropertySPlitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) 

update NASHVILLE_HOUSING
set PropertySPlitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select *
from NASHVILLE_HOUSING

select OwnerAddress
from  NASHVILLE_HOUSING
-- the function PARSENAME LOOKS FOR PERIOD(.)
select 
PARSENAME(replace(OwnerAddress,',','.'), 3),
PARSENAME(replace(OwnerAddress,',','.'), 2),
PARSENAME(replace(OwnerAddress,',','.'), 1)
from NASHVILLE_HOUSING


ALTER TABLE NASHVILLE_HOUSING

ADD OwnerSplitAddress nvarchar(225)

ALTER TABLE NASHVILLE_HOUSING

ADD OwnerSplitCity nvarchar(225)

ALTER TABLE NASHVILLE_HOUSING

ADD OwnerSplitState nvarchar(225)


update NASHVILLE_HOUSING
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'), 3)

update NASHVILLE_HOUSING
set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'), 2)

update NASHVILLE_HOUSING
set  OwnerSplitState= PARSENAME(replace(OwnerAddress,',','.'), 1)


SELECT SoldAsVacant, COUNT( SoldAsVacant) AS CountSoldAsVacant
FROM NASHVILLE_HOUSING
GROUP BY SoldAsVacant

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
    when SoldAsVacant  = 'N' then 'No'
	
	else SoldAsVacant
	end
FROM NASHVILLE_HOUSING

update NASHVILLE_HOUSING

set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
    when SoldAsVacant  = 'N' then 'No'
	when SoldAsVacant  = ' No' then 'No'
	else SoldAsVacant
	end
FROM NASHVILLE_HOUSING

--REMOVING DUPLICATES

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, LegalReference ORDER BY UniqueID) AS RowNum
    FROM NASHVILLE_HOUSING
)

SELECT * 
FROM RowNumCTE
WHERE  RowNum > 1
ORDER BY PropertyAddress






SELECT *
from Portfolio_Project..NASHVILLE_HOUSING

ALTER TABLE NASHVILLE_HOUSING
drop column Taxdistrict, OwnerAddress, PropertyAddress, SaleDate





