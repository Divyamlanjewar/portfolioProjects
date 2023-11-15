select *from portfolio..Nashvillehousing
------------------------------------------
--standardise data format

select saledateconverted,convert(date,saledate)
from portfolio..Nashvillehousing

update portfolio..Nashvillehousing
set saledate=convert(date,saledate)

use portfolio
alter table nashvillehousing
add saledataconverted date;

update Nashvillehousing
set saledateconverted=convert(date,saledate);

---------------------------------------
--property address data

select * 
from portfolio..Nashvillehousing
order by parcelID
--where PropertyAddress is null



select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.propertyaddress,b.PropertyAddress)
from portfolio..Nashvillehousing a
join portfolio..Nashvillehousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.propertyaddress is null



update a
set PropertyAddress=isnull(a.propertyaddress,b.propertyaddress)
from portfolio..Nashvillehousing a
join portfolio..Nashvillehousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


-------------------------------------------------------------
--breaking out address into individual column (address,city,states)
select propertyaddress
from portfolio..Nashvillehousing
--where propertyaddress is null
--order by parcelId

select
substring(propertyaddress,1,charindex(',',propertyaddress)-1) as address
,substring(propertyaddress,charindex(',',propertyaddress) +1,len(PropertyAddress)) as address
from portfolio..Nashvillehousing

alter table nashvillehousing
add propertSplitaddress nvarchar(255);

update Nashvillehousing
set propertSplitaddress =SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)

use portfolio
alter table nashvillehousing
add propertySplitcity nvarchar(255);

update Nashvillehousing
set propertySplitcity=substring(propertyaddress,charindex(',',propertyaddress) +1,len(PropertyAddress))

SELECT * FROM portfolio..Nashvillehousing





------------------------------------------------------------------------------

SELECT OwnerAddress FROM portfolio..Nashvillehousing

SELECT
    PARSENAME(REPLACE(owneraddress, ',', '.'), 3) AS Part3,
    PARSENAME(REPLACE(owneraddress, ',', '.'), 2) AS Part2,
    PARSENAME(REPLACE(owneraddress, ',', '.'), 1) AS Part1
FROM portfolio..nashvillehousing;





alter table nashvillehousing
add ownerSplitaddress nvarchar(255);

update Nashvillehousing
set ownerSplitaddress =  PARSENAME(REPLACE(owneraddress, ',', '.'), 3) 

USE portfolio;

ALTER TABLE nashvillehousing
ADD ownersplitcity NVARCHAR(255);

UPDATE Nashvillehousing
SET ownersplitcity = PARSENAME(REPLACE(owneraddress, ',', '.'), 2);


ALTER TABLE nashvillehousing
ADD ownersplitstate NVARCHAR(255);

UPDATE Nashvillehousing
SET ownersplitstate = PARSENAME(REPLACE(owneraddress, ',', '.'), 2);


select * from portfolio..Nashvillehousing

-----------------------------------------------------------------------------------------------------------
--change Y and N to yes or no in "sold as vacant" field

select distinct(SoldAsVacant),count(SoldAsVacant)from
portfolio..Nashvillehousing
group by SoldAsVacant
order by 2

USE portfolio;

SELECT SoldAsVacant,
  CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
  END
FROM portfolio..Nashvillehousing;

update Nashvillehousing
set SoldAsVacant= CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
  END

--------------------------------------------------------------------------------------
----remove duplicates
with rownumCTE as(
select *,
row_number() over(
partition by parcelid,
propertyaddress,saleprice,
saledate,legalreference
order by uniqueID) row_num
from portfolio..Nashvillehousing
--order by ParcelID
)select * from rownumCTE
where row_num > 1
order by PropertyAddress

--------------------------------------------------------------------------------------------------

--delete unused coloumns
select * from portfolio..Nashvillehousing

alter table portfolio..Nashvillehousing
drop column owneraddress,taxdistrict,propertyaddress


alter table portfolio..Nashvillehousing
drop column saledate


--------------------------------------------------------------ThankYou!!----------------------------------------------------------------------------